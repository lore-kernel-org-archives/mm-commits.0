From: akpm@linux-foundation.org
Subject: - usb-mon-nopage.patch removed from -mm tree
Date: Fri, 21 Dec 2007 14:08:52 -0800
Message-ID: <200712212208.lBLM8qIJ001733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41502 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756591AbXLUWKF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Dec 2007 17:10:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, greg@kroah.com, zaitcev@redhat.com, mm-commits@vger.kernel.org


The patch titled
     usb: mon nopage
has been removed from the -mm tree.  Its filename was
     usb-mon-nopage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-alsa.patch
git-dvb.patch
git-ieee1394.patch
git-infiniband.patch
git-jfs.patch
git-kvm.patch
nfs-use-gfp_nofs-preloads-for-radix-tree-insertion.patch
git-sched.patch
sg-nopage.patch
git-x86.patch
slub-use-non-atomic-bit-unlock.patch
tmpfs-shuffle-add_to_swap_caches.patch
tmpfs-radix_tree_preloading.patch
radix-tree-avoid-atomic-allocations-for-preloaded-insertions.patch
mm-dont-allow-ioremapping-of-ranges-larger-than-vmalloc-space.patch
mm-special-mapping-nopage.patch
agp-alpha-nopage.patch
vt-bitlock-fix.patch
radix_treeh-trivial-comment-correction.patch
inotify-fix-race.patch
inotify-remove-debug-code.patch
relay-nopage.patch
uio-nopage.patch
ext2-xip-check-fix.patch
fb-defio-nopage.patch
rewrite-rd.patch
rewrite-rd-fix.patch
rd-support-xip.patch
reiser4.patch
