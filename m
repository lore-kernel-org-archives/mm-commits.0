From: akpm@linux-foundation.org
Subject: [merged] blackfin-serial-driver-explain-why-we-cannot-cpu_relax-in-early-serial-code.patch removed from -mm tree
Date: Thu, 12 Mar 2009 13:17:03 -0700
Message-ID: <200903122017.n2CKH3ro032627@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43490 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751150AbZCLUUG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Mar 2009 16:20:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk, cooloney@kernel.org, mm-commits@vger.kernel.org


The patch titled
     blackfin serial driver: explain why we cannot cpu_relax() in early serial code
has been removed from the -mm tree.  Its filename was
     blackfin-serial-driver-explain-why-we-cannot-cpu_relax-in-early-serial-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: blackfin serial driver: explain why we cannot cpu_relax() in early serial code
From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/bfin_5xx.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/serial/bfin_5xx.c~blackfin-serial-driver-explain-why-we-cannot-cpu_relax-in-early-serial-code drivers/serial/bfin_5xx.c
--- a/drivers/serial/bfin_5xx.c~blackfin-serial-driver-explain-why-we-cannot-cpu_relax-in-early-serial-code
+++ a/drivers/serial/bfin_5xx.c
@@ -1190,6 +1190,10 @@ static __init void early_serial_putc(str
 	unsigned timeout = 0xffff;
 	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
 
+	/* We cannot cpu_relax() here as doing so on the BF561 relies
+	 * on the per-cpu region being setup, and since this is early
+	 * serial code, it may not yet be usable ...
+	 */
 	while ((!(UART_GET_LSR(uart) & THRE)) && --timeout)
 		barrier();
 
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

origin.patch
linux-next.patch
blackfin-nfc-driver-do-not-clobber-dmac1_perimux.patch
blackfin-nfc-driver-mark-bf5xx_nand_add_partition-as-__devinit.patch
blackfin-nfc-driver-drop-pointless-casts-with-set_dma_callback.patch
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

