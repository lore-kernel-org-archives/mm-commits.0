From: akpm@linux-foundation.org
Subject: [merged] blackfin-nfc-driver-do-not-clobber-dmac1_perimux.patch removed from -mm tree
Date: Mon, 30 Mar 2009 12:05:33 -0700
Message-ID: <200903301905.n2UJ5X3e018712@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34232 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759134AbZC3TKe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 15:10:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, cooloney@kernel.org, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mtd: Blackfin NFC Driver: do not clobber DMAC1_PERIMUX
has been removed from the -mm tree.  Its filename was
     blackfin-nfc-driver-do-not-clobber-dmac1_perimux.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: Blackfin NFC Driver: do not clobber DMAC1_PERIMUX
From: Mike Frysinger <vapier.adi@gmail.com>

Only set DMAC1_PERIMUX once we have requested and been granted the dma
channel to prevent breaking other peripherals in the error case

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/bf5xx_nand.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN drivers/mtd/nand/bf5xx_nand.c~blackfin-nfc-driver-do-not-clobber-dmac1_perimux drivers/mtd/nand/bf5xx_nand.c
--- a/drivers/mtd/nand/bf5xx_nand.c~blackfin-nfc-driver-do-not-clobber-dmac1_perimux
+++ a/drivers/mtd/nand/bf5xx_nand.c
@@ -552,7 +552,6 @@ static void bf5xx_nand_dma_write_buf(str
 static int bf5xx_nand_dma_init(struct bf5xx_nand_info *info)
 {
 	int ret;
-	unsigned short val;
 
 	/* Do not use dma */
 	if (!hardware_ecc)
@@ -560,13 +559,6 @@ static int bf5xx_nand_dma_init(struct bf
 
 	init_completion(&info->dma_completion);
 
-#ifdef CONFIG_BF54x
-	/* Setup DMAC1 channel mux for NFC which shared with SDH */
-	val = bfin_read_DMAC1_PERIMUX();
-	val &= 0xFFFE;
-	bfin_write_DMAC1_PERIMUX(val);
-	SSYNC();
-#endif
 	/* Request NFC DMA channel */
 	ret = request_dma(CH_NFC, "BF5XX NFC driver");
 	if (ret < 0) {
@@ -574,6 +566,12 @@ static int bf5xx_nand_dma_init(struct bf
 		return ret;
 	}
 
+#ifdef CONFIG_BF54x
+	/* Setup DMAC1 channel mux for NFC which shared with SDH */
+	bfin_write_DMAC1_PERIMUX(bfin_read_DMAC1_PERIMUX() & ~1);
+	SSYNC();
+#endif
+
 	set_dma_callback(CH_NFC, (void *) bf5xx_nand_dma_irq, (void *) info);
 
 	/* Turn off the DMA channel first */
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

origin.patch
linux-next.patch
blackfin-serial-driver-irq-funcs-take-an-unsigned-long-for-flags.patch
blackfin-serial-driver-update-kgdb-uart-config-name.patch
blackfin-serial-driver-fix-building-when-debug-is-enabled-but-serial-console-is-disabled.patch
blackfin-serial-driver-depend-on-kgdb_serial_console-being-set-to-n.patch
blackfin-serial-driver-use-the-dlab-macro-to-hide-variant-differences.patch
blackfin-serial-driver-update-path-to-gpio-header.patch
flat-fix-data-sections-alignment-update.patch
blackfin-spi-driver-ensure-cache-coherency-before-doing-dma.patch
blackfin-spi-driver-remove-useless-asm-cplbinith.patch
blackfin-spi-driver-use-len_in_bytes-when-we-care-about-the-number-of-bytes-transferred.patch
blackfin-spi-driver-pass-dma-overflow-error-to-the-higher-level.patch
blackfin-spi-driver-unify-duplicated-code-in-dma-read-write-paths.patch
blackfin-spi-driver-drop-bogus-cast-and-touchup-dma-label.patch
blackfin-spi-driver-add-a-few-more-dma-debug-messages.patch
blackfin-spi-driver-do-not-check-for-spi-errors-if-dma-itself-did-not-flag-any.patch
blackfin-spi-driver-use-the-properl-bit_ctl_xxx-defines.patch
blackfin-spi-driver-spi-slave-select-code-cleanup.patch
blackfin-spi-driver-get-dma-working-for-spi-flashes.patch
blackfin-spi-driver-add-timeout-while-waiting-for-spif-in-dma-irq-handler.patch
blackfin-spi-driver-tweak-magic-spi-dma-sequence-to-get-it-working-on-bf54x.patch
blackfin-spi-driver-use-bfin_spi_-prefix-on-all-functions.patch
blackfin-spi-driver-fix-null-pointer-crash.patch
bin_elf_fdpic-check-the-return-value-of-clear_user.patch

