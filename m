Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CF77C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:12:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234239AbiEJEQT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236035AbiEJEPn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:15:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570E91FA5F
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:11:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA088B81AF7
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:11:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC2AC385C2;
        Tue, 10 May 2022 04:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155877;
        bh=qakCimdLb74/EuIgi1IrgWH16P+QuT6eEcApJkV0CS4=;
        h=Date:To:From:Subject:From;
        b=LdCThAA3huMAFfl0unUjp3Gr7cqyNzFxtSuaizgI/FBLAuclHmF+DUOTh47oFqmYx
         DFYf7AW7oUnr68ZJoMVN1YSAUhIRS9c+IMwKado/SqzTluggVOaB5bM1oqSilX/Khi
         53DrAu5FNUEEFG0X3GkREdVKNkokj14azrjS8sDY=
Date:   Mon, 09 May 2022 21:11:16 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-z3fold-move-decrement-of-pool-pages_nr-into-__release_z3fold_page.patch removed from -mm tree
Message-Id: <20220510041117.5CC2AC385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/z3fold: move decrement of pool->pages_nr into __release_z3fold_page()
has been removed from the -mm tree.  Its filename was
     mm-z3fold-move-decrement-of-pool-pages_nr-into-__release_z3fold_page.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/z3fold: move decrement of pool->pages_nr into __release_z3fold_page()

The z3fold will always do atomic64_dec(&pool->pages_nr) when the
__release_z3fold_page() is called.  Thus we can move decrement of
pool->pages_nr into __release_z3fold_page() to simplify the code.

Also we can reduce the size of z3fold.o ~1k.

Without this patch:
   text	   data	    bss	    dec	    hex	filename
  15444	   1376	      8	  16828	   41bc	mm/z3fold.o
With this patch:
   text	   data	    bss	    dec	    hex	filename
  15044	   1248	      8	  16300	   3fac	mm/z3fold.o

Link: https://lkml.kernel.org/r/20220308134311.59086-7-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |   41 ++++++++++++-----------------------------
 1 file changed, 12 insertions(+), 29 deletions(-)

--- a/mm/z3fold.c~mm-z3fold-move-decrement-of-pool-pages_nr-into-__release_z3fold_page
+++ a/mm/z3fold.c
@@ -520,6 +520,8 @@ static void __release_z3fold_page(struct
 	list_add(&zhdr->buddy, &pool->stale);
 	queue_work(pool->release_wq, &pool->work);
 	spin_unlock(&pool->stale_lock);
+
+	atomic64_dec(&pool->pages_nr);
 }
 
 static void release_z3fold_page(struct kref *ref)
@@ -737,13 +739,9 @@ static struct z3fold_header *compact_sin
 	return new_zhdr;
 
 out_fail:
-	if (new_zhdr) {
-		if (kref_put(&new_zhdr->refcount, release_z3fold_page_locked))
-			atomic64_dec(&pool->pages_nr);
-		else {
-			add_to_unbuddied(pool, new_zhdr);
-			z3fold_page_unlock(new_zhdr);
-		}
+	if (new_zhdr && !kref_put(&new_zhdr->refcount, release_z3fold_page_locked)) {
+		add_to_unbuddied(pool, new_zhdr);
+		z3fold_page_unlock(new_zhdr);
 	}
 	return NULL;
 
@@ -816,10 +814,8 @@ static void do_compact_page(struct z3fol
 	list_del_init(&zhdr->buddy);
 	spin_unlock(&pool->lock);
 
-	if (kref_put(&zhdr->refcount, release_z3fold_page_locked)) {
-		atomic64_dec(&pool->pages_nr);
+	if (kref_put(&zhdr->refcount, release_z3fold_page_locked))
 		return;
-	}
 
 	if (test_bit(PAGE_STALE, &page->private) ||
 	    test_and_set_bit(PAGE_CLAIMED, &page->private)) {
@@ -829,9 +825,7 @@ static void do_compact_page(struct z3fol
 
 	if (!zhdr->foreign_handles && buddy_single(zhdr) &&
 	    zhdr->mapped_count == 0 && compact_single_buddy(zhdr)) {
-		if (kref_put(&zhdr->refcount, release_z3fold_page_locked))
-			atomic64_dec(&pool->pages_nr);
-		else {
+		if (!kref_put(&zhdr->refcount, release_z3fold_page_locked)) {
 			clear_bit(PAGE_CLAIMED, &page->private);
 			z3fold_page_unlock(zhdr);
 		}
@@ -1089,10 +1083,8 @@ retry:
 		if (zhdr) {
 			bud = get_free_buddy(zhdr, chunks);
 			if (bud == HEADLESS) {
-				if (kref_put(&zhdr->refcount,
+				if (!kref_put(&zhdr->refcount,
 					     release_z3fold_page_locked))
-					atomic64_dec(&pool->pages_nr);
-				else
 					z3fold_page_unlock(zhdr);
 				pr_err("No free chunks in unbuddied\n");
 				WARN_ON(1);
@@ -1239,10 +1231,8 @@ static void z3fold_free(struct z3fold_po
 
 	if (!page_claimed)
 		free_handle(handle, zhdr);
-	if (kref_put(&zhdr->refcount, release_z3fold_page_locked_list)) {
-		atomic64_dec(&pool->pages_nr);
+	if (kref_put(&zhdr->refcount, release_z3fold_page_locked_list))
 		return;
-	}
 	if (page_claimed) {
 		/* the page has not been claimed by us */
 		put_z3fold_header(zhdr);
@@ -1353,9 +1343,7 @@ static int z3fold_reclaim_page(struct z3
 				break;
 			}
 			if (!z3fold_page_trylock(zhdr)) {
-				if (kref_put(&zhdr->refcount,
-						release_z3fold_page))
-					atomic64_dec(&pool->pages_nr);
+				kref_put(&zhdr->refcount, release_z3fold_page);
 				zhdr = NULL;
 				continue; /* can't evict at this point */
 			}
@@ -1366,10 +1354,8 @@ static int z3fold_reclaim_page(struct z3
 			 */
 			if (zhdr->foreign_handles ||
 			    test_and_set_bit(PAGE_CLAIMED, &page->private)) {
-				if (kref_put(&zhdr->refcount,
+				if (!kref_put(&zhdr->refcount,
 						release_z3fold_page_locked))
-					atomic64_dec(&pool->pages_nr);
-				else
 					z3fold_page_unlock(zhdr);
 				zhdr = NULL;
 				continue; /* can't evict such page */
@@ -1447,7 +1433,6 @@ next:
 			if (kref_put(&zhdr->refcount,
 					release_z3fold_page_locked)) {
 				kmem_cache_free(pool->c_handle, slots);
-				atomic64_dec(&pool->pages_nr);
 				return 0;
 			}
 			/*
@@ -1669,10 +1654,8 @@ static void z3fold_page_putback(struct p
 	if (!list_empty(&zhdr->buddy))
 		list_del_init(&zhdr->buddy);
 	INIT_LIST_HEAD(&page->lru);
-	if (kref_put(&zhdr->refcount, release_z3fold_page_locked)) {
-		atomic64_dec(&pool->pages_nr);
+	if (kref_put(&zhdr->refcount, release_z3fold_page_locked))
 		return;
-	}
 	spin_lock(&pool->lock);
 	list_add(&page->lru, &pool->lru);
 	spin_unlock(&pool->lock);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swapfile-unuse_pte-can-map-random-data-if-swap-read-fails.patch
mm-swapfile-fix-lost-swap-bits-in-unuse_pte.patch
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
mm-swap-use-helper-is_swap_pte-in-swap_vma_readahead.patch
mm-swap-use-helper-macro-__attr_rw.patch
mm-swap-fold-__swap_info_get-into-its-sole-caller.patch
mm-swap-remove-unneeded-return-value-of-free_swap_slot.patch
mm-swap-print-bad-swap-offset-entry-in-get_swap_device.patch
mm-swap-remove-buggy-cache-nr-check-in-refill_swap_slots_cache.patch
mm-swap-remove-unneeded-p-=-null-check-in-__swap_duplicate.patch
mm-swap-make-page_swapcount-and-__lru_add_drain_all.patch
mm-swap-avoid-calling-swp_swap_info-when-try-to-check-swp_stable_writes.patch
mm-swap-add-helper-swap_offset_available.patch
mm-swap-fix-the-obsolete-comment-for-swp_type_shift.patch
mm-swap-clean-up-the-comment-of-find_next_to_unuse.patch
mm-swap-fix-the-comment-of-get_kernel_pages.patch
mm-swap-fix-comment-about-swap-extent.patch

