From: akpm@linux-foundation.org
Subject: + mspec-convert-nopfn-to-fault.patch added to -mm tree
Date: Mon, 05 May 2008 13:20:45 -0700
Message-ID: <200805052020.m45KKjis003080@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41972 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757047AbYEEUVU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2008 16:21:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, jes@sgi.com


The patch titled
     mspec: convert nopfn to fault
has been added to the -mm tree.  Its filename is
     mspec-convert-nopfn-to-fault.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mspec: convert nopfn to fault
From: Nick Piggin <npiggin@suse.de>

Signed-off-by: Nick Piggin <npiggin@suse.de>
Acked-by: Jes Sorensen <jes@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mspec.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff -puN drivers/char/mspec.c~mspec-convert-nopfn-to-fault drivers/char/mspec.c
--- a/drivers/char/mspec.c~mspec-convert-nopfn-to-fault
+++ a/drivers/char/mspec.c
@@ -193,25 +193,24 @@ mspec_close(struct vm_area_struct *vma)
 }
 
 /*
- * mspec_nopfn
+ * mspec_fault
  *
  * Creates a mspec page and maps it to user space.
  */
-static unsigned long
-mspec_nopfn(struct vm_area_struct *vma, unsigned long address)
+static int
+mspec_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	unsigned long paddr, maddr;
 	unsigned long pfn;
+	pgoff_t index = vmf->pgoff;
 	int index;
 	struct vma_data *vdata = vma->vm_private_data;
 
-	BUG_ON(address < vdata->vm_start || address >= vdata->vm_end);
-	index = (address - vdata->vm_start) >> PAGE_SHIFT;
 	maddr = (volatile unsigned long) vdata->maddr[index];
 	if (maddr == 0) {
 		maddr = uncached_alloc_page(numa_node_id(), 1);
 		if (maddr == 0)
-			return NOPFN_OOM;
+			return VM_FAULT_OOM;
 
 		spin_lock(&vdata->lock);
 		if (vdata->maddr[index] == 0) {
@@ -231,13 +230,20 @@ mspec_nopfn(struct vm_area_struct *vma, 
 
 	pfn = paddr >> PAGE_SHIFT;
 
-	return pfn;
+	/*
+	 * vm_insert_pfn can fail with -EBUSY, but in that case it will
+	 * be because another thread has installed the pte first, so it
+	 * is no problem.
+	 */
+	vm_insert_pfn(vma, (unsigned long)vmf->virtual_address, pfn);
+
+	return VM_FAULT_NOPAGE;
 }
 
 static struct vm_operations_struct mspec_vm_ops = {
 	.open = mspec_open,
 	.close = mspec_close,
-	.nopfn = mspec_nopfn
+	.fault = mspec_fault,
 };
 
 /*
_

Patches currently in -mm which might be from npiggin@suse.de are

linux-next.patch
mm-allow-pfnmap-faults.patch
mspec-convert-nopfn-to-fault.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

