From: akpm@linux-foundation.org
Subject: - drivers-pmc-msp71xx-gpio-char-driver.patch removed from -mm tree
Date: Tue, 05 Feb 2008 23:10:07 -0800
Message-ID: <200802060709.m1679mt6031077@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54700 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756068AbYBFHKE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 02:10:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stjeanma@pmc-sierra.com, Brian_Oostenbrink@pmc-sierra.com, Dan_Doucette@pmc-sierra.com, Marc_St-Jean@pmc-sierra.com, david-b@pacbell.net, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     drivers: PMC MSP71xx GPIO char driver
has been removed from the -mm tree.  Its filename was
     drivers-pmc-msp71xx-gpio-char-driver.patch

This patch was dropped because it seems to be stuck

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers: PMC MSP71xx GPIO char driver
From: Marc St-Jean <stjeanma@pmc-sierra.com>

Add a GPIO char driver for the PMC-Sierra MSP71xx devices.

Signed-off-by: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>
Cc: <Brian_Oostenbrink@pmc-sierra.com>
Cc: <Dan_Doucette@pmc-sierra.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David Brownell <david-b@pacbell.net>

david-b said:

 - Doesn't even vaguely resemble Documentation/gpio.txt

 - The "blinking" stuff seems to imply LEDs, not GPIOs,
   and would be superfluous given the gpio.txt interface
   combined with the gpio-leds stuff (ready since February
   but it missed the 2.6.22 merge window; in MM)

 - I'm not sure what to make of that usermode interface,
   but it looks like it lets userspace trash any config
   done by kernel drivers.

 - There seems to be some coupling of pin mux setup with
   the gpio config too, which of course is a nonportable
   notion.

 - This is a boatload of code for what -- 20 pins?

On Mon, 1 Oct 2007 15:41:34 -0700 
Brian Oostenbrink <Brian_Oostenbrink@pmc-sierra.com> wrote:

> Marc St. Jean has left PMC, and so far noone has been available to finish up this work.  Not sure when we'll get around to it...

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/Kconfig                           |    4 
 drivers/char/Makefile                          |    1 
 drivers/char/pmcmsp_gpio.c                     |  649 +++++++++++++++
 include/asm-mips/pmc-sierra/msp71xx/msp_gpio.h |  253 +++++
 4 files changed, 907 insertions(+)

diff -puN drivers/char/Kconfig~drivers-pmc-msp71xx-gpio-char-driver drivers/char/Kconfig
--- a/drivers/char/Kconfig~drivers-pmc-msp71xx-gpio-char-driver
+++ a/drivers/char/Kconfig
@@ -383,6 +383,10 @@ config NOZOMI
 	  To compile this driver as a module, choose M here, the module
 	  will be called nozomi.
 
+config PMCMSP_GPIO
+	tristate "PMC MSP 7120 GPIO device support"
+	depends on MIPS && (PMC_MSP7120_EVAL || PMC_MSP7120_GW || PMC_MSP7120_FPGA)
+
 config A2232
 	tristate "Commodore A2232 serial support (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && ZORRO && BROKEN_ON_SMP
diff -puN drivers/char/Makefile~drivers-pmc-msp71xx-gpio-char-driver drivers/char/Makefile
--- a/drivers/char/Makefile~drivers-pmc-msp71xx-gpio-char-driver
+++ a/drivers/char/Makefile
@@ -87,6 +87,7 @@ obj-$(CONFIG_I8K)		+= i8k.o
 obj-$(CONFIG_DS1620)		+= ds1620.o
 obj-$(CONFIG_HW_RANDOM)		+= hw_random/
 obj-$(CONFIG_COBALT_LCD)	+= lcd.o
+obj-$(CONFIG_PMCMSP_GPIO)	+= pmcmsp_gpio.o
 obj-$(CONFIG_PPDEV)		+= ppdev.o
 obj-$(CONFIG_NWBUTTON)		+= nwbutton.o
 obj-$(CONFIG_NWFLASH)		+= nwflash.o
diff -puN /dev/null drivers/char/pmcmsp_gpio.c
--- /dev/null
+++ a/drivers/char/pmcmsp_gpio.c
@@ -0,0 +1,649 @@
+/*
+ * Driver for the PMC MSP71xx reference board GPIO pins
+ *
+ * Copyright 2005-2007 PMC-Sierra, Inc.
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
+ *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
+ *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
+ *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
+ *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
+ *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
+ *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *  You should have received a copy of the  GNU General Public License along
+ *  with this program; if not, write  to the Free Software Foundation, Inc.,
+ *  675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/ioport.h>
+#include <linux/spinlock.h>
+#include <linux/miscdevice.h>
+#include <linux/fs.h>
+#include <linux/kthread.h>
+#include <linux/sched.h>
+#include <linux/completion.h>
+#include <linux/freezer.h>
+#include <linux/io.h>
+
+#include <asm/war.h>
+
+#include <msp_regs.h>
+#include <msp_regops.h>
+#include <msp_gpio.h>
+
+/* -- Private definitions -- */
+
+/* Special bitflags and whatnot for the driver's convenience */
+#define GPIO_REG_COUNT		4
+#define GPIO_CFG_SHIFT(i)	(i * 4)
+#define GPIO_CFG_PINMASK	0xf
+
+static const u32 gpio_data_count[] = { 2, 4, 4, 6 };
+static const u32 gpio_data_shift[] = { 0, 2, 6, 10 };
+static const u32 gpio_data_mask[] = { 0x03, 0x0f, 0x0f, 0x3f };
+static u32 *const gpio_data_reg[] = {
+	(u32 *)GPIO_DATA1_REG, (u32 *)GPIO_DATA2_REG,
+	(u32 *)GPIO_DATA3_REG, (u32 *)GPIO_DATA4_REG,
+};
+static const u32 gpio_cfg_mask[] = { 0x0000ff, 0x00ffff, 0x00ffff, 0xffffff };
+static u32 *const gpio_cfg_reg[] = {
+	(u32 *)GPIO_CFG1_REG, (u32 *)GPIO_CFG2_REG,
+	(u32 *)GPIO_CFG3_REG, (u32 *)GPIO_CFG4_REG,
+};
+
+/* Maps MODE to allowed pin mask */
+static const u32 gpio_mode_allowed[] = {
+	0xfffff,	/* Mode 0 - INPUT */
+	0x00000,	/* Mode 1 - INTERRUPT */
+	0x00030,	/* Mode 2 - UART_INPUT (GPIO 4, 5)*/
+	0, 0, 0, 0, 0,	/* Modes 3, 4, 5, 6, and 7 are reserved */
+	0xfffff,	/* Mode 8 - OUTPUT */
+	0x0000f,	/* Mode 9 - UART_OUTPUT/PERF_TIMERA (GPIO 0,1,2,3) */
+	0x00003,	/* Mode a - PERF_TIMERB (GPIO 0, 1) */
+	0x00000,	/* Mode b - Not really a mode! */
+};
+
+/* The extended gpio register */
+
+#define EXTENDED_GPIO_COUNT	4
+#define EXTENDED_GPIO_SHIFT	16
+#define EXTENDED_GPIO_MASK	0x0f
+
+#define EXTENDED_GPIO_DATA_SHIFT(i)	(i * 2)
+#define EXTENDED_GPIO_DATA_MASK(i)	(0x3 << (i*2))
+#define EXTENDED_GPIO_DATA_SET		0x2
+#define EXTENDED_GPIO_DATA_CLR		0x1
+#define EXTENDED_GPIO_CFG_SHIFT(i)	((i * 2) + 16)
+#define EXTENDED_GPIO_CFG_MASK(i)	(0x3 << ((i*2)+16))
+#define EXTENDED_GPIO_CFG_DISABLE	0x2
+#define EXTENDED_GPIO_CFG_ENABLE	0x1
+
+/* -- Data structures -- */
+
+static DEFINE_SPINLOCK(msp_gpio_spinlock);
+
+static struct task_struct *msp_blinkthread;
+static DEFINE_SPINLOCK(msp_blink_lock);
+static DECLARE_COMPLETION(msp_blink_wait);
+
+struct blink_table {
+	u32 count;
+	u32 period;
+	u32 dcycle;
+};
+
+static struct blink_table blink_table[MSP_NUM_GPIOS];
+
+/* -- Utility functions -- */
+
+/* Reads the data bits from a single register set */
+static u32 msp_gpio_read_data_basic(int reg)
+{
+	return read_reg32(gpio_data_reg[reg], gpio_data_mask[reg]);
+}
+
+/* Reads the data bits from the extended register set */
+static u32 msp_gpio_read_data_extended(void)
+{
+	int pin;
+	u32 reg = *EXTENDED_GPIO_REG;
+	u32 retval = 0;
+
+	for (pin = 0; pin < EXTENDED_GPIO_COUNT; pin++) {
+		u32 bit = 0;
+
+		/*
+		 * In output mode, read CLR bit
+		 * In input mode, read SET bit
+		 */
+		if (reg & (EXTENDED_GPIO_CFG_ENABLE <<
+				EXTENDED_GPIO_CFG_SHIFT(pin)))
+			bit = EXTENDED_GPIO_DATA_CLR <<
+				EXTENDED_GPIO_DATA_SHIFT(pin);
+		else
+			bit = EXTENDED_GPIO_DATA_SET <<
+				EXTENDED_GPIO_DATA_SHIFT(pin);
+
+		if (reg & bit)
+			retval |= 1 << pin;
+	}
+
+	return retval;
+}
+
+/*
+ * Reads the current state of all 20 pins, putting the values in
+ * the lowest 20 bits (1=HI, 0=LO)
+ */
+static u32 msp_gpio_read_data(void)
+{
+	int reg;
+	u32 retval = 0;
+
+	spin_lock(&msp_gpio_spinlock);
+	for (reg = 0; reg < GPIO_REG_COUNT; reg++)
+		retval |= msp_gpio_read_data_basic(reg) <<
+				gpio_data_shift[reg];
+	retval |= msp_gpio_read_data_extended() << EXTENDED_GPIO_SHIFT;
+	spin_unlock(&msp_gpio_spinlock);
+
+	pr_debug("%s: 0x%08x\n", __FUNCTION__, retval);
+
+	return retval;
+}
+
+/*
+ * This assumes both data and mask are register-ready, and does
+ * the set atomically
+ */
+static void msp_gpio_write_data_basic(int reg, u32 data, u32 mask)
+{
+	set_value_reg32(gpio_data_reg[reg], mask, data);
+}
+
+/*
+ * The four lowest bits of 'data' and 'mask' are used, and the set
+ * is done atomically
+ */
+static void msp_gpio_write_data_extended(u32 data, u32 mask)
+{
+	int i;
+	u32 tmpmask = 0xffffffff, tmpdata = 0;
+
+	/* Set all SET/CLR values based on data bits passed in */
+	for (i = 0; i < EXTENDED_GPIO_COUNT; i++) {
+		if (mask & (1 << i)) {
+			if (data & (1 << i))
+				/* Set the bit HI */
+				tmpdata |= EXTENDED_GPIO_DATA_SET <<
+					   EXTENDED_GPIO_DATA_SHIFT(i);
+			else
+				/* Set the bit LO */
+				tmpdata |= EXTENDED_GPIO_DATA_CLR <<
+					   EXTENDED_GPIO_DATA_SHIFT(i);
+		}
+	}
+
+	set_value_reg32(EXTENDED_GPIO_REG, tmpmask, tmpdata);
+}
+
+/*
+ * Sets all masked GPIOs based on the first 20 bits of the data
+ * passed in (1=HI, 0=LO)
+ */
+static void msp_gpio_write_data(u32 data, u32 mask)
+{
+	int reg;
+
+	spin_lock(&msp_gpio_spinlock);
+	for (reg = 0; reg < GPIO_REG_COUNT; reg++) {
+		u32 tmpdata = (data >> gpio_data_shift[reg]) &
+					gpio_data_mask[reg];
+		u32 tmpmask = (mask >> gpio_data_shift[reg]) &
+					gpio_data_mask[reg];
+		if (tmpmask > 0)
+			msp_gpio_write_data_basic(reg, tmpdata, tmpmask);
+	}
+	msp_gpio_write_data_extended(data >> EXTENDED_GPIO_SHIFT,
+					mask >> EXTENDED_GPIO_SHIFT);
+	spin_unlock(&msp_gpio_spinlock);
+}
+
+/* Reads the config bits from a single register set */
+static u32 msp_gpio_read_cfg_basic(int reg)
+{
+	return read_reg32(gpio_cfg_reg[reg], gpio_cfg_mask[reg]);
+}
+
+/*
+ * This assumes both data and mask are register-ready, and does
+ * the write atomically
+ */
+static void msp_gpio_write_cfg_basic(int reg, u32 data, u32 mask)
+{
+	set_value_reg32(gpio_cfg_reg[reg], mask, data);
+}
+
+/*
+ * Reads the configuration of the extended pins, returning the current
+ * configuration in the lowest 4 bits (1-output, 0-input)
+ */
+static u32 msp_gpio_read_cfg_extended(void)
+{
+	int i;
+	u32 reg = *EXTENDED_GPIO_REG;
+	u32 retval = 0;
+
+	/* Read all ENABLE/DISABLE values and translate to single bits */
+	for (i = 0; i < EXTENDED_GPIO_COUNT; i++) {
+		if (reg & (EXTENDED_GPIO_CFG_ENABLE <<
+				EXTENDED_GPIO_CFG_SHIFT(i)))
+			/* Pin is OUTPUT */
+			retval |= 1 << i;
+		else
+			/* Pin is INPUT */
+			retval &= ~(1 << i);
+	}
+
+	return retval;
+}
+
+/*
+ * Sets the masked extended pins to (1-output, 0-input)
+ * (uses 4 lowest bits of the mask)
+ * Does the write atomically
+ */
+static void msp_gpio_write_cfg_extended(u32 data, u32 mask)
+{
+	int i;
+	u32 tmpmask = 0xffffffff, tmpdata = 0;
+
+	/* Set all ENABLE/DISABLE values based on mask bits passed in */
+	for (i = 0; i < EXTENDED_GPIO_COUNT; i++) {
+		if (mask & (1 << i)) {
+			if (data & (1 << i))
+				/* Set the pin to OUTPUT */
+				tmpdata |= EXTENDED_GPIO_CFG_ENABLE <<
+					   EXTENDED_GPIO_CFG_SHIFT(i);
+			else
+				/* Set the pin to INPUT */
+				tmpdata |= EXTENDED_GPIO_CFG_DISABLE <<
+					   EXTENDED_GPIO_CFG_SHIFT(i);
+		}
+	}
+
+	set_value_reg32(EXTENDED_GPIO_REG, tmpmask, tmpdata);
+}
+
+/*
+ * Sets all GPIOs to input/output based on the first 20 bits of the mask
+ * (1-output, 0-input)
+ */
+static void msp_gpio_write_cfg(enum msp_gpio_mode mode, u32 mask)
+{
+	int reg;
+	u32 extdata = 0, extmask = 0;
+
+	spin_lock(&msp_gpio_spinlock);
+	for (reg = 0; reg < GPIO_REG_COUNT; reg++) {
+		int pin;
+		u32 tmpdata = 0, tmpmask = 0;
+		for (pin = 0; pin < gpio_data_count[reg]; pin++) {
+			if (mask & (1 << (gpio_data_shift[reg] + pin))) {
+				tmpmask |= GPIO_CFG_PINMASK <<
+					   GPIO_CFG_SHIFT(pin);
+				tmpdata |= (u32)mode <<
+					   GPIO_CFG_SHIFT(pin);
+			}
+		}
+		if (tmpmask)
+			msp_gpio_write_cfg_basic(reg, tmpdata, tmpmask);
+	}
+
+	extmask = mask >> EXTENDED_GPIO_SHIFT;
+	if (mode == MSP_GPIO_INPUT)
+		extdata = 0;
+	else if (mode == MSP_GPIO_OUTPUT)
+		extdata = 0xf;
+	else
+		extmask = 0;
+	if (extmask)
+		msp_gpio_write_cfg_extended(extdata, extmask);
+	spin_unlock(&msp_gpio_spinlock);
+}
+
+/*
+ * Reads all GPIO config values and checks if they match the pin mode given,
+ * placing the result in the lowest 20 bits of the result, one bit per pin
+ * (1-pin matches mode give, 0-pin does not match)
+ */
+static u32 msp_gpio_read_cfg(u32 mode)
+{
+	u32 retval = 0;
+	int reg;
+
+	spin_lock(&msp_gpio_spinlock);
+	for (reg = 0; reg < GPIO_REG_COUNT; reg++) {
+		int pin;
+		u32 tmpdata = msp_gpio_read_cfg_basic(reg);
+		for (pin = 0; pin < gpio_data_count[reg]; pin++) {
+			u32 val = (tmpdata >> GPIO_CFG_SHIFT(pin)) &
+					GPIO_CFG_PINMASK;
+			if (val == mode)
+				retval |= 1 << (gpio_data_shift[reg] + pin);
+		}
+	}
+
+	/* Extended pins only have INPUT or OUTPUT pins */
+	if (mode == MSP_GPIO_INPUT)
+		retval |= (~msp_gpio_read_cfg_extended() & EXTENDED_GPIO_MASK)
+			  << EXTENDED_GPIO_SHIFT;
+	else if (mode == MSP_GPIO_OUTPUT)
+		retval |= (msp_gpio_read_cfg_extended() & EXTENDED_GPIO_MASK)
+			  << EXTENDED_GPIO_SHIFT;
+	spin_unlock(&msp_gpio_spinlock);
+
+	pr_debug("%s(0x%02x): 0x%08x\n", __FUNCTION__, mode, retval);
+
+	return retval;
+}
+
+/* -- Public functions -- */
+
+/*
+ * Reads the bits specified by the mask and puts the values in data.
+ * May include output statuses also, if in mask.
+ *
+ * Returns 0 on success
+ */
+int msp_gpio_in(u32 *data, u32 mask)
+{
+	*data = msp_gpio_read_data() & mask;
+
+	return 0;
+}
+EXPORT_SYMBOL(msp_gpio_in);
+
+/*
+ * Sets the specified data on the masked pins
+ *
+ * Returns 0 on success or one of the following:
+ *  -EINVAL if any of the pins in the mask are not free or not already
+ *  in output mode
+ */
+int msp_gpio_out(u32 data, u32 mask)
+{
+	if ((mask & ~MSP_GPIO_FREE_MASK) != 0) {
+		printk(KERN_WARNING
+			"Invalid GPIO mask - References non-free pins\n");
+		return -EINVAL;
+	}
+	if ((mask & ~msp_gpio_read_cfg(MSP_GPIO_OUTPUT)) != 0) {
+		printk(KERN_WARNING
+			"Invalid GPIO mask - Cannot set non-output pins\n");
+		return -EINVAL;
+	}
+
+	msp_gpio_noblink(mask);
+	msp_gpio_write_data(data, mask);
+
+	return 0;
+}
+EXPORT_SYMBOL(msp_gpio_out);
+
+/*
+ * Sets masked pins to the specified msp_gpio_mode
+ *
+ * Returns 0 on success or one of the following:
+ *  -EINVAL if any of the pins in the mask are not free or if any pins
+ *  are not allowed to be set to the specified mode
+ */
+int msp_gpio_mode(enum msp_gpio_mode mode, u32 mask)
+{
+	u32 allowedmask;
+
+	if ((mask & ~MSP_GPIO_FREE_MASK) != 0) {
+		printk(KERN_WARNING
+			"Invalid GPIO mask - References non-free pins\n");
+		return -EINVAL;
+	}
+
+	/* Enforce pin-mode rules */
+	allowedmask = gpio_mode_allowed[mode];
+	if ((mask & ~allowedmask) != 0) {
+		printk(KERN_WARNING
+			"Invalid GPIO mode for masked pins\n");
+		return -EINVAL;
+	}
+
+	msp_gpio_noblink(mask);
+	msp_gpio_write_cfg(mode, mask);
+
+	return 0;
+}
+EXPORT_SYMBOL(msp_gpio_mode);
+
+/*
+ * Stops the specified GPIOs from blinking
+ */
+int msp_gpio_noblink(u32 mask)
+{
+	int i;
+
+	if ((mask & ~msp_gpio_read_cfg(MSP_GPIO_OUTPUT)) != 0)
+		return -EINVAL;
+
+	spin_lock(&msp_blink_lock);
+	for (i = 0; i < MSP_NUM_GPIOS; i++) {
+		if (mask & (1 << i)) {
+			blink_table[i].count = 0;
+			blink_table[i].period = 0;
+			blink_table[i].dcycle = 0;
+		}
+	}
+	spin_unlock(&msp_blink_lock);
+
+	msp_gpio_write_data(0, mask);
+
+	return 0;
+}
+EXPORT_SYMBOL(msp_gpio_noblink);
+
+/*
+ * Configures GPIO(s) to blink
+ *  - mask shows which GPIOs to blink
+ *  - period is the time in 100ths of a second for the total period
+ *    (0 disables blinking)
+ *  - dcycle is the percentage of the period where the GPIO is HI
+ */
+int msp_gpio_blink(u32 mask, u32 period, u32 dcycle)
+{
+	int i;
+
+	if ((mask & ~msp_gpio_read_cfg(MSP_GPIO_OUTPUT)) != 0) {
+		printk(KERN_WARNING
+			"Invalid GPIO mask - Cannot blink non-output pins\n");
+		return -EINVAL;
+	}
+
+	if (period == 0)
+		return msp_gpio_noblink(mask);
+
+	spin_lock(&msp_blink_lock);
+	for (i = 0; i < MSP_NUM_GPIOS; i++) {
+		if (mask & (1 << i)) {
+			blink_table[i].count = 0;
+			blink_table[i].period = period;
+			blink_table[i].dcycle = dcycle;
+		}
+	}
+	spin_unlock(&msp_blink_lock);
+
+	complete(&msp_blink_wait);
+
+	return 0;
+}
+EXPORT_SYMBOL(msp_gpio_blink);
+
+/* -- File functions -- */
+
+static int msp_gpio_open(struct inode *inode, struct file *file)
+{
+	return 0;
+}
+
+static int msp_gpio_release(struct inode *inode, struct file *file)
+{
+	return 0;
+}
+
+static int msp_gpio_ioctl(struct inode *inode, struct file *file,
+			  unsigned int cmd, unsigned long arg)
+{
+	static struct msp_gpio_ioctl_io_data data;
+	static struct msp_gpio_ioctl_blink_data blink;
+
+	switch (cmd) {
+	case MSP_GPIO_BLINK:
+		if (copy_from_user(&blink,
+		    (struct msp_gpio_ioctl_blink_data *)arg, sizeof(blink)))
+			return -EFAULT;
+		break;
+	default:
+		if (copy_from_user(&data,
+		    (struct msp_gpio_ioctl_io_data *)arg, sizeof(data)))
+			return -EFAULT;
+		break;
+	}
+
+	switch (cmd) {
+	case MSP_GPIO_IN:
+		if (msp_gpio_in(&data.data, data.mask))
+			return -EFAULT;
+		if (copy_to_user((struct msp_gpio_ioctl_io_data *)arg,
+		    &data, sizeof(data)))
+			return -EFAULT;
+		break;
+	case MSP_GPIO_OUT:
+		if (msp_gpio_out(data.data, data.mask))
+			return -EFAULT;
+		break;
+	case MSP_GPIO_MODE:
+		if (msp_gpio_mode(data.data, data.mask))
+			return -EFAULT;
+		break;
+	case MSP_GPIO_BLINK:
+		if (msp_gpio_blink(blink.mask, blink.period, blink.dcycle))
+			return -EFAULT;
+		break;
+	default:
+		return -ENOIOCTLCMD;
+	}
+
+	return 0;
+}
+
+static struct file_operations msp_gpio_fops = {
+	.owner		= THIS_MODULE,
+	.ioctl		= msp_gpio_ioctl,
+	.open		= msp_gpio_open,
+	.release	= msp_gpio_release,
+};
+
+static struct miscdevice msp_gpio_miscdev = {
+	MISC_DYNAMIC_MINOR,
+	"pmcmsp_gpio",
+	&msp_gpio_fops
+};
+
+static int msp_gpio_blinkthread(void *none)
+{
+	int firstrun = 1;
+
+	do {
+		u32 mask = 0, data = 0;
+		int i, blinking = 0;
+		spin_lock(&msp_blink_lock);
+		for (i = 0; i < MSP_NUM_GPIOS; i++) {
+			/* use blink_table[i].period as 'blink enabled' test */
+			if (blink_table[i].period) {
+				blinking = 1;
+				mask |= 1 << i;
+				blink_table[i].count++;
+
+				if (blink_table[i].count >=
+				    blink_table[i].period)
+					blink_table[i].count = 0;
+
+				if (blink_table[i].count <
+				    (blink_table[i].period *
+				    blink_table[i].dcycle / 100))
+					data |= 1 << i;
+			}
+		}
+		spin_unlock(&msp_blink_lock);
+
+		if (!firstrun || blinking)
+			msp_gpio_write_data(data, mask);
+		else
+			firstrun = 0;
+
+		if (blinking)
+			schedule_timeout_interruptible(HZ/100);
+		else
+			wait_for_completion_interruptible(&msp_blink_wait);
+
+		/* make swsusp happy with our thread */
+		try_to_freeze();
+	} while (!kthread_should_stop());
+
+	return 0;
+}
+
+/* -- Module functions -- */
+
+static int __init msp_gpio_init(void)
+{
+	if (misc_register(&msp_gpio_miscdev)) {
+		printk(KERN_ERR "Device registration failed\n");
+		goto err_miscdev;
+	}
+
+	msp_blinkthread = kthread_run(msp_gpio_blinkthread, NULL, "gpio_blink");
+	if (msp_blinkthread == NULL) {
+		printk(KERN_ERR "Could not start kthread\n");
+		goto err_blinkthread;
+	}
+
+	printk(KERN_WARNING "MSP7120 GPIO subsystem initialized\n");
+	return 0;
+
+err_blinkthread:
+	misc_deregister(&msp_gpio_miscdev);
+err_miscdev:
+	return -ENOMEM;
+}
+
+static void __exit msp_gpio_exit(void)
+{
+	complete(&msp_blink_wait);
+	kthread_stop(msp_blinkthread);
+
+	misc_deregister(&msp_gpio_miscdev);
+}
+
+MODULE_DESCRIPTION("PMC MSP GPIO driver");
+MODULE_LICENSE("GPL");
+
+module_init(msp_gpio_init);
+module_exit(msp_gpio_exit);
diff -puN /dev/null include/asm-mips/pmc-sierra/msp71xx/msp_gpio.h
--- /dev/null
+++ a/include/asm-mips/pmc-sierra/msp71xx/msp_gpio.h
@@ -0,0 +1,253 @@
+/*
+ * Driver for the PMC MSP71xx reference board GPIO pins
+ *
+ * Copyright 2005-2007 PMC-Sierra, Inc.
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
+ *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
+ *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
+ *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
+ *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
+ *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
+ *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *  You should have received a copy of the  GNU General Public License along
+ *  with this program; if not, write  to the Free Software Foundation, Inc.,
+ *  675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef __MSP_GPIO_H__
+#define __MSP_GPIO_H__
+
+#ifdef __KERNEL__
+#include <linux/ioctl.h>
+#endif
+
+/* Bit flags and masks for GPIOs */
+#define MSP_NUM_GPIOS		20
+#define MSP_GPIO_ALL_MASK 	((1 << MSP_NUM_GPIOS) - 1)
+#define MSP_GPIO_NONE_MASK 	0LL
+#define MSP_GPIO_FREE_MASK	MSP_GPIO_ALL_MASK
+
+/* GPIO modes */
+enum msp_gpio_mode {
+	MSP_GPIO_INPUT		= 0x0,
+	/* MSP_GPIO_ INTERRUPT	= 0x1,	Not supported yet */
+	MSP_GPIO_UART_INPUT	= 0x2,	/* Only GPIO 4 or 5 */
+	MSP_GPIO_OUTPUT		= 0x8,
+	MSP_GPIO_UART_OUTPUT	= 0x9,	/* Only GPIO 2 or 3 */
+	MSP_GPIO_PERIF_TIMERA	= 0x9,	/* Only GPIO 0 or 1 */
+	MSP_GPIO_PERIF_TIMERB	= 0xa,	/* Only GPIO 0 or 1 */
+	MSP_GPIO_UNKNOWN	= 0xb,  /* No such GPIO or mode */
+};
+
+/*
+ * Inline functions available even when GPIO driver is disabled
+ */
+
+/* This gives you the 'register relative offset gpio' numbers */
+inline static u32
+basic_offset_gpio(u32 gpio)
+{
+	/* GPIO 0 and 1 on the first register */
+	if (gpio < 2)
+		return gpio;
+	/* GPIO 2, 3, 4, and 5 on the second register */
+	else if (gpio < 6)
+		return gpio - 2;
+	/* GPIO 6, 7, 8, and 9 on the third register */
+	else if (gpio < 10)
+		return gpio - 6;
+	/* GPIO 10, 11, 12, 13, 14, and 15 on the fourth register */
+	else
+		return gpio - 10;
+}
+
+/* These take the 'register relative offset gpio' number */
+inline static u32
+basic_data_reg_mask(u32 ogpio)
+{
+	return 1 << ogpio;
+}
+
+inline static u32
+basic_mode_reg_shift(u32 ogpio)
+{
+	return ogpio * 4;
+}
+
+inline static u32
+basic_mode_reg_value(enum msp_gpio_mode mode, u32 ogpio)
+{
+	return mode << basic_mode_reg_shift(ogpio);
+}
+
+inline static u32
+basic_mode_reg_mask(u32 ogpio)
+{
+	return basic_mode_reg_value(0xf, ogpio);
+}
+
+inline static u32
+basic_mode_reg_from_reg(u32 data, u32 ogpio)
+{
+	return (data & basic_mode_reg_mask(ogpio)) >>
+			basic_mode_reg_shift(ogpio);
+}
+
+/* These take the actual GPIO number (0 through 15) */
+inline static u32
+basic_data_mask(u32 gpio)
+{
+	return basic_data_reg_mask(basic_offset_gpio(gpio));
+}
+
+inline static u32
+basic_mode_mask(u32 gpio)
+{
+	return basic_mode_reg_mask(basic_offset_gpio(gpio));
+}
+
+inline static u32
+basic_mode(enum msp_gpio_mode mode, u32 gpio)
+{
+	return basic_mode_reg_value(mode, basic_offset_gpio(gpio));
+}
+
+inline static u32
+basic_mode_shift(u32 gpio)
+{
+	return basic_mode_reg_shift(basic_offset_gpio(gpio));
+}
+
+inline static u32
+basic_mode_from_reg(u32 data, u32 gpio)
+{
+	return basic_mode_reg_from_reg(data, basic_offset_gpio(gpio));
+}
+
+/* This gives you the extended 'register relative offset gpio' number */
+inline static u32
+extended_offset_gpio(u32 gpio)
+{
+	return gpio - 16;
+}
+
+/* These take the 'register relative offset gpio' number */
+inline static u32
+extended_reg_disable(u32 ogpio)
+{
+	return 0x2 << ((ogpio * 2) + 16);
+}
+
+inline static u32
+extended_reg_enable(u32 ogpio)
+{
+	return 0x1 << ((ogpio * 2) + 16);
+}
+
+inline static u32
+extended_reg_set(u32 ogpio)
+{
+	return 0x2 << (ogpio * 2);
+}
+
+inline static u32
+extended_reg_clr(u32 ogpio)
+{
+	return 0x1 << (ogpio * 2);
+}
+
+/* These take the actual GPIO number (16 through 19) */
+inline static u32
+extended_disable(u32 gpio)
+{
+	return extended_reg_disable(extended_offset_gpio(gpio));
+}
+
+inline static u32
+extended_enable(u32 gpio)
+{
+	return extended_reg_enable(extended_offset_gpio(gpio));
+}
+
+inline static u32
+extended_set(u32 gpio)
+{
+	return extended_reg_set(extended_offset_gpio(gpio));
+}
+
+inline static u32
+extended_clr(u32 gpio)
+{
+	return extended_reg_clr(extended_offset_gpio(gpio));
+}
+
+#ifdef __KERNEL__
+/*
+ * IOCTL structs and macros
+ */
+struct msp_gpio_ioctl_io_data {
+	u32 data;
+	u32 mask;
+};
+
+struct msp_gpio_ioctl_blink_data {
+	u32 mask;
+	u32 period;
+	u32 dcycle;
+};
+
+#define MSP_GPIO_IOCTL_BASE	'Z'
+
+/* Reads the current data bits */
+#define MSP_GPIO_IN	_IOWR(MSP_GPIO_IOCTL_BASE, 0, \
+			      struct msp_gpio_ioctl_io_data)
+
+/* Writes data bits */
+#define MSP_GPIO_OUT	_IOW(MSP_GPIO_IOCTL_BASE, 1, \
+			      struct msp_gpio_ioctl_io_data)
+
+/* Sets all masked pins to the msp_gpio_mode given in the data field */
+#define MSP_GPIO_MODE	_IOW(MSP_GPIO_IOCTL_BASE, 2, \
+			      struct msp_gpio_ioctl_io_data)
+
+/*
+ * Starts any masked LEDs blinking with parameters as follows:
+ *   - period - The time in 100ths of a second for a single period
+ *              (set to '0' to stop blinking)
+ *   - dcycle - The 'duty cycle' - what percentage of the period should
+ *              the gpio be on?
+ */
+#define MSP_GPIO_BLINK	_IOW(MSP_GPIO_IOCTL_BASE, 3, \
+			      struct msp_gpio_ioctl_blink_data)
+
+/*
+ * Public driver functions available to other modules.
+ */
+
+/* Reads the bits specified by the mask and puts the values in data */
+extern int msp_gpio_in(u32 *data, u32 mask);
+
+/* Sets the specified data on the masked pins */
+extern int msp_gpio_out(u32 data, u32 mask);
+
+/* Sets masked pins to the specified msp_gpio_mode */
+extern int msp_gpio_mode(enum msp_gpio_mode mode, u32 mask);
+
+/* Stops the specified GPIOs from blinking */
+extern int msp_gpio_noblink(u32 mask);
+
+/* Configures GPIO(s) to blink */
+extern int msp_gpio_blink(u32 mask, u32 period, u32 dcycle);
+#endif /* __KERNEL__ */
+
+#endif /* !__MSP_GPIO_H__ */
_

Patches currently in -mm which might be from stjeanma@pmc-sierra.com are

drivers-pmc-msp71xx-gpio-char-driver.patch
