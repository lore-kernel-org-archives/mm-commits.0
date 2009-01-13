From: akpm@linux-foundation.org
Subject: + gpiolib-allow-gpios-to-be-named.patch added to -mm tree
Date: Tue, 13 Jan 2009 13:22:10 -0800
Message-ID: <200901132122.n0DLMAYH006808@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44485 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751531AbZAMVWw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 16:22:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dsilvers@simtec.co.uk, david-b@pacbell.net


The patch titled
     gpiolib: allow GPIOs to be named
has been added to the -mm tree.  Its filename is
     gpiolib-allow-gpios-to-be-named.patch

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

gpiolib-allow-gpios-to-be-named.patch

