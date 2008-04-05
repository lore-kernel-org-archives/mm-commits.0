From: akpm@linux-foundation.org
Subject: + gpiochip_reserve-fix-2.patch added to -mm tree
Date: Fri, 04 Apr 2008 20:27:56 -0700
Message-ID: <200804050327.m353RufX022660@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45022 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751133AbYDED2v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2008 23:28:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, avorontsov@ru.mvista.com, dbrownell@users.sourceforge.net


The patch titled
     don't export gpiochip_reserve (section fix)
has been added to the -mm tree.  Its filename is
     gpiochip_reserve-fix-2.patch

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
Subject: don't export gpiochip_reserve (section fix)
From: David Brownell <david-b@pacbell.net>

Fix section warning:
  WARNING: drivers/gpio/built-in.o(__ksymtab_gpl+0xc0): Section mismatch
  in reference from the variable __ksymtab_gpiochip_reserve
  to the function .init.text:gpiochip_reserve()
  The symbol gpiochip_reserve is exported and annotated __init
  Fix this by removing the __init annotation of gpiochip_reserve or drop the export.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpiolib.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/gpio/gpiolib.c~gpiochip_reserve-fix-2 drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpiochip_reserve-fix-2
+++ a/drivers/gpio/gpiolib.c
@@ -150,7 +150,6 @@ err:
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(gpiochip_reserve);
 
 /**
  * gpiochip_add() - register a gpio_chip
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
git-acpi.patch
git-arm.patch
git-avr32.patch
git-input.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
spi-pxa2xx_spi-sparse-fixes.patch
atmel_spi-support-zero-length-transfer.patch
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
gpiochip_reserve-fix-2.patch
remove-duplicated-unlikely-in-is_err.patch

