From: akpm@linux-foundation.org
Subject: + rtc-kconfig-tweax.patch added to -mm tree
Date: Sat, 23 Jun 2007 09:53:50 -0700
Message-ID: <200706231653.l5NGrliu019708@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37404 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760177AbXFWQ6A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 12:58:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net


The patch titled
     RTC Kconfig tweax
has been added to the -mm tree.  Its filename is
     rtc-kconfig-tweax.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: RTC Kconfig tweax
From: David Brownell <david-b@pacbell.net>

Minor fix to the Kconfig for RTCs: don't display section headers for I2C or
SPI unless they're configured.  And depend on SPI_MASTER; having slave
support wouldn't help.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/Kconfig~rtc-kconfig-tweax drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-kconfig-tweax
+++ a/drivers/rtc/Kconfig
@@ -118,7 +118,7 @@ config RTC_DRV_TEST
 	  will be called rtc-test.
 
 comment "I2C RTC drivers"
-	depends on RTC_CLASS
+	depends on RTC_CLASS && I2C
 
 config RTC_DRV_DS1307
 	tristate "Dallas/Maxim DS1307/37/38/39/40, ST M41T00"
@@ -213,11 +213,11 @@ config RTC_DRV_PCF8583
 	  will be called rtc-pcf8583.
 
 comment "SPI RTC drivers"
-	depends on RTC_CLASS
+	depends on RTC_CLASS && SPI_MASTER
 
 config RTC_DRV_RS5C348
 	tristate "Ricoh RS5C348A/B"
-	depends on RTC_CLASS && SPI
+	depends on RTC_CLASS && SPI_MASTER
 	help
 	  If you say yes here you get support for the
 	  Ricoh RS5C348A and RS5C348B RTC chips.
@@ -227,7 +227,7 @@ config RTC_DRV_RS5C348
 
 config RTC_DRV_MAX6902
 	tristate "Maxim 6902"
-	depends on RTC_CLASS && SPI
+	depends on RTC_CLASS && SPI_MASTER
 	help
 	  If you say yes here you will get support for the
 	  Maxim MAX6902 SPI RTC chip.
_

Patches currently in -mm which might be from david-b@pacbell.net are

git-avr32.patch
git-leds.patch
git-mmc.patch
git-netdev-all.patch
git-backlight.patch
char-genrtc-use-wait_event_interruptible.patch
spi-controller-drivers-check-for-unsupported-modes.patch
spi-controller-drivers-check-for-unsupported-modes-update.patch
spi-add-3wire-mode-flag.patch
spi-add-3wire-mode-flag-fix.patch
spidev-compiler-warning-gone.patch
spi_lm70llp-parport-adapter-driver-correction.patch
spi_mpc83xxc-underclocking-hotfix.patch
atmel_spi-minor-updates.patch
s3c24xx-spi-controllers-both-select-bitbang.patch
rtc-ds1307-cleanups.patch
rtc-rs5c372-becomes-a-new-style-i2c-driver.patch
thecus-n2100-register-rtc-rs5c372-i2c-device.patch
rtc-make-example-code-jump-to-done-instead-of-return-when-ioctl-not-supported.patch
rtc-dev-return-enotty-in-ioctl-if-irq_set_freq-is-not-implemented-by-driver.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix.patch
rtc-kconfig-tweax.patch
rtc-add-rtc-m41t80-driver-take-2.patch
rtc-watchdog-support-for-rtc-m41t80-driver-take-2.patch
