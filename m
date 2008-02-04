From: akpm@linux-foundation.org
Subject: + rtc-at91sam9-rtc-support-rtt-and-or-rtc.patch added to -mm tree
Date: Mon, 04 Feb 2008 14:48:53 -0800
Message-ID: <200802042248.m14Mmrlo022052@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34881 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755619AbYBDWt1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2008 17:49:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net, linux@maxim.org.za, murpme@gmail.com, nicolas.ferre@rfo.atmel.com, rmk@arm.linux.org.uk


The patch titled
     rtc: at91sam9 RTC support (RTT and/or RTC)
has been added to the -mm tree.  Its filename is
     rtc-at91sam9-rtc-support-rtt-and-or-rtc.patch

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
Subject: rtc: at91sam9 RTC support (RTT and/or RTC)
From: David Brownell <david-b@pacbell.net>

AT91sam9 RTC support, primarily in the form of an RTT-as-RTC driver that was
extracted from 2.6.23-at91 patch and updated:

 - Relies on now-merged platform updates, which associate the RTT
   hardware address with each RTT and use the "at91_rtt" name.

 - RTC framework related fixes and cleanups, notably:
    * removed now-needless suspend/resume clock offset logic
    * alarm read/write now respects the "enabled" flag
    * suspend always disables update irqs
    * shutdown (and startup) disables all irqs

 - Misc cleanup:
    * use dev_*() messaging
    * add comments
    * remove globals,
    * ... etc

 - Don't force use of RTT0 and GPBR0.  Either resource may need
   to be used for other purposes (like NO_HZ support).

 - Update "AT91RM9200 RTC" Kconfig to allow it on SAM9RL chips
   (it has both RTT and RTC).

Driver binding uses bus_find_device() to avoid needing any kind of "timer
library" code when there's more than one RTT module.  (This timer can be used
as an RTC, to support NO_HZ operation, or potentially for other stuff.  The
choice is a per-system policy.)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Michel Benoit <murpme@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Cc: Andrew Victor <linux@maxim.org.za>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig        |   43 ++
 drivers/rtc/Makefile       |    1 
 drivers/rtc/rtc-at91sam9.c |  520 +++++++++++++++++++++++++++++++++++
 3 files changed, 561 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/Kconfig~rtc-at91sam9-rtc-support-rtt-and-or-rtc drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-at91sam9-rtc-support-rtt-and-or-rtc
+++ a/drivers/rtc/Kconfig
@@ -469,10 +469,47 @@ config RTC_DRV_AT32AP700X
 	  AT32AP700x family processors.
 
 config RTC_DRV_AT91RM9200
-	tristate "AT91RM9200"
-	depends on ARCH_AT91RM9200
+	tristate "AT91RM9200 or AT91SAM9RL"
+	depends on ARCH_AT91RM9200 || ARCH_AT91SAM9RL
 	help
-	  Driver for the Atmel AT91RM9200's internal RTC (Realtime Clock).
+	  Driver for the internal RTC (Realtime Clock) module found on
+	  Atmel AT91RM9200's and AT91SAM9RL chips.  On SAM9RL chips
+	  this is powered by the backup power supply.
+
+config RTC_DRV_AT91SAM9
+	tristate "AT91SAM9x"
+	depends on ARCH_AT91 && !(ARCH_AT91RM9200 || ARCH_AT91X40)
+	help
+	  RTC driver for the Atmel AT91SAM9x internal RTT (Real Time Timer).
+	  These timers are powered by the backup power supply (such as a
+	  small coin cell battery), but do not need to be used as RTCs.
+
+	  (On AT91SAM9rl chips you probably want to use the dedicated RTC
+	  module and leave the RTT available for other uses.)
+
+config RTC_DRV_AT91SAM9_RTT
+	int
+	range 0 1
+	default 0
+	prompt "RTT module Number" if ARCH_AT91SAM9263
+	depends on RTC_DRV_AT91SAM9
+	help
+	  More than one RTT module is available.  You can choose which
+	  one will be used as an RTC.  The default of zero is normally
+	  OK to use, though some systems use that for non-RTC purposes.
+
+config RTC_DRV_AT91SAM9_GPBR
+	int
+	range 0 3 if !ARCH_AT91SAM9263
+	range 0 15 if ARCH_AT91SAM9263
+	default 0
+	prompt "Backup Register Number"
+	depends on RTC_DRV_AT91SAM9
+	help
+	  The RTC driver needs to use one of the General Purpose Backup
+	  Registers (GPBRs) as well as the RTT.  You can choose which one
+	  will be used.  The default of zero is normally OK to use, but
+	  on some systems other software needs to use that register.
 
 config RTC_DRV_BFIN
 	tristate "Blackfin On-Chip RTC"
diff -puN drivers/rtc/Makefile~rtc-at91sam9-rtc-support-rtt-and-or-rtc drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-at91sam9-rtc-support-rtt-and-or-rtc
+++ a/drivers/rtc/Makefile
@@ -19,6 +19,7 @@ rtc-core-$(CONFIG_RTC_INTF_SYSFS) += rtc
 
 obj-$(CONFIG_RTC_DRV_AT32AP700X)+= rtc-at32ap700x.o
 obj-$(CONFIG_RTC_DRV_AT91RM9200)+= rtc-at91rm9200.o
+obj-$(CONFIG_RTC_DRV_AT91SAM9)	+= rtc-at91sam9.o
 obj-$(CONFIG_RTC_DRV_BFIN)	+= rtc-bfin.o
 obj-$(CONFIG_RTC_DRV_CMOS)	+= rtc-cmos.o
 obj-$(CONFIG_RTC_DRV_DS1216)	+= rtc-ds1216.o
diff -puN /dev/null drivers/rtc/rtc-at91sam9.c
--- /dev/null
+++ a/drivers/rtc/rtc-at91sam9.c
@@ -0,0 +1,520 @@
+/*
+ * "RTT as Real Time Clock" driver for AT91SAM9 SoC family
+ *
+ * (C) 2007 Michel Benoit
+ *
+ * Based on rtc-at91rm9200.c by Rick Bronson
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/time.h>
+#include <linux/rtc.h>
+#include <linux/interrupt.h>
+#include <linux/ioctl.h>
+
+#include <asm/mach/time.h>
+#include <asm/arch/board.h>
+#include <asm/arch/at91_rtt.h>
+
+
+/*
+ * This driver uses two configurable hardware resources that live in the
+ * AT91SAM9 backup power domain (intended to be powered at all times)
+ * to implement the Real Time Clock interfaces
+ *
+ *  - A "Real-time Timer" (RTT) counts up in seconds from a base time.
+ *    We can't assign the counter value (CRTV) ... but we can reset it.
+ *
+ *  - One of the "General Purpose Backup Registers" (GPBRs) holds the
+ *    base time, normally an offset from the beginning of the POSIX
+ *    epoch (1970-Jan-1 00:00:00 UTC).  Some systems also include the
+ *    local timezone's offset.
+ *
+ * The RTC's value is the RTT counter plus that offset.  The RTC's alarm
+ * is likewise a base (ALMV) plus that offset.
+ *
+ * Not all RTTs will be used as RTCs; some systems have multiple RTTs to
+ * choose from, or a "real" RTC module.  All systems have multiple GPBR
+ * registers available, likewise usable for more than "RTC" support.
+ */
+
+/*
+ * We store ALARM_DISABLED in ALMV to record that no alarm is set.
+ * It's also the reset value for that field.
+ */
+#define ALARM_DISABLED	((u32)~0)
+
+
+struct sam9_rtc {
+	void __iomem		*rtt;
+	struct rtc_device	*rtcdev;
+	u32			imr;
+};
+
+#define rtt_readl(rtc, field) \
+	__raw_readl((rtc)->rtt + AT91_RTT_ ## field)
+#define rtt_writel(rtc, field, val) \
+	__raw_writel((val), (rtc)->rtt + AT91_RTT_ ## field)
+
+#define gpbr_readl(rtc) \
+	at91_sys_read(AT91_GPBR + 4 * CONFIG_RTC_DRV_AT91SAM9_GPBR)
+#define gpbr_writel(rtc, val) \
+	at91_sys_write(AT91_GPBR + 4 * CONFIG_RTC_DRV_AT91SAM9_GPBR, (val))
+
+/*
+ * Read current time and date in RTC
+ */
+static int at91_rtc_readtime(struct device *dev, struct rtc_time *tm)
+{
+	struct sam9_rtc *rtc = dev_get_drvdata(dev);
+	u32 secs, secs2;
+	u32 offset;
+
+	/* read current time offset */
+	offset = gpbr_readl(rtc);
+	if (offset == 0)
+		return -EILSEQ;
+
+	/* reread the counter to help sync the two clock domains */
+	secs = rtt_readl(rtc, VR);
+	secs2 = rtt_readl(rtc, VR);
+	if (secs != secs2)
+		secs = rtt_readl(rtc, VR);
+
+	rtc_time_to_tm(offset + secs, tm);
+
+	dev_dbg(dev, "%s: %4d-%02d-%02d %02d:%02d:%02d\n", "readtime",
+		1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
+		tm->tm_hour, tm->tm_min, tm->tm_sec);
+
+	return 0;
+}
+
+/*
+ * Set current time and date in RTC
+ */
+static int at91_rtc_settime(struct device *dev, struct rtc_time *tm)
+{
+	struct sam9_rtc *rtc = dev_get_drvdata(dev);
+	int err;
+	u32 offset, alarm, mr;
+	unsigned long secs;
+
+	dev_dbg(dev, "%s: %4d-%02d-%02d %02d:%02d:%02d\n", "settime",
+		1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
+		tm->tm_hour, tm->tm_min, tm->tm_sec);
+
+	err = rtc_tm_to_time(tm, &secs);
+	if (err != 0)
+		return err;
+
+	mr = rtt_readl(rtc, MR);
+
+	/* disable interrupts */
+	rtt_writel(rtc, MR, mr & ~(AT91_RTT_ALMIEN | AT91_RTT_RTTINCIEN));
+
+	/* read current time offset */
+	offset = gpbr_readl(rtc);
+
+	/* store the new base time in a battery backup register */
+	secs += 1;
+	gpbr_writel(rtc, secs);
+
+	/* adjust the alarm time for the new base */
+	alarm = rtt_readl(rtc, AR);
+	if (alarm != ALARM_DISABLED) {
+		if (offset > secs) {
+			/* time jumped backwards, increase time until alarm */
+			alarm += (offset - secs);
+		} else if ((alarm + offset) > secs) {
+			/* time jumped forwards, decrease time until alarm */
+			alarm -= (secs - offset);
+		} else {
+			/* time jumped past the alarm, disable alarm */
+			alarm = ALARM_DISABLED;
+			mr &= ~AT91_RTT_ALMIEN;
+		}
+		rtt_writel(rtc, AR, alarm);
+	}
+
+	/* reset the timer, and re-enable interrupts */
+	rtt_writel(rtc, MR, mr | AT91_RTT_RTTRST);
+
+	return 0;
+}
+
+static int at91_rtc_readalarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct sam9_rtc *rtc = dev_get_drvdata(dev);
+	struct rtc_time *tm = &alrm->time;
+	u32 alarm = rtt_readl(rtc, AR);
+	u32 offset;
+
+	offset = gpbr_readl(rtc);
+	if (offset == 0)
+		return -EILSEQ;
+
+	memset(alrm, 0, sizeof(alrm));
+	if (alarm != ALARM_DISABLED && offset != 0) {
+		rtc_time_to_tm(offset + alarm, tm);
+
+		dev_dbg(dev, "%s: %4d-%02d-%02d %02d:%02d:%02d\n", "readalarm",
+			1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
+			tm->tm_hour, tm->tm_min, tm->tm_sec);
+
+		if (rtt_readl(rtc, MR) & AT91_RTT_ALMIEN)
+			alrm->enabled = 1;
+	}
+
+	return 0;
+}
+
+static int at91_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct sam9_rtc *rtc = dev_get_drvdata(dev);
+	struct rtc_time *tm = &alrm->time;
+	unsigned long secs;
+	u32 offset;
+	u32 mr;
+	int err;
+
+	err = rtc_tm_to_time(tm, &secs);
+	if (err != 0)
+		return err;
+
+	offset = gpbr_readl(rtc);
+	if (offset == 0) {
+		/* time is not set */
+		return -EILSEQ;
+	}
+	mr = rtt_readl(rtc, MR);
+	rtt_writel(rtc, MR, mr & ~AT91_RTT_ALMIEN);
+
+	/* alarm in the past? finish and leave disabled */
+	if (secs <= offset) {
+		rtt_writel(rtc, AR, ALARM_DISABLED);
+		return 0;
+	}
+
+	/* else set alarm and maybe enable it */
+	rtt_writel(rtc, AR, secs - offset);
+	if (alrm->enabled)
+		rtt_writel(rtc, MR, mr | AT91_RTT_ALMIEN);
+
+	dev_dbg(dev, "%s: %4d-%02d-%02d %02d:%02d:%02d\n", "setalarm",
+		tm->tm_year, tm->tm_mon, tm->tm_mday, tm->tm_hour,
+		tm->tm_min, tm->tm_sec);
+
+	return 0;
+}
+
+/*
+ * Handle commands from user-space
+ */
+static int at91_rtc_ioctl(struct device *dev, unsigned int cmd,
+			unsigned long arg)
+{
+	struct sam9_rtc *rtc = dev_get_drvdata(dev);
+	int ret = 0;
+	u32 mr = rtt_readl(rtc, MR);
+
+	dev_dbg(dev, "ioctl: cmd=%08x, arg=%08lx, mr %08x\n", cmd, arg, mr);
+
+	switch (cmd) {
+	case RTC_AIE_OFF:		/* alarm off */
+		rtt_writel(rtc, MR, mr & ~AT91_RTT_ALMIEN);
+		break;
+	case RTC_AIE_ON:		/* alarm on */
+		rtt_writel(rtc, MR, mr | AT91_RTT_ALMIEN);
+		break;
+	case RTC_UIE_OFF:		/* update off */
+		rtt_writel(rtc, MR, mr & ~AT91_RTT_RTTINCIEN);
+		break;
+	case RTC_UIE_ON:		/* update on */
+		rtt_writel(rtc, MR, mr | AT91_RTT_RTTINCIEN);
+		break;
+	default:
+		ret = -ENOIOCTLCMD;
+		break;
+	}
+
+	return ret;
+}
+
+/*
+ * Provide additional RTC information in /proc/driver/rtc
+ */
+static int at91_rtc_proc(struct device *dev, struct seq_file *seq)
+{
+	struct sam9_rtc *rtc = dev_get_drvdata(dev);
+	u32 mr = mr = rtt_readl(rtc, MR);
+
+	seq_printf(seq, "update_IRQ\t: %s\n",
+			(mr & AT91_RTT_RTTINCIEN) ? "yes" : "no");
+	return 0;
+}
+
+/*
+ * IRQ handler for the RTC
+ */
+static irqreturn_t at91_rtc_interrupt(int irq, void *_rtc)
+{
+	struct sam9_rtc *rtc = _rtc;
+	u32 sr, mr;
+	unsigned long events = 0;
+
+	/* Shared interrupt may be for another device.  Note: reading
+	 * SR clears it, so we must only read it in this irq handler!
+	 */
+	mr = rtt_readl(rtc, MR) & (AT91_RTT_ALMIEN | AT91_RTT_RTTINCIEN);
+	sr = rtt_readl(rtc, SR) & mr;
+	if (!sr)
+		return IRQ_NONE;
+
+	/* alarm status */
+	if (sr & AT91_RTT_ALMS)
+		events |= (RTC_AF | RTC_IRQF);
+
+	/* timer update/increment */
+	if (sr & AT91_RTT_RTTINC)
+		events |= (RTC_UF | RTC_IRQF);
+
+	rtc_update_irq(rtc->rtcdev, 1, events);
+
+	pr_debug("%s: num=%ld, events=0x%02lx\n", __FUNCTION__,
+		events >> 8, events & 0x000000FF);
+
+	return IRQ_HANDLED;
+}
+
+static const struct rtc_class_ops at91_rtc_ops = {
+	.ioctl		= at91_rtc_ioctl,
+	.read_time	= at91_rtc_readtime,
+	.set_time	= at91_rtc_settime,
+	.read_alarm	= at91_rtc_readalarm,
+	.set_alarm	= at91_rtc_setalarm,
+	.proc		= at91_rtc_proc,
+};
+
+/*
+ * Initialize and install RTC driver
+ */
+static int __init at91_rtc_probe(struct platform_device *pdev)
+{
+	struct resource	*r;
+	struct sam9_rtc	*rtc;
+	int		ret;
+	u32		mr;
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!r)
+		return -ENODEV;
+
+	rtc = kzalloc(sizeof *rtc, GFP_KERNEL);
+	if (!rtc)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, rtc);
+	rtc->rtt = (void __force __iomem *) (AT91_VA_BASE_SYS - AT91_BASE_SYS);
+	rtc->rtt += r->start;
+
+	mr = rtt_readl(rtc, MR);
+
+	/* unless RTT is counting at 1 Hz, re-initialize it */
+	if ((mr & AT91_RTT_RTPRES) != AT91_SLOW_CLOCK) {
+		mr = AT91_RTT_RTTRST | (AT91_SLOW_CLOCK & AT91_RTT_RTPRES);
+		gpbr_writel(rtc, 0);
+	}
+
+	/* disable all interrupts (same as on shutdown path) */
+	mr &= ~(AT91_RTT_ALMIEN | AT91_RTT_RTTINCIEN);
+	rtt_writel(rtc, MR, mr);
+
+	rtc->rtcdev = rtc_device_register(pdev->name, &pdev->dev,
+				&at91_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtc->rtcdev)) {
+		ret = PTR_ERR(rtc->rtcdev);
+		goto fail;
+	}
+
+	/* register irq handler after we know what name we'll use */
+	ret = request_irq(AT91_ID_SYS, at91_rtc_interrupt,
+				IRQF_DISABLED | IRQF_SHARED,
+				rtc->rtcdev->dev.bus_id, rtc);
+	if (ret) {
+		dev_dbg(&pdev->dev, "can't share IRQ %d?\n", AT91_ID_SYS);
+		rtc_device_unregister(rtc->rtcdev);
+		goto fail;
+	}
+
+	/* NOTE:  sam9260 rev A silicon has a ROM bug which resets the
+	 * RTT on at least some reboots.  If you have that chip, you must
+	 * initialize the time from some external source like a GPS, wall
+	 * clock, discrete RTC, etc
+	 */
+
+	if (gpbr_readl(rtc) == 0)
+		dev_warn(&pdev->dev, "%s: SET TIME!\n",
+				rtc->rtcdev->dev.bus_id);
+
+	return 0;
+
+fail:
+	platform_set_drvdata(pdev, NULL);
+	kfree(rtc);
+	return ret;
+}
+
+/*
+ * Disable and remove the RTC driver
+ */
+static int __exit at91_rtc_remove(struct platform_device *pdev)
+{
+	struct sam9_rtc	*rtc = platform_get_drvdata(pdev);
+	u32		mr = rtt_readl(rtc, MR);
+
+	/* disable all interrupts */
+	rtt_writel(rtc, MR, mr & ~(AT91_RTT_ALMIEN | AT91_RTT_RTTINCIEN));
+	free_irq(AT91_ID_SYS, rtc);
+
+	rtc_device_unregister(rtc->rtcdev);
+
+	platform_set_drvdata(pdev, NULL);
+	kfree(rtc);
+	return 0;
+}
+
+static void at91_rtc_shutdown(struct platform_device *pdev)
+{
+	struct sam9_rtc	*rtc = platform_get_drvdata(pdev);
+	u32		mr = rtt_readl(rtc, MR);
+
+	rtc->imr = mr & (AT91_RTT_ALMIEN | AT91_RTT_RTTINCIEN);
+	rtt_writel(rtc, MR, mr & ~rtc->imr);
+}
+
+#ifdef CONFIG_PM
+
+/* AT91SAM9 RTC Power management control */
+
+static int at91_rtc_suspend(struct platform_device *pdev,
+					pm_message_t state)
+{
+	struct sam9_rtc	*rtc = platform_get_drvdata(pdev);
+	u32		mr = rtt_readl(rtc, MR);
+
+	/*
+	 * This IRQ is shared with DBGU and other hardware which isn't
+	 * necessarily a wakeup event source.
+	 */
+	rtc->imr = mr & (AT91_RTT_ALMIEN | AT91_RTT_RTTINCIEN);
+	if (rtc->imr) {
+		if (device_may_wakeup(&pdev->dev) && (mr & AT91_RTT_ALMIEN)) {
+			enable_irq_wake(AT91_ID_SYS);
+			/* don't let RTTINC cause wakeups */
+			if (mr & AT91_RTT_RTTINCIEN)
+				rtt_writel(rtc, MR, mr & ~AT91_RTT_RTTINCIEN);
+		} else
+			rtt_writel(rtc, MR, mr & ~rtc->imr);
+	}
+
+	return 0;
+}
+
+static int at91_rtc_resume(struct platform_device *pdev)
+{
+	struct sam9_rtc	*rtc = platform_get_drvdata(pdev);
+	u32		mr;
+
+	if (rtc->imr) {
+		if (device_may_wakeup(&pdev->dev))
+			disable_irq_wake(AT91_ID_SYS);
+		mr = rtt_readl(rtc, MR);
+		rtt_writel(rtc, MR, mr | rtc->imr);
+	}
+
+	return 0;
+}
+#else
+#define at91_rtc_suspend	NULL
+#define at91_rtc_resume		NULL
+#endif
+
+static struct platform_driver at91_rtc_driver = {
+	.driver.name	= "rtc-at91sam9",
+	.driver.owner	= THIS_MODULE,
+	.remove		= __exit_p(at91_rtc_remove),
+	.shutdown	= at91_rtc_shutdown,
+	.suspend	= at91_rtc_suspend,
+	.resume		= at91_rtc_resume,
+};
+
+/* Chips can have more than one RTT module, and they can be used for more
+ * than just RTCs.  So we can't just register as "the" RTT driver.
+ *
+ * A normal approach in such cases is to create a library to allocate and
+ * free the modules.  Here we just use bus_find_device() as like such a
+ * library, binding directly ... no runtime "library" footprint is needed.
+ */
+static int __init at91_rtc_match(struct device *dev, void *v)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	int ret;
+
+	/* continue searching if this isn't the RTT we need */
+	if (strcmp("at91_rtt", pdev->name) != 0
+			|| pdev->id != CONFIG_RTC_DRV_AT91SAM9_RTT)
+		goto fail;
+
+	/* else we found it ... but fail unless we can bind to the RTC driver */
+	if (dev->driver) {
+		dev_dbg(dev, "busy, can't use as RTC!\n");
+		goto fail;
+	}
+	dev->driver = &at91_rtc_driver.driver;
+	if (device_attach(dev) == 0) {
+		dev_dbg(dev, "can't attach RTC!\n");
+		goto fail;
+	}
+	ret = at91_rtc_probe(pdev);
+	if (ret == 0)
+		return true;
+
+	dev_dbg(dev, "RTC probe err %d!\n", ret);
+fail:
+	return false;
+}
+
+static int __init at91_rtc_init(void)
+{
+	int status;
+	struct device *rtc;
+
+	status = platform_driver_register(&at91_rtc_driver);
+	if (status)
+		return status;
+	rtc = bus_find_device(&platform_bus_type, NULL,
+			NULL, at91_rtc_match);
+	if (!rtc)
+		platform_driver_unregister(&at91_rtc_driver);
+	return rtc ? -ENODEV : 0;
+}
+module_init(at91_rtc_init);
+
+static void __exit at91_rtc_exit(void)
+{
+	platform_driver_unregister(&at91_rtc_driver);
+}
+module_exit(at91_rtc_exit);
+
+
+MODULE_AUTHOR("Michel Benoit");
+MODULE_DESCRIPTION("RTC driver for Atmel AT91SAM9x");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
pcmcia-stop-updating-dev-powerpower_state.patch
git-arm.patch
at91-correct-at91sam9263ek-lcd-power-gpio-pin.patch
i2c-isp1301_omap-new-style-i2c-driver-updates-part-1.patch
git-input.patch
git-mmc.patch
git-mtd.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
remove-pointless-casts-from-void-pointers.patch
spi-core-stop-updating-dev-powerpower_state.patch
spi-s3c-drivers-shouldnt-care-about-spi_board_info.patch
spi-remove-more-dev-powerpower_state-usage.patch
cosmetic-fixes-to-rtc-subsystems-kconfig.patch
rtc-pcf8583-dont-abuse-i2c_m_nostart.patch
rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch
rtc-cmos-exports-nvram-in-sysfs.patch
rtc-cmos-alarm-acts-as-oneshot.patch
platform-real-time-clock-driver-for-dallas-1511-chip.patch
add-hpet-rtc-emulation-to-rtc_drv_cmos.patch
add-hpet-rtc-emulation-to-rtc_drv_cmos-fix.patch
rtc-add-support-for-epson-rtc-9701je-v2.patch
rtc-add-support-for-epson-rtc-9701je-v4.patch
rtc-update-documentation-wrt-irq_set_freq.patch
rtc-cleanup-example-code.patch
rtc-remove-more-dev-powerpower_state-usage.patch
rtc-at91sam9-rtc-support-rtt-and-or-rtc.patch
b.patch
w1-gpio-add-gpio-w1-bus-master-driver.patch
w1-gpio-add-gpio-w1-bus-master-driver-v3.patch
basic-pwm-driver-for-avr32-and-at91.patch
basic-pwm-driver-for-avr32-and-at91-fix.patch
pwm-led-driver.patch
