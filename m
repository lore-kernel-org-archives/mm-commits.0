From: akpm@linux-foundation.org
Subject: [to-be-updated] mtd-maps-blackfin-async-flash-maps-fix-up-memory-leak.patch removed from -mm tree
Date: Wed, 11 Feb 2009 16:42:27 -0800
Message-ID: <200902120042.n1C0gRpR011360@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57011 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754921AbZBLAmr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Feb 2009 19:42:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, cooloney@kernel.org, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mtd/maps: blackfin async flash maps: fix up memory leak
has been removed from the -mm tree.  Its filename was
     mtd-maps-blackfin-async-flash-maps-fix-up-memory-leak.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd/maps: blackfin async flash maps: fix up memory leak
From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/maps/bfin-async-flash.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/mtd/maps/bfin-async-flash.c~mtd-maps-blackfin-async-flash-maps-fix-up-memory-leak drivers/mtd/maps/bfin-async-flash.c
--- a/drivers/mtd/maps/bfin-async-flash.c~mtd-maps-blackfin-async-flash-maps-fix-up-memory-leak
+++ a/drivers/mtd/maps/bfin-async-flash.c
@@ -170,6 +170,7 @@ static int __devinit bfin_flash_probe(st
 	if (ret > 0) {
 		pr_devinit(KERN_NOTICE DRIVER_NAME ": Using commandline partition definition\n");
 		add_mtd_partitions(state->mtd, pdata->parts, ret);
+		kfree(pdata->parts);
 
 	} else if (pdata->nr_parts) {
 		pr_devinit(KERN_NOTICE DRIVER_NAME ": Using board partition definition\n");
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

video-framebuffer-move-the-probe-func-into-devinittext-in-blackfin-lcd-driver.patch
linux-next.patch
blackfin-nfc-driver-do-not-clobber-dmac1_perimux.patch
blackfin-nfc-driver-mark-bf5xx_nand_add_partition-as-__devinit.patch
blackfin-nfc-driver-drop-pointless-casts-with-set_dma_callback.patch
mtd-maps-blackfin-async-flash-maps-fix-bug-dont-leak-resources-when-initializing-in-case-of-errors.patch
mtd-maps-blackfin-async-flash-maps-bfin-async-mtd-driver-needs-complex-mappings.patch
mtd-maps-blackfin-async-flash-maps-fix-up-memory-leak.patch
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

