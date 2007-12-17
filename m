From: akpm@linux-foundation.org
Subject: - ib-nopage.patch removed from -mm tree
Date: Mon, 17 Dec 2007 15:39:08 -0800
Message-ID: <200712172339.lBHNd8B3008101@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46663 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756872AbXLQXjN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Dec 2007 18:39:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, rolandd@cisco.com, mm-commits@vger.kernel.org


The patch titled
     ib: nopage
has been removed from the -mm tree.  Its filename was
     ib-nopage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ib: nopage
From: Nick Piggin <npiggin@suse.de>

Convert IB from nopage to fault.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/ipath/ipath_debug.h    |    4 +-
 drivers/infiniband/hw/ipath/ipath_file_ops.c |   29 +++++------------
 2 files changed, 12 insertions(+), 21 deletions(-)

diff -puN drivers/infiniband/hw/ipath/ipath_debug.h~ib-nopage drivers/infiniband/hw/ipath/ipath_debug.h
--- a/drivers/infiniband/hw/ipath/ipath_debug.h~ib-nopage
+++ a/drivers/infiniband/hw/ipath/ipath_debug.h
@@ -55,7 +55,7 @@
 #define __IPATH_PKTDBG      0x80	/* print packet data */
 /* print process startup (init)/exit messages */
 #define __IPATH_PROCDBG     0x100
-/* print mmap/nopage stuff, not using VDBG any more */
+/* print mmap/fault stuff, not using VDBG any more */
 #define __IPATH_MMDBG       0x200
 #define __IPATH_ERRPKTDBG   0x400
 #define __IPATH_USER_SEND   0x1000	/* use user mode send */
@@ -81,7 +81,7 @@
 #define __IPATH_VERBDBG   0x0	/* very verbose debug */
 #define __IPATH_PKTDBG    0x0	/* print packet data */
 #define __IPATH_PROCDBG   0x0	/* process startup (init)/exit messages */
-/* print mmap/nopage stuff, not using VDBG any more */
+/* print mmap/fault stuff, not using VDBG any more */
 #define __IPATH_MMDBG     0x0
 #define __IPATH_EPKTDBG   0x0	/* print ethernet packet data */
 #define __IPATH_IPATHDBG  0x0	/* Ethernet (IPATH) table dump on */
diff -puN drivers/infiniband/hw/ipath/ipath_file_ops.c~ib-nopage drivers/infiniband/hw/ipath/ipath_file_ops.c
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c~ib-nopage
+++ a/drivers/infiniband/hw/ipath/ipath_file_ops.c
@@ -1120,33 +1120,24 @@ bail:
 }
 
 /*
- * ipath_file_vma_nopage - handle a VMA page fault.
+ * ipath_file_vma_fault - handle a VMA page fault.
  */
-static struct page *ipath_file_vma_nopage(struct vm_area_struct *vma,
-					  unsigned long address, int *type)
+static int ipath_file_vma_fault(struct vm_area_struct *vma,
+					struct vm_fault *vmf)
 {
-	unsigned long offset = address - vma->vm_start;
-	struct page *page = NOPAGE_SIGBUS;
-	void *pageptr;
+	struct page *page;
 
-	/*
-	 * Convert the vmalloc address into a struct page.
-	 */
-	pageptr = (void *)(offset + (vma->vm_pgoff << PAGE_SHIFT));
-	page = vmalloc_to_page(pageptr);
+	page = vmalloc_to_page((void *)(vmf->pgoff << PAGE_SHIFT));
 	if (!page)
-		goto out;
-
-	/* Increment the reference count. */
+		return VM_FAULT_SIGBUS;
 	get_page(page);
-	if (type)
-		*type = VM_FAULT_MINOR;
-out:
-	return page;
+	vmf->page = page;
+
+	return 0;
 }
 
 static struct vm_operations_struct ipath_file_vm_ops = {
-	.nopage = ipath_file_vma_nopage,
+	.fault = ipath_file_vma_fault,
 };
 
 static int mmap_kvaddr(struct vm_area_struct *vma, u64 pgaddr,
_

Patches currently in -mm which might be from npiggin@suse.de are

git-alsa.patch
git-dvb.patch
ia64-ia32-nopage.patch
git-ieee1394.patch
git-infiniband.patch
git-jfs.patch
git-kvm.patch
nfs-use-gfp_nofs-preloads-for-radix-tree-insertion.patch
git-sched.patch
sg-nopage.patch
git-block.patch
usb-mon-nopage.patch
git-x86.patch
slub-use-non-atomic-bit-unlock.patch
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
