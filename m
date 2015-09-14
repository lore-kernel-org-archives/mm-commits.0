From: akpm@linux-foundation.org
Subject: + mm-make-swapin-readahead-to-improve-thp-collapse-rate.patch
 added to -mm tree
Date: Mon, 14 Sep 2015 14:41:21 -0700
Message-ID: <55f73f01.8PlPm9Ffh/2zD4uc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48716 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbbINVlW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Sep 2015 17:41:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebru.akagunduz@gmail.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, gorcunov@openvz.org, hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, xiexiuqi@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make swapin readahead to improve thp collapse rate
has been added to the -mm tree.  Its filename is
     mm-make-swapin-readahead-to-improve-thp-collapse-rate.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-make-swapin-readahead-to-improve-thp-collapse-rate.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-make-swapin-readahead-to-improve-thp-collapse-rate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Signed-off-by: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Xie XiuQi <xiexiuqi@huawei.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/huge_memory.h |   24 +++++++++++++++
 mm/huge_memory.c                   |   43 +++++++++++++++++++++++++++
 mm/internal.h                      |    4 ++
 mm/memory.c                        |    2 -
 4 files changed, 72 insertions(+), 1 deletion(-)

diff -puN include/trace/events/huge_memory.h~mm-make-swapin-readahead-to-improve-thp-collapse-rate include/trace/events/huge_memory.h
--- a/include/trace/events/huge_memory.h~mm-make-swapin-readahead-to-improve-thp-collapse-rate
+++ a/include/trace/events/huge_memory.h
@@ -136,6 +136,30 @@ TRACE_EVENT(mm_collapse_huge_page_isolat
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
@@ -2584,6 +2584,47 @@ static bool hugepage_vma_check(struct vm
 	return true;
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
+					unsigned long address, pmd_t *pmd,
+					pte_t *pte)
+{
+	unsigned long _address;
+	pte_t pteval = *pte;
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
+
+
 static void collapse_huge_page(struct mm_struct *mm,
 				   unsigned long address,
 				   struct page **hpage,
@@ -2655,6 +2696,8 @@ static void collapse_huge_page(struct mm
 
 	anon_vma_lock_write(vma->anon_vma);
 
+	__collapse_huge_page_swapin(mm, vma, address, pmd, pte);
+
 	pte = pte_offset_map(pmd, address);
 	pte_ptl = pte_lockptr(mm, pmd);
 
diff -puN mm/internal.h~mm-make-swapin-readahead-to-improve-thp-collapse-rate mm/internal.h
--- a/mm/internal.h~mm-make-swapin-readahead-to-improve-thp-collapse-rate
+++ a/mm/internal.h
@@ -14,6 +14,10 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 
+extern int do_swap_page(struct mm_struct *mm, struct vm_area_struct *vma,
+			unsigned long address, pte_t *page_table, pmd_t *pmd,
+			unsigned int flags, pte_t orig_pte);
+
 void free_pgtables(struct mmu_gather *tlb, struct vm_area_struct *start_vma,
 		unsigned long floor, unsigned long ceiling);
 
diff -puN mm/memory.c~mm-make-swapin-readahead-to-improve-thp-collapse-rate mm/memory.c
--- a/mm/memory.c~mm-make-swapin-readahead-to-improve-thp-collapse-rate
+++ a/mm/memory.c
@@ -2441,7 +2441,7 @@ EXPORT_SYMBOL(unmap_mapping_range);
  * We return with the mmap_sem locked or unlocked in the same cases
  * as does filemap_fault().
  */
-static int do_swap_page(struct mm_struct *mm, struct vm_area_struct *vma,
+int do_swap_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		unsigned long address, pte_t *page_table, pmd_t *pmd,
 		unsigned int flags, pte_t orig_pte)
 {
_

Patches currently in -mm which might be from ebru.akagunduz@gmail.com are

mm-add-tracepoint-for-scanning-pages.patch
mm-make-optimistic-check-for-swapin-readahead.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate.patch

