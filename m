From: akpm@linux-foundation.org
Subject: + rtc-ds1307-ds_1340-change-init.patch added to -mm tree
Date: Wed, 23 Jan 2008 14:18:40 -0800
Message-ID: <200801232218.m0NMIWnX029309@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53417 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752358AbYAWWTM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jan 2008 17:19:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: f.rodo@til-technologies.fr, a.zummo@towertech.it, david-b@pacbell.net, khali@linux-fr.org, rmk@arm.linux.org.uk


The patch titled
     rtc-ds1307: ds_1340 change init
has been added to the -mm tree.  Its filename is
     rtc-ds1307-ds_1340-change-init.patch

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
Subject: rtc-ds1307: ds_1340 change init
From: frederic RODO <f.rodo@til-technologies.fr>

Change the initialization of ds1340 according to the FIXME.

It was tested on a arm custom board, this is the log when I plug the board
without backup battery.

Linux version 2.6.24-rc7 (fredo@srv-devhard) (gcc version 3.4.6) #22 Tue
Jan 15 19:45:16 CET 2008
.......
Kernel command line: debug
.......
atmel_spi atmel_spi.1: Atmel SPI Controller at 0xfffcc000 (irq 13)
i2c /dev entries driver
rtc-ds1307 0-0068: SET TIME!
rtc-ds1307 0-0068: rtc core: registered ds1340 as rtc0
i2c-gpio i2c-gpio: using pins 55 (SDA) and 56 (SCL)
.......

Signed-off-by: Frederic RODO <f.rodo@til-technologies.fr>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |   33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-ds1307.c~rtc-ds1307-ds_1340-change-init drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-ds1307-ds_1340-change-init
+++ a/drivers/rtc/rtc-ds1307.c
@@ -392,6 +392,33 @@ static int __devinit ds1307_probe(struct
 			dev_warn(&client->dev, "SET TIME!\n");
 		}
 		break;
+	case ds_1340:
+		/* Test nEOSC before OSF */
+		tmp = i2c_smbus_read_byte_data(client, DS1307_REG_SECS);
+		if (tmp < 0) {
+			pr_debug("read error %d\n", tmp);
+			err = -EIO;
+			goto exit_free;
+		}
+
+		/* oscillator off?  turn it on, so clock can tick. */
+		if (tmp & DS1340_BIT_nEOSC)
+			i2c_smbus_write_byte_data(client, DS1307_REG_SECS,
+				tmp & ~DS1340_BIT_nEOSC);
+
+		tmp = i2c_smbus_read_byte_data(client, DS1340_REG_FLAG);
+		if (tmp < 0) {
+			pr_debug("read error %d\n", tmp);
+			err = -EIO;
+			goto exit_free;
+		}
+
+		/* oscillator fault?  clear flag, and warn */
+		if (tmp & DS1340_BIT_OSF) {
+			i2c_smbus_write_byte_data(client, DS1340_REG_FLAG, 0);
+			dev_warn(&client->dev, "SET TIME!\n");
+		}
+		break;
 	default:
 		break;
 	}
@@ -412,11 +439,6 @@ read_rtc:
 	 */
 	tmp = ds1307->regs[DS1307_REG_SECS];
 	switch (ds1307->type) {
-	case ds_1340:
-		/* FIXME read register with DS1340_BIT_OSF, use that to
-		 * trigger the "set time" warning (*after* restarting the
-		 * oscillator!) instead of this weaker ds1307/m41t00 test.
-		 */
 	case ds_1307:
 	case m41t00:
 		/* clock halted?  turn it on, so clock can tick. */
@@ -442,6 +464,7 @@ read_rtc:
 		break;
 	case ds_1337:
 	case ds_1339:
+	case ds_1340:
 		break;
 	}
 
_

Patches currently in -mm which might be from f.rodo@til-technologies.fr are

rtc-ds1307-ds_1340-change-init.patch
