Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3957DC07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:19:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16DCB61C7F
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:19:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231811AbhGFTWQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:22:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:55938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231917AbhGFTWQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:22:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4B6D61C91;
        Tue,  6 Jul 2021 19:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599177;
        bh=pPKuppODbqWOAp9D1WyRGUD/F7R6kC8C7QzMIZ5gg5M=;
        h=Date:From:To:Subject:From;
        b=wPctQXzlfWaCPjZcanYxOprN2VpDbyupJNOL1cBgFQREuaYfs9+QBZFTmpDO+0LGk
         qWyMmJrsmz3pLesq/820Uet5qzL2QE9q/4MXyPlgCnQVgzZcdUJuNiNkEmRUjsROhF
         iAKGQ2JUgfGd+PfUPl2bynYvXhRqYC38eM7Nc23w=
Date:   Tue, 06 Jul 2021 12:19:36 -0700
From:   akpm@linux-foundation.org
To:     borntraeger@de.ibm.com, dan.carpenter@oracle.com,
        gerald.schaefer@linux.ibm.com, gor@linux.ibm.com,
        hca@linux.ibm.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        ying.huang@intel.com, ziy@nvidia.com
Subject:  [merged] mm-thp-refactor-numa-fault-handling.patch
 removed from -mm tree
Message-ID: <20210706191936.a7uYm6fwM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: refactor NUMA fault handling
has been removed from the -mm tree.  Its filename was
     mm-thp-refactor-numa-fault-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: thp: refactor NUMA fault handling

When the THP NUMA fault support was added THP migration was not supported
yet.  So the ad hoc THP migration was implemented in NUMA fault handling. 
Since v4.14 THP migration has been supported so it doesn't make too much
sense to still keep another THP migration implementation rather than using
the generic migration code.

This patch reworks the NUMA fault handling to use generic migration
implementation to migrate misplaced page.  There is no functional change.

After the refactor the flow of NUMA fault handling looks just like its
PTE counterpart:
  Acquire ptl
  Prepare for migration (elevate page refcount)
  Release ptl
  Isolate page from lru and elevate page refcount
  Migrate the misplaced THP

If migration fails just restore the old normal PMD.

In the old code anon_vma lock was needed to serialize THP migration
against THP split, but since then the THP code has been reworked a lot, it
seems anon_vma lock is not required anymore to avoid the race.

The page refcount elevation when holding ptl should prevent from THP
split.

Use migrate_misplaced_page() for both base page and THP NUMA hinting fault
and remove all the dead and duplicate code.

[dan.carpenter@oracle.com: fix a double unlock bug]
  Link: https://lkml.kernel.org/r/YLX8uYN01JmfLnlK@mwanda
Link: https://lkml.kernel.org/r/20210518200801.7413-4-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |   23 ----
 mm/huge_memory.c        |  145 +++++++++----------------------
 mm/internal.h           |   18 ---
 mm/migrate.c            |  177 +++++++-------------------------------
 4 files changed, 77 insertions(+), 286 deletions(-)

--- a/include/linux/migrate.h~mm-thp-refactor-numa-fault-handling
+++ a/include/linux/migrate.h
@@ -99,14 +99,9 @@ static inline void __ClearPageMovable(st
 #endif
 
 #ifdef CONFIG_NUMA_BALANCING
-extern bool pmd_trans_migrating(pmd_t pmd);
 extern int migrate_misplaced_page(struct page *page,
 				  struct vm_area_struct *vma, int node);
 #else
-static inline bool pmd_trans_migrating(pmd_t pmd)
-{
-	return false;
-}
 static inline int migrate_misplaced_page(struct page *page,
 					 struct vm_area_struct *vma, int node)
 {
@@ -114,24 +109,6 @@ static inline int migrate_misplaced_page
 }
 #endif /* CONFIG_NUMA_BALANCING */
 
-#if defined(CONFIG_NUMA_BALANCING) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
-extern int migrate_misplaced_transhuge_page(struct mm_struct *mm,
-			struct vm_area_struct *vma,
-			pmd_t *pmd, pmd_t entry,
-			unsigned long address,
-			struct page *page, int node);
-#else
-static inline int migrate_misplaced_transhuge_page(struct mm_struct *mm,
-			struct vm_area_struct *vma,
-			pmd_t *pmd, pmd_t entry,
-			unsigned long address,
-			struct page *page, int node)
-{
-	return -EAGAIN;
-}
-#endif /* CONFIG_NUMA_BALANCING && CONFIG_TRANSPARENT_HUGEPAGE*/
-
-
 #ifdef CONFIG_MIGRATION
 
 /*
--- a/mm/huge_memory.c~mm-thp-refactor-numa-fault-handling
+++ a/mm/huge_memory.c
@@ -1423,94 +1423,22 @@ out:
 vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
-	pmd_t pmd = vmf->orig_pmd;
-	struct anon_vma *anon_vma = NULL;
+	pmd_t oldpmd = vmf->orig_pmd;
+	pmd_t pmd;
 	struct page *page;
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
-	int page_nid = NUMA_NO_NODE, this_nid = numa_node_id();
+	int page_nid = NUMA_NO_NODE;
 	int target_nid, last_cpupid = -1;
-	bool page_locked;
 	bool migrated = false;
-	bool was_writable;
+	bool was_writable = pmd_savedwrite(oldpmd);
 	int flags = 0;
 
 	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
-	if (unlikely(!pmd_same(pmd, *vmf->pmd)))
-		goto out_unlock;
-
-	/*
-	 * If there are potential migrations, wait for completion and retry
-	 * without disrupting NUMA hinting information. Do not relock and
-	 * check_same as the page may no longer be mapped.
-	 */
-	if (unlikely(pmd_trans_migrating(*vmf->pmd))) {
-		page = pmd_page(*vmf->pmd);
-		if (!get_page_unless_zero(page))
-			goto out_unlock;
+	if (unlikely(!pmd_same(oldpmd, *vmf->pmd))) {
 		spin_unlock(vmf->ptl);
-		put_and_wait_on_page_locked(page, TASK_UNINTERRUPTIBLE);
 		goto out;
 	}
 
-	page = pmd_page(pmd);
-	BUG_ON(is_huge_zero_page(page));
-	page_nid = page_to_nid(page);
-	last_cpupid = page_cpupid_last(page);
-	count_vm_numa_event(NUMA_HINT_FAULTS);
-	if (page_nid == this_nid) {
-		count_vm_numa_event(NUMA_HINT_FAULTS_LOCAL);
-		flags |= TNF_FAULT_LOCAL;
-	}
-
-	/* See similar comment in do_numa_page for explanation */
-	if (!pmd_savedwrite(pmd))
-		flags |= TNF_NO_GROUP;
-
-	/*
-	 * Acquire the page lock to serialise THP migrations but avoid dropping
-	 * page_table_lock if at all possible
-	 */
-	page_locked = trylock_page(page);
-	target_nid = mpol_misplaced(page, vma, haddr);
-	/* Migration could have started since the pmd_trans_migrating check */
-	if (!page_locked) {
-		page_nid = NUMA_NO_NODE;
-		if (!get_page_unless_zero(page))
-			goto out_unlock;
-		spin_unlock(vmf->ptl);
-		put_and_wait_on_page_locked(page, TASK_UNINTERRUPTIBLE);
-		goto out;
-	} else if (target_nid == NUMA_NO_NODE) {
-		/* There are no parallel migrations and page is in the right
-		 * node. Clear the numa hinting info in this pmd.
-		 */
-		goto clear_pmdnuma;
-	}
-
-	/*
-	 * Page is misplaced. Page lock serialises migrations. Acquire anon_vma
-	 * to serialises splits
-	 */
-	get_page(page);
-	spin_unlock(vmf->ptl);
-	anon_vma = page_lock_anon_vma_read(page);
-
-	/* Confirm the PMD did not change while page_table_lock was released */
-	spin_lock(vmf->ptl);
-	if (unlikely(!pmd_same(pmd, *vmf->pmd))) {
-		unlock_page(page);
-		put_page(page);
-		page_nid = NUMA_NO_NODE;
-		goto out_unlock;
-	}
-
-	/* Bail if we fail to protect against THP splits for any reason */
-	if (unlikely(!anon_vma)) {
-		put_page(page);
-		page_nid = NUMA_NO_NODE;
-		goto clear_pmdnuma;
-	}
-
 	/*
 	 * Since we took the NUMA fault, we must have observed the !accessible
 	 * bit. Make sure all other CPUs agree with that, to avoid them
@@ -1537,43 +1465,58 @@ vm_fault_t do_huge_pmd_numa_page(struct
 					      haddr + HPAGE_PMD_SIZE);
 	}
 
-	/*
-	 * Migrate the THP to the requested node, returns with page unlocked
-	 * and access rights restored.
-	 */
+	pmd = pmd_modify(oldpmd, vma->vm_page_prot);
+	page = vm_normal_page_pmd(vma, haddr, pmd);
+	if (!page)
+		goto out_map;
+
+	/* See similar comment in do_numa_page for explanation */
+	if (!was_writable)
+		flags |= TNF_NO_GROUP;
+
+	page_nid = page_to_nid(page);
+	last_cpupid = page_cpupid_last(page);
+	target_nid = numa_migrate_prep(page, vma, haddr, page_nid,
+				       &flags);
+
+	if (target_nid == NUMA_NO_NODE) {
+		put_page(page);
+		goto out_map;
+	}
+
 	spin_unlock(vmf->ptl);
 
-	migrated = migrate_misplaced_transhuge_page(vma->vm_mm, vma,
-				vmf->pmd, pmd, vmf->address, page, target_nid);
+	migrated = migrate_misplaced_page(page, vma, target_nid);
 	if (migrated) {
 		flags |= TNF_MIGRATED;
 		page_nid = target_nid;
-	} else
+	} else {
 		flags |= TNF_MIGRATE_FAIL;
-
-	goto out;
-clear_pmdnuma:
-	BUG_ON(!PageLocked(page));
-	was_writable = pmd_savedwrite(pmd);
-	pmd = pmd_modify(pmd, vma->vm_page_prot);
-	pmd = pmd_mkyoung(pmd);
-	if (was_writable)
-		pmd = pmd_mkwrite(pmd);
-	set_pmd_at(vma->vm_mm, haddr, vmf->pmd, pmd);
-	update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
-	unlock_page(page);
-out_unlock:
-	spin_unlock(vmf->ptl);
+		vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
+		if (unlikely(!pmd_same(oldpmd, *vmf->pmd))) {
+			spin_unlock(vmf->ptl);
+			goto out;
+		}
+		goto out_map;
+	}
 
 out:
-	if (anon_vma)
-		page_unlock_anon_vma_read(anon_vma);
-
 	if (page_nid != NUMA_NO_NODE)
 		task_numa_fault(last_cpupid, page_nid, HPAGE_PMD_NR,
 				flags);
 
 	return 0;
+
+out_map:
+	/* Restore the PMD */
+	pmd = pmd_modify(oldpmd, vma->vm_page_prot);
+	pmd = pmd_mkyoung(pmd);
+	if (was_writable)
+		pmd = pmd_mkwrite(pmd);
+	set_pmd_at(vma->vm_mm, haddr, vmf->pmd, pmd);
+	update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
+	spin_unlock(vmf->ptl);
+	goto out;
 }
 
 /*
--- a/mm/internal.h~mm-thp-refactor-numa-fault-handling
+++ a/mm/internal.h
@@ -369,23 +369,6 @@ extern unsigned int munlock_vma_page(str
  */
 extern void clear_page_mlock(struct page *page);
 
-/*
- * mlock_migrate_page - called only from migrate_misplaced_transhuge_page()
- * (because that does not go through the full procedure of migration ptes):
- * to migrate the Mlocked page flag; update statistics.
- */
-static inline void mlock_migrate_page(struct page *newpage, struct page *page)
-{
-	if (TestClearPageMlocked(page)) {
-		int nr_pages = thp_nr_pages(page);
-
-		/* Holding pmd lock, no change in irq context: __mod is safe */
-		__mod_zone_page_state(page_zone(page), NR_MLOCK, -nr_pages);
-		SetPageMlocked(newpage);
-		__mod_zone_page_state(page_zone(newpage), NR_MLOCK, nr_pages);
-	}
-}
-
 extern pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma);
 
 /*
@@ -461,7 +444,6 @@ static inline struct file *maybe_unlock_
 #else /* !CONFIG_MMU */
 static inline void clear_page_mlock(struct page *page) { }
 static inline void mlock_vma_page(struct page *page) { }
-static inline void mlock_migrate_page(struct page *new, struct page *old) { }
 static inline void vunmap_range_noflush(unsigned long start, unsigned long end)
 {
 }
--- a/mm/migrate.c~mm-thp-refactor-numa-fault-handling
+++ a/mm/migrate.c
@@ -2048,6 +2048,23 @@ static struct page *alloc_misplaced_dst_
 	return newpage;
 }
 
+static struct page *alloc_misplaced_dst_page_thp(struct page *page,
+						 unsigned long data)
+{
+	int nid = (int) data;
+	struct page *newpage;
+
+	newpage = alloc_pages_node(nid, (GFP_TRANSHUGE_LIGHT | __GFP_THISNODE),
+				   HPAGE_PMD_ORDER);
+	if (!newpage)
+		goto out;
+
+	prep_transhuge_page(newpage);
+
+out:
+	return newpage;
+}
+
 static int numamigrate_isolate_page(pg_data_t *pgdat, struct page *page)
 {
 	int page_lru;
@@ -2086,12 +2103,6 @@ static int numamigrate_isolate_page(pg_d
 	return 1;
 }
 
-bool pmd_trans_migrating(pmd_t pmd)
-{
-	struct page *page = pmd_page(pmd);
-	return PageLocked(page);
-}
-
 /*
  * Attempt to migrate a misplaced page to the specified destination
  * node. Caller is expected to have an elevated reference count on
@@ -2104,6 +2115,20 @@ int migrate_misplaced_page(struct page *
 	int isolated;
 	int nr_remaining;
 	LIST_HEAD(migratepages);
+	new_page_t *new;
+	bool compound;
+
+	/*
+	 * PTE mapped THP or HugeTLB page can't reach here so the page could
+	 * be either base page or THP.  And it must be head page if it is
+	 * THP.
+	 */
+	compound = PageTransHuge(page);
+
+	if (compound)
+		new = alloc_misplaced_dst_page_thp;
+	else
+		new = alloc_misplaced_dst_page;
 
 	/*
 	 * Don't migrate file pages that are mapped in multiple processes
@@ -2125,9 +2150,8 @@ int migrate_misplaced_page(struct page *
 		goto out;
 
 	list_add(&page->lru, &migratepages);
-	nr_remaining = migrate_pages(&migratepages, alloc_misplaced_dst_page,
-				     NULL, node, MIGRATE_ASYNC,
-				     MR_NUMA_MISPLACED);
+	nr_remaining = migrate_pages(&migratepages, *new, NULL, node,
+				     MIGRATE_ASYNC, MR_NUMA_MISPLACED);
 	if (nr_remaining) {
 		if (!list_empty(&migratepages)) {
 			list_del(&page->lru);
@@ -2146,141 +2170,6 @@ out:
 	return 0;
 }
 #endif /* CONFIG_NUMA_BALANCING */
-
-#if defined(CONFIG_NUMA_BALANCING) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
-/*
- * Migrates a THP to a given target node. page must be locked and is unlocked
- * before returning.
- */
-int migrate_misplaced_transhuge_page(struct mm_struct *mm,
-				struct vm_area_struct *vma,
-				pmd_t *pmd, pmd_t entry,
-				unsigned long address,
-				struct page *page, int node)
-{
-	spinlock_t *ptl;
-	pg_data_t *pgdat = NODE_DATA(node);
-	int isolated = 0;
-	struct page *new_page = NULL;
-	int page_lru = page_is_file_lru(page);
-	unsigned long start = address & HPAGE_PMD_MASK;
-
-	new_page = alloc_pages_node(node,
-		(GFP_TRANSHUGE_LIGHT | __GFP_THISNODE),
-		HPAGE_PMD_ORDER);
-	if (!new_page)
-		goto out_fail;
-	prep_transhuge_page(new_page);
-
-	isolated = numamigrate_isolate_page(pgdat, page);
-	if (!isolated) {
-		put_page(new_page);
-		goto out_fail;
-	}
-
-	/* Prepare a page as a migration target */
-	__SetPageLocked(new_page);
-	if (PageSwapBacked(page))
-		__SetPageSwapBacked(new_page);
-
-	/* anon mapping, we can simply copy page->mapping to the new page: */
-	new_page->mapping = page->mapping;
-	new_page->index = page->index;
-	/* flush the cache before copying using the kernel virtual address */
-	flush_cache_range(vma, start, start + HPAGE_PMD_SIZE);
-	migrate_page_copy(new_page, page);
-	WARN_ON(PageLRU(new_page));
-
-	/* Recheck the target PMD */
-	ptl = pmd_lock(mm, pmd);
-	if (unlikely(!pmd_same(*pmd, entry) || !page_ref_freeze(page, 2))) {
-		spin_unlock(ptl);
-
-		/* Reverse changes made by migrate_page_copy() */
-		if (TestClearPageActive(new_page))
-			SetPageActive(page);
-		if (TestClearPageUnevictable(new_page))
-			SetPageUnevictable(page);
-
-		unlock_page(new_page);
-		put_page(new_page);		/* Free it */
-
-		/* Retake the callers reference and putback on LRU */
-		get_page(page);
-		putback_lru_page(page);
-		mod_node_page_state(page_pgdat(page),
-			 NR_ISOLATED_ANON + page_lru, -HPAGE_PMD_NR);
-
-		goto out_unlock;
-	}
-
-	entry = mk_huge_pmd(new_page, vma->vm_page_prot);
-	entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
-
-	/*
-	 * Overwrite the old entry under pagetable lock and establish
-	 * the new PTE. Any parallel GUP will either observe the old
-	 * page blocking on the page lock, block on the page table
-	 * lock or observe the new page. The SetPageUptodate on the
-	 * new page and page_add_new_anon_rmap guarantee the copy is
-	 * visible before the pagetable update.
-	 */
-	page_add_anon_rmap(new_page, vma, start, true);
-	/*
-	 * At this point the pmd is numa/protnone (i.e. non present) and the TLB
-	 * has already been flushed globally.  So no TLB can be currently
-	 * caching this non present pmd mapping.  There's no need to clear the
-	 * pmd before doing set_pmd_at(), nor to flush the TLB after
-	 * set_pmd_at().  Clearing the pmd here would introduce a race
-	 * condition against MADV_DONTNEED, because MADV_DONTNEED only holds the
-	 * mmap_lock for reading.  If the pmd is set to NULL at any given time,
-	 * MADV_DONTNEED won't wait on the pmd lock and it'll skip clearing this
-	 * pmd.
-	 */
-	set_pmd_at(mm, start, pmd, entry);
-	update_mmu_cache_pmd(vma, address, &entry);
-
-	page_ref_unfreeze(page, 2);
-	mlock_migrate_page(new_page, page);
-	page_remove_rmap(page, true);
-	set_page_owner_migrate_reason(new_page, MR_NUMA_MISPLACED);
-
-	spin_unlock(ptl);
-
-	/* Take an "isolate" reference and put new page on the LRU. */
-	get_page(new_page);
-	putback_lru_page(new_page);
-
-	unlock_page(new_page);
-	unlock_page(page);
-	put_page(page);			/* Drop the rmap reference */
-	put_page(page);			/* Drop the LRU isolation reference */
-
-	count_vm_events(PGMIGRATE_SUCCESS, HPAGE_PMD_NR);
-	count_vm_numa_events(NUMA_PAGE_MIGRATE, HPAGE_PMD_NR);
-
-	mod_node_page_state(page_pgdat(page),
-			NR_ISOLATED_ANON + page_lru,
-			-HPAGE_PMD_NR);
-	return isolated;
-
-out_fail:
-	count_vm_events(PGMIGRATE_FAIL, HPAGE_PMD_NR);
-	ptl = pmd_lock(mm, pmd);
-	if (pmd_same(*pmd, entry)) {
-		entry = pmd_modify(entry, vma->vm_page_prot);
-		set_pmd_at(mm, start, pmd, entry);
-		update_mmu_cache_pmd(vma, address, &entry);
-	}
-	spin_unlock(ptl);
-
-out_unlock:
-	unlock_page(page);
-	put_page(page);
-	return 0;
-}
-#endif /* CONFIG_NUMA_BALANCING */
-
 #endif /* CONFIG_NUMA */
 
 #ifdef CONFIG_DEVICE_PRIVATE
_

Patches currently in -mm which might be from shy828301@gmail.com are


