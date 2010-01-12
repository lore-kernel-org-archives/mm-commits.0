From: akpm@linux-foundation.org
Subject: + gpio-introduce-gpio_request_one-and-friends.patch added to -mm tree
Date: Tue, 12 Jan 2010 15:10:10 -0800
Message-ID: <201001122310.o0CNAAbv000888@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40404 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752230Ab0ALXKd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jan 2010 18:10:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.y.miao@gmail.com, bn@niasdigital.com, dbrownell@users.sourceforge.net


The patch titled
     gpio: introduce gpio_request_one() and friends
has been added to the -mm tree.  Its filename is
     gpio-introduce-gpio_request_one-and-friends.patch

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
Subject: gpio: introduce gpio_request_one() and friends
From: Eric Miao <eric.y.miao@gmail.com>

gpio_request() without initial configuration of the GPIO is normally
useless, introduce gpio_request_one() together with GPIOF_ flags for
input/output direction and initial output level.

gpio_{request,free}_array() for multiple GPIOs.

Signed-off-by: Eric Miao <eric.y.miao@gmail.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Ben Nizette <bn@niasdigital.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpiolib.c     |   42 +++++++++++++++++++++++++++++++++++
 include/asm-generic/gpio.h |   20 ++++++++++++++++
 2 files changed, 62 insertions(+)

diff -puN drivers/gpio/gpiolib.c~gpio-introduce-gpio_request_one-and-friends drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpio-introduce-gpio_request_one-and-friends
+++ a/drivers/gpio/gpiolib.c
@@ -1237,6 +1237,48 @@ void gpio_free(unsigned gpio)
 }
 EXPORT_SYMBOL_GPL(gpio_free);
 
+int gpio_request_one(unsigned gpio, unsigned long flags, const char *label)
+{
+	int err;
+
+	err = gpio_request(gpio, label);
+	if (err)
+		return err;
+
+	if (flags & GPIOF_DIR_IN)
+		err = gpio_direction_input(gpio);
+	else
+		err = gpio_direction_output(gpio,
+				(flags & GPIOF_INIT_HIGH) ? 1 : 0);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(gpio_request_one);
+
+int gpio_request_array(struct gpio *array, size_t num)
+{
+	int i, err;
+
+	for (i = 0; i < num; i++, array++) {
+		err = gpio_request_one(array->gpio, array->flags, array->label);
+		if (err)
+			goto err_free;
+	}
+	return 0;
+
+err_free:
+	while (i--)
+		gpio_free((--array)->gpio);
+	return err;
+}
+EXPORT_SYMBOL_GPL(gpio_request_array);
+
+void gpio_free_array(struct gpio *array, size_t num)
+{
+	while (num--)
+		gpio_free((array++)->gpio);
+}
+EXPORT_SYMBOL_GPL(gpio_free_array);
 
 /**
  * gpiochip_is_requested - return string iff signal was requested
diff -puN include/asm-generic/gpio.h~gpio-introduce-gpio_request_one-and-friends include/asm-generic/gpio.h
--- a/include/asm-generic/gpio.h~gpio-introduce-gpio_request_one-and-friends
+++ a/include/asm-generic/gpio.h
@@ -136,6 +136,26 @@ extern int __gpio_cansleep(unsigned gpio
 
 extern int __gpio_to_irq(unsigned gpio);
 
+#define GPIOF_DIR_OUT	(0 << 0)
+#define GPIOF_DIR_IN	(1 << 0)
+
+#define GPIOF_INIT_LOW	(0 << 1)
+#define GPIOF_INIT_HIGH	(1 << 1)
+
+#define GPIOF_IN		(GPIOF_DIR_IN)
+#define GPIOF_OUT_INIT_LOW	(GPIOF_DIR_OUT | GPIOF_INIT_LOW)
+#define GPIOF_OUT_INIT_HIGH	(GPIOF_DIR_OUT | GPIOF_INIT_HIGH)
+
+struct gpio {
+	unsigned	gpio;
+	unsigned long	flags;
+	const char	*label;
+};
+
+extern int gpio_request_one(unsigned gpio, unsigned long flags, const char *label);
+extern int gpio_request_array(struct gpio *array, size_t num);
+extern void gpio_free_array(struct gpio *array, size_t num);
+
 #ifdef CONFIG_GPIO_SYSFS
 
 /*
_

Patches currently in -mm which might be from eric.y.miao@gmail.com are

origin.patch
linux-next.patch
arch-arm-plat-pxa-dmac-correct-null-test.patch
gpio-introduce-gpio_request_one-and-friends.patch

