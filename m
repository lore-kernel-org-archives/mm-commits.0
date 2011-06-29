From: akpm@linux-foundation.org
Subject: + x86-olpc-xo1-sci-add-gpe-handler-and-ebook-switch-functionality.patch added to -mm tree
Date: Wed, 29 Jun 2011 14:29:24 -0700
Message-ID: <201106292129.p5TLTPtw013101@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754148Ab1F2V3o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jun 2011 17:29:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dsd@laptop.org, dilinger@queued.net, grant.likely@secretlab.ca, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86, olpc-xo1-sci: add GPE handler and ebook switch functionality
has been added to the -mm tree.  Its filename is
     x86-olpc-xo1-sci-add-gpe-handler-and-ebook-switch-functionality.patch

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
Subject: x86, olpc-xo1-sci: add GPE handler and ebook switch functionality
From: Daniel Drake <dsd@laptop.org>

The EC in the OLPC XO-1 delivers GPE events to provide various
notifications.  Add the basic code for GPE/EC event processing and enable
the ebook switch, which can be used as a wakeup source.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Acked-by: Andres Salomon <dilinger@queued.net>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig                      |    2 
 arch/x86/include/asm/olpc.h           |    5 
 arch/x86/platform/olpc/olpc-xo1-sci.c |  183 +++++++++++++++++++++++-
 include/linux/cs5535.h                |   22 ++
 4 files changed, 209 insertions(+), 3 deletions(-)

diff -puN arch/x86/Kconfig~x86-olpc-xo1-sci-add-gpe-handler-and-ebook-switch-functionality arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86-olpc-xo1-sci-add-gpe-handler-and-ebook-switch-functionality
+++ a/arch/x86/Kconfig
@@ -2103,7 +2103,9 @@ config OLPC_XO1_SCI
 	select MFD_CORE
 	---help---
 	  Add support for SCI-based features of the OLPC XO-1 laptop:
+	   - EC-driven system wakeups
 	   - Power button
+	   - Ebook switch
 
 endif # X86_32
 
diff -puN arch/x86/include/asm/olpc.h~x86-olpc-xo1-sci-add-gpe-handler-and-ebook-switch-functionality arch/x86/include/asm/olpc.h
--- a/arch/x86/include/asm/olpc.h~x86-olpc-xo1-sci-add-gpe-handler-and-ebook-switch-functionality
+++ a/arch/x86/include/asm/olpc.h
@@ -111,6 +111,7 @@ extern int olpc_ec_cmd(unsigned char cmd
 #define EC_WRITE_SCI_MASK		0x1b
 #define EC_WAKE_UP_WLAN			0x24
 #define EC_WLAN_LEAVE_RESET		0x25
+#define EC_READ_EB_MODE			0x2a
 #define EC_SET_SCI_INHIBIT		0x32
 #define EC_SET_SCI_INHIBIT_RELEASE	0x34
 #define EC_WLAN_ENTER_RESET		0x35
@@ -144,7 +145,7 @@ extern int olpc_ec_cmd(unsigned char cmd
 #define OLPC_GPIO_SMB_CLK      14
 #define OLPC_GPIO_SMB_DATA     15
 #define OLPC_GPIO_WORKAUX	geode_gpio(24)
-#define OLPC_GPIO_LID		geode_gpio(26)
-#define OLPC_GPIO_ECSCI		geode_gpio(27)
+#define OLPC_GPIO_LID		26
+#define OLPC_GPIO_ECSCI		27
 
 #endif /* _ASM_X86_OLPC_H */
diff -puN arch/x86/platform/olpc/olpc-xo1-sci.c~x86-olpc-xo1-sci-add-gpe-handler-and-ebook-switch-functionality arch/x86/platform/olpc/olpc-xo1-sci.c
--- a/arch/x86/platform/olpc/olpc-xo1-sci.c~x86-olpc-xo1-sci-add-gpe-handler-and-ebook-switch-functionality
+++ a/arch/x86/platform/olpc/olpc-xo1-sci.c
@@ -12,12 +12,15 @@
  */
 
 #include <linux/cs5535.h>
+#include <linux/device.h>
+#include <linux/gpio.h>
 #include <linux/input.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/pm.h>
 #include <linux/mfd/core.h>
 #include <linux/suspend.h>
+#include <linux/workqueue.h>
 
 #include <asm/io.h>
 #include <asm/msr.h>
@@ -28,8 +31,60 @@
 
 static unsigned long acpi_base;
 static struct input_dev *power_button_idev;
+static struct input_dev *ebook_switch_idev;
+
 static int sci_irq;
 
+/* Report current ebook switch state through input layer */
+static void send_ebook_state(void)
+{
+	unsigned char state;
+
+	if (olpc_ec_cmd(EC_READ_EB_MODE, NULL, 0, &state, 1)) {
+		pr_err(PFX "failed to get ebook state\n");
+		return;
+	}
+
+	input_report_switch(ebook_switch_idev, SW_TABLET_MODE, state);
+	input_sync(ebook_switch_idev);
+}
+
+/*
+ * Process all items in the EC's SCI queue.
+ *
+ * This is handled in a workqueue because olpc_ec_cmd can be slow (and
+ * can even timeout).
+ *
+ * If propagate_events is false, the queue is drained without events being
+ * generated for the interrupts.
+ */
+static void process_sci_queue(bool propagate_events)
+{
+	int r;
+	u16 data;
+
+	do {
+		r = olpc_ec_sci_query(&data);
+		if (r || !data)
+			break;
+
+		pr_debug(PFX "SCI 0x%x received\n", data);
+
+		if (data == EC_SCI_SRC_EBOOK && propagate_events)
+			send_ebook_state();
+	} while (data);
+
+	if (r)
+		pr_err(PFX "Failed to clear SCI queue");
+}
+
+static void process_sci_queue_work(struct work_struct *work)
+{
+	process_sci_queue(true);
+}
+
+static DECLARE_WORK(sci_work, process_sci_queue_work);
+
 static irqreturn_t xo1_sci_intr(int irq, void *dev_id)
 {
 	struct platform_device *pdev = dev_id;
@@ -51,6 +106,11 @@ static irqreturn_t xo1_sci_intr(int irq,
 		input_sync(power_button_idev);
 	}
 
+	if (gpe & CS5536_GPIOM7_PME_FLAG) { /* EC GPIO */
+		cs5535_gpio_set(OLPC_GPIO_ECSCI, GPIO_NEGATIVE_EDGE_STS);
+		schedule_work(&sci_work);
+	}
+
 	return IRQ_HANDLED;
 }
 
@@ -60,6 +120,19 @@ static int xo1_sci_suspend(struct platfo
 		olpc_xo1_pm_wakeup_set(CS5536_PM_PWRBTN);
 	else
 		olpc_xo1_pm_wakeup_clear(CS5536_PM_PWRBTN);
+
+	if (device_may_wakeup(&ebook_switch_idev->dev))
+		olpc_ec_wakeup_set(EC_SCI_SRC_EBOOK);
+	else
+		olpc_ec_wakeup_clear(EC_SCI_SRC_EBOOK);
+
+	return 0;
+}
+
+static int xo1_sci_resume(struct platform_device *pdev)
+{
+	/* Enable all EC events */
+	olpc_ec_mask_write(EC_SCI_SRC_ALL);
 	return 0;
 }
 
@@ -104,6 +177,50 @@ static int __devinit setup_sci_interrupt
 	return r;
 }
 
+static int __devinit setup_ec_sci(void)
+{
+	int r;
+
+	r = gpio_request(OLPC_GPIO_ECSCI, "OLPC-ECSCI");
+	if (r)
+		return r;
+
+	gpio_direction_input(OLPC_GPIO_ECSCI);
+
+	/* Clear pending EC SCI events */
+	cs5535_gpio_set(OLPC_GPIO_ECSCI, GPIO_NEGATIVE_EDGE_STS);
+	cs5535_gpio_set(OLPC_GPIO_ECSCI, GPIO_POSITIVE_EDGE_STS);
+
+	/*
+	 * Enable EC SCI events, and map them to both a PME and the SCI
+	 * interrupt.
+	 *
+	 * Ordinarily, in addition to functioning as GPIOs, Geode GPIOs can
+	 * be mapped to regular interrupts *or* Geode-specific Power
+	 * Management Events (PMEs) - events that bring the system out of
+	 * suspend. In this case, we want both of those things - the system
+	 * wakeup, *and* the ability to get an interrupt when an event occurs.
+	 *
+	 * To achieve this, we map the GPIO to a PME, and then we use one
+	 * of the many generic knobs on the CS5535 PIC to additionally map the
+	 * PME to the regular SCI interrupt line.
+	 */
+	cs5535_gpio_set(OLPC_GPIO_ECSCI, GPIO_EVENTS_ENABLE);
+
+	/* Set the SCI to cause a PME event on group 7 */
+	cs5535_gpio_setup_event(OLPC_GPIO_ECSCI, 7, 1);
+
+	/* And have group 7 also fire the SCI interrupt */
+	cs5535_pic_unreqz_select_high(7, sci_irq);
+
+	return 0;
+}
+
+static void free_ec_sci(void)
+{
+	gpio_free(OLPC_GPIO_ECSCI);
+}
+
 static int __devinit setup_power_button(struct platform_device *pdev)
 {
 	int r;
@@ -135,6 +252,37 @@ static void free_power_button(void)
 	input_free_device(power_button_idev);
 }
 
+static int __devinit setup_ebook_switch(struct platform_device *pdev)
+{
+	int r;
+
+	ebook_switch_idev = input_allocate_device();
+	if (!ebook_switch_idev)
+		return -ENOMEM;
+
+	ebook_switch_idev->name = "EBook Switch";
+	ebook_switch_idev->phys = DRV_NAME "/input1";
+	set_bit(EV_SW, ebook_switch_idev->evbit);
+	set_bit(SW_TABLET_MODE, ebook_switch_idev->swbit);
+
+	ebook_switch_idev->dev.parent = &pdev->dev;
+	device_set_wakeup_capable(&ebook_switch_idev->dev, true);
+
+	r = input_register_device(ebook_switch_idev);
+	if (r) {
+		dev_err(&pdev->dev, "failed to register ebook switch: %d\n", r);
+		input_free_device(ebook_switch_idev);
+	}
+
+	return r;
+}
+
+static void free_ebook_switch(void)
+{
+	input_unregister_device(ebook_switch_idev);
+	input_free_device(ebook_switch_idev);
+}
+
 static int __devinit xo1_sci_probe(struct platform_device *pdev)
 {
 	struct resource *res;
@@ -159,10 +307,39 @@ static int __devinit xo1_sci_probe(struc
 	if (r)
 		return r;
 
+	r = setup_ebook_switch(pdev);
+	if (r)
+		goto err_ebook;
+
+	r = setup_ec_sci();
+	if (r)
+		goto err_ecsci;
+
+	/* Enable PME generation for EC-generated events */
+	outl(CS5536_GPIOM7_PME_EN, acpi_base + CS5536_PM_GPE0_EN);
+
+	/* Clear pending events */
+	outl(0xffffffff, acpi_base + CS5536_PM_GPE0_STS);
+	process_sci_queue(false);
+
+	/* Initial sync */
+	send_ebook_state();
+
 	r = setup_sci_interrupt(pdev);
 	if (r)
-		free_power_button();
+		goto err_sci;
 
+	/* Enable all EC events */
+	olpc_ec_mask_write(EC_SCI_SRC_ALL);
+
+	return r;
+
+err_sci:
+	free_ec_sci();
+err_ecsci:
+	free_ebook_switch();
+err_ebook:
+	free_power_button();
 	return r;
 }
 
@@ -170,6 +347,9 @@ static int __devexit xo1_sci_remove(stru
 {
 	mfd_cell_disable(pdev);
 	free_irq(sci_irq, pdev);
+	cancel_work_sync(&sci_work);
+	free_ec_sci();
+	free_ebook_switch();
 	free_power_button();
 	acpi_base = 0;
 	return 0;
@@ -182,6 +362,7 @@ static struct platform_driver xo1_sci_dr
 	.probe = xo1_sci_probe,
 	.remove = __devexit_p(xo1_sci_remove),
 	.suspend = xo1_sci_suspend,
+	.resume = xo1_sci_resume,
 };
 
 static int __init xo1_sci_init(void)
diff -puN include/linux/cs5535.h~x86-olpc-xo1-sci-add-gpe-handler-and-ebook-switch-functionality include/linux/cs5535.h
--- a/include/linux/cs5535.h~x86-olpc-xo1-sci-add-gpe-handler-and-ebook-switch-functionality
+++ a/include/linux/cs5535.h
@@ -11,6 +11,8 @@
 #ifndef _CS5535_H
 #define _CS5535_H
 
+#include <asm/msr.h>
+
 /* MSRs */
 #define MSR_GLIU_P2D_RO0	0x10000029
 
@@ -43,6 +45,18 @@
 #define MSR_GX_GLD_MSR_CONFIG	0xC0002001
 #define MSR_GX_MSR_PADSEL	0xC0002011
 
+static inline int cs5535_pic_unreqz_select_high(unsigned int group,
+						unsigned int irq)
+{
+	uint32_t lo, hi;
+
+	rdmsr(MSR_PIC_ZSEL_HIGH, lo, hi);
+	lo &= ~(0xF << (group * 4));
+	lo |= (irq & 0xF) << (group * 4);
+	wrmsr(MSR_PIC_ZSEL_HIGH, lo, hi);
+	return 0;
+}
+
 /* PIC registers */
 #define CS5536_PIC_INT_SEL1	0x4d0
 #define CS5536_PIC_INT_SEL2	0x4d1
@@ -73,6 +87,7 @@
 #define CS5536_PM1_EN		0x02
 #define CS5536_PM1_CNT		0x08
 #define CS5536_PM_GPE0_STS	0x18
+#define CS5536_PM_GPE0_EN	0x1c
 
 /* CS5536_PM1_STS bits */
 #define CS5536_WAK_FLAG		(1 << 15)
@@ -81,6 +96,13 @@
 /* CS5536_PM1_EN bits */
 #define CS5536_PM_PWRBTN	(1 << 8)
 
+/* CS5536_PM_GPE0_STS bits */
+#define CS5536_GPIOM7_PME_FLAG	(1 << 31)
+#define CS5536_GPIOM6_PME_FLAG	(1 << 30)
+
+/* CS5536_PM_GPE0_EN bits */
+#define CS5536_GPIOM7_PME_EN	(1 << 31)
+
 /* VSA2 magic values */
 #define VSA_VRC_INDEX		0xAC1C
 #define VSA_VRC_DATA		0xAC1E
_

Patches currently in -mm which might be from dsd@laptop.org are

linux-next.patch
x86-olpc-add-missing-elements-to-device-tree.patch
x86-olpc-move-cs5536-related-constants-to-cs5535h.patch
x86-olpc-rename-olpc-xo1-to-olpc-xo1-pm.patch
x86-olpc-add-xo-1-suspend-resume-support.patch
x86-olpc-add-xo-1-sci-driver-and-power-button-control.patch
x86-olpc-ec-sci-wakeup-mask-functionality.patch
x86-olpc-xo1-sci-add-gpe-handler-and-ebook-switch-functionality.patch
x86-olpc-xo1-sci-add-lid-switch-functionality.patch
x86-olpc-xo1-sci-propagate-power-supply-battery-events.patch
x86-olpc-add-xo-1-rtc-driver.patch
x86-olpc-add-xo-15-sci-driver.patch

