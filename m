From: akpm@linux-foundation.org
Subject: + usb-mon-nopage.patch added to -mm tree
Date: Wed, 05 Dec 2007 14:45:06 -0800
Message-ID: <200712052245.lB5Mj6Vh028901@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36090 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752331AbXLEWpu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Dec 2007 17:45:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, greg@kroah.com, zaitcev@redhat.com


The patch titled
     usb: mon nopage
has been added to the -mm tree.  Its filename is
     usb-mon-nopage.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: usb: mon nopage
From: Nick Piggin <npiggin@suse.de>

Convert USB mon driver from nopage to fault.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Acked-by: Pete Zaitcev <zaitcev@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/mon/mon_bin.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff -puN drivers/usb/mon/mon_bin.c~usb-mon-nopage drivers/usb/mon/mon_bin.c
--- a/drivers/usb/mon/mon_bin.c~usb-mon-nopage
+++ a/drivers/usb/mon/mon_bin.c
@@ -1047,33 +1047,31 @@ static void mon_bin_vma_close(struct vm_
 /*
  * Map ring pages to user space.
  */
-struct page *mon_bin_vma_nopage(struct vm_area_struct *vma,
-                                unsigned long address, int *type)
+static int mon_bin_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct mon_reader_bin *rp = vma->vm_private_data;
 	unsigned long offset, chunk_idx;
 	struct page *pageptr;
 
-	offset = (address - vma->vm_start) + (vma->vm_pgoff << PAGE_SHIFT);
+	offset = vmf->pgoff << PAGE_SHIFT;
 	if (offset >= rp->b_size)
-		return NOPAGE_SIGBUS;
+		return VM_FAULT_SIGBUS;
 	chunk_idx = offset / CHUNK_SIZE;
 	pageptr = rp->b_vec[chunk_idx].pg;
 	get_page(pageptr);
-	if (type)
-		*type = VM_FAULT_MINOR;
-	return pageptr;
+	vmf->page = pageptr;
+	return 0;
 }
 
 struct vm_operations_struct mon_bin_vm_ops = {
 	.open =     mon_bin_vma_open,
 	.close =    mon_bin_vma_close,
-	.nopage =   mon_bin_vma_nopage,
+	.fault =    mon_bin_vma_fault,
 };
 
 int mon_bin_mmap(struct file *filp, struct vm_area_struct *vma)
 {
-	/* don't do anything here: "nopage" will set up page table entries */
+	/* don't do anything here: "fault" will set up page table entries */
 	vma->vm_ops = &mon_bin_vm_ops;
 	vma->vm_flags |= VM_RESERVED;
 	vma->vm_private_data = filp->private_data;
_

Patches currently in -mm which might be from npiggin@suse.de are

mm-fix-xip-file-writes.patch
git-jfs.patch
nfs-use-gfp_nofs-preloads-for-radix-tree-insertion.patch
slub-use-non-atomic-bit-unlock.patch
radix-tree-avoid-atomic-allocations-for-preloaded-insertions.patch
mm-dont-allow-ioremapping-of-ranges-larger-than-vmalloc-space.patch
vt-bitlock-fix.patch
radix_treeh-trivial-comment-correction.patch
inotify-fix-race.patch
inotify-remove-debug-code.patch
rewrite-rd.patch
rewrite-rd-fix.patch
rd-support-xip.patch
reiser4.patch
ia64-ia32-nopage.patch
relay-nopage.patch
uio-nopage.patch
ieee1394-nopage.patch
v4l-nopage.patch
fb-defio-nopage.patch
agp-alpha-nopage.patch
sg-nopage.patch
ib-nopage.patch
usb-mon-nopage.patch
alsa-nopage.patch
alsa-usx2y-nopage.patch
mm-special-mapping-nopage.patch
