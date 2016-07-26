From: akpm@linux-foundation.org
Subject: [patch 083/126] mm: make swapin readahead to improve thp collapse rate
Date: Tue, 26 Jul 2016 15:25:03 -0700
Message-ID: <5797e33f.rByQrwAtQgICDhU8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56981 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758511AbcGZWZE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:25:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, ebru.akagunduz@gmail.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, gorcunov@openvz.org, hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, xiexiuqi@huawei.com

From: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Subject: mm: make swapin readahead to improve thp collapse rate

This patch makes swapin readahead to improve thp collapse rate.  When
khugepaged scanned pages, there can be a few of the pages in swap area.

With the patch THP can collapse 4kB pages into a THP when there are up to
max_ptes_swap swap ptes in a 2MB range.

The patch was tested with a test program that allocates 400B of memory,
writes to it, and then sleeps.  I force the system to swap out all. 
Afterwards, the test program touches the area by writing, it skips a page
in each 20 pages of the area.

Without the patch, system did not swap in readahead.  THP rate was %65 of
the program of the memory, it did not change over time.

With this patch, after 10 minutes of waiting khugepaged had collapsed %99
of the program's memory.

[kirill.shutemov@linux.intel.com: trivial cleanup of exit path of the function]
[kirill.shutemov@linux.intel.com: __collapse_huge_page_swapin(): drop unused 'pte' parameter]
[kirill.shutemov@linux.intel.com: do not hold anon_vma lock during swap in]
Signed-off-by: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Xie XiuQi <xiexiuqi@huawei.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/huge_memory.h |   24 +++++++++++++++
 mm/huge_memory.c                   |   43 +++++++++++++++++++++++++--
 mm/internal.h                      |    4 ++
 mm/memory.c                        |    2 -
 4 files changed, 69 insertions(+), 4 deletions(-)

diff -puN include/trace/events/huge_memory.h~mm-make-swapin-readahead-to-improve-thp-collapse-rate include/trace/events/huge_memory.h
--- a/include/trace/events/huge_memory.h~mm-make-swapin-readahead-to-improve-thp-collapse-rate
+++ a/include/trace/events/huge_memory.h
@@ -135,5 +135,29 @@ TRACE_EVENT(mm_collapse_huge_page_isolat
 		__print_symbolic(__entry->status, SCAN_STATUS))
 );
 
+TRACE_EVENT(mm_collapse_huge_page_swapin,
+
+	TP_PROTO(struct mm_struct *mm, int swapped_in, int ret),
+
+	TP_ARGS(mm, swapped_in, ret),
+
+	TP_STRUCT__entry(
+		__field(struct mm_struct *, mm)
+		__field(int, swapped_in)
+		__field(int, ret)
+	),
+
+	TP_fast_assign(
+		__entry->mm = mm;
+		__entry->swapped_in = swapped_in;
+		__entry->ret = ret;
+	),
+
+	TP_printk("mm=%p, swapped_in=%d, ret=%d",
+		__entry->mm,
+		__entry->swapped_in,
+		__entry->ret)
+);
+
 #endif /* __HUGE_MEMORY_H */
 #include <trace/define_trace.h>
diff -puN mm/huge_memory.c~mm-make-swapin-readahead-to-improve-thp-collapse-rate mm/huge_memory.c
--- a/mm/huge_memory.c~mm-make-swapin-readahead-to-improve-thp-collapse-rate
+++ a/mm/huge_memory.c
@@ -2373,6 +2373,44 @@ static bool hugepage_vma_check(struct vm
 	return !(vma->vm_flags & VM_NO_THP);
 }
 
+/*
+ * Bring missing pages in from swap, to complete THP collapse.
+ * Only done if khugepaged_scan_pmd believes it is worthwhile.
+ *
+ * Called and returns without pte mapped or spinlocks held,
+ * but with mmap_sem held to protect against vma changes.
+ */
+
+static void __collapse_huge_page_swapin(struct mm_struct *mm,
+					struct vm_area_struct *vma,
+					unsigned long address, pmd_t *pmd)
+{
+	unsigned long _address;
+	pte_t *pte, pteval;
+	int swapped_in = 0, ret = 0;
+
+	pte = pte_offset_map(pmd, address);
+	for (_address = address; _address < address + HPAGE_PMD_NR*PAGE_SIZE;
+	     pte++, _address += PAGE_SIZE) {
+		pteval = *pte;
+		if (!is_swap_pte(pteval))
+			continue;
+		swapped_in++;
+		ret = do_swap_page(mm, vma, _address, pte, pmd,
+				   FAULT_FLAG_ALLOW_RETRY|FAULT_FLAG_RETRY_NOWAIT,
+				   pteval);
+		if (ret & VM_FAULT_ERROR) {
+			trace_mm_collapse_huge_page_swapin(mm, swapped_in, 0);
+			return;
+		}
+		/* pte is unmapped now, we need to map it */
+		pte = pte_offset_map(pmd, _address);
+	}
+	pte--;
+	pte_unmap(pte);
+	trace_mm_collapse_huge_page_swapin(mm, swapped_in, 1);
+}
+
 static void collapse_huge_page(struct mm_struct *mm,
 				   unsigned long address,
 				   struct page **hpage,
@@ -2440,6 +2478,8 @@ static void collapse_huge_page(struct mm
 		goto out;
 	}
 
+	__collapse_huge_page_swapin(mm, vma, address, pmd);
+
 	anon_vma_lock_write(vma->anon_vma);
 
 	pte = pte_offset_map(pmd, address);
@@ -2516,9 +2556,6 @@ static void collapse_huge_page(struct mm
 	result = SCAN_SUCCEED;
 out_up_write:
 	up_write(&mm->mmap_sem);
-	trace_mm_collapse_huge_page(mm, isolated, result);
-	return;
-
 out_nolock:
 	trace_mm_collapse_huge_page(mm, isolated, result);
 	return;
diff -puN mm/internal.h~mm-make-swapin-readahead-to-improve-thp-collapse-rate mm/internal.h
--- a/mm/internal.h~mm-make-swapin-readahead-to-improve-thp-collapse-rate
+++ a/mm/internal.h
@@ -36,6 +36,10 @@
 /* Do not use these with a slab allocator */
 #define GFP_SLAB_BUG_MASK (__GFP_DMA32|__GFP_HIGHMEM|~__GFP_BITS_MASK)
 
+extern int do_swap_page(struct mm_struct *mm, struct vm_area_struct *vma,
+			unsigned long address, pte_t *page_table, pmd_t *pmd,
+			unsigned int flags, pte_t orig_pte);
+
 void free_pgtables(struct mmu_gather *tlb, struct vm_area_struct *start_vma,
 		unsigned long floor, unsigned long ceiling);
 
diff -puN mm/memory.c~mm-make-swapin-readahead-to-improve-thp-collapse-rate mm/memory.c
--- a/mm/memory.c~mm-make-swapin-readahead-to-improve-thp-collapse-rate
+++ a/mm/memory.c
@@ -2522,7 +2522,7 @@ EXPORT_SYMBOL(unmap_mapping_range);
  * We return with the mmap_sem locked or unlocked in the same cases
  * as does filemap_fault().
  */
-static int do_swap_page(struct mm_struct *mm, struct vm_area_struct *vma,
+int do_swap_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		unsigned long address, pte_t *page_table, pmd_t *pmd,
 		unsigned int flags, pte_t orig_pte)
 {
_
