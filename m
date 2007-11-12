From: akpm@linux-foundation.org
Subject: + avr32-uses-gpio_chip.patch added to -mm tree
Date: Mon, 12 Nov 2007 13:38:16 -0800
Message-ID: <200711122138.lACLcGsx010198@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51609 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752579AbXKLVij (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 16:38:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net, florian.fainelli@telecomint.eu, hskinnemoen@atmel.com


The patch titled
     avr32 uses gpio_chip
has been added to the -mm tree.  Its filename is
     avr32-uses-gpio_chip.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: avr32 uses gpio_chip
From: David Brownell <david-b@pacbell.net>

Teach AVR32 to use the "GPIO Library" when exposing its GPIOs, so that signals
on external chips (like GPIO expanders) can easily be used.

This mostly reorganizes some existing logic, with two minor changes
in behavior:

 - The PSR registers are used instead of the previous "gpio_mask" values,
   matching AT91 behavior and removing some duplication between that role
   and that of "pinmux_mask".

 - NR_IRQs grew to acommodate a bank of external GPIOs.  Eventually this
   number should probably become a config option.

There's a debugfs dump of status for the built-in GPIOs, showing which
pins have deglitching, pullups, or open drain drive enabled, as well as
the ID string used when requesting each IRQ.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Florian Fainelli <florian.fainelli@telecomint.eu>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/Kconfig                         |    1 
 arch/avr32/mach-at32ap/pio.c               |  169 ++++++++++---------
 arch/avr32/mach-at32ap/pio.h               |    2 
 include/asm-avr32/arch-at32ap/at32ap7000.h |    2 
 include/asm-avr32/arch-at32ap/gpio.h       |   36 ++--
 include/asm-avr32/arch-at32ap/irq.h        |    4 
 6 files changed, 119 insertions(+), 95 deletions(-)

diff -puN arch/avr32/Kconfig~avr32-uses-gpio_chip arch/avr32/Kconfig
--- a/arch/avr32/Kconfig~avr32-uses-gpio_chip
+++ a/arch/avr32/Kconfig
@@ -83,6 +83,7 @@ config PLATFORM_AT32AP
 	select SUBARCH_AVR32B
 	select MMU
 	select PERFORMANCE_COUNTERS
+	select GPIO_LIB
 
 choice
 	prompt "AVR32 CPU type"
diff -puN arch/avr32/mach-at32ap/pio.c~avr32-uses-gpio_chip arch/avr32/mach-at32ap/pio.c
--- a/arch/avr32/mach-at32ap/pio.c~avr32-uses-gpio_chip
+++ a/arch/avr32/mach-at32ap/pio.c
@@ -28,7 +28,7 @@ struct pio_device {
 	const struct platform_device *pdev;
 	struct clk *clk;
 	u32 pinmux_mask;
-	u32 gpio_mask;
+	struct gpio_chip chip;
 	char name[8];
 };
 
@@ -64,7 +64,8 @@ void __init at32_select_periph(unsigned 
 		goto fail;
 	}
 
-	if (unlikely(test_and_set_bit(pin_index, &pio->pinmux_mask))) {
+	if (unlikely(test_and_set_bit(pin_index, &pio->pinmux_mask)
+			 || gpiochip_is_requested(&pio->chip, pin_index))) {
 		printk("%s: pin %u is busy\n", pio->name, pin_index);
 		goto fail;
 	}
@@ -79,9 +80,6 @@ void __init at32_select_periph(unsigned 
 	if (!(flags & AT32_GPIOF_PULLUP))
 		pio_writel(pio, PUDR, mask);
 
-	/* gpio_request NOT allowed */
-	set_bit(pin_index, &pio->gpio_mask);
-
 	return;
 
 fail:
@@ -130,9 +128,6 @@ void __init at32_select_gpio(unsigned in
 
 	pio_writel(pio, PER, mask);
 
-	/* gpio_request now allowed */
-	clear_bit(pin_index, &pio->gpio_mask);
-
 	return;
 
 fail:
@@ -166,96 +161,50 @@ fail:
 
 /* GPIO API */
 
-int gpio_request(unsigned int gpio, const char *label)
+static int direction_input(struct gpio_chip *chip, unsigned offset)
 {
-	struct pio_device *pio;
-	unsigned int pin;
+	struct pio_device *pio = container_of(chip, struct pio_device, chip);
+	u32 mask = 1 << offset;
 
-	pio = gpio_to_pio(gpio);
-	if (!pio)
-		return -ENODEV;
-
-	pin = gpio & 0x1f;
-	if (test_and_set_bit(pin, &pio->gpio_mask))
-		return -EBUSY;
+	if (!(pio_readl(pio, PSR) & mask))
+		return -EINVAL;
 
+	pio_writel(pio, ODR, mask);
 	return 0;
 }
-EXPORT_SYMBOL(gpio_request);
 
-void gpio_free(unsigned int gpio)
+static int gpio_get(struct gpio_chip *chip, unsigned offset)
 {
-	struct pio_device *pio;
-	unsigned int pin;
-
-	pio = gpio_to_pio(gpio);
-	if (!pio) {
-		printk(KERN_ERR
-		       "gpio: attempted to free invalid pin %u\n", gpio);
-		return;
-	}
+	struct pio_device *pio = container_of(chip, struct pio_device, chip);
 
-	pin = gpio & 0x1f;
-	if (!test_and_clear_bit(pin, &pio->gpio_mask))
-		printk(KERN_ERR "gpio: freeing free or non-gpio pin %s-%u\n",
-		       pio->name, pin);
+	return (pio_readl(pio, PDSR) >> offset) & 1;
 }
-EXPORT_SYMBOL(gpio_free);
 
-int gpio_direction_input(unsigned int gpio)
-{
-	struct pio_device *pio;
-	unsigned int pin;
-
-	pio = gpio_to_pio(gpio);
-	if (!pio)
-		return -ENODEV;
+static void gpio_set(struct gpio_chip *chip, unsigned offset, int value);
 
-	pin = gpio & 0x1f;
-	pio_writel(pio, ODR, 1 << pin);
-
-	return 0;
-}
-EXPORT_SYMBOL(gpio_direction_input);
-
-int gpio_direction_output(unsigned int gpio, int value)
+static int direction_output(struct gpio_chip *chip, unsigned offset, int value)
 {
-	struct pio_device *pio;
-	unsigned int pin;
-
-	pio = gpio_to_pio(gpio);
-	if (!pio)
-		return -ENODEV;
+	struct pio_device *pio = container_of(chip, struct pio_device, chip);
+	u32 mask = 1 << offset;
 
-	gpio_set_value(gpio, value);
-
-	pin = gpio & 0x1f;
-	pio_writel(pio, OER, 1 << pin);
+	if (!(pio_readl(pio, PSR) & mask))
+		return -EINVAL;
 
+	gpio_set(chip, offset, value);
+	pio_writel(pio, OER, mask);
 	return 0;
 }
-EXPORT_SYMBOL(gpio_direction_output);
 
-int gpio_get_value(unsigned int gpio)
+static void gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 {
-	struct pio_device *pio = &pio_dev[gpio >> 5];
+	struct pio_device *pio = container_of(chip, struct pio_device, chip);
+	u32 mask = 1 << offset;
 
-	return (pio_readl(pio, PDSR) >> (gpio & 0x1f)) & 1;
-}
-EXPORT_SYMBOL(gpio_get_value);
-
-void gpio_set_value(unsigned int gpio, int value)
-{
-	struct pio_device *pio = &pio_dev[gpio >> 5];
-	u32 mask;
-
-	mask = 1 << (gpio & 0x1f);
 	if (value)
 		pio_writel(pio, SODR, mask);
 	else
 		pio_writel(pio, CODR, mask);
 }
-EXPORT_SYMBOL(gpio_set_value);
 
 /*--------------------------------------------------------------------------*/
 
@@ -339,6 +288,60 @@ gpio_irq_setup(struct pio_device *pio, i
 
 /*--------------------------------------------------------------------------*/
 
+#ifdef CONFIG_DEBUG_FS
+
+#include <linux/seq_file.h>
+
+/*
+ * This shows more info than the generic gpio dump code:
+ * pullups, deglitching, open drain drive.
+ */
+static void pio_bank_show(struct seq_file *s, struct gpio_chip *chip)
+{
+	struct pio_device *pio = container_of(chip, struct pio_device, chip);
+	u32			psr, osr, imr, pdsr, pusr, ifsr, mdsr;
+	unsigned		i;
+	u32			mask;
+	char			bank;
+
+	psr = pio_readl(pio, PSR);
+	osr = pio_readl(pio, OSR);
+	imr = pio_readl(pio, IMR);
+	pdsr = pio_readl(pio, PDSR);
+	pusr = pio_readl(pio, PUSR);
+	ifsr = pio_readl(pio, IFSR);
+	mdsr = pio_readl(pio, MDSR);
+
+	bank = 'A' + pio->pdev->id;
+
+	for (i = 0, mask = 1; i < 32; i++, mask <<= 1) {
+		if (!gpiochip_is_requested(chip, i))
+			continue;
+
+		seq_printf(s, " gpio-%-3d P%c%-2d (%-12s) %s %s %s",
+			chip->base + i, bank, i,
+			chip->requested[i],
+			(osr & mask) ? "out" : "in ",
+			(mask & pdsr) ? "hi" : "lo",
+			(mask & pusr) ? "  " : "up");
+		if (ifsr & mask)
+			seq_printf(s, " deglitch");
+		if ((osr & mdsr) & mask)
+			seq_printf(s, " open-drain");
+		if (imr & mask)
+			seq_printf(s, " irq-%d edge-both",
+				gpio_to_irq(chip->base + i));
+		seq_printf(s, "\n");
+	}
+}
+
+#else
+#define pio_bank_show	NULL
+#endif
+
+
+/*--------------------------------------------------------------------------*/
+
 static int __init pio_probe(struct platform_device *pdev)
 {
 	struct pio_device *pio = NULL;
@@ -349,6 +352,18 @@ static int __init pio_probe(struct platf
 	pio = &pio_dev[pdev->id];
 	BUG_ON(!pio->regs);
 
+	pio->chip.label = pio->name;
+	pio->chip.base = pdev->id * 32;
+	pio->chip.ngpio = 32;
+
+	pio->chip.direction_input = direction_input;
+	pio->chip.get = gpio_get;
+	pio->chip.direction_output = direction_output;
+	pio->chip.set = gpio_set;
+	pio->chip.dbg_show = pio_bank_show;
+
+	gpiochip_add(&pio->chip);
+
 	gpio_irq_setup(pio, irq, gpio_irq_base);
 
 	platform_set_drvdata(pdev, pio);
@@ -406,12 +421,6 @@ void __init at32_init_pio(struct platfor
 	pio->pdev = pdev;
 	pio->regs = ioremap(regs->start, regs->end - regs->start + 1);
 
-	/*
-	 * request_gpio() is only valid for pins that have been
-	 * explicitly configured as GPIO and not previously requested
-	 */
-	pio->gpio_mask = ~0UL;
-
 	/* start with irqs disabled and acked */
 	pio_writel(pio, IDR, ~0UL);
 	(void) pio_readl(pio, ISR);
diff -puN arch/avr32/mach-at32ap/pio.h~avr32-uses-gpio_chip arch/avr32/mach-at32ap/pio.h
--- a/arch/avr32/mach-at32ap/pio.h~avr32-uses-gpio_chip
+++ a/arch/avr32/mach-at32ap/pio.h
@@ -19,7 +19,7 @@
 #define PIO_OSR                                0x0018
 #define PIO_IFER                               0x0020
 #define PIO_IFDR                               0x0024
-#define PIO_ISFR                               0x0028
+#define PIO_IFSR                               0x0028
 #define PIO_SODR                               0x0030
 #define PIO_CODR                               0x0034
 #define PIO_ODSR                               0x0038
diff -puN include/asm-avr32/arch-at32ap/at32ap7000.h~avr32-uses-gpio_chip include/asm-avr32/arch-at32ap/at32ap7000.h
--- a/include/asm-avr32/arch-at32ap/at32ap7000.h~avr32-uses-gpio_chip
+++ a/include/asm-avr32/arch-at32ap/at32ap7000.h
@@ -13,8 +13,6 @@
 #define GPIO_PERIPH_A	0
 #define GPIO_PERIPH_B	1
 
-#define NR_GPIO_CONTROLLERS	4
-
 /*
  * Pin numbers identifying specific GPIO pins on the chip. They can
  * also be converted to IRQ numbers by passing them through
diff -puN include/asm-avr32/arch-at32ap/gpio.h~avr32-uses-gpio_chip include/asm-avr32/arch-at32ap/gpio.h
--- a/include/asm-avr32/arch-at32ap/gpio.h~avr32-uses-gpio_chip
+++ a/include/asm-avr32/arch-at32ap/gpio.h
@@ -5,20 +5,36 @@
 #include <asm/irq.h>
 
 
-/* Arch-neutral GPIO API */
-int __must_check gpio_request(unsigned int gpio, const char *label);
-void gpio_free(unsigned int gpio);
-
-int gpio_direction_input(unsigned int gpio);
-int gpio_direction_output(unsigned int gpio, int value);
-int gpio_get_value(unsigned int gpio);
-void gpio_set_value(unsigned int gpio, int value);
+/* Some GPIO chips can manage IRQs; some can't.  The exact numbers can
+ * be changed if needed, but for the moment they're not configurable.
+ */
+#define ARCH_NR_GPIOS	(NR_GPIO_IRQS + 2 * ARCH_GPIOS_PER_CHIP)
+
+
+/* Arch-neutral GPIO API, supporting both "native" and external GPIOs. */
+#include <asm-generic/gpio.h>
+
+static inline int gpio_get_value(unsigned int gpio)
+{
+	return __gpio_get_value(gpio);
+}
+
+static inline void gpio_set_value(unsigned int gpio, int value)
+{
+	__gpio_set_value(gpio, value);
+}
+
+static inline int gpio_cansleep(unsigned int gpio)
+{
+	return __gpio_cansleep(gpio);
+}
 
-#include <asm-generic/gpio.h>		/* cansleep wrappers */
 
 static inline int gpio_to_irq(unsigned int gpio)
 {
-	return gpio + GPIO_IRQ_BASE;
+	if (gpio < NR_GPIO_IRQS)
+		return gpio + GPIO_IRQ_BASE;
+	return -EINVAL;
 }
 
 static inline int irq_to_gpio(unsigned int irq)
diff -puN include/asm-avr32/arch-at32ap/irq.h~avr32-uses-gpio_chip include/asm-avr32/arch-at32ap/irq.h
--- a/include/asm-avr32/arch-at32ap/irq.h~avr32-uses-gpio_chip
+++ a/include/asm-avr32/arch-at32ap/irq.h
@@ -3,11 +3,11 @@
 
 #define EIM_IRQ_BASE	NR_INTERNAL_IRQS
 #define NR_EIM_IRQS	32
-
 #define AT32_EXTINT(n)	(EIM_IRQ_BASE + (n))
 
 #define GPIO_IRQ_BASE	(EIM_IRQ_BASE + NR_EIM_IRQS)
-#define NR_GPIO_IRQS	(5 * 32)
+#define NR_GPIO_CTLR	(5 /*internal*/ + 1 /*external*/)
+#define NR_GPIO_IRQS	(NR_GPIO_CTLR * 32)
 
 #define NR_IRQS		(GPIO_IRQ_BASE + NR_GPIO_IRQS)
 
_

Patches currently in -mm which might be from david-b@pacbell.net are

rtc_hctosys-expects-rtcs-in-utc-doc.patch
rtcs-handle-nvram-better.patch
rtc-ds1307-exports-nvram.patch
rtc-tweak-driver-documentation-for-rtc-periodic.patch
spi-fix-double-free-on-spi_unregister_master.patch
spi-fix-error-paths-on-txx9spi_probe.patch
atmel_serial-build-warnings-begone.patch
rtc-dont-write-rtc-century-when-setting-a-wake-alarm.patch
git-arm-master.patch
usb-s3c2410_udc-minor-irq-handler-cleanups.patch
rtc-release-correct-region-in-error-path.patch
rtc-fallback-to-requesting-only-the-ports-we-actually-use.patch
tle62x0-driver-stops-ignoring-read-errors.patch
rtc-convert-mutex-to-bitfield.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
remove-pointless-casts-from-void-pointers.patch
spi-at25-driver-is-for-eeprom-not-flash.patch
spi-use-mutex-not-semaphore.patch
blackfin-spi-driver-use-cpu_relax-to-replace-continue-in-while-busywait.patch
blackfin-spi-driver-use-void-__iomem-for-regs_base.patch
blackfin-spi-driver-move-hard-coded-pin_req-to-board-file.patch
blackfin-spi-driver-reconfigure-speed_hz-and-bits_per_word-in-each-spi-transfer.patch
cosmetic-fixes-to-rtc-subsystems-kconfig.patch
rtc-pcf8583-dont-abuse-i2c_m_nostart.patch
rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch
rtc-cmos-exports-nvram-in-sysfs.patch
generic-gpio-gpio_chip-support.patch
avr32-uses-gpio_chip.patch
mcp23s08-spi-gpio-expander.patch
pnp-request-ioport-and-iomem-resources-used-by-active-devices.patch
