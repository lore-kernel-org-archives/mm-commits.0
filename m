From: akpm@linux-foundation.org
Subject: + rtc_hctosys-expects-rtcs-in-utc-doc.patch added to -mm tree
Date: Mon, 05 Nov 2007 16:31:24 -0800
Message-ID: <200711060031.lA60VOjW027639@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49217 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755044AbXKFAcB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 19:32:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net


The patch titled
     rtc_hctosys expects RTCs in UTC (doc)
has been added to the -mm tree.  Its filename is
     rtc_hctosys-expects-rtcs-in-utc-doc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rtc_hctosys expects RTCs in UTC (doc)
From: David Brownell <david-b@pacbell.net>

The RTC "hctosys" mechanism expects that RTC clock will use UTC, not local
time (e.g.  PST).  Say so in Kconfig and in the kernel message.

(Strictly speaking, the RTC clock should be tracking the POSIX epoch.  That's
not worth going into here.  Goofing timezones means clocks are wrong by many
hours; the POSIX-v-UTC differences just cost seconds.)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig   |    4 +++-
 drivers/rtc/hctosys.c |    4 ++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/Kconfig~rtc_hctosys-expects-rtcs-in-utc-doc drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc_hctosys-expects-rtcs-in-utc-doc
+++ a/drivers/rtc/Kconfig
@@ -36,7 +36,9 @@ config RTC_HCTOSYS_DEVICE
 	help
 	  The RTC device that will be used to (re)initialize the system
 	  clock, usually rtc0.  Initialization is done when the system
-	  starts up, and when it resumes from a low power state.
+	  starts up, and when it resumes from a low power state.  This
+	  device should record time in UTC, since the kernel won't do
+	  timezone correction.
 
 	  The driver for this RTC device must be loaded before late_initcall
 	  functions run, so it must usually be statically linked.
diff -puN drivers/rtc/hctosys.c~rtc_hctosys-expects-rtcs-in-utc-doc drivers/rtc/hctosys.c
--- a/drivers/rtc/hctosys.c~rtc_hctosys-expects-rtcs-in-utc-doc
+++ a/drivers/rtc/hctosys.c
@@ -47,8 +47,8 @@ static int __init rtc_hctosys(void)
 			do_settimeofday(&tv);
 
 			dev_info(rtc->dev.parent,
-				"setting the system clock to "
-				"%d-%02d-%02d %02d:%02d:%02d (%u)\n",
+				"setting system clock to "
+				"%d-%02d-%02d %02d:%02d:%02d UTC (%u)\n",
 				tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday,
 				tm.tm_hour, tm.tm_min, tm.tm_sec,
 				(unsigned int) tv.tv_sec);
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
rtc-m48t59-fix-section-mismatch-warning.patch
rtc_hctosys-expects-rtcs-in-utc-doc.patch
rtcs-handle-nvram-better.patch
rtc-ds1307-exports-nvram.patch
rtc-dont-write-rtc-century-when-setting-a-wake-alarm.patch
usb-s3c2410_udc-minor-irq-handler-cleanups.patch
pci-add-pci-identifiers-for-the-rdc-devices.patch
x86-add-support-for-the-rdc-r-321x-soc.patch
add-the-rdc-machine-specific-reboot-fixup.patch
rtc-release-correct-region-in-error-path.patch
rtc-fallback-to-requesting-only-the-ports-we-actually-use.patch
tle62x0-driver-stops-ignoring-read-errors.patch
rtc-convert-mutex-to-bitfield.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
remove-pointless-casts-from-void-pointers.patch
spi-at25-driver-is-for-eeprom-not-flash.patch
spi-use-mutex-not-semaphore.patch
blackfin-spi-driver-use-cpu_relax-to-replace-continue-in-while-busywait.patch
blackfin-spi-driver-use-void-__iomem-for-regs_base.patch
blackfin-spi-driver-move-hard-coded-pin_req-to-board-file.patch
blackfin-spi-driver-reconfigure-speed_hz-and-bits_per_word-in-each-spi-transfer.patch
cosmetic-fixes-to-rtc-subsystems-kconfig.patch
rtc-pcf8583-dont-abuse-i2c_m_nostart.patch
pnp-request-ioport-and-iomem-resources-used-by-active-devices.patch
