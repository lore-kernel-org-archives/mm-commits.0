From: akpm@linux-foundation.org
Subject: - gpio-max7301-fix-the-race-between-chip-addition-and-pins-reconfiguration.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:15:50 -0700
Message-ID: <200810182315.m9INFo8p028695@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751150AbYJRXQK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:16:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbaryshkov@gmail.com, david-b@pacbell.net, g.liakhovetski@pengutronix.de, j.beisert@pengutronix.de, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     gpio: max7301: fix the race between chip addition and pins reconfiguration
has been removed from the -mm tree.  Its filename was
     gpio-max7301-fix-the-race-between-chip-addition-and-pins-reconfiguration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: max7301: fix the race between chip addition and pins reconfiguration
From: Dmitry Baryshkov <dbaryshkov@gmail.com>

There is a small race and code ugliness in max7301: pins are reconfigured
after the chip is registered.  Swap these calls so that the device is
registered in correct state.

Also this fixes the comile-time warning about unchecked gpiochip_remove.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Juergen Beisert <j.beisert@pengutronix.de>
Cc: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/max7301.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN drivers/gpio/max7301.c~gpio-max7301-fix-the-race-between-chip-addition-and-pins-reconfiguration drivers/gpio/max7301.c
--- a/drivers/gpio/max7301.c~gpio-max7301-fix-the-race-between-chip-addition-and-pins-reconfiguration
+++ a/drivers/gpio/max7301.c
@@ -255,10 +255,6 @@ static int __devinit max7301_probe(struc
 	ts->chip.dev = &spi->dev;
 	ts->chip.owner = THIS_MODULE;
 
-	ret = gpiochip_add(&ts->chip);
-	if (ret)
-		goto exit_destroy;
-
 	/*
 	 * tristate all pins in hardware and cache the
 	 * register values for later use.
@@ -269,17 +265,19 @@ static int __devinit max7301_probe(struc
 		max7301_write(spi, 0x08 + i, 0xAA);
 		ts->port_config[i] = 0xAA;
 		for (j = 0; j < 4; j++) {
-			int idx = ts->chip.base + (i - 1) * 4 + j;
-			ret = gpio_direction_input(idx);
+			int offset = (i - 1) * 4 + j;
+			ret = max7301_direction_input(&ts->chip, offset);
 			if (ret)
-				goto exit_remove;
-			gpio_free(idx);
+				goto exit_destroy;
 		}
 	}
+
+	ret = gpiochip_add(&ts->chip);
+	if (ret)
+		goto exit_destroy;
+
 	return ret;
 
-exit_remove:
-	gpiochip_remove(&ts->chip);
 exit_destroy:
 	dev_set_drvdata(&spi->dev, NULL);
 	mutex_destroy(&ts->lock);
_

Patches currently in -mm which might be from dbaryshkov@gmail.com are

origin.patch
add-new-framebuffer-driver-for-fujitsu-mb862xx-gdcs.patch

