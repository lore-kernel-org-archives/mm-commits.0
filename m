From: akpm@linux-foundation.org
Subject: - gpiochip_reserve.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:57:09 -0700
Message-ID: <200804282157.m3SLv9EC018377@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966002AbYD1WDj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 18:03:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     gpiochip_reserve()
has been removed from the -mm tree.  Its filename was
     gpiochip_reserve.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpiochip_reserve()
From: Anton Vorontsov <avorontsov@ru.mvista.com>

Add a new function gpiochip_reserve() to reserve ranges of gpios that platform
code has pre-allocated.  That is, this marks gpio numbers which will be
claimed by drivers that haven't yet been loaded, and thus are not available
for dynamic gpio number allocation.

[akpm@linux-foundation.org: remove unneeded __must_check]
[david-b@pacbell.net: don't export gpiochip_reserve (section fix)]
Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpiolib.c     |   50 ++++++++++++++++++++++++++++++++---
 include/asm-generic/gpio.h |    1 
 2 files changed, 48 insertions(+), 3 deletions(-)

diff -puN drivers/gpio/gpiolib.c~gpiochip_reserve drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpiochip_reserve
+++ a/drivers/gpio/gpiolib.c
@@ -43,6 +43,7 @@ struct gpio_desc {
 /* flag symbols are bit numbers */
 #define FLAG_REQUESTED	0
 #define FLAG_IS_OUT	1
+#define FLAG_RESERVED	2
 
 #ifdef CONFIG_DEBUG_FS
 	const char		*label;
@@ -88,9 +89,10 @@ static int gpiochip_find_base(int ngpio)
 	int base = -ENOSPC;
 
 	for (i = ARCH_NR_GPIOS - 1; i >= 0 ; i--) {
-		struct gpio_chip *chip = gpio_desc[i].chip;
+		struct gpio_desc *desc = &gpio_desc[i];
+		struct gpio_chip *chip = desc->chip;
 
-		if (!chip) {
+		if (!chip && !test_bit(FLAG_RESERVED, &desc->flags)) {
 			spare++;
 			if (spare == ngpio) {
 				base = i;
@@ -98,7 +100,8 @@ static int gpiochip_find_base(int ngpio)
 			}
 		} else {
 			spare = 0;
-			i -= chip->ngpio - 1;
+			if (chip)
+				i -= chip->ngpio - 1;
 		}
 	}
 
@@ -108,6 +111,47 @@ static int gpiochip_find_base(int ngpio)
 }
 
 /**
+ * gpiochip_reserve() - reserve range of gpios to use with platform code only
+ * @start: starting gpio number
+ * @ngpio: number of gpios to reserve
+ * Context: platform init, potentially before irqs or kmalloc will work
+ *
+ * Returns a negative errno if any gpio within the range is already reserved
+ * or registered, else returns zero as a success code.  Use this function
+ * to mark a range of gpios as unavailable for dynamic gpio number allocation,
+ * for example because its driver support is not yet loaded.
+ */
+int __init gpiochip_reserve(int start, int ngpio)
+{
+	int ret = 0;
+	unsigned long flags;
+	int i;
+
+	if (!gpio_is_valid(start) || !gpio_is_valid(start + ngpio))
+		return -EINVAL;
+
+	spin_lock_irqsave(&gpio_lock, flags);
+
+	for (i = start; i < start + ngpio; i++) {
+		struct gpio_desc *desc = &gpio_desc[i];
+
+		if (desc->chip || test_bit(FLAG_RESERVED, &desc->flags)) {
+			ret = -EBUSY;
+			goto err;
+		}
+
+		set_bit(FLAG_RESERVED, &desc->flags);
+	}
+
+	pr_debug("%s: reserved gpios from %d to %d\n",
+		 __func__, start, start + ngpio - 1);
+err:
+	spin_unlock_irqrestore(&gpio_lock, flags);
+
+	return ret;
+}
+
+/**
  * gpiochip_add() - register a gpio_chip
  * @chip: the chip to register, with chip->base initialized
  * Context: potentially before irqs or kmalloc will work
diff -puN include/asm-generic/gpio.h~gpiochip_reserve include/asm-generic/gpio.h
--- a/include/asm-generic/gpio.h~gpiochip_reserve
+++ a/include/asm-generic/gpio.h
@@ -74,6 +74,7 @@ struct gpio_chip {
 
 extern const char *gpiochip_is_requested(struct gpio_chip *chip,
 			unsigned offset);
+extern int __init __must_check gpiochip_reserve(int start, int ngpio);
 
 /* add/remove chips */
 extern int gpiochip_add(struct gpio_chip *chip);
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch

