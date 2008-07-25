From: akpm@linux-foundation.org
Subject: - gpio-sysfs-interface-updated-update.patch removed from -mm tree
Date: Thu, 24 Jul 2008 17:13:50 -0700
Message-ID: <200807250013.m6P0DpQN013518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33982 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752473AbYGYAO1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 20:14:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, g.liakhovetski@pengutronix.de, greg@kroah.com, kay.sievers@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     gpio: updates to sysfs support
has been removed from the -mm tree.  Its filename was
     gpio-sysfs-interface-updated-update.patch

This patch was dropped because it was folded into gpio-sysfs-interface-updated.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: updates to sysfs support
From: David Brownell <david-b@pacbell.net>

Update and bugfix the patch adding sysfs GPIO support:

  * Bugfix:  the test initializing the IS_OUT flag for output-only
    GPIOs had the sense inverted.

  * Update:  when gpio_chip.dev is provided, list it in the debugfs
    dump.  Device nodes are unique; the "label" isn't.

The bug of course caused output-only GPIOs to misbehave, but it also
made just-exported (or generally:  only-requested) GPIOs always appear
to be outputs in sysfs and debugfs.  That's wrong more often than it's
right, although it gets corrected when the direction is assigned.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpiolib.c |   28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff -puN drivers/gpio/gpiolib.c~gpio-sysfs-interface-updated-update drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpio-sysfs-interface-updated-update
+++ a/drivers/gpio/gpiolib.c
@@ -685,7 +685,14 @@ int gpiochip_add(struct gpio_chip *chip)
 	if (status == 0) {
 		for (id = base; id < base + chip->ngpio; id++) {
 			gpio_desc[id].chip = chip;
-			gpio_desc[id].flags = chip->direction_input
+
+			/* REVISIT:  most hardware initializes GPIOs as
+			 * inputs (often with pullups enabled) so power
+			 * usage is minimized.  Linux code should set the
+			 * gpio direction first thing; but until it does,
+			 * we may expose the wrong direction in sysfs.
+			 */
+			gpio_desc[id].flags = !chip->direction_input
 				? (1 << FLAG_IS_OUT)
 				: 0;
 		}
@@ -1108,17 +1115,28 @@ static int gpiolib_show(struct seq_file 
 	/* REVISIT this isn't locked against gpio_chip removal ... */
 
 	for (gpio = 0; gpio_is_valid(gpio); gpio++) {
+		struct device *dev;
+
 		if (chip == gpio_desc[gpio].chip)
 			continue;
 		chip = gpio_desc[gpio].chip;
 		if (!chip)
 			continue;
 
-		seq_printf(s, "%sGPIOs %d-%d, %s%s:\n",
+		seq_printf(s, "%sGPIOs %d-%d",
 				started ? "\n" : "",
-				chip->base, chip->base + chip->ngpio - 1,
-				chip->label ? : "generic",
-				chip->can_sleep ? ", can sleep" : "");
+				chip->base, chip->base + chip->ngpio - 1);
+		dev = chip->dev;
+		if (dev)
+			seq_printf(s, ", %s/%s",
+				dev->bus ? dev->bus->name : "no-bus",
+				dev->bus_id);
+		if (chip->label)
+			seq_printf(s, ", %s", chip->label);
+		if (chip->can_sleep)
+			seq_printf(s, ", can sleep");
+		seq_printf(s, ":\n");
+
 		started = 1;
 		if (chip->dbg_show)
 			chip->dbg_show(s, chip);
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
sm501-add-gpiolib-support.patch
sm501-gpio-dynamic-registration-for-pci-devices.patch
sm501-gpio-i2c-support.patch
gpio-sysfs-interface-updated.patch
gpio-sysfs-interface-updated-update.patch
gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support.patch
gpio-mcp23s08-handles-multiple-chips-per-chipselect.patch
gpio-add-bt8xxgpio-driver.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-fix.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-cleanup.patch
gpiolib-allow-user-selection.patch
gpiolib-allow-user-selection-update.patch

