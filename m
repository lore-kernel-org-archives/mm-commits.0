From: akpm@linux-foundation.org
Subject: + gpio-max7301-fix-the-race-between-chip-addition-and-pins-reconfiguration.patch added to -mm tree
Date: Thu, 21 Aug 2008 12:44:08 -0700
Message-ID: <200808211944.m7LJi8l2022572@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43834 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751594AbYHUTpG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Aug 2008 15:45:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbaryshkov@gmail.com, david-b@pacbell.net, g.liakhovetski@pengutronix.de, j.beisert@pengutronix.de, rmk@arm.linux.org.uk


The patch titled
     gpio: max7301: fix the race between chip addition and pins reconfiguration
has been added to the -mm tree.  Its filename is
     gpio-max7301-fix-the-race-between-chip-addition-and-pins-reconfiguration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
make-gpiochip-label-const.patch
gpio-max7301-fix-the-race-between-chip-addition-and-pins-reconfiguration.patch

