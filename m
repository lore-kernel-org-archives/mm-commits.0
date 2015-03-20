From: akpm@linux-foundation.org
Subject: +
 mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp.patch added to
 -mm tree
Date: Fri, 20 Mar 2015 16:11:17 -0700
Message-ID: <550ca915.bxTNuo1HenKNs6xz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54393 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbbCTXLS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Mar 2015 19:11:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, hannes@cmpxchg.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memcg: sync allocation and memcg charge gfp flags for THP
has been added to the -mm tree.  Its filename is
     mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

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
 
@@ -1131,7 +1130,7 @@ alloc:
 	}
 
 	if (unlikely(mem_cgroup_try_charge(new_page, mm,
-					   GFP_TRANSHUGE, &memcg))) {
+					   huge_gfp, &memcg))) {
 		put_page(new_page);
 		if (page) {
 			split_huge_page(page);
@@ -2325,16 +2324,14 @@ static bool khugepaged_prealloc_page(str
 }
 
 static struct page
-*khugepaged_alloc_page(struct page **hpage, struct mm_struct *mm,
+*khugepaged_alloc_page(struct page **hpage, gfp_t *gfp, struct mm_struct *mm,
 		       struct vm_area_struct *vma, unsigned long address,
 		       int node)
 {
-	gfp_t flags;
-
 	VM_BUG_ON_PAGE(*hpage, *hpage);
 
 	/* Only allocate from the target node */
-	flags = alloc_hugepage_gfpmask(khugepaged_defrag(), __GFP_OTHER_NODE) |
+	*gfp = alloc_hugepage_gfpmask(khugepaged_defrag(), __GFP_OTHER_NODE) |
 	        __GFP_THISNODE;
 
 	/*
@@ -2345,7 +2342,7 @@ static struct page
 	 */
 	up_read(&mm->mmap_sem);
 
-	*hpage = alloc_pages_exact_node(node, flags, HPAGE_PMD_ORDER);
+	*hpage = alloc_pages_exact_node(node, *gfp, HPAGE_PMD_ORDER);
 	if (unlikely(!*hpage)) {
 		count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
 		*hpage = ERR_PTR(-ENOMEM);
@@ -2399,12 +2396,18 @@ static bool khugepaged_prealloc_page(str
 }
 
 static struct page
-*khugepaged_alloc_page(struct page **hpage, struct mm_struct *mm,
+*khugepaged_alloc_page(struct page **hpage, gfp_t *gfp, struct mm_struct *mm,
 		       struct vm_area_struct *vma, unsigned long address,
 		       int node)
 {
 	up_read(&mm->mmap_sem);
 	VM_BUG_ON(!*hpage);
+
+	/*
+	 * khugepaged_alloc_hugepage is doing the preallocation, use the same
+	 * gfp flags here.
+	 */
+	*gfp = alloc_hugepage_gfpmask(khugepaged_defrag(), 0);
 	return  *hpage;
 }
 #endif
@@ -2439,16 +2442,17 @@ static void collapse_huge_page(struct mm
 	struct mem_cgroup *memcg;
 	unsigned long mmun_start;	/* For mmu_notifiers */
 	unsigned long mmun_end;		/* For mmu_notifiers */
+	gfp_t gfp;
 
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 
 	/* release the mmap_sem read lock. */
-	new_page = khugepaged_alloc_page(hpage, mm, vma, address, node);
+	new_page = khugepaged_alloc_page(hpage, &gfp, mm, vma, address, node);
 	if (!new_page)
 		return;
 
 	if (unlikely(mem_cgroup_try_charge(new_page, mm,
-					   GFP_TRANSHUGE, &memcg)))
+					   gfp, &memcg)))
 		return;
 
 	/*
_

Patches currently in -mm which might be from mhocko@suse.cz are

mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention.patch
mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention-v2.patch
cxgb4-drop-__gfp_nofail-allocation.patch
cxgb4-drop-__gfp_nofail-allocation-fix.patch
jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
mm-memcontrol-update-copyright-notice.patch
mm-cma-release-trigger-fixpatch.patch
mm-hide-per-cpu-lists-in-output-of-show_mem.patch
mm-completely-remove-dumping-per-cpu-lists-from-show_mem.patch
mm-refactor-do_wp_page-extract-the-reuse-case.patch
mm-refactor-do_wp_page-rewrite-the-unlock-flow.patch
mm-refactor-do_wp_page-extract-the-page-copy-flow.patch
mm-refactor-do_wp_page-handling-of-shared-vma-into-a-function.patch
mm-clarify-__gfp_nofail-deprecation-status.patch
mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes.patch
sparc-clarify-__gfp_nofail-allocation.patch
mm-memcontrol-let-mem_cgroup_move_account-have-effect-only-if-mmu-enabled.patch
memcg-print-cgroup-information-when-system-panics-due-to-panic_on_oom.patch
memcg-zap-mem_cgroup_lookup.patch
memcg-remove-obsolete-comment.patch
mm-consolidate-all-page-flags-helpers-in-linux-page-flagsh.patch
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
allow-compaction-of-unevictable-pages.patch
mm-change-deactivate_page-with-deactivate_file_page.patch
mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp.patch
mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list.patch
fork-report-pid-reservation-failure-properly.patch

