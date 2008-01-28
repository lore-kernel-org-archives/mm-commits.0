From: akpm@linux-foundation.org
Subject: + basic-pwm-driver-for-avr32-and-at91.patch added to -mm tree
Date: Sun, 27 Jan 2008 21:28:48 -0800
Message-ID: <200801280529.m0S5ThY8013996@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47296 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750750AbYA1FaW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 00:30:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net, hskinnemoen@atmel.com, linux@maxim.org.za, nicolas.ferre@atmel.com


The patch titled
     Basic PWM driver for AVR32 and AT91
has been added to the -mm tree.  Its filename is
     basic-pwm-driver-for-avr32-and-at91.patch

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
Subject: Basic PWM driver for AVR32 and AT91
From: David Brownell <david-b@pacbell.net>

PWM device setup, and a simple PWM driver exposing a programming interface
giving access to each channel's full capabilities.  Note that this doesn't
support starting several channels in synch.

[hskinnemoen@atmel.com: allocate platform device dynamically]
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Andrew Victor <linux@maxim.org.za>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/mach-at32ap/at32ap700x.c   |   54 +++
 drivers/misc/Kconfig                  |    9 
 drivers/misc/Makefile                 |    1 
 drivers/misc/atmel_pwm.c              |  409 ++++++++++++++++++++++++
 include/asm-avr32/arch-at32ap/board.h |    3 
 include/linux/atmel_pwm.h             |   70 ++++
 6 files changed, 546 insertions(+)

diff -puN arch/avr32/mach-at32ap/at32ap700x.c~basic-pwm-driver-for-avr32-and-at91 arch/avr32/mach-at32ap/at32ap700x.c
--- a/arch/avr32/mach-at32ap/at32ap700x.c~basic-pwm-driver-for-avr32-and-at91
+++ a/arch/avr32/mach-at32ap/at32ap700x.c
@@ -1185,6 +1185,59 @@ err_dup_modedb:
 #endif
 
 /* --------------------------------------------------------------------
+ *  PWM
+ * -------------------------------------------------------------------- */
+static struct resource atmel_pwm0_resource[] __initdata = {
+	PBMEM(0xfff01400),
+	IRQ(24),
+};
+static struct clk atmel_pwm0_mck = {
+	.name		= "mck",
+	.parent		= &pbb_clk,
+	.mode		= pbb_clk_mode,
+	.get_rate	= pbb_clk_get_rate,
+	.index		= 5,
+};
+
+struct platform_device *__init at32_add_device_pwm(u32 mask)
+{
+	struct platform_device *pdev;
+
+	if (!mask)
+		return NULL;
+
+	pdev = platform_device_alloc("atmel_pwm", 0);
+	if (!pdev)
+		return NULL;
+
+	if (platform_device_add_resources(pdev, atmel_pwm0_resource,
+				ARRAY_SIZE(atmel_pwm0_resource)))
+		goto out_free_pdev;
+
+	if (platform_device_add_data(pdev, &mask, sizeof(mask)))
+		goto out_free_pdev;
+
+	if (mask & (1 << 0))
+		select_peripheral(PA(28), PERIPH_A, 0);
+	if (mask & (1 << 1))
+		select_peripheral(PA(29), PERIPH_A, 0);
+	if (mask & (1 << 2))
+		select_peripheral(PA(21), PERIPH_B, 0);
+	if (mask & (1 << 3))
+		select_peripheral(PA(22), PERIPH_B, 0);
+
+	atmel_pwm0_mck.dev = &pdev->dev;
+
+	platform_device_add(pdev);
+
+	return pdev;
+
+out_free_pdev:
+	platform_device_put(pdev);
+	return NULL;
+}
+
+/* --------------------------------------------------------------------
  *  SSC
  * -------------------------------------------------------------------- */
 static struct resource ssc0_resource[] = {
@@ -1645,6 +1698,7 @@ struct clk *at32_clock_list[] = {
 	&atmel_usart1_usart,
 	&atmel_usart2_usart,
 	&atmel_usart3_usart,
+	&atmel_pwm0_mck,
 #if defined(CONFIG_CPU_AT32AP7000)
 	&macb0_hclk,
 	&macb0_pclk,
diff -puN drivers/misc/Kconfig~basic-pwm-driver-for-avr32-and-at91 drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~basic-pwm-driver-for-avr32-and-at91
+++ a/drivers/misc/Kconfig
@@ -13,6 +13,15 @@ menuconfig MISC_DEVICES
 
 if MISC_DEVICES
 
+config ATMEL_PWM
+	tristate "Atmel AT32/AT91 PWM support"
+	depends on (AVR32 || AT91) && EXPERIMENTAL
+	help
+	  This option enables device driver support for the PWM channels
+	  on certain Atmel prcoessors.  Pulse Width Modulation is used for
+	  purposes including software controlled power-efficent backlights
+	  on LCD displays, motor control, and waveform generation.
+
 config IBM_ASM
 	tristate "Device driver for IBM RSA service processor"
 	depends on X86 && PCI && INPUT && EXPERIMENTAL
diff -puN drivers/misc/Makefile~basic-pwm-driver-for-avr32-and-at91 drivers/misc/Makefile
--- a/drivers/misc/Makefile~basic-pwm-driver-for-avr32-and-at91
+++ a/drivers/misc/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_IBM_ASM)		+= ibmasm/
 obj-$(CONFIG_HDPU_FEATURES)	+= hdpuftrs/
 obj-$(CONFIG_MSI_LAPTOP)     += msi-laptop.o
 obj-$(CONFIG_ASUS_LAPTOP)     += asus-laptop.o
+obj-$(CONFIG_ATMEL_PWM)		+= atmel_pwm.o
 obj-$(CONFIG_ATMEL_SSC)		+= atmel-ssc.o
 obj-$(CONFIG_LKDTM)		+= lkdtm.o
 obj-$(CONFIG_TIFM_CORE)       	+= tifm_core.o
diff -puN /dev/null drivers/misc/atmel_pwm.c
--- /dev/null
+++ a/drivers/misc/atmel_pwm.c
@@ -0,0 +1,409 @@
+#include <linux/module.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/atmel_pwm.h>
+
+
+/*
+ * This is a simple driver for the PWM controller found in various newer
+ * Atmel SOCs, including the AVR32 series and the AT91sam9263.
+ *
+ * Chips with current Linux ports have only 4 PWM channels, out of max 32.
+ * AT32UC3A and AT32UC3B chips have 7 channels (but currently no Linux).
+ * Docs are inconsistent about the width of the channel counter registers;
+ * it's at least 16 bits, but several places say 20 bits.
+ */
+#define	PWM_NCHAN	4		/* max 32 */
+
+struct pwm {
+	spinlock_t		lock;
+	struct platform_device	*pdev;
+	u32			mask;
+	int			irq;
+	void __iomem		*base;
+	struct clk		*clk;
+	struct pwm_channel	*channel[PWM_NCHAN];
+	void			(*handler[PWM_NCHAN])(struct pwm_channel *);
+};
+
+
+/* global PWM controller registers */
+#define PWM_MR		0x00
+#define PWM_ENA		0x04
+#define PWM_DIS		0x08
+#define PWM_SR		0x0c
+#define PWM_IER		0x10
+#define PWM_IDR		0x14
+#define PWM_IMR		0x18
+#define PWM_ISR		0x1c
+
+static inline void pwm_writel(const struct pwm *p, unsigned offset, u32 val)
+{
+	__raw_writel(val, p->base + offset);
+}
+
+static inline u32 pwm_readl(const struct pwm *p, unsigned offset)
+{
+	return __raw_readl(p->base + offset);
+}
+
+static inline void __iomem *pwmc_regs(const struct pwm *p, int index)
+{
+	return p->base + 0x200 + index * 0x20;
+}
+
+static struct pwm *pwm;
+
+static void pwm_dumpregs(struct pwm_channel *ch, char *tag)
+{
+	struct device	*dev = &pwm->pdev->dev;
+
+	dev_dbg(dev, "%s: mr %08x, sr %08x, imr %08x\n",
+		tag,
+		pwm_readl(pwm, PWM_MR),
+		pwm_readl(pwm, PWM_SR),
+		pwm_readl(pwm, PWM_IMR));
+	dev_dbg(dev,
+		"pwm ch%d - mr %08x, dty %u, prd %u, cnt %u\n",
+		ch->index,
+		pwm_channel_readl(ch, PWM_CMR),
+		pwm_channel_readl(ch, PWM_CDTY),
+		pwm_channel_readl(ch, PWM_CPRD),
+		pwm_channel_readl(ch, PWM_CCNT));
+}
+
+
+/**
+ * pwm_channel_alloc - allocate an unused PWM channel
+ * @index: identifies the channel
+ * @ch: structure to be initialized
+ *
+ * Drivers allocate PWM channels according to the board's wiring, and
+ * matching board-specific setup code.  Returns zero or negative errno.
+ */
+int pwm_channel_alloc(int index, struct pwm_channel *ch)
+{
+	unsigned long	flags;
+	int		status = 0;
+
+	/* insist on PWM init, with this signal pinned out */
+	if (!pwm || !(pwm->mask & 1 << index))
+		return -ENODEV;
+
+	if (index < 0 || index >= PWM_NCHAN || !ch)
+		return -EINVAL;
+	memset(ch, 0, sizeof *ch);
+
+	spin_lock_irqsave(&pwm->lock, flags);
+	if (pwm->channel[index])
+		status = -EBUSY;
+	else {
+		clk_enable(pwm->clk);
+
+		ch->regs = pwmc_regs(pwm, index);
+		ch->index = index;
+
+		/* REVISIT: ap7000 seems to go 2x as fast as we expect!! */
+		ch->mck = clk_get_rate(pwm->clk);
+
+		pwm->channel[index] = ch;
+		pwm->handler[index] = NULL;
+
+		/* channel and irq are always disabled when we return */
+		pwm_writel(pwm, PWM_DIS, 1 << index);
+		pwm_writel(pwm, PWM_IDR, 1 << index);
+	}
+	spin_unlock_irqrestore(&pwm->lock, flags);
+	return status;
+}
+EXPORT_SYMBOL(pwm_channel_alloc);
+
+static int pwmcheck(struct pwm_channel *ch)
+{
+	int		index;
+
+	if (!pwm)
+		return -ENODEV;
+	if (!ch)
+		return -EINVAL;
+	index = ch->index;
+	if (index < 0 || index >= PWM_NCHAN || pwm->channel[index] != ch)
+		return -EINVAL;
+
+	return index;
+}
+
+/**
+ * pwm_channel_free - release a previously allocated channel
+ * @ch: the channel being released
+ *
+ * The channel is completely shut down (counter and IRQ disabled),
+ * and made available for re-use.  Returns zero, or negative errno.
+ */
+int pwm_channel_free(struct pwm_channel *ch)
+{
+	unsigned long	flags;
+	int		t;
+
+	spin_lock_irqsave(&pwm->lock, flags);
+	t = pwmcheck(ch);
+	if (t >= 0) {
+		pwm->channel[t] = NULL;
+		pwm->handler[t] = NULL;
+
+		/* channel and irq are always disabled when we return */
+		pwm_writel(pwm, PWM_DIS, 1 << t);
+		pwm_writel(pwm, PWM_IDR, 1 << t);
+
+		clk_disable(pwm->clk);
+		t = 0;
+	}
+	spin_unlock_irqrestore(&pwm->lock, flags);
+	return t;
+}
+EXPORT_SYMBOL(pwm_channel_free);
+
+int __pwm_channel_onoff(struct pwm_channel *ch, int enabled)
+{
+	unsigned long	flags;
+	int		t;
+
+	/* OMITTED FUNCTIONALITY:  starting several channels in synch */
+
+	spin_lock_irqsave(&pwm->lock, flags);
+	t = pwmcheck(ch);
+	if (t >= 0) {
+		pwm_writel(pwm, enabled ? PWM_ENA : PWM_DIS, 1 << t);
+		t = 0;
+		pwm_dumpregs(ch, enabled ? "enable" : "disable");
+	}
+	spin_unlock_irqrestore(&pwm->lock, flags);
+
+	return t;
+}
+EXPORT_SYMBOL(__pwm_channel_onoff);
+
+/**
+ * pwm_clk_alloc - allocate and configure CLKA or CLKB
+ * @prescale: from 0..10, the power of two used to divide MCK
+ * @div: from 1..255, the linear divisor to use
+ *
+ * Returns PWM_CPR_CLKA, PWM_CPR_CLKB, or negative errno.  The allocated
+ * clock will run with a period of (2^prescale * div) / MCK, or twice as
+ * long if center aligned PWM output is used.  The clock must later be
+ * deconfigured using pwm_clk_free().
+ */
+int pwm_clk_alloc(unsigned prescale, unsigned div)
+{
+	unsigned long	flags;
+	u32		mr;
+	u32		val = (prescale << 8) | div;
+	int		ret = -EBUSY;
+
+	if (prescale >= 10 || div == 0 || div > 255)
+		return -EINVAL;
+
+	spin_lock_irqsave(&pwm->lock, flags);
+	mr = pwm_readl(pwm, PWM_MR);
+	if ((mr & 0xffff) == 0) {
+		mr |= val;
+		ret = PWM_CPR_CLKA;
+	}
+	if ((mr & (0xffff << 16)) == 0) {
+		mr |= val << 16;
+		ret = PWM_CPR_CLKB;
+	}
+	if (ret > 0)
+		pwm_writel(pwm, PWM_MR, mr);
+	spin_unlock_irqrestore(&pwm->lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL(pwm_clk_alloc);
+
+/**
+ * pwm_clk_free - deconfigure and release CLKA or CLKB
+ *
+ * Reverses the effect of pwm_clk_alloc().
+ */
+void pwm_clk_free(unsigned clk)
+{
+	unsigned long	flags;
+	u32		mr;
+
+	spin_lock_irqsave(&pwm->lock, flags);
+	mr = pwm_readl(pwm, PWM_MR);
+	if (clk == PWM_CPR_CLKA)
+		pwm_writel(pwm, PWM_MR, mr & ~(0xffff << 0));
+	if (clk == PWM_CPR_CLKB)
+		pwm_writel(pwm, PWM_MR, mr & ~(0xffff << 16));
+	spin_unlock_irqrestore(&pwm->lock, flags);
+}
+EXPORT_SYMBOL(pwm_clk_free);
+
+/**
+ * pwm_channel_handler - manage channel's IRQ handler
+ * @ch: the channel
+ * @handler: the handler to use, possibly NULL
+ *
+ * If the handler is non-null, the handler will be called after every
+ * period of this PWM channel.  If the handler is null, this channel
+ * won't generate an IRQ.
+ */
+int pwm_channel_handler(struct pwm_channel *ch,
+		void (*handler)(struct pwm_channel *ch))
+{
+	unsigned long	flags;
+	int		t;
+
+	spin_lock_irqsave(&pwm->lock, flags);
+	t = pwmcheck(ch);
+	if (t >= 0) {
+		pwm->handler[t] = handler;
+		pwm_writel(pwm, handler ? PWM_IER : PWM_IDR, 1 << t);
+		t = 0;
+	}
+	spin_unlock_irqrestore(&pwm->lock, flags);
+
+	return t;
+}
+EXPORT_SYMBOL(pwm_channel_handler);
+
+static irqreturn_t pwm_irq(int id, void *_pwm)
+{
+	struct pwm	*p = _pwm;
+	irqreturn_t	handled = IRQ_NONE;
+	u32		irqstat;
+	int		index;
+
+	spin_lock(&p->lock);
+
+	/* ack irqs, then handle them */
+	irqstat = pwm_readl(pwm, PWM_ISR);
+
+	while (irqstat) {
+		struct pwm_channel *ch;
+		void (*handler)(struct pwm_channel *ch);
+
+		index = ffs(irqstat) - 1;
+		irqstat &= ~(1 << index);
+		ch = pwm->channel[index];
+		handler = pwm->handler[index];
+		if (handler && ch) {
+			spin_unlock(&p->lock);
+			handler(ch);
+			spin_lock(&p->lock);
+			handled = IRQ_HANDLED;
+		}
+	}
+
+	spin_unlock(&p->lock);
+	return handled;
+}
+
+static int __init pwm_probe(struct platform_device *pdev)
+{
+	struct resource *r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	int irq = platform_get_irq(pdev, 0);
+	u32 *mp = pdev->dev.platform_data;
+	struct pwm *p;
+	int status = -EIO;
+
+	if (pwm)
+		return -EBUSY;
+	if (!r || irq < 0 || !mp || !*mp)
+		return -ENODEV;
+	if (*mp & ~((1<<PWM_NCHAN)-1)) {
+		dev_warn(&pdev->dev, "mask 0x%x ... more than %d channels\n",
+			*mp, PWM_NCHAN);
+		return -EINVAL;
+	}
+
+	p = kzalloc(sizeof(*p), GFP_KERNEL);
+	if (!p)
+		return -ENOMEM;
+
+	spin_lock_init(&p->lock);
+	p->pdev = pdev;
+	p->mask = *mp;
+	p->irq = irq;
+	p->base = ioremap(r->start, r->end - r->start + 1);
+	if (!p->base)
+		goto fail;
+	p->clk = clk_get(&pdev->dev, "mck");
+	if (IS_ERR(p->clk)) {
+		status = PTR_ERR(p->clk);
+		p->clk = NULL;
+		goto fail;
+	}
+
+	status = request_irq(irq, pwm_irq, 0, pdev->name, p);
+	if (status < 0)
+		goto fail;
+
+	pwm = p;
+	platform_set_drvdata(pdev, p);
+
+	return 0;
+
+fail:
+	if (p->clk)
+		clk_put(p->clk);
+	if (p->base)
+		iounmap(p->base);
+
+	kfree(p);
+	return status;
+}
+
+static int __exit pwm_remove(struct platform_device *pdev)
+{
+	struct pwm *p = platform_get_drvdata(pdev);
+
+	if (p != pwm)
+		return -EINVAL;
+
+	clk_enable(pwm->clk);
+	pwm_writel(pwm, PWM_DIS, (1 << PWM_NCHAN) - 1);
+	pwm_writel(pwm, PWM_IDR, (1 << PWM_NCHAN) - 1);
+	clk_disable(pwm->clk);
+
+	pwm = NULL;
+
+	free_irq(p->irq, p);
+	clk_put(p->clk);
+	iounmap(p->base);
+	kfree(p);
+
+	return 0;
+}
+
+static struct platform_driver atmel_pwm_driver = {
+	.driver = {
+		.name = "atmel_pwm",
+		.owner = THIS_MODULE,
+	},
+	.remove = __exit_p(pwm_remove),
+
+	/* NOTE: PWM can keep running in AVR32 "idle" and "frozen" states;
+	 * and all AT91sam9263 states, albeit at reduced clock rate if
+	 * MCK becomes the slow clock (i.e. what Linux labels STR).
+	 */
+};
+
+static int __init pwm_init(void)
+{
+	return platform_driver_probe(&atmel_pwm_driver, pwm_probe);
+}
+module_init(pwm_init);
+
+static void __exit pwm_exit(void)
+{
+	platform_driver_unregister(&atmel_pwm_driver);
+}
+module_exit(pwm_exit);
+
+MODULE_DESCRIPTION("Driver for AT32/AT91 PWM module");
+MODULE_LICENSE("GPL");
diff -puN include/asm-avr32/arch-at32ap/board.h~basic-pwm-driver-for-avr32-and-at91 include/asm-avr32/arch-at32ap/board.h
--- a/include/asm-avr32/arch-at32ap/board.h~basic-pwm-driver-for-avr32-and-at91
+++ a/include/asm-avr32/arch-at32ap/board.h
@@ -51,6 +51,9 @@ struct platform_device *
 at32_add_device_ide(unsigned int id, unsigned int extint,
 		    struct ide_platform_data *data);
 
+/* mask says which PWM channels to mux */
+struct platform_device *at32_add_device_pwm(u32 mask);
+
 /* depending on what's hooked up, not all SSC pins will be used */
 #define	ATMEL_SSC_TK		0x01
 #define	ATMEL_SSC_TF		0x02
diff -puN /dev/null include/linux/atmel_pwm.h
--- /dev/null
+++ a/include/linux/atmel_pwm.h
@@ -0,0 +1,70 @@
+#ifndef __LINUX_ATMEL_PWM_H
+#define __LINUX_ATMEL_PWM_H
+
+/**
+ * struct pwm_channel - driver handle to a PWM channel
+ * @regs: base of this channel's registers
+ * @index: number of this channel (0..31)
+ * @mck: base clock rate, which can be prescaled and maybe subdivided
+ *
+ * Drivers initialize a pwm_channel structure using pwm_channel_alloc().
+ * Then they configure its clock rate (derived from MCK), alignment,
+ * polarity, and duty cycle by writing directly to the channel registers,
+ * before enabling the channel by calling pwm_channel_enable().
+ *
+ * After emitting a PWM signal for the desired length of time, drivers
+ * may then pwm_channel_disable() or pwm_channel_free().  Both of these
+ * disable the channel, but when it's freed the IRQ is deconfigured and
+ * the channel must later be re-allocated and reconfigured.
+ *
+ * Note that if the period or duty cycle need to be changed while the
+ * PWM channel is operating, drivers must use the PWM_CUPD double buffer
+ * mechanism, either polling until they change or getting implicitly
+ * notified through a once-per-period interrupt handler.
+ */
+struct pwm_channel {
+	void __iomem	*regs;
+	unsigned	index;
+	unsigned long	mck;
+};
+
+extern int pwm_channel_alloc(int index, struct pwm_channel *ch);
+extern int pwm_channel_free(struct pwm_channel *ch);
+
+extern int pwm_clk_alloc(unsigned prescale, unsigned div);
+extern void pwm_clk_free(unsigned clk);
+
+extern int __pwm_channel_onoff(struct pwm_channel *ch, int enabled);
+
+#define pwm_channel_enable(ch)	__pwm_channel_onoff((ch), 1)
+#define pwm_channel_disable(ch)	__pwm_channel_onoff((ch), 0)
+
+/* periodic interrupts, mostly for CUPD changes to period or cycle */
+extern int pwm_channel_handler(struct pwm_channel *ch,
+		void (*handler)(struct pwm_channel *ch));
+
+/* per-channel registers (banked at pwm_channel->regs) */
+#define PWM_CMR		0x00		/* mode register */
+#define		PWM_CPR_CPD	(1 << 10)	/* set: CUPD modifies period */
+#define		PWM_CPR_CPOL	(1 << 9)	/* set: idle high */
+#define		PWM_CPR_CALG	(1 << 8)	/* set: center align */
+#define		PWM_CPR_CPRE	(0xf << 0)	/* mask: rate is mck/(2^pre) */
+#define		PWM_CPR_CLKA	(0xb << 0)	/* rate CLKA */
+#define		PWM_CPR_CLKB	(0xc << 0)	/* rate CLKB */
+#define PWM_CDTY	0x04		/* duty cycle (max of CPRD) */
+#define PWM_CPRD	0x08		/* period (count up from zero) */
+#define PWM_CCNT	0x0c		/* counter (20 bits?) */
+#define PWM_CUPD	0x10		/* update CPRD (or CDTY) next period */
+
+static inline void
+pwm_channel_writel(struct pwm_channel *pwmc, unsigned offset, u32 val)
+{
+	__raw_writel(val, pwmc->regs + offset);
+}
+
+static inline u32 pwm_channel_readl(struct pwm_channel *pwmc, unsigned offset)
+{
+	return __raw_readl(pwmc->regs + offset);
+}
+
+#endif /* __LINUX_ATMEL_PWM_H */
_

Patches currently in -mm which might be from david-b@pacbell.net are

git-acpi.patch
git-arm.patch
at91-correct-at91sam9263ek-lcd-power-gpio-pin.patch
i2c-isp1301_omap-new-style-i2c-driver-updates-part-1.patch
i2c-isp1301_omap-new-style-i2c-driver-updates-part-2.patch
git-input.patch
git-mmc.patch
git-mtd.patch
pcmcia-stop-updating-dev-powerpower_state.patch
usb-dma-bounce-buffer-support-v3-fix.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
remove-pointless-casts-from-void-pointers.patch
spi-core-stop-updating-dev-powerpower_state.patch
spi-s3c-drivers-shouldnt-care-about-spi_board_info.patch
cosmetic-fixes-to-rtc-subsystems-kconfig.patch
rtc-pcf8583-dont-abuse-i2c_m_nostart.patch
rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch
rtc-cmos-exports-nvram-in-sysfs.patch
rtc-cmos-alarm-acts-as-oneshot.patch
platform-real-time-clock-driver-for-dallas-1511-chip.patch
make-config_hpet_emulate_rtc-usable-from-modules.patch
use-the-irq-callback-interface-in-old-rtc-driver.patch
add-hpet-rtc-emulation-to-rtc_drv_cmos.patch
rtc-add-support-for-epson-rtc-9701je-v2.patch
rtc-add-support-for-epson-rtc-9701je-v4.patch
w1-gpio-add-gpio-w1-bus-master-driver.patch
w1-gpio-add-gpio-w1-bus-master-driver-v3.patch
basic-pwm-driver-for-avr32-and-at91.patch
basic-pwm-driver-for-avr32-and-at91-fix.patch
pwm-led-driver.patch
