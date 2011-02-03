From: akpm@linux-foundation.org
Subject: + gpio-make-gpio_requestfree_array-gpio-array-parameter-const.patch added to -mm tree
Date: Thu, 03 Feb 2011 12:38:09 -0800
Message-ID: <201102032038.p13Kc9Pv023348@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751640Ab1BCUid (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2011 15:38:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lars@metafoo.de, eric.y.miao@gmail.com, w.sang@pengutronix.de


The patch titled
     gpio: make gpio_{request,free}_array gpio array parameter const
has been added to the -mm tree.  Its filename is
     gpio-make-gpio_requestfree_array-gpio-array-parameter-const.patch

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
Subject: gpio: make gpio_{request,free}_array gpio array parameter const
From: Lars-Peter Clausen <lars@metafoo.de>

gpio_{request,free}_array should not (and do not) modify the passed gpio
array, so make the parameter const.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Eric Miao <eric.y.miao@gmail.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpiolib.c     |    4 ++--
 include/asm-generic/gpio.h |    4 ++--
 include/linux/gpio.h       |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/gpio/gpiolib.c~gpio-make-gpio_requestfree_array-gpio-array-parameter-const drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpio-make-gpio_requestfree_array-gpio-array-parameter-const
+++ a/drivers/gpio/gpiolib.c
@@ -1293,7 +1293,7 @@ EXPORT_SYMBOL_GPL(gpio_request_one);
  * @array:	array of the 'struct gpio'
  * @num:	how many GPIOs in the array
  */
-int gpio_request_array(struct gpio *array, size_t num)
+int gpio_request_array(const struct gpio *array, size_t num)
 {
 	int i, err;
 
@@ -1316,7 +1316,7 @@ EXPORT_SYMBOL_GPL(gpio_request_array);
  * @array:	array of the 'struct gpio'
  * @num:	how many GPIOs in the array
  */
-void gpio_free_array(struct gpio *array, size_t num)
+void gpio_free_array(const struct gpio *array, size_t num)
 {
 	while (num--)
 		gpio_free((array++)->gpio);
diff -puN include/asm-generic/gpio.h~gpio-make-gpio_requestfree_array-gpio-array-parameter-const include/asm-generic/gpio.h
--- a/include/asm-generic/gpio.h~gpio-make-gpio_requestfree_array-gpio-array-parameter-const
+++ a/include/asm-generic/gpio.h
@@ -193,8 +193,8 @@ struct gpio {
 };
 
 extern int gpio_request_one(unsigned gpio, unsigned long flags, const char *label);
-extern int gpio_request_array(struct gpio *array, size_t num);
-extern void gpio_free_array(struct gpio *array, size_t num);
+extern int gpio_request_array(const struct gpio *array, size_t num);
+extern void gpio_free_array(const struct gpio *array, size_t num);
 
 #ifdef CONFIG_GPIO_SYSFS
 
diff -puN include/linux/gpio.h~gpio-make-gpio_requestfree_array-gpio-array-parameter-const include/linux/gpio.h
--- a/include/linux/gpio.h~gpio-make-gpio_requestfree_array-gpio-array-parameter-const
+++ a/include/linux/gpio.h
@@ -41,7 +41,7 @@ static inline int gpio_request_one(unsig
 	return -ENOSYS;
 }
 
-static inline int gpio_request_array(struct gpio *array, size_t num)
+static inline int gpio_request_array(const struct gpio *array, size_t num)
 {
 	return -ENOSYS;
 }
@@ -54,7 +54,7 @@ static inline void gpio_free(unsigned gp
 	WARN_ON(1);
 }
 
-static inline void gpio_free_array(struct gpio *array, size_t num)
+static inline void gpio_free_array(const struct gpio *array, size_t num)
 {
 	might_sleep();
 
_

Patches currently in -mm which might be from lars@metafoo.de are

gpio-make-gpio_requestfree_array-gpio-array-parameter-const.patch

