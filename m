From: akpm@linux-foundation.org
Subject: - spidev-warning-fix.patch removed from -mm tree
Date: Mon, 13 Aug 2007 22:03:39 -0700
Message-ID: <200708140503.l7E53dlm032078@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51375 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765605AbXHNFLG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 01:11:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spidev warning fix
has been removed from the -mm tree.  Its filename was
     spidev-warning-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spidev warning fix
From: David Brownell <david-b@pacbell.net>

Git rid of "warning: passing arg 2 of `access_ok' makes pointer from integer
without a cast" reported on SH ...  most architectures use macros in that
test, SH uses inlined functions.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spidev.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/spi/spidev.c~spidev-warning-fix drivers/spi/spidev.c
--- a/drivers/spi/spidev.c~spidev-warning-fix
+++ a/drivers/spi/spidev.c
@@ -183,7 +183,9 @@ static int spidev_message(struct spidev_
 
 		if (u_tmp->rx_buf) {
 			k_tmp->rx_buf = buf;
-			if (!access_ok(VERIFY_WRITE, u_tmp->rx_buf, u_tmp->len))
+			if (!access_ok(VERIFY_WRITE, (u8 __user *)
+						(ptrdiff_t) u_tmp->rx_buf,
+						u_tmp->len))
 				goto done;
 		}
 		if (u_tmp->tx_buf) {
_

Patches currently in -mm which might be from david-b@pacbell.net are

git-avr32.patch
git-mmc.patch
git-mtd.patch
dma_free_coherent-needs-irqs-enabled-sigh.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91.patch
clean-up-duplicate-includes-in-drivers-spi.patch
rtc-periodic-irq-fix.patch
rtc_irq_set_freq-requires-power-of-two-and-associated-kerneldoc.patch
