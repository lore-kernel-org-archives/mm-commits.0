Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDC43C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 07:04:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354852AbiD2HH4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 03:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354893AbiD2HHv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 03:07:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDCEDBE9C4
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 00:04:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67AFF61F68
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 07:04:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF20FC385A7;
        Fri, 29 Apr 2022 07:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651215873;
        bh=Wx9OBW1+eNtIO8vM0w82ieD0WoH+JFuNHuSDo9sKymY=;
        h=Date:To:From:Subject:From;
        b=RRdFVFeJafK6Ea4oMaqBbu+uMbtwSsysHIzJMBSnynmDCis+k1LP/LcmJlPS7jAtS
         9fqqSM9wUVbU7X1QKJllVSslYNpdoKM4Kt0VNLo8Tk0DAgaqCA3YzjXj7UDKQH34Hs
         Ert+XmVXQgsAR3a/czJqx70nTDMpL+cgRDQZEjhc=
Date:   Fri, 29 Apr 2022 00:04:33 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-z3fold-fix-z3fold_reclaim_page-races-with-z3fold_free.patch added to mm-unstable branch
Message-Id: <20220429070433.BF20FC385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/z3fold: fix z3fold_reclaim_page races with z3fold_free
has been added to the -mm mm-unstable branch.  Its filename is
     mm-z3fold-fix-z3fold_reclaim_page-races-with-z3fold_free.patch

This patch should soon appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/z3fold: fix z3fold_reclaim_page races with z3fold_free

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
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
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

mm-swapfile-unuse_pte-can-map-random-data-if-swap-read-fails.patch
mm-swapfile-fix-lost-swap-bits-in-unuse_pte.patch
mm-madvise-free-hwpoison-and-swapin-error-entry-in-madvise_free_pte_range.patch
mm-migration-reduce-the-rcu-lock-duration.patch
mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch
mm-migration-return-errno-when-isolate_huge_page-failed.patch
mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-vmscan-take-min_slab_pages-into-account-when-try-to-call-shrink_node.patch
mm-vmscan-add-a-comment-about-madv_free-pages-check-in-folio_check_dirty_writeback.patch
mm-vmscan-introduce-helper-function-reclaim_page_list.patch
mm-vmscan-take-all-base-pages-of-thp-into-account-when-race-with-speculative-reference.patch
mm-vmscan-remove-obsolete-comment-in-kswapd_run.patch
mm-vmscan-use-helper-folio_is_file_lru.patch
mm-vmscan-use-helper-folio_is_file_lru-fix.patch
mm-z3fold-fix-sheduling-while-atomic.patch
mm-z3fold-fix-possible-null-pointer-dereferencing.patch
mm-z3fold-remove-buggy-use-of-stale-list-for-allocation.patch
mm-z3fold-throw-warning-on-failure-of-trylock_page-in-z3fold_alloc.patch
revert-mm-z3foldc-allow-__gfp_highmem-in-z3fold_alloc.patch
mm-z3fold-put-z3fold-page-back-into-unbuddied-list-when-reclaim-or-migration-fails.patch
mm-z3fold-always-clear-page_claimed-under-z3fold-page-lock.patch
mm-z3fold-fix-z3fold_reclaim_page-races-with-z3fold_free.patch
mm-z3fold-fix-z3fold_page_migrate-races-with-z3fold_map.patch

