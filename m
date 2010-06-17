From: akpm@linux-foundation.org
Subject: + gpio-max730x-make-pullups-configurable-via-platformdata.patch added to -mm tree
Date: Thu, 17 Jun 2010 13:59:32 -0700
Message-ID: <201006172059.o5HKxWsY027108@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59801 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757139Ab0FQU7y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jun 2010 16:59:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mkl@pengutronix.de, david-b@pacbell.net, w.sang@pengutronix.de


The patch titled
     gpio: max730x: make pullups configurable via platformdata
has been added to the -mm tree.  Its filename is
     gpio-max730x-make-pullups-configurable-via-platformdata.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: max730x: make pullups configurable via platformdata
From: Marc Kleine-Budde <mkl@pengutronix.de>

The gpios on the max730x chips have support for internal pullups while in
input mode.

This patch adds support for configuring these pullups via platform data. 
A new member ("input_pullup_active") to the platform data struct is
introduced.  A set bit in this variable activates the pullups while the
respective port is in input mode.  This is a compatible enhancement since
unset bits lead to disables pullups which was the default in the original
driver.

_Note_: the 4 lowest bits in "input_pullup_active" are unused because the
first 4 ports of the controller are not used, too.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/max730x.c      |   22 +++++++++++++++-------
 include/linux/spi/max7301.h |    8 ++++++++
 2 files changed, 23 insertions(+), 7 deletions(-)

diff -puN drivers/gpio/max730x.c~gpio-max730x-make-pullups-configurable-via-platformdata drivers/gpio/max730x.c
--- a/drivers/gpio/max730x.c~gpio-max730x-make-pullups-configurable-via-platformdata
+++ a/drivers/gpio/max730x.c
@@ -54,7 +54,7 @@ static int max7301_direction_input(struc
 {
 	struct max7301 *ts = container_of(chip, struct max7301, chip);
 	u8 *config;
-	u8 offset_bits;
+	u8 offset_bits, pin_config;
 	int ret;
 
 	/* First 4 pins are unused in the controller */
@@ -63,12 +63,15 @@ static int max7301_direction_input(struc
 
 	config = &ts->port_config[offset >> 2];
 
+	if (ts->input_pullup_active & BIT(offset))
+		pin_config = PIN_CONFIG_IN_PULLUP;
+	else
+		pin_config = PIN_CONFIG_IN_WO_PULLUP;
+
 	mutex_lock(&ts->lock);
 
-	/* Standard GPIO API doesn't support pull-ups, has to be extended.
-	 * Hard-coding no pollup for now. */
 	*config = (*config & ~(PIN_CONFIG_MASK << offset_bits))
-			   | (PIN_CONFIG_IN_WO_PULLUP << offset_bits);
+			   | (pin_config << offset_bits);
 
 	ret = ts->write(ts->dev, 0x08 + (offset >> 2), *config);
 
@@ -177,6 +180,7 @@ int __devinit __max730x_probe(struct max
 	/* Power up the chip and disable IRQ output */
 	ts->write(dev, 0x04, 0x01);
 
+	ts->input_pullup_active = pdata->input_pullup_active;
 	ts->chip.label = dev->driver->name;
 
 	ts->chip.direction_input = max7301_direction_input;
@@ -191,13 +195,17 @@ int __devinit __max730x_probe(struct max
 	ts->chip.owner = THIS_MODULE;
 
 	/*
-	 * tristate all pins in hardware and cache the
+	 * initialize pullups according to platform data and cache the
 	 * register values for later use.
 	 */
 	for (i = 1; i < 8; i++) {
 		int j;
-		/* 0xAA means input with internal pullup disabled */
-		ts->write(dev, 0x08 + i, 0xAA);
+		/*
+		 * initialize port_config with "0xAA", which means
+		 * input with internal pullup disabled. This is needed
+		 * to avoid writing zeros (in the inner for loop),
+		 * which is not allowed according to the datasheet.
+		 */
 		ts->port_config[i] = 0xAA;
 		for (j = 0; j < 4; j++) {
 			int offset = (i - 1) * 4 + j;
diff -puN include/linux/spi/max7301.h~gpio-max730x-make-pullups-configurable-via-platformdata include/linux/spi/max7301.h
--- a/include/linux/spi/max7301.h~gpio-max730x-make-pullups-configurable-via-platformdata
+++ a/include/linux/spi/max7301.h
@@ -11,6 +11,7 @@ struct max7301 {
 	struct mutex	lock;
 	u8		port_config[8];	/* field 0 is unused */
 	u32		out_level;	/* cached output levels */
+	u32		input_pullup_active;
 	struct gpio_chip chip;
 	struct device *dev;
 	int (*write)(struct device *dev, unsigned int reg, unsigned int val);
@@ -20,6 +21,13 @@ struct max7301 {
 struct max7301_platform_data {
 	/* number assigned to the first GPIO */
 	unsigned	base;
+	/*
+	 * bitmask controlling the pullup configuration,
+	 *
+	 * _note_ the 4 lowest bits are unused, because the first 4
+	 * ports of the controller are not used, too.
+	 */
+	u32		input_pullup_active;
 };
 
 extern int __max730x_remove(struct device *dev);
_

Patches currently in -mm which might be from mkl@pengutronix.de are

gpio-max730x-make-pullups-configurable-via-platformdata.patch

