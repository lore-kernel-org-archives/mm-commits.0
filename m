From: akpm@linux-foundation.org
Subject: [merged] thinkpad-acpi-wrong-thermal-attribute_group-removed-in-thermal_exit.patch removed from -mm tree
Date: Thu, 18 Feb 2010 12:45:27 -0800
Message-ID: <201002182045.o1IKjR09002738@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751749Ab0BRUq1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Feb 2010 15:46:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, ibm-acpi@hmh.eng.br, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     thinkpad-acpi: wrong thermal attribute_group removed in thermal_exit()
has been removed from the -mm tree.  Its filename was
     thinkpad-acpi-wrong-thermal-attribute_group-removed-in-thermal_exit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thinkpad-acpi: wrong thermal attribute_group removed in thermal_exit()
From: Roel Kluin <roel.kluin@gmail.com>

sysfs_remove_group() removed the wrong attribute_group for
thermal_read_mode TPEC_8, ACPI_TMP07 and ACPI_UPDT

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/thinkpad_acpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/platform/x86/thinkpad_acpi.c~thinkpad-acpi-wrong-thermal-attribute_group-removed-in-thermal_exit drivers/platform/x86/thinkpad_acpi.c
--- a/drivers/platform/x86/thinkpad_acpi.c~thinkpad-acpi-wrong-thermal-attribute_group-removed-in-thermal_exit
+++ a/drivers/platform/x86/thinkpad_acpi.c
@@ -5771,7 +5771,7 @@ static void thermal_exit(void)
 	case TPACPI_THERMAL_ACPI_TMP07:
 	case TPACPI_THERMAL_ACPI_UPDT:
 		sysfs_remove_group(&tpacpi_sensors_pdev->dev.kobj,
-				   &thermal_temp_input16_group);
+				   &thermal_temp_input8_group);
 		break;
 	case TPACPI_THERMAL_NONE:
 	default:
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

