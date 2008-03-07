From: akpm@linux-foundation.org
Subject: + ps-2-serio-driver-for-avr32-devices.patch added to -mm tree
Date: Fri, 07 Mar 2008 00:06:38 -0800
Message-ID: <200803070806.m2786cKx012268@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756200AbYCGIHQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Mar 2008 03:07:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hcegtvedt@atmel.com, dtor@mail.ru, hskinnemoen@atmel.com, jikos@jikos.cz


The patch titled
     input: PS/2 serio driver for AVR32 devices
has been added to the -mm tree.  Its filename is
     ps-2-serio-driver-for-avr32-devices.patch

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
Subject: input: PS/2 serio driver for AVR32 devices
From: Hans-Christian Egtvedt <hcegtvedt@atmel.com>

Add support for the PSIF peripheral on AVR32 AP7 devices.  It is implemented
as a serio driver and will behave like a serio 8042 device.

The driver has been tested with a Dell keyboard capable of running on 3.3
volts and a Logitech mouse on the STK1000 + STK1002 starter kit.  The Logitech
mouse was hacked by cutting the cord and using a bi-directional voltage
converter to get the required 5 volt I/O level.

For more information about the PSIF module, see the datasheet for AT32AP700X at
http://www.atmel.com/dyn/products/datasheets.asp?family_id=682

Signed-off-by: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Jiri Kosina <jikos@jikos.cz>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/serio/Kconfig    |   11 
 drivers/input/serio/Makefile   |    1 
 drivers/input/serio/at32psif.c |  351 +++++++++++++++++++++++++++++++
 drivers/input/serio/at32psif.h |   82 +++++++
 4 files changed, 445 insertions(+)

diff -puN drivers/input/serio/Kconfig~ps-2-serio-driver-for-avr32-devices drivers/input/serio/Kconfig
--- a/drivers/input/serio/Kconfig~ps-2-serio-driver-for-avr32-devices
+++ a/drivers/input/serio/Kconfig
@@ -88,6 +88,17 @@ config SERIO_RPCKBD
 	  To compile this driver as a module, choose M here: the
 	  module will be called rpckbd.
 
+config SERIO_AT32PSIF
+	tristate "AVR32 PSIF PS/2 keyboard and mouse controller"
+	depends on AVR32
+	default n
+	help
+	  Say Y here if you want to use the PSIF peripheral on AVR32 devices
+	  and connect a PS/2 keyboard and/or mouse to it.
+
+	  To compile this driver as a module, choose M here: the module will
+	  be called at32psif.
+
 config SERIO_AMBAKMI
 	tristate "AMBA KMI keyboard controller"
 	depends on ARM_AMBA
diff -puN drivers/input/serio/Makefile~ps-2-serio-driver-for-avr32-devices drivers/input/serio/Makefile
--- a/drivers/input/serio/Makefile~ps-2-serio-driver-for-avr32-devices
+++ a/drivers/input/serio/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_SERIO_CT82C710)	+= ct82c710
 obj-$(CONFIG_SERIO_RPCKBD)	+= rpckbd.o
 obj-$(CONFIG_SERIO_SA1111)	+= sa1111ps2.o
 obj-$(CONFIG_SERIO_AMBAKMI)	+= ambakmi.o
+obj-$(CONFIG_SERIO_AT32PSIF)	+= at32psif.o
 obj-$(CONFIG_SERIO_Q40KBD)	+= q40kbd.o
 obj-$(CONFIG_SERIO_GSCPS2)	+= gscps2.o
 obj-$(CONFIG_HP_SDC)		+= hp_sdc.o
diff -puN /dev/null drivers/input/serio/at32psif.c
--- /dev/null
+++ a/drivers/input/serio/at32psif.c
@@ -0,0 +1,351 @@
+/*
+ * Copyright (C) 2007 Atmel Corporation
+ *
+ * Driver for the AT32AP700X PS/2 controller (PSIF).
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/init.h>
+#include <linux/serio.h>
+#include <linux/timer.h>
+#include <linux/interrupt.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/clk.h>
+#include <linux/platform_device.h>
+
+#include "at32psif.h"
+
+#define PSIF_BUF_SIZE		16
+
+#define ring_is_empty(_psif)	(_psif->head == _psif->tail)
+#define ring_next_head(_psif)	((_psif->head + 1) & (PSIF_BUF_SIZE - 1))
+#define ring_next_tail(_psif)	((_psif->tail + 1) & (PSIF_BUF_SIZE - 1))
+
+struct psif {
+	struct platform_device	*pdev;
+	struct clk		*pclk;
+	struct serio		*io;
+	struct timer_list	tx_timer;
+	void __iomem		*regs;
+	unsigned int		irq;
+	unsigned int		open;
+	/* Prevent concurrent writes to circular buffer. */
+	spinlock_t		lock;
+	unsigned int		head;
+	unsigned int		tail;
+	unsigned char		buffer[PSIF_BUF_SIZE];
+};
+
+static irqreturn_t psif_interrupt(int irq, void *_ptr)
+{
+	struct psif *psif = _ptr;
+	int retval = IRQ_NONE;
+	unsigned int io_flags = 0;
+	unsigned long status;
+
+	status = psif_readl(psif, SR);
+
+	if (status & PSIF_BIT(RXRDY)) {
+		unsigned char val = (unsigned char) psif_readl(psif, RHR);
+
+		if (status & PSIF_BIT(PARITY))
+			io_flags |= SERIO_PARITY;
+		if (status & PSIF_BIT(OVRUN))
+			dev_err(&psif->pdev->dev, "overrun read error\n");
+
+		serio_interrupt(psif->io, val, io_flags);
+
+		retval = IRQ_HANDLED;
+	}
+
+	spin_lock(&psif->lock);
+
+	if (status & PSIF_BIT(TXEMPTY)) {
+		if (status & PSIF_BIT(NACK))
+			dev_err(&psif->pdev->dev, "NACK error\n");
+
+		psif_writel(psif, IDR, PSIF_BIT(TXEMPTY));
+
+		if (!ring_is_empty(psif))
+			mod_timer(&psif->tx_timer,
+					jiffies + msecs_to_jiffies(1));
+
+		retval = IRQ_HANDLED;
+	}
+
+	spin_unlock(&psif->lock);
+
+	return retval;
+}
+
+static void psif_transmit_data(unsigned long data)
+{
+	struct psif *psif = (struct psif *)data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&psif->lock, flags);
+
+	psif_writel(psif, THR, psif->buffer[psif->tail]);
+	psif->tail = ring_next_tail(psif);
+
+	if (!ring_is_empty(psif))
+		psif_writel(psif, IER, PSIF_BIT(TXEMPTY));
+
+	spin_unlock_irqrestore(&psif->lock, flags);
+}
+
+static int psif_write(struct serio *io, unsigned char val)
+{
+	struct psif *psif = io->port_data;
+	unsigned long flags;
+	unsigned int head;
+
+	spin_lock_irqsave(&psif->lock, flags);
+
+	head = ring_next_head(psif);
+
+	if (head != psif->tail) {
+		psif->buffer[psif->head] = val;
+		psif->head = head;
+	} else {
+		dev_err(&psif->pdev->dev, "underrun write error\n");
+	}
+
+	spin_unlock_irqrestore(&psif->lock, flags);
+
+	/* Make sure TXEMPTY interrupt is enabled. */
+	psif_writel(psif, IER, PSIF_BIT(TXEMPTY));
+
+	return 0;
+}
+
+static int psif_open(struct serio *io)
+{
+	struct psif *psif = io->port_data;
+	int retval;
+
+	retval = clk_enable(psif->pclk);
+	if (retval)
+		goto out;
+
+	psif_writel(psif, CR, PSIF_BIT(CR_TXEN) | PSIF_BIT(CR_RXEN));
+	psif_writel(psif, IER, PSIF_BIT(RXRDY));
+
+	psif->open = 1;
+out:
+	return retval;
+}
+
+static void psif_close(struct serio *io)
+{
+	struct psif *psif = io->port_data;
+
+	psif->open = 0;
+
+	psif_writel(psif, IDR, ~0UL);
+	psif_writel(psif, CR, PSIF_BIT(CR_TXDIS) | PSIF_BIT(CR_RXDIS));
+
+	clk_disable(psif->pclk);
+}
+
+static void psif_set_prescaler(struct psif *psif)
+{
+	unsigned long prscv;
+	unsigned long rate = clk_get_rate(psif->pclk);
+
+	/* PRSCV = Pulse length (100 us) * PSIF module frequency. */
+	prscv = 100 * (rate / 1000000UL);
+
+	if (prscv > ((1<<PSIF_PSR_PRSCV_SIZE) - 1)) {
+		prscv = (1<<PSIF_PSR_PRSCV_SIZE) - 1;
+		dev_dbg(&psif->pdev->dev, "pclk too fast, "
+				"prescaler set to max\n");
+	}
+
+	clk_enable(psif->pclk);
+	psif_writel(psif, PSR, prscv);
+	clk_disable(psif->pclk);
+}
+
+static int __init psif_probe(struct platform_device *pdev)
+{
+	struct resource *regs;
+	struct psif *psif;
+	struct serio *io;
+	struct clk *pclk;
+	int irq;
+	int ret;
+
+	psif = kzalloc(sizeof(struct psif), GFP_KERNEL);
+	if (!psif) {
+		dev_dbg(&pdev->dev, "out of memory\n");
+		ret = -ENOMEM;
+		goto out;
+	}
+	psif->pdev = pdev;
+
+	io = kzalloc(sizeof(struct serio), GFP_KERNEL);
+	if (!io) {
+		dev_dbg(&pdev->dev, "out of memory\n");
+		ret = -ENOMEM;
+		goto out_free_psif;
+	}
+	psif->io = io;
+
+	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!regs) {
+		dev_dbg(&pdev->dev, "no mmio resources defined\n");
+		ret = -ENOMEM;
+		goto out_free_io;
+	}
+
+	psif->regs = ioremap(regs->start, regs->end - regs->start + 1);
+	if (!psif->regs) {
+		ret = -ENOMEM;
+		dev_dbg(&pdev->dev, "could not map I/O memory\n");
+		goto out_free_io;
+	}
+
+	pclk = clk_get(&pdev->dev, "pclk");
+	if (IS_ERR(pclk)) {
+		dev_dbg(&pdev->dev, "could not get peripheral clock\n");
+		ret = PTR_ERR(pclk);
+		goto out_iounmap;
+	}
+	psif->pclk = pclk;
+
+	/* Reset the PSIF to enter at a known state. */
+	ret = clk_enable(pclk);
+	if (ret) {
+		dev_dbg(&pdev->dev, "could not enable pclk\n");
+		goto out_put_clk;
+	}
+	psif_writel(psif, CR, PSIF_BIT(CR_SWRST));
+	clk_disable(pclk);
+
+	setup_timer(&psif->tx_timer, psif_transmit_data, (unsigned long)psif);
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_dbg(&pdev->dev, "could not get irq\n");
+		ret = -ENXIO;
+		goto out_put_clk;
+	}
+	ret = request_irq(irq, psif_interrupt, IRQF_SHARED, "at32psif", psif);
+	if (ret) {
+		dev_dbg(&pdev->dev, "could not request irq %d\n", irq);
+		goto out_put_clk;
+	}
+	psif->irq = irq;
+
+	io->id.type	= SERIO_8042;
+	io->write	= psif_write;
+	io->open	= psif_open;
+	io->close	= psif_close;
+	strlcpy(io->name, pdev->dev.bus_id, sizeof(io->name));
+	strlcpy(io->phys, pdev->dev.bus_id, sizeof(io->phys));
+	io->port_data	= psif;
+	io->dev.parent	= &pdev->dev;
+
+	psif_set_prescaler(psif);
+
+	spin_lock_init(&psif->lock);
+	serio_register_port(psif->io);
+	platform_set_drvdata(pdev, psif);
+
+	dev_info(&pdev->dev, "Atmel AVR32 PSIF PS/2 driver on 0x%08x irq %d\n",
+			(int)psif->regs, psif->irq);
+
+	return 0;
+
+out_put_clk:
+	clk_put(psif->pclk);
+out_iounmap:
+	iounmap(psif->regs);
+out_free_io:
+	kfree(io);
+out_free_psif:
+	kfree(psif);
+out:
+	return ret;
+}
+
+static int __exit psif_remove(struct platform_device *pdev)
+{
+	struct psif *psif = platform_get_drvdata(pdev);
+
+	psif_writel(psif, IDR, ~0UL);
+	psif_writel(psif, CR, PSIF_BIT(CR_TXDIS) | PSIF_BIT(CR_RXDIS));
+
+	serio_unregister_port(psif->io);
+	iounmap(psif->regs);
+	free_irq(psif->irq, psif);
+	clk_put(psif->pclk);
+	kfree(psif);
+
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int psif_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct psif *psif = platform_get_drvdata(pdev);
+
+	if (psif->open) {
+		psif_writel(psif, CR, PSIF_BIT(CR_RXDIS) | PSIF_BIT(CR_TXDIS));
+		clk_disable(psif->pclk);
+	}
+
+	return 0;
+}
+
+static int psif_resume(struct platform_device *pdev)
+{
+	struct psif *psif = platform_get_drvdata(pdev);
+
+	if (psif->open) {
+		clk_enable(psif->pclk);
+		psif_set_prescaler(psif);
+		psif_writel(psif, CR, PSIF_BIT(CR_RXEN) | PSIF_BIT(CR_TXEN));
+	}
+
+	return 0;
+}
+#else
+#define psif_suspend	NULL
+#define psif_resume	NULL
+#endif
+
+static struct platform_driver psif_driver = {
+	.remove		= __exit_p(psif_remove),
+	.driver		= {
+		.name	= "atmel_psif",
+	},
+	.suspend	= psif_suspend,
+	.resume		= psif_resume,
+};
+
+static int __init psif_init(void)
+{
+	return platform_driver_probe(&psif_driver, psif_probe);
+}
+
+static void __exit psif_exit(void)
+{
+	platform_driver_unregister(&psif_driver);
+}
+
+module_init(psif_init);
+module_exit(psif_exit);
+
+MODULE_AUTHOR("Hans-Christian Egtvedt <hcegtvedt@atmel.com>");
+MODULE_DESCRIPTION("Atmel AVR32 PSIF PS/2 driver");
+MODULE_LICENSE("GPL");
diff -puN /dev/null drivers/input/serio/at32psif.h
--- /dev/null
+++ a/drivers/input/serio/at32psif.h
@@ -0,0 +1,82 @@
+/*
+ * Copyright (C) 2007 Atmel Corporation
+ *
+ * Driver for the AT32AP700X PS/2 controller (PSIF).
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ */
+
+#ifndef _AT32PSIF_H
+#define _AT32PSIF_H
+
+/* PSIF register offsets */
+#define PSIF_CR				0x00
+#define PSIF_RHR			0x04
+#define PSIF_THR			0x08
+#define PSIF_SR				0x10
+#define PSIF_IER			0x14
+#define PSIF_IDR			0x18
+#define PSIF_IMR			0x1c
+#define PSIF_PSR			0x24
+
+/* Bitfields in control register. */
+#define PSIF_CR_RXDIS_OFFSET		1
+#define PSIF_CR_RXDIS_SIZE		1
+#define PSIF_CR_RXEN_OFFSET		0
+#define PSIF_CR_RXEN_SIZE		1
+#define PSIF_CR_SWRST_OFFSET		15
+#define PSIF_CR_SWRST_SIZE		1
+#define PSIF_CR_TXDIS_OFFSET		9
+#define PSIF_CR_TXDIS_SIZE		1
+#define PSIF_CR_TXEN_OFFSET		8
+#define PSIF_CR_TXEN_SIZE		1
+
+/* Bitfields in interrupt disable, enable, mask and status register. */
+#define PSIF_NACK_OFFSET		8
+#define PSIF_NACK_SIZE			1
+#define PSIF_OVRUN_OFFSET		5
+#define PSIF_OVRUN_SIZE			1
+#define PSIF_PARITY_OFFSET		9
+#define PSIF_PARITY_SIZE		1
+#define PSIF_RXRDY_OFFSET		4
+#define PSIF_RXRDY_SIZE			1
+#define PSIF_TXEMPTY_OFFSET		1
+#define PSIF_TXEMPTY_SIZE		1
+#define PSIF_TXRDY_OFFSET		0
+#define PSIF_TXRDY_SIZE			1
+
+/* Bitfields in prescale register. */
+#define PSIF_PSR_PRSCV_OFFSET		0
+#define PSIF_PSR_PRSCV_SIZE		12
+
+/* Bitfields in receive hold register. */
+#define PSIF_RHR_RXDATA_OFFSET		0
+#define PSIF_RHR_RXDATA_SIZE		8
+
+/* Bitfields in transmit hold register. */
+#define PSIF_THR_TXDATA_OFFSET		0
+#define PSIF_THR_TXDATA_SIZE		8
+
+/* Bit manipulation macros */
+#define PSIF_BIT(name)					\
+	(1 << PSIF_##name##_OFFSET)
+#define PSIF_BF(name, value)				\
+	(((value) & ((1 << PSIF_##name##_SIZE) - 1))	\
+	 << PSIF_##name##_OFFSET)
+#define PSIF_BFEXT(name, value)\
+	(((value) >> PSIF_##name##_OFFSET)		\
+	 & ((1 << PSIF_##name##_SIZE) - 1))
+#define PSIF_BFINS(name, value, old)			\
+	(((old) & ~(((1 << PSIF_##name##_SIZE) - 1)	\
+		    << PSIF_##name##_OFFSET))		\
+	 | PSIF_BF(name, value))
+
+/* Register access macros */
+#define psif_readl(port, reg)				\
+	__raw_readl((port)->regs + PSIF_##reg)
+#define psif_writel(port, reg, value)			\
+	__raw_writel((value), (port)->regs + PSIF_##reg)
+
+#endif /* _AT32PSIF_H */
_

Patches currently in -mm which might be from hcegtvedt@atmel.com are

git-alsa.patch
git-avr32.patch
input-core-driver-for-wm97xx-touchscreens-update.patch
input-core-driver-for-wm97xx-touchscreens-update-fix-typo.patch
input-driver-for-wm97xx-touchscreens-in-streaming-mode-on-mainstone-update.patch
ps-2-serio-driver-for-avr32-devices.patch

