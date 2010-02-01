From: akpm@linux-foundation.org
Subject: + mtd-change-positive-error-return-into-negative-in-mtd_do_writeoob.patch added to -mm tree
Date: Mon, 01 Feb 2010 12:20:32 -0800
Message-ID: <201002012020.o11KKWlZ010135@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55421 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756049Ab0BAUVM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 15:21:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, dwmw2@infradead.org


The patch titled
     mtd: change positive error return into negative in mtd_do_writeoob()
has been added to the -mm tree.  Its filename is
     mtd-change-positive-error-return-into-negative-in-mtd_do_writeoob.patch

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
Subject: mtd: change positive error return into negative in mtd_do_writeoob()
From: Roel Kluin <roel.kluin@gmail.com>

The error return should be negative

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdchar.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mtd/mtdchar.c~mtd-change-positive-error-return-into-negative-in-mtd_do_writeoob drivers/mtd/mtdchar.c
--- a/drivers/mtd/mtdchar.c~mtd-change-positive-error-return-into-negative-in-mtd_do_writeoob
+++ a/drivers/mtd/mtdchar.c
@@ -373,7 +373,7 @@ static int mtd_do_writeoob(struct file *
 	if (!mtd->write_oob)
 		ret = -EOPNOTSUPP;
 	else
-		ret = access_ok(VERIFY_READ, ptr, length) ? 0 : EFAULT;
+		ret = access_ok(VERIFY_READ, ptr, length) ? 0 : -EFAULT;
 
 	if (ret)
 		return ret;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
acpi-fix-confusion-in-acpi_evaluate_string-in-comment.patch
asus-acpi-remove-duplicate-comparison-of-asus_model-strings.patch
thinkpad-acpi-wrong-thermal-attribute_group-removed-in-thermal_exit.patch
gemini-wrong-registers-used-to-set-reg_level-in-gpio_set_irq_type.patch
dma-cases-ipu_pix_fmt_bgra32-bgr32-and-abgr32-are-the-same-in-ipu_ch_param_set_size.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
drivers-gpu-drm-drm_crtc_helperc-fix-setting-of-fb_changed-in-drm_crtc_helper_set_config.patch
ia64-wrong-attribute-of-hub-chip-written-in-uv_setup.patch
mtd-hot-spin-and-code-duplication-in-nand_bcm_umi_bch_read_oobecc.patch
mtd-change-positive-error-return-into-negative-in-mtd_do_writeoob.patch
hisax-timeout-off-by-one-in-waitrecmsg.patch
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
paride-fix-off-by-one-test.patch
musb-test-always-evaluates-to-false.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
cris-v32-typo-in-crisv32_arbiter_unwatch.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch
w1-fix-test-in-ds2482_wait_1wire_idle.patch
misdn-positive-error-return-should-be-negative-in-mode_hfcmulti.patch
lpfc-positive-error-return-into-negative.patch
qla2xxx-negative-error-return-in-qla2x00_change_queue_depth.patch

