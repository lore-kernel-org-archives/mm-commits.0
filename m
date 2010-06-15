From: akpm@linux-foundation.org
Subject: + gpio-msm7200a-add-irq-support-to-msm-gpiolib.patch added to -mm tree
Date: Tue, 15 Jun 2010 13:12:41 -0700
Message-ID: <201006152012.o5FKCfin028203@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59911 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758187Ab0FOUNR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jun 2010 16:13:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gbean@codeaurora.org, bryanh@codeaurora.org, david-b@pacbell.net, davidb@codeaurora.org, dwalker@codeaurora.org


The patch titled
     gpio: msm7200a: add irq support to msm-gpiolib
has been added to the -mm tree.  Its filename is
     gpio-msm7200a-add-irq-support-to-msm-gpiolib.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: msm7200a: add irq support to msm-gpiolib
From: Gregory Bean <gbean@codeaurora.org>

Signed-off-by: Gregory Bean <gbean@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>
Cc: Daniel Walker <dwalker@codeaurora.org>
Cc: Bryan Huntsman <bryanh@codeaurora.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/msm7200a-gpio.c  |  203 +++++++++++++++++++++++++++++++-
 include/linux/msm7200a-gpio.h |    7 +
 2 files changed, 209 insertions(+), 1 deletion(-)

diff -puN drivers/gpio/msm7200a-gpio.c~gpio-msm7200a-add-irq-support-to-msm-gpiolib drivers/gpio/msm7200a-gpio.c
--- a/drivers/gpio/msm7200a-gpio.c~gpio-msm7200a-add-irq-support-to-msm-gpiolib
+++ a/drivers/gpio/msm7200a-gpio.c
@@ -23,13 +23,25 @@
 #include <linux/kernel.h>
 #include <linux/gpio.h>
 #include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/msm7200a-gpio.h>
 
+/*
+ * The INT_STATUS register latches both edge- and level-detection events,
+ * which is atypical.  Turning on DONT_LATCH_LEVEL_IRQS causes level irq
+ * triggers to be forgotten across mask/unmask calls, emulating a more
+ * traditional setup.
+ */
+#define MSM_GPIO_DONT_LATCH_LEVEL_IRQS 1
+
 struct msm_gpio_dev {
 	struct gpio_chip		gpio_chip;
 	spinlock_t			lock;
+	unsigned			irq_base;
+	unsigned			irq_summary;
 	struct msm7200a_gpio_regs	regs;
 };
 
@@ -119,12 +131,160 @@ static void gpio_chip_set(struct gpio_ch
 	spin_unlock_irqrestore(&msm_gpio->lock, irq_flags);
 }
 
+static int gpio_chip_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	struct msm_gpio_dev *msm_gpio = TO_MSM_GPIO_DEV(chip);
+	return msm_gpio->irq_base + offset;
+}
+
+#if MSM_GPIO_DONT_LATCH_LEVEL_IRQS
+static inline void forget_level_irq(struct msm_gpio_dev *msm_gpio,
+				unsigned offset)
+{
+	unsigned v = readl(msm_gpio->regs.int_edge);
+	unsigned b = bit(offset);
+
+	if (!(v & b))
+		writel(b, msm_gpio->regs.int_clear);
+
+}
+#else
+static inline void forget_level_irq(struct msm_gpio_dev *msm, unsigned off)
+{
+}
+#endif
+
+static void msm_gpio_irq_mask(unsigned int irq)
+{
+	unsigned long irq_flags;
+	struct msm_gpio_dev *msm_gpio = get_irq_chip_data(irq);
+	unsigned offset = irq - msm_gpio->irq_base;
+
+	spin_lock_irqsave(&msm_gpio->lock, irq_flags);
+	forget_level_irq(msm_gpio, offset);
+	clr_gpio_bit(offset, msm_gpio->regs.int_en);
+	spin_unlock_irqrestore(&msm_gpio->lock, irq_flags);
+}
+
+static void msm_gpio_irq_unmask(unsigned int irq)
+{
+	unsigned long irq_flags;
+	struct msm_gpio_dev *msm_gpio = get_irq_chip_data(irq);
+	unsigned offset = irq - msm_gpio->irq_base;
+
+	spin_lock_irqsave(&msm_gpio->lock, irq_flags);
+	forget_level_irq(msm_gpio, offset);
+	set_gpio_bit(offset, msm_gpio->regs.int_en);
+	spin_unlock_irqrestore(&msm_gpio->lock, irq_flags);
+}
+
+static int msm_gpio_irq_set_type(unsigned int irq, unsigned int flow_type)
+{
+	unsigned long irq_flags;
+	struct msm_gpio_dev *msm_gpio = get_irq_chip_data(irq);
+	unsigned offset = irq - msm_gpio->irq_base;
+
+	if ((flow_type & (IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING)) ==
+		(IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING))
+		return -ENOTSUPP;
+
+	if ((flow_type & (IRQF_TRIGGER_HIGH | IRQF_TRIGGER_LOW)) ==
+		(IRQF_TRIGGER_HIGH | IRQF_TRIGGER_LOW))
+		return -ENOTSUPP;
+
+	spin_lock_irqsave(&msm_gpio->lock, irq_flags);
+
+	if (flow_type & (IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING)) {
+		set_gpio_bit(offset, msm_gpio->regs.int_edge);
+		irq_desc[irq].handle_irq = handle_edge_irq;
+	} else {
+		clr_gpio_bit(offset, msm_gpio->regs.int_edge);
+		irq_desc[irq].handle_irq = handle_level_irq;
+	}
+
+	if (flow_type & (IRQF_TRIGGER_HIGH | IRQF_TRIGGER_RISING))
+		set_gpio_bit(offset, msm_gpio->regs.int_pos);
+	else
+		clr_gpio_bit(offset, msm_gpio->regs.int_pos);
+
+	spin_unlock_irqrestore(&msm_gpio->lock, irq_flags);
+
+	return 0;
+}
+
+static void msm_gpio_irq_mask_ack(unsigned int irq)
+{
+	msm_gpio_irq_mask(irq);
+}
+
+static int msm_gpio_irq_set_affinity(unsigned int irq,
+				const struct cpumask *dest)
+{
+	return -ENOTSUPP;
+}
+
+static int msm_gpio_irq_retrigger(unsigned int irq)
+{
+	return -ENOTSUPP;
+}
+
+static int msm_gpio_irq_set_wake(unsigned int irq, unsigned int on)
+{
+	return -ENOTSUPP;
+}
+
+static irqreturn_t msm_gpio_irq_handler(int irq, void *dev)
+{
+	unsigned long irq_flags;
+	int b, m;
+	unsigned e, s, v;
+
+	struct msm_gpio_dev *msm_gpio = (struct msm_gpio_dev *)dev;
+
+	/*
+	 * The int_status register latches trigger events whether or not
+	 * the gpio line is enabled as an interrupt source.  Therefore,
+	 * the set of pins which defines the interrupts which need to fire
+	 * is the intersection of int_status and int_en - int_status
+	 * alone provides an incomplete picture.
+	 */
+	spin_lock_irqsave(&msm_gpio->lock, irq_flags);
+	s = readl(msm_gpio->regs.int_status);
+	e = readl(msm_gpio->regs.int_en);
+	v = s & e;
+	if (v)
+		writel(v, msm_gpio->regs.int_clear);
+	spin_unlock_irqrestore(&msm_gpio->lock, irq_flags);
+
+	if (!v)
+		return IRQ_NONE;
+
+	while (v) {
+		m = v & -v;
+		b = fls(m) - 1;
+		v &= ~m;
+		generic_handle_irq(msm_gpio->irq_base + b);
+	}
+	return IRQ_HANDLED;
+}
+
+static struct irq_chip msm_gpio_irq_chip = {
+	.name			= "msm_gpio",
+	.mask			= msm_gpio_irq_mask,
+	.mask_ack		= msm_gpio_irq_mask_ack,
+	.unmask			= msm_gpio_irq_unmask,
+	.set_affinity		= msm_gpio_irq_set_affinity,
+	.retrigger		= msm_gpio_irq_retrigger,
+	.set_type		= msm_gpio_irq_set_type,
+	.set_wake		= msm_gpio_irq_set_wake,
+};
+
 static int msm_gpio_probe(struct platform_device *dev)
 {
 	struct msm_gpio_dev *msm_gpio;
 	struct msm7200a_gpio_platform_data *pdata =
 		(struct msm7200a_gpio_platform_data *)dev->dev.platform_data;
-	int ret;
+	int i, irq, ret;
 
 	if (!pdata)
 		return -EINVAL;
@@ -146,12 +306,52 @@ static int msm_gpio_probe(struct platfor
 	msm_gpio->gpio_chip.direction_output = gpio_chip_direction_output;
 	msm_gpio->gpio_chip.get              = gpio_chip_get;
 	msm_gpio->gpio_chip.set              = gpio_chip_set;
+	msm_gpio->gpio_chip.to_irq           = gpio_chip_to_irq;
+	msm_gpio->irq_base                   = pdata->irq_base;
+	msm_gpio->irq_summary                = pdata->irq_summary;
 
 	ret = gpiochip_add(&msm_gpio->gpio_chip);
 	if (ret < 0)
 		goto err_post_malloc;
 
+	for (i = 0; i < msm_gpio->gpio_chip.ngpio; ++i) {
+		irq = msm_gpio->irq_base + i;
+		set_irq_chip_data(irq, msm_gpio);
+		set_irq_chip(irq, &msm_gpio_irq_chip);
+		set_irq_handler(irq, handle_level_irq);
+		set_irq_flags(irq, IRQF_VALID);
+	}
+
+	/*
+	 * We use a level-triggered interrupt because of the nature
+	 * of the shared GPIO-group interrupt.
+	 *
+	 * Many GPIO chips may be sharing the same group IRQ line, and
+	 * it is possible for GPIO interrupt to re-occur while the system
+	 * is still servicing the group interrupt associated with it.
+	 * The group IRQ line would not de-assert and re-assert, and
+	 * we'd get no second edge to cause the group IRQ to be handled again.
+	 *
+	 * Using a level interrupt guarantees that the group IRQ handlers
+	 * will continue to be called as long as any GPIO chip in the group
+	 * is asserting, even if the condition began while the group
+	 * handler was in mid-pass.
+	 */
+	ret = request_irq(msm_gpio->irq_summary,
+			  msm_gpio_irq_handler,
+			  IRQF_SHARED | IRQF_TRIGGER_HIGH,
+			  dev->name,
+			  msm_gpio);
+	if (ret < 0)
+		goto err_post_gpiochip_add;
+
 	return ret;
+err_post_gpiochip_add:
+	/*
+	 * Under no circumstances should a line be held on a gpiochip
+	 * which hasn't finished probing.
+	 */
+	BUG_ON(gpiochip_remove(&msm_gpio->gpio_chip) < 0);
 err_post_malloc:
 	kfree(msm_gpio);
 	return ret;
@@ -165,6 +365,7 @@ static int msm_gpio_remove(struct platfo
 	if (ret < 0)
 		return ret;
 
+	free_irq(msm_gpio->irq_summary, msm_gpio);
 	kfree(msm_gpio);
 
 	return 0;
diff -puN include/linux/msm7200a-gpio.h~gpio-msm7200a-add-irq-support-to-msm-gpiolib include/linux/msm7200a-gpio.h
--- a/include/linux/msm7200a-gpio.h~gpio-msm7200a-add-irq-support-to-msm-gpiolib
+++ a/include/linux/msm7200a-gpio.h
@@ -33,11 +33,18 @@ struct msm7200a_gpio_regs {
 	void __iomem *in;
 	void __iomem *out;
 	void __iomem *oe;
+	void __iomem *int_status;
+	void __iomem *int_clear;
+	void __iomem *int_en;
+	void __iomem *int_edge;
+	void __iomem *int_pos;
 };
 
 struct msm7200a_gpio_platform_data {
 	unsigned gpio_base;
 	unsigned ngpio;
+	unsigned irq_base;
+	unsigned irq_summary;
 	struct msm7200a_gpio_regs regs;
 };
 
_

Patches currently in -mm which might be from gbean@codeaurora.org are

gpio-msm7200a-add-gpiolib-support-for-msm-chips.patch
gpio-msm7200a-add-irq-support-to-msm-gpiolib.patch

