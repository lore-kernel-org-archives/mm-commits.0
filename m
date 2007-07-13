From: akpm@linux-foundation.org
Subject: + dev_vdbg-available-with-dverbose_debug.patch added to -mm tree
Date: Thu, 12 Jul 2007 22:08:22 -0700
Message-ID: <200707130508.l6D58MP3029707@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45215 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932337AbXGMFIt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 01:08:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net, greg@kroah.com


The patch titled
     dev_vdbg(), available with -DVERBOSE_DEBUG
has been added to the -mm tree.  Its filename is
     dev_vdbg-available-with-dverbose_debug.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dev_vdbg(), available with -DVERBOSE_DEBUG
From: David Brownell <david-b@pacbell.net>

This defines a dev_vdbg() call, which is enabled with -DVERBOSE_DEBUG. 
When enabled, dev_vdbg() acts just like dev_dbg().  When disabled, it is a
NOP ...  just like dev_dbg() without -DDEBUG.  The specific code was moved
out of a USB patch, but lots of drivers have similar support.

That is, code can now be written to use an additional level of debug
output, selected at compile time.  Many driver authors have found this
idiom to be very useful.  A typical usage model is for "normal" debug
messages to focus on fault paths and not be very "chatty", so that those
messages can be left on during normal operation without much of a
performance or syslog load.  On the other hand "verbose" messages would be
noisy enough that they wouldn't normally be enabled; they might even affect
timings enough to change system or driver behavior.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/driver.c |    7 -------
 include/linux/device.h    |   10 ++++++++++
 2 files changed, 10 insertions(+), 7 deletions(-)

diff -puN drivers/usb/core/driver.c~dev_vdbg-available-with-dverbose_debug drivers/usb/core/driver.c
--- a/drivers/usb/core/driver.c~dev_vdbg-available-with-dverbose_debug
+++ a/drivers/usb/core/driver.c
@@ -29,13 +29,6 @@
 #include "hcd.h"
 #include "usb.h"
 
-#define VERBOSE_DEBUG	0
-
-#if VERBOSE_DEBUG
-#define dev_vdbg	dev_dbg
-#else
-#define dev_vdbg(dev, fmt, args...)	do { } while (0)
-#endif
 
 #ifdef CONFIG_HOTPLUG
 
diff -puN include/linux/device.h~dev_vdbg-available-with-dverbose_debug include/linux/device.h
--- a/include/linux/device.h~dev_vdbg-available-with-dverbose_debug
+++ a/include/linux/device.h
@@ -572,6 +572,16 @@ dev_dbg(struct device * dev, const char 
 }
 #endif
 
+#ifdef VERBOSE_DEBUG
+#define dev_vdbg	dev_dbg
+#else
+static inline int __attribute__ ((format (printf, 2, 3)))
+dev_vdbg(struct device * dev, const char * fmt, ...)
+{
+	return 0;
+}
+#endif
+
 #define dev_err(dev, format, arg...)		\
 	dev_printk(KERN_ERR , dev , format , ## arg)
 #define dev_info(dev, format, arg...)		\
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
rtc-kconfig-tweax.patch
rtc-add-rtc-m41t80-driver-take-2.patch
rtc-watchdog-support-for-rtc-m41t80-driver-take-2.patch
omap-add-ti-twl92330-menelaus-power-management-chip-driver.patch
