From: akpm@linux-foundation.org
Subject: - atmel_spi-throughput-improvement.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:25:44 -0800
Message-ID: <200802070025.m170PPuj006713@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33843 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763866AbYBGAoz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hskinnemoen@atmel.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     atmel_spi throughput improvement
has been removed from the -mm tree.  Its filename was
     atmel_spi-throughput-improvement.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_spi throughput improvement
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

Don't insert (undesirable) delays between consecutive words (DLYBCT) or when
activating chipselects (DLYBS).

Removing the between-word delays improves the performance of bulk transfers
(such as mtd_dataflash, m25p80, mmc_spi) significantly.  In one test, the
improvement was a factor of more than eight!

(The large DLYBCT value came from the legacy at91 SPI driver, and it's not
clear why it used such a huge value.)

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/atmel_spi.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN drivers/spi/atmel_spi.c~atmel_spi-throughput-improvement drivers/spi/atmel_spi.c
--- a/drivers/spi/atmel_spi.c~atmel_spi-throughput-improvement
+++ a/drivers/spi/atmel_spi.c
@@ -490,9 +490,14 @@ static int atmel_spi_setup(struct spi_de
 	if (!(spi->mode & SPI_CPHA))
 		csr |= SPI_BIT(NCPHA);
 
-	/* TODO: DLYBS and DLYBCT */
-	csr |= SPI_BF(DLYBS, 10);
-	csr |= SPI_BF(DLYBCT, 10);
+	/* DLYBS is mostly irrelevant since we manage chipselect using GPIOs.
+	 *
+	 * DLYBCT would add delays between words, slowing down transfers.
+	 * It could potentially be useful to cope with DMA bottlenecks, but
+	 * in those cases it's probably best to just use a lower bitrate.
+	 */
+	csr |= SPI_BF(DLYBS, 0);
+	csr |= SPI_BF(DLYBCT, 0);
 
 	/* chipselect must have been muxed as GPIO (e.g. in board setup) */
 	npcs_pin = (unsigned int)spi->controller_data;
_

Patches currently in -mm which might be from hskinnemoen@atmel.com are

origin.patch
git-avr32.patch
git-mtd.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-avr32.patch
tty-let-architectures-override-the-user-kernel-macros.patch
maintainers-add-haavard-as-maintainer-of-the-atmel_serial-driver.patch
atmel_serial-clean-up-the-code.patch
atmel_serial-use-cpu_relax-when-busy-waiting.patch
atmel_serial-use-existing-console-options-only-if-brg-is-running.patch
atmel_serial-fix-bugs-in-probe-error-path-and-remove.patch
atmel_serial-split-the-interrupt-handler.patch
atmel_serial-add-dma-support.patch
atmel_serial-add-dma-support-fix.patch
atmel_serial-fix-broken-rx-buffer-allocation.patch
atmel_serial-use-container_of-instead-of-direct-cast.patch
atmel_serial-show-tty-name-in-proc-interrupts.patch
basic-pwm-driver-for-avr32-and-at91.patch
basic-pwm-driver-for-avr32-and-at91-fix.patch
pwm-led-driver.patch
