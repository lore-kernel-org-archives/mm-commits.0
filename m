From: akpm@linux-foundation.org
Subject: [merged] comedi-null-dereference-of-amcc-in-v_pci_card_list_init.patch removed from -mm tree
Date: Tue, 15 Sep 2009 14:06:03 -0700
Message-ID: <200909152106.n8FL63hm001029@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47529 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758149AbZIOVGe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Sep 2009 17:06:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, devel@driverdev.osuosl.org, gregkh@suse.de, wfp5p@virginia.edu, mm-commits@vger.kernel.org


The patch titled
     comedi: NULL dereference of amcc in v_pci_card_list_init()
has been removed from the -mm tree.  Its filename was
     comedi-null-dereference-of-amcc-in-v_pci_card_list_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: comedi: NULL dereference of amcc in v_pci_card_list_init()
From: Roel Kluin <roel.kluin@gmail.com>

amcc allocation may fail, prevent a NULL dereference.

allocation may fail, prevent a dereference.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Bill Pemberton <wfp5p@virginia.edu>
Cc: <devel@driverdev.osuosl.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/comedi/drivers/addi-data/addi_amcc_s5933.h |    3 +++
 drivers/staging/comedi/drivers/addi-data/amcc_s5933_58.h   |    3 +++
 2 files changed, 6 insertions(+)

diff -puN drivers/staging/comedi/drivers/addi-data/addi_amcc_s5933.h~comedi-null-dereference-of-amcc-in-v_pci_card_list_init drivers/staging/comedi/drivers/addi-data/addi_amcc_s5933.h
--- a/drivers/staging/comedi/drivers/addi-data/addi_amcc_s5933.h~comedi-null-dereference-of-amcc-in-v_pci_card_list_init
+++ a/drivers/staging/comedi/drivers/addi-data/addi_amcc_s5933.h
@@ -261,6 +261,9 @@ void v_pci_card_list_init(unsigned short
 			pci_vendor = i_ADDIDATADeviceID[i_Count];
 			if (pcidev->vendor == pci_vendor) {
 				amcc = kmalloc(sizeof(*amcc), GFP_KERNEL);
+				if (amcc == NULL)
+					continue;
+
 				memset(amcc, 0, sizeof(*amcc));
 
 				amcc->pcidev = pcidev;
diff -puN drivers/staging/comedi/drivers/addi-data/amcc_s5933_58.h~comedi-null-dereference-of-amcc-in-v_pci_card_list_init drivers/staging/comedi/drivers/addi-data/amcc_s5933_58.h
--- a/drivers/staging/comedi/drivers/addi-data/amcc_s5933_58.h~comedi-null-dereference-of-amcc-in-v_pci_card_list_init
+++ a/drivers/staging/comedi/drivers/addi-data/amcc_s5933_58.h
@@ -254,6 +254,9 @@ void v_pci_card_list_init(unsigned short
 	pci_for_each_dev(pcidev) {
 		if (pcidev->vendor == pci_vendor) {
 			amcc = kmalloc(sizeof(*amcc), GFP_KERNEL);
+			if (amcc == NULL)
+				continue;
+
 			memset(amcc, 0, sizeof(*amcc));
 
 			amcc->pcidev = pcidev;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
pcmcia-fix-read-buffer-overflow.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
octeon-false-positive-timeout.patch
msp71xx-request_irq-failure-ignored-in-msp_pcibios_config_access.patch
mtd-jffs2-fix-read-buffer-overflow.patch
mtd-prevent-a-read-from-eraseregions.patch
mtd-prevent-a-read-from-regions.patch
hfc_usb-fix-read-buffer-overflow.patch
zorro8390-fix-read-buffer-overflow-in-zorro8390_init_one-checkpatch-fixes.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
regulator-fix-calculation-of-voltage-range-in-da9034_set_ldo12_voltage.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
st-fix-test-of-value-range-in-st_set_options.patch
st-fix-test-of-value-range-in-st_set_options-fix.patch
drivers-staging-octeon-ethernet-rgmiic-dont-ignore-request_irq-return-code.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
blackfin-fix-read-buffer-overflow.patch
arch-alpha-boot-tools-objstripc-wrong-variable-tested-after-open.patch
m32r-remove-redundant-tests-on-unsigned.patch
uml-fix-order-of-pud-and-pmd_free.patch
dme1737-keep-index-within-pwm_config.patch
sdio-fix-read-buffer-overflow.patch
hwmon-fix-freeing-of-gpio_data-and-irq.patch
ncpfs-read-buffer-overflow.patch
smbfs-read-buffer-overflow.patch
platinumfb-misplaced-parenthesis.patch
sisfb-read-buffer-overflow.patch
drivers-video-console-newport_conc-fix-read-outside-array-bounds.patch
mwave-fix-read-buffer-overflow.patch
adfs-remove-redundant-test-on-unsigned.patch
gru-allocation-may-fail-in-quicktest1.patch

