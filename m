From: akpm@linux-foundation.org
Subject: [merged] gpiolib-annotate-gpio-intialization-with-__must_check.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:08:06 -0800
Message-ID: <201101132010.p0DKAlZx030093@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52999 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933651Ab1AMULi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:11:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: w.sang@pengutronix.de, dbrownell@users.sourceforge.net, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     gpiolib: annotate gpio-intialization with __must_check
has been removed from the -mm tree.  Its filename was
     gpiolib-annotate-gpio-intialization-with-__must_check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpiolib: annotate gpio-intialization with __must_check
From: Wolfram Sang <w.sang@pengutronix.de>

Because GPIOs can have crucial functions especially in embedded systems,
we are better safe than sorry regarding their configuration.  For
gpio_request, the documentation is simply enforced: <quote>"The return
value of gpio_request() must be checked."</quote> For gpio_direction_* and
gpio_request_*, we now act accordingly.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg KH <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/gpio.txt     |    2 +-
 include/asm-generic/gpio.h |   10 +++++-----
 include/linux/gpio.h       |    6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff -puN Documentation/gpio.txt~gpiolib-annotate-gpio-intialization-with-__must_check Documentation/gpio.txt
--- a/Documentation/gpio.txt~gpiolib-annotate-gpio-intialization-with-__must_check
+++ a/Documentation/gpio.txt
@@ -135,7 +135,7 @@ setting up a platform_device using the G
 	int gpio_direction_input(unsigned gpio);
 	int gpio_direction_output(unsigned gpio, int value);
 
-The return value is zero for success, else a negative errno.  It should
+The return value is zero for success, else a negative errno.  It must
 be checked, since the get/set calls don't have error returns and since
 misconfiguration is possible.  You should normally issue these calls from
 a task context.  However, for spinlock-safe GPIOs it's OK to use them
diff -puN include/asm-generic/gpio.h~gpiolib-annotate-gpio-intialization-with-__must_check include/asm-generic/gpio.h
--- a/include/asm-generic/gpio.h~gpiolib-annotate-gpio-intialization-with-__must_check
+++ a/include/asm-generic/gpio.h
@@ -147,11 +147,11 @@ extern struct gpio_chip *gpiochip_find(v
 /* Always use the library code for GPIO management calls,
  * or when sleeping may be involved.
  */
-extern int gpio_request(unsigned gpio, const char *label);
+extern int __must_check gpio_request(unsigned gpio, const char *label);
 extern void gpio_free(unsigned gpio);
 
-extern int gpio_direction_input(unsigned gpio);
-extern int gpio_direction_output(unsigned gpio, int value);
+extern int __must_check gpio_direction_input(unsigned gpio);
+extern int __must_check gpio_direction_output(unsigned gpio, int value);
 
 extern int gpio_set_debounce(unsigned gpio, unsigned debounce);
 
@@ -192,8 +192,8 @@ struct gpio {
 	const char	*label;
 };
 
-extern int gpio_request_one(unsigned gpio, unsigned long flags, const char *label);
-extern int gpio_request_array(struct gpio *array, size_t num);
+extern int __must_check gpio_request_one(unsigned gpio, unsigned long flags, const char *label);
+extern int __must_check gpio_request_array(struct gpio *array, size_t num);
 extern void gpio_free_array(struct gpio *array, size_t num);
 
 #ifdef CONFIG_GPIO_SYSFS
diff -puN include/linux/gpio.h~gpiolib-annotate-gpio-intialization-with-__must_check include/linux/gpio.h
--- a/include/linux/gpio.h~gpiolib-annotate-gpio-intialization-with-__must_check
+++ a/include/linux/gpio.h
@@ -29,7 +29,7 @@ static inline int gpio_is_valid(int numb
 	return 0;
 }
 
-static inline int gpio_request(unsigned gpio, const char *label)
+static inline int __must_check gpio_request(unsigned gpio, const char *label)
 {
 	return -ENOSYS;
 }
@@ -42,12 +42,12 @@ static inline void gpio_free(unsigned gp
 	WARN_ON(1);
 }
 
-static inline int gpio_direction_input(unsigned gpio)
+static inline int __must_check gpio_direction_input(unsigned gpio)
 {
 	return -ENOSYS;
 }
 
-static inline int gpio_direction_output(unsigned gpio, int value)
+static inline int __must_check gpio_direction_output(unsigned gpio, int value)
 {
 	return -ENOSYS;
 }
_

Patches currently in -mm which might be from w.sang@pengutronix.de are

origin.patch
linux-next.patch

