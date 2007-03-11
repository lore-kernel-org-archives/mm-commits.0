From: akpm@linux-foundation.org
Subject: + gpio_direction_output-needs-an-initial-value.patch added to -mm tree
Date: Sun, 11 Mar 2007 00:34:12 -0800
Message-ID: <200703110834.l2B8YCtW007916@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40027 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbXCKIes (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 04:34:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, andrew@sanpeople.com, dbrownell@users.sourceforge.net, hskinnemoen@atmel.com, msvoboda@ra.rockwell.com, rmk@arm.linux.org.uk


The patch titled
     gpio_direction_output() needs an initial value
has been added to the -mm tree.  Its filename is
     gpio_direction_output-needs-an-initial-value.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: gpio_direction_output() needs an initial value
From: David Brownell <david-b@pacbell.net>

It's been pointed out that output GPIOs should have an initial value, to
avoid signal glitching ...  among other things, it can be some time before
a driver is ready.  This patch corrects that oversight, fixing

 - documentation
 - platforms supporting the GPIO interface
 - users of that call (just one for now, others are pending)

There's only one user of this call for now since most platforms are still
using non-generic GPIO setup code, which in most cases already couples the
initial value with its "set output mode" request.

Note that most platforms are clear about the hardware letting the output
value be set before the pin direction is changed, but the s3c241x docs are
vague on that topic ...  so those chips might not avoid the glitches.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Andrew Victor <andrew@sanpeople.com>
Acked-by: Milan Svoboda <msvoboda@ra.rockwell.com>
Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/gpio.txt               |    5 ++++-
 arch/arm/mach-at91/gpio.c            |    3 ++-
 arch/arm/mach-sa1100/generic.c       |    3 ++-
 arch/avr32/mach-at32ap/pio.c         |    4 +++-
 drivers/spi/atmel_spi.c              |    2 +-
 include/asm-arm/arch-at91/gpio.h     |    2 +-
 include/asm-arm/arch-omap/gpio.h     |    3 ++-
 include/asm-arm/arch-pxa/gpio.h      |    4 ++--
 include/asm-arm/arch-s3c2410/gpio.h  |    4 +++-
 include/asm-arm/arch-sa1100/gpio.h   |    2 +-
 include/asm-avr32/arch-at32ap/gpio.h |    2 +-
 11 files changed, 22 insertions(+), 12 deletions(-)

diff -puN arch/arm/mach-at91/gpio.c~gpio_direction_output-needs-an-initial-value arch/arm/mach-at91/gpio.c
--- a/arch/arm/mach-at91/gpio.c~gpio_direction_output-needs-an-initial-value
+++ a/arch/arm/mach-at91/gpio.c
@@ -215,13 +215,14 @@ int gpio_direction_input(unsigned pin)
 }
 EXPORT_SYMBOL(gpio_direction_input);
 
-int gpio_direction_output(unsigned pin)
+int gpio_direction_output(unsigned pin, int value)
 {
 	void __iomem	*pio = pin_to_controller(pin);
 	unsigned	mask = pin_to_mask(pin);
 
 	if (!pio || !(__raw_readl(pio + PIO_PSR) & mask))
 		return -EINVAL;
+	__raw_writel(mask, pio + (value ? PIO_SODR : PIO_CODR));
 	__raw_writel(mask, pio + PIO_OER);
 	return 0;
 }
diff -puN arch/arm/mach-sa1100/generic.c~gpio_direction_output-needs-an-initial-value arch/arm/mach-sa1100/generic.c
--- a/arch/arm/mach-sa1100/generic.c~gpio_direction_output-needs-an-initial-value
+++ a/arch/arm/mach-sa1100/generic.c
@@ -153,7 +153,7 @@ int gpio_direction_input(unsigned gpio)
 
 EXPORT_SYMBOL(gpio_direction_input);
 
-int gpio_direction_output(unsigned gpio)
+int gpio_direction_output(unsigned gpio, int value)
 {
 	unsigned long flags;
 
@@ -161,6 +161,7 @@ int gpio_direction_output(unsigned gpio)
 		return -EINVAL;
 
 	local_irq_save(flags);
+	gpio_set_value(gpio, value);
 	GPDR |= GPIO_GPIO(gpio);
 	local_irq_restore(flags);
 	return 0;
diff -puN arch/avr32/mach-at32ap/pio.c~gpio_direction_output-needs-an-initial-value arch/avr32/mach-at32ap/pio.c
--- a/arch/avr32/mach-at32ap/pio.c~gpio_direction_output-needs-an-initial-value
+++ a/arch/avr32/mach-at32ap/pio.c
@@ -214,7 +214,7 @@ int gpio_direction_input(unsigned int gp
 }
 EXPORT_SYMBOL(gpio_direction_input);
 
-int gpio_direction_output(unsigned int gpio)
+int gpio_direction_output(unsigned int gpio, int value)
 {
 	struct pio_device *pio;
 	unsigned int pin;
@@ -223,6 +223,8 @@ int gpio_direction_output(unsigned int g
 	if (!pio)
 		return -ENODEV;
 
+	gpio_set_value(gpio, value);
+
 	pin = gpio & 0x1f;
 	pio_writel(pio, OER, 1 << pin);
 
diff -puN Documentation/gpio.txt~gpio_direction_output-needs-an-initial-value Documentation/gpio.txt
--- a/Documentation/gpio.txt~gpio_direction_output-needs-an-initial-value
+++ a/Documentation/gpio.txt
@@ -105,12 +105,15 @@ setting up a platform_device using the G
 
 	/* set as input or output, returning 0 or negative errno */
 	int gpio_direction_input(unsigned gpio);
-	int gpio_direction_output(unsigned gpio);
+	int gpio_direction_output(unsigned gpio, int value);
 
 The return value is zero for success, else a negative errno.  It should
 be checked, since the get/set calls don't have error returns and since
 misconfiguration is possible.  (These calls could sleep.)
 
+For output GPIOs, the value provided becomes the initial output value.
+This helps avoid signal glitching during system startup.
+
 Setting the direction can fail if the GPIO number is invalid, or when
 that particular GPIO can't be used in that mode.  It's generally a bad
 idea to rely on boot firmware to have set the direction correctly, since
diff -puN drivers/spi/atmel_spi.c~gpio_direction_output-needs-an-initial-value drivers/spi/atmel_spi.c
--- a/drivers/spi/atmel_spi.c~gpio_direction_output-needs-an-initial-value
+++ a/drivers/spi/atmel_spi.c
@@ -425,7 +425,7 @@ static int atmel_spi_setup(struct spi_de
 		if (ret)
 			return ret;
 		spi->controller_state = (void *)npcs_pin;
-		gpio_direction_output(npcs_pin);
+		gpio_direction_output(npcs_pin, !(spi->mode & SPI_CS_HIGH));
 	}
 
 	dev_dbg(&spi->dev,
diff -puN include/asm-arm/arch-at91/gpio.h~gpio_direction_output-needs-an-initial-value include/asm-arm/arch-at91/gpio.h
--- a/include/asm-arm/arch-at91/gpio.h~gpio_direction_output-needs-an-initial-value
+++ a/include/asm-arm/arch-at91/gpio.h
@@ -223,7 +223,7 @@ static inline void gpio_free(unsigned gp
 }
 
 extern int gpio_direction_input(unsigned gpio);
-extern int gpio_direction_output(unsigned gpio);
+extern int gpio_direction_output(unsigned gpio, int value);
 
 static inline int gpio_get_value(unsigned gpio)
 {
diff -puN include/asm-arm/arch-omap/gpio.h~gpio_direction_output-needs-an-initial-value include/asm-arm/arch-omap/gpio.h
--- a/include/asm-arm/arch-omap/gpio.h~gpio_direction_output-needs-an-initial-value
+++ a/include/asm-arm/arch-omap/gpio.h
@@ -113,8 +113,9 @@ static inline int gpio_direction_input(u
 	return __gpio_set_direction(gpio, 1);
 }
 
-static inline int gpio_direction_output(unsigned gpio)
+static inline int gpio_direction_output(unsigned gpio, int value)
 {
+	omap_set_gpio_dataout(gpio, value);
 	return __gpio_set_direction(gpio, 0);
 }
 
diff -puN include/asm-arm/arch-pxa/gpio.h~gpio_direction_output-needs-an-initial-value include/asm-arm/arch-pxa/gpio.h
--- a/include/asm-arm/arch-pxa/gpio.h~gpio_direction_output-needs-an-initial-value
+++ a/include/asm-arm/arch-pxa/gpio.h
@@ -43,9 +43,9 @@ static inline int gpio_direction_input(u
 	return pxa_gpio_mode(gpio | GPIO_IN);
 }
 
-static inline int gpio_direction_output(unsigned gpio)
+static inline int gpio_direction_output(unsigned gpio, int value)
 {
-	return pxa_gpio_mode(gpio | GPIO_OUT);
+	return pxa_gpio_mode(gpio | GPIO_OUT | (value ? 0 : GPIO_DFLT_LOW));
 }
 
 static inline int __gpio_get_value(unsigned gpio)
diff -puN include/asm-arm/arch-s3c2410/gpio.h~gpio_direction_output-needs-an-initial-value include/asm-arm/arch-s3c2410/gpio.h
--- a/include/asm-arm/arch-s3c2410/gpio.h~gpio_direction_output-needs-an-initial-value
+++ a/include/asm-arm/arch-s3c2410/gpio.h
@@ -44,9 +44,11 @@ static inline int gpio_direction_input(u
 	return 0;
 }
 
-static inline int gpio_direction_output(unsigned gpio)
+static inline int gpio_direction_output(unsigned gpio, int value)
 {
 	s3c2410_gpio_cfgpin(gpio, S3C2410_GPIO_OUTPUT);
+	/* REVISIT can we write the value first, to avoid glitching? */
+	s3c2410_gpio_setpin(gpio, value);
 	return 0;
 }
 
diff -puN include/asm-arm/arch-sa1100/gpio.h~gpio_direction_output-needs-an-initial-value include/asm-arm/arch-sa1100/gpio.h
--- a/include/asm-arm/arch-sa1100/gpio.h~gpio_direction_output-needs-an-initial-value
+++ a/include/asm-arm/arch-sa1100/gpio.h
@@ -38,7 +38,7 @@ static inline void gpio_free(unsigned gp
 }
 
 extern int gpio_direction_input(unsigned gpio);
-extern int gpio_direction_output(unsigned gpio);
+extern int gpio_direction_output(unsigned gpio, int value);
 
 
 static inline int gpio_get_value(unsigned gpio)
diff -puN include/asm-avr32/arch-at32ap/gpio.h~gpio_direction_output-needs-an-initial-value include/asm-avr32/arch-at32ap/gpio.h
--- a/include/asm-avr32/arch-at32ap/gpio.h~gpio_direction_output-needs-an-initial-value
+++ a/include/asm-avr32/arch-at32ap/gpio.h
@@ -10,7 +10,7 @@ int __must_check gpio_request(unsigned i
 void gpio_free(unsigned int gpio);
 
 int gpio_direction_input(unsigned int gpio);
-int gpio_direction_output(unsigned int gpio);
+int gpio_direction_output(unsigned int gpio, int value);
 int gpio_get_value(unsigned int gpio);
 void gpio_set_value(unsigned int gpio, int value);
 
_

Patches currently in -mm which might be from david-b@pacbell.net are

reduce-pnp-syslog-spam.patch
rm-pointless-dmaengine-exports.patch
gpio_direction_output-needs-an-initial-value.patch
git-avr32.patch
git-md-accel.patch
8250-make-probing-for-txen-bug-a-config-option.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
blackfin-blackfin-i2c-driver-update-2.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
init-dma-masks-in-pnp_dev.patch
rtc-remove-sys-class-rtc-dev.patch
rtc-rtc-interfaces-dont-use-class_device.patch
rtc-simplified-rtc-sysfs-attribute-handling.patch
rtc-simplified-proc-driver-rtc-handling.patch
rtc-remove-rest-of-class_device.patch
rtc-suspend-resume-restores-system-clock.patch
rtc-simplified-rtc-sysfs-attribute-handling-tidy.patch
