From: akpm@linux-foundation.org
Subject: [merged] fbdev-tv_paln-bit-set-twice-in-sisfb_detect_vb_connect.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:35:33 -0800
Message-ID: <200912162035.nBGKZX32013106@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38889 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935400AbZLPUfn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:35:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, krzysztof.h1@poczta.fm, thomas@winischhofer.net, mm-commits@vger.kernel.org


The patch titled
     fbdev: TV_PALN bit set twice in sisfb_detect_VB_connect()
has been removed from the -mm tree.  Its filename was
     fbdev-tv_paln-bit-set-twice-in-sisfb_detect_vb_connect.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: TV_PALN bit set twice in sisfb_detect_VB_connect()
From: Roel Kluin <roel.kluin@gmail.com>

The TV_PALN bit was tested twice, replace one by TV_PALM.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sis/sis_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/sis/sis_main.c~fbdev-tv_paln-bit-set-twice-in-sisfb_detect_vb_connect drivers/video/sis/sis_main.c
--- a/drivers/video/sis/sis_main.c~fbdev-tv_paln-bit-set-twice-in-sisfb_detect_vb_connect
+++ a/drivers/video/sis/sis_main.c
@@ -2115,7 +2115,7 @@ sisfb_detect_VB_connect(struct sis_video
 	   if( (!(ivideo->vbflags2 & VB2_SISBRIDGE)) &&
 	       (!((ivideo->sisvga_engine == SIS_315_VGA) &&
 			(ivideo->vbflags2 & VB2_CHRONTEL))) ) {
-	      if(ivideo->sisfb_tvstd & (TV_PALN | TV_PALN | TV_NTSCJ)) {
+	      if(ivideo->sisfb_tvstd & (TV_PALM | TV_PALN | TV_NTSCJ)) {
 		 ivideo->sisfb_tvstd = -1;
 		 printk(KERN_ERR "sisfb: PALM/PALN/NTSCJ not supported\n");
 	      }
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch
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
keys-ptr_err-return-of-wrong-pointer-in-keyctl_get_security.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
hvc_console-fix-test-on-unsigned-in-hvc_console_print.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch

