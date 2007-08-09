From: akpm@linux-foundation.org
Subject: + spidev-warning-fix.patch added to -mm tree
Date: Thu, 09 Aug 2007 13:41:30 -0700
Message-ID: <200708092041.l79KfUXp018462@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35477 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753545AbXHIUlt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 16:41:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     spidev warning fix
has been added to the -mm tree.  Its filename is
     spidev-warning-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

spidev-warning-fix.patch
git-mmc.patch
git-mtd.patch
dma_free_coherent-needs-irqs-enabled-sigh.patch
rtc-periodic-irq-fix.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91.patch
clean-up-duplicate-includes-in-drivers-spi.patch
rtc_irq_set_freq-requires-power-of-two-and-associated-kerneldoc.patch
