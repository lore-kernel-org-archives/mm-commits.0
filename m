From: akpm@linux-foundation.org
Subject: + mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem.patch
 added to -mm tree
Date: Fri, 27 May 2016 13:07:06 -0700
Message-ID: <5748a8ea.4J6NG9wqvsJZutiE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43963 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756519AbcE0UHH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 16:07:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebru.akagunduz@gmail.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, gorcunov@openvz.org, hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.cz, minchan.kim@gmail.com, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, thp: make swapin readahead under down_read of mmap_sem
has been added to the -mm tree.  Its filename is
     mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem.patch

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
Subject: mm, thp: make swapin readahead under down_read of mmap_sem

Currently khugepaged makes swapin readahead under down_write.  This patch
supplies to make swapin readahead under down_read instead of down_write.

The patch was tested with a test program that allocates 800MB of memory,
writes to it, and then sleeps.  The system was forced to swap out all. 
Afterwards, the test program touches the area by writing, it skips a page
in each 20 pages of the area.

Link: http://lkml.kernel.org/r/1464335964-6510-4-git-send-email-ebru.akagunduz@gmail.com
Signed-off-by: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   97 ++++++++++++++++++++++++++++++---------------
 1 file changed, 66 insertions(+), 31 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem
+++ a/mm/huge_memory.c
@@ -2379,6 +2379,35 @@ static bool hugepage_vma_check(struct vm
 }
 
 /*
+ * If mmap_sem temporarily dropped, revalidate vma
+ * before taking mmap_sem.
+ * Return 0 if succeeds, otherwise return none-zero
+ * value (scan code).
+ */
+
+static int hugepage_vma_revalidate(struct mm_struct *mm,
+				   struct vm_area_struct *vma,
+				   unsigned long address)
+{
+	unsigned long hstart, hend;
+
+	if (unlikely(khugepaged_test_exit(mm)))
+		return SCAN_ANY_PROCESS;
+
+	vma = find_vma(mm, address);
+	if (!vma)
+		return SCAN_VMA_NULL;
+
+	hstart = (vma->vm_start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
+	hend = vma->vm_end & HPAGE_PMD_MASK;
+	if (address < hstart || address + HPAGE_PMD_SIZE > hend)
+		return SCAN_ADDRESS_RANGE;
+	if (!hugepage_vma_check(vma))
+		return SCAN_VMA_CHECK;
+	return 0;
+}
+
+/*
  * Bring missing pages in from swap, to complete THP collapse.
  * Only done if khugepaged_scan_pmd believes it is worthwhile.
  *
@@ -2386,7 +2415,7 @@ static bool hugepage_vma_check(struct vm
  * but with mmap_sem held to protect against vma changes.
  */
 
-static void __collapse_huge_page_swapin(struct mm_struct *mm,
+static bool __collapse_huge_page_swapin(struct mm_struct *mm,
 					struct vm_area_struct *vma,
 					unsigned long address, pmd_t *pmd)
 {
@@ -2402,11 +2431,18 @@ static void __collapse_huge_page_swapin(
 			continue;
 		swapped_in++;
 		ret = do_swap_page(mm, vma, _address, pte, pmd,
-				   FAULT_FLAG_ALLOW_RETRY|FAULT_FLAG_RETRY_NOWAIT,
+				   FAULT_FLAG_ALLOW_RETRY,
 				   pteval);
+		/* do_swap_page returns VM_FAULT_RETRY with released mmap_sem */
+		if (ret & VM_FAULT_RETRY) {
+			down_read(&mm->mmap_sem);
+			/* vma is no longer available, don't continue to swapin */
+			if (hugepage_vma_revalidate(mm, vma, address))
+				return false;
+		}
 		if (ret & VM_FAULT_ERROR) {
 			trace_mm_collapse_huge_page_swapin(mm, swapped_in, 0);
-			return;
+			return false;
 		}
 		/* pte is unmapped now, we need to map it */
 		pte = pte_offset_map(pmd, _address);
@@ -2414,6 +2450,7 @@ static void __collapse_huge_page_swapin(
 	pte--;
 	pte_unmap(pte);
 	trace_mm_collapse_huge_page_swapin(mm, swapped_in, 1);
+	return true;
 }
 
 static void collapse_huge_page(struct mm_struct *mm,
@@ -2428,7 +2465,7 @@ static void collapse_huge_page(struct mm
 	struct page *new_page;
 	spinlock_t *pmd_ptl, *pte_ptl;
 	int isolated = 0, result = 0;
-	unsigned long hstart, hend, swap, curr_allocstall;
+	unsigned long swap, curr_allocstall;
 	struct mem_cgroup *memcg;
 	unsigned long mmun_start;	/* For mmu_notifiers */
 	unsigned long mmun_end;		/* For mmu_notifiers */
@@ -2453,33 +2490,11 @@ static void collapse_huge_page(struct mm
 
 	swap = get_mm_counter(mm, MM_SWAPENTS);
 	curr_allocstall = sum_vm_event(ALLOCSTALL);
-
-	/*
-	 * Prevent all access to pagetables with the exception of
-	 * gup_fast later hanlded by the ptep_clear_flush and the VM
-	 * handled by the anon_vma lock + PG_lock.
-	 */
-	down_write(&mm->mmap_sem);
-	if (unlikely(khugepaged_test_exit(mm))) {
-		result = SCAN_ANY_PROCESS;
+	down_read(&mm->mmap_sem);
+	result = hugepage_vma_revalidate(mm, vma, address);
+	if (result)
 		goto out;
-	}
 
-	vma = find_vma(mm, address);
-	if (!vma) {
-		result = SCAN_VMA_NULL;
-		goto out;
-	}
-	hstart = (vma->vm_start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
-	hend = vma->vm_end & HPAGE_PMD_MASK;
-	if (address < hstart || address + HPAGE_PMD_SIZE > hend) {
-		result = SCAN_ADDRESS_RANGE;
-		goto out;
-	}
-	if (!hugepage_vma_check(vma)) {
-		result = SCAN_VMA_CHECK;
-		goto out;
-	}
 	pmd = mm_find_pmd(mm, address);
 	if (!pmd) {
 		result = SCAN_PMD_NULL;
@@ -2490,8 +2505,28 @@ static void collapse_huge_page(struct mm
 	 * Don't perform swapin readahead when the system is under pressure,
 	 * to avoid unnecessary resource consumption.
 	 */
-	if (allocstall == curr_allocstall && swap != 0)
-		__collapse_huge_page_swapin(mm, vma, address, pmd);
+	if (allocstall == curr_allocstall && swap != 0) {
+		/*
+		 * __collapse_huge_page_swapin always returns with mmap_sem
+		 * locked. If it fails, release mmap_sem and jump directly
+		 * label out. Continuing to collapse causes inconsistency.
+		 */
+		if (!__collapse_huge_page_swapin(mm, vma, address, pmd)) {
+			up_read(&mm->mmap_sem);
+			goto out;
+		}
+	}
+
+	up_read(&mm->mmap_sem);
+	/*
+	 * Prevent all access to pagetables with the exception of
+	 * gup_fast later hanlded by the ptep_clear_flush and the VM
+	 * handled by the anon_vma lock + PG_lock.
+	 */
+	down_write(&mm->mmap_sem);
+	result = hugepage_vma_revalidate(mm, vma, address);
+	if (result)
+		goto out;
 
 	anon_vma_lock_write(vma->anon_vma);
 
_

Patches currently in -mm which might be from ebru.akagunduz@gmail.com are

mm-make-optimistic-check-for-swapin-readahead.patch
mm-make-optimistic-check-for-swapin-readahead-fix-3.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate.patch
mm-vmstat-calculate-particular-vm-event.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix-2.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem.patch

