From: akpm@linux-foundation.org
Subject: [folded] gpio-introduce-gpio_request_one-and-friends-update.patch removed from -mm tree
Date: Fri, 05 Mar 2010 13:26:05 -0800
Message-ID: <201003052126.o25LQ5KQ028524@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60487 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755498Ab0CEV1Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Mar 2010 16:27:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.y.miao@gmail.com, bn@niasdigital.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     gpio-introduce-gpio_request_one-and-friends-update
has been removed from the -mm tree.  Its filename was
     gpio-introduce-gpio_request_one-and-friends-update.patch

This patch was dropped because it was folded into gpio-introduce-gpio_request_one-and-friends.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio-introduce-gpio_request_one-and-friends-update
From: Eric Miao <eric.y.miao@gmail.com>

Signed-off-by: Eric Miao <eric.y.miao@gmail.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Ben Nizette <bn@niasdigital.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/gpio.txt     |   64 +++++++++++++++++++++++++++++++++++
 drivers/gpio/gpiolib.c     |   16 ++++++++
 include/asm-generic/gpio.h |    6 +++
 3 files changed, 86 insertions(+)

diff -puN Documentation/gpio.txt~gpio-introduce-gpio_request_one-and-friends-update Documentation/gpio.txt
--- a/Documentation/gpio.txt~gpio-introduce-gpio_request_one-and-friends-update
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
diff -puN drivers/gpio/gpiolib.c~gpio-introduce-gpio_request_one-and-friends-update drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpio-introduce-gpio_request_one-and-friends-update
+++ a/drivers/gpio/gpiolib.c
@@ -1241,6 +1241,12 @@ void gpio_free(unsigned gpio)
 }
 EXPORT_SYMBOL_GPL(gpio_free);
 
+/**
+ * gpio_request_one - request a single GPIO with initial configuration
+ * @gpio:	the GPIO number
+ * @flags:	GPIO configuration as specified by GPIOF_*
+ * @label:	a literal description string of this GPIO
+ */
 int gpio_request_one(unsigned gpio, unsigned long flags, const char *label)
 {
 	int err;
@@ -1259,6 +1265,11 @@ int gpio_request_one(unsigned gpio, unsi
 }
 EXPORT_SYMBOL_GPL(gpio_request_one);
 
+/**
+ * gpio_request_array - request multiple GPIOs in a single call
+ * @array:	array of the 'struct gpio'
+ * @num:	how many GPIOs in the array
+ */
 int gpio_request_array(struct gpio *array, size_t num)
 {
 	int i, err;
@@ -1277,6 +1288,11 @@ err_free:
 }
 EXPORT_SYMBOL_GPL(gpio_request_array);
 
+/**
+ * gpio_free_array - release multiple GPIOs in a single call
+ * @array:	array of the 'struct gpio'
+ * @num:	how many GPIOs in the array
+ */
 void gpio_free_array(struct gpio *array, size_t num)
 {
 	while (num--)
diff -puN include/asm-generic/gpio.h~gpio-introduce-gpio_request_one-and-friends-update include/asm-generic/gpio.h
--- a/include/asm-generic/gpio.h~gpio-introduce-gpio_request_one-and-friends-update
+++ a/include/asm-generic/gpio.h
@@ -146,6 +146,12 @@ extern int __gpio_to_irq(unsigned gpio);
 #define GPIOF_OUT_INIT_LOW	(GPIOF_DIR_OUT | GPIOF_INIT_LOW)
 #define GPIOF_OUT_INIT_HIGH	(GPIOF_DIR_OUT | GPIOF_INIT_HIGH)
 
+/**
+ * struct gpio - a structure describing a GPIO with configuration
+ * @gpio:	the GPIO number
+ * @flags:	GPIO configuration as specified by GPIOF_*
+ * @label:	a literal description string of this GPIO
+ */
 struct gpio {
 	unsigned	gpio;
 	unsigned long	flags;
_

Patches currently in -mm which might be from eric.y.miao@gmail.com are

origin.patch
gpio-introduce-gpio_request_one-and-friends.patch
gpio-introduce-gpio_request_one-and-friends-update.patch
gpio-pca953xc-add-interrupt-handling-capability.patch
gpio-pca953xc-add-interrupt-handling-capability-fix.patch
gpio-pca953xc-add-interrupt-handling-capability-v4.patch

