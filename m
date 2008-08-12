From: akpm@linux-foundation.org
Subject: - i2c-renesas-highlander-fpga-smbus-support.patch removed from -mm tree
Date: Tue, 12 Aug 2008 13:32:48 -0700
Message-ID: <200808122032.m7CKWmxZ011737@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40653 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751934AbYHLUhI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 16:37:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, khali@linux-fr.org, xyzzy@speakeasy.org, mm-commits@vger.kernel.org


The patch titled
     i2c: Renesas Highlander FPGA SMBus support
has been removed from the -mm tree.  Its filename was
     i2c-renesas-highlander-fpga-smbus-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: i2c: Renesas Highlander FPGA SMBus support
From: Paul Mundt <lethal@linux-sh.org>

This adds support for the SMBus adapter found in the various FPGAs on the
Renesas Highlander platforms.  Particularly the R0P7780LC0011RL and
R0P7785LC0011RL FPGAs.

Functionality is fairly restricted, in that only byte and block data transfers
are supported.  Normal/fast mode and IRQ/polling are also supported. 
Primarily used for various RTCs and thermal sensors.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Jean Delvare <khali@linux-fr.org>

On Thu, 15 May 2008 13:58:31 +0200 Jean Delvare <khali@linux-fr.org> wrote:
> I have reviewed this new driver on April 25th:
> http://lists.lm-sensors.org/pipermail/i2c/2008-April/003397.html
> Trent Piepho added some valuable comments too. I am now waiting for
> Paul to submit an updated patch, but it did not happen yet. Which is
> why this patch isn't in my i2c tree.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/Kconfig          |   12 
 drivers/i2c/busses/Makefile         |    1 
 drivers/i2c/busses/i2c-highlander.c |  500 ++++++++++++++++++++++++++
 3 files changed, 513 insertions(+)

diff -puN drivers/i2c/busses/Kconfig~i2c-renesas-highlander-fpga-smbus-support drivers/i2c/busses/Kconfig
--- a/drivers/i2c/busses/Kconfig~i2c-renesas-highlander-fpga-smbus-support
+++ a/drivers/i2c/busses/Kconfig
@@ -230,6 +230,18 @@ config I2C_VIAPRO
 comment "Mac SMBus host controller drivers"
 	depends on PPC_CHRP || PPC_PMAC
 
+config I2C_HIGHLANDER
+	tristate "Highlander FPGA SMBus interface"
+	depends on SH_HIGHLANDER
+	help
+	  If you say yes to this option, support will be included for
+	  the SMBus interface located in the FPGA on various Highlander
+	  boards, particularly the R0P7780LC0011RL and R0P7785LC0011RL
+	  FPGAs. This is wholly unrelated to the SoC I2C.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called i2c-highlander.
+
 config I2C_HYDRA
 	tristate "CHRP Apple Hydra Mac I/O I2C interface"
 	depends on PCI && PPC_CHRP && EXPERIMENTAL
diff -puN drivers/i2c/busses/Makefile~i2c-renesas-highlander-fpga-smbus-support drivers/i2c/busses/Makefile
--- a/drivers/i2c/busses/Makefile~i2c-renesas-highlander-fpga-smbus-support
+++ a/drivers/i2c/busses/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_I2C_BLACKFIN_TWI)	+= i2c-bf
 obj-$(CONFIG_I2C_CPM)		+= i2c-cpm.o
 obj-$(CONFIG_I2C_DAVINCI)	+= i2c-davinci.o
 obj-$(CONFIG_I2C_GPIO)		+= i2c-gpio.o
+obj-$(CONFIG_I2C_HIGHLANDER)	+= i2c-highlander.o
 obj-$(CONFIG_I2C_IBM_IIC)	+= i2c-ibm_iic.o
 obj-$(CONFIG_I2C_IOP3XX)	+= i2c-iop3xx.o
 obj-$(CONFIG_I2C_IXP2000)	+= i2c-ixp2000.o
diff -puN /dev/null drivers/i2c/busses/i2c-highlander.c
--- /dev/null
+++ a/drivers/i2c/busses/i2c-highlander.c
@@ -0,0 +1,500 @@
+/*
+ * Renesas Solutions Highlander FPGA I2C/SMBus support.
+ *
+ * Supported devices: R0P7780LC0011RL, R0P7785LC0011RL
+ *
+ * Copyright (C) 2008  Paul Mundt
+ * Copyright (C) 2008  Renesas Solutions Corp.
+ * Copyright (C) 2008  Atom Create Engineering Co., Ltd.
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License version 2. See the file "COPYING" in the main directory
+ * of this archive for more details.
+ */
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/i2c.h>
+#include <linux/platform_device.h>
+#include <linux/completion.h>
+#include <linux/io.h>
+#include <linux/delay.h>
+
+#define SMCR		0x00
+#define SMCR_START	(1 << 0)
+#define SMCR_IRIC	(1 << 1)
+#define SMCR_BBSY	(1 << 2)
+#define SMCR_ACKE	(1 << 3)
+#define SMCR_RST	(1 << 4)
+#define SMCR_IEIC	(1 << 6)
+
+#define SMSMADR		0x02
+
+#define SMMR		0x04
+#define SMMR_MODE0	(1 << 0)
+#define SMMR_MODE1	(1 << 1)
+#define SMMR_CAP	(1 << 3)
+#define SMMR_TMMD	(1 << 4)
+#define SMMR_SP		(1 << 7)
+
+#define SMSADR		0x06
+#define SMTRDR		0x46
+
+struct highlander_i2c_dev {
+	struct device		*dev;
+	void __iomem		*base;
+	struct i2c_adapter	adapter;
+	struct completion	cmd_complete;
+	int			irq;
+	u8			*buf;
+	size_t			buf_len;
+};
+
+static int iic_force_poll, iic_force_normal, iic_timeout = 1000;
+
+static inline void highlander_i2c_irq_enable(struct highlander_i2c_dev *dev)
+{
+	iowrite16(ioread16(dev->base + SMCR) | SMCR_IEIC, dev->base + SMCR);
+}
+
+static inline void highlander_i2c_irq_disable(struct highlander_i2c_dev *dev)
+{
+	iowrite16(ioread16(dev->base + SMCR) & ~SMCR_IEIC, dev->base + SMCR);
+}
+
+static inline void highlander_i2c_start(struct highlander_i2c_dev *dev)
+{
+	iowrite16(ioread16(dev->base + SMCR) | SMCR_START, dev->base + SMCR);
+}
+
+static inline void highlander_i2c_done(struct highlander_i2c_dev *dev)
+{
+	iowrite16(ioread16(dev->base + SMCR) | SMCR_IRIC, dev->base + SMCR);
+}
+
+static inline void highlander_i2c_setup(struct highlander_i2c_dev *dev)
+{
+	u16 smmr;
+
+	smmr = ioread16(dev->base + SMMR);
+	smmr |= SMMR_TMMD;
+
+	if (iic_force_normal)
+		smmr &= ~SMMR_SP;
+	else
+		smmr |= SMMR_SP;
+
+	iowrite16(smmr, dev->base + SMMR);
+}
+
+static void smbus_write_data(u8 *src, u16 *dst, int len)
+{
+	int i, j;
+
+	if (len == 1)
+		*dst = *src << 8;
+	else {
+		j = 0;
+		for (i = 0; i < len; i += 2) {
+			*(dst + j) = *(src + i) << 8 | *(src + i + 1);
+			j++;
+		}
+	}
+}
+
+static void smbus_read_data(u16 *src, u8 *dst, int len)
+{
+	int i, j;
+
+	if (len == 1)
+		*dst = *src >> 8;
+	else {
+		j = 0;
+		for (i = 0; i < len; i += 2) {
+			*(dst + i) = *(src + j) >> 8;
+			*(dst + i + 1) = *(src + j) & 0x00ff;
+			j++;
+		}
+	}
+}
+
+static void highlander_i2c_command(struct highlander_i2c_dev *dev, u8 command, int len)
+{
+	u16 cmd[32];
+	int i, j;
+
+	j = 0;
+	if (len == 1)
+		cmd[j++] = (command << 8);
+	else
+		for (i = 0; i < len; i += 2)
+			cmd[j++] = (command << 8) | command;
+
+	for (i = 0; i < j; i++) {
+		iowrite16(cmd[i], dev->base + SMSADR + (i * sizeof(u16)));
+		dev_dbg(dev->dev, "command data[%x] 0x%04x\n", i, cmd[i]);
+	}
+}
+
+static int highlander_i2c_wait_for_bbsy(struct highlander_i2c_dev *dev)
+{
+	unsigned long timeout;
+
+	timeout = jiffies + msecs_to_jiffies(iic_timeout);
+	while (ioread16(dev->base + SMCR) & SMCR_BBSY) {
+		if (time_after(jiffies, timeout)) {
+			dev_warn(dev->dev, "timeout waiting for bus ready\n");
+			return -ETIMEDOUT;
+		}
+
+		msleep(1);
+	}
+
+	return 0;
+}
+
+static int highlander_i2c_reset(struct highlander_i2c_dev *dev)
+{
+	iowrite16(ioread16(dev->base + SMCR) | SMCR_RST, dev->base + SMCR);
+	return highlander_i2c_wait_for_bbsy(dev);
+}
+
+static int highlander_i2c_wait_for_ack(struct highlander_i2c_dev *dev)
+{
+	u16 tmp = ioread16(dev->base + SMCR);
+
+	if ((tmp & (SMCR_IRIC | SMCR_ACKE)) == SMCR_ACKE) {
+		dev_warn(dev->dev, "ack abnormality\n");
+		return highlander_i2c_reset(dev);
+	}
+
+	return 0;
+}
+
+static irqreturn_t highlander_i2c_irq(int irq, void *dev_id)
+{
+	struct highlander_i2c_dev *dev = dev_id;
+
+	highlander_i2c_done(dev);
+	complete(&dev->cmd_complete);
+
+	return IRQ_HANDLED;
+}
+
+static void highlander_i2c_poll(struct highlander_i2c_dev *dev)
+{
+	unsigned long timeout;
+	u16 smcr;
+
+	timeout = jiffies + msecs_to_jiffies(iic_timeout);
+	for (;;) {
+		smcr = ioread16(dev->base + SMCR);
+
+		/*
+		 * Don't bother checking ACKE here, this and the reset
+		 * are handled in highlander_i2c_wait_xfer_done() when
+		 * waiting for the ACK.
+		 */
+
+		if (smcr & SMCR_IRIC)
+			return;
+		if (time_after(jiffies, timeout))
+			break;
+
+		cpu_relax();
+		cond_resched();
+	}
+
+	dev_err(dev->dev, "polling timed out\n");
+}
+
+static inline int highlander_i2c_wait_xfer_done(struct highlander_i2c_dev *dev)
+{
+	if (dev->irq)
+		wait_for_completion_interruptible_timeout(&dev->cmd_complete,
+					  msecs_to_jiffies(iic_timeout));
+	else
+		/* busy looping, the IRQ of champions */
+		highlander_i2c_poll(dev);
+
+	return highlander_i2c_wait_for_ack(dev);
+}
+
+static int highlander_i2c_read(struct highlander_i2c_dev *dev,
+			       u8 *buf, unsigned int len)
+{
+	int i, cnt;
+	u16 data[16];
+
+	if (highlander_i2c_wait_for_bbsy(dev)) {
+		dev_warn(dev->dev, "timed out\n");
+		return -EAGAIN;
+	}
+
+	highlander_i2c_start(dev);
+
+	if (highlander_i2c_wait_xfer_done(dev)) {
+		dev_err(dev->dev, "Arbitration loss\n");
+		return -EIO;
+	}
+
+	cnt = (len + 1) >> 1;
+	for (i = 0; i < cnt; i++) {
+		data[i] = ioread16(dev->base + SMTRDR + (i * sizeof(u16)));
+		dev_dbg(dev->dev, "read data[%x] 0x%04x\n", i, data[i]);
+	}
+
+	smbus_read_data(data, buf, len);
+
+	/*
+	 * The R0P7780LC0011RL FPGA on the SH7780-based Highlanders
+	 * needs a significant delay in the read path. SH7785 Highlanders
+	 * don't have this issue, so restrict it entirely to those.
+	 */
+	if (mach_is_r7780rp() || mach_is_r7780mp())
+		mdelay(1000);
+
+	return 0;
+}
+
+static int highlander_i2c_write(struct highlander_i2c_dev *dev,
+				u8 *buf, unsigned int len)
+{
+	int i, cnt;
+	u16 data[16];
+
+	smbus_write_data(buf, data, len);
+
+	cnt = (len + 1) >> 1;
+	for (i = 0; i < cnt; i++) {
+		iowrite16(data[i], dev->base + SMTRDR + (i * sizeof(u16)));
+		dev_dbg(dev->dev, "write data[%x] 0x%04x\n", i, data[i]);
+	}
+
+	if (highlander_i2c_wait_for_bbsy(dev)) {
+		dev_warn(dev->dev, "timed out\n");
+		return -EAGAIN;
+	}
+
+	highlander_i2c_start(dev);
+
+	return highlander_i2c_wait_xfer_done(dev);
+}
+
+static int highlander_i2c_smbus_xfer(struct i2c_adapter *adap, u16 addr,
+				  unsigned short flags, char read_write,
+				  u8 command, int size,
+				  union i2c_smbus_data *data)
+{
+	struct highlander_i2c_dev *dev = i2c_get_adapdata(adap);
+	int read = read_write & I2C_SMBUS_READ;
+	u16 tmp;
+
+	init_completion(&dev->cmd_complete);
+
+	dev_dbg(dev->dev, "addr %04x, command %02x, read_write %d, size %d\n",
+		addr, command, read_write, size);
+
+	/* Defaults */
+	dev->buf = NULL;
+	dev->buf_len = 0;
+
+	/*
+	 * Set up the buffer and transfer size
+	 */
+	switch (size) {
+	case I2C_SMBUS_BYTE_DATA:
+		if (data)
+			dev->buf = &data->byte;
+		dev->buf_len = 1;
+		break;
+	case I2C_SMBUS_BLOCK_DATA:
+	case I2C_SMBUS_I2C_BLOCK_DATA:
+		dev->buf = &data->block[1];
+		dev->buf_len = data->block[0];
+		break;
+	default:
+		dev_err(dev->dev, "bogus command %d\n", size);
+		return -EINVAL;
+	}
+
+	/*
+	 * Encode the mode setting
+	 */
+	tmp = ioread16(dev->base + SMMR);
+	tmp &= ~(SMMR_MODE0 | SMMR_MODE1);
+
+	switch (dev->buf_len) {
+	case 1:
+		/* default */
+		break;
+	case 8:
+		tmp |= SMMR_MODE0;
+		break;
+	case 16:
+		tmp |= SMMR_MODE1;
+		break;
+	case 32:
+		tmp |= (SMMR_MODE0 | SMMR_MODE1);
+		break;
+	default:
+		dev_err(dev->dev, "bogus xfer size %d\n", dev->buf_len);
+		return -EINVAL;
+	}
+
+	iowrite16(tmp, dev->base + SMMR);
+
+	/* Ensure we're in a sane state */
+	highlander_i2c_done(dev);
+
+	/* Set slave address */
+	iowrite16(((addr & 0x7f) << 1) | read, dev->base + SMSMADR);
+
+	highlander_i2c_command(dev, command, dev->buf_len);
+
+	if (read)
+		return highlander_i2c_read(dev, dev->buf, dev->buf_len);
+	else
+		return highlander_i2c_write(dev, dev->buf, dev->buf_len);
+}
+
+static u32 highlander_i2c_func(struct i2c_adapter *adapter)
+{
+	return I2C_FUNC_SMBUS_BYTE_DATA | I2C_FUNC_SMBUS_BLOCK_DATA;
+}
+
+static const struct i2c_algorithm highlander_i2c_algo = {
+	.smbus_xfer	= highlander_i2c_smbus_xfer,
+	.functionality	= highlander_i2c_func,
+};
+
+static int highlander_i2c_probe(struct platform_device *pdev)
+{
+	struct highlander_i2c_dev *dev;
+	struct i2c_adapter *adap;
+	struct resource *res;
+	int ret;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (unlikely(!res)) {
+		dev_err(&pdev->dev, "no mem resource\n");
+		return -ENODEV;
+	}
+
+	dev = kzalloc(sizeof(struct highlander_i2c_dev), GFP_KERNEL);
+	if (unlikely(!dev))
+		return -ENOMEM;
+
+	dev->base = ioremap_nocache(res->start, res->end - res ->start + 1);
+	if (unlikely(!dev->base)) {
+		ret = -ENXIO;
+		goto err;
+	}
+
+	dev->dev = &pdev->dev;
+	platform_set_drvdata(pdev, dev);
+
+	dev->irq = platform_get_irq(pdev, 0);
+	if (dev->irq && !iic_force_poll) {
+		ret = request_irq(dev->irq, highlander_i2c_irq, IRQF_DISABLED,
+				  pdev->name, dev);
+		if (unlikely(ret))
+			goto err_unmap;
+
+		highlander_i2c_irq_enable(dev);
+	} else {
+		dev_notice(&pdev->dev, "no IRQ, using polling mode\n");
+		highlander_i2c_irq_disable(dev);
+	}
+
+	highlander_i2c_setup(dev);
+
+	adap = &dev->adapter;
+	i2c_set_adapdata(adap, dev);
+	adap->owner = THIS_MODULE;
+	adap->class = I2C_CLASS_HWMON;
+	strncpy(adap->name, "HL FPGA I2C adapter", sizeof(adap->name));
+	adap->algo = &highlander_i2c_algo;
+	adap->dev.parent = &pdev->dev;
+
+	adap->nr = pdev->id;
+	ret = i2c_add_numbered_adapter(adap);
+	if (unlikely(ret)) {
+		dev_err(&pdev->dev, "failure adding adapter\n");
+		goto err_free_irq;
+	}
+
+	/*
+	 * Reset the adapter
+	 */
+	ret = highlander_i2c_reset(dev);
+	if (unlikely(ret)) {
+		dev_err(&pdev->dev, "controller didn't come up\n");
+		goto err_free_irq;
+	}
+
+	return 0;
+
+err_free_irq:
+	free_irq(dev->irq, dev);
+err_unmap:
+	iounmap(dev->base);
+err:
+	kfree(dev);
+
+	platform_set_drvdata(pdev, NULL);
+
+	return ret;
+}
+
+static int highlander_i2c_remove(struct platform_device *pdev)
+{
+	struct highlander_i2c_dev *dev = platform_get_drvdata(pdev);
+
+	i2c_del_adapter(&dev->adapter);
+
+	if (dev->irq)
+		free_irq(dev->irq, dev);
+
+	iounmap(dev->base);
+	kfree(dev);
+
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static struct platform_driver highlander_i2c_driver = {
+	.driver		= {
+		.name	= "i2c-highlander",
+		.owner	= THIS_MODULE,
+	},
+
+	.probe		= highlander_i2c_probe,
+	.remove		= highlander_i2c_remove,
+};
+
+static int __init highlander_i2c_init(void)
+{
+	return platform_driver_register(&highlander_i2c_driver);
+}
+
+static void __exit highlander_i2c_exit(void)
+{
+	platform_driver_unregister(&highlander_i2c_driver);
+}
+
+module_init(highlander_i2c_init);
+module_exit(highlander_i2c_exit);
+
+MODULE_AUTHOR("Paul Mundt");
+MODULE_DESCRIPTION("Renesas Highlander FPGA I2C/SMBus adapter");
+MODULE_LICENSE("GPL v2");
+
+module_param(iic_force_poll, bool, 0);
+module_param(iic_force_normal, bool, 0);
+module_param(iic_timeout, int, 0);
+
+MODULE_PARM_DESC(iic_force_poll, "Force polling mode");
+MODULE_PARM_DESC(iic_force_normal, "Force normal mode (100 kHz), default is fast mode (400 kHz)");
+MODULE_PARM_DESC(iic_timeout, "Force timeout value in msecs (default 1000 ms)");
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
linux-next.patch
rtc-rtc-rs5c372-smbus-conversion-support.patch
rtc-rtc-rs5c372-add-support-for-ricoh-r2025s-d-rtc.patch
rtc-file-close-consistently-disables-repeating-irqs.patch
kdump-make-elfcorehdr_addr-independent-of-config_proc_vmcore.patch
binfmt_elf_fdpic-support-auxvec-base-platform-string.patch
binfmt_elf_fdpic-convert-initial-stack-alignment-to-arch_align_stack.patch
binfmt_elf_fdpic-wire-up-at_execfd-at_execfn-at_secure.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-new-ioresource_clk-type-v2.patch
i2c-sh_mobile-ioresource_clk-support.patch

