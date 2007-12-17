From: akpm@linux-foundation.org
Subject: + stc-remember-to-initialise-the-sg-table.patch added to -mm tree
Date: Mon, 17 Dec 2007 13:58:11 -0800
Message-ID: <200712172158.lBHLwBPq003769@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52468 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936718AbXLQV6n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Dec 2007 16:58:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tomof@acm.org, James.Bottomley@steeleye.com


The patch titled
     st.c: remember to initialise the sg table
has been added to the -mm tree.  Its filename is
     stc-remember-to-initialise-the-sg-table.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: st.c: remember to initialise the sg table
From: FUJITA Tomonori <tomof@acm.org>

Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/st.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/scsi/st.c~stc-remember-to-initialise-the-sg-table drivers/scsi/st.c
--- a/drivers/scsi/st.c~stc-remember-to-initialise-the-sg-table
+++ a/drivers/scsi/st.c
@@ -3611,6 +3611,7 @@ static struct st_buffer *
 
 	tb->dma = need_dma;
 	tb->buffer_size = got;
+	sg_init_table(tb->sg, max_sg);
 
 	return tb;
 }
_

Patches currently in -mm which might be from tomof@acm.org are

git-scsi-misc.patch
stc-remember-to-initialise-the-sg-table.patch
iommu-sg-merging-add-device_dma_parameters-structure.patch
iommu-sg-merging-pci-add-device_dma_parameters-support.patch
iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-ppc-make-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-ia64-make-sba_iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-alpha-make-pci_iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-sparc64-make-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-parisc-make-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-call-blk_queue_segment_boundary-in-__scsi_alloc_queue.patch
iommu-sg-merging-sata_inic162x-use-pci_set_dma_max_seg_size.patch
iommu-sg-merging-aacraid-use-pci_set_dma_max_seg_size.patch
iommu-sg-add-iommu-helper-functions-for-the-free-area-management.patch
iommu-sg-powerpc-convert-iommu-to-use-the-iommu-helper.patch
iommu-sg-powerpc-remove-dma-4gb-boundary-protection.patch
iommu-sg-x86-convert-calgary-iommu-to-use-the-iommu-helper.patch
iommu-sg-x86-convert-gart-iommu-to-use-the-iommu-helper.patch
iommu-sg-kill-__clear_bit_string-and-find_next_zero_string.patch
add-accessors-for-segment_boundary_mask-in.patch
pci-add-dma-segment-boundary-support.patch
swiotlb-respect-the-segment-boundary-limits.patch
call-dma_set_seg_boundary-in-__scsi_alloc_queue.patch
alpha-kill-deprecated-virt_to_bus.patch
