From: akpm@linux-foundation.org
Subject: + spidev-compiler-warning-gone.patch added to -mm tree
Date: Tue, 29 May 2007 15:03:38 -0700
Message-ID: <200705292203.l4TM3c6P012741@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750711AbXE2WDs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 18:03:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     spidev compiler warning gone
has been added to the -mm tree.  Its filename is
     spidev-compiler-warning-gone.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spidev compiler warning gone
From: David Brownell <david-b@pacbell.net>

Get rid of annoying GCC warning on 32-bit platforms.

drivers/spi/spidev.c: In function 'spidev_message':
drivers/spi/spidev.c:184: warning: cast to pointer from integer of different size
drivers/spi/spidev.c:216: warning: cast to pointer from integer of different size


The trick is to add an extra cast using "ptrdiff_t" to convert the u64 to
the correct size integer, and only then casting it into a "void *" pointer.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spidev.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/spi/spidev.c~spidev-compiler-warning-gone drivers/spi/spidev.c
--- a/drivers/spi/spidev.c~spidev-compiler-warning-gone
+++ a/drivers/spi/spidev.c
@@ -181,7 +181,8 @@ static int spidev_message(struct spidev_
 		}
 		if (u_tmp->tx_buf) {
 			k_tmp->tx_buf = buf;
-			if (copy_from_user(buf, (const u8 __user *)u_tmp->tx_buf,
+			if (copy_from_user(buf, (const u8 __user *)
+						(ptrdiff_t) u_tmp->tx_buf,
 					u_tmp->len))
 				goto done;
 		}
@@ -213,7 +214,8 @@ static int spidev_message(struct spidev_
 	buf = spidev->buffer;
 	for (n = n_xfers, u_tmp = u_xfers; n; n--, u_tmp++) {
 		if (u_tmp->rx_buf) {
-			if (__copy_to_user((u8 __user *)u_tmp->rx_buf, buf,
+			if (__copy_to_user((u8 __user *)
+					(ptrdiff_t) u_tmp->rx_buf, buf,
 					u_tmp->len)) {
 				status = -EFAULT;
 				goto done;
_

Patches currently in -mm which might be from david-b@pacbell.net are

at91-fix-enable-disable_irq_wake-symmetry-in-pcmcia-driver.patch
git-leds.patch
git-mmc.patch
spi-controller-drivers-check-for-unsupported-modes.patch
spi-add-3wire-mode-flag.patch
spi-add-3wire-mode-flag-fix.patch
spidev-compiler-warning-gone.patch
rtc-ds1307-cleanups.patch
rtc-rs5c372-becomes-a-new-style-i2c-driver.patch
