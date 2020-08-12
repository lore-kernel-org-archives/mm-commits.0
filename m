Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23700C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:01:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EECBF2078B
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266094;
	bh=fdaVOgS051xxuqhkhr8RWT0fWtwATzFJB0PGmMPiQ24=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=0P0NmQdsXtbA7Vw9eBXLEt+GXCj6AaBK1fzfV2ohGA7R7R721F4MqEpRqAaUtdeNQ
	 l/J3Sl8BbUH1uctJO1UCIoi0fwrjmyrWHBZEh6gefCCCVy2wz2IT4/xQTtAm4n4orq
	 zR1zNOKGASOMgmsMdflCWGpE56hq2RDxF6GRAVaE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgHLVBd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:01:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:46048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726564AbgHLVB3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:01:29 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A17B12078B;
        Wed, 12 Aug 2020 21:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266089;
        bh=fdaVOgS051xxuqhkhr8RWT0fWtwATzFJB0PGmMPiQ24=;
        h=Date:From:To:Subject:From;
        b=Ch9kemSaKFXame3ptk5gaxG9FwjI3+hynfCXAcUXT1+rrNLo4IpIKmmQs0ltnd58J
         oiacq5/wOP8kEE6cKIgwdJ74deBrjquR4kUcbRG2+74RXlcSv9gLOuBruL6xhi4Gtp
         OGcvOrj832gw3iBvjSjC/2Ra0feV7RSAWtYvCNjc=
Date:   Wed, 12 Aug 2020 14:01:28 -0700
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com,
        mgorman@techsingularity.net, mhocko@kernel.org, minchan@kernel.org,
        mm-commits@vger.kernel.org, vbabka@suse.cz, willy@infradead.org
Subject:  [merged]
 mm-swap-implement-workingset-detection-for-anonymous-lru.patch removed from
 -mm tree
Message-ID: <20200812210128.ClStro1qh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: implement workingset detection for anonymous LRU
has been removed from the -mm tree.  Its filename was
     mm-swap-implement-workingset-detection-for-anonymous-lru.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/swap: implement workingset detection for anonymous LRU

This patch implements workingset detection for anonymous LRU.  All the
infrastructure is implemented by the previous patches so this patch just
activates the workingset detection by installing/retrieving the shadow
entry and adding refault calculation.

Link: http://lkml.kernel.org/r/1595490560-15117-6-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    6 ++++++
 mm/memory.c          |   11 ++++-------
 mm/swap_state.c      |   23 ++++++++++++++++++-----
 mm/vmscan.c          |    7 ++++---
 mm/workingset.c      |   15 +++++++++++----
 5 files changed, 43 insertions(+), 19 deletions(-)

--- a/include/linux/swap.h~mm-swap-implement-workingset-detection-for-anonymous-lru
+++ a/include/linux/swap.h
@@ -414,6 +414,7 @@ extern struct address_space *swapper_spa
 extern unsigned long total_swapcache_pages(void);
 extern void show_swap_cache_info(void);
 extern int add_to_swap(struct page *page);
+extern void *get_shadow_from_swap_cache(swp_entry_t entry);
 extern int add_to_swap_cache(struct page *page, swp_entry_t entry,
 			gfp_t gfp, void **shadowp);
 extern void __delete_from_swap_cache(struct page *page,
@@ -573,6 +574,11 @@ static inline int add_to_swap(struct pag
 	return 0;
 }
 
+static inline void *get_shadow_from_swap_cache(swp_entry_t entry)
+{
+	return NULL;
+}
+
 static inline int add_to_swap_cache(struct page *page, swp_entry_t entry,
 					gfp_t gfp_mask, void **shadowp)
 {
--- a/mm/memory.c~mm-swap-implement-workingset-detection-for-anonymous-lru
+++ a/mm/memory.c
@@ -3098,6 +3098,7 @@ vm_fault_t do_swap_page(struct vm_fault
 	int locked;
 	int exclusive = 0;
 	vm_fault_t ret = 0;
+	void *shadow = NULL;
 
 	if (!pte_unmap_same(vma->vm_mm, vmf->pmd, vmf->pte, vmf->orig_pte))
 		goto out;
@@ -3149,13 +3150,9 @@ vm_fault_t do_swap_page(struct vm_fault
 					goto out_page;
 				}
 
-				/*
-				 * XXX: Move to lru_cache_add() when it
-				 * supports new vs putback
-				 */
-				spin_lock_irq(&page_pgdat(page)->lru_lock);
-				lru_note_cost_page(page);
-				spin_unlock_irq(&page_pgdat(page)->lru_lock);
+				shadow = get_shadow_from_swap_cache(entry);
+				if (shadow)
+					workingset_refault(page, shadow);
 
 				lru_cache_add(page);
 				swap_readpage(page, true);
--- a/mm/swap_state.c~mm-swap-implement-workingset-detection-for-anonymous-lru
+++ a/mm/swap_state.c
@@ -106,6 +106,20 @@ void show_swap_cache_info(void)
 	printk("Total swap = %lukB\n", total_swap_pages << (PAGE_SHIFT - 10));
 }
 
+void *get_shadow_from_swap_cache(swp_entry_t entry)
+{
+	struct address_space *address_space = swap_address_space(entry);
+	pgoff_t idx = swp_offset(entry);
+	struct page *page;
+
+	page = find_get_entry(address_space, idx);
+	if (xa_is_value(page))
+		return page;
+	if (page)
+		put_page(page);
+	return NULL;
+}
+
 /*
  * add_to_swap_cache resembles add_to_page_cache_locked on swapper_space,
  * but sets SwapCache flag and private instead of mapping and index.
@@ -406,6 +420,7 @@ struct page *__read_swap_cache_async(swp
 {
 	struct swap_info_struct *si;
 	struct page *page;
+	void *shadow = NULL;
 
 	*new_page_allocated = false;
 
@@ -474,7 +489,7 @@ struct page *__read_swap_cache_async(swp
 	__SetPageSwapBacked(page);
 
 	/* May fail (-ENOMEM) if XArray node allocation failed. */
-	if (add_to_swap_cache(page, entry, gfp_mask & GFP_RECLAIM_MASK, NULL)) {
+	if (add_to_swap_cache(page, entry, gfp_mask & GFP_RECLAIM_MASK, &shadow)) {
 		put_swap_page(page, entry);
 		goto fail_unlock;
 	}
@@ -484,10 +499,8 @@ struct page *__read_swap_cache_async(swp
 		goto fail_unlock;
 	}
 
-	/* XXX: Move to lru_cache_add() when it supports new vs putback */
-	spin_lock_irq(&page_pgdat(page)->lru_lock);
-	lru_note_cost_page(page);
-	spin_unlock_irq(&page_pgdat(page)->lru_lock);
+	if (shadow)
+		workingset_refault(page, shadow);
 
 	/* Caller will initiate read into locked page */
 	SetPageWorkingset(page);
--- a/mm/vmscan.c~mm-swap-implement-workingset-detection-for-anonymous-lru
+++ a/mm/vmscan.c
@@ -854,6 +854,7 @@ static int __remove_mapping(struct addre
 {
 	unsigned long flags;
 	int refcount;
+	void *shadow = NULL;
 
 	BUG_ON(!PageLocked(page));
 	BUG_ON(mapping != page_mapping(page));
@@ -896,13 +897,13 @@ static int __remove_mapping(struct addre
 	if (PageSwapCache(page)) {
 		swp_entry_t swap = { .val = page_private(page) };
 		mem_cgroup_swapout(page, swap);
-		__delete_from_swap_cache(page, swap, NULL);
+		if (reclaimed && !mapping_exiting(mapping))
+			shadow = workingset_eviction(page, target_memcg);
+		__delete_from_swap_cache(page, swap, shadow);
 		xa_unlock_irqrestore(&mapping->i_pages, flags);
 		put_swap_page(page, swap);
-		workingset_eviction(page, target_memcg);
 	} else {
 		void (*freepage)(struct page *);
-		void *shadow = NULL;
 
 		freepage = mapping->a_ops->freepage;
 		/*
--- a/mm/workingset.c~mm-swap-implement-workingset-detection-for-anonymous-lru
+++ a/mm/workingset.c
@@ -353,15 +353,22 @@ void workingset_refault(struct page *pag
 	/*
 	 * Compare the distance to the existing workingset size. We
 	 * don't activate pages that couldn't stay resident even if
-	 * all the memory was available to the page cache. Whether
-	 * cache can compete with anon or not depends on having swap.
+	 * all the memory was available to the workingset. Whether
+	 * workingset competition needs to consider anon or not depends
+	 * on having swap.
 	 */
 	workingset_size = lruvec_page_state(eviction_lruvec, NR_ACTIVE_FILE);
-	if (mem_cgroup_get_nr_swap_pages(memcg) > 0) {
+	if (!file) {
 		workingset_size += lruvec_page_state(eviction_lruvec,
-						     NR_INACTIVE_ANON);
+						     NR_INACTIVE_FILE);
+	}
+	if (mem_cgroup_get_nr_swap_pages(memcg) > 0) {
 		workingset_size += lruvec_page_state(eviction_lruvec,
 						     NR_ACTIVE_ANON);
+		if (file) {
+			workingset_size += lruvec_page_state(eviction_lruvec,
+						     NR_INACTIVE_ANON);
+		}
 	}
 	if (refault_distance > workingset_size)
 		goto out;
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-memory-failure-remove-a-wrapper-for-alloc_migration_target.patch
mm-memory_hotplug-remove-a-wrapper-for-alloc_migration_target.patch

