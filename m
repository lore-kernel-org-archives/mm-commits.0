From: akpm@linux-foundation.org
Subject: - hugepage-support-zero_page.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:33:56 -0700
Message-ID: <200810202033.m9KKXu1s010736@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33613 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754725AbYJTUrI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:47:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, agl@us.ibm.com, hidehiro.kawai.ez@hitachi.com, hugh@veritas.com, mel@skynet.ie, mm-commits@vger.kernel.org


The patch titled
     hugepage: support ZERO_PAGE()
has been removed from the -mm tree.  Its filename was
     hugepage-support-zero_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugepage: support ZERO_PAGE()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Presently hugepage doesn't use zero page at all because zero page is only
used for coredumping and hugepage can't core dump.

However we have now implemented hugepage coredumping.  Therefore we should
implement the zero page of hugepage.

Implementation note:

o Why do we only check VM_SHARED for zero page?
  normal page checked as ..

	static inline int use_zero_page(struct vm_area_struct *vma)
	{
	        if (vma->vm_flags & (VM_LOCKED | VM_SHARED))
	                return 0;

	        return !vma->vm_ops || !vma->vm_ops->fault;
	}

First, hugepages are never mlock()ed.  We aren't concerned with VM_LOCKED.

Second, hugetlbfs is a pseudo filesystem, not a real filesystem and it
doesn't have any file backing.  Thus ops->fault checking is meaningless.

o Why don't we use zero page if !pte.

!pte indicate {pud, pmd} doesn't exist or some error happened.  So we
shouldn't return zero page if any error occurred.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Kawai Hidehiro <hidehiro.kawai.ez@hitachi.com>
Cc: Mel Gorman <mel@skynet.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff -puN mm/hugetlb.c~hugepage-support-zero_page mm/hugetlb.c
--- a/mm/hugetlb.c~hugepage-support-zero_page
+++ a/mm/hugetlb.c
@@ -2071,6 +2071,14 @@ follow_huge_pud(struct mm_struct *mm, un
 	return NULL;
 }
 
+static int huge_zeropage_ok(pte_t *ptep, int write, int shared)
+{
+	if (!ptep || write || shared)
+		return 0;
+	else
+		return huge_pte_none(huge_ptep_get(ptep));
+}
+
 int follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			struct page **pages, struct vm_area_struct **vmas,
 			unsigned long *position, int *length, int i,
@@ -2080,6 +2088,8 @@ int follow_hugetlb_page(struct mm_struct
 	unsigned long vaddr = *position;
 	int remainder = *length;
 	struct hstate *h = hstate_vma(vma);
+	int zeropage_ok = 0;
+	int shared = vma->vm_flags & VM_SHARED;
 
 	spin_lock(&mm->page_table_lock);
 	while (vaddr < vma->vm_end && remainder) {
@@ -2092,8 +2102,11 @@ int follow_hugetlb_page(struct mm_struct
 		 * first, for the page indexing below to work.
 		 */
 		pte = huge_pte_offset(mm, vaddr & huge_page_mask(h));
+		if (huge_zeropage_ok(pte, write, shared))
+			zeropage_ok = 1;
 
-		if (!pte || huge_pte_none(huge_ptep_get(pte)) ||
+		if (!pte ||
+		    (huge_pte_none(huge_ptep_get(pte)) && !zeropage_ok) ||
 		    (write && !pte_write(huge_ptep_get(pte)))) {
 			int ret;
 
@@ -2113,8 +2126,11 @@ int follow_hugetlb_page(struct mm_struct
 		page = pte_page(huge_ptep_get(pte));
 same_page:
 		if (pages) {
-			get_page(page);
-			pages[i] = page + pfn_offset;
+			if (zeropage_ok)
+				pages[i] = ZERO_PAGE(0);
+			else
+				pages[i] = page + pfn_offset;
+			get_page(pages[i]);
 		}
 
 		if (vmas)
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch

