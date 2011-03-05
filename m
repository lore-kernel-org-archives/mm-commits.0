From: akpm@linux-foundation.org
Subject: + mm-add-vm-counters-for-transparent-hugepages.patch added to -mm tree
Date: Fri, 04 Mar 2011 16:08:30 -0800
Message-ID: <201103050008.p2508U6M011956@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49735 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759880Ab1CEAIn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2011 19:08:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, aarcange@redhat.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     mm: add VM counters for transparent hugepages
has been added to the -mm tree.  Its filename is
     mm-add-vm-counters-for-transparent-hugepages.patch

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
Subject: mm: add VM counters for transparent hugepages
From: Andi Kleen <ak@linux.intel.com>

I found it difficult to make sense of transparent huge pages without
having any counters for its actions.  Add some counters to vmstat for
allocation of transparent hugepages and fallback to smaller pages.

Optional patch, but useful for development and understanding the system.

Contains improvements from Andrea Arcangeli and Johannes Weiner

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    7 +++++++
 mm/huge_memory.c       |   25 +++++++++++++++++++++----
 mm/vmstat.c            |    8 ++++++++
 3 files changed, 36 insertions(+), 4 deletions(-)

diff -puN include/linux/vmstat.h~mm-add-vm-counters-for-transparent-hugepages include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-add-vm-counters-for-transparent-hugepages
+++ a/include/linux/vmstat.h
@@ -58,6 +58,13 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		UNEVICTABLE_PGCLEARED,	/* on COW, page truncate */
 		UNEVICTABLE_PGSTRANDED,	/* unable to isolate on unlock */
 		UNEVICTABLE_MLOCKFREED,
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	        THP_FAULT_ALLOC,
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
@@ -1780,9 +1786,11 @@ static void collapse_huge_page(struct mm
 				      node, __GFP_OTHER_NODE);
 	if (unlikely(!new_page)) {
 		up_read(&mm->mmap_sem);
+		count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
 		*hpage = ERR_PTR(-ENOMEM);
 		return;
 	}
+	count_vm_event(THP_COLLAPSE_ALLOC);
 #endif
 	if (unlikely(mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))) {
 		up_read(&mm->mmap_sem);
@@ -2147,8 +2155,11 @@ static void khugepaged_do_scan(struct pa
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
@@ -2188,8 +2199,11 @@ static struct page *khugepaged_alloc_hug
 
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
@@ -2206,8 +2220,11 @@ static void khugepaged_loop(void)
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
@@ -946,6 +946,14 @@ static const char * const vmstat_text[] 
 	"unevictable_pgs_stranded",
 	"unevictable_pgs_mlockfreed",
 #endif
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	"thp_fault_alloc",
+	"thp_fault_fallback",
+	"thp_collapse_alloc",
+	"thp_collapse_alloc_failed",
+	"thp_split",
+#endif
 };
 
 static void zoneinfo_show_print(struct seq_file *m, pg_data_t *pgdat,
_

Patches currently in -mm which might be from ak@linux.intel.com are

mm-change-alloc_pages_vma-to-pass-down-the-policy-node-for-local-policy.patch
mm-add-alloc_page_vma_node.patch
mm-preserve-original-node-for-transparent-huge-page-copies.patch
mm-use-correct-numa-policy-node-for-transparent-hugepages.patch
mm-use-correct-numa-policy-node-for-transparent-hugepages-checkpatch-fixes.patch
linux-next.patch
mm-numa-aware-alloc_task_struct_node.patch
mm-numa-aware-alloc_thread_info_node.patch
kthread-numa-aware-kthread_create_on_cpu.patch
kthread-use-kthread_create_on_cpu.patch
mm-add-__gfp_other_node-flag.patch
mm-add-__gfp_other_node-flag-checkpatch-fixes.patch
mm-use-__gfp_other_node-for-transparent-huge-pages.patch
mm-use-__gfp_other_node-for-transparent-huge-pages-checkpatch-fixes.patch
mm-add-vm-counters-for-transparent-hugepages.patch
llist-irq_work-use-llist-in-irq_work.patch
llist-net-rds-replace-xlist-in-net-rds-xlisth-with-llist.patch

