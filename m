From: akpm@linux-foundation.org
Subject: + gpio-add-gpio_lookup.patch added to -mm tree
Date: Tue, 13 Oct 2009 11:05:16 -0700
Message-ID: <200910131805.n9DI5H5M012375@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49286 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760839AbZJMSGq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 14:06:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: corbet@lwn.net, bn@niasdigital.com, david-b@pacbell.net


The patch titled
     gpio: add gpio_lookup
has been added to the -mm tree.  Its filename is
     gpio-add-gpio_lookup.patch

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
Subject: gpio: add gpio_lookup
From: Jonathan Corbet <corbet@lwn.net>

GPIOs have names associated with them, but drivers cannot use those names
and must thus rely on hardwired GPIO numbers.  That, in turn, makes
dynamic assignment hard to use.  This patch adds a little function
gpio_lookup() which returns the GPIO number associated with a name.

This function will be used by the viafb camera driver.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Cc: Ben Nizette <bn@niasdigital.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN Documentation/gpio.txt~gpio-add-gpio_lookup Documentation/gpio.txt
--- a/Documentation/gpio.txt~gpio-add-gpio_lookup
+++ a/Documentation/gpio.txt
@@ -253,6 +253,14 @@ pin setup (e.g. controlling which pin th
 Also note that it's your responsibility to have stopped using a GPIO
 before you free it.
 
+GPIO users can look up GPIO numbers using the names which were provided by
+the GPIO driver, using:
+
+	int gpio_lookup(const char *name);
+
+The return value will be the associated GPIO number, or -EINVAL if no GPIO
+with the given name is found.
+
 
 GPIOs mapped to IRQs
 --------------------
diff -puN drivers/gpio/gpiolib.c~gpio-add-gpio_lookup drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpio-add-gpio_lookup
+++ a/drivers/gpio/gpiolib.c
@@ -1102,6 +1102,31 @@ void gpio_free(unsigned gpio)
 }
 EXPORT_SYMBOL_GPL(gpio_free);
 
+/**
+ * gpio_lookup - Look up a GPIO by name
+ * @name: the name of the desired GPIO
+ *
+ * Returns the GPIO number associated with name, or -EINVAL if
+ * the GPIO is not found.
+ */
+int gpio_lookup(const char *name)
+{
+	int i;
+
+	for (i = 0; i < ARCH_NR_GPIOS; i++) {
+		struct gpio_chip *chip = gpio_desc[i].chip;
+
+		if (chip == NULL || chip->names == NULL)
+			continue;
+		if (!strcmp (name, chip->names[i - chip->base])) {
+			printk(KERN_NOTICE "grbn found %d\n", i);
+			return i;
+		}
+	}
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(gpio_lookup);
+
 
 /**
  * gpiochip_is_requested - return string iff signal was requested
diff -puN include/asm-generic/gpio.h~gpio-add-gpio_lookup include/asm-generic/gpio.h
--- a/include/asm-generic/gpio.h~gpio-add-gpio_lookup
+++ a/include/asm-generic/gpio.h
@@ -116,6 +116,7 @@ extern int __must_check gpiochip_remove(
  */
 extern int gpio_request(unsigned gpio, const char *label);
 extern void gpio_free(unsigned gpio);
+extern int gpio_lookup(const char *name);
 
 extern int gpio_direction_input(unsigned gpio);
 extern int gpio_direction_output(unsigned gpio, int value);
diff -puN include/linux/gpio.h~gpio-add-gpio_lookup include/linux/gpio.h
--- a/include/linux/gpio.h~gpio-add-gpio_lookup
+++ a/include/linux/gpio.h
@@ -41,6 +41,11 @@ static inline void gpio_free(unsigned gp
 	WARN_ON(1);
 }
 
+static inline int gpio_lookup(const char *name)
+{
+	return -ENOSYS;
+}
+
 static inline int gpio_direction_input(unsigned gpio)
 {
 	return -ENOSYS;
_

Patches currently in -mm which might be from corbet@lwn.net are

gpio-add-gpio_lookup.patch
gpio-add-gpio_lookup-checkpatch-fixes.patch
gpio-add-gpio_lookup-fix.patch

