From: akpm@linux-foundation.org
Subject: [merged] mtd-hot-spin-and-code-duplication-in-nand_bcm_umi_bch_read_oobecc.patch removed from -mm tree
Date: Mon, 01 Mar 2010 11:46:50 -0800
Message-ID: <201003011946.o21JkoWV028702@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751496Ab0CATr3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Mar 2010 14:47:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, dwmw2@infradead.org, leochen@broadcom.com, sbranden@broadcom.com, mm-commits@vger.kernel.org


The patch titled
     mtd: hot spin and code duplication in nand_bcm_umi_bch_read_oobEcc()
has been removed from the -mm tree.  Its filename was
     mtd-hot-spin-and-code-duplication-in-nand_bcm_umi_bch_read_oobecc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
score-fix-dereference-of-null-pointer-in-local_flush_tlb_page.patch
isdn-misplaced-parenthesis-in-pof_handle_data.patch
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
lpfc-positive-error-return-into-negative.patch
scsi-bfa-correct-onstack-wait_queue_head-declaration.patch
paride-fix-off-by-one-test.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-ptr_err-overwrites-einval-in-syscall-osf_mount.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
cris-v32-typo-in-crisv32_arbiter_unwatch.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch
w1-fix-test-in-ds2482_wait_1wire_idle.patch

