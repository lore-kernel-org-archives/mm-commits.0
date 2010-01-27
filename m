From: akpm@linux-foundation.org
Subject: + mtd-hot-spin-and-code-duplication-in-nand_bcm_umi_bch_read_oobecc.patch added to -mm tree
Date: Tue, 26 Jan 2010 17:03:56 -0800
Message-ID: <201001270103.o0R13uQi001905@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40606 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1749667Ab0A0BEH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jan 2010 20:04:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, dwmw2@infradead.org, leochen@broadcom.com, sbranden@broadcom.com


The patch titled
     mtd: hot spin and code duplication in nand_bcm_umi_bch_read_oobEcc()
has been added to the -mm tree.  Its filename is
     mtd-hot-spin-and-code-duplication-in-nand_bcm_umi_bch_read_oobecc.patch

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
Subject: mtd: hot spin and code duplication in nand_bcm_umi_bch_read_oobEcc()
From: Roel Kluin <roel.kluin@gmail.com>

In the branch where pagesize equalled NAND_DATA_ACCESS_SIZE, NumToRead
wasn't decremented in the `while (numToRead > 11)' loop.  Also the first
and last while loops were duplicated in both branches.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Leo Chen <leochen@broadcom.com>
Cc: "Scott Branden" <sbranden@broadcom.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/nand_bcm_umi.h |   73 ++++++++++--------------------
 1 file changed, 26 insertions(+), 47 deletions(-)

diff -puN drivers/mtd/nand/nand_bcm_umi.h~mtd-hot-spin-and-code-duplication-in-nand_bcm_umi_bch_read_oobecc drivers/mtd/nand/nand_bcm_umi.h
--- a/drivers/mtd/nand/nand_bcm_umi.h~mtd-hot-spin-and-code-duplication-in-nand_bcm_umi_bch_read_oobecc
+++ a/drivers/mtd/nand/nand_bcm_umi.h
@@ -167,18 +167,27 @@ static inline void nand_bcm_umi_bch_read
 	int numToRead = 16;	/* There are 16 bytes per sector in the OOB */
 
 	/* ECC is already paused when this function is called */
+	if (pageSize != NAND_DATA_ACCESS_SIZE) {
+		/* skip BI */
+#if defined(__KERNEL__) && !defined(STANDALONE)
+		*oobp++ = REG_NAND_DATA8;
+#else
+		REG_NAND_DATA8;
+#endif
+		numToRead--;
+	}
 
-	if (pageSize == NAND_DATA_ACCESS_SIZE) {
-		while (numToRead > numEccBytes) {
-			/* skip free oob region */
+	while (numToRead > numEccBytes) {
+		/* skip free oob region */
 #if defined(__KERNEL__) && !defined(STANDALONE)
-			*oobp++ = REG_NAND_DATA8;
+		*oobp++ = REG_NAND_DATA8;
 #else
-			REG_NAND_DATA8;
+		REG_NAND_DATA8;
 #endif
-			numToRead--;
-		}
+		numToRead--;
+	}
 
+	if (pageSize == NAND_DATA_ACCESS_SIZE) {
 		/* read ECC bytes before BI */
 		nand_bcm_umi_bch_resume_read_ecc_calc();
 
@@ -190,6 +199,7 @@ static inline void nand_bcm_umi_bch_read
 #else
 			eccCalc[eccPos++] = REG_NAND_DATA8;
 #endif
+			numToRead--;
 		}
 
 		nand_bcm_umi_bch_pause_read_ecc_calc();
@@ -204,49 +214,18 @@ static inline void nand_bcm_umi_bch_read
 			numToRead--;
 		}
 
-		/* read ECC bytes */
-		nand_bcm_umi_bch_resume_read_ecc_calc();
-		while (numToRead) {
-#if defined(__KERNEL__) && !defined(STANDALONE)
-			*oobp = REG_NAND_DATA8;
-			eccCalc[eccPos++] = *oobp;
-			oobp++;
-#else
-			eccCalc[eccPos++] = REG_NAND_DATA8;
-#endif
-			numToRead--;
-		}
-	} else {
-		/* skip BI */
-#if defined(__KERNEL__) && !defined(STANDALONE)
-		*oobp++ = REG_NAND_DATA8;
+	}
+	/* read ECC bytes */
+	nand_bcm_umi_bch_resume_read_ecc_calc();
+	while (numToRead) {
+#if defined(__KERNEL__) && !defined(STANDALONE)
+		*oobp = REG_NAND_DATA8;
+		eccCalc[eccPos++] = *oobp;
+		oobp++;
 #else
-		REG_NAND_DATA8;
+		eccCalc[eccPos++] = REG_NAND_DATA8;
 #endif
 		numToRead--;
-
-		while (numToRead > numEccBytes) {
-			/* skip free oob region */
-#if defined(__KERNEL__) && !defined(STANDALONE)
-			*oobp++ = REG_NAND_DATA8;
-#else
-			REG_NAND_DATA8;
-#endif
-			numToRead--;
-		}
-
-		/* read ECC bytes */
-		nand_bcm_umi_bch_resume_read_ecc_calc();
-		while (numToRead) {
-#if defined(__KERNEL__) && !defined(STANDALONE)
-			*oobp = REG_NAND_DATA8;
-			eccCalc[eccPos++] = *oobp;
-			oobp++;
-#else
-			eccCalc[eccPos++] = REG_NAND_DATA8;
-#endif
-			numToRead--;
-		}
 	}
 }
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
acpi-fix-confusion-in-acpi_evaluate_string-in-comment.patch
asus-acpi-remove-duplicate-comparison-of-asus_model-strings.patch
thinkpad-acpi-wrong-thermal-attribute_group-removed-in-thermal_exit.patch
gemini-wrong-registers-used-to-set-reg_level-in-gpio_set_irq_type.patch
dma-cases-ipu_pix_fmt_bgra32-bgr32-and-abgr32-are-the-same-in-ipu_ch_param_set_size.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
drivers-gpu-drm-drm_crtc_helperc-fix-setting-of-fb_changed-in-drm_crtc_helper_set_config.patch
cx23885-wrong-command-printed-in-cmd_to_str.patch
ia64-wrong-attribute-of-hub-chip-written-in-uv_setup.patch
mtd-hot-spin-and-code-duplication-in-nand_bcm_umi_bch_read_oobecc.patch
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
bfa-comparison-with-wrong-msgtag-in-bfa_pport_isr.patch
paride-fix-off-by-one-test.patch
rt2860-sta_ioctlc-two-branches-the-same-in-rt_ioctl_giwscan.patch
serqt_usb2-two-branches-the-same-in-qt_set_termios.patch
comedi-g1-3-status-registers-not-read-in-ni_gpct_to_660x_register.patch
musb-test-always-evaluates-to-false.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
cris-v32-typo-in-crisv32_arbiter_unwatch.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch
w1-fix-test-in-ds2482_wait_1wire_idle.patch

