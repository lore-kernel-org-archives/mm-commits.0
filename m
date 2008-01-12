From: akpm@linux-foundation.org
Subject: - mcp23s08-spi-gpio-expander.patch removed from -mm tree
Date: Fri, 11 Jan 2008 18:12:57 -0800
Message-ID: <200801120212.m0C2CvXp009310@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35170 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752631AbYALCV0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jan 2008 21:21:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, florian.fainelli@telecomint.eu, hskinnemoen@atmel.com, mm-commits@vger.kernel.org


The patch titled
     mcp23s08 spi gpio expander
has been removed from the -mm tree.  Its filename was
     mcp23s08-spi-gpio-expander.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mcp23s08 spi gpio expander
From: David Brownell <david-b@pacbell.net>

Basic driver for 8-bit SPI based MCP23S08 GPIO expander, without support for
IRQs or the shared chipselect mechanism.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Florian Fainelli <florian.fainelli@telecomint.eu>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/Kconfig          |    7 
 drivers/spi/Makefile         |    1 
 drivers/spi/mcp23s08.c       |  355 +++++++++++++++++++++++++++++++++
 include/linux/spi/mcp23s08.h |   24 ++
 4 files changed, 387 insertions(+)

diff -puN drivers/spi/Kconfig~mcp23s08-spi-gpio-expander drivers/spi/Kconfig
--- a/drivers/spi/Kconfig~mcp23s08-spi-gpio-expander
+++ a/drivers/spi/Kconfig
@@ -214,6 +214,13 @@ config SPI_AT25
 	  This driver can also be built as a module.  If so, the module
 	  will be called at25.
 
+config SPI_MCP23S08
+	tristate "Microchip MCP23S08 I/O expander"
+	depends on SPI_MASTER && GPIO_LIB
+	help
+	  SPI driver for Microchip MCP23S08 I/O expander.  This provides
+	  a GPIO interface supporting inputs and outputs.
+
 config SPI_SPIDEV
 	tristate "User mode SPI device driver support"
 	depends on SPI_MASTER && EXPERIMENTAL
diff -puN drivers/spi/Makefile~mcp23s08-spi-gpio-expander drivers/spi/Makefile
--- a/drivers/spi/Makefile~mcp23s08-spi-gpio-expander
+++ a/drivers/spi/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_SPI_XILINX)		+= xilinx_spi.
 
 # SPI protocol drivers (device/link on bus)
 obj-$(CONFIG_SPI_AT25)		+= at25.o
+obj-$(CONFIG_SPI_MCP23S08)	+= mcp23s08.o
 obj-$(CONFIG_SPI_SPIDEV)	+= spidev.o
 obj-$(CONFIG_SPI_TLE62X0)	+= tle62x0.o
 # 	... add above this line ...
diff -puN /dev/null drivers/spi/mcp23s08.c
--- /dev/null
+++ a/drivers/spi/mcp23s08.c
@@ -0,0 +1,355 @@
+/*
+ * mcp23s08.c - SPI gpio expander driver
+ */
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/workqueue.h>
+#include <linux/mutex.h>
+
+#include <linux/spi/spi.h>
+#include <linux/spi/mcp23s08.h>
+
+#include <asm/gpio.h>
+
+
+/* Registers are all 8 bits wide.
+ *
+ * The mcp23s17 has twice as many bits, and can be configured to work
+ * with either 16 bit registers or with two adjacent 8 bit banks.
+ *
+ * Also, there are I2C versions of both chips.
+ */
+#define MCP_IODIR	0x00		/* init/reset:  all ones */
+#define MCP_IPOL	0x01
+#define MCP_GPINTEN	0x02
+#define MCP_DEFVAL	0x03
+#define MCP_INTCON	0x04
+#define MCP_IOCON	0x05
+#	define IOCON_SEQOP	(1 << 5)
+#	define IOCON_HAEN	(1 << 3)
+#	define IOCON_ODR	(1 << 2)
+#	define IOCON_INTPOL	(1 << 1)
+#define MCP_GPPU	0x06
+#define MCP_INTF	0x07
+#define MCP_INTCAP	0x08
+#define MCP_GPIO	0x09
+#define MCP_OLAT	0x0a
+
+struct mcp23s08 {
+	struct spi_device	*spi;
+	u8			addr;
+
+	/* lock protects the cached values */
+	struct mutex		lock;
+	u8			cache[11];
+
+	struct gpio_chip	chip;
+
+	struct work_struct	work;
+};
+
+static int mcp23s08_read(struct mcp23s08 *mcp, unsigned reg)
+{
+	u8	tx[2], rx[1];
+	int	status;
+
+	tx[0] = mcp->addr | 0x01;
+	tx[1] = reg;
+	status = spi_write_then_read(mcp->spi, tx, sizeof tx, rx, sizeof rx);
+	return (status < 0) ? status : rx[0];
+}
+
+static int mcp23s08_write(struct mcp23s08 *mcp, unsigned reg, u8 val)
+{
+	u8	tx[3];
+
+	tx[0] = mcp->addr;
+	tx[1] = reg;
+	tx[2] = val;
+	return spi_write_then_read(mcp->spi, tx, sizeof tx, NULL, 0);
+}
+
+static int
+mcp23s08_read_regs(struct mcp23s08 *mcp, unsigned reg, u8 *vals, unsigned n)
+{
+	u8	tx[2];
+
+	if ((n + reg) > sizeof mcp->cache)
+		return -EINVAL;
+	tx[0] = mcp->addr | 0x01;
+	tx[1] = reg;
+	return spi_write_then_read(mcp->spi, tx, sizeof tx, vals, n);
+}
+
+/*----------------------------------------------------------------------*/
+
+static int mcp23s08_direction_input(struct gpio_chip *chip, unsigned offset)
+{
+	struct mcp23s08	*mcp = container_of(chip, struct mcp23s08, chip);
+	int status;
+
+	mutex_lock(&mcp->lock);
+	mcp->cache[MCP_IODIR] |= (1 << offset);
+	status = mcp23s08_write(mcp, MCP_IODIR, mcp->cache[MCP_IODIR]);
+	mutex_unlock(&mcp->lock);
+	return status;
+}
+
+static int mcp23s08_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct mcp23s08	*mcp = container_of(chip, struct mcp23s08, chip);
+	int status;
+
+	mutex_lock(&mcp->lock);
+
+	/* REVISIT reading this clears any IRQ ... */
+	status = mcp23s08_read(mcp, MCP_GPIO);
+	if (status < 0)
+		status = 0;
+	else {
+		mcp->cache[MCP_GPIO] = status;
+		status = !!(status & (1 << offset));
+	}
+	mutex_unlock(&mcp->lock);
+	return status;
+}
+
+static int __mcp23s08_set(struct mcp23s08 *mcp, unsigned mask, int value)
+{
+	u8 olat = mcp->cache[MCP_OLAT];
+
+	if (value)
+		olat |= mask;
+	else
+		olat &= ~mask;
+	mcp->cache[MCP_OLAT] = olat;
+	return mcp23s08_write(mcp, MCP_OLAT, olat);
+}
+
+static void mcp23s08_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct mcp23s08	*mcp = container_of(chip, struct mcp23s08, chip);
+	u8 mask = 1 << offset;
+
+	mutex_lock(&mcp->lock);
+	__mcp23s08_set(mcp, mask, value);
+	mutex_unlock(&mcp->lock);
+}
+
+static int
+mcp23s08_direction_output(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct mcp23s08	*mcp = container_of(chip, struct mcp23s08, chip);
+	u8 mask = 1 << offset;
+	int status;
+
+	mutex_lock(&mcp->lock);
+	status = __mcp23s08_set(mcp, mask, value);
+	if (status == 0) {
+		mcp->cache[MCP_IODIR] &= ~mask;
+		status = mcp23s08_write(mcp, MCP_IODIR, mcp->cache[MCP_IODIR]);
+	}
+	mutex_unlock(&mcp->lock);
+	return status;
+}
+
+/*----------------------------------------------------------------------*/
+
+#ifdef CONFIG_DEBUG_FS
+
+#include <linux/seq_file.h>
+
+/*
+ * This shows more info than the generic gpio dump code:
+ * pullups, deglitching, open drain drive.
+ */
+static void mcp23s08_dbg_show(struct seq_file *s, struct gpio_chip *chip)
+{
+	struct mcp23s08	*mcp;
+	char		bank;
+	unsigned	t;
+	unsigned	mask;
+
+	mcp = container_of(chip, struct mcp23s08, chip);
+
+	/* NOTE: we only handle one bank for now ... */
+	bank = '0' + ((mcp->addr >> 1) & 0x3);
+
+	mutex_lock(&mcp->lock);
+	t = mcp23s08_read_regs(mcp, 0, mcp->cache, sizeof mcp->cache);
+	if (t < 0) {
+		seq_printf(s, " I/O ERROR %d\n", t);
+		goto done;
+	}
+
+	for (t = 0, mask = 1; t < 8; t++, mask <<= 1) {
+		if (!gpiochip_is_requested(chip, t))
+			continue;
+
+		seq_printf(s, " gpio-%-3d P%c.%d (%-12s) %s %s %s",
+			chip->base + t, bank, t,
+			chip->requested[t],
+			(mcp->cache[MCP_IODIR] & mask) ? "in " : "out",
+			(mcp->cache[MCP_GPIO] & mask) ? "hi" : "lo",
+			(mcp->cache[MCP_GPPU] & mask) ? "  " : "up");
+		/* NOTE:  ignoring the irq-related registers */
+		seq_printf(s, "\n");
+	}
+done:
+	mutex_unlock(&mcp->lock);
+}
+
+#else
+#define mcp23s08_dbg_show	NULL
+#endif
+
+/*----------------------------------------------------------------------*/
+
+static int mcp23s08_probe(struct spi_device *spi)
+{
+	struct mcp23s08			*mcp;
+	struct mcp23s08_platform_data	*pdata;
+	int				status;
+	int				do_update = 0;
+
+	pdata = spi->dev.platform_data;
+	if (!pdata || pdata->slave > 3 || !pdata->base)
+		return -ENODEV;
+
+	mcp = kzalloc(sizeof *mcp, GFP_KERNEL);
+	if (!mcp)
+		return -ENOMEM;
+
+	mutex_init(&mcp->lock);
+
+	mcp->spi = spi;
+	mcp->addr = 0x40 | (pdata->slave << 1);
+
+	mcp->chip.label = "mcp23s08",
+
+	mcp->chip.direction_input = mcp23s08_direction_input;
+	mcp->chip.get = mcp23s08_get;
+	mcp->chip.direction_output = mcp23s08_direction_output;
+	mcp->chip.set = mcp23s08_set;
+	mcp->chip.dbg_show = mcp23s08_dbg_show;
+
+	mcp->chip.base = pdata->base;
+	mcp->chip.ngpio = 8;
+	mcp->chip.can_sleep = 1;
+
+	spi_set_drvdata(spi, mcp);
+
+	/* verify MCP_IOCON.SEQOP = 0, so sequential reads work */
+	status = mcp23s08_read(mcp, MCP_IOCON);
+	if (status < 0)
+		goto fail;
+	if (status & IOCON_SEQOP) {
+		status &= ~IOCON_SEQOP;
+		status = mcp23s08_write(mcp, MCP_IOCON, (u8) status);
+		if (status < 0)
+			goto fail;
+	}
+
+	/* configure ~100K pullups */
+	status = mcp23s08_write(mcp, MCP_GPPU, pdata->pullups);
+	if (status < 0)
+		goto fail;
+
+	status = mcp23s08_read_regs(mcp, 0, mcp->cache, sizeof mcp->cache);
+	if (status < 0)
+		goto fail;
+
+	/* disable inverter on input */
+	if (mcp->cache[MCP_IPOL] != 0) {
+		mcp->cache[MCP_IPOL] = 0;
+		do_update = 1;
+	}
+
+	/* disable irqs */
+	if (mcp->cache[MCP_GPINTEN] != 0) {
+		mcp->cache[MCP_GPINTEN] = 0;
+		do_update = 1;
+	}
+
+	if (do_update) {
+		u8 tx[4];
+
+		tx[0] = mcp->addr;
+		tx[1] = MCP_IPOL;
+		memcpy(&tx[2], &mcp->cache[MCP_IPOL], sizeof(tx) - 2);
+		status = spi_write_then_read(mcp->spi, tx, sizeof tx, NULL, 0);
+
+		// FIXME check status...
+	}
+
+	status = gpiochip_add(&mcp->chip);
+
+	/* NOTE:  these chips have a relatively sane IRQ framework, with
+	 * per-signal masking and level/edge triggering.  It's not yet
+	 * handled here...
+	 */
+
+	if (pdata->setup) {
+		status = pdata->setup(spi, mcp->chip.base,
+				mcp->chip.ngpio, pdata->context);
+		if (status < 0)
+			dev_dbg(&spi->dev, "setup --> %d\n", status);
+	}
+
+	return 0;
+
+fail:
+	kfree(mcp);
+	return status;
+}
+
+static int mcp23s08_remove(struct spi_device *spi)
+{
+	struct mcp23s08			*mcp = spi_get_drvdata(spi);
+	struct mcp23s08_platform_data	*pdata = spi->dev.platform_data;
+	int				status = 0;
+
+	if (pdata->teardown) {
+		status = pdata->teardown(spi,
+				mcp->chip.base, mcp->chip.ngpio,
+				pdata->context);
+		if (status < 0) {
+			dev_err(&spi->dev, "%s --> %d\n", "teardown", status);
+			return status;
+		}
+	}
+
+	status = gpiochip_remove(&mcp->chip);
+	if (status == 0)
+		kfree(mcp);
+	else
+		dev_err(&spi->dev, "%s --> %d\n", "remove", status);
+	return status;
+}
+
+static struct spi_driver mcp23s08_driver = {
+	.probe		= mcp23s08_probe,
+	.remove		= mcp23s08_remove,
+	.driver = {
+		.name	= "mcp23s08",
+		.owner	= THIS_MODULE,
+	},
+};
+
+/*----------------------------------------------------------------------*/
+
+static int __init mcp23s08_init(void)
+{
+	return spi_register_driver(&mcp23s08_driver);
+}
+/* we want GPIOs to be ready at device_initcall() time when possible */
+subsys_initcall(mcp23s08_init);
+
+static void __exit mcp23s08_exit(void)
+{
+	spi_unregister_driver(&mcp23s08_driver);
+}
+module_exit(mcp23s08_exit);
+
+MODULE_LICENSE("GPL");
diff -puN /dev/null include/linux/spi/mcp23s08.h
--- /dev/null
+++ a/include/linux/spi/mcp23s08.h
@@ -0,0 +1,24 @@
+
+/* FIXME driver should be able to handle all four slaves that
+ * can be hooked up to each chipselect, as well as IRQs...
+ */
+
+struct mcp23s08_platform_data {
+	/* four slaves can share one SPI chipselect */
+	u8		slave;
+
+	/* number assigned to the first GPIO */
+	unsigned	base;
+
+	/* pins with pullups */
+	u8		pullups;
+
+	void		*context;	/* param to setup/teardown */
+
+	int		(*setup)(struct spi_device *spi,
+					int gpio, unsigned ngpio,
+					void *context);
+	int		(*teardown)(struct spi_device *spi,
+					int gpio, unsigned ngpio,
+					void *context);
+};
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
mcp23s08-spi-gpio-expander.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
arm-pxa-gpiolib-support-make-pxa_gpio_chip-static.patch
