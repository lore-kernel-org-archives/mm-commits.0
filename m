From: akpm@linux-foundation.org
Subject: [merged] qla2xxx-negative-error-return-in-qla2x00_change_queue_depth.patch removed from -mm tree
Date: Thu, 18 Feb 2010 12:46:08 -0800
Message-ID: <201002182046.o1IKk880002793@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60734 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755850Ab0BRUrZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Feb 2010 15:47:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, James.Bottomley@HansenPartnership.com, giridhar.malavali@qlogic.com, mm-commits@vger.kernel.org


The patch titled
     qla2xxx: negative error return in qla2x00_change_queue_depth()
has been removed from the -mm tree.  Its filename was
     qla2xxx-negative-error-return-in-qla2x00_change_queue_depth.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: qla2xxx: negative error return in qla2x00_change_queue_depth()
From: Roel Kluin <roel.kluin@gmail.com>

The *change_queue_depth functions usually return a negative error return.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Acked-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/qla2xxx/qla_os.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/qla2xxx/qla_os.c~qla2xxx-negative-error-return-in-qla2x00_change_queue_depth drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c~qla2xxx-negative-error-return-in-qla2x00_change_queue_depth
+++ a/drivers/scsi/qla2xxx/qla_os.c
@@ -1258,7 +1258,7 @@ qla2x00_change_queue_depth(struct scsi_d
 		qla2x00_adjust_sdev_qdepth_up(sdev, qdepth);
 		break;
 	default:
-		return EOPNOTSUPP;
+		return -EOPNOTSUPP;
 	}
 
 	return sdev->queue_depth;
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

