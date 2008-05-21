From: akpm@linux-foundation.org
Subject: + gpio-build-fixes-mostly-potential.patch added to -mm tree
Date: Wed, 21 May 2008 16:08:38 -0700
Message-ID: <200805212308.m4LN8cGe005477@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756552AbYEUXJL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 May 2008 19:09:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, Uwe.Kleine-Koenig@digi.com, arnaud.patard@rtp-net.org, dbrownell@users.sourceforge.net, rmk@arm.linux.org.uk


The patch titled
     gpio: build fixes (mostly potential)
has been added to the -mm tree.  Its filename is
     gpio-build-fixes-mostly-potential.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: gpio: build fixes (mostly potential)
=46rom: David Brownell <david-b@pacbell.net>

This fixes various gpio-related build errors (mostly potential)
reported in part by Russell King and Uwe Kleine-K=F6nig.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Uwe Kleine-K=F6nig <Uwe.Kleine-Koenig@digi.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/gpio.h |    6 +++++-
 include/linux/gpio.h       |    3 +++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff -puN include/asm-generic/gpio.h~gpio-build-fixes-mostly-potential =
include/asm-generic/gpio.h
--- a/include/asm-generic/gpio.h~gpio-build-fixes-mostly-potential
+++ a/include/asm-generic/gpio.h
@@ -1,8 +1,12 @@
 #ifndef _ASM_GENERIC_GPIO_H
 #define _ASM_GENERIC_GPIO_H
=20
+#include <linux/types.h>
+
 #ifdef CONFIG_HAVE_GPIO_LIB
=20
+#include <linux/compiler.h>
+
 /* Platforms may implement their GPIO interface with library code,
  * at a small performance cost for non-inlined operations and some
  * extra memory (for code and for per-GPIO table entries).
@@ -74,7 +78,7 @@ struct gpio_chip {
=20
 extern const char *gpiochip_is_requested(struct gpio_chip *chip,
 			unsigned offset);
-extern int __init __must_check gpiochip_reserve(int start, int ngpio);
+extern int __must_check gpiochip_reserve(int start, int ngpio);
=20
 /* add/remove chips */
 extern int gpiochip_add(struct gpio_chip *chip);
diff -puN include/linux/gpio.h~gpio-build-fixes-mostly-potential includ=
e/linux/gpio.h
--- a/include/linux/gpio.h~gpio-build-fixes-mostly-potential
+++ a/include/linux/gpio.h
@@ -8,6 +8,9 @@
=20
 #else
=20
+#include <linux/types.h>
+#include <linux/errno.h>
+
 /*
  * Some platforms don't support the GPIO programming interface.
  *
_

Patches currently in -mm which might be from david-b@pacbell.net are

gpio-pca953x-driver-handles-pca9554-too.patch
gpio-build-fixes-mostly-potential.patch
linux-next.patch
jffs2-summary-allocation-dont-use-vmalloc.patch
rndis_host-increase-delay-in-command-response-loop.patch
net-usb-add-support-for-apple-usb-ethernet-adapter.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned=
-issues.patch
x86-provide-rtc_cmos-platform-device.patch
asic3-gpiolib-support.patch
asic3-remove-children-platform-data.patch
asic3-new-gpio-configuration-code.patch
rtc-rtc-rs5c372-smbus-conversion-support.patch
rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch
rtc-m41t80-sort-header-inclusions-for-readability.patch
rtc-m41t80-use-pr_info-as-appropriate.patch
gpio-sysfs-interface.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
