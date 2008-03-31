From: akpm@linux-foundation.org
Subject: + sparc32-delete-bogus-js-rtc-records.patch added to -mm tree
Date: Mon, 31 Mar 2008 16:51:38 -0700
Message-ID: <200803312351.m2VNpc2p032266@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751591AbYCaXwc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 19:52:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, davem@davemloft.net, dbrownell@users.sourceforge.net


The patch titled
     sparc32: delete bogus js-rtc records
has been added to the -mm tree.  Its filename is
     sparc32-delete-bogus-js-rtc-records.patch

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
Subject: sparc32: delete bogus js-rtc records
From: David Brownell <david-b@pacbell.net>

While looking at the legacy RTC drivers in the drivers/char directory, I
noticed what looks like bogus entry for SPARC32 systems: JS_RTC, which seems
to rely on a non-existent js-rtc file.  Just delete it.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/defconfig  |    1 -
 drivers/char/Kconfig  |   22 ----------------------
 drivers/char/Makefile |    3 ---
 3 files changed, 26 deletions(-)

diff -puN arch/sparc/defconfig~sparc32-delete-bogus-js-rtc-records arch/sparc/defconfig
--- a/arch/sparc/defconfig~sparc32-delete-bogus-js-rtc-records
+++ a/arch/sparc/defconfig
@@ -521,7 +521,6 @@ CONFIG_LEGACY_PTY_COUNT=256
 # CONFIG_IPMI_HANDLER is not set
 # CONFIG_WATCHDOG is not set
 CONFIG_HW_RANDOM=m
-CONFIG_JS_RTC=m
 # CONFIG_R3964 is not set
 # CONFIG_APPLICOM is not set
 # CONFIG_RAW_DRIVER is not set
diff -puN drivers/char/Kconfig~sparc32-delete-bogus-js-rtc-records drivers/char/Kconfig
--- a/drivers/char/Kconfig~sparc32-delete-bogus-js-rtc-records
+++ a/drivers/char/Kconfig
@@ -746,28 +746,6 @@ config RTC
 	  To compile this driver as a module, choose M here: the
 	  module will be called rtc.
 
-config JS_RTC
-	tristate "Enhanced Real Time Clock Support"
-	depends on SPARC32 && PCI
-	---help---
-	  If you say Y here and create a character special file /dev/rtc with
-	  major number 10 and minor number 135 using mknod ("man mknod"), you
-	  will get access to the real time clock (or hardware clock) built
-	  into your computer.
-
-	  Every PC has such a clock built in. It can be used to generate
-	  signals from as low as 1Hz up to 8192Hz, and can also be used
-	  as a 24 hour alarm. It reports status information via the file
-	  /proc/driver/rtc and its behaviour is set by various ioctls on
-	  /dev/rtc.
-
-	  If you think you have a use for such a device (such as periodic data
-	  sampling), then say Y here, and read <file:Documentation/rtc.txt>
-	  for details.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called js-rtc.
-
 config SGI_DS1286
 	tristate "SGI DS1286 RTC support"
 	depends on SGI_HAS_DS1286
diff -puN drivers/char/Makefile~sparc32-delete-bogus-js-rtc-records drivers/char/Makefile
--- a/drivers/char/Makefile~sparc32-delete-bogus-js-rtc-records
+++ a/drivers/char/Makefile
@@ -109,9 +109,6 @@ obj-$(CONFIG_TCG_TPM)		+= tpm/
 
 obj-$(CONFIG_PS3_FLASH)		+= ps3flash.o
 
-obj-$(CONFIG_JS_RTC)		+= js-rtc.o
-js-rtc-y = rtc.o
-
 # Files generated that shall be removed upon make clean
 clean-files := consolemap_deftbl.c defkeymap.c
 
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
git-acpi.patch
git-arm.patch
git-avr32.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
usb-net-asix-does-not-really-need-10-100mbit.patch
sparc32-delete-bogus-js-rtc-records.patch
fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
usb-gadget-dummy_hcdc-fix-nested-switch-statements.patch
drivers-net-usb-pegasusc-remove-in_atomic-check.patch
usb-ohci-fix-2-timers-to-fire-at-jiffies-1s.patch
spi-pxa2xx_spi-sparse-fixes.patch
rtc-avoid-legacy-drivers-with-generic-framework.patch
rtc-avoid-legacy-drivers-with-generic-framework-update.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
rtc-silence-section-mismatch-warning-in-rtc-test.patch
make-ds1511_rtc_readset_time-static.patch
kerneldoc-for-linux-clkh.patch
kerneldoc-for-linux-clkh-fix.patch
rtc-rtc-rs5c372-fix-up-null-name-in-transfer-error-path.patch
rtc-rtc-rs5c372-smbus-conversion-support.patch
rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch
rtc-replace-remaining-__function__-occurrences.patch
remove-duplicated-unlikely-in-is_err.patch

