From: akpm@linux-foundation.org
Subject: + generic-gpio-gpio_chip-support-fix.patch added to -mm tree
Date: Mon, 12 Nov 2007 16:01:52 -0800
Message-ID: <200711130001.lAD01qCe015457@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46810 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751802AbXKMACF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 19:02:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     minor gpiolib tweaks
has been added to the -mm tree.  Its filename is
     generic-gpio-gpio_chip-support-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: minor gpiolib tweaks
From: David Brownell <david-b@pacbell.net>

Minor fixups to the gpiolib code.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/gpiolib.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/gpiolib.c~generic-gpio-gpio_chip-support-fix lib/gpiolib.c
--- a/lib/gpiolib.c~generic-gpio-gpio_chip-support-fix
+++ a/lib/gpiolib.c
@@ -28,7 +28,7 @@
 #define	extra_checks	0
 #endif
 
-/* gpio_lock protects the table of chips and to gpio_chip->requested.
+/* gpio_lock protects the table of chips and gpio_chip->requested.
  * While any gpio is requested, its gpio_chip is not removable.  It's
  * a raw spinlock to ensure safe access from hardirq contexts, and to
  * shrink bitbang overhead:  per-bit preemption would be very wrong.
@@ -533,6 +533,6 @@ static int __init gpiolib_debugfs_init(v
 				NULL, NULL, &gpiolib_operations);
 	return 0;
 }
-postcore_initcall(gpiolib_debugfs_init);
+subsys_initcall(gpiolib_debugfs_init);
 
 #endif	/* DEBUG_FS */
_

Patches currently in -mm which might be from david-b@pacbell.net are

rtc_hctosys-expects-rtcs-in-utc-doc.patch
rtcs-handle-nvram-better.patch
rtc-ds1307-exports-nvram.patch
rtc-tweak-driver-documentation-for-rtc-periodic.patch
spi-fix-double-free-on-spi_unregister_master.patch
spi-fix-error-paths-on-txx9spi_probe.patch
atmel_serial-build-warnings-begone.patch
rtc-dont-write-rtc-century-when-setting-a-wake-alarm.patch
git-arm-master.patch
usb-s3c2410_udc-minor-irq-handler-cleanups.patch
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
rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch
rtc-cmos-exports-nvram-in-sysfs.patch
generic-gpio-gpio_chip-support.patch
generic-gpio-gpio_chip-support-fix.patch
avr32-uses-gpio_chip.patch
mcp23s08-spi-gpio-expander.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
pnp-request-ioport-and-iomem-resources-used-by-active-devices.patch
