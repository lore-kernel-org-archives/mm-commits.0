From: akpm@linux-foundation.org
Subject: + rtc-pcf8563-remove-client-validation.patch added to -mm tree
Date: Mon, 28 Jul 2008 22:26:05 -0700
Message-ID: <200807290526.m6T5Q5Sp016170@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752608AbYG2F0b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 01:26:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laurentp@cse-semaphore.com, a.zummo@towertech.it, david-b@pacbell.net


The patch titled
     rtc-pcf8563: remove client validation
has been added to the -mm tree.  Its filename is
     rtc-pcf8563-remove-client-validation.patch

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
Subject: rtc-pcf8563: remove client validation
From: Laurent Pinchart <laurentp@cse-semaphore.com>

Validating clients with black magic register checks doesn't make much
sense for new-style i2c driver and has been known to fail on valid NXP
pcf8563 chips.  This patch removes the client validation code.

Signed-off-by: Laurent Pinchart <laurentp@cse-semaphore.com>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8563.c |   58 ------------------------------------
 1 file changed, 58 deletions(-)

diff -puN drivers/rtc/rtc-pcf8563.c~rtc-pcf8563-remove-client-validation drivers/rtc/rtc-pcf8563.c
--- a/drivers/rtc/rtc-pcf8563.c~rtc-pcf8563-remove-client-validation
+++ a/drivers/rtc/rtc-pcf8563.c
@@ -179,58 +179,6 @@ struct pcf8563_limit
 	unsigned char max;
 };
 
-static int pcf8563_validate_client(struct i2c_client *client)
-{
-	int i;
-
-	static const struct pcf8563_limit pattern[] = {
-		/* register, mask, min, max */
-		{ PCF8563_REG_SC,	0x7F,	0,	59	},
-		{ PCF8563_REG_MN,	0x7F,	0,	59	},
-		{ PCF8563_REG_HR,	0x3F,	0,	23	},
-		{ PCF8563_REG_DM,	0x3F,	0,	31	},
-		{ PCF8563_REG_MO,	0x1F,	0,	12	},
-	};
-
-	/* check limits (only registers with bcd values) */
-	for (i = 0; i < ARRAY_SIZE(pattern); i++) {
-		int xfer;
-		unsigned char value;
-		unsigned char buf = pattern[i].reg;
-
-		struct i2c_msg msgs[] = {
-			{ client->addr, 0, 1, &buf },
-			{ client->addr, I2C_M_RD, 1, &buf },
-		};
-
-		xfer = i2c_transfer(client->adapter, msgs, ARRAY_SIZE(msgs));
-
-		if (xfer != ARRAY_SIZE(msgs)) {
-			dev_err(&client->dev,
-				"%s: could not read register 0x%02X\n",
-				__func__, pattern[i].reg);
-
-			return -EIO;
-		}
-
-		value = BCD2BIN(buf & pattern[i].mask);
-
-		if (value > pattern[i].max ||
-			value < pattern[i].min) {
-			dev_dbg(&client->dev,
-				"%s: pattern=%d, reg=%x, mask=0x%02x, min=%d, "
-				"max=%d, value=%d, raw=0x%02X\n",
-				__func__, i, pattern[i].reg, pattern[i].mask,
-				pattern[i].min, pattern[i].max,
-				value, buf);
-
-			return -ENODEV;
-		}
-	}
-
-	return 0;
-}
-
 static int pcf8563_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
 	return pcf8563_get_datetime(to_i2c_client(dev), tm);
@@ -262,12 +210,6 @@ static int pcf8563_probe(struct i2c_clie
 	if (!pcf8563)
 		return -ENOMEM;
 
-	/* Verify the chip is really an PCF8563 */
-	if (pcf8563_validate_client(client) < 0) {
-		err = -ENODEV;
-		goto exit_kfree;
-	}
