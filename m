From: akpm@linux-foundation.org
Subject: - mm-report-the-pagesize-backing-a-vma-in-proc-pid-smaps.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:11:00 -0800
Message-ID: <200901072211.n07MB02r011329@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50972 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752599AbZAGWLP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:11:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, adobriyan@gmail.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm: report the pagesize backing a VMA in /proc/pid/smaps
has been removed from the -mm tree.  Its filename was
     mm-report-the-pagesize-backing-a-vma-in-proc-pid-smaps.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: report the pagesize backing a VMA in /proc/pid/smaps
From: Mel Gorman <mel@csn.ul.ie>

It is useful to verify a hugepage-aware application is using the expected
pagesizes for its memory regions. This patch creates an entry called
KernelPageSize in /proc/pid/smaps that is the size of page used by the
kernel to back a VMA. The entry is not called PageSize as it is possible
the MMU uses a different size. This extension should not break any sensible
parser that skips lines containing unrecognised information.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c      |    6 ++++--
 include/linux/hugetlb.h |    3 +++
 mm/hugetlb.c            |   16 ++++++++++++++++
 3 files changed, 23 insertions(+), 2 deletions(-)

diff -puN fs/proc/task_mmu.c~mm-report-the-pagesize-backing-a-vma-in-proc-pid-smaps fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-report-the-pagesize-backing-a-vma-in-proc-pid-smaps
+++ a/fs/proc/task_mmu.c
@@ -396,7 +396,8 @@ static int show_smap(struct seq_file *m,
 		   "Private_Clean:  %8lu kB\n"
 		   "Private_Dirty:  %8lu kB\n"
 		   "Referenced:     %8lu kB\n"
-		   "Swap:           %8lu kB\n",
+		   "Swap:           %8lu kB\n"
+		   "KernelPageSize: %8lu kB\n",
 		   (vma->vm_end - vma->vm_start) >> 10,
 		   mss.resident >> 10,
 		   (unsigned long)(mss.pss >> (10 + PSS_SHIFT)),
@@ -405,7 +406,8 @@ static int show_smap(struct seq_file *m,
 		   mss.private_clean >> 10,
 		   mss.private_dirty >> 10,
 		   mss.referenced >> 10,
-		   mss.swap >> 10);
+		   mss.swap >> 10,
+		   vma_kernel_pagesize(vma) >> 10);
 
 	if (m->count < m->size)  /* vma is copied successfully */
 		m->version = (vma != get_gate_vma(task)) ? vma->vm_start : 0;
diff -puN include/linux/hugetlb.h~mm-report-the-pagesize-backing-a-vma-in-proc-pid-smaps include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-report-the-pagesize-backing-a-vma-in-proc-pid-smaps
+++ a/include/linux/hugetlb.h
@@ -233,6 +233,8 @@ static inline unsigned long huge_page_si
 	return (unsigned long)PAGE_SIZE << h->order;
 }
 
+extern unsigned long vma_kernel_pagesize(struct vm_area_struct *vma);
+
 static inline unsigned long huge_page_mask(struct hstate *h)
 {
 	return h->mask;
@@ -273,6 +275,7 @@ struct hstate {};
 #define hstate_inode(i) NULL
 #define huge_page_size(h) PAGE_SIZE
 #define huge_page_mask(h) PAGE_MASK
+#define vma_kernel_pagesize(v) PAGE_SIZE
 #define huge_page_order(h) 0
 #define huge_page_shift(h) PAGE_SHIFT
 static inline unsigned int pages_per_huge_page(struct hstate *h)
diff -puN mm/hugetlb.c~mm-report-the-pagesize-backing-a-vma-in-proc-pid-smaps mm/hugetlb.c
--- a/mm/hugetlb.c~mm-report-the-pagesize-backing-a-vma-in-proc-pid-smaps
+++ a/mm/hugetlb.c
@@ -220,6 +220,22 @@ static pgoff_t vma_hugecache_offset(stru
 }
 
 /*
+ * Return the size of the pages allocated when backing a VMA. In the majority
+ * cases this will be same size as used by the page table entries.
+ */
+unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
+{
+	struct hstate *hstate;
+
+	if (!is_vm_hugetlb_page(vma))
+		return PAGE_SIZE;
+
+	hstate = hstate_vma(vma);
+
+	return 1UL << (hstate->order + PAGE_SHIFT);
+}
+
+/*
  * Flags for MAP_PRIVATE reservations.  These are stored in the bottom
  * bits of the reservation map pointer, which are always clear due to
  * alignment.
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
add-debugging-aid-for-memory-initialisation-problems.patch

