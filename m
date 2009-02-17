From: akpm@linux-foundation.org
Subject: [merged] mtd-maps-blackfin-async-flash-maps-fix-bug-dont-leak-resources-when-initializing-in-case-of-errors.patch removed from -mm tree
Date: Tue, 17 Feb 2009 12:09:09 -0800
Message-ID: <200902172009.n1HK99OV001668@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752919AbZBQUPU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Feb 2009 15:15:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, cooloney@kernel.org, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mtd/maps: blackfin async flash maps - fix bug: dont leak resources when initializing in case of errors
has been removed from the -mm tree.  Its filename was
     mtd-maps-blackfin-async-flash-maps-fix-bug-dont-leak-resources-when-initializing-in-case-of-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd/maps: blackfin async flash maps - fix bug: dont leak resources when initializing in case of errors
From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/maps/bfin-async-flash.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/mtd/maps/bfin-async-flash.c~mtd-maps-blackfin-async-flash-maps-fix-bug-dont-leak-resources-when-initializing-in-case-of-errors drivers/mtd/maps/bfin-async-flash.c
--- a/drivers/mtd/maps/bfin-async-flash.c~mtd-maps-blackfin-async-flash-maps-fix-bug-dont-leak-resources-when-initializing-in-case-of-errors
+++ a/drivers/mtd/maps/bfin-async-flash.c
@@ -152,14 +152,18 @@ static int __devinit bfin_flash_probe(st
 
 	if (gpio_request(state->enet_flash_pin, DRIVER_NAME)) {
 		pr_devinit(KERN_ERR DRIVER_NAME ": Failed to request gpio %d\n", state->enet_flash_pin);
+		kfree(state);
 		return -EBUSY;
 	}
 	gpio_direction_output(state->enet_flash_pin, 1);
 
 	pr_devinit(KERN_NOTICE DRIVER_NAME ": probing %d-bit flash bus\n", state->map.bankwidth * 8);
 	state->mtd = do_map_probe(memory->name, &state->map);
-	if (!state->mtd)
+	if (!state->mtd) {
+		gpio_free(state->enet_flash_pin);
+		kfree(state);
 		return -ENXIO;
+	}
 
 #ifdef CONFIG_MTD_PARTITIONS
 	ret = parse_mtd_partitions(state->mtd, part_probe_types, &pdata->parts, 0);
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

linux-next.patch
blackfin-nfc-driver-do-not-clobber-dmac1_perimux.patch
blackfin-nfc-driver-mark-bf5xx_nand_add_partition-as-__devinit.patch
blackfin-nfc-driver-drop-pointless-casts-with-set_dma_callback.patch
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

