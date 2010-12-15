From: akpm@linux-foundation.org
Subject: + thp-add-numa-awareness-to-hugepage-allocations.patch added to -mm tree
Date: Wed, 15 Dec 2010 15:57:47 -0800
Message-ID: <201012152357.oBFNvlpC013641@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42067 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755885Ab0LOX57 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Dec 2010 18:57:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com


The patch titled
     thp: add numa awareness to hugepage allocations
has been added to the -mm tree.  Its filename is
     thp-add-numa-awareness-to-hugepage-allocations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: add numa awareness to hugepage allocations
From: Andrea Arcangeli <aarcange@redhat.com>

It's mostly a matter of replacing alloc_pages with alloc_pages_vma after
introducing alloc_pages_vma.  khugepaged needs special handling as the
allocation has to happen inside collapse_huge_page where the vma is known
and an error has to be returned to the outer loop to sleep
alloc_sleep_millisecs in case of failure.  But it retains the more
efficient logic of handling allocation failures in khugepaged in case of
CONFIG_NUMA=n.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    7 ++-
 mm/huge_memory.c    |   87 +++++++++++++++++++++++++++++++++++-------
 mm/mempolicy.c      |   13 +++---
 3 files changed, 87 insertions(+), 20 deletions(-)

diff -puN include/linux/gfp.h~thp-add-numa-awareness-to-hugepage-allocations include/linux/gfp.h
--- a/include/linux/gfp.h~thp-add-numa-awareness-to-hugepage-allocations
+++ a/include/linux/gfp.h
@@ -331,14 +331,17 @@ alloc_pages(gfp_t gfp_mask, unsigned int
 {
 	return alloc_pages_current(gfp_mask, order);
 }
-extern struct page *alloc_page_vma(gfp_t gfp_mask,
+extern struct page *alloc_pages_vma(gfp_t gfp_mask, int order,
 			struct vm_area_struct *vma, unsigned long addr);
 #else
 #define alloc_pages(gfp_mask, order) \
 		alloc_pages_node(numa_node_id(), gfp_mask, order)
-#define alloc_page_vma(gfp_mask, vma, addr) alloc_pages(gfp_mask, 0)
+#define alloc_pages_vma(gfp_mask, order, vma, addr)	\
+	alloc_pages(gfp_mask, order)
 #endif
 #define alloc_page(gfp_mask) alloc_pages(gfp_mask, 0)
+#define alloc_page_vma(gfp_mask, vma, addr)	\
+	alloc_pages_vma(gfp_mask, 0, vma, addr)
 
 extern unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order);
 extern unsigned long get_zeroed_page(gfp_t gfp_mask);
diff -puN mm/huge_memory.c~thp-add-numa-awareness-to-hugepage-allocations mm/huge_memory.c
--- a/mm/huge_memory.c~thp-add-numa-awareness-to-hugepage-allocations
+++ a/mm/huge_memory.c
@@ -620,11 +620,26 @@ static int __do_huge_pmd_anonymous_page(
 	return ret;
 }
 
+static inline gfp_t alloc_hugepage_gfpmask(int defrag)
+{
+	return GFP_TRANSHUGE & ~(defrag ? 0 : __GFP_WAIT);
+}
+
+static inline struct page *alloc_hugepage_vma(int defrag,
+					      struct vm_area_struct *vma,
+					      unsigned long haddr)
+{
+	return alloc_pages_vma(alloc_hugepage_gfpmask(defrag),
+			       HPAGE_PMD_ORDER, vma, haddr);
+}
+
+#ifndef CONFIG_NUMA
 static inline struct page *alloc_hugepage(int defrag)
 {
-	return alloc_pages(GFP_TRANSHUGE & ~(defrag ? 0 : __GFP_WAIT),
+	return alloc_pages(alloc_hugepage_gfpmask(defrag),
 			   HPAGE_PMD_ORDER);
 }
+#endif
 
 int do_huge_pmd_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			       unsigned long address, pmd_t *pmd,
@@ -639,7 +654,8 @@ int do_huge_pmd_anonymous_page(struct mm
 			return VM_FAULT_OOM;
 		if (unlikely(khugepaged_enter(vma)))
 			return VM_FAULT_OOM;
-		page = alloc_hugepage(transparent_hugepage_defrag(vma));
+		page = alloc_hugepage_vma(transparent_hugepage_defrag(vma),
+					  vma, haddr);
 		if (unlikely(!page))
 			goto out;
 		if (unlikely(mem_cgroup_newpage_charge(page, mm, GFP_KERNEL))) {
@@ -862,7 +878,8 @@ int do_huge_pmd_wp_page(struct mm_struct
 
 	if (transparent_hugepage_enabled(vma) &&
 	    !transparent_hugepage_debug_cow())
-		new_page = alloc_hugepage(transparent_hugepage_defrag(vma));
+		new_page = alloc_hugepage_vma(transparent_hugepage_defrag(vma),
+					      vma, haddr);
 	else
 		new_page = NULL;
 
@@ -1661,7 +1678,11 @@ static void collapse_huge_page(struct mm
 	unsigned long hstart, hend;
 
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
+#ifndef CONFIG_NUMA
 	VM_BUG_ON(!*hpage);
+#else
+	VM_BUG_ON(*hpage);
+#endif
 
 	/*
 	 * Prevent all access to pagetables with the exception of
@@ -1699,9 +1720,17 @@ static void collapse_huge_page(struct mm
 	if (!pmd_present(*pmd) || pmd_trans_huge(*pmd))
 		goto out;
 
+#ifndef CONFIG_NUMA
 	new_page = *hpage;
-	if (unlikely(mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL)))
+#else
+	new_page = alloc_hugepage_vma(khugepaged_defrag(), vma, address);
+	if (unlikely(!new_page)) {
+		*hpage = ERR_PTR(-ENOMEM);
 		goto out;
+	}
+#endif
+	if (unlikely(mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL)))
+		goto out_put_page;
 
 	anon_vma_lock(vma->anon_vma);
 
@@ -1730,7 +1759,7 @@ static void collapse_huge_page(struct mm
 		spin_unlock(&mm->page_table_lock);
 		anon_vma_unlock(vma->anon_vma);
 		mem_cgroup_uncharge_page(new_page);
-		goto out;
+		goto out_put_page;
 	}
 
 	/*
@@ -1765,10 +1794,19 @@ static void collapse_huge_page(struct mm
 	mm->nr_ptes--;
 	spin_unlock(&mm->page_table_lock);
 
+#ifndef CONFIG_NUMA
 	*hpage = NULL;
+#endif
 	khugepaged_pages_collapsed++;
 out:
 	up_write(&mm->mmap_sem);
+	return;
+
+out_put_page:
+#ifdef CONFIG_NUMA
+	put_page(new_page);
+#endif
+	goto out;
 }
 
 static int khugepaged_scan_pmd(struct mm_struct *mm,
@@ -2001,11 +2039,16 @@ static void khugepaged_do_scan(struct pa
 	while (progress < pages) {
 		cond_resched();
 
+#ifndef CONFIG_NUMA
 		if (!*hpage) {
 			*hpage = alloc_hugepage(khugepaged_defrag());
 			if (unlikely(!*hpage))
 				break;
 		}
+#else
+		if (IS_ERR(*hpage))
+			break;
+#endif
 
 		spin_lock(&khugepaged_mm_lock);
 		if (!khugepaged_scan.mm_slot)
@@ -2020,37 +2063,55 @@ static void khugepaged_do_scan(struct pa
 	}
 }
 
+static void khugepaged_alloc_sleep(void)
+{
+	DEFINE_WAIT(wait);
+	add_wait_queue(&khugepaged_wait, &wait);
+	schedule_timeout_interruptible(
+		msecs_to_jiffies(
+			khugepaged_alloc_sleep_millisecs));
+	remove_wait_queue(&khugepaged_wait, &wait);
+}
+
+#ifndef CONFIG_NUMA
 static struct page *khugepaged_alloc_hugepage(void)
 {
 	struct page *hpage;
 
 	do {
 		hpage = alloc_hugepage(khugepaged_defrag());
-		if (!hpage) {
-			DEFINE_WAIT(wait);
-			add_wait_queue(&khugepaged_wait, &wait);
-			schedule_timeout_interruptible(
-				msecs_to_jiffies(
-					khugepaged_alloc_sleep_millisecs));
-			remove_wait_queue(&khugepaged_wait, &wait);
-		}
+		if (!hpage)
+			khugepaged_alloc_sleep();
 	} while (unlikely(!hpage) &&
 		 likely(khugepaged_enabled()));
 	return hpage;
 }
+#endif
 
 static void khugepaged_loop(void)
 {
 	struct page *hpage;
 
+#ifdef CONFIG_NUMA
+	hpage = NULL;
+#endif
 	while (likely(khugepaged_enabled())) {
+#ifndef CONFIG_NUMA
 		hpage = khugepaged_alloc_hugepage();
 		if (unlikely(!hpage))
 			break;
+#else
+		if (IS_ERR(hpage)) {
+			khugepaged_alloc_sleep();
+			hpage = NULL;
+		}
+#endif
 
 		khugepaged_do_scan(&hpage);
+#ifndef CONFIG_NUMA
 		if (hpage)
 			put_page(hpage);
+#endif
 		if (khugepaged_has_work()) {
 			DEFINE_WAIT(wait);
 			if (!khugepaged_scan_sleep_millisecs)
diff -puN mm/mempolicy.c~thp-add-numa-awareness-to-hugepage-allocations mm/mempolicy.c
--- a/mm/mempolicy.c~thp-add-numa-awareness-to-hugepage-allocations
+++ a/mm/mempolicy.c
@@ -1796,7 +1796,7 @@ static struct page *alloc_page_interleav
 }
 
 /**
- * 	alloc_page_vma	- Allocate a page for a VMA.
+ * 	alloc_pages_vma	- Allocate a page for a VMA.
  *
  * 	@gfp:
  *      %GFP_USER    user allocation.
@@ -1805,6 +1805,7 @@ static struct page *alloc_page_interleav
  *      %GFP_FS      allocation should not call back into a file system.
  *      %GFP_ATOMIC  don't sleep.
  *
+ *	@order:Order of the GFP allocation.
  * 	@vma:  Pointer to VMA or NULL if not available.
  *	@addr: Virtual Address of the allocation. Must be inside the VMA.
  *
@@ -1818,7 +1819,8 @@ static struct page *alloc_page_interleav
  *	Should be called with the mm_sem of the vma hold.
  */
 struct page *
-alloc_page_vma(gfp_t gfp, struct vm_area_struct *vma, unsigned long addr)
+alloc_pages_vma(gfp_t gfp, int order, struct vm_area_struct *vma,
+		unsigned long addr)
 {
 	struct mempolicy *pol = get_vma_policy(current, vma, addr);
 	struct zonelist *zl;
@@ -1830,7 +1832,7 @@ alloc_page_vma(gfp_t gfp, struct vm_area
 
 		nid = interleave_nid(pol, vma, addr, PAGE_SHIFT);
 		mpol_cond_put(pol);
-		page = alloc_page_interleave(gfp, 0, nid);
+		page = alloc_page_interleave(gfp, order, nid);
 		put_mems_allowed();
 		return page;
 	}
@@ -1839,7 +1841,7 @@ alloc_page_vma(gfp_t gfp, struct vm_area
 		/*
 		 * slow path: ref counted shared policy
 		 */
-		struct page *page =  __alloc_pages_nodemask(gfp, 0,
+		struct page *page =  __alloc_pages_nodemask(gfp, order,
 						zl, policy_nodemask(gfp, pol));
 		__mpol_put(pol);
 		put_mems_allowed();
@@ -1848,7 +1850,8 @@ alloc_page_vma(gfp_t gfp, struct vm_area
 	/*
 	 * fast path:  default or task policy
 	 */
-	page = __alloc_pages_nodemask(gfp, 0, zl, policy_nodemask(gfp, pol));
+	page = __alloc_pages_nodemask(gfp, order, zl,
+				      policy_nodemask(gfp, pol));
 	put_mems_allowed();
 	return page;
 }
_

Patches currently in -mm which might be from aarcange@redhat.com are

mm-compaction-add-trace-events-for-memory-compaction-activity.patch
mm-vmscan-convert-lumpy_mode-into-a-bitmask.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mm-migration-cleanup-migrate_pages-api-by-matching-types-for-offlining-and-sync.patch
mm-compaction-perform-a-faster-migration-scan-when-migrating-asynchronously.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode-fix.patch
thp-ksm-free-swap-when-swapcache-page-is-replaced.patch
thp-fix-bad_page-to-show-the-real-reason-the-page-is-bad.patch
thp-transparent-hugepage-support-documentation.patch
thp-mm-define-madv_hugepage.patch
thp-compound_lock.patch
thp-alter-compound-get_page-put_page.patch
thp-put_page-recheck-pagehead-after-releasing-the-compound_lock.patch
thp-update-futex-compound-knowledge.patch
thp-clear-compound-mapping.patch
thp-add-native_set_pmd_at.patch
thp-add-pmd-paravirt-ops.patch
thp-no-paravirt-version-of-pmd-ops.patch
thp-export-maybe_mkwrite.patch
thp-comment-reminder-in-destroy_compound_page.patch
thp-config_transparent_hugepage.patch
thp-special-pmd_trans_-functions.patch
thp-add-pmd-mangling-generic-functions.patch
thp-add-pmd-mangling-functions-to-x86.patch
thp-bail-out-gup_fast-on-splitting-pmd.patch
thp-pte-alloc-trans-splitting.patch
thp-add-pmd-mmu_notifier-helpers.patch
thp-clear-page-compound.patch
thp-add-pmd_huge_pte-to-mm_struct.patch
thp-split_huge_page_mm-vma.patch
thp-split_huge_page-paging.patch
thp-clear_copy_huge_page.patch
thp-_gfp_no_kswapd.patch
thp-dont-alloc-harder-for-gfp-nomemalloc-even-if-nowait.patch
thp-transparent-hugepage-core.patch
thp-split_huge_page-anon_vma-ordering-dependency.patch
thp-verify-pmd_trans_huge-isnt-leaking.patch
thp-madvisemadv_hugepage.patch
thp-add-pagetranscompound.patch
thp-pmd_trans_huge-migrate-bugcheck.patch
thp-memcg-compound.patch
thp-transhuge-memcg-commit-tail-pages-at-charge.patch
thp-memcg-huge-memory.patch
thp-transparent-hugepage-vmstat.patch
thp-khugepaged.patch
thp-khugepaged-vma-merge.patch
thp-skip-transhuge-pages-in-ksm-for-now.patch
thp-remove-pg_buddy.patch
thp-add-x86-32bit-support.patch
thp-mincore-transparent-hugepage-support.patch
thp-add-pmd_modify.patch
thp-mprotect-pass-vma-down-to-page-table-walkers.patch
thp-mprotect-transparent-huge-page-support.patch
thp-set-recommended-min-free-kbytes.patch
thp-enable-direct-defrag.patch
thp-add-numa-awareness-to-hugepage-allocations.patch
thp-allocate-memory-in-khugepaged-outside-of-mmap_sem-write-mode.patch
thp-transparent-hugepage-config-choice.patch
thp-select-config_compaction-if-transparent_hugepage-enabled.patch
thp-transhuge-isolate_migratepages.patch
thp-avoid-breaking-huge-pmd-invariants-in-case-of-vma_adjust-failures.patch
thp-dont-allow-transparent-hugepage-support-without-pse.patch
thp-mmu_notifier_test_young.patch
thp-freeze-khugepaged-and-ksmd.patch
thp-use-compaction-in-kswapd-for-gfp_atomic-order-0.patch
thp-use-compaction-for-all-allocation-orders.patch
thp-disable-transparent-hugepages-by-default-on-small-systems.patch
thp-fix-anon-memory-statistics-with-transparent-hugepages.patch
thp-scale-nr_rotated-to-balance-memory-pressure.patch
thp-transparent-hugepage-sysfs-meminfo.patch
thp-add-debug-checks-for-mapcount-related-invariants.patch
thp-fix-memory-failure-hugetlbfs-vs-thp-collision.patch
thp-compound_trans_order.patch
thp-mm-define-madv_nohugepage.patch
thp-madvisemadv_nohugepage.patch

