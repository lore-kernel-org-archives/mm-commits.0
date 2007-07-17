From: akpm@linux-foundation.org
Subject: - spidev-compiler-warning-gone.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:02:58 -0700
Message-ID: <200707172302.l6HN2w4L011645@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49175 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936648AbXGQXQG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spidev compiler warning gone
has been removed from the -mm tree.  Its filename was
     spidev-compiler-warning-gone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 4 insertions(+), 2 deletions(-)

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

origin.patch
git-leds.patch
git-mmc.patch
git-mtd.patch
git-backlight.patch
use-mutex-instead-of-semaphore-in-the-usb-gadget-serial-driver.patch
geode-basic-infrastructure-support-for-amd-geode-class.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
gpio-calls-dont-need-i-o-barriers.patch
dev_vdbg-available-with-dverbose_debug.patch
dev_vdbg-available-with-dverbose_debug-docs.patch
