From: akpm@linux-foundation.org
Subject: + driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-update.patch added to -mm tree
Date: Fri, 13 Jul 2007 00:07:32 -0700
Message-ID: <200707130707.l6D77Wup003889@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48724 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752498AbXGMHJv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 03:09:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net, hcegtvedt@atmel.com


The patch titled
     Further fixes for the at32ap700x RTC driver:
has been added to the -mm tree.  Its filename is
     driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Further fixes for the at32ap700x RTC driver:
From: David Brownell <david-b@pacbell.net>

 - Strike some alarm setup code that's no longer needed.
   (This patch seems to have gotten lost somewhere...)

 - Make the driver name (and its module alias) match what
   the platform setup code uses, so the driver can bind
   and hotplug.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at32ap700x.c |   26 +++-----------------------
 1 file changed, 3 insertions(+), 23 deletions(-)

diff -puN drivers/rtc/rtc-at32ap700x.c~driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-update drivers/rtc/rtc-at32ap700x.c
--- a/drivers/rtc/rtc-at32ap700x.c~driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-update
+++ a/drivers/rtc/rtc-at32ap700x.c
@@ -109,28 +109,6 @@ static int at32_rtc_setalarm(struct devi
 
 	rtc_unix_time = rtc_readl(rtc, VAL);
 
-	/* RTC does only support one alarm time, not periodic */
-	if (alrm->time.tm_mday <= 0) {
-		struct rtc_time	tm;
-		unsigned long then;
-
-		rtc_time_to_tm(rtc_unix_time, &tm);
-
-		alrm->time.tm_mday = tm.tm_mday;
-		alrm->time.tm_mon  = tm.tm_mon;
-		alrm->time.tm_year = tm.tm_year;
-
-		rtc_tm_to_time(&alrm->time, &then);
-
-		/* check if the alarm wraps into tomorrow */
-		if (then < rtc_unix_time) {
-			rtc_time_to_tm(rtc_unix_time + 24 * 60 * 60, &tm);
-			alrm->time.tm_mday = tm.tm_mday;
-			alrm->time.tm_mon  = tm.tm_mon;
-			alrm->time.tm_year = tm.tm_year;
-		}
-	}
-
 	ret = rtc_tm_to_time(&alrm->time, &alarm_unix_time);
 	if (ret)
 		return ret;
@@ -312,10 +290,12 @@ static int __exit at32_rtc_remove(struct
 	return 0;
 }
 
+MODULE_ALIAS("at32ap700x_rtc");
+
 static struct platform_driver at32_rtc_driver = {
 	.remove		= __exit_p(at32_rtc_remove),
 	.driver		= {
-		.name	= "rtc-at32ap700x",
+		.name	= "at32ap700x_rtc",
 		.owner	= THIS_MODULE,
 	},
 };
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
git-avr32.patch
pm-do-not-use-saved_state-from-struct-dev_pm_info-on-arm.patch
git-mmc.patch
git-mtd.patch
geode-basic-infrastructure-support-for-amd-geode-class.patch
char-genrtc-use-wait_event_interruptible.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
gpio-calls-dont-need-i-o-barriers.patch
dev_vdbg-available-with-dverbose_debug.patch
spi-controller-drivers-check-for-unsupported-modes.patch
spi-add-3wire-mode-flag.patch
spidev-compiler-warning-gone.patch
spi_mpc83xxc-underclocking-hotfix.patch
atmel_spi-minor-updates.patch
s3c24xx-spi-controllers-both-select-bitbang.patch
spi-master-driver-for-xilinx-virtex.patch
spi-omap2_mcspi-driver.patch
rtc-ds1307-cleanups.patch
rtc-rs5c372-becomes-a-new-style-i2c-driver.patch
thecus-n2100-register-rtc-rs5c372-i2c-device.patch
rtc-make-example-code-jump-to-done-instead-of-return-when-ioctl-not-supported.patch
rtc-dev-return-enotty-in-ioctl-if-irq_set_freq-is-not-implemented-by-driver.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-update.patch
rtc-kconfig-tweax.patch
rtc-add-rtc-m41t80-driver-take-2.patch
rtc-watchdog-support-for-rtc-m41t80-driver-take-2.patch
omap-add-ti-twl92330-menelaus-power-management-chip-driver.patch
