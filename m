From: akpm@linux-foundation.org
Subject: [merged] gpio-introduce-gpio_request_one-and-friends.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:11:13 -0800
Message-ID: <201003091911.o29JBDBa031726@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49520 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756055Ab0CITWb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.y.miao@gmail.com, bn@niasdigital.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     gpio: introduce gpio_request_one() and friends
has been removed from the -mm tree.  Its filename was
     gpio-introduce-gpio_request_one-and-friends.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 Documentation/gpio.txt     |   64 +++++++++++++++++++++++++++++++++++
 drivers/gpio/gpiolib.c     |   58 +++++++++++++++++++++++++++++++
 include/asm-generic/gpio.h |   26 ++++++++++++++
 3 files changed, 148 insertions(+)

diff -puN Documentation/gpio.txt~gpio-introduce-gpio_request_one-and-friends Documentation/gpio.txt
--- a/Documentation/gpio.txt~gpio-introduce-gpio_request_one-and-friends
+++ a/Documentation/gpio.txt
@@ -253,6 +253,70 @@ pin setup (e.g. controlling which pin th
 Also note that it's your responsibility to have stopped using a GPIO
 before you free it.
 
+Considering in most cases GPIOs are actually configured right after they
+are claimed, three additional calls are defined:
+
+	/* request a single GPIO, with initial configuration specified by
+	 * 'flags', identical to gpio_request() wrt other arguments and
+	 * return value
+	 */
+	int gpio_request_one(unsigned gpio, unsigned long flags, const char *label);
+
+	/* request multiple GPIOs in a single call
+	 */
+	int gpio_request_array(struct gpio *array, size_t num);
+
+	/* release multiple GPIOs in a single call
+	 */
+	void gpio_free_array(struct gpio *array, size_t num);
+
+where 'flags' is currently defined to specify the following properties:
+
+	* GPIOF_DIR_IN		- to configure direction as input
+	* GPIOF_DIR_OUT		- to configure direction as output
+
+	* GPIOF_INIT_LOW	- as output, set initial level to LOW
+	* GPIOF_INIT_HIGH	- as output, set initial level to HIGH
+
+since GPIOF_INIT_* are only valid when configured as output, so group valid
+combinations as:
+
+	* GPIOF_IN		- configure as input
+	* GPIOF_OUT_INIT_LOW	- configured as output, initial level LOW
+	* GPIOF_OUT_INIT_HIGH	- configured as output, initial level HIGH
+
+In the future, these flags can be extended to support more properties such
+as open-drain status.
+
+Further more, to ease the claim/release of multiple GPIOs, 'struct gpio' is
+introduced to encapsulate all three fields as:
+
+	struct gpio {
+		unsigned	gpio;
+		unsigned long	flags;
+		const char	*label;
+	};
+
+A typical example of usage:
+
+	static struct gpio leds_gpios[] = {
+		{ 32, GPIOF_OUT_INIT_HIGH, "Power LED" }, /* default to ON */
+		{ 33, GPIOF_OUT_INIT_LOW,  "Green LED" }, /* default to OFF */
+		{ 34, GPIOF_OUT_INIT_LOW,  "Red LED"   }, /* default to OFF */
+		{ 35, GPIOF_OUT_INIT_LOW,  "Blue LED"  }, /* default to OFF */
+		{ ... },
+	};
+
+	err = gpio_request_one(31, GPIOF_IN, "Reset Button");
+	if (err)
+		...
+
+	err = gpio_request_array(leds_gpios, ARRAY_SIZE(leds_gpios));
+	if (err)
+		...
+
+	gpio_free_array(leds_gpios, ARRAY_SIZE(leds_gpios));
+
 
 GPIOs mapped to IRQs
 --------------------
diff -puN drivers/gpio/gpiolib.c~gpio-introduce-gpio_request_one-and-friends drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpio-introduce-gpio_request_one-and-friends
+++ a/drivers/gpio/gpiolib.c
@@ -1237,6 +1237,64 @@ void gpio_free(unsigned gpio)
 }
 EXPORT_SYMBOL_GPL(gpio_free);
 
+/**
+ * gpio_request_one - request a single GPIO with initial configuration
+ * @gpio:	the GPIO number
+ * @flags:	GPIO configuration as specified by GPIOF_*
+ * @label:	a literal description string of this GPIO
+ */
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
+/**
+ * gpio_request_array - request multiple GPIOs in a single call
+ * @array:	array of the 'struct gpio'
+ * @num:	how many GPIOs in the array
+ */
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
+/**
+ * gpio_free_array - release multiple GPIOs in a single call
+ * @array:	array of the 'struct gpio'
+ * @num:	how many GPIOs in the array
+ */
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
@@ -136,6 +136,32 @@ extern int __gpio_cansleep(unsigned gpio
 
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
+/**
+ * struct gpio - a structure describing a GPIO with configuration
+ * @gpio:	the GPIO number
+ * @flags:	GPIO configuration as specified by GPIOF_*
+ * @label:	a literal description string of this GPIO
+ */
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

linux-next.patch
arch-arm-plat-pxa-dmac-correct-null-test.patch
genirq-warn-about-irqf_sharedirqf_disabled-at-the-right-place.patch

