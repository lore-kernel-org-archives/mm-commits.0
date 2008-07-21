From: akpm@linux-foundation.org
Subject: + rtc-at91rm9200-avoid-spurious-irqs.patch added to -mm tree
Date: Sun, 20 Jul 2008 22:25:00 -0700
Message-ID: <200807210525.m6L5P0ng019093@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752726AbYGUFZQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jul 2008 01:25:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, avictor.za@gmail.com, unruh@physics.ubc.ca


The patch titled
     rtc-at91rm9200: avoid spurious irqs
has been added to the -mm tree.  Its filename is
     rtc-at91rm9200-avoid-spurious-irqs.patch

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
Subject: rtc-at91rm9200: avoid spurious irqs
From: David Brownell <dbrownell@users.sourceforge.net>

This fixes kernel http://bugzilla.kernel.org/show_bug.cgi?id=11112 (bogus
RTC update IRQs reported) for rtc-at91rm9200 by scrubbing old IRQ status
before enabling IRQs.

It also removes nonfunctional periodic IRQ support from this driver;
only update IRQs are reported, or provided by the hardware.

I suspect some other RTCs probably have versions of #11112; it's easy to
overlook, since most non-RTC drivers don't care about spurious IRQs:
they're not reported to userspace.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Report-by: W Unruh <unruh@physics.ubc.ca>
Cc: Andrew Victor <avictor.za@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at91rm9200.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff -puN drivers/rtc/rtc-at91rm9200.c~rtc-at91rm9200-avoid-spurious-irqs drivers/rtc/rtc-at91rm9200.c
--- a/drivers/rtc/rtc-at91rm9200.c~rtc-at91rm9200-avoid-spurious-irqs
+++ a/drivers/rtc/rtc-at91rm9200.c
@@ -171,8 +171,10 @@ static int at91_rtc_setalarm(struct devi
 		| BIN2BCD(tm.tm_mday) << 24
 		| AT91_RTC_DATEEN | AT91_RTC_MTHEN);
 
-	if (alrm->enabled)
+	if (alrm->enabled) {
+		at91_sys_write(AT91_RTC_SCCR, AT91_RTC_ALARM);
 		at91_sys_write(AT91_RTC_IER, AT91_RTC_ALARM);
+	}
 
 	pr_debug("%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
 		at91_alarm_year, tm.tm_mon, tm.tm_mday, tm.tm_hour,
@@ -191,28 +193,22 @@ static int at91_rtc_ioctl(struct device 
 
 	pr_debug("%s(): cmd=%08x, arg=%08lx.\n", __func__, cmd, arg);
 
+	/* important:  scrub old status before enabling IRQs */
 	switch (cmd) {
 	case RTC_AIE_OFF:	/* alarm off */
 		at91_sys_write(AT91_RTC_IDR, AT91_RTC_ALARM);
 		break;
 	case RTC_AIE_ON:	/* alarm on */
+		at91_sys_write(AT91_RTC_SCCR, AT91_RTC_ALARM);
 		at91_sys_write(AT91_RTC_IER, AT91_RTC_ALARM);
 		break;
 	case RTC_UIE_OFF:	/* update off */
-	case RTC_PIE_OFF:	/* periodic off */
 		at91_sys_write(AT91_RTC_IDR, AT91_RTC_SECEV);
 		break;
 	case RTC_UIE_ON:	/* update on */
-	case RTC_PIE_ON:	/* periodic on */
+		at91_sys_write(AT91_RTC_SCCR, AT91_RTC_SECEV);
 		at91_sys_write(AT91_RTC_IER, AT91_RTC_SECEV);
 		break;
-	case RTC_IRQP_READ:	/* read periodic alarm frequency */
-		ret = put_user(AT91_RTC_FREQ, (unsigned long *) arg);
-		break;
-	case RTC_IRQP_SET:	/* set periodic alarm frequency */
-		if (arg != AT91_RTC_FREQ)
-			ret = -EINVAL;
-		break;
 	default:
 		ret = -ENOIOCTLCMD;
 		break;
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

origin.patch
gpio-pcf857x-add-lock-and-handle-more-chips.patch
linux-next.patch
add-have_clk-to-kconfig-for-driver-dependencies.patch
drivers-input-touchscreen-ads7846c-optimize-order-of-calculating-rt-in-ads7846_rx.patch
pm-boot-time-suspend-selftest.patch
pm-boot-time-suspend-selftest-vs-linux-next.patch
pm-boot-time-suspend-selftest-update.patch
drivers-power-fix-platform-driver-hotplug-coldplug.patch
mfd-fix-platform-driver-hotplug-coldplug.patch
parport-fix-platform-driver-hotplug-coldplug.patch
spi-spi_mpc83xx-clockrate-fixes.patch
xilinx_spi-test-below-0-on-unsigned-irq-in-xilinx_spi_probe.patch
spi-kconfig-simplifications.patch
spi-make-spi_board_infomodalias-a-char-array.patch
spidev-bkl-removal.patch
spi-au1550_spi-proper-platform-device.patch
spi-au1550_spi-improve-pio-transfer-mode.patch
spi-au1550_spi-improve-pio-transfer-mode-checkpatch-fixes.patch
rtc-remove-bkl-for-ioctl.patch
rtc-ds1305-ds1306-driver.patch
rtc-ds1305-ds1306-driver-fix.patch
rtc-bcd-codeshrink.patch
rtc-rtc-omap-footprint-shrinkage.patch
rtc-cmos-improve-hpet-irq-glue.patch
rtc-at91rm9200-avoid-spurious-irqs.patch
rtc-cmos-avoid-spurious-irqs.patch
gpio-gpio-driver-for-max7301-spi-gpio-expander-check-spi_setup-return-code-cleanup.patch
gpio-sysfs-interface-updated.patch
gpio-sysfs-interface-updated-update.patch
gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support.patch
gpio-mcp23s08-handles-multiple-chips-per-chipselect.patch

