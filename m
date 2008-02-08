From: akpm@linux-foundation.org
Subject: - sg-nopage.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:10:56 -0800
Message-ID: <200802080810.m188Ab8N014954@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54006 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760124AbYBHITW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, James.Bottomley@steeleye.com, dougg@torque.net, mm-commits@vger.kernel.org


The patch titled
     sg: nopage
has been removed from the -mm tree.  Its filename was
     sg-nopage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sg: nopage
From: Nick Piggin <npiggin@suse.de>

Convert SG from nopage to fault.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sg.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff -puN drivers/scsi/sg.c~sg-nopage drivers/scsi/sg.c
--- a/drivers/scsi/sg.c~sg-nopage
+++ a/drivers/scsi/sg.c
@@ -1160,23 +1160,22 @@ sg_fasync(int fd, struct file *filp, int
 	return (retval < 0) ? retval : 0;
 }
 
-static struct page *
-sg_vma_nopage(struct vm_area_struct *vma, unsigned long addr, int *type)
+static int
+sg_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	Sg_fd *sfp;
-	struct page *page = NOPAGE_SIGBUS;
 	unsigned long offset, len, sa;
 	Sg_scatter_hold *rsv_schp;
 	struct scatterlist *sg;
 	int k;
 
 	if ((NULL == vma) || (!(sfp = (Sg_fd *) vma->vm_private_data)))
-		return page;
+		return VM_FAULT_SIGBUS;
 	rsv_schp = &sfp->reserve;
-	offset = addr - vma->vm_start;
+	offset = vmf->pgoff << PAGE_SHIFT;
 	if (offset >= rsv_schp->bufflen)
-		return page;
-	SCSI_LOG_TIMEOUT(3, printk("sg_vma_nopage: offset=%lu, scatg=%d\n",
+		return VM_FAULT_SIGBUS;
+	SCSI_LOG_TIMEOUT(3, printk("sg_vma_fault: offset=%lu, scatg=%d\n",
 				   offset, rsv_schp->k_use_sg));
 	sg = rsv_schp->buffer;
 	sa = vma->vm_start;
@@ -1185,21 +1184,21 @@ sg_vma_nopage(struct vm_area_struct *vma
 		len = vma->vm_end - sa;
 		len = (len < sg->length) ? len : sg->length;
 		if (offset < len) {
+			struct page *page;
 			page = virt_to_page(page_address(sg_page(sg)) + offset);
 			get_page(page);	/* increment page count */
-			break;
+			vmf->page = page;
+			return 0; /* success */
 		}
 		sa += len;
 		offset -= len;
 	}
 
-	if (type)
-		*type = VM_FAULT_MINOR;
-	return page;
+	return VM_FAULT_SIGBUS;
 }
 
 static struct vm_operations_struct sg_mmap_vm_ops = {
-	.nopage = sg_vma_nopage,
+	.fault = sg_vma_fault,
 };
 
 static int
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
git-drm.patch
git-kvm.patch
nfs-use-gfp_nofs-preloads-for-radix-tree-insertion.patch
mm-special-mapping-nopage.patch
rewrite-rd.patch
rewrite-rd-fix.patch
rewrite-rd-fix-2.patch
rd-support-xip.patch
mm-remove-nopage.patch
buffer_head-fix-private_list-handling.patch
reiser4.patch
reiser4-correct-references-to-filemap_nopage.patch
