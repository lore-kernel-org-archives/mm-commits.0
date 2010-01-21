From: akpm@linux-foundation.org
Subject: [obsolete] zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch removed from -mm tree
Date: Thu, 21 Jan 2010 13:24:54 -0800
Message-ID: <201001212124.o0LLOsKb030460@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53052 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754932Ab0AUVZV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jan 2010 16:25:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, michaelc@cs.wisc.edu, yjwei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     zfcp: test kmalloc failure in scsi_get_vpd_page()
has been removed from the -mm tree.  Its filename was
     zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: zfcp: test kmalloc failure in scsi_get_vpd_page()
From: Roel Kluin <roel.kluin@gmail.com>

kmalloc() may fail, so test whether it succeeded.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Wei Yongjun <yjwei@cn.fujitsu.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/scsi/scsi.c~zfcp-test-kmalloc-failure-in-scsi_get_vpd_page drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c~zfcp-test-kmalloc-failure-in-scsi_get_vpd_page
+++ a/drivers/scsi/scsi.c
@@ -1066,6 +1066,8 @@ unsigned char *scsi_get_vpd_page(struct 
 
 	kfree(buf);
 	buf = kmalloc(len, GFP_KERNEL);
+	if (!buf)
+		return NULL;
 	result = scsi_vpd_inquiry(sdev, buf, page, len);
 	if (result)
 		goto fail;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
acpi-fix-confusion-in-acpi_evaluate_string-in-comment.patch
asus-acpi-remove-duplicate-comparison-of-asus_model-strings.patch
gemini-wrong-registers-used-to-set-reg_level-in-gpio_set_irq_type.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
ia64-wrong-attribute-of-hub-chip-written-in-uv_setup.patch
hisax-timeout-off-by-one-in-waitrecmsg.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
dc395x-decrease-iteration-for-tag_number-of-max_command-in-start_scsi.patch
mpt2sas-fix-confusion-in-_scsih_sas_device_status_change_event.patch
paride-fix-off-by-one-test.patch
80211core-fix-confusion.patch
rtl8192u-ieee80211-currentmpdudensity-assigned-to-itself-in-htusedefaultsetting.patch
musb-test-always-evaluates-to-false.patch
musb-dont-dereference-null-tusb_dma-in-dma_controller_destroy.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch
w1-fix-test-in-ds2482_wait_1wire_idle.patch

