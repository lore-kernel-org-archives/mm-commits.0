From: akpm@linux-foundation.org
Subject: + driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core.patch added to -mm tree
Date: Fri, 27 Apr 2007 17:40:30 -0700
Message-ID: <200704280040.l3S0eUJ1011697@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46506 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751060AbXD1Ake (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 20:40:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mreimer@vpop.net, johnpol@2ka.mipt.ru


The patch titled
     Driver for the Maxim DS1WM, a 1-wire bus master ASIC core
has been added to the -mm tree.  Its filename is
     driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Driver for the Maxim DS1WM, a 1-wire bus master ASIC core

Cc: Matt Reimer <mreimer@vpop.net>

Signed-off-by: Matt Reimer <mreimer@vpop.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/Kconfig  |    8 
 drivers/w1/masters/Makefile |    2 
 drivers/w1/masters/ds1wm.c  |  463 ++++++++++++++++++++++++++++++++++
 include/linux/ds1wm.h       |   13 
 4 files changed, 485 insertions(+), 1 deletion(-)

diff -puN drivers/w1/masters/Kconfig~driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core drivers/w1/masters/Kconfig
--- a/drivers/w1/masters/Kconfig~driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core
+++ a/drivers/w1/masters/Kconfig
@@ -35,5 +35,13 @@ config W1_MASTER_DS2482
 	  This driver can also be built as a module.  If so, the module
 	  will be called ds2482.
 
+config W1_DS1WM
+	tristate "Maxim DS1WM 1-wire busmaster"
+	depends on W1
+	help
+	  Say Y here to enable the DS1WM 1-wire driver, such as that
+	  in HP iPAQ devices like h5xxx, h2200, and ASIC3-based like
+	  hx4700.
+
 endmenu
 
diff -puN drivers/w1/masters/Makefile~driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core drivers/w1/masters/Makefile
--- a/drivers/w1/masters/Makefile~driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core
+++ a/drivers/w1/masters/Makefile
@@ -5,4 +5,4 @@
 obj-$(CONFIG_W1_MASTER_MATROX)		+= matrox_w1.o
 obj-$(CONFIG_W1_MASTER_DS2490)		+= ds2490.o
 obj-$(CONFIG_W1_MASTER_DS2482)		+= ds2482.o
-
+obj-$(CONFIG_W1_DS1WM)                  += ds1wm.o
diff -puN /dev/null drivers/w1/masters/ds1wm.c
--- /dev/null
+++ a/drivers/w1/masters/ds1wm.c
@@ -0,0 +1,463 @@
+/*
+ * 1-wire busmaster driver for DS1WM and ASICs with embedded DS1WMs
+ * such as HP iPAQs (including h5xxx, h2200, and devices with ASIC3
+ * like hx4700).
+ *
+ * Copyright (c) 2004-2005, Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
+ * Copyright (c) 2004-2007, Matt Reimer <mreimer@vpop.net>
+ *
+ * Use consistent with the GNU GPL is permitted,
+ * provided that this copyright notice is
+ * preserved in its entirety in all copies and derived works.
+ */
+
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/pm.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/ds1wm.h>
+
+#include <asm/io.h>
+
+#include "../w1.h"
+#include "../w1_int.h"
+
+
+#define DS1WM_CMD	0x00	/* R/W 4 bits command */
+#define DS1WM_DATA	0x01	/* R/W 8 bits, transmit/receive buffer */
+#define DS1WM_INT	0x02	/* R/W interrupt status */
+#define DS1WM_INT_EN	0x03	/* R/W interrupt enable */
+#define DS1WM_CLKDIV	0x04	/* R/W 5 bits of divisor and pre-scale */
+
+#define DS1WM_CMD_1W_RESET  1 << 0	/* force reset on 1-wire bus */
+#define DS1WM_CMD_SRA	    1 << 1	/* enable Search ROM accelerator mode */
+#define DS1WM_CMD_DQ_OUTPUT 1 << 2	/* write only - forces bus low */
+#define DS1WM_CMD_DQ_INPUT  1 << 3	/* read only - reflects state of bus */
+
+#define DS1WM_INT_PD	    1 << 0	/* presence detect */
+#define DS1WM_INT_PDR	    1 << 1	/* presence detect result */
+#define DS1WM_INT_TBE	    1 << 2	/* tx buffer empty */
+#define DS1WM_INT_TSRE	    1 << 3	/* tx shift register empty */
+#define DS1WM_INT_RBF	    1 << 4	/* rx buffer full */
+#define DS1WM_INT_RSRF	    1 << 5	/* rx shift register full */
+
+#define DS1WM_INTEN_EPD	    1 << 0	/* enable presence detect int */
+#define DS1WM_INTEN_IAS	    1 << 1	/* INTR active state */
+#define DS1WM_INTEN_ETBE    1 << 2	/* enable tx buffer empty int */
+#define DS1WM_INTEN_ETMT    1 << 3	/* enable tx shift register empty int */
+#define DS1WM_INTEN_ERBF    1 << 4	/* enable rx buffer full int */
+#define DS1WM_INTEN_ERSRF   1 << 5	/* enable rx shift register full int */
+#define DS1WM_INTEN_DQO	    1 << 6	/* enable direct bus driving ops
+					   (undocumented), Szabolcs Gyurko */
+
+
+#define DS1WM_TIMEOUT (HZ * 5)
+
+static struct {
+	unsigned long freq;
+	unsigned long divisor;
+} freq[] = {
+	{ 4000000, 0x8 },
+	{ 5000000, 0x2 },
+	{ 6000000, 0x5 },
+	{ 7000000, 0x3 },
+	{ 8000000, 0xc },
+	{ 10000000, 0x6 },
+	{ 12000000, 0x9 },
+	{ 14000000, 0x7 },
+	{ 16000000, 0x10 },
+	{ 20000000, 0xa },
+	{ 24000000, 0xd },
+	{ 28000000, 0xb },
+	{ 32000000, 0x14 },
+	{ 40000000, 0xe },
+	{ 48000000, 0x11 },
+	{ 56000000, 0xf },
+	{ 64000000, 0x18 },
+	{ 80000000, 0x12 },
+	{ 96000000, 0x15 },
+	{ 112000000, 0x13 },
+	{ 128000000, 0x1c },
+};
+
+struct ds1wm_data {
+	void		*map;
+	int		bus_shift; /* # of shifts to calc register offsets */
+	struct platform_device *pdev;
+	struct ds1wm_platform_data *pdata;
+	int		irq;
+	struct clk	*clk;
+	int		slave_present;
+	void		*reset_complete;
+	void		*read_complete;
+	void		*write_complete;
+	u8		read_byte; /* last byte received */
+};
+
+static inline void ds1wm_write_register(struct ds1wm_data *ds1wm_data, u32 reg,
+					u8 val)
+{
+        __raw_writeb(val, ds1wm_data->map + (reg << ds1wm_data->bus_shift));
+}
+
+static inline u8 ds1wm_read_register(struct ds1wm_data *ds1wm_data, u32 reg)
+{
+        return __raw_readb(ds1wm_data->map + (reg << ds1wm_data->bus_shift));
+}
+
+
+static irqreturn_t ds1wm_isr(int isr, void *data)
+{
+	struct ds1wm_data *ds1wm_data = data;
+	u8 intr = ds1wm_read_register(ds1wm_data, DS1WM_INT);
+
+	ds1wm_data->slave_present = intr & DS1WM_INT_PDR ? 0 : 1;
+
+	if (intr & DS1WM_INT_PD && ds1wm_data->reset_complete)
+		complete(ds1wm_data->reset_complete);
+
+	if (intr & DS1WM_INT_RBF) {
+		ds1wm_data->read_byte = ds1wm_read_register(ds1wm_data,
+							    DS1WM_DATA);
+		if (ds1wm_data->read_complete)
+			complete(ds1wm_data->read_complete);
+	}
+
+	if (intr & DS1WM_INT_TSRE && ds1wm_data->write_complete)
+		complete(ds1wm_data->write_complete);
+
+	return IRQ_HANDLED;
+}
+
+static int ds1wm_reset(struct ds1wm_data *ds1wm_data)
+{
+	unsigned long timeleft;
+	DECLARE_COMPLETION(reset_done);
+
+	ds1wm_data->reset_complete = &reset_done;
+
+	ds1wm_write_register(ds1wm_data, DS1WM_INT_EN, DS1WM_INTEN_EPD |
+		(ds1wm_data->pdata->active_high ? DS1WM_INTEN_IAS : 0));
+
+	ds1wm_write_register(ds1wm_data, DS1WM_CMD, DS1WM_CMD_1W_RESET);
+
+	timeleft = wait_for_completion_timeout(&reset_done, DS1WM_TIMEOUT);
+	ds1wm_data->reset_complete = NULL;
+	if (!timeleft) {
+                dev_dbg(&ds1wm_data->pdev->dev, "reset failed\n");
+                return 1;
+	}
+
+	/* Wait for the end of the reset. According to the specs, the time
+	 * from when the interrupt is asserted to the end of the reset is:
+	 *     tRSTH  - tPDH  - tPDL - tPDI
+	 *     625 us - 60 us - 240 us - 100 ns = 324.9 us
+	 *
+	 * We'll wait a bit longer just to be sure.
+	 */
+	udelay(500);
+
+	ds1wm_write_register(ds1wm_data, DS1WM_INT_EN,
+		DS1WM_INTEN_ERBF | DS1WM_INTEN_ETMT | DS1WM_INTEN_EPD |
+		(ds1wm_data->pdata->active_high ? DS1WM_INTEN_IAS : 0));
+
+	if (!ds1wm_data->slave_present) {
+                dev_dbg(&ds1wm_data->pdev->dev, "reset: no devices found\n");
+                return 1;
+        }
+
+        return 0;
+}
+
+static int ds1wm_write(struct ds1wm_data *ds1wm_data, u8 data)
+{
+	DECLARE_COMPLETION(write_done);
+	ds1wm_data->write_complete = &write_done;
+
+	ds1wm_write_register(ds1wm_data, DS1WM_DATA, data);
+
+	wait_for_completion_timeout(&write_done, DS1WM_TIMEOUT);
+	ds1wm_data->write_complete = NULL;
+
+	return 0;
+}
+
+static int ds1wm_read(struct ds1wm_data *ds1wm_data, unsigned char write_data)
+{
+	DECLARE_COMPLETION(read_done);
+	ds1wm_data->read_complete = &read_done;
+
+	ds1wm_write(ds1wm_data, write_data);
+	wait_for_completion_timeout(&read_done, DS1WM_TIMEOUT);
+	ds1wm_data->read_complete = NULL;
+
+	return ds1wm_data->read_byte;
+}
+
+static int ds1wm_find_divisor(int gclk)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE (freq); i++)
+		if (gclk <= freq[i].freq)
+			return freq[i].divisor;
+
+	return 0;
+}
+
+static void ds1wm_up(struct ds1wm_data *ds1wm_data)
+{
+	int gclk, divisor;
+
+	if (ds1wm_data->pdata->enable)
+		ds1wm_data->pdata->enable(ds1wm_data->pdev);
+
+	gclk = clk_get_rate(ds1wm_data->clk);
+	clk_enable(ds1wm_data->clk);
+	divisor = ds1wm_find_divisor(gclk);
+	if (divisor == 0) {
+		dev_err(&ds1wm_data->pdev->dev,
+			"no suitable divisor for %dHz clock\n", gclk);
+		return;
+	}
+	ds1wm_write_register(ds1wm_data, DS1WM_CLKDIV, divisor);
+
+	/* Let the w1 clock stabilize. */
+	msleep(1);
+
+	enable_irq(ds1wm_data->irq);
+}
+
+static void ds1wm_down(struct ds1wm_data *ds1wm_data)
+{
+	disable_irq(ds1wm_data->irq);
+	if (ds1wm_data->pdata->disable)
+		ds1wm_data->pdata->disable(ds1wm_data->pdev);
+
+	clk_disable(ds1wm_data->clk);
+}
+
+/* --------------------------------------------------------------------- */
+/* w1 methods */
+
+static u8 ds1wm_read_byte(void *data)
+{
+	struct ds1wm_data *ds1wm_data = data;
+
+	return ds1wm_read(ds1wm_data, 0xff);
+}
+
+static void ds1wm_write_byte(void *data, u8 byte)
+{
+	struct ds1wm_data *ds1wm_data = data;
+
+	ds1wm_write(ds1wm_data, byte);
+}
+
+static u8 ds1wm_reset_bus(void *data)
+{
+	struct ds1wm_data *ds1wm_data = data;
+
+	ds1wm_reset(ds1wm_data);
+
+	return 0;
+}
+
+static void ds1wm_search(void *data, u8 search_type,
+			 w1_slave_found_callback slave_found)
+{
+	struct ds1wm_data *ds1wm_data = data;
+	int i;
+	unsigned long long rom_id;
+
+	/* XXX We need to iterate for multiple devices per the DS1WM docs.
+	 * See http://www.maxim-ic.com/appnotes.cfm/appnote_number/120. */
+	if (ds1wm_reset(ds1wm_data))
+		return;
+
+	ds1wm_write(ds1wm_data, search_type);
+	ds1wm_write_register(ds1wm_data, DS1WM_CMD, DS1WM_CMD_SRA);
+
+	for (rom_id = 0, i = 0; i < 16; i++) {
+
+		unsigned char resp, r, d;
+
+		resp = ds1wm_read(ds1wm_data, 0x00);
+
+		r = ((resp & 0x02) >> 1) |
+		    ((resp & 0x08) >> 2) |
+		    ((resp & 0x20) >> 3) |
+		    ((resp & 0x80) >> 4);
+
+		d = ((resp & 0x01) >> 0) |
+		    ((resp & 0x04) >> 1) |
+		    ((resp & 0x10) >> 2) |
+		    ((resp & 0x40) >> 3);
+
+		rom_id |= (unsigned long long) r << (i * 4);
+
+	}
+	dev_dbg(&ds1wm_data->pdev->dev, "found 0x%08llX", rom_id);
+
+	ds1wm_write_register(ds1wm_data, DS1WM_CMD, ~DS1WM_CMD_SRA);
+	ds1wm_reset(ds1wm_data);
+
+	slave_found(ds1wm_data, rom_id);
+}
+
+/* --------------------------------------------------------------------- */
+
+static struct w1_bus_master ds1wm_master = {
+	.read_byte  = ds1wm_read_byte,
+	.write_byte = ds1wm_write_byte,
+	.reset_bus  = ds1wm_reset_bus,
+	.search	    = ds1wm_search,
+};
+
+static int ds1wm_probe(struct platform_device *pdev)
+{
+	struct ds1wm_data *ds1wm_data;
+	struct ds1wm_platform_data *plat;
+	struct resource *res;
+	int ret;
+
+	if (!pdev)
+		return -ENODEV;
+
+	ds1wm_data = kzalloc(sizeof (*ds1wm_data), GFP_KERNEL);
+	if (!ds1wm_data)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, ds1wm_data);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		ret = -ENXIO;
+		goto err0;
+	}
+	ds1wm_data->map = ioremap(res->start, res->end - res->start + 1);
+	if (!ds1wm_data->map) {
+		ret = -ENOMEM;
+		goto err0;
+	}
+	plat = pdev->dev.platform_data;
+	ds1wm_data->bus_shift = plat->bus_shift;
+	ds1wm_data->pdev = pdev;
+	ds1wm_data->pdata = plat;
+
+	ds1wm_data->irq = platform_get_irq(pdev, 0);
+	if (ds1wm_data->irq < 0) {
+		ret = -ENXIO;
+		goto err1;
+	}
+
+	if (plat->falling_edge)
+		set_irq_type(ds1wm_data->irq, IRQ_TYPE_EDGE_FALLING);
+	else
+		set_irq_type(ds1wm_data->irq, IRQ_TYPE_EDGE_RISING);
+
+	ret = request_irq(ds1wm_data->irq, ds1wm_isr,
+			  IRQF_DISABLED | IRQF_SAMPLE_RANDOM, "ds1wm",
+			  ds1wm_data);
+	if (ret)
+		goto err1;
+	disable_irq(ds1wm_data->irq);
+
+	ds1wm_data->clk = clk_get(&pdev->dev, "ds1wm");
+	if (!ds1wm_data->clk) {
+		ret = -ENOENT;
+		goto err2;
+	}
+
+	ds1wm_up(ds1wm_data);
+
+	ds1wm_master.data = (void *)ds1wm_data;
+
+	ret = w1_add_master_device(&ds1wm_master);
+	if (ret)
+		goto err3;
+
+	return 0;
+
+err3:
+	ds1wm_reset(ds1wm_data);
+	ds1wm_down(ds1wm_data);
+	clk_put(ds1wm_data->clk);
+err2:
+	free_irq(ds1wm_data->irq, ds1wm_data);
+err1:
+	iounmap(ds1wm_data->map);
+err0:
+	kfree(ds1wm_data);
+
+	return ret;
+}
+
+#ifdef CONFIG_PM
+static int ds1wm_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct ds1wm_data *ds1wm_data = platform_get_drvdata(pdev);
+
+	ds1wm_down(ds1wm_data);
+
+	return 0;
+}
+
+static int ds1wm_resume(struct platform_device *pdev)
+{
+	struct ds1wm_data *ds1wm_data = platform_get_drvdata(pdev);
+
+	ds1wm_up(ds1wm_data);
+
+	return 0;
+}
+#endif
+
+static int ds1wm_remove(struct platform_device *pdev)
+{
+	struct ds1wm_data *ds1wm_data = platform_get_drvdata(pdev);
+
+	w1_remove_master_device(&ds1wm_master);
+	ds1wm_reset(ds1wm_data);
+	ds1wm_down(ds1wm_data);
+	clk_put(ds1wm_data->clk);
+	free_irq(ds1wm_data->irq, ds1wm_data);
+	iounmap(ds1wm_data->map);
+	kfree(ds1wm_data);
+
+	return 0;
+}
+
+static struct platform_driver ds1wm_driver = {
+	.driver   = {
+		.name = "ds1wm",
+	},
+	.probe    = ds1wm_probe,
+	.remove   = ds1wm_remove,
+#ifdef CONFIG_PM
+	.suspend  = ds1wm_suspend,
+	.resume   = ds1wm_resume
+#endif
+};
+
+static int ds1wm_init(void)
+{
+	printk("DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko\n");
+	return platform_driver_register(&ds1wm_driver);
+}
+
+static void ds1wm_exit(void)
+{
+	platform_driver_unregister(&ds1wm_driver);
+}
+
+module_init(ds1wm_init);
+module_exit(ds1wm_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>, "
+	      "Matt Reimer <mreimer@vpop.net>");
+MODULE_DESCRIPTION("DS1WM w1 busmaster driver");
diff -puN /dev/null include/linux/ds1wm.h
--- /dev/null
+++ a/include/linux/ds1wm.h
@@ -0,0 +1,13 @@
+/* platform data for the DS1WM driver */
+
+struct ds1wm_platform_data {
+	int bus_shift;	    /* number of shifts needed to calculate the
+			     * offset between DS1WM registers;
+			     * e.g. on h5xxx and h2200 this is 2
+			     * (registers aligned to 4-byte boundaries),
+			     * while on hx4700 this is 1 */
+	int falling_edge;   /* interrupt edge - passed to set_irq_type() */
+	int active_high;    /* interrupt polarity, passed to DS1WM as IAS bit */
+	void (*enable)(struct platform_device *pdev);
+	void (*disable)(struct platform_device *pdev);
+};
_

Patches currently in -mm which might be from mreimer@vpop.net are

w1-allow-bus-master-to-have-reset-and-byte-ops.patch
driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core.patch
