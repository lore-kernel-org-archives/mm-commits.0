From: akpm@linux-foundation.org
Subject: [patch 084/126] mm, thp: make swapin readahead under down_read of mmap_sem
Date: Tue, 26 Jul 2016 15:25:06 -0700
Message-ID: <5797e342.U6cCno3CSNzVwVVY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56994 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758482AbcGZWZH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:25:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, ebru.akagunduz@gmail.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, gorcunov@openvz.org, hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.cz, minchan.kim@gmail.com, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, vbabka@suse.cz

From: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Subject: mm, thp: make swapin readahead under down_read of mmap_sem

Currently khugepaged makes swapin readahead under down_write.  This patch
supplies to make swapin readahead under down_read instead of down_write.

The patch was tested with a test program that allocates 800MB of memory,
writes to it, and then sleeps.  The system was forced to swap out all.
Afterwards, the test program touches the area by writing, it skips a page
in each 20 pages of the area.

[akpm@linux-foundation.org: update comment to match new code]
[kirill.shutemov@linux.intel.com: passing 'vma' to hugepage_vma_revlidate() is useless]
  Link: http://lkml.kernel.org/r/20160530095058.GA53044@black.fi.intel.com
  Link: http://lkml.kernel.org/r/1466021202-61880-3-git-send-email-kirill.shutemov@linux.intel.com
Link: http://lkml.kernel.org/r/1464335964-6510-4-git-send-email-ebru.akagunduz@gmail.com
Link: http://lkml.kernel.org/r/1466021202-61880-2-git-send-email-kirill.shutemov@linux.intel.com
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

 mm/huge_memory.c |   91 ++++++++++++++++++++++++++++++---------------
 1 file changed, 62 insertions(+), 29 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-ks mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-ks
+++ a/mm/huge_memory.c
@@ -2374,6 +2374,34 @@ static bool hugepage_vma_check(struct vm
 }
 
 /*
+ * If mmap_sem temporarily dropped, revalidate vma
+ * before taking mmap_sem.
+ * Return 0 if succeeds, otherwise return none-zero
+ * value (scan code).
+ */
+
+static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address)
+{
+	struct vm_area_struct *vma;
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
@@ -2381,7 +2409,7 @@ static bool hugepage_vma_check(struct vm
  * but with mmap_sem held to protect against vma changes.
  */
 
-static void __collapse_huge_page_swapin(struct mm_struct *mm,
+static bool __collapse_huge_page_swapin(struct mm_struct *mm,
 					struct vm_area_struct *vma,
 					unsigned long address, pmd_t *pmd)
 {
@@ -2397,11 +2425,18 @@ static void __collapse_huge_page_swapin(
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
+			if (hugepage_vma_revalidate(mm, address))
+				return false;
+		}
 		if (ret & VM_FAULT_ERROR) {
 			trace_mm_collapse_huge_page_swapin(mm, swapped_in, 0);
-			return;
+			return false;
 		}
 		/* pte is unmapped now, we need to map it */
 		pte = pte_offset_map(pmd, _address);
@@ -2409,6 +2444,7 @@ static void __collapse_huge_page_swapin(
 	pte--;
 	pte_unmap(pte);
 	trace_mm_collapse_huge_page_swapin(mm, swapped_in, 1);
+	return true;
 }
 
 static void collapse_huge_page(struct mm_struct *mm,
@@ -2423,7 +2459,6 @@ static void collapse_huge_page(struct mm
 	struct page *new_page;
 	spinlock_t *pmd_ptl, *pte_ptl;
 	int isolated = 0, result = 0;
-	unsigned long hstart, hend;
 	struct mem_cgroup *memcg;
 	unsigned long mmun_start;	/* For mmu_notifiers */
 	unsigned long mmun_end;		/* For mmu_notifiers */
@@ -2446,39 +2481,37 @@ static void collapse_huge_page(struct mm
 		goto out_nolock;
 	}
 
-	/*
-	 * Prevent all access to pagetables with the exception of
-	 * gup_fast later hanlded by the ptep_clear_flush and the VM
-	 * handled by the anon_vma lock + PG_lock.
-	 */
-	down_write(&mm->mmap_sem);
-	if (unlikely(khugepaged_test_exit(mm))) {
-		result = SCAN_ANY_PROCESS;
+	down_read(&mm->mmap_sem);
+	result = hugepage_vma_revalidate(mm, address);
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
 		goto out;
 	}
 
-	__collapse_huge_page_swapin(mm, vma, address, pmd);
+	/*
+	 * __collapse_huge_page_swapin always returns with mmap_sem locked.
+	 * If it fails, release mmap_sem and jump directly out.
+	 * Continuing to collapse causes inconsistency.
+	 */
+	if (!__collapse_huge_page_swapin(mm, vma, address, pmd)) {
+		up_read(&mm->mmap_sem);
+		goto out;
+	}
+
+	up_read(&mm->mmap_sem);
+	/*
+	 * Prevent all access to pagetables with the exception of
+	 * gup_fast later handled by the ptep_clear_flush and the VM
+	 * handled by the anon_vma lock + PG_lock.
+	 */
+	down_write(&mm->mmap_sem);
+	result = hugepage_vma_revalidate(mm, address);
+	if (result)
+		goto out;
 
 	anon_vma_lock_write(vma->anon_vma);
 
_
