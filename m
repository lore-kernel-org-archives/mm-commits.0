From: akpm@linux-foundation.org
Subject: [merged] spi_mpc83xx-quieten-down-the-requested-speed-is-too-low-message.patch removed from -mm tree
Date: Mon, 22 Jun 2009 10:00:06 -0700
Message-ID: <200906221700.n5MH06hC009362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40641 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751233AbZFVRCC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jun 2009 13:02:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, benh@kernel.crashing.org, david-b@pacbell.net, galak@gate.crashing.org, mm-commits@vger.kernel.org


The patch titled
     spi_mpc83xx: quieten down the "Requested speed is too low" message
has been removed from the -mm tree.  Its filename was
     spi_mpc83xx-quieten-down-the-requested-speed-is-too-low-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi_mpc83xx: quieten down the "Requested speed is too low" message
From: Anton Vorontsov <avorontsov@ru.mvista.com>

When a platform is running at high frequencies it's not always possible to
scale-down a frequency to a requested value, and using mmc_spi driver this
leads to the following printk flood during card polling:

  ...
  mmc_spi spi32766.0: Requested speed is too low: 400000 Hz. Will use
  520828 Hz instead.
  mmc_spi spi32766.0: Requested speed is too low: 400000 Hz. Will use
  520828 Hz instead.
  ...

Fix this by using WARN_ONCE(), it's better than the flood, and also better
than turning dev_err() into dev_dbg(), since we actually want to warn that
some things may not work correctly.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: David Brownell <david-b@pacbell.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_mpc83xx.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN drivers/spi/spi_mpc83xx.c~spi_mpc83xx-quieten-down-the-requested-speed-is-too-low-message drivers/spi/spi_mpc83xx.c
--- a/drivers/spi/spi_mpc83xx.c~spi_mpc83xx-quieten-down-the-requested-speed-is-too-low-message
+++ a/drivers/spi/spi_mpc83xx.c
@@ -14,6 +14,7 @@
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
+#include <linux/bug.h>
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/completion.h>
@@ -275,12 +276,12 @@ int mpc83xx_spi_setup_transfer(struct sp
 	if ((mpc83xx_spi->spibrg / hz) > 64) {
 		cs->hw_mode |= SPMODE_DIV16;
 		pm = mpc83xx_spi->spibrg / (hz * 64);
-		if (pm > 16) {
-			dev_err(&spi->dev, "Requested speed is too "
-				"low: %d Hz. Will use %d Hz instead.\n",
-				hz, mpc83xx_spi->spibrg / 1024);
+
+		WARN_ONCE(pm > 16, "%s: Requested speed is too low: %d Hz. "
+			  "Will use %d Hz instead.\n", dev_name(&spi->dev),
+			  hz, mpc83xx_spi->spibrg / 1024);
+		if (pm > 16)
 			pm = 16;
-		}
 	} else
 		pm = mpc83xx_spi->spibrg / (hz * 4);
 	if (pm)
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
linux-next.patch
usb-mutually-exclusive-port_status.patch

