Return-Path: <SRS0=g5V1=BD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D86F9C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 00:47:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1C7E208A9
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 00:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595551667;
	bh=iOA0fG26dYBZ65RS4+pC2lkpIPBOgQBSIQrG59BZalE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=TLt52CDmVDV/sMAJXOsotJSOC9pVjeyEO4hDpgngxicU8utHsGKRDiFV/iXcqJA4V
	 piPQ7myn7m3XCxRaDx2yklwYdZudO1ALGJZL0yUEn52nKOwa65BaeWpZU2d4Ig89Kw
	 umiy+fzBm3ddstzeDRayhPTrV6jeZNDpvJddBzkg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbgGXArr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Jul 2020 20:47:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:60276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727783AbgGXArr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Jul 2020 20:47:47 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E788A20737;
        Fri, 24 Jul 2020 00:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595551666;
        bh=iOA0fG26dYBZ65RS4+pC2lkpIPBOgQBSIQrG59BZalE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=AICKgNE8V/0rIwgrawy13RSUm3WzLlRgLzdlToGwuBqOe/wUClNQyJTFQHiH6mYc+
         UpFLbW2S3Qstf0Zm44H2ygSk0LxTK+DCtc9BFPvLcQ+DPOhyF1/8m1SmHIit4Q89qn
         zC8PKIRHegV1uUrx2xBYw0ndFKTjnlm3cqFeGAa8=
Date:   Thu, 23 Jul 2020 17:47:45 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com,
        mgorman@techsingularity.net, mhocko@kernel.org, minchan@kernel.org,
        mm-commits@vger.kernel.org, vbabka@suse.cz, willy@infradead.org
Subject:  + mm-swapcache-support-to-handle-the-shadow-entries.patch
 added to -mm tree
Message-ID: <20200724004745.qON8b7KlY%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapcache: support to handle the shadow entries
has been added to the -mm tree.  Its filename is
     mm-swapcache-support-to-handle-the-shadow-entries.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swapcache-support-to-handle-the-shadow-entries.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swapcache-support-to-handle-the-shadow-entries.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/swapcache: support to handle the shadow entries

Workingset detection for anonymous page will be implemented in the
following patch and it requires to store the shadow entries into the
swapcache.  This patch implements an infrastructure to store the shadow
entry in the swapcache.

Link: http://lkml.kernel.org/r/1595490560-15117-5-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   17 +++++++++---
 mm/shmem.c           |    3 +-
 mm/swap_state.c      |   57 ++++++++++++++++++++++++++++++++++++-----
 mm/swapfile.c        |    2 +
 mm/vmscan.c          |    2 -
 5 files changed, 69 insertions(+), 12 deletions(-)

--- a/include/linux/swap.h~mm-swapcache-support-to-handle-the-shadow-entries
+++ a/include/linux/swap.h
@@ -414,9 +414,13 @@ extern struct address_space *swapper_spa
 extern unsigned long total_swapcache_pages(void);
 extern void show_swap_cache_info(void);
 extern int add_to_swap(struct page *page);
-extern int add_to_swap_cache(struct page *, swp_entry_t, gfp_t);
-extern void __delete_from_swap_cache(struct page *, swp_entry_t entry);
+extern int add_to_swap_cache(struct page *page, swp_entry_t entry,
+			gfp_t gfp, void **shadowp);
+extern void __delete_from_swap_cache(struct page *page,
+			swp_entry_t entry, void *shadow);
 extern void delete_from_swap_cache(struct page *);
+extern void clear_shadow_from_swap_cache(int type, unsigned long begin,
+				unsigned long end);
 extern void free_page_and_swap_cache(struct page *);
 extern void free_pages_and_swap_cache(struct page **, int);
 extern struct page *lookup_swap_cache(swp_entry_t entry,
@@ -570,13 +574,13 @@ static inline int add_to_swap(struct pag
 }
 
 static inline int add_to_swap_cache(struct page *page, swp_entry_t entry,
-							gfp_t gfp_mask)
+					gfp_t gfp_mask, void **shadowp)
 {
 	return -1;
 }
 
 static inline void __delete_from_swap_cache(struct page *page,
-							swp_entry_t entry)
+					swp_entry_t entry, void *shadow)
 {
 }
 
@@ -584,6 +588,11 @@ static inline void delete_from_swap_cach
 {
 }
 
+static inline void clear_shadow_from_swap_cache(int type, unsigned long begin,
+				unsigned long end)
+{
+}
+
 static inline int page_swapcount(struct page *page)
 {
 	return 0;
--- a/mm/shmem.c~mm-swapcache-support-to-handle-the-shadow-entries
+++ a/mm/shmem.c
@@ -1434,7 +1434,8 @@ static int shmem_writepage(struct page *
 		list_add(&info->swaplist, &shmem_swaplist);
 
 	if (add_to_swap_cache(page, swap,
-			__GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN) == 0) {
+			__GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN,
+			NULL) == 0) {
 		spin_lock_irq(&info->lock);
 		shmem_recalc_inode(inode);
 		info->swapped++;
--- a/mm/swapfile.c~mm-swapcache-support-to-handle-the-shadow-entries
+++ a/mm/swapfile.c
@@ -696,6 +696,7 @@ static void add_to_avail_list(struct swa
 static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
 			    unsigned int nr_entries)
 {
+	unsigned long begin = offset;
 	unsigned long end = offset + nr_entries - 1;
 	void (*swap_slot_free_notify)(struct block_device *, unsigned long);
 
@@ -721,6 +722,7 @@ static void swap_range_free(struct swap_
 			swap_slot_free_notify(si->bdev, offset);
 		offset++;
 	}
+	clear_shadow_from_swap_cache(si->type, begin, end);
 }
 
 static void set_cluster_next(struct swap_info_struct *si, unsigned long next)
--- a/mm/swap_state.c~mm-swapcache-support-to-handle-the-shadow-entries
+++ a/mm/swap_state.c
@@ -110,12 +110,14 @@ void show_swap_cache_info(void)
  * add_to_swap_cache resembles add_to_page_cache_locked on swapper_space,
  * but sets SwapCache flag and private instead of mapping and index.
  */
-int add_to_swap_cache(struct page *page, swp_entry_t entry, gfp_t gfp)
+int add_to_swap_cache(struct page *page, swp_entry_t entry,
+			gfp_t gfp, void **shadowp)
 {
 	struct address_space *address_space = swap_address_space(entry);
 	pgoff_t idx = swp_offset(entry);
 	XA_STATE_ORDER(xas, &address_space->i_pages, idx, compound_order(page));
 	unsigned long i, nr = hpage_nr_pages(page);
+	void *old;
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(PageSwapCache(page), page);
@@ -125,16 +127,25 @@ int add_to_swap_cache(struct page *page,
 	SetPageSwapCache(page);
 
 	do {
+		unsigned long nr_shadows = 0;
+
 		xas_lock_irq(&xas);
 		xas_create_range(&xas);
 		if (xas_error(&xas))
 			goto unlock;
 		for (i = 0; i < nr; i++) {
 			VM_BUG_ON_PAGE(xas.xa_index != idx + i, page);
+			old = xas_load(&xas);
+			if (xa_is_value(old)) {
+				nr_shadows++;
+				if (shadowp)
+					*shadowp = old;
+			}
 			set_page_private(page + i, entry.val + i);
 			xas_store(&xas, page);
 			xas_next(&xas);
 		}
+		address_space->nrexceptional -= nr_shadows;
 		address_space->nrpages += nr;
 		__mod_node_page_state(page_pgdat(page), NR_FILE_PAGES, nr);
 		ADD_CACHE_INFO(add_total, nr);
@@ -154,7 +165,8 @@ unlock:
  * This must be called only on pages that have
  * been verified to be in the swap cache.
  */
-void __delete_from_swap_cache(struct page *page, swp_entry_t entry)
+void __delete_from_swap_cache(struct page *page,
+			swp_entry_t entry, void *shadow)
 {
 	struct address_space *address_space = swap_address_space(entry);
 	int i, nr = hpage_nr_pages(page);
@@ -166,12 +178,14 @@ void __delete_from_swap_cache(struct pag
 	VM_BUG_ON_PAGE(PageWriteback(page), page);
 
 	for (i = 0; i < nr; i++) {
-		void *entry = xas_store(&xas, NULL);
+		void *entry = xas_store(&xas, shadow);
 		VM_BUG_ON_PAGE(entry != page, entry);
 		set_page_private(page + i, 0);
 		xas_next(&xas);
 	}
 	ClearPageSwapCache(page);
+	if (shadow)
+		address_space->nrexceptional += nr;
 	address_space->nrpages -= nr;
 	__mod_node_page_state(page_pgdat(page), NR_FILE_PAGES, -nr);
 	ADD_CACHE_INFO(del_total, nr);
@@ -208,7 +222,7 @@ int add_to_swap(struct page *page)
 	 * Add it to the swap cache.
 	 */
 	err = add_to_swap_cache(page, entry,
-			__GFP_HIGH|__GFP_NOMEMALLOC|__GFP_NOWARN);
+			__GFP_HIGH|__GFP_NOMEMALLOC|__GFP_NOWARN, NULL);
 	if (err)
 		/*
 		 * add_to_swap_cache() doesn't return -EEXIST, so we can safely
@@ -246,13 +260,44 @@ void delete_from_swap_cache(struct page
 	struct address_space *address_space = swap_address_space(entry);
 
 	xa_lock_irq(&address_space->i_pages);
-	__delete_from_swap_cache(page, entry);
+	__delete_from_swap_cache(page, entry, NULL);
 	xa_unlock_irq(&address_space->i_pages);
 
 	put_swap_page(page, entry);
 	page_ref_sub(page, hpage_nr_pages(page));
 }
 
+void clear_shadow_from_swap_cache(int type, unsigned long begin,
+				unsigned long end)
+{
+	unsigned long curr = begin;
+	void *old;
+
+	for (;;) {
+		unsigned long nr_shadows = 0;
+		swp_entry_t entry = swp_entry(type, curr);
+		struct address_space *address_space = swap_address_space(entry);
+		XA_STATE(xas, &address_space->i_pages, curr);
+
+		xa_lock_irq(&address_space->i_pages);
+		xas_for_each(&xas, old, end) {
+			if (!xa_is_value(old))
+				continue;
+			xas_store(&xas, NULL);
+			nr_shadows++;
+		}
+		address_space->nrexceptional -= nr_shadows;
+		xa_unlock_irq(&address_space->i_pages);
+
+		/* search the next swapcache until we meet end */
+		curr >>= SWAP_ADDRESS_SPACE_SHIFT;
+		curr++;
+		curr <<= SWAP_ADDRESS_SPACE_SHIFT;
+		if (curr > end)
+			break;
+	}
+}
+
 /* 
  * If we are the only user, then try to free up the swap cache. 
  * 
@@ -429,7 +474,7 @@ struct page *__read_swap_cache_async(swp
 	__SetPageSwapBacked(page);
 
 	/* May fail (-ENOMEM) if XArray node allocation failed. */
-	if (add_to_swap_cache(page, entry, gfp_mask & GFP_RECLAIM_MASK)) {
+	if (add_to_swap_cache(page, entry, gfp_mask & GFP_RECLAIM_MASK, NULL)) {
 		put_swap_page(page, entry);
 		goto fail_unlock;
 	}
--- a/mm/vmscan.c~mm-swapcache-support-to-handle-the-shadow-entries
+++ a/mm/vmscan.c
@@ -896,7 +896,7 @@ static int __remove_mapping(struct addre
 	if (PageSwapCache(page)) {
 		swp_entry_t swap = { .val = page_private(page) };
 		mem_cgroup_swapout(page, swap);
-		__delete_from_swap_cache(page, swap);
+		__delete_from_swap_cache(page, swap, NULL);
 		xa_unlock_irqrestore(&mapping->i_pages, flags);
 		put_swap_page(page, swap);
 		workingset_eviction(page, target_memcg);
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-vmscan-make-active-inactive-ratio-as-1-1-for-anon-lru.patch
mm-vmscan-protect-the-workingset-on-anonymous-lru.patch
mm-workingset-prepare-the-workingset-detection-infrastructure-for-anon-lru.patch
mm-swapcache-support-to-handle-the-shadow-entries.patch
mm-swap-implement-workingset-detection-for-anonymous-lru.patch
mm-vmscan-restore-active-inactive-ratio-for-anonymous-lru.patch
mm-page_isolation-prefer-the-node-of-the-source-page.patch
mm-migrate-move-migration-helper-from-h-to-c.patch
mm-hugetlb-unify-migration-callbacks.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations.patch
mm-migrate-make-a-standard-migration-target-allocation-function.patch
mm-mempolicy-use-a-standard-migration-target-allocation-callback.patch
mm-page_alloc-remove-a-wrapper-for-alloc_migration_target.patch
mm-memory-failure-remove-a-wrapper-for-alloc_migration_target.patch
mm-memory_hotplug-remove-a-wrapper-for-alloc_migration_target.patch

