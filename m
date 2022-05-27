Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71FFAC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 27 May 2022 16:37:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347221AbiE0QhH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 27 May 2022 12:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231706AbiE0QfE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2022 12:35:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA123B2AE
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 09:35:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4B09B825AE
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 16:35:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E7CBC385A9;
        Fri, 27 May 2022 16:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653669300;
        bh=1HBa8A4QXXOTaLcYPP3NZD95LqShJzoMe/ZjNtWFMJk=;
        h=Date:To:From:Subject:From;
        b=MhlYukSu8+DY2u43mOA4rEtsrMA0Yx4VI+VcP+J48OtPkMP2guIC0s7mgUSZH/Ift
         ks+8p5728vQa1wGFdMj1g2HFZNAigb375HzcpgkcQREpB3NoCtGtl5nI5sIeqzqN60
         glji2uEXkofglCx4gLCdBWWDHR4ZrEdDSKBm6gHY=
Date:   Fri, 27 May 2022 09:34:59 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-z3fold-fix-z3fold_reclaim_page-races-with-z3fold_free.patch removed from -mm tree
Message-Id: <20220527163500.7E7CBC385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/z3fold: fix z3fold_reclaim_page races with z3fold_free
has been removed from the -mm tree.  Its filename was
     mm-z3fold-fix-z3fold_reclaim_page-races-with-z3fold_free.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/z3fold: fix z3fold_reclaim_page races with z3fold_free
Date: Fri, 29 Apr 2022 14:40:43 +0800

Think about the below scenario:

CPU1				CPU2
z3fold_reclaim_page		z3fold_free
 spin_lock(&pool->lock)		 get_z3fold_header -- hold page_lock
 kref_get_unless_zero
				 kref_put--zhdr->refcount can be 1 now
 !z3fold_page_trylock
  kref_put -- zhdr->refcount is 0 now
   release_z3fold_page
    WARN_ON(!list_empty(&zhdr->buddy)); -- we're on buddy now!
    spin_lock(&pool->lock); -- deadlock here!

z3fold_reclaim_page might race with z3fold_free and will lead to pool lock
deadlock and zhdr buddy non-empty warning.  To fix this, defer getting the
refcount until page_lock is held just like what __z3fold_alloc does.  Note
this has the side effect that we won't break the reclaim if we meet a soon
to be released z3fold page now.

Link: https://lkml.kernel.org/r/20220429064051.61552-9-linmiaohe@huawei.com
Fixes: dcf5aedb24f8 ("z3fold: stricter locking and more careful reclaim")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

--- a/mm/z3fold.c~mm-z3fold-fix-z3fold_reclaim_page-races-with-z3fold_free
+++ a/mm/z3fold.c
@@ -519,13 +519,6 @@ static void __release_z3fold_page(struct
 	atomic64_dec(&pool->pages_nr);
 }
 
-static void release_z3fold_page(struct kref *ref)
-{
-	struct z3fold_header *zhdr = container_of(ref, struct z3fold_header,
-						refcount);
-	__release_z3fold_page(zhdr, false);
-}
-
 static void release_z3fold_page_locked(struct kref *ref)
 {
 	struct z3fold_header *zhdr = container_of(ref, struct z3fold_header,
@@ -1317,12 +1310,7 @@ static int z3fold_reclaim_page(struct z3
 				break;
 			}
 
-			if (kref_get_unless_zero(&zhdr->refcount) == 0) {
-				zhdr = NULL;
-				break;
-			}
 			if (!z3fold_page_trylock(zhdr)) {
-				kref_put(&zhdr->refcount, release_z3fold_page);
 				zhdr = NULL;
 				continue; /* can't evict at this point */
 			}
@@ -1333,14 +1321,14 @@ static int z3fold_reclaim_page(struct z3
 			 */
 			if (zhdr->foreign_handles ||
 			    test_and_set_bit(PAGE_CLAIMED, &page->private)) {
-				if (!kref_put(&zhdr->refcount,
-						release_z3fold_page_locked))
-					z3fold_page_unlock(zhdr);
+				z3fold_page_unlock(zhdr);
 				zhdr = NULL;
 				continue; /* can't evict such page */
 			}
 			list_del_init(&zhdr->buddy);
 			zhdr->cpu = -1;
+			/* See comment in __z3fold_alloc. */
+			kref_get(&zhdr->refcount);
 			break;
 		}
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


