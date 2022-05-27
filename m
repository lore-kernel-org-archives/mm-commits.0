Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EE77C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 27 May 2022 16:37:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347485AbiE0QhE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 27 May 2022 12:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352516AbiE0QfB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2022 12:35:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A5873B2AE
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 09:35:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 085ED61DE6
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 16:35:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E32C385B8;
        Fri, 27 May 2022 16:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653669299;
        bh=Z8kDWUEY44aJW23jewWzSqzAHYtvis2mN6bVWe1KT5Q=;
        h=Date:To:From:Subject:From;
        b=B4OK5Ng4w/b6u3/vxM3ZZjRIQjda4bGJrxe2ZkyrW2/RdkFPZTwKbzeC1Zd7JX5Db
         cN0EtvPAsPQzqD8gvRaI6LTeQoJdfD0bLPf4/jxllsv69ofYUPBnD/tIMyJKPjLtp5
         WFylLDpnZMFb+BpeznrdyPk6SRMoyG1fV1xVscTs=
Date:   Fri, 27 May 2022 09:34:58 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-z3fold-always-clear-page_claimed-under-z3fold-page-lock.patch removed from -mm tree
Message-Id: <20220527163459.62E32C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/z3fold: always clear PAGE_CLAIMED under z3fold page lock
has been removed from the -mm tree.  Its filename was
     mm-z3fold-always-clear-page_claimed-under-z3fold-page-lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/z3fold: always clear PAGE_CLAIMED under z3fold page lock
Date: Fri, 29 Apr 2022 14:40:43 +0800

Think about the below race window:

CPU1				CPU2
z3fold_reclaim_page		z3fold_free
 test_and_set_bit PAGE_CLAIMED
 failed to reclaim page
 z3fold_page_lock(zhdr);
 add back to the lru list;
 z3fold_page_unlock(zhdr);
				 get_z3fold_header
				 page_claimed=test_and_set_bit PAGE_CLAIMED

 clear_bit(PAGE_CLAIMED, &page->private);

				 if (!page_claimed) /* it's false true */
				  free_handle is not called

free_handle won't be called in this case. So z3fold_buddy_slots will leak.
Fix it by always clear PAGE_CLAIMED under z3fold page lock.

Link: https://lkml.kernel.org/r/20220429064051.61552-8-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/z3fold.c~mm-z3fold-always-clear-page_claimed-under-z3fold-page-lock
+++ a/mm/z3fold.c
@@ -1221,8 +1221,8 @@ static void z3fold_free(struct z3fold_po
 		return;
 	}
 	if (test_and_set_bit(NEEDS_COMPACTING, &page->private)) {
-		put_z3fold_header(zhdr);
 		clear_bit(PAGE_CLAIMED, &page->private);
+		put_z3fold_header(zhdr);
 		return;
 	}
 	if (zhdr->cpu < 0 || !cpu_online(zhdr->cpu)) {
@@ -1424,8 +1424,8 @@ next:
 			spin_unlock(&pool->lock);
 			if (list_empty(&zhdr->buddy))
 				add_to_unbuddied(pool, zhdr);
-			z3fold_page_unlock(zhdr);
 			clear_bit(PAGE_CLAIMED, &page->private);
+			z3fold_page_unlock(zhdr);
 		}
 
 		/* We started off locked to we need to lock the pool back */
@@ -1577,8 +1577,8 @@ static int z3fold_page_migrate(struct ad
 	if (!z3fold_page_trylock(zhdr))
 		return -EAGAIN;
 	if (zhdr->mapped_count != 0 || zhdr->foreign_handles != 0) {
-		z3fold_page_unlock(zhdr);
 		clear_bit(PAGE_CLAIMED, &page->private);
+		z3fold_page_unlock(zhdr);
 		return -EBUSY;
 	}
 	if (work_pending(&zhdr->work)) {
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


