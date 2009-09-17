From: akpm@linux-foundation.org
Subject: [merged] blackfin-fix-read-buffer-overflow.patch removed from -mm tree
Date: Thu, 17 Sep 2009 12:45:22 -0700
Message-ID: <200909171945.n8HJjMLH007254@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41568 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750741AbZIQTpV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Sep 2009 15:45:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     blackfin: fix read buffer overflow
has been removed from the -mm tree.  Its filename was
     blackfin-fix-read-buffer-overflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: blackfin: fix read buffer overflow
From: Roel Kluin <roel.kluin@gmail.com>

Check whether index is within bounds before testing the element.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/kernel/bfin_dma_5xx.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/blackfin/kernel/bfin_dma_5xx.c~blackfin-fix-read-buffer-overflow arch/blackfin/kernel/bfin_dma_5xx.c
--- a/arch/blackfin/kernel/bfin_dma_5xx.c~blackfin-fix-read-buffer-overflow
+++ a/arch/blackfin/kernel/bfin_dma_5xx.c
@@ -146,8 +146,8 @@ EXPORT_SYMBOL(request_dma);
 
 int set_dma_callback(unsigned int channel, irq_handler_t callback, void *data)
 {
-	BUG_ON(!(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
-	       && channel < MAX_DMA_CHANNELS));
+	BUG_ON(channel >= MAX_DMA_CHANNELS ||
+			dma_ch[channel].chan_status == DMA_CHANNEL_FREE);
 
 	if (callback != NULL) {
 		int ret;
@@ -181,8 +181,8 @@ static void clear_dma_buffer(unsigned in
 void free_dma(unsigned int channel)
 {
 	pr_debug("freedma() : BEGIN \n");
-	BUG_ON(!(dma_ch[channel].chan_status != DMA_CHANNEL_FREE
-	       && channel < MAX_DMA_CHANNELS));
+	BUG_ON(channel >= MAX_DMA_CHANNELS ||
+			dma_ch[channel].chan_status == DMA_CHANNEL_FREE);
 
 	/* Halt the DMA */
 	disable_dma(channel);
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

