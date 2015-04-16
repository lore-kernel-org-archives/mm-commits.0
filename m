From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp.patch removed
 from -mm tree
Date: Thu, 16 Apr 2015 09:51:42 -0700
Message-ID: <552fe89e.JBK+GrHyUFG/to3K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42643 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbbDPQqN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:46:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, hannes@cmpxchg.org, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memcg: sync allocation and memcg charge gfp flags for THP
has been removed from the -mm tree.  Its filename was
     mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: mm, memcg: sync allocation and memcg charge gfp flags for THP

memcg currently uses hardcoded GFP_TRANSHUGE gfp flags for all THP
charges.  THP allocations, however, might be using different flags
depending on /sys/kernel/mm/transparent_hugepage/{,khugepaged/}defrag and
the current allocation context.

The primary difference is that defrag configured to "madvise" value will
clear __GFP_WAIT flag from the core gfp mask to make the allocation
lighter for all mappings which are not backed by VM_HUGEPAGE vmas.  If
memcg charge path ignores this fact we will get light allocation but the a
potential memcg reclaim would kill the whole point of the configuration.

Fix the mismatch by providing the same gfp mask used for the allocation to
the charge functions.  This is quite easy for all paths except for
hugepaged kernel thread with !CONFIG_NUMA which is doing a pre-allocation
long before the allocated page is used in collapse_huge_page via
khugepaged_alloc_page.  To prevent from cluttering the whole code path
from khugepaged_do_scan we simply return the current flags as per
khugepaged_defrag() value which might have changed since the
preallocation.  If somebody changed the value of the knob we would charge
differently but this shouldn't happen often and it is definitely not
critical because it would only lead to a reduced success rate of one-off
THP promotion.

[akpm@linux-foundation.org: fix weird code layout while we're there]
[rientjes@google.com: clean up around alloc_hugepage_gfpmask()]
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   42 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff -puN mm/huge_memory.c~mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp mm/huge_memory.c
--- a/mm/huge_memory.c~mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp
+++ a/mm/huge_memory.c
@@ -708,7 +708,7 @@ static inline pmd_t mk_huge_pmd(struct p
 static int __do_huge_pmd_anonymous_page(struct mm_struct *mm,
 					struct vm_area_struct *vma,
 					unsigned long haddr, pmd_t *pmd,
-					struct page *page)
+					struct page *page, gfp_t gfp)
 {
 	struct mem_cgroup *memcg;
 	pgtable_t pgtable;
@@ -716,7 +716,7 @@ static int __do_huge_pmd_anonymous_page(
 
 	VM_BUG_ON_PAGE(!PageCompound(page), page);
 
-	if (mem_cgroup_try_charge(page, mm, GFP_TRANSHUGE, &memcg))
+	if (mem_cgroup_try_charge(page, mm, gfp, &memcg))
 		return VM_FAULT_OOM;
 
 	pgtable = pte_alloc_one(mm, haddr);
@@ -822,7 +822,7 @@ int do_huge_pmd_anonymous_page(struct mm
 		count_vm_event(THP_FAULT_FALLBACK);
 		return VM_FAULT_FALLBACK;
 	}
-	if (unlikely(__do_huge_pmd_anonymous_page(mm, vma, haddr, pmd, page))) {
+	if (unlikely(__do_huge_pmd_anonymous_page(mm, vma, haddr, pmd, page, gfp))) {
 		put_page(page);
 		count_vm_event(THP_FAULT_FALLBACK);
 		return VM_FAULT_FALLBACK;
@@ -1080,6 +1080,7 @@ int do_huge_pmd_wp_page(struct mm_struct
 	unsigned long haddr;
 	unsigned long mmun_start;	/* For mmu_notifiers */
 	unsigned long mmun_end;		/* For mmu_notifiers */
+	gfp_t huge_gfp;			/* for allocation and charge */
 
 	ptl = pmd_lockptr(mm, pmd);
 	VM_BUG_ON_VMA(!vma->anon_vma, vma);
@@ -1106,10 +1107,8 @@ int do_huge_pmd_wp_page(struct mm_struct
 alloc:
 	if (transparent_hugepage_enabled(vma) &&
 	    !transparent_hugepage_debug_cow()) {
-		gfp_t gfp;
-
-		gfp = alloc_hugepage_gfpmask(transparent_hugepage_defrag(vma), 0);
-		new_page = alloc_hugepage_vma(gfp, vma, haddr, HPAGE_PMD_ORDER);
+		huge_gfp = alloc_hugepage_gfpmask(transparent_hugepage_defrag(vma), 0);
+		new_page = alloc_hugepage_vma(huge_gfp, vma, haddr, HPAGE_PMD_ORDER);
 	} else
 		new_page = NULL;
 
@@ -1130,8 +1129,7 @@ alloc:
 		goto out;
 	}
 
-	if (unlikely(mem_cgroup_try_charge(new_page, mm,
-					   GFP_TRANSHUGE, &memcg))) {
+	if (unlikely(mem_cgroup_try_charge(new_page, mm, huge_gfp, &memcg))) {
 		put_page(new_page);
 		if (page) {
 			split_huge_page(page);
@@ -2323,19 +2321,13 @@ static bool khugepaged_prealloc_page(str
 	return true;
 }
 
-static struct page
-*khugepaged_alloc_page(struct page **hpage, struct mm_struct *mm,
+static struct page *
+khugepaged_alloc_page(struct page **hpage, gfp_t gfp, struct mm_struct *mm,
 		       struct vm_area_struct *vma, unsigned long address,
 		       int node)
 {
-	gfp_t flags;
-
 	VM_BUG_ON_PAGE(*hpage, *hpage);
 
-	/* Only allocate from the target node */
-	flags = alloc_hugepage_gfpmask(khugepaged_defrag(), __GFP_OTHER_NODE) |
-	        __GFP_THISNODE;
-
 	/*
 	 * Before allocating the hugepage, release the mmap_sem read lock.
 	 * The allocation can take potentially a long time if it involves
@@ -2344,7 +2336,7 @@ static struct page
 	 */
 	up_read(&mm->mmap_sem);
 
-	*hpage = alloc_pages_exact_node(node, flags, HPAGE_PMD_ORDER);
+	*hpage = alloc_pages_exact_node(node, gfp, HPAGE_PMD_ORDER);
 	if (unlikely(!*hpage)) {
 		count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
 		*hpage = ERR_PTR(-ENOMEM);
@@ -2397,13 +2389,14 @@ static bool khugepaged_prealloc_page(str
 	return true;
 }
 
-static struct page
-*khugepaged_alloc_page(struct page **hpage, struct mm_struct *mm,
+static struct page *
+khugepaged_alloc_page(struct page **hpage, gfp_t gfp, struct mm_struct *mm,
 		       struct vm_area_struct *vma, unsigned long address,
 		       int node)
 {
 	up_read(&mm->mmap_sem);
 	VM_BUG_ON(!*hpage);
+
 	return  *hpage;
 }
 #endif
@@ -2438,16 +2431,21 @@ static void collapse_huge_page(struct mm
 	struct mem_cgroup *memcg;
 	unsigned long mmun_start;	/* For mmu_notifiers */
 	unsigned long mmun_end;		/* For mmu_notifiers */
+	gfp_t gfp;
 
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 
+	/* Only allocate from the target node */
+	gfp = alloc_hugepage_gfpmask(khugepaged_defrag(), __GFP_OTHER_NODE) |
+		__GFP_THISNODE;
+
 	/* release the mmap_sem read lock. */
-	new_page = khugepaged_alloc_page(hpage, mm, vma, address, node);
+	new_page = khugepaged_alloc_page(hpage, gfp, mm, vma, address, node);
 	if (!new_page)
 		return;
 
 	if (unlikely(mem_cgroup_try_charge(new_page, mm,
-					   GFP_TRANSHUGE, &memcg)))
+					   gfp, &memcg)))
 		return;
 
 	/*
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-reclaimable-pages.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
fork-report-pid-reservation-failure-properly.patch
linux-next.patch
cxgb4-drop-__gfp_nofail-allocation.patch

