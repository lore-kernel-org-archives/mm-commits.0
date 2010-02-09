From: akpm@linux-foundation.org
Subject: + iwmc3200wifi-test-of-wrong-pointer-after-kzalloc-in-iwm_mlme_update_bss_table.patch added to -mm tree
Date: Tue, 09 Feb 2010 15:05:44 -0800
Message-ID: <201002092305.o19N5inU007113@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60853 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751167Ab0BIXF6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Feb 2010 18:05:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, linville@tuxdriver.com, sameo@linux.intel.com, yi.zhu@intel.com


The patch titled
     iwmc3200wifi: test of wrong pointer after kzalloc in iwm_mlme_update_bss_table()
has been added to the -mm tree.  Its filename is
     iwmc3200wifi-test-of-wrong-pointer-after-kzalloc-in-iwm_mlme_update_bss_table.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iwmc3200wifi: test of wrong pointer after kzalloc in iwm_mlme_update_bss_table()
From: Roel Kluin <roel.kluin@gmail.com>

The wrong pointer was tested.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>
Cc: Zhu Yi <yi.zhu@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/iwmc3200wifi/rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/wireless/iwmc3200wifi/rx.c~iwmc3200wifi-test-of-wrong-pointer-after-kzalloc-in-iwm_mlme_update_bss_table drivers/net/wireless/iwmc3200wifi/rx.c
--- a/drivers/net/wireless/iwmc3200wifi/rx.c~iwmc3200wifi-test-of-wrong-pointer-after-kzalloc-in-iwm_mlme_update_bss_table
+++ a/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -794,7 +794,7 @@ static int iwm_mlme_update_bss_table(str
 	}
 
 	bss->bss = kzalloc(bss_len, GFP_KERNEL);
-	if (!bss) {
+	if (!bss->bss) {
 		kfree(bss);
 		IWM_ERR(iwm, "Couldn't allocate bss\n");
 		return -ENOMEM;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
thinkpad-acpi-wrong-thermal-attribute_group-removed-in-thermal_exit.patch
acpi-fix-confusion-in-acpi_evaluate_string-in-comment.patch
asus-acpi-remove-duplicate-comparison-of-asus_model-strings.patch
gemini-wrong-registers-used-to-set-reg_level-in-gpio_set_irq_type.patch
mx1-mx2-einval-overwritten-in-second-iteration-in-mxc_gpio_setup_multiple_pins.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
ia64-wrong-attribute-of-hub-chip-written-in-uv_setup.patch
mtd-hot-spin-and-code-duplication-in-nand_bcm_umi_bch_read_oobecc.patch
mtd-change-positive-error-return-into-negative-in-mtd_do_writeoob.patch
score-fix-dereference-of-null-pointer-in-local_flush_tlb_page.patch
obsolete-config-in-kernel-source-use_internal_timer.patch
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
scsi-bfa-correct-onstack-wait_queue_head-declaration.patch
paride-fix-off-by-one-test.patch
musb-test-always-evaluates-to-false.patch
iwmc3200wifi-test-of-wrong-pointer-after-kzalloc-in-iwm_mlme_update_bss_table.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-ptr_err-overwrites-einval-in-syscall-osf_mount.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
cris-v32-typo-in-crisv32_arbiter_unwatch.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch
w1-fix-test-in-ds2482_wait_1wire_idle.patch

