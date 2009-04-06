From: akpm@linux-foundation.org
Subject: [merged] gpiolib-allow-gpios-to-be-named.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:33:31 -0700
Message-ID: <200904061933.n36JXVcE011137@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43781 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757112AbZDFTf4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:35:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dsilvers@simtec.co.uk, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     gpiolib: allow GPIOs to be named
has been removed from the -mm tree.  Its filename was
     gpiolib-allow-gpios-to-be-named.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpiolib: allow GPIOs to be named
From: Daniel Silverstone <dsilvers@simtec.co.uk>

Allow GPIOs in GPIOLIB chips to be named.  This name is then used when the
GPIO is exported to sysfs, although it could be used elsewhere if deemed
useful.

Signed-off-by: Daniel Silverstone <dsilvers@simtec.co.uk>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpiolib.c     |    7 ++++++-
 include/asm-generic/gpio.h |    5 +++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff -puN drivers/gpio/gpiolib.c~gpiolib-allow-gpios-to-be-named drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpiolib-allow-gpios-to-be-named
+++ a/drivers/gpio/gpiolib.c
@@ -438,6 +438,7 @@ int gpio_export(unsigned gpio, bool dire
 	unsigned long		flags;
 	struct gpio_desc	*desc;
 	int			status = -EINVAL;
+	char			*ioname = NULL;
 
 	/* can't export until sysfs is available ... */
 	if (!gpio_class.p) {
@@ -461,11 +462,14 @@ int gpio_export(unsigned gpio, bool dire
 	}
 	spin_unlock_irqrestore(&gpio_lock, flags);
 
+	if (desc->chip->names && desc->chip->names[gpio - desc->chip->base])
+		ioname = desc->chip->names[gpio - desc->chip->base];
+
 	if (status == 0) {
 		struct device	*dev;
 
 		dev = device_create(&gpio_class, desc->chip->dev, MKDEV(0, 0),
-					desc, "gpio%d", gpio);
+				    desc, ioname ? ioname : "gpio%d", gpio);
 		if (dev) {
 			if (direction_may_change)
 				status = sysfs_create_group(&dev->kobj,
@@ -513,6 +517,7 @@ void gpio_unexport(unsigned gpio)
 	mutex_lock(&sysfs_lock);
 
 	desc = &gpio_desc[gpio];
+
 	if (test_bit(FLAG_EXPORT, &desc->flags)) {
 		struct device	*dev = NULL;
 
diff -puN include/asm-generic/gpio.h~gpiolib-allow-gpios-to-be-named include/asm-generic/gpio.h
--- a/include/asm-generic/gpio.h~gpiolib-allow-gpios-to-be-named
+++ a/include/asm-generic/gpio.h
@@ -55,6 +55,10 @@ struct module;
  *	handled is (base + ngpio - 1).
  * @can_sleep: flag must be set iff get()/set() methods sleep, as they
  *	must while accessing GPIO expander chips over I2C or SPI
+ * @names: if set, must be an array of strings to use as alternative
+ *      names for the GPIOs in this chip. Any entry in the array
+ *      may be NULL if there is no alias for the GPIO, however the
+ *      array must be @ngpio entries long.
  *
  * A gpio_chip can help platforms abstract various sources of GPIOs so
  * they can all be accessed through a common programing interface.
@@ -92,6 +96,7 @@ struct gpio_chip {
 						struct gpio_chip *chip);
 	int			base;
 	u16			ngpio;
+	char			**names;
 	unsigned		can_sleep:1;
 	unsigned		exported:1;
 };
_

Patches currently in -mm which might be from dsilvers@simtec.co.uk are

origin.patch

