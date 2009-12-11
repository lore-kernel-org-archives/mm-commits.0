From: akpm@linux-foundation.org
Subject: [merged] ib-uverbs-ptr_err-return-of-wrong-pointer-in-ib_uverbs_get_context.patch removed from -mm tree
Date: Fri, 11 Dec 2009 12:59:24 -0800
Message-ID: <200912112059.nBBKxOuh020416@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60727 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762549AbZLKU7t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Dec 2009 15:59:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, rolandd@cisco.com, mm-commits@vger.kernel.org


The patch titled
     IB/uverbs: PTR_ERR return of wrong pointer in ib_uverbs_get_context()
has been removed from the -mm tree.  Its filename was
     ib-uverbs-ptr_err-return-of-wrong-pointer-in-ib_uverbs_get_context.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: IB/uverbs: PTR_ERR return of wrong pointer in ib_uverbs_get_context()
From: Roel Kluin <roel.kluin@gmail.com>

Return the PTR_ERR of the correct pointer.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/core/uverbs_cmd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/infiniband/core/uverbs_cmd.c~ib-uverbs-ptr_err-return-of-wrong-pointer-in-ib_uverbs_get_context drivers/infiniband/core/uverbs_cmd.c
--- a/drivers/infiniband/core/uverbs_cmd.c~ib-uverbs-ptr_err-return-of-wrong-pointer-in-ib_uverbs_get_context
+++ a/drivers/infiniband/core/uverbs_cmd.c
@@ -285,7 +285,7 @@ ssize_t ib_uverbs_get_context(struct ib_
 
 	ucontext = ibdev->alloc_ucontext(ibdev, &udata);
 	if (IS_ERR(ucontext)) {
-		ret = PTR_ERR(file->ucontext);
+		ret = PTR_ERR(ucontext);
 		goto err;
 	}
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch
omap-return-ptr_err-rather-than-is_err.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
powerpc-85xx-wrong-variable-returned-on-error.patch
hidp-ptr_err-return-of-wrong-pointer-in-hidp_setup_hid.patch
imx-bit-confusion.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
r8192u_core-test-for-negative-error-in-rtl8192_rx_isr.patch
page-types-unsigned-cannot-be-less-than-0-in-add_page.patch
keys-ptr_err-return-of-wrong-pointer-in-keyctl_get_security.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
gpio-fix-test-on-unsigned-in-lnw_irq_type.patch
fbdev-tv_paln-bit-set-twice-in-sisfb_detect_vb_connect.patch
hvc_console-fix-test-on-unsigned-in-hvc_console_print.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch

