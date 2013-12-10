From: akpm@linux-foundation.org
Subject: +
 mm-numa-serialise-parallel-get_user_page-against-thp-migration.patch added
 to -mm tree
Date: Tue, 10 Dec 2013 14:20:17 -0800
Message-ID: <52a793a1.vYoneuI9LaDwdd1l%akpm__47591.7784533978$1386714029$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40725 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3LJWUS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Dec 2013 17:20:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, riel@redhat.com, athorlton@sgi.com, mgorman@suse.de

Subject: + mm-numa-serialise-parallel-get_user_page-against-thp-migration.patch added to -mm tree
To: mgorman@suse.de,athorlton@sgi.com,riel@redhat.com,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 10 Dec 2013 14:20:17 -0800


The patch titled
     Subject: mm: numa: serialise parallel get_user_page against THP migration
has been added to the -mm tree.  Its filename is
     mm-numa-serialise-parallel-get_user_page-against-thp-migration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-numa-serialise-parallel-get_user_page-against-thp-migration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-numa-serialise-parallel-get_user_page-against-thp-migration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: numa: serialise parallel get_user_page against THP migration

Base pages are unmapped and flushed from cache and TLB during normal page
migration and replaced with a migration entry that causes any parallel or
gup to block until migration completes.  THP does not unmap pages due to a
lack of support for migration entries at a PMD level.  This allows races
with get_user_pages and get_user_pages_fast which commit 3f926ab94 ("mm:
Close races between THP migration and PMD numa clearing") made worse by
introducing a pmd_clear_flush().

This patch forces get_user_page (fast and normal) on a pmd_numa page to go
through the slow get_user_page path where it will serialise against THP
migration and properly account for the NUMA hinting fault.  On the
migration side the page table lock is taken for each PTE update.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Alex Thorlton <athorlton@sgi.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/gup.c |   13 +++++++++++++
 mm/huge_memory.c  |   24 ++++++++++++++++--------
 mm/migrate.c      |   38 +++++++++++++++++++++++++++++++-------
 3 files changed, 60 insertions(+), 15 deletions(-)

diff -puN arch/x86/mm/gup.c~mm-numa-serialise-parallel-get_user_page-against-thp-migration arch/x86/mm/gup.c
--- a/arch/x86/mm/gup.c~mm-numa-serialise-parallel-get_user_page-against-thp-migration
+++ a/arch/x86/mm/gup.c
@@ -83,6 +83,12 @@ static noinline int gup_pte_range(pmd_t
 		pte_t pte = gup_get_pte(ptep);
 		struct page *page;
 
+		/* Similar to the PMD case, NUMA hinting must take slow path */
+		if (pte_numa(pte)) {
+			pte_unmap(ptep);
+			return 0;
+		}
+
 		if ((pte_flags(pte) & (mask | _PAGE_SPECIAL)) != mask) {
 			pte_unmap(ptep);
 			return 0;
@@ -167,6 +173,13 @@ static int gup_pmd_range(pud_t pud, unsi
 		if (pmd_none(pmd) || pmd_trans_splitting(pmd))
 			return 0;
 		if (unlikely(pmd_large(pmd))) {
+			/*
+			 * NUMA hinting faults need to be handled in the GUP
+			 * slowpath for accounting purposes and so that they
+			 * can be serialised against THP migration.
+			 */
+			if (pmd_numa(pmd))
+				return 0;
 			if (!gup_huge_pmd(pmd, addr, next, write, pages, nr))
 				return 0;
 		} else {
diff -puN mm/huge_memory.c~mm-numa-serialise-parallel-get_user_page-against-thp-migration mm/huge_memory.c
--- a/mm/huge_memory.c~mm-numa-serialise-parallel-get_user_page-against-thp-migration
+++ a/mm/huge_memory.c
@@ -1243,6 +1243,10 @@ struct page *follow_trans_huge_pmd(struc
 	if ((flags & FOLL_DUMP) && is_huge_zero_pmd(*pmd))
 		return ERR_PTR(-EFAULT);
 
+	/* Full NUMA hinting faults to serialise migration in fault paths */
+	if ((flags & FOLL_NUMA) && pmd_numa(*pmd))
+		goto out;
+
 	page = pmd_page(*pmd);
 	VM_BUG_ON(!PageHead(page));
 	if (flags & FOLL_TOUCH) {
@@ -1323,23 +1327,27 @@ int do_huge_pmd_numa_page(struct mm_stru
 		/* If the page was locked, there are no parallel migrations */
 		if (page_locked)
 			goto clear_pmdnuma;
+	}
 
-		/*
-		 * Otherwise wait for potential migrations and retry. We do
-		 * relock and check_same as the page may no longer be mapped.
-		 * As the fault is being retried, do not account for it.
-		 */
+	/*
+	 * If there are potential migrations, wait for completion and retry. We
+	 * do not relock and check_same as the page may no longer be mapped.
+	 * Furtermore, even if the page is currently misplaced, there is no
+	 * guarantee it is still misplaced after the migration completes.
+	 */
+	if (!page_locked) {
 		spin_unlock(ptl);
 		wait_on_page_locked(page);
 		page_nid = -1;
 		goto out;
 	}
 
-	/* Page is misplaced, serialise migrations and parallel THP splits */
+	/*
+	 * Page is misplaced. Page lock serialises migrations. Acquire anon_vma
+	 * to serialises splits
+	 */
 	get_page(page);
 	spin_unlock(ptl);
-	if (!page_locked)
-		lock_page(page);
 	anon_vma = page_lock_anon_vma_read(page);
 
 	/* Confirm the PMD did not change while page_table_lock was released */
diff -puN mm/migrate.c~mm-numa-serialise-parallel-get_user_page-against-thp-migration mm/migrate.c
--- a/mm/migrate.c~mm-numa-serialise-parallel-get_user_page-against-thp-migration
+++ a/mm/migrate.c
@@ -1727,6 +1727,7 @@ int migrate_misplaced_transhuge_page(str
 	struct page *new_page = NULL;
 	struct mem_cgroup *memcg = NULL;
 	int page_lru = page_is_file_cache(page);
+	pmd_t orig_entry;
 
 	/*
 	 * Rate-limit the amount of data that is being migrated to a node.
@@ -1761,7 +1762,8 @@ int migrate_misplaced_transhuge_page(str
 
 	/* Recheck the target PMD */
 	ptl = pmd_lock(mm, pmd);
-	if (unlikely(!pmd_same(*pmd, entry))) {
+	if (unlikely(!pmd_same(*pmd, entry) || page_count(page) != 2)) {
+fail_putback:
 		spin_unlock(ptl);
 
 		/* Reverse changes made by migrate_page_copy() */
@@ -1791,16 +1793,34 @@ int migrate_misplaced_transhuge_page(str
 	 */
 	mem_cgroup_prepare_migration(page, new_page, &memcg);
 
+	orig_entry = *pmd;
 	entry = mk_pmd(new_page, vma->vm_page_prot);
-	entry = pmd_mknonnuma(entry);
-	entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
 	entry = pmd_mkhuge(entry);
+	entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
 
+	/*
+	 * Clear the old entry under pagetable lock and establish the new PTE.
+	 * Any parallel GUP will either observe the old page blocking on the
+	 * page lock, block on the page table lock or observe the new page.
+	 * The SetPageUptodate on the new page and page_add_new_anon_rmap
+	 * guarantee the copy is visible before the pagetable update.
+	 */
+	flush_cache_range(vma, haddr, haddr + HPAGE_PMD_SIZE);
+	page_add_new_anon_rmap(new_page, vma, haddr);
 	pmdp_clear_flush(vma, haddr, pmd);
 	set_pmd_at(mm, haddr, pmd, entry);
-	page_add_new_anon_rmap(new_page, vma, haddr);
 	update_mmu_cache_pmd(vma, address, &entry);
+
+	if (page_count(page) != 2) {
+		set_pmd_at(mm, haddr, pmd, orig_entry);
+		flush_tlb_range(vma, haddr, haddr + HPAGE_PMD_SIZE);
+		update_mmu_cache_pmd(vma, address, &entry);
+		page_remove_rmap(new_page);
+		goto fail_putback;
+	}
+
 	page_remove_rmap(page);
+
 	/*
 	 * Finish the charge transaction under the page table lock to
 	 * prevent split_huge_page() from dividing up the charge
@@ -1825,9 +1845,13 @@ int migrate_misplaced_transhuge_page(str
 out_fail:
 	count_vm_events(PGMIGRATE_FAIL, HPAGE_PMD_NR);
 out_dropref:
-	entry = pmd_mknonnuma(entry);
-	set_pmd_at(mm, haddr, pmd, entry);
-	update_mmu_cache_pmd(vma, address, &entry);
+	ptl = pmd_lock(mm, pmd);
+	if (pmd_same(*pmd, entry)) {
+		entry = pmd_mknonnuma(entry);
+		set_pmd_at(mm, haddr, pmd, entry);
+		update_mmu_cache_pmd(vma, address, &entry);
+	}
+	spin_unlock(ptl);
 
 	unlock_page(page);
 	put_page(page);
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-hugetlbfs-add-some-vm_bug_ons-to-catch-non-hugetlbfs-pages.patch
mm-hugetlb-use-get_page_foll-in-follow_hugetlb_page.patch
mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path.patch
mm-thp-optimize-compound_trans_huge.patch
mm-tail-page-refcounting-optimization-for-slab-and-hugetlbfs.patch
mm-hugetlbfs-use-__compound_tail_refcounted-in-__get_page_tail-too.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-hugetlbc-defer-pageheadhuge-symbol-export.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
mm-call-mmu-notifiers-when-copying-a-hugetlb-page-range.patch
mm-show_mem-remove-show_mem_filter_page_count.patch
x86-get-pg_data_ts-memory-from-other-node.patch
memblock-numa-introduce-flags-field-into-memblock.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions.patch
memblock-make-memblock_set_node-support-different-memblock_type.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock.patch
acpi-numa-mem_hotplug-mark-all-nodes-the-kernel-resides-un-hotpluggable.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed.patch
x86-numa-acpi-memory-hotplug-make-movable_node-have-higher-priority.patch
mm-rmap-recompute-pgoff-for-huge-page.patch
mm-rmap-factor-nonlinear-handling-out-of-try_to_unmap_file.patch
mm-rmap-factor-lock-function-out-of-rmap_walk_anon.patch
mm-rmap-make-rmap_walk-to-get-the-rmap_walk_control-argument.patch
mm-rmap-extend-rmap_walk_xxx-to-cope-with-different-cases.patch
mm-rmap-use-rmap_walk-in-try_to_unmap.patch
mm-rmap-use-rmap_walk-in-try_to_munlock.patch
mm-rmap-use-rmap_walk-in-page_referenced.patch
mm-rmap-use-rmap_walk-in-page_mkclean.patch
mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim.patch
mm-numa-serialise-parallel-get_user_page-against-thp-migration.patch
mm-numa-call-mmu-notifiers-on-thp-migration.patch
mm-clear-pmd_numa-before-invalidating.patch
mm-numa-do-not-clear-pmd-during-pte-update-scan.patch
mm-numa-do-not-clear-pte-for-pte_numa-update.patch
mm-numa-ensure-anon_vma-is-locked-to-prevent-parallel-thp-splits.patch
mm-numa-avoid-unnecessary-work-on-the-failure-path.patch
sched-numa-skip-inaccessible-vmas.patch
mm-numa-clear-numa-hinting-information-on-mprotect.patch
mm-numa-avoid-unnecessary-disruption-of-numa-hinting-during-migration.patch
mm-fix-tlb-flush-race-between-migration-and-change_protection_range.patch
mm-numa-defer-tlb-flush-for-thp-migration-as-long-as-possible.patch
mm-numa-make-numa-migrate-related-functions-static.patch
mm-numa-limit-scope-of-lock-for-numa-migrate-rate-limiting.patch
mm-numa-trace-tasks-that-fail-migration-due-to-rate-limiting.patch
mm-numa-do-not-automatically-migrate-ksm-pages.patch
sched-add-tracepoints-related-to-numa-task-migration.patch
linux-next.patch

