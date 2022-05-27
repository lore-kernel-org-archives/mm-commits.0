Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5AB2C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 27 May 2022 16:37:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349330AbiE0QhK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 27 May 2022 12:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354101AbiE0QfG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2022 12:35:06 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E15D13B2AE
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 09:35:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 51B30CE251B
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 16:35:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA86AC385B8;
        Fri, 27 May 2022 16:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653669301;
        bh=oBTnSSysZluk97OiWD3A1C6Scmu/Gh4FfRtTQ/W37KA=;
        h=Date:To:From:Subject:From;
        b=mFDFoCHqsE4GSF0cKSP0KXPj1WztnbA3paJoqD0c+p3JedKM8xEMf5BOwyi+Fl2Nb
         Drqv8hqZaadIV0tbeeu+OADyufBUkrO+rrws/W75VRVBDsotBa87Q5RKHDXJUApoPp
         0YxYXPDiPUGO25bNqFzkAq4LlZHOsGqZZYhhNHxY=
Date:   Fri, 27 May 2022 09:35:01 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-z3fold-fix-z3fold_page_migrate-races-with-z3fold_map.patch removed from -mm tree
Message-Id: <20220527163501.AA86AC385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/z3fold: fix z3fold_page_migrate races with z3fold_map
has been removed from the -mm tree.  Its filename was
     mm-z3fold-fix-z3fold_page_migrate-races-with-z3fold_map.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/z3fold: fix z3fold_page_migrate races with z3fold_map
Date: Fri, 29 Apr 2022 14:40:43 +0800

Think about the below scenario:

CPU1				CPU2
 z3fold_page_migrate		z3fold_map
  z3fold_page_trylock
  ...
  z3fold_page_unlock
  /* slots still points to old zhdr*/
				 get_z3fold_header
				  get slots from handle
				  get old zhdr from slots
				  z3fold_page_trylock
				  return *old* zhdr
  encode_handle(new_zhdr, FIRST|LAST|MIDDLE)
  put_page(page) /* zhdr is freed! */
				 but zhdr is still used by caller!

z3fold_map can map freed z3fold page and lead to use-after-free bug.  To
fix it, we add PAGE_MIGRATED to indicate z3fold page is migrated and soon
to be released.  So get_z3fold_header won't return such page.

Link: https://lkml.kernel.org/r/20220429064051.61552-10-linmiaohe@huawei.com
Fixes: 1f862989b04a ("mm/z3fold.c: support page migration")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/mm/z3fold.c~mm-z3fold-fix-z3fold_page_migrate-races-with-z3fold_map
+++ a/mm/z3fold.c
@@ -181,6 +181,7 @@ enum z3fold_page_flags {
 	NEEDS_COMPACTING,
 	PAGE_STALE,
 	PAGE_CLAIMED, /* by either reclaim or free */
+	PAGE_MIGRATED, /* page is migrated and soon to be released */
 };
 
 /*
@@ -270,8 +271,13 @@ static inline struct z3fold_header *get_
 			zhdr = (struct z3fold_header *)(addr & PAGE_MASK);
 			locked = z3fold_page_trylock(zhdr);
 			read_unlock(&slots->lock);
-			if (locked)
-				break;
+			if (locked) {
+				struct page *page = virt_to_page(zhdr);
+
+				if (!test_bit(PAGE_MIGRATED, &page->private))
+					break;
+				z3fold_page_unlock(zhdr);
+			}
 			cpu_relax();
 		} while (true);
 	} else {
@@ -389,6 +395,7 @@ static struct z3fold_header *init_z3fold
 	clear_bit(NEEDS_COMPACTING, &page->private);
 	clear_bit(PAGE_STALE, &page->private);
 	clear_bit(PAGE_CLAIMED, &page->private);
+	clear_bit(PAGE_MIGRATED, &page->private);
 	if (headless)
 		return zhdr;
 
@@ -1576,7 +1583,7 @@ static int z3fold_page_migrate(struct ad
 	new_zhdr = page_address(newpage);
 	memcpy(new_zhdr, zhdr, PAGE_SIZE);
 	newpage->private = page->private;
-	page->private = 0;
+	set_bit(PAGE_MIGRATED, &page->private);
 	z3fold_page_unlock(zhdr);
 	spin_lock_init(&new_zhdr->page_lock);
 	INIT_WORK(&new_zhdr->work, compact_page_work);
@@ -1606,7 +1613,8 @@ static int z3fold_page_migrate(struct ad
 
 	queue_work_on(new_zhdr->cpu, pool->compact_wq, &new_zhdr->work);
 
-	clear_bit(PAGE_CLAIMED, &page->private);
+	/* PAGE_CLAIMED and PAGE_MIGRATED are cleared now. */
+	page->private = 0;
 	put_page(page);
 	return 0;
 }
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


