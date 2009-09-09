From: akpm@linux-foundation.org
Subject: - octeon-request_irq-failure-ignored-in-cvm_oct_spi_init.patch removed from -mm tree
Date: Tue, 08 Sep 2009 17:09:47 -0700
Message-ID: <200909090009.n8909lwA031765@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752140AbZIIAJs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2009 20:09:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, ddaney@caviumnetworks.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     octeon: request_irq() failure ignored in cvm_oct_spi_init()
has been removed from the -mm tree.  Its filename was
     octeon-request_irq-failure-ignored-in-cvm_oct_spi_init.patch

This patch was dropped because of confusion

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: octeon: request_irq() failure ignored in cvm_oct_spi_init()
From: Roel Kluin <roel.kluin@gmail.com>

Produce an error if request_irq() failed.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: David Daney <ddaney@caviumnetworks.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/octeon/ethernet-spi.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/staging/octeon/ethernet-spi.c~octeon-request_irq-failure-ignored-in-cvm_oct_spi_init drivers/staging/octeon/ethernet-spi.c
--- a/drivers/staging/octeon/ethernet-spi.c~octeon-request_irq-failure-ignored-in-cvm_oct_spi_init
+++ a/drivers/staging/octeon/ethernet-spi.c
@@ -295,6 +295,8 @@ int cvm_oct_spi_init(struct net_device *
 	if (number_spi_ports == 0) {
 		r = request_irq(OCTEON_IRQ_RML, cvm_oct_spi_rml_interrupt,
 				IRQF_SHARED, "SPI", &number_spi_ports);
+		if (r != 0)
+			return r;
 	}
 	number_spi_ports++;
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

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
comedi-null-dereference-of-amcc-in-v_pci_card_list_init.patch
rt2860-possible-null-dereferences.patch
drivers-staging-octeon-ethernet-rgmiic-dont-ignore-request_irq-return-code.patch
octeon-request_irq-failure-ignored-in-cvm_oct_spi_init.patch
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

