From: akpm@linux-foundation.org
Subject: [merged]
 khugepaged-fix-use-after-free-in-collapse_huge_page.patch removed from -mm
 tree
Date: Tue, 20 Sep 2016 12:30:23 -0700
Message-ID: <57e18e4f.ODPp5J15U8hio3BE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48651 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752320AbcITTaY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 20 Sep 2016 15:30:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, dvyukov@google.com, ebru.akagunduz@gmail.com, glider@google.com, gthelen@google.com, hannes@cmpxchg.org, hughd@google.com, kcc@google.com, koct9i@gmail.com, levinsasha928@gmail.com, mgorman@techsingularity.net, rientjes@google.com, ryabinin.a.a@gmail.com, suleiman@google.com, syzkaller@googlegroups.com, vbabka@suse.cz, vegard.nossum@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: khugepaged: fix use-after-free in collapse_huge_page()
has been removed from the -mm tree.  Its filename was
     khugepaged-fix-use-after-free-in-collapse_huge_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: khugepaged: fix use-after-free in collapse_huge_page()

hugepage_vma_revalidate() tries to re-check if we still should try to
collapse small pages into huge one after the re-acquiring mmap_sem.

The problem Dmitry Vyukov reported[1] is that the vma found by
hugepage_vma_revalidate() can be suitable for huge pages, but not the same
vma we had before dropping mmap_sem.  And dereferencing original vma can
lead to fun results..

Let's use vma hugepage_vma_revalidate() found instead of assuming it's the
same as what we had before the lock was dropped.  [1]
http://lkml.kernel.org/r/CACT4Y+Z3gigBvhca9kRJFcjX0G70V_nRhbwKBU+yGoESBDKi9Q@mail.gmail.com

Link: http://lkml.kernel.org/r/20160907122559.GA6542@black.fi.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Sasha Levin <levinsasha928@gmail.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: syzkaller <syzkaller@googlegroups.com>
Cc: Kostya Serebryany <kcc@google.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN mm/khugepaged.c~khugepaged-fix-use-after-free-in-collapse_huge_page mm/khugepaged.c
--- a/mm/khugepaged.c~khugepaged-fix-use-after-free-in-collapse_huge_page
+++ a/mm/khugepaged.c
@@ -838,7 +838,8 @@ static bool hugepage_vma_check(struct vm
  * value (scan code).
  */
 
-static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address)
+static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
+		struct vm_area_struct **vmap)
 {
 	struct vm_area_struct *vma;
 	unsigned long hstart, hend;
@@ -846,7 +847,7 @@ static int hugepage_vma_revalidate(struc
 	if (unlikely(khugepaged_test_exit(mm)))
 		return SCAN_ANY_PROCESS;
 
-	vma = find_vma(mm, address);
+	*vmap = vma = find_vma(mm, address);
 	if (!vma)
 		return SCAN_VMA_NULL;
 
@@ -898,7 +899,7 @@ static bool __collapse_huge_page_swapin(
 		/* do_swap_page returns VM_FAULT_RETRY with released mmap_sem */
 		if (ret & VM_FAULT_RETRY) {
 			down_read(&mm->mmap_sem);
-			if (hugepage_vma_revalidate(mm, address)) {
+			if (hugepage_vma_revalidate(mm, address, &fe.vma)) {
 				/* vma is no longer available, don't continue to swapin */
 				trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, 0);
 				return false;
@@ -923,7 +924,6 @@ static bool __collapse_huge_page_swapin(
 static void collapse_huge_page(struct mm_struct *mm,
 				   unsigned long address,
 				   struct page **hpage,
-				   struct vm_area_struct *vma,
 				   int node, int referenced)
 {
 	pmd_t *pmd, _pmd;
@@ -933,6 +933,7 @@ static void collapse_huge_page(struct mm
 	spinlock_t *pmd_ptl, *pte_ptl;
 	int isolated = 0, result = 0;
 	struct mem_cgroup *memcg;
+	struct vm_area_struct *vma;
 	unsigned long mmun_start;	/* For mmu_notifiers */
 	unsigned long mmun_end;		/* For mmu_notifiers */
 	gfp_t gfp;
@@ -961,7 +962,7 @@ static void collapse_huge_page(struct mm
 	}
 
 	down_read(&mm->mmap_sem);
-	result = hugepage_vma_revalidate(mm, address);
+	result = hugepage_vma_revalidate(mm, address, &vma);
 	if (result) {
 		mem_cgroup_cancel_charge(new_page, memcg, true);
 		up_read(&mm->mmap_sem);
@@ -994,7 +995,7 @@ static void collapse_huge_page(struct mm
 	 * handled by the anon_vma lock + PG_lock.
 	 */
 	down_write(&mm->mmap_sem);
-	result = hugepage_vma_revalidate(mm, address);
+	result = hugepage_vma_revalidate(mm, address, &vma);
 	if (result)
 		goto out;
 	/* check if the pmd is still valid */
@@ -1202,7 +1203,7 @@ out_unmap:
 	if (ret) {
 		node = khugepaged_find_target_node();
 		/* collapse_huge_page will return with the mmap_sem released */
-		collapse_huge_page(mm, address, hpage, vma, node, referenced);
+		collapse_huge_page(mm, address, hpage, node, referenced);
 	}
 out:
 	trace_mm_khugepaged_scan_pmd(mm, page, writable, referenced,
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are


