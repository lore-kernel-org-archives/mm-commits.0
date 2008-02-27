From: akpm@linux-foundation.org
Subject: + gpio-linux-gpioh-and-no-gpio-support-here-stubs.patch added to -mm tree
Date: Wed, 27 Feb 2008 15:49:03 -0800
Message-ID: <200802272349.m1RNn4B0004991@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:40162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753352AbYB0Xti (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 18:49:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     gpio: <linux/gpio.h> and "no GPIO support here" stubs
has been added to the -mm tree.  Its filename is
     gpio-linux-gpioh-and-no-gpio-support-here-stubs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: <linux/gpio.h> and "no GPIO support here" stubs
From: David Brownell <david-b@pacbell.net>

Add a <linux/gpio.h> defining fail/warn stubs for GPIO calls on platforms that
don't support the GPIO programming interface.  That includes the arch-specific
implementation glue otherwise.

This facilitates a new model for GPIO usage: drivers that can use GPIOs if
they're available, but don't require them.  One example of such a driver is
NAND driver for various FreeScale chips.  On platforms update with GPIO
support, they can be used instead of a worst-case delay to verify that the
BUSY signal is off.

(Also includes a couple minor unrelated doc updates.)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/gpio.txt |   16 ++++--
 include/linux/gpio.h   |   95 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 107 insertions(+), 4 deletions(-)

diff -puN Documentation/gpio.txt~gpio-linux-gpioh-and-no-gpio-support-here-stubs Documentation/gpio.txt
--- a/Documentation/gpio.txt~gpio-linux-gpioh-and-no-gpio-support-here-stubs
+++ a/Documentation/gpio.txt
@@ -2,6 +2,9 @@ GPIO Interfaces
 
 This provides an overview of GPIO access conventions on Linux.
 
+These calls use the gpio_* naming prefix.  No other calls should use that
+prefix, or the related __gpio_* prefix.
+
 
 What is a GPIO?
 ===============
@@ -69,11 +72,13 @@ in this document, but drivers acting as 
 not care how it's implemented.)
 
 That said, if the convention is supported on their platform, drivers should
-use it when possible.  Platforms should declare GENERIC_GPIO support in
-Kconfig (boolean true), which multi-platform drivers can depend on when
-using the include file:
+use it when possible.  Platforms must declare GENERIC_GPIO support in their
+Kconfig (boolean true), and provide an <asm/gpio.h> file.  Drivers that can't
+work without standard GPIO calls should have Kconfig entries which depend
+on GENERIC_GPIO.  The GPIO calls are available, either as "real code" or as
+optimized-away stubs, when drivers use the include file:
 
-	#include <asm/gpio.h>
+	#include <linux/gpio.h>
 
 If you stick to this convention then it'll be easier for other developers to
 see what your code is doing, and help maintain it.
@@ -326,6 +331,9 @@ pulldowns integrated on some platforms. 
 or support them in the same way; and any given board might use external
 pullups (or pulldowns) so that the on-chip ones should not be used.
 (When a circuit needs 5 kOhm, on-chip 100 kOhm resistors won't do.)
+Likewise drive strength (2 mA vs 20 mA) and voltage (1.8V vs 3.3V) is a
+platform-specific issue, as are models like (not) having a one-to-one
+correspondence between configurable pins and GPIOs.
 
 There are other system-specific mechanisms that are not specified here,
 like the aforementioned options for input de-glitching and wire-OR output.
diff -puN /dev/null include/linux/gpio.h
--- /dev/null
+++ a/include/linux/gpio.h
@@ -0,0 +1,95 @@
+#ifndef __LINUX_GPIO_H
+#define __LINUX_GPIO_H
+
+/* see Documentation/gpio.txt */
+
+#ifdef CONFIG_GENERIC_GPIO
+#include <asm/gpio.h>
+
+#else
+
+/*
+ * Some platforms don't support the GPIO programming interface.
+ *
+ * In case some driver uses it anyway (it should normally have
+ * depended on GENERIC_GPIO), these routines help the compiler
+ * optimize out much GPIO-related code ... or trigger a runtime
+ * warning when something is wrongly called.
+ */
+
+static inline int gpio_is_valid(int number)
+{
+	return 0;
+}
+
+static inline int gpio_request(unsigned gpio, const char *label)
+{
+	return -ENOSYS;
+}
+
+static inline void gpio_free(unsigned gpio)
+{
+	/* GPIO can never have been requested */
+	WARN_ON(1);
+}
+
+static inline int gpio_direction_input(unsigned gpio)
+{
+	return -ENOSYS;
+}
+
+static inline int gpio_direction_output(unsigned gpio, int value)
+{
+	return -ENOSYS;
+}
+
+static inline int gpio_get_value(unsigned gpio)
+{
+	/* GPIO can never have been requested or set as {in,out}put */
+	WARN_ON(1);
+	return 0;
+}
+
+static inline void gpio_set_value(unsigned gpio, int value)
+{
+	/* GPIO can never have been requested or set as output */
+	WARN_ON(1);
+}
+
+static inline int gpio_cansleep(unsigned gpio)
+{
+	/* GPIO can never have been requested or set as {in,out}put */
+	WARN_ON(1);
+	return 0;
+}
+
+static inline int gpio_get_value_cansleep(unsigned gpio)
+{
+	/* GPIO can never have been requested or set as {in,out}put */
+	WARN_ON(1);
+	return 0;
+}
+
+static inline void gpio_set_value_cansleep(unsigned gpio, int value)
+{
+	/* GPIO can never have been requested or set as output */
+	WARN_ON(1);
+}
+
+static inline int gpio_to_irq(unsigned gpio)
+{
+	/* GPIO can never have been requested or set as input */
+	WARN_ON(1);
+	return -EINVAL;
+}
+
+static inline int irq_to_gpio(unsigned irq)
+{
+	/* irq can never have been returned from gpio_to_irq() */
+	WARN_ON(1);
+	return -EINVAL;
+}
+
+#endif
+
+#endif /* __LINUX_GPIO_H */
_

Patches currently in -mm which might be from david-b@pacbell.net are

rtc-add-support-for-the-s-35390a-rtc-chip.patch
git-acpi.patch
at91-correct-at91sam9263ek-lcd-power-gpio-pin.patch
git-avr32.patch
usb-net-asix-does-not-really-need-10-100mbit.patch
mpc5200-fix-build-error-on-mpc52xx_psc_spi-device-driver.patch
spi-pxa2xx_spi-sparse-fixes.patch
rtc-avoid-legacy-drivers-with-generic-framework.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
rtc-silence-section-mismatch-warning-in-rtc-test.patch
make-ds1511_rtc_readset_time-static.patch
gpio-linux-gpioh-and-no-gpio-support-here-stubs.patch
