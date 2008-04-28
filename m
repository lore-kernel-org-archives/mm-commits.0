From: akpm@linux-foundation.org
Subject: - gpiochip_reserve-fix-2.patch removed from -mm tree
Date: Sun, 27 Apr 2008 23:59:57 -0700
Message-ID: <200804280659.m3S6xvtn012947@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763227AbYD1HAO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 03:00:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, avorontsov@ru.mvista.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     don't export gpiochip_reserve (section fix)
has been removed from the -mm tree.  Its filename was
     gpiochip_reserve-fix-2.patch

This patch was dropped because it was folded into gpiochip_reserve.patch

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
rtc-avoid-legacy-drivers-with-generic-framework.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes.patch
rtc-pcf8563-new-style-conversion.patch
rtc-pcf8563-add-device-ids-table.patch
rtc-x1205-new-style-conversion.patch
rtc-silence-section-mismatch-warning-in-rtc-test.patch
make-ds1511_rtc_readset_time-static.patch
kerneldoc-for-linux-clkh.patch
rtc-rtc-rs5c372-fix-up-null-name-in-transfer-error-path.patch
drivers-char-rtcc-use-time_before-time_before_eq-etc.patch
rtc-replace-remaining-__function__-occurrences.patch
spi-pxa2xx_spi-sparse-fixes.patch
atmel_spi-support-zero-length-transfer.patch
gpiochip_reserve.patch
gpiochip_reserve-fix-2.patch

