From: akpm@linux-foundation.org
Subject: [merged] misdn-positive-error-return-should-be-negative-in-mode_hfcmulti.patch removed from -mm tree
Date: Fri, 05 Feb 2010 11:58:57 -0800
Message-ID: <201002051958.o15JwvrM017913@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933766Ab0BET7D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2010 14:59:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, isdn@linux-pingi.de, mm-commits@vger.kernel.org


The patch titled
     mISDN: positive error return should be negative in mode_hfcmulti()
has been removed from the -mm tree.  Its filename was
     misdn-positive-error-return-should-be-negative-in-mode_hfcmulti.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mISDN: positive error return should be negative in mode_hfcmulti()
From: Roel Kluin <roel.kluin@gmail.com>

The error return should be negative.  Its only caller that acts upon its
return, handle_bmsg(), transmits the positive error but can also return
negative errors.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Karsten Keil <isdn@linux-pingi.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hardware/mISDN/hfcmulti.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/isdn/hardware/mISDN/hfcmulti.c~misdn-positive-error-return-should-be-negative-in-mode_hfcmulti drivers/isdn/hardware/mISDN/hfcmulti.c
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c~misdn-positive-error-return-should-be-negative-in-mode_hfcmulti
+++ a/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -2846,7 +2846,7 @@ mode_hfcmulti(struct hfc_multi *hc, int 
 	int conf;
 
 	if (ch < 0 || ch > 31)
-		return EINVAL;
+		return -EINVAL;
 	oslot_tx = hc->chan[ch].slot_tx;
 	oslot_rx = hc->chan[ch].slot_rx;
 	conf = hc->chan[ch].conf;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
acpi-fix-confusion-in-acpi_evaluate_string-in-comment.patch
asus-acpi-remove-duplicate-comparison-of-asus_model-strings.patch
thinkpad-acpi-wrong-thermal-attribute_group-removed-in-thermal_exit.patch
gemini-wrong-registers-used-to-set-reg_level-in-gpio_set_irq_type.patch
mx1-mx2-einval-overwritten-in-second-iteration-in-mxc_gpio_setup_multiple_pins.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
drivers-gpu-drm-drm_crtc_helperc-fix-setting-of-fb_changed-in-drm_crtc_helper_set_config.patch
ia64-wrong-attribute-of-hub-chip-written-in-uv_setup.patch
mtd-hot-spin-and-code-duplication-in-nand_bcm_umi_bch_read_oobecc.patch
mtd-change-positive-error-return-into-negative-in-mtd_do_writeoob.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
dc395x-decrease-iteration-for-tag_number-of-max_command-in-start_scsi.patch
mpt2sas-fix-confusion-in-_scsih_sas_device_status_change_event.patch
lpfc-two-branches-the-same-in-lpfc_decode_firmware_rev.patch
lpfc-positive-error-return-into-negative.patch
qla2xxx-negative-error-return-in-qla2x00_change_queue_depth.patch
paride-fix-off-by-one-test.patch
musb-test-always-evaluates-to-false.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-ptr_err-overwrites-einval-in-syscall-osf_mount.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
cris-v32-typo-in-crisv32_arbiter_unwatch.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch
w1-fix-test-in-ds2482_wait_1wire_idle.patch

