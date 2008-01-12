From: akpm@linux-foundation.org
Subject: - generic-gpio-gpio_chip-support.patch removed from -mm tree
Date: Fri, 11 Jan 2008 18:12:46 -0800
Message-ID: <200801120212.m0C2CkPJ009298@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58425 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752484AbYALCVU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jan 2008 21:21:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, florian.fainelli@telecomint.eu, hskinnemoen@atmel.com, mm-commits@vger.kernel.org


The patch titled
     generic gpio: gpio_chip support
has been removed from the -mm tree.  Its filename was
     generic-gpio-gpio_chip-support.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: generic gpio: gpio_chip support
From: David Brownell <david-b@pacbell.net>

Provide new implementation infrastructure that platforms may choose to use
when implementing the GPIO programming interface.  Platforms can update their
GPIO support to use this.  In many cases the incremental cost to access a
non-inlined GPIO should be on the order of a dozen instructions, so it won't
normally be a problem.  The upside is:

  * Providing two features which were "want to have (but OK to defer)" when
    GPIO interfaces were first discussed in November 2006:

    -	A "struct gpio_chip" to plug in GPIOs that aren't directly supported
	by SOC platforms, but come from FPGAs or other multifunction devices
	using conventional device registers (like UCB-1x00 or SM501 GPIOs,
	and southbridges in PCs with more open specs than usual).

    -	Full support for message-based GPIO expanders, where registers are
	accessed through sleeping I/O calls.  Previous support for these
	"cansleep" calls was just stubs.  (One example: the widely used
	pcf8574 I2C chips, with 8 GPIOs each.)

  * Including a non-stub implementation of the gpio_{request,free}() calls,
    making those calls much more useful.  The diagnostic labels are also
    recorded given DEBUG_FS, so /sys/kernel/debug/gpio can show a snapshot
    of all GPIOs known to this infrastructure.

The driver programming interfaces introduced in 2.6.21 do not change at all;
this infrastructure is entirely below those covers.

This opens the door to an augmented programming interface, addressing GPIOs by
chip and index.  That could be used as a performance tweak (lookup once then
cache, avoiding locking and lookup overheads) or to support transient GPIOs
not registered in the integer GPIO namespace (maybe a USB-to-GPIO adapter, or
GPIOs coupled to some other type of add-on card).

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Florian Fainelli <florian.fainelli@telecomint.eu>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/gpio.txt     |   15 
 include/asm-generic/gpio.h |  127 ++++++++
 lib/Kconfig                |    6 
 lib/Kconfig.debug          |    9 
 lib/Makefile               |    2 
 lib/gpiolib.c              |  538 +++++++++++++++++++++++++++++++++++
 6 files changed, 693 insertions(+), 4 deletions(-)

diff -puN Documentation/gpio.txt~generic-gpio-gpio_chip-support Documentation/gpio.txt
--- a/Documentation/gpio.txt~generic-gpio-gpio_chip-support
+++ a/Documentation/gpio.txt
@@ -63,7 +63,9 @@ and that can be critical for glue logic.
 Plus, this doesn't define an implementation framework, just an interface.
 One platform might implement it as simple inline functions accessing chip
 registers; another might implement it by delegating through abstractions
-used for several very different kinds of GPIO controller.
+used for several very different kinds of GPIO controller.  (There is some
+library code supporting such an implementation strategy, but drivers acting
+as clients to the GPIO interface should not care how it's implemented.)
 
 That said, if the convention is supported on their platform, drivers should
 use it when possible.  Platforms should declare GENERIC_GPIO support in
@@ -133,6 +135,7 @@ Spinlock-Safe GPIO access
 -------------------------
 Most GPIO controllers can be accessed with memory read/write instructions.
 That doesn't need to sleep, and can safely be done from inside IRQ handlers.
+(That includes hardirq contexts on RT kernels.)
 
 Use these calls to access such GPIOs:
 
@@ -223,6 +226,9 @@ Note that requesting a GPIO does NOT cau
 way; it just marks that GPIO as in use.  Separate code must handle any
 pin setup (e.g. controlling which pin the GPIO uses, pullup/pulldown).
 
+Also note that it's your responsibility to have stopped using a GPIO
+before you free it.
+
 
 GPIOs mapped to IRQs
 --------------------
@@ -238,7 +244,7 @@ map between them using calls like:
 
 Those return either the corresponding number in the other namespace, or
 else a negative errno code if the mapping can't be done.  (For example,
-some GPIOs can't used as IRQs.)  It is an unchecked error to use a GPIO
+some GPIOs can't be used as IRQs.)  It is an unchecked error to use a GPIO
 number that wasn't set up as an input using gpio_direction_input(), or
 to use an IRQ number that didn't originally come from gpio_to_irq().
 
@@ -299,6 +305,7 @@ Related to multiplexing is configuration
 pulldowns integrated on some platforms.  Not all platforms support them,
 or support them in the same way; and any given board might use external
 pullups (or pulldowns) so that the on-chip ones should not be used.
+(When a circuit needs 5 kOhm, on-chip 100 kOhm resistors won't do.)
 
 There are other system-specific mechanisms that are not specified here,
 like the aforementioned options for input de-glitching and wire-OR output.
@@ -308,8 +315,8 @@ commonly grouped in banks of 16 or 32, w
 banks.)  Some systems can trigger IRQs from output GPIOs.  Code relying on
 such mechanisms will necessarily be nonportable.
 
-Dynamic definition of GPIOs is not currently supported; for example, as
+Dynamic definition of GPIOs is not currently standard; for example, as
 a side effect of configuring an add-on board with some GPIO expanders.
 
 These calls are purely for kernel space, but a userspace API could be built
-on top of it.
+on top of them.
diff -puN include/asm-generic/gpio.h~generic-gpio-gpio_chip-support include/asm-generic/gpio.h
--- a/include/asm-generic/gpio.h~generic-gpio-gpio_chip-support
+++ a/include/asm-generic/gpio.h
@@ -1,6 +1,131 @@
 #ifndef _ASM_GENERIC_GPIO_H
 #define _ASM_GENERIC_GPIO_H
 
+#ifdef CONFIG_GPIO_LIB
+
+/* Platforms may implement their GPIO interface with library code,
+ * at a small performance cost for non-inlined operations.
+ *
+ * While the GPIO programming interface defines valid GPIO numbers
+ * to be in the range 0..MAX_INT, this library restricts them to the
+ * smaller range 0..ARCH_NR_GPIOS and allocates them in groups of
+ * ARCH_GPIOS_PER_CHIP (which will usually be the word size used for
+ * each bank of a SOC processor's integrated GPIO modules).
+ */
+
+#ifndef ARCH_NR_GPIOS
+#define ARCH_NR_GPIOS		512
+#endif
+
+#ifndef ARCH_GPIOS_PER_CHIP
+#define ARCH_GPIOS_PER_CHIP	BITS_PER_LONG
+#endif
+
+struct seq_file;
+
+/**
+ * struct gpio_chip - abstract a GPIO controller
+ * @label: for diagnostics
+ * @direction_input: configures signal "offset" as input, or returns error
+ * @get: returns value for signal "offset"; for output signals this
+ *	returns either the value actually sensed, or zero
+ * @direction_output: configures signal "offset" as output, or returns error
+ * @set: assigns output value for signal "offset"
+ * @dbg_show: optional routine to show contents in debugfs; default code
+ *	will be used when this is omitted, but custom code can show extra
+ *	state (such as pullup/pulldown configuration).
+ * @base: identifies the first GPIO number handled by this chip; or, if
+ *	negative during registration, requests dynamic ID allocation.
+ * @ngpio: the number of GPIOs handled by this controller; the value must
+ *	be at most ARCH_GPIOS_PER_CHIP, so the last GPIO handled is
+ *	(base + ngpio - 1).
+ * @can_sleep: flag must be set iff get()/set() methods sleep, as they
+ *	must while accessing GPIO expander chips over I2C or SPI
+ * @is_out: bit array where bit N is true iff GPIO with offset N has been
+ *	 called successfully to configure this as an output
+ *
+ * A gpio_chip can help platforms abstract various sources of GPIOs so
+ * they can all be accessed through a common programing interface.
+ * Example sources would be SOC controllers, FPGAs, multifunction
+ * chips, dedicated GPIO expanders, and so on.
+ *
+ * Each chip controls a number of signals, numbered 0..@ngpio, which are
+ * identified in method calls by an "offset" value.  When those signals
+ * are referenced through calls like gpio_get_value(gpio), the offset
+ * is calculated by subtracting @base from the gpio number.
+ */
+struct gpio_chip {
+	char			*label;
+
+	int			(*direction_input)(struct gpio_chip *chip,
+						unsigned offset);
+	int			(*get)(struct gpio_chip *chip,
+						unsigned offset);
+	int			(*direction_output)(struct gpio_chip *chip,
+						unsigned offset, int value);
+	void			(*set)(struct gpio_chip *chip,
+						unsigned offset, int value);
+	void			(*dbg_show)(struct seq_file *s,
+						struct gpio_chip *chip);
+	int			base;
+	u16			ngpio;
+	unsigned		can_sleep:1;
+
+	/* other fields are modified by the gpio library only */
+	DECLARE_BITMAP(is_out, ARCH_GPIOS_PER_CHIP);
+
+#ifdef CONFIG_DEBUG_FS
+	/* fat bits */
+	const char		*requested[ARCH_GPIOS_PER_CHIP];
+#else
+	/* thin bits */
+	DECLARE_BITMAP(requested, ARCH_GPIOS_PER_CHIP);
+#endif
+};
+
+/* returns true iff a given gpio signal has been requested;
+ * primarily for code dumping gpio_chip state.
+ */
+static inline int
+gpiochip_is_requested(struct gpio_chip *chip, unsigned offset)
+{
+#ifdef CONFIG_DEBUG_FS
+	return chip->requested[offset] != NULL;
+#else
+	return test_bit(offset, chip->requested);
+#endif
+}
+
+/* add/remove chips */
+extern int gpiochip_add(struct gpio_chip *chip);
+extern int __must_check gpiochip_remove(struct gpio_chip *chip);
+
+
+/* Always use the library code for GPIO management calls,
+ * or when sleeping may be involved.
+ */
+extern int gpio_request(unsigned gpio, const char *label);
+extern void gpio_free(unsigned gpio);
+
+extern int gpio_direction_input(unsigned gpio);
+extern int gpio_direction_output(unsigned gpio, int value);
+
+extern int gpio_get_value_cansleep(unsigned gpio);
+extern void gpio_set_value_cansleep(unsigned gpio, int value);
+
+
+/* A platform's <asm/gpio.h> code may want to inline the I/O calls when
+ * the GPIO is constant and refers to some always-present controller,
+ * giving direct access to chip registers and tight bitbanging loops.
+ */
+extern int __gpio_get_value(unsigned gpio);
+extern void __gpio_set_value(unsigned gpio, int value);
+
+extern int __gpio_cansleep(unsigned gpio);
+
+
+#else
+
 /* platforms that don't directly support access to GPIOs through I2C, SPI,
  * or other blocking infrastructure can use these wrappers.
  */
@@ -22,4 +147,6 @@ static inline void gpio_set_value_cansle
 	gpio_set_value(gpio, value);
 }
 
+#endif
+
 #endif /* _ASM_GENERIC_GPIO_H */
diff -puN lib/Kconfig~generic-gpio-gpio_chip-support lib/Kconfig
--- a/lib/Kconfig~generic-gpio-gpio_chip-support
+++ a/lib/Kconfig
@@ -141,4 +141,10 @@ config HAS_DMA
 config CHECK_SIGNATURE
 	bool
 
+#
+# gpiolib is selected if needed
+#
+config GPIO_LIB
+	boolean
+
 endmenu
diff -puN lib/Kconfig.debug~generic-gpio-gpio_chip-support lib/Kconfig.debug
--- a/lib/Kconfig.debug~generic-gpio-gpio_chip-support
+++ a/lib/Kconfig.debug
@@ -156,6 +156,15 @@ config DEBUG_SLAB
 	  allocation as well as poisoning memory on free to catch use of freed
 	  memory. This can make kmalloc/kfree-intensive workloads much slower.
 
+config DEBUG_GPIO
+	bool "Debug GPIO calls"
+	depends on DEBUG_KERNEL && GPIO_LIB
+	help
+	  Say Y here to add some extra checks to GPIO calls, ensuring that
+	  GPIOs have been properly initialized before they are used and
+	  that sleeping calls aren't made from nonsleeping contexts.  This
+	  can make bitbanged serial protocols slower.
+
 config DEBUG_SLAB_LEAK
 	bool "Memory leak debugging"
 	depends on DEBUG_SLAB
diff -puN lib/Makefile~generic-gpio-gpio_chip-support lib/Makefile
--- a/lib/Makefile~generic-gpio-gpio_chip-support
+++ a/lib/Makefile
@@ -70,6 +70,8 @@ obj-$(CONFIG_FAULT_INJECTION) += fault-i
 
 lib-$(CONFIG_GENERIC_BUG) += bug.o
 
+lib-$(CONFIG_GPIO_LIB) += gpiolib.o
+
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
diff -puN /dev/null lib/gpiolib.c
--- /dev/null
+++ a/lib/gpiolib.c
@@ -0,0 +1,538 @@
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/irq.h>
+#include <linux/spinlock.h>
+
+#include <asm/gpio.h>
+
+
+/* Optional implementation infrastructure for GPIO interfaces.
+ *
+ * Platforms may want to use this if they tend to use very many GPIOs
+ * that aren't part of a System-On-Chip core; or across I2C/SPI/etc.
+ *
+ * When kernel footprint or instruction count is an issue, simpler
+ * implementations may be preferred.  The GPIO programming interface
+ * allows for inlining speed-critical get/set operations for common
+ * cases, so that access to SOC-integrated GPIOs can sometimes cost
+ * only an instruction or two per bit.
+ */
+
+
+/* When debugging, extend minimal trust to callers and platform code.
+ * Otherwise, minimize overhead in what may be bitbanging codepaths.
+ */
+#ifdef	CONFIG_DEBUG_GPIO
+#define	extra_checks	1
+#else
+#define	extra_checks	0
+#endif
+
+/* gpio_lock protects the table of chips and to gpio_chip->requested.
+ * While any gpio is requested, its gpio_chip is not removable.  It's
+ * a raw spinlock to ensure safe access from hardirq contexts, and to
+ * shrink bitbang overhead:  per-bit preemption would be very wrong.
+ */
+static raw_spinlock_t gpio_lock = __RAW_SPIN_LOCK_UNLOCKED;
+static struct gpio_chip *chips[DIV_ROUND_UP(ARCH_NR_GPIOS,
+					ARCH_GPIOS_PER_CHIP)];
+
+
+/* Warn when drivers omit gpio_request() calls -- legal but
+ * ill-advised when setting direction, and otherwise illegal.
+ */
+static void gpio_ensure_requested(struct gpio_chip *chip, unsigned offset)
+{
+	int		requested;
+
+#ifdef CONFIG_DEBUG_FS
+	requested = (int) chip->requested[offset];
+	if (!requested)
+		chip->requested[offset] = "[auto]";
+#else
+	requested = test_and_set_bit(offset, chip->requested);
+#endif
+
+	if (!requested)
+		printk(KERN_DEBUG "GPIO-%d autorequested\n",
+				chip->base + offset);
+}
+
+/* caller holds gpio_lock */
+static inline struct gpio_chip *gpio_to_chip(unsigned gpio)
+{
+	return chips[gpio / ARCH_GPIOS_PER_CHIP];
+}
+
+/**
+ * gpiochip_add() - register a gpio_chip
+ * @chip: the chip to register, with chip->base initialized
+ * Context: potentially before irqs or kmalloc will work
+ *
+ * Returns a negative errno if the chip can't be registered, such as
+ * because the chip->base is invalid or already associated with a
+ * different chip.  Otherwise it returns zero as a success code.
+ */
+int gpiochip_add(struct gpio_chip *chip)
+{
+	unsigned long	flags;
+	int		status = 0;
+	unsigned	id;
+
+	if (chip->base < 0 || (chip->base % ARCH_GPIOS_PER_CHIP) != 0)
+		return -EINVAL;
+	if ((chip->base + chip->ngpio) >= ARCH_NR_GPIOS)
+		return -EINVAL;
+	if (chip->ngpio > ARCH_GPIOS_PER_CHIP)
+		return -EINVAL;
+
+	local_irq_save(flags);
+	__raw_spin_lock(&gpio_lock);
+
+	id = chip->base / ARCH_GPIOS_PER_CHIP;
+	if (chips[id] == NULL)
+		chips[id] = chip;
+	else
+		status = -EBUSY;
+
+	__raw_spin_unlock(&gpio_lock);
+	local_irq_restore(flags);
+	return status;
+}
+EXPORT_SYMBOL_GPL(gpiochip_add);
+
+/**
+ * gpiochip_remove() - unregister a gpio_chip
+ * @chip: the chip to unregister
+ *
+ * A gpio_chip with any GPIOs still requested may not be removed.
+ */
+int gpiochip_remove(struct gpio_chip *chip)
+{
+	unsigned long	flags;
+	int		status = 0;
+	int		offset;
+	unsigned	id = chip->base / ARCH_GPIOS_PER_CHIP;
+
+	local_irq_save(flags);
+	__raw_spin_lock(&gpio_lock);
+
+	for (offset = 0; offset < chip->ngpio; offset++) {
+		if (gpiochip_is_requested(chip, offset)) {
+			status = -EBUSY;
+			break;
+		}
+	}
+
+	if (status == 0) {
+		if (chips[id] == chip)
+			chips[id] = NULL;
+		else
+			status = -EINVAL;
+	}
+
+	__raw_spin_unlock(&gpio_lock);
+	local_irq_restore(flags);
+	return status;
+}
+EXPORT_SYMBOL_GPL(gpiochip_remove);
+
+
+/* These "optional" allocation calls help prevent drivers from stomping
+ * on each other, and help provide better diagnostics in debugfs.
+ * They're called even less than the "set direction" calls.
+ */
+int gpio_request(unsigned gpio, const char *label)
+{
+	struct gpio_chip	*chip;
+	int			status = -EINVAL;
+	unsigned long		flags;
+
+	local_irq_save(flags);
+	__raw_spin_lock(&gpio_lock);
+
+	chip = gpio_to_chip(gpio);
+	if (!chip)
+		goto done;
+	gpio -= chip->base;
+	if (gpio >= chip->ngpio)
+		goto done;
+
+	/* NOTE:  gpio_request() can be called in early boot,
+	 * before IRQs are enabled.
+	 */
+
+	status = 0;
+#ifdef CONFIG_DEBUG_FS
+	if (!label)
+		label = "?";
+	if (chip->requested[gpio])
+		status = -EBUSY;
+	else
+		chip->requested[gpio] = label;
+#else
+	if (test_and_set_bit(gpio, chip->requested))
+		status = -EBUSY;
+#endif
+
+done:
+	__raw_spin_unlock(&gpio_lock);
+	local_irq_restore(flags);
+	return status;
+}
+EXPORT_SYMBOL_GPL(gpio_request);
+
+void gpio_free(unsigned gpio)
+{
+	unsigned long		flags;
+	struct gpio_chip	*chip;
+
+	local_irq_save(flags);
+	__raw_spin_lock(&gpio_lock);
+
+	chip = gpio_to_chip(gpio);
+	if (!chip)
+		goto done;
+	gpio -= chip->base;
+	if (gpio >= chip->ngpio)
+		goto done;
+
+#ifdef CONFIG_DEBUG_FS
+	if (chip->requested[gpio])
+		chip->requested[gpio] = NULL;
+	else
+		chip = NULL;
+#else
+	if (!test_and_clear_bit(gpio, chip->requested))
+		chip = NULL;
+#endif
+	WARN_ON(extra_checks && chip == NULL);
+done:
+	__raw_spin_unlock(&gpio_lock);
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL_GPL(gpio_free);
+
+
+
+/* Drivers MUST make configuration calls before get/set calls
+ *
+ * As a rule these aren't called more than once (except for drivers
+ * using the open-drain emulation idiom) so these are natural places
+ * to accumulate extra debugging checks.  Note that we can't rely on
+ * gpio_request() having been called beforehand.
+ */
+
+int gpio_direction_input(unsigned gpio)
+{
+	unsigned long		flags;
+	struct gpio_chip	*chip;
+	int			status = -EINVAL;
+
+	local_irq_save(flags);
+	__raw_spin_lock(&gpio_lock);
+
+	chip = gpio_to_chip(gpio);
+	if (!chip || !chip->get || !chip->direction_input)
+		goto fail;
+	gpio -= chip->base;
+	if (gpio >= chip->ngpio)
+		goto fail;
+	gpio_ensure_requested(chip, gpio);
+
+	/* now we know the gpio is valid and chip won't vanish */
+
+	__raw_spin_unlock(&gpio_lock);
+	local_irq_restore(flags);
+
+	might_sleep_if(extra_checks && chip->can_sleep);
+
+	status = chip->direction_input(chip, gpio);
+	if (status == 0)
+		clear_bit(gpio, chip->is_out);
+	return status;
+fail:
+	__raw_spin_unlock(&gpio_lock);
+	local_irq_restore(flags);
+	return status;
+}
+EXPORT_SYMBOL_GPL(gpio_direction_input);
+
+int gpio_direction_output(unsigned gpio, int value)
+{
+	unsigned long		flags;
+	struct gpio_chip	*chip;
+	int			status = -EINVAL;
+
+	local_irq_save(flags);
+	__raw_spin_lock(&gpio_lock);
+
+	chip = gpio_to_chip(gpio);
+	if (!chip || !chip->set || !chip->direction_output)
+		goto fail;
+	gpio -= chip->base;
+	if (gpio >= chip->ngpio)
+		goto fail;
+	gpio_ensure_requested(chip, gpio);
+
+	/* now we know the gpio is valid and chip won't vanish */
+
+	__raw_spin_unlock(&gpio_lock);
+	local_irq_restore(flags);
+
+	might_sleep_if(extra_checks && chip->can_sleep);
+
+	status = chip->direction_output(chip, gpio, value);
+	if (status == 0)
+		set_bit(gpio, chip->is_out);
+	return status;
+fail:
+	__raw_spin_unlock(&gpio_lock);
+	local_irq_restore(flags);
+	return status;
+}
+EXPORT_SYMBOL_GPL(gpio_direction_output);
+
+
+/* I/O calls are only valid after configuration completed; the relevant
+ * "is this a valid GPIO" error checks should already have been done.
+ *
+ * "Get" operations are often inlinable as reading a pin value register,
+ * and masking the relevant bit in that register.
+ *
+ * When "set" operations are inlinable, they involve writing that mask to
+ * one register to set a low value, or a different register to set it high.
+ * Otherwise locking is needed, so there may be little value to inlining.
+ */
+int __gpio_get_value(unsigned gpio)
+{
+	unsigned long		flags;
+	struct gpio_chip	*chip;
+
+	local_irq_save(flags);
+	__raw_spin_lock(&gpio_lock);
+
+	chip = gpio_to_chip(gpio);
+	if (extra_checks)
+		gpio_ensure_requested(chip, gpio - chip->base);
+
+	__raw_spin_unlock(&gpio_lock);
+	local_irq_restore(flags);
+
+	WARN_ON(extra_checks && chip->can_sleep);
+	return chip->get(chip, gpio - chip->base);
+}
+EXPORT_SYMBOL_GPL(__gpio_get_value);
+
+void __gpio_set_value(unsigned gpio, int value)
+{
+	unsigned long		flags;
+	struct gpio_chip	*chip;
+
+	local_irq_save(flags);
+	__raw_spin_lock(&gpio_lock);
+
+	chip = gpio_to_chip(gpio);
+	if (extra_checks)
+		gpio_ensure_requested(chip, gpio - chip->base);
+
+	__raw_spin_unlock(&gpio_lock);
+	local_irq_restore(flags);
+
+	WARN_ON(extra_checks && chip->can_sleep);
+	chip->set(chip, gpio - chip->base, value);
+}
+EXPORT_SYMBOL_GPL(__gpio_set_value);
+
+int __gpio_cansleep(unsigned gpio)
+{
+	unsigned long		flags;
+	struct gpio_chip	*chip;
+
+	local_irq_save(flags);
+	__raw_spin_lock(&gpio_lock);
+
+	chip = gpio_to_chip(gpio);
+	if (extra_checks)
+		gpio_ensure_requested(chip, gpio - chip->base);
+
+	__raw_spin_unlock(&gpio_lock);
+	local_irq_restore(flags);
+
+	return chip->can_sleep;
+}
+EXPORT_SYMBOL_GPL(__gpio_cansleep);
+
+
+
+/* There's no value in inlining GPIO calls that may sleep.
+ * Common examples include ones connected to I2C or SPI chips.
+ */
+
+int gpio_get_value_cansleep(unsigned gpio)
+{
+	unsigned long		flags;
+	struct gpio_chip	*chip;
+
+	might_sleep_if(extra_checks);
+
+	local_irq_save(flags);
+	__raw_spin_lock(&gpio_lock);
+
+	chip = gpio_to_chip(gpio);
+	if (extra_checks)
+		gpio_ensure_requested(chip, gpio - chip->base);
+
+	__raw_spin_unlock(&gpio_lock);
+	local_irq_restore(flags);
+
+	return chip->get(chip, gpio - chip->base);
+}
+EXPORT_SYMBOL_GPL(gpio_get_value_cansleep);
+
+void gpio_set_value_cansleep(unsigned gpio, int value)
+{
+	unsigned long		flags;
+	struct gpio_chip	*chip;
+
+	might_sleep_if(extra_checks);
+
+	local_irq_save(flags);
+	__raw_spin_lock(&gpio_lock);
+
+	chip = gpio_to_chip(gpio);
+	if (extra_checks)
+		gpio_ensure_requested(chip, gpio - chip->base);
+
+	__raw_spin_unlock(&gpio_lock);
+	local_irq_restore(flags);
+
+	chip->set(chip, gpio - chip->base, value);
+}
+EXPORT_SYMBOL_GPL(gpio_set_value_cansleep);
+
+
+#ifdef CONFIG_DEBUG_FS
+
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+
+
+static void gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)
+{
+	unsigned	i;
+
+	for (i = 0; i < chip->ngpio; i++) {
+		unsigned	gpio;
+		int		is_out;
+
+		if (!chip->requested[i])
+			continue;
+
+		gpio = chip->base + i;
+		is_out = test_bit(i, chip->is_out);
+
+		seq_printf(s, " gpio-%-3d (%-12s) %s %s",
+			gpio, chip->requested[i],
+			is_out ? "out" : "in ",
+			chip->get
+				? (chip->get(chip, i) ? "hi" : "lo")
+				: "?  ");
+
+		if (!is_out) {
+			int		irq = gpio_to_irq(gpio);
+			struct irq_desc	*desc = irq_desc + irq;
+
+			/* This races with request_irq(), set_irq_type(),
+			 * and set_irq_wake() ... but those are "rare".
+			 *
+			 * More significantly, trigger type flags aren't
+			 * currently maintained by genirq.
+			 */
+			if (irq >= 0 && desc->action) {
+				char *trigger;
+
+				switch (desc->status & IRQ_TYPE_SENSE_MASK) {
+				case IRQ_TYPE_NONE:
+					trigger = "(default)";
+					break;
+				case IRQ_TYPE_EDGE_FALLING:
+					trigger = "edge-falling";
+					break;
+				case IRQ_TYPE_EDGE_RISING:
+					trigger = "edge-rising";
+					break;
+				case IRQ_TYPE_EDGE_BOTH:
+					trigger = "edge-both";
+					break;
+				case IRQ_TYPE_LEVEL_HIGH:
+					trigger = "level-high";
+					break;
+				case IRQ_TYPE_LEVEL_LOW:
+					trigger = "level-low";
+					break;
+				default:
+					trigger = "?trigger?";
+					break;
+				}
+
+				seq_printf(s, " irq-%d %s%s",
+					irq, trigger,
+					(desc->status & IRQ_WAKEUP)
+						? " wakeup" : "");
+			}
+		}
+
+		seq_printf(s, "\n");
+	}
+}
+
+static int gpiolib_show(struct seq_file *s, void *unused)
+{
+	struct gpio_chip	*chip;
+	unsigned		id;
+	int			started = 0;
+
+	/* REVISIT this isn't locked against gpio_chip removal ... */
+
+	for (id = 0; id < ARRAY_SIZE(chips); id++) {
+		chip = chips[id];
+		if (!chip)
+			continue;
+
+		seq_printf(s, "%sGPIOs %d-%d, %s%s:\n",
+				started ? "\n" : "",
+				chip->base, chip->base + chip->ngpio - 1,
+				chip->label ? : "generic",
+				chip->can_sleep ? ", can sleep" : "");
+		started = 1;
+		if (chip->dbg_show)
+			chip->dbg_show(s, chip);
+		else
+			gpiolib_dbg_show(s, chip);
+	}
+	return 0;
+}
+
+static int gpiolib_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, gpiolib_show, NULL);
+}
+
+static struct file_operations gpiolib_operations = {
+	.open		= gpiolib_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int __init gpiolib_debugfs_init(void)
+{
+	/* /sys/kernel/debug/gpio */
+	(void) debugfs_create_file("gpio", S_IFREG | S_IRUGO,
+				NULL, NULL, &gpiolib_operations);
+	return 0;
+}
+postcore_initcall(gpiolib_debugfs_init);
+
+#endif	/* DEBUG_FS */
_

Patches currently in -mm which might be from david-b@pacbell.net are

git-arm.patch
i2c-isp1301_omap-new-style-i2c-driver-updates-part-1.patch
i2c-isp1301_omap-new-style-i2c-driver-updates-part-2.patch
git-input.patch
git-mmc.patch
git-mtd.patch
pcmcia-stop-updating-dev-powerpower_state.patch
remove-obsolete-sys-devices-power-state-docs.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
remove-pointless-casts-from-void-pointers.patch
spi-core-stop-updating-dev-powerpower_state.patch
cosmetic-fixes-to-rtc-subsystems-kconfig.patch
rtc-pcf8583-dont-abuse-i2c_m_nostart.patch
rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch
rtc-cmos-exports-nvram-in-sysfs.patch
rtc-cmos-alarm-acts-as-oneshot.patch
platform-real-time-clock-driver-for-dallas-1511-chip.patch
rtc-add-support-for-the-s-35390a-rtc-chip.patch
rtc-add-support-for-the-s-35390a-rtc-chip-update.patch
w1-gpio-add-gpio-w1-bus-master-driver.patch
w1-gpio-add-gpio-w1-bus-master-driver-v3.patch
generic-gpio-gpio_chip-support.patch
generic-gpio-gpio_chip-support-fix.patch
generic-gpio-gpio_chip-support-gpiolib-locking-simplified.patch
avr32-uses-gpio_chip.patch
mcp23s08-spi-gpio-expander.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
arm-pxa-gpiolib-support-make-pxa_gpio_chip-static.patch
