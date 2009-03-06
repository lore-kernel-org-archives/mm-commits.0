From: akpm@linux-foundation.org
Subject: + mmc-align-data-size-for-host-which-only-supports-power-of-2-block.patch added to -mm tree
Date: Fri, 06 Mar 2009 14:08:23 -0800
Message-ID: <200903062208.n26M8NSH004472@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42791 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750995AbZCFWIl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Mar 2009 17:08:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cooloney@kernel.org, cliff.cai@analog.com, drzeus@drzeus.cx


The patch titled
     mmc: align data size for host which only supports power-of-2 block
has been added to the -mm tree.  Its filename is
     mmc-align-data-size-for-host-which-only-supports-power-of-2-block.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: align data size for host which only supports power-of-2 block
From: Bryan Wu <cooloney@kernel.org>


Signed-off-by: Cliff Cai <cliff.cai@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/core.c  |    8 +++++++-
 include/linux/mmc/host.h |    1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

diff -puN drivers/mmc/core/core.c~mmc-align-data-size-for-host-which-only-supports-power-of-2-block drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c~mmc-align-data-size-for-host-which-only-supports-power-of-2-block
+++ a/drivers/mmc/core/core.c
@@ -321,7 +321,13 @@ unsigned int mmc_align_data_size(struct 
 	 * the core about its problems yet, so for now we just 32-bit
 	 * align the size.
 	 */
-	sz = ((sz + 3) / 4) * 4;
+
+	/* Align size for host which only supports power-of-2 block */
+	if (card->host->powerof2_block) {
+		if (sz & (sz - 1))
+			sz = 1 << fls(sz);
+	} else
+		sz = ((sz + 3) / 4) * 4;
 
 	return sz;
 }
diff -puN include/linux/mmc/host.h~mmc-align-data-size-for-host-which-only-supports-power-of-2-block include/linux/mmc/host.h
--- a/include/linux/mmc/host.h~mmc-align-data-size-for-host-which-only-supports-power-of-2-block
+++ a/include/linux/mmc/host.h
@@ -162,6 +162,7 @@ struct mmc_host {
 	struct dentry		*debugfs_root;
 
 	unsigned long		private[0] ____cacheline_aligned;
+	unsigned int		powerof2_block;	/* host only supports power-of-2 block */
 };
 
 extern struct mmc_host *mmc_alloc_host(int extra, struct device *);
_

Patches currently in -mm which might be from cooloney@kernel.org are

linux-next.patch
input-ad7879-touchscreen-driver.patch
mmc-align-data-size-for-host-which-only-supports-power-of-2-block.patch
blackfin-nfc-driver-do-not-clobber-dmac1_perimux.patch
blackfin-nfc-driver-mark-bf5xx_nand_add_partition-as-__devinit.patch
blackfin-nfc-driver-drop-pointless-casts-with-set_dma_callback.patch
usb-serial-ftdi-enable-uart-detection-on-gnice-jtag-adaptors-blacklist-interface0.patch
flat-fix-data-sections-alignment.patch
flat-fix-data-sections-alignment-update.patch
blackfin-spi-driver-ensure-cache-coherency-before-doing-dma.patch
blackfin-spi-driver-fix-erroneous-spi-clock-divisor-calculation.patch
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
blackfin-spi-driver-fix-bug-spi-controller-driver-does-not-assert-deassert-cs-correctly.patch
blackfin-spi-driver-fix-bug-correct-usage-of-struct-spi_transfercs_change.patch
blackfin-spi-driver-use-bfin_spi_-prefix-on-all-functions.patch
blackfin-spi-driver-fix-null-pointer-crash.patch
blackfin-spi-driver-add-gpio-controlled-spi-slave-select-support.patch
blackfin-spi-driver-make-mmc_spi-driver-work-on-blackfin.patch
bin_elf_fdpic-check-the-return-value-of-clear_user.patch

