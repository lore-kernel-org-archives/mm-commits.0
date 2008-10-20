From: akpm@linux-foundation.org
Subject: + mm-report-the-mmu-pagesize-in-proc-pid-smaps.patch added to -mm tree
Date: Mon, 20 Oct 2008 14:42:36 -0700
Message-ID: <200810202142.m9KLgbgA023115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752590AbYJTVmo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 17:42:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, adobriyan@gmail.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     mm: report the MMU pagesize in /proc/pid/smaps
has been added to the -mm tree.  Its filename is
     mm-report-the-mmu-pagesize-in-proc-pid-smaps.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: report the MMU pagesize in /proc/pid/smaps
From: Mel Gorman <mel@csn.ul.ie>

The KernelPageSize entry in /proc/pid/smaps is the pagesize used by the
kernel to back a VMA.  This matches the size used by the MMU in the
majority of cases.  However, one counter-example occurs on PPC64 kernels
whereby a kernel using 64K as a base pagesize may still use 4K pages for
the MMU on older processor.  To distinguish, this patch reports
MMUPageSize as the pagesize used by the MMU in /proc/pid/smaps.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/hugetlb.h |    6 ++++++
 arch/powerpc/mm/hugetlbpage.c      |    7 +++++++
 fs/proc/task_mmu.c                 |    6 ++++--
 include/linux/hugetlb.h            |    3 +++
 mm/hugetlb.c                       |   13 +++++++++++++
 5 files changed, 33 insertions(+), 2 deletions(-)

diff -puN arch/powerpc/include/asm/hugetlb.h~mm-report-the-mmu-pagesize-in-proc-pid-smaps arch/powerpc/include/asm/hugetlb.h
--- a/arch/powerpc/include/asm/hugetlb.h~mm-report-the-mmu-pagesize-in-proc-pid-smaps
+++ a/arch/powerpc/include/asm/hugetlb.h
@@ -18,6 +18,12 @@ pte_t huge_ptep_get_and_clear(struct mm_
 			      pte_t *ptep);
 
 /*
+ * The version of vma_mmu_pagesize() in arch/powerpc/mm/hugetlbpage.c needs
+ * to override the version in mm/hugetlb.c
+ */
+#define vma_mmu_pagesize vma_mmu_pagesize
+
+/*
  * If the arch doesn't supply something else, assume that hugepage
  * size aligned regions are ok without further preparation.
  */
diff -puN arch/powerpc/mm/hugetlbpage.c~mm-report-the-mmu-pagesize-in-proc-pid-smaps arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~mm-report-the-mmu-pagesize-in-proc-pid-smaps
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -510,6 +510,13 @@ unsigned long hugetlb_get_unmapped_area(
 	return slice_get_unmapped_area(addr, len, flags, mmu_psize, 1, 0);
 }
 
+unsigned long vma_mmu_pagesize(struct vm_area_struct *vma)
+{
+	unsigned int psize = get_slice_psize(vma->vm_mm, vma->vm_start);
+
+	return 1UL << mmu_psize_to_shift(psize);
+}
+
 /*
  * Called by asm hashtable.S for doing lazy icache flush
  */
diff -puN fs/proc/task_mmu.c~mm-report-the-mmu-pagesize-in-proc-pid-smaps fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-report-the-mmu-pagesize-in-proc-pid-smaps
+++ a/fs/proc/task_mmu.c
@@ -397,7 +397,8 @@ static int show_smap(struct seq_file *m,
 		   "Private_Dirty:  %8lu kB\n"
 		   "Referenced:     %8lu kB\n"
 		   "Swap:           %8lu kB\n"
-		   "KernelPageSize: %8lu kB\n",
+		   "KernelPageSize: %8lu kB\n"
+		   "MMUPageSize:    %8lu kB\n",
 		   (vma->vm_end - vma->vm_start) >> 10,
 		   mss.resident >> 10,
 		   (unsigned long)(mss.pss >> (10 + PSS_SHIFT)),
@@ -407,7 +408,8 @@ static int show_smap(struct seq_file *m,
 		   mss.private_dirty >> 10,
 		   mss.referenced >> 10,
 		   mss.swap >> 10,
-		   vma_kernel_pagesize(vma) >> 10);
+		   vma_kernel_pagesize(vma) >> 10,
+		   vma_mmu_pagesize(vma) >> 10);
 
 	if (m->count < m->size)  /* vma is copied successfully */
 		m->version = (vma != get_gate_vma(task)) ? vma->vm_start : 0;
diff -puN include/linux/hugetlb.h~mm-report-the-mmu-pagesize-in-proc-pid-smaps include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-report-the-mmu-pagesize-in-proc-pid-smaps
+++ a/include/linux/hugetlb.h
@@ -235,6 +235,8 @@ static inline unsigned long huge_page_si
 
 extern unsigned long vma_kernel_pagesize(struct vm_area_struct *vma);
 
+extern unsigned long vma_mmu_pagesize(struct vm_area_struct *vma);
+
 static inline unsigned long huge_page_mask(struct hstate *h)
 {
 	return h->mask;
@@ -276,6 +278,7 @@ struct hstate {};
 #define huge_page_size(h) PAGE_SIZE
 #define huge_page_mask(h) PAGE_MASK
 #define vma_kernel_pagesize(v) PAGE_SIZE
+#define vma_mmu_pagesize(v) PAGE_SIZE
 #define huge_page_order(h) 0
 #define huge_page_shift(h) PAGE_SHIFT
 static inline unsigned int pages_per_huge_page(struct hstate *h)
diff -puN mm/hugetlb.c~mm-report-the-mmu-pagesize-in-proc-pid-smaps mm/hugetlb.c
--- a/mm/hugetlb.c~mm-report-the-mmu-pagesize-in-proc-pid-smaps
+++ a/mm/hugetlb.c
@@ -236,6 +236,19 @@ unsigned long vma_kernel_pagesize(struct
 }
 
 /*
+ * Return the page size being used by the MMU to back a VMA. In the majority
+ * of cases, the page size used by the kernel matches the MMU size. On
+ * architectures where it differs, an architecture-specific version of this
+ * function is required.
+ */
+#ifndef vma_mmu_pagesize
+unsigned long vma_mmu_pagesize(struct vm_area_struct *vma)
+{
+	return vma_kernel_pagesize(vma);
+}
+#endif
+
+/*
  * Flags for MAP_PRIVATE reservations.  These are stored in the bottom
  * bits of the reservation map pointer, which are always clear due to
  * alignment.
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
mm-report-the-pagesize-backing-a-vma-in-proc-pid-smaps.patch
mm-report-the-mmu-pagesize-in-proc-pid-smaps.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch

