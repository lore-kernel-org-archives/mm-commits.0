From: akpm@linux-foundation.org
Subject: - convert-hugetlbfs-to-use-vm_ops-fault.patch removed from -mm tree
Date: Thu, 12 Jul 2007 13:23:36 -0700
Message-ID: <200707122023.l6CKNapt032499@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32898 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756599AbXGLUYd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jul 2007 16:24:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agl@us.ibm.com, bill.irwin@oracle.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     "Convert" hugetlbfs to use vm_ops->fault()
has been removed from the -mm tree.  Its filename was
     convert-hugetlbfs-to-use-vm_ops-fault.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
Subject: "Convert" hugetlbfs to use vm_ops->fault()
From: Adam Litke <agl@us.ibm.com>

I discovered that 2.6.21-rc5-mm1 was oopsing my box when running the
libhugetlbfs test suite.  The trouble led me once again to shm stacked
files ;-) The stacked mmap function is labeling the lack of a ->fault()
vm_op a BUG() which is probably a good idea.  It isn't really a problem for
hugetlbfs though, since our faults are handled by an explicit hook in
__handle_mm_fault().  Rather than removing the BUG(), just convert the
hugetlbfs ->nopage() placeholder to a ->fault() one which helps us get one
step closer to removing the nopage vm_op anyway.

Signed-off-by: Adam Litke <agl@us.ibm.com>
Acked-by: Nick Piggin <nickpiggin@yahoo.com.au>
Acked-by: Bill Irwin <bill.irwin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN mm/hugetlb.c~convert-hugetlbfs-to-use-vm_ops-fault mm/hugetlb.c
--- a/mm/hugetlb.c~convert-hugetlbfs-to-use-vm_ops-fault
+++ a/mm/hugetlb.c
@@ -287,20 +287,19 @@ unsigned long hugetlb_total_pages(void)
 }
 
 /*
- * We cannot handle pagefaults against hugetlb pages at all.  They cause
- * handle_mm_fault() to try to instantiate regular-sized pages in the
- * hugegpage VMA.  do_page_fault() is supposed to trap this, so BUG is we get
- * this far.
+ * Hugetlb faults are serviced in __handle_mm_fault by explicitly calling
+ * hugetlb_fault.  Therefore the vm_ops->fault() op for hugetlb pages
+ * should never be called.
  */
-static struct page *hugetlb_nopage(struct vm_area_struct *vma,
-				unsigned long address, int *unused)
+static struct page *hugetlb_vm_op_fault(struct vm_area_struct *vma,
+					struct fault_data *fdata)
 {
 	BUG();
 	return NULL;
 }
 
 struct vm_operations_struct hugetlb_vm_ops = {
-	.nopage = hugetlb_nopage,
+	.fault = hugetlb_vm_op_fault,
 };
 
 static pte_t make_huge_pte(struct vm_area_struct *vma, struct page *page,
_

Patches currently in -mm which might be from agl@us.ibm.com are

hugetlbfs-use-lib-parser-fix-docs.patch
