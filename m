From: akpm@linux-foundation.org
Subject: [merged] slram-read-buffer-overflow.patch removed from -mm tree
Date: Tue, 08 Sep 2009 14:26:25 -0700
Message-ID: <200909082126.n88LQPCh006969@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33738 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752012AbZIHV0a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2009 17:26:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     slram: fix read buffer overflow
has been removed from the -mm tree.  Its filename was
     slram-read-buffer-overflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: slram: fix read buffer overflow
From: Roel Kluin <roel.kluin@gmail.com>

map[count] is checked before count < SLRAM_MAX_DEVICES_PARAMS

declared on drivers/mtd/devices/slram.c:66:

static char *map[SLRAM_MAX_DEVICES_PARAMS];

[akpm@linux-foundation.org: cleanups]
Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/devices/slram.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/mtd/devices/slram.c~slram-read-buffer-overflow drivers/mtd/devices/slram.c
--- a/drivers/mtd/devices/slram.c~slram-read-buffer-overflow
+++ a/drivers/mtd/devices/slram.c
@@ -341,9 +341,8 @@ static int __init init_slram(void)
 #else
 	int count;
 
-	for (count = 0; (map[count]) && (count < SLRAM_MAX_DEVICES_PARAMS);
-			count++) {
-	}
+	for (count = 0; count < SLRAM_MAX_DEVICES_PARAMS && map[count]; count++)
+		;
 
 	if ((count % 3 != 0) || (count == 0)) {
 		E("slram: not enough parameters.\n");
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

