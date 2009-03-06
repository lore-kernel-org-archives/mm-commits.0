From: akpm@linux-foundation.org
Subject: + blackfin-serial-driver-depend-on-kgdb_serial_console-being-set-to-n.patch added to -mm tree
Date: Fri, 06 Mar 2009 14:37:30 -0800
Message-ID: <200903062237.n26MbVw4007065@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40450 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754786AbZCFWn3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Mar 2009 17:43:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk, cooloney@kernel.org


The patch titled
     blackfin serial driver: depend on KGDB_SERIAL_CONSOLE being set to N
has been added to the -mm tree.  Its filename is
     blackfin-serial-driver-depend-on-kgdb_serial_console-being-set-to-n.patch

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
Subject: blackfin serial driver: depend on KGDB_SERIAL_CONSOLE being set to N
From: Mike Frysinger <vapier.adi@gmail.com>

Depend on KGDB_SERIAL_CONSOLE being set to N rather than !Y, since it can
be built as a module.

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/serial/Kconfig~blackfin-serial-driver-depend-on-kgdb_serial_console-being-set-to-n drivers/serial/Kconfig
--- a/drivers/serial/Kconfig~blackfin-serial-driver-depend-on-kgdb_serial_console-being-set-to-n
+++ a/drivers/serial/Kconfig
@@ -700,7 +700,7 @@ choice
 
 config SERIAL_BFIN_DMA
 	bool "DMA mode"
-	depends on !DMA_UNCACHED_NONE && !KGDB_SERIAL_CONSOLE
+	depends on !DMA_UNCACHED_NONE && KGDB_SERIAL_CONSOLE=n
 	help
 	  This driver works under DMA mode. If this option is selected, the
 	  blackfin simple dma driver is also enabled.
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

linux-next.patch
blackfin-nfc-driver-do-not-clobber-dmac1_perimux.patch
blackfin-nfc-driver-mark-bf5xx_nand_add_partition-as-__devinit.patch
blackfin-nfc-driver-drop-pointless-casts-with-set_dma_callback.patch
blackfin-serial-driver-explain-why-we-cannot-cpu_relax-in-early-serial-code.patch
blackfin-serial-driver-use-unsigned-long-for-flags-with-irq-functions-rather-than-int.patch
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

