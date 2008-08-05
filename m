From: akpm@linux-foundation.org
Subject: + i2c-renesas-highlander-fpga-smbus-support-update.patch added to -mm tree
Date: Tue, 05 Aug 2008 14:38:01 -0700
Message-ID: <200808052138.m75Lc2i4024746@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44080 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757649AbYHEViq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Aug 2008 17:38:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lethal@linux-sh.org, khali@linux-fr.org, xyzzy@speakeasy.org


The patch titled
     i2c: renesas Highlander FPGA SMBus support, v2
has been added to the -mm tree.  Its filename is
     i2c-renesas-highlander-fpga-smbus-support-update.patch

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
Subject: i2c: renesas Highlander FPGA SMBus support, v2
From: Paul Mundt <lethal@linux-sh.org>

This adds support for the SMBus adapter found in the various FPGAs on
the Renesas Highlander platforms.  Particularly the R0P7780LC0011RL and
R0P7785LC0011RL FPGAs.

Functionality is fairly restricted, in that only byte and block data
transfers are supported.  Normal/fast mode and IRQ/polling are also
supported.  Primarily used for various RTCs and thermal sensors.

This version incorporates all of the comments from Jean Delvare and
Trent Piepho.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Trent Piepho <xyzzy@speakeasy.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/Kconfig          |   24 +--
 drivers/i2c/busses/i2c-highlander.c |  159 ++++++++++++--------------
 2 files changed, 89 insertions(+), 94 deletions(-)

diff -puN drivers/i2c/busses/Kconfig~i2c-renesas-highlander-fpga-smbus-support-update drivers/i2c/busses/Kconfig
--- a/drivers/i2c/busses/Kconfig~i2c-renesas-highlander-fpga-smbus-support-update
+++ a/drivers/i2c/busses/Kconfig
@@ -230,18 +230,6 @@ config I2C_VIAPRO
 comment "Mac SMBus host controller drivers"
 	depends on PPC_CHRP || PPC_PMAC
 
-config I2C_HIGHLANDER
-	tristate "Highlander FPGA SMBus interface"
-	depends on SH_HIGHLANDER
-	help
-	  If you say yes to this option, support will be included for
-	  the SMBus interface located in the FPGA on various Highlander
-	  boards, particularly the R0P7780LC0011RL and R0P7785LC0011RL
-	  FPGAs. This is wholly unrelated to the SoC I2C.
-
-	  This driver can also be built as a module.  If so, the module
-	  will be called i2c-highlander.
-
 config I2C_HYDRA
 	tristate "CHRP Apple Hydra Mac I/O I2C interface"
 	depends on PCI && PPC_CHRP && EXPERIMENTAL
@@ -342,6 +330,18 @@ config I2C_GPIO
 	  This is a very simple bitbanging I2C driver utilizing the
 	  arch-neutral GPIO API to control the SCL and SDA lines.
 
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
 config I2C_IBM_IIC
 	tristate "IBM PPC 4xx on-chip I2C interface"
 	depends on 4xx
diff -puN drivers/i2c/busses/i2c-highlander.c~i2c-renesas-highlander-fpga-smbus-support-update drivers/i2c/busses/i2c-highlander.c
--- a/drivers/i2c/busses/i2c-highlander.c~i2c-renesas-highlander-fpga-smbus-support-update
+++ a/drivers/i2c/busses/i2c-highlander.c
@@ -45,12 +45,14 @@ struct highlander_i2c_dev {
 	void __iomem		*base;
 	struct i2c_adapter	adapter;
 	struct completion	cmd_complete;
+	unsigned long		last_read_time;
 	int			irq;
 	u8			*buf;
 	size_t			buf_len;
 };
 
-static int iic_force_poll, iic_force_normal, iic_timeout = 1000;
+static int iic_force_poll, iic_force_normal;
+static int iic_timeout = 1000, iic_read_delay = 0;
 
 static inline void highlander_i2c_irq_enable(struct highlander_i2c_dev *dev)
 {
@@ -72,7 +74,7 @@ static inline void highlander_i2c_done(s
 	iowrite16(ioread16(dev->base + SMCR) | SMCR_IRIC, dev->base + SMCR);
 }
 
-static inline void highlander_i2c_setup(struct highlander_i2c_dev *dev)
+static void highlander_i2c_setup(struct highlander_i2c_dev *dev)
 {
 	u16 smmr;
 
@@ -89,50 +91,36 @@ static inline void highlander_i2c_setup(
 
 static void smbus_write_data(u8 *src, u16 *dst, int len)
 {
-	int i, j;
+	for (; len > 1; len -= 2) {
+		*dst++ = be16_to_cpup((u16 *)src);
+		src += 2;
+	}
 
-	if (len == 1)
+	if (len)
 		*dst = *src << 8;
-	else {
-		j = 0;
-		for (i = 0; i < len; i += 2) {
-			*(dst + j) = *(src + i) << 8 | *(src + i + 1);
-			j++;
-		}
-	}
 }
 
 static void smbus_read_data(u16 *src, u8 *dst, int len)
 {
-	int i, j;
+	for (; len > 1; len -= 2) {
+		*(u16 *)dst = cpu_to_be16p(src++);
+		dst += 2;
+	}
 
-	if (len == 1)
+	if (len)
 		*dst = *src >> 8;
-	else {
-		j = 0;
-		for (i = 0; i < len; i += 2) {
-			*(dst + i) = *(src + j) >> 8;
-			*(dst + i + 1) = *(src + j) & 0x00ff;
-			j++;
-		}
-	}
 }
 
 static void highlander_i2c_command(struct highlander_i2c_dev *dev, u8 command, int len)
 {
-	u16 cmd[32];
-	int i, j;
-
-	j = 0;
-	if (len == 1)
-		cmd[j++] = (command << 8);
-	else
-		for (i = 0; i < len; i += 2)
-			cmd[j++] = (command << 8) | command;
+	unsigned int i;
+	u16 cmd = (command << 8) | command;
 
-	for (i = 0; i < j; i++) {
-		iowrite16(cmd[i], dev->base + SMSADR + (i * sizeof(u16)));
-		dev_dbg(dev->dev, "command data[%x] 0x%04x\n", i, cmd[i]);
+	for (i = 0; i < len; i += 2) {
+		if (len - i == 1)
+			cmd = command << 8;
+		iowrite16(cmd, dev->base + SMSADR + i);
+		dev_dbg(dev->dev, "command data[%x] 0x%04x\n", i/2, cmd);
 	}
 }
 
@@ -220,61 +208,66 @@ static inline int highlander_i2c_wait_xf
 	return highlander_i2c_wait_for_ack(dev);
 }
 
-static int highlander_i2c_read(struct highlander_i2c_dev *dev,
-			       u8 *buf, unsigned int len)
+static int highlander_i2c_read(struct highlander_i2c_dev *dev)
 {
 	int i, cnt;
 	u16 data[16];
 
-	if (highlander_i2c_wait_for_bbsy(dev)) {
-		dev_warn(dev->dev, "timed out\n");
+	if (highlander_i2c_wait_for_bbsy(dev))
 		return -EAGAIN;
-	}
 
 	highlander_i2c_start(dev);
 
 	if (highlander_i2c_wait_xfer_done(dev)) {
 		dev_err(dev->dev, "Arbitration loss\n");
-		return -EIO;
+		return -EAGAIN;
 	}
 
-	cnt = (len + 1) >> 1;
+	/*
+	 * The R0P7780LC0011RL FPGA needs a significant delay between
+	 * data read cycles, otherwise the transciever gets confused and
+	 * garbage is returned when the read is subsequently aborted.
+	 *
+	 * It is not sufficient to wait for BBSY.
+	 *
+	 * While this generally only applies to the older SH7780-based
+	 * Highlanders, the same issue can be observed on SH7785 ones,
+	 * albeit less frequently. SH7780-based Highlanders may need
+	 * this to be as high as 1000 ms.
+	 */
+	if (iic_read_delay && time_before(jiffies, dev->last_read_time +
+				 msecs_to_jiffies(iic_read_delay)))
+		msleep_interruptible(jiffies_to_msecs((dev->last_read_time +
+				msecs_to_jiffies(iic_read_delay)) - jiffies));
+
+	cnt = (dev->buf_len + 1) >> 1;
 	for (i = 0; i < cnt; i++) {
 		data[i] = ioread16(dev->base + SMTRDR + (i * sizeof(u16)));
 		dev_dbg(dev->dev, "read data[%x] 0x%04x\n", i, data[i]);
 	}
 
-	smbus_read_data(data, buf, len);
+	smbus_read_data(data, dev->buf, dev->buf_len);
 
-	/*
-	 * The R0P7780LC0011RL FPGA on the SH7780-based Highlanders
-	 * needs a significant delay in the read path. SH7785 Highlanders
-	 * don't have this issue, so restrict it entirely to those.
-	 */
-	if (mach_is_r7780rp() || mach_is_r7780mp())
-		mdelay(1000);
+	dev->last_read_time = jiffies;
 
 	return 0;
 }
 
-static int highlander_i2c_write(struct highlander_i2c_dev *dev,
-				u8 *buf, unsigned int len)
+static int highlander_i2c_write(struct highlander_i2c_dev *dev)
 {
 	int i, cnt;
 	u16 data[16];
 
-	smbus_write_data(buf, data, len);
+	smbus_write_data(dev->buf, data, dev->buf_len);
 
-	cnt = (len + 1) >> 1;
+	cnt = (dev->buf_len + 1) >> 1;
 	for (i = 0; i < cnt; i++) {
 		iowrite16(data[i], dev->base + SMTRDR + (i * sizeof(u16)));
 		dev_dbg(dev->dev, "write data[%x] 0x%04x\n", i, data[i]);
 	}
 
-	if (highlander_i2c_wait_for_bbsy(dev)) {
-		dev_warn(dev->dev, "timed out\n");
+	if (highlander_i2c_wait_for_bbsy(dev))
 		return -EAGAIN;
-	}
 
 	highlander_i2c_start(dev);
 
@@ -295,26 +288,20 @@ static int highlander_i2c_smbus_xfer(str
 	dev_dbg(dev->dev, "addr %04x, command %02x, read_write %d, size %d\n",
 		addr, command, read_write, size);
 
-	/* Defaults */
-	dev->buf = NULL;
-	dev->buf_len = 0;
-
 	/*
 	 * Set up the buffer and transfer size
 	 */
 	switch (size) {
 	case I2C_SMBUS_BYTE_DATA:
-		if (data)
-			dev->buf = &data->byte;
+		dev->buf = &data->byte;
 		dev->buf_len = 1;
 		break;
-	case I2C_SMBUS_BLOCK_DATA:
 	case I2C_SMBUS_I2C_BLOCK_DATA:
 		dev->buf = &data->block[1];
 		dev->buf_len = data->block[0];
 		break;
 	default:
-		dev_err(dev->dev, "bogus command %d\n", size);
+		dev_err(dev->dev, "unsupported command %d\n", size);
 		return -EINVAL;
 	}
 
@@ -338,7 +325,7 @@ static int highlander_i2c_smbus_xfer(str
 		tmp |= (SMMR_MODE0 | SMMR_MODE1);
 		break;
 	default:
-		dev_err(dev->dev, "bogus xfer size %d\n", dev->buf_len);
+		dev_err(dev->dev, "unsupported xfer size %d\n", dev->buf_len);
 		return -EINVAL;
 	}
 
@@ -348,19 +335,19 @@ static int highlander_i2c_smbus_xfer(str
 	highlander_i2c_done(dev);
 
 	/* Set slave address */
-	iowrite16(((addr & 0x7f) << 1) | read, dev->base + SMSMADR);
+	iowrite16((addr << 1) | read, dev->base + SMSMADR);
 
 	highlander_i2c_command(dev, command, dev->buf_len);
 
 	if (read)
-		return highlander_i2c_read(dev, dev->buf, dev->buf_len);
+		return highlander_i2c_read(dev);
 	else
-		return highlander_i2c_write(dev, dev->buf, dev->buf_len);
+		return highlander_i2c_write(dev);
 }
 
 static u32 highlander_i2c_func(struct i2c_adapter *adapter)
 {
-	return I2C_FUNC_SMBUS_BYTE_DATA | I2C_FUNC_SMBUS_BLOCK_DATA;
+	return I2C_FUNC_SMBUS_BYTE_DATA | I2C_FUNC_SMBUS_I2C_BLOCK;
 }
 
 static const struct i2c_algorithm highlander_i2c_algo = {
@@ -368,7 +355,7 @@ static const struct i2c_algorithm highla
 	.functionality	= highlander_i2c_func,
 };
 
-static int highlander_i2c_probe(struct platform_device *pdev)
+static int __devinit highlander_i2c_probe(struct platform_device *pdev)
 {
 	struct highlander_i2c_dev *dev;
 	struct i2c_adapter *adap;
@@ -385,7 +372,7 @@ static int highlander_i2c_probe(struct p
 	if (unlikely(!dev))
 		return -ENOMEM;
 
-	dev->base = ioremap_nocache(res->start, res->end - res ->start + 1);
+	dev->base = ioremap_nocache(res->start, res->end - res->start + 1);
 	if (unlikely(!dev->base)) {
 		ret = -ENXIO;
 		goto err;
@@ -395,7 +382,10 @@ static int highlander_i2c_probe(struct p
 	platform_set_drvdata(pdev, dev);
 
 	dev->irq = platform_get_irq(pdev, 0);
-	if (dev->irq && !iic_force_poll) {
+	if (iic_force_poll)
+		dev->irq = 0;
+
+	if (dev->irq) {
 		ret = request_irq(dev->irq, highlander_i2c_irq, IRQF_DISABLED,
 				  pdev->name, dev);
 		if (unlikely(ret))
@@ -407,22 +397,18 @@ static int highlander_i2c_probe(struct p
 		highlander_i2c_irq_disable(dev);
 	}
 
+	dev->last_read_time = jiffies;	/* initial read jiffies */
+
 	highlander_i2c_setup(dev);
 
 	adap = &dev->adapter;
 	i2c_set_adapdata(adap, dev);
 	adap->owner = THIS_MODULE;
 	adap->class = I2C_CLASS_HWMON;
-	strncpy(adap->name, "HL FPGA I2C adapter", sizeof(adap->name));
+	strlcpy(adap->name, "HL FPGA I2C adapter", I2C_NAME_SIZE);
 	adap->algo = &highlander_i2c_algo;
 	adap->dev.parent = &pdev->dev;
-
 	adap->nr = pdev->id;
-	ret = i2c_add_numbered_adapter(adap);
-	if (unlikely(ret)) {
-		dev_err(&pdev->dev, "failure adding adapter\n");
-		goto err_free_irq;
-	}
 
 	/*
 	 * Reset the adapter
@@ -433,10 +419,17 @@ static int highlander_i2c_probe(struct p
 		goto err_free_irq;
 	}
 
+	ret = i2c_add_numbered_adapter(adap);
+	if (unlikely(ret)) {
+		dev_err(&pdev->dev, "failure adding adapter\n");
+		goto err_free_irq;
+	}
+
 	return 0;
 
 err_free_irq:
-	free_irq(dev->irq, dev);
+	if (dev->irq)
+		free_irq(dev->irq, dev);
 err_unmap:
 	iounmap(dev->base);
 err:
@@ -447,7 +440,7 @@ err:
 	return ret;
 }
 
-static int highlander_i2c_remove(struct platform_device *pdev)
+static int __devexit highlander_i2c_remove(struct platform_device *pdev)
 {
 	struct highlander_i2c_dev *dev = platform_get_drvdata(pdev);
 
@@ -471,7 +464,7 @@ static struct platform_driver highlander
 	},
 
 	.probe		= highlander_i2c_probe,
-	.remove		= highlander_i2c_remove,
+	.remove		= __devexit_p(highlander_i2c_remove),
 };
 
 static int __init highlander_i2c_init(void)
@@ -494,7 +487,9 @@ MODULE_LICENSE("GPL v2");
 module_param(iic_force_poll, bool, 0);
 module_param(iic_force_normal, bool, 0);
 module_param(iic_timeout, int, 0);
+module_param(iic_read_delay, int, 0);
 
 MODULE_PARM_DESC(iic_force_poll, "Force polling mode");
 MODULE_PARM_DESC(iic_force_normal, "Force normal mode (100 kHz), default is fast mode (400 kHz)");
-MODULE_PARM_DESC(iic_timeout, "Force timeout value in msecs (default 1000 ms)");
+MODULE_PARM_DESC(iic_timeout, "Set timeout value in msecs (default 1000 ms)");
+MODULE_PARM_DESC(iic_read_delay, "Delay between data read cycles (default 0 ms)");
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
i2c-renesas-highlander-fpga-smbus-support.patch
i2c-renesas-highlander-fpga-smbus-support-update.patch
git-sh.patch
rtc-rtc-rs5c372-smbus-conversion-support.patch
rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch
kdump-make-elfcorehdr_addr-independent-of-config_proc_vmcore.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-new-ioresource_clk-type-v2.patch
i2c-sh_mobile-ioresource_clk-support.patch

