From: akpm@linux-foundation.org
Subject: - gpiolib-dynamic-gpio-number-allocation.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:57:07 -0700
Message-ID: <200804282157.m3SLv7Gj018374@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53118 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934055AbYD1V5V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:57:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     gpiolib: dynamic gpio number allocation
has been removed from the -mm tree.  Its filename was
     gpiolib-dynamic-gpio-number-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpiolib: dynamic gpio number allocation
From: Anton Vorontsov <avorontsov@ru.mvista.com>

If gpio_chip->base is negative during registration, gpiolib performs dynamic
base allocation.  This is useful for devices that aren't always present, such
as GPIOs on hotplugged devices rather than mainboards.  (This behavior was
previously specified but not implemented.)

To avoid using any numbers that may have been explicitly assigned but not yet
registered, this dynamic allocation assigns GPIO numbers from the biggest
number on down, instead of from the smallest on up.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpiolib.c |   52 +++++++++++++++++++++++++++++++++------
 1 file changed, 45 insertions(+), 7 deletions(-)

diff -puN drivers/gpio/gpiolib.c~gpiolib-dynamic-gpio-number-allocation drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpiolib-dynamic-gpio-number-allocation
+++ a/drivers/gpio/gpiolib.c
@@ -80,6 +80,33 @@ static inline struct gpio_chip *gpio_to_
 	return gpio_desc[gpio].chip;
 }
 
+/* dynamic allocation of GPIOs, e.g. on a hotplugged device */
+static int gpiochip_find_base(int ngpio)
+{
+	int i;
+	int spare = 0;
+	int base = -ENOSPC;
+
+	for (i = ARCH_NR_GPIOS - 1; i >= 0 ; i--) {
+		struct gpio_chip *chip = gpio_desc[i].chip;
+
+		if (!chip) {
+			spare++;
+			if (spare == ngpio) {
+				base = i;
+				break;
+			}
+		} else {
+			spare = 0;
+			i -= chip->ngpio - 1;
+		}
+	}
+
+	if (gpio_is_valid(base))
+		pr_debug("%s: found new base at %d\n", __func__, base);
+	return base;
+}
+
 /**
  * gpiochip_add() - register a gpio_chip
  * @chip: the chip to register, with chip->base initialized
@@ -88,38 +115,49 @@ static inline struct gpio_chip *gpio_to_
  * Returns a negative errno if the chip can't be registered, such as
  * because the chip->base is invalid or already associated with a
  * different chip.  Otherwise it returns zero as a success code.
+ *
+ * If chip->base is negative, this requests dynamic assignment of
+ * a range of valid GPIOs.
  */
 int gpiochip_add(struct gpio_chip *chip)
 {
 	unsigned long	flags;
 	int		status = 0;
 	unsigned	id;
+	int		base = chip->base;
 
-	/* NOTE chip->base negative is reserved to mean a request for
-	 * dynamic allocation.  We don't currently support that.
-	 */
-
-	if (chip->base < 0 || !gpio_is_valid(chip->base  + chip->ngpio)) {
+	if ((!gpio_is_valid(base) || !gpio_is_valid(base + chip->ngpio))
+			&& base >= 0) {
 		status = -EINVAL;
 		goto fail;
 	}
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
+	if (base < 0) {
+		base = gpiochip_find_base(chip->ngpio);
+		if (base < 0) {
+			status = base;
+			goto fail_unlock;
+		}
+		chip->base = base;
+	}
+
 	/* these GPIO numbers must not be managed by another gpio_chip */
-	for (id = chip->base; id < chip->base + chip->ngpio; id++) {
+	for (id = base; id < base + chip->ngpio; id++) {
 		if (gpio_desc[id].chip != NULL) {
 			status = -EBUSY;
 			break;
 		}
 	}
 	if (status == 0) {
-		for (id = chip->base; id < chip->base + chip->ngpio; id++) {
+		for (id = base; id < base + chip->ngpio; id++) {
 			gpio_desc[id].chip = chip;
 			gpio_desc[id].flags = 0;
 		}
 	}
 
+fail_unlock:
 	spin_unlock_irqrestore(&gpio_lock, flags);
 fail:
 	/* failures here can mean systems won't boot... */
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch

