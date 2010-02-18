From: akpm@linux-foundation.org
Subject: [merged] lpfc-two-branches-the-same-in-lpfc_decode_firmware_rev.patch removed from -mm tree
Date: Thu, 18 Feb 2010 12:46:05 -0800
Message-ID: <201002182046.o1IKk5WR002785@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55281 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755850Ab0BRUr4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Feb 2010 15:47:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, James.Bottomley@HansenPartnership.com, james.smart@emulex.com, mm-commits@vger.kernel.org


The patch titled
     lpfc: two branches the same in lpfc_decode_firmware_rev()
has been removed from the -mm tree.  Its filename was
     lpfc-two-branches-the-same-in-lpfc_decode_firmware_rev.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lpfc: two branches the same in lpfc_decode_firmware_rev()
From: Roel Kluin <roel.kluin@gmail.com>

Regardless of the flag state, the branches execute the same code

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: James Smart <james.smart@emulex.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/lpfc/lpfc_ct.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN drivers/scsi/lpfc/lpfc_ct.c~lpfc-two-branches-the-same-in-lpfc_decode_firmware_rev drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c~lpfc-two-branches-the-same-in-lpfc_decode_firmware_rev
+++ a/drivers/scsi/lpfc/lpfc_ct.c
@@ -1843,12 +1843,7 @@ lpfc_decode_firmware_rev(struct lpfc_hba
 		c  = (rev & 0x0000ff00) >> 8;
 		b4 = (rev & 0x000000ff);
 
-		if (flag)
-			sprintf(fwrevision, "%d.%d%d%c%d ", b1,
-				b2, b3, c, b4);
-		else
-			sprintf(fwrevision, "%d.%d%d%c%d ", b1,
-				b2, b3, c, b4);
+		sprintf(fwrevision, "%d.%d%d%c%d", b1, b2, b3, c, b4);
 	}
 	return;
 }
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
gemini-wrong-registers-used-to-set-reg_level-in-gpio_set_irq_type.patch
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

