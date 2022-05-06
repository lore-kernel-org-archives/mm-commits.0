Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DB2EC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  6 May 2022 01:33:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387954AbiEFBgk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 May 2022 21:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387958AbiEFBgj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 May 2022 21:36:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4351A61616
        for <mm-commits@vger.kernel.org>; Thu,  5 May 2022 18:32:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0588DB82E5C
        for <mm-commits@vger.kernel.org>; Fri,  6 May 2022 01:32:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4725C385A8;
        Fri,  6 May 2022 01:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651800772;
        bh=eS8/hZyfTkllZvHrx+zkm4YtQu8S/LVCq+q/m9EFqjI=;
        h=Date:To:From:Subject:From;
        b=zhdlsTrAyjQTQuYdtl8R/P5bzGP/rLRXoE86TCBY7mdK3KxIazP3dXRZNl6Njh1I1
         drObfs4BMMGDXsYagd4Oe0Lu4VClBa93WHcPMrM97B6e1olOUXOUrRLMKcXp6vpOK6
         iqbRrEi62Fe3Kwt036FILVkVv1JXbRanJMmmpkzk=
Date:   Thu, 05 May 2022 18:32:52 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + swap-turn-get_swap_page-into-folio_alloc_swap.patch added to mm-unstable branch
Message-Id: <20220506013252.B4725C385A8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: swap: turn get_swap_page() into folio_alloc_swap()
has been added to the -mm mm-unstable branch.  Its filename is
     swap-turn-get_swap_page-into-folio_alloc_swap.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: swap: turn get_swap_page() into folio_alloc_swap()

This removes an assumption that a large folio is HPAGE_PMD_NR pages
in size.

Link: https://lkml.kernel.org/r/20220504182857.4013401-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   13 +++++++------
 mm/memcontrol.c      |   16 ++++++++--------
 mm/shmem.c           |    3 ++-
 mm/swap_slots.c      |   14 +++++++-------
 mm/swap_state.c      |    3 ++-
 mm/swapfile.c        |   17 +++++++++--------
 6 files changed, 35 insertions(+), 31 deletions(-)

--- a/include/linux/swap.h~swap-turn-get_swap_page-into-folio_alloc_swap
+++ a/include/linux/swap.h
@@ -475,7 +475,7 @@ static inline long get_nr_swap_pages(voi
 }
 
 extern void si_swapinfo(struct sysinfo *);
-extern swp_entry_t get_swap_page(struct page *page);
+swp_entry_t folio_alloc_swap(struct folio *folio);
 extern void put_swap_page(struct page *page, swp_entry_t entry);
 extern swp_entry_t get_swap_page_of_type(int);
 extern int get_swap_pages(int n, swp_entry_t swp_entries[], int entry_size);
@@ -588,7 +588,7 @@ static inline int try_to_free_swap(struc
 	return 0;
 }
 
-static inline swp_entry_t get_swap_page(struct page *page)
+static inline swp_entry_t folio_alloc_swap(struct folio *folio)
 {
 	swp_entry_t entry;
 	entry.val = 0;
@@ -648,12 +648,13 @@ static inline void cgroup_throttle_swapr
 
 #ifdef CONFIG_MEMCG_SWAP
 void mem_cgroup_swapout(struct folio *folio, swp_entry_t entry);
-extern int __mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry);
-static inline int mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry)
+int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry);
+static inline int mem_cgroup_try_charge_swap(struct folio *folio,
+		swp_entry_t entry)
 {
 	if (mem_cgroup_disabled())
 		return 0;
-	return __mem_cgroup_try_charge_swap(page, entry);
+	return __mem_cgroup_try_charge_swap(folio, entry);
 }
 
 extern void __mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_pages);
@@ -671,7 +672,7 @@ static inline void mem_cgroup_swapout(st
 {
 }
 
-static inline int mem_cgroup_try_charge_swap(struct page *page,
+static inline int mem_cgroup_try_charge_swap(struct folio *folio,
 					     swp_entry_t entry)
 {
 	return 0;
--- a/mm/memcontrol.c~swap-turn-get_swap_page-into-folio_alloc_swap
+++ a/mm/memcontrol.c
@@ -7162,17 +7162,17 @@ void mem_cgroup_swapout(struct folio *fo
 }
 
 /**
- * __mem_cgroup_try_charge_swap - try charging swap space for a page
- * @page: page being added to swap
+ * __mem_cgroup_try_charge_swap - try charging swap space for a folio
+ * @folio: folio being added to swap
  * @entry: swap entry to charge
  *
- * Try to charge @page's memcg for the swap space at @entry.
+ * Try to charge @folio's memcg for the swap space at @entry.
  *
  * Returns 0 on success, -ENOMEM on failure.
  */
-int __mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry)
+int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
 {
-	unsigned int nr_pages = thp_nr_pages(page);
+	unsigned int nr_pages = folio_nr_pages(folio);
 	struct page_counter *counter;
 	struct mem_cgroup *memcg;
 	unsigned short oldid;
@@ -7180,9 +7180,9 @@ int __mem_cgroup_try_charge_swap(struct
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return 0;
 
-	memcg = page_memcg(page);
+	memcg = folio_memcg(folio);
 
-	VM_WARN_ON_ONCE_PAGE(!memcg, page);
+	VM_WARN_ON_ONCE_FOLIO(!memcg, folio);
 	if (!memcg)
 		return 0;
 
@@ -7205,7 +7205,7 @@ int __mem_cgroup_try_charge_swap(struct
 	if (nr_pages > 1)
 		mem_cgroup_id_get_many(memcg, nr_pages - 1);
 	oldid = swap_cgroup_record(entry, mem_cgroup_id(memcg), nr_pages);
-	VM_BUG_ON_PAGE(oldid, page);
+	VM_BUG_ON_FOLIO(oldid, folio);
 	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
 
 	return 0;
--- a/mm/shmem.c~swap-turn-get_swap_page-into-folio_alloc_swap
+++ a/mm/shmem.c
@@ -1313,6 +1313,7 @@ int shmem_unuse(unsigned int type)
  */
 static int shmem_writepage(struct page *page, struct writeback_control *wbc)
 {
+	struct folio *folio = page_folio(page);
 	struct shmem_inode_info *info;
 	struct address_space *mapping;
 	struct inode *inode;
@@ -1386,7 +1387,7 @@ static int shmem_writepage(struct page *
 		SetPageUptodate(page);
 	}
 
-	swap = get_swap_page(page);
+	swap = folio_alloc_swap(folio);
 	if (!swap.val)
 		goto redirty;
 
--- a/mm/swapfile.c~swap-turn-get_swap_page-into-folio_alloc_swap
+++ a/mm/swapfile.c
@@ -77,9 +77,9 @@ static PLIST_HEAD(swap_active_head);
 /*
  * all available (active, not full) swap_info_structs
  * protected with swap_avail_lock, ordered by priority.
- * This is used by get_swap_page() instead of swap_active_head
+ * This is used by folio_alloc_swap() instead of swap_active_head
  * because swap_active_head includes all swap_info_structs,
- * but get_swap_page() doesn't need to look at full ones.
+ * but folio_alloc_swap() doesn't need to look at full ones.
  * This uses its own lock instead of swap_lock because when a
  * swap_info_struct changes between not-full/full, it needs to
  * add/remove itself to/from this list, but the swap_info_struct->lock
@@ -2124,11 +2124,12 @@ retry:
 	 * Under global memory pressure, swap entries can be reinserted back
 	 * into process space after the mmlist loop above passes over them.
 	 *
-	 * Limit the number of retries? No: when mmget_not_zero() above fails,
-	 * that mm is likely to be freeing swap from exit_mmap(), which proceeds
-	 * at its own independent pace; and even shmem_writepage() could have
-	 * been preempted after get_swap_page(), temporarily hiding that swap.
-	 * It's easy and robust (though cpu-intensive) just to keep retrying.
+	 * Limit the number of retries? No: when mmget_not_zero()
+	 * above fails, that mm is likely to be freeing swap from
+	 * exit_mmap(), which proceeds at its own independent pace;
+	 * and even shmem_writepage() could have been preempted after
+	 * folio_alloc_swap(), temporarily hiding that swap.  It's easy
+	 * and robust (though cpu-intensive) just to keep retrying.
 	 */
 	if (READ_ONCE(si->inuse_pages)) {
 		if (!signal_pending(current))
@@ -2342,7 +2343,7 @@ static void _enable_swap_info(struct swa
 	 * which on removal of any swap_info_struct with an auto-assigned
 	 * (i.e. negative) priority increments the auto-assigned priority
 	 * of any lower-priority swap_info_structs.
-	 * swap_avail_head needs to be priority ordered for get_swap_page(),
+	 * swap_avail_head needs to be priority ordered for folio_alloc_swap(),
 	 * which allocates swap pages from the highest available priority
 	 * swap_info_struct.
 	 */
--- a/mm/swap_slots.c~swap-turn-get_swap_page-into-folio_alloc_swap
+++ a/mm/swap_slots.c
@@ -117,7 +117,7 @@ static int alloc_swap_slot_cache(unsigne
 
 	/*
 	 * Do allocation outside swap_slots_cache_mutex
-	 * as kvzalloc could trigger reclaim and get_swap_page,
+	 * as kvzalloc could trigger reclaim and folio_alloc_swap,
 	 * which can lock swap_slots_cache_mutex.
 	 */
 	slots = kvcalloc(SWAP_SLOTS_CACHE_SIZE, sizeof(swp_entry_t),
@@ -213,7 +213,7 @@ static void __drain_swap_slots_cache(uns
 	 * this function can be invoked in the cpu
 	 * hot plug path:
 	 * cpu_up -> lock cpu_hotplug -> cpu hotplug state callback
-	 *   -> memory allocation -> direct reclaim -> get_swap_page
+	 *   -> memory allocation -> direct reclaim -> folio_alloc_swap
 	 *   -> drain_swap_slots_cache
 	 *
 	 * Hence the loop over current online cpu below could miss cpu that
@@ -301,16 +301,16 @@ direct_free:
 	return 0;
 }
 
-swp_entry_t get_swap_page(struct page *page)
+swp_entry_t folio_alloc_swap(struct folio *folio)
 {
 	swp_entry_t entry;
 	struct swap_slots_cache *cache;
 
 	entry.val = 0;
 
-	if (PageTransHuge(page)) {
+	if (folio_test_large(folio)) {
 		if (IS_ENABLED(CONFIG_THP_SWAP))
-			get_swap_pages(1, &entry, HPAGE_PMD_NR);
+			get_swap_pages(1, &entry, folio_nr_pages(folio));
 		goto out;
 	}
 
@@ -344,8 +344,8 @@ repeat:
 
 	get_swap_pages(1, &entry, 1);
 out:
-	if (mem_cgroup_try_charge_swap(page, entry)) {
-		put_swap_page(page, entry);
+	if (mem_cgroup_try_charge_swap(folio, entry)) {
+		put_swap_page(&folio->page, entry);
 		entry.val = 0;
 	}
 	return entry;
--- a/mm/swap_state.c~swap-turn-get_swap_page-into-folio_alloc_swap
+++ a/mm/swap_state.c
@@ -184,13 +184,14 @@ void __delete_from_swap_cache(struct pag
  */
 int add_to_swap(struct page *page)
 {
+	struct folio *folio = page_folio(page);
 	swp_entry_t entry;
 	int err;
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(!PageUptodate(page), page);
 
-	entry = get_swap_page(page);
+	entry = folio_alloc_swap(folio);
 	if (!entry.val)
 		return 0;
 
_

Patches currently in -mm which might be from willy@infradead.org are

shmem-convert-shmem_alloc_hugepage-to-use-vma_alloc_folio.patch
mm-huge_memory-convert-do_huge_pmd_anonymous_page-to-use-vma_alloc_folio.patch
alpha-fix-alloc_zeroed_user_highpage_movable.patch
mm-remove-alloc_pages_vma.patch
vmscan-use-folio_mapped-in-shrink_page_list.patch
vmscan-convert-the-writeback-handling-in-shrink_page_list-to-folios.patch
swap-turn-get_swap_page-into-folio_alloc_swap.patch
swap-convert-add_to_swap-to-take-a-folio.patch
vmscan-convert-dirty-page-handling-to-folios.patch
vmscan-convert-page-buffer-handling-to-use-folios.patch
vmscan-convert-lazy-freeing-to-folios.patch
vmscan-move-initialisation-of-mapping-down.patch
vmscan-convert-the-activate_locked-portion-of-shrink_page_list-to-folios.patch
mm-allow-can_split_folio-to-be-called-when-thp-are-disabled.patch
vmscan-remove-remaining-uses-of-page-in-shrink_page_list.patch
mm-shmem-use-a-folio-in-shmem_unused_huge_shrink.patch
mm-swap-add-folio_throttle_swaprate.patch
mm-shmem-convert-shmem_add_to_page_cache-to-take-a-folio.patch
mm-shmem-turn-shmem_should_replace_page-into-shmem_should_replace_folio.patch
mm-shmem-add-shmem_alloc_folio.patch
mm-shmem-convert-shmem_alloc_and_acct_page-to-use-a-folio.patch
mm-shmem-convert-shmem_getpage_gfp-to-use-a-folio.patch
mm-shmem-convert-shmem_swapin_page-to-shmem_swapin_folio.patch
mm-add-folio_mapping_flags.patch
mm-add-folio_test_movable.patch
mm-migrate-convert-move_to_new_page-into-move_to_new_folio.patch

