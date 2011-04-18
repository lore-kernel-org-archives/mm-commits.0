From: akpm@linux-foundation.org
Subject: [merged] mm-add-vm-counters-for-transparent-hugepages.patch removed from -mm tree
Date: Mon, 18 Apr 2011 11:02:46 -0700
Message-ID: <201104181758.p3IHwvBR016099@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42775 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756173Ab1DRR7j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Apr 2011 13:59:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, aarcange@redhat.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm: add VM counters for transparent hugepages
has been removed from the -mm tree.  Its filename was
     mm-add-vm-counters-for-transparent-hugepages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: add VM counters for transparent hugepages
From: Andi Kleen <ak@linux.intel.com>

I found it difficult to make sense of transparent huge pages without
having any counters for its actions.  Add some counters to vmstat for
allocation of transparent hugepages and fallback to smaller pages.

Optional patch, but useful for development and understanding the system.

Contains improvements from Andrea Arcangeli and Johannes Weiner

[akpm@linux-foundation.org: coding-style fixes]
[hannes@cmpxchg.org: fix vmstat_text[] entries]
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    7 +++++++
 mm/huge_memory.c       |   25 +++++++++++++++++++++----
 mm/vmstat.c            |    9 +++++++++
 3 files changed, 37 insertions(+), 4 deletions(-)

diff -puN include/linux/vmstat.h~mm-add-vm-counters-for-transparent-hugepages include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-add-vm-counters-for-transparent-hugepages
+++ a/include/linux/vmstat.h
@@ -58,6 +58,13 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		UNEVICTABLE_PGCLEARED,	/* on COW, page truncate */
 		UNEVICTABLE_PGSTRANDED,	/* unable to isolate on unlock */
 		UNEVICTABLE_MLOCKFREED,
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+		THP_FAULT_ALLOC,
+		THP_FAULT_FALLBACK,
+		THP_COLLAPSE_ALLOC,
+		THP_COLLAPSE_ALLOC_FAILED,
+		THP_SPLIT,
+#endif
 		NR_VM_EVENT_ITEMS
 };
 
diff -puN mm/huge_memory.c~mm-add-vm-counters-for-transparent-hugepages mm/huge_memory.c
--- a/mm/huge_memory.c~mm-add-vm-counters-for-transparent-hugepages
+++ a/mm/huge_memory.c
@@ -680,8 +680,11 @@ int do_huge_pmd_anonymous_page(struct mm
 			return VM_FAULT_OOM;
 		page = alloc_hugepage_vma(transparent_hugepage_defrag(vma),
 					  vma, haddr, numa_node_id(), 0);
-		if (unlikely(!page))
+		if (unlikely(!page)) {
+			count_vm_event(THP_FAULT_FALLBACK);
 			goto out;
+		}
+		count_vm_event(THP_FAULT_ALLOC);
 		if (unlikely(mem_cgroup_newpage_charge(page, mm, GFP_KERNEL))) {
 			put_page(page);
 			goto out;
@@ -909,11 +912,13 @@ int do_huge_pmd_wp_page(struct mm_struct
 		new_page = NULL;
 
 	if (unlikely(!new_page)) {
+		count_vm_event(THP_FAULT_FALLBACK);
 		ret = do_huge_pmd_wp_page_fallback(mm, vma, address,
 						   pmd, orig_pmd, page, haddr);
 		put_page(page);
 		goto out;
 	}
+	count_vm_event(THP_FAULT_ALLOC);
 
 	if (unlikely(mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))) {
 		put_page(new_page);
@@ -1390,6 +1395,7 @@ int split_huge_page(struct page *page)
 
 	BUG_ON(!PageSwapBacked(page));
 	__split_huge_page(page, anon_vma);
+	count_vm_event(THP_SPLIT);
 
 	BUG_ON(PageCompound(page));
 out_unlock:
@@ -1784,9 +1790,11 @@ static void collapse_huge_page(struct mm
 				      node, __GFP_OTHER_NODE);
 	if (unlikely(!new_page)) {
 		up_read(&mm->mmap_sem);
+		count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
 		*hpage = ERR_PTR(-ENOMEM);
 		return;
 	}
+	count_vm_event(THP_COLLAPSE_ALLOC);
 	if (unlikely(mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))) {
 		up_read(&mm->mmap_sem);
 		put_page(new_page);
@@ -2151,8 +2159,11 @@ static void khugepaged_do_scan(struct pa
 #ifndef CONFIG_NUMA
 		if (!*hpage) {
 			*hpage = alloc_hugepage(khugepaged_defrag());
-			if (unlikely(!*hpage))
+			if (unlikely(!*hpage)) {
+				count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
 				break;
+			}
+			count_vm_event(THP_COLLAPSE_ALLOC);
 		}
 #else
 		if (IS_ERR(*hpage))
@@ -2192,8 +2203,11 @@ static struct page *khugepaged_alloc_hug
 
 	do {
 		hpage = alloc_hugepage(khugepaged_defrag());
-		if (!hpage)
+		if (!hpage) {
+			count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
 			khugepaged_alloc_sleep();
+		} else
+			count_vm_event(THP_COLLAPSE_ALLOC);
 	} while (unlikely(!hpage) &&
 		 likely(khugepaged_enabled()));
 	return hpage;
@@ -2210,8 +2224,11 @@ static void khugepaged_loop(void)
 	while (likely(khugepaged_enabled())) {
 #ifndef CONFIG_NUMA
 		hpage = khugepaged_alloc_hugepage();
-		if (unlikely(!hpage))
+		if (unlikely(!hpage)) {
+			count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
 			break;
+		}
+		count_vm_event(THP_COLLAPSE_ALLOC);
 #else
 		if (IS_ERR(hpage)) {
 			khugepaged_alloc_sleep();
diff -puN mm/vmstat.c~mm-add-vm-counters-for-transparent-hugepages mm/vmstat.c
--- a/mm/vmstat.c~mm-add-vm-counters-for-transparent-hugepages
+++ a/mm/vmstat.c
@@ -948,7 +948,16 @@ static const char * const vmstat_text[] 
 	"unevictable_pgs_cleared",
 	"unevictable_pgs_stranded",
 	"unevictable_pgs_mlockfreed",
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	"thp_fault_alloc",
+	"thp_fault_fallback",
+	"thp_collapse_alloc",
+	"thp_collapse_alloc_failed",
+	"thp_split",
 #endif
+
+#endif /* CONFIG_VM_EVENTS_COUNTERS */
 };
 
 static void zoneinfo_show_print(struct seq_file *m, pg_data_t *pgdat,
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch

