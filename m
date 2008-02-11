From: akpm@linux-foundation.org
Subject: + rtc-avoid-legacy-drivers-with-generic-framework.patch added to -mm tree
Date: Mon, 11 Feb 2008 15:00:08 -0800
Message-ID: <200802112300.m1BN08Vt005641@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59668 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752843AbYBKXI3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Feb 2008 18:08:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net


The patch titled
     rtc: avoid legacy drivers with generic framework
has been added to the -mm tree.  Its filename is
     rtc-avoid-legacy-drivers-with-generic-framework.patch

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
Subject: rtc: avoid legacy drivers with generic framework
From: David Brownell <david-b@pacbell.net>

Kconfig tweaks to help reduce RTC configuration bugs, by avoiding
legacy RTC drivers when the generic RTC framework is enabled:

 - If rtc-cmos is selected, disable the legacy rtc driver;

 - When using generic RTC on x86, enable rtc-cmos by default;

 - In the old "chardev RTC" section of Kconfig, add a comment
   warning people off these (seven) legacy RTC drivers when
   the generic framework is in use.

People can still use the legacy drivers if they want (or need) to.

This doesn't fix the broken dependencies for the legacy "CMOS" RTC driver. 
Ideally it would be a full list of platforms where it works, not a partial
list of ones where it won't.  Or better yet, it would depend on a
"HAVE_CMOS_RTC" flag defined by various platforms ...  surely there's a
Kconfig style guideline lurking there.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/Kconfig |    7 ++++++-
 drivers/rtc/Kconfig  |    1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/char/Kconfig~rtc-avoid-legacy-drivers-with-generic-framework drivers/char/Kconfig
--- a/drivers/char/Kconfig~rtc-avoid-legacy-drivers-with-generic-framework
+++ a/drivers/char/Kconfig
@@ -704,9 +704,14 @@ config NVRAM
 	  To compile this driver as a module, choose M here: the
 	  module will be called nvram.
 
+comment "Avoid any legacy RTC drivers you may see here"
+	depends on RTC_LIB
+
 config RTC
 	tristate "Enhanced Real Time Clock Support"
-	depends on !PPC && !PARISC && !IA64 && !M68K && !SPARC && !FRV && !ARM && !SUPERH && !S390
+	depends on !PPC && !PARISC && !IA64 && !M68K && !SPARC && !FRV \
+			&& !ARM && !SUPERH && !S390 \
+			&& RTC_DRV_CMOS=n
 	---help---
 	  If you say Y here and create a character special file /dev/rtc with
 	  major number 10 and minor number 135 using mknod ("man mknod"), you
diff -puN drivers/rtc/Kconfig~rtc-avoid-legacy-drivers-with-generic-framework drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-avoid-legacy-drivers-with-generic-framework
+++ a/drivers/rtc/Kconfig
@@ -294,6 +294,7 @@ comment "Platform RTC drivers"
 config RTC_DRV_CMOS
 	tristate "PC-style 'CMOS'"
 	depends on X86 || ALPHA || ARM || M32R || ATARI || PPC || MIPS
+	default y if X86
 	help
 	  Say "yes" here to get direct support for the real time clock
 	  found in every PC or ACPI-based system, and some other boards.
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
parport-section-fixup.patch
at91-correct-at91sam9263ek-lcd-power-gpio-pin.patch
i2c-isp1301_omap-new-style-i2c-driver-updates-part-1.patch
git-mmc.patch
usb-ehci-tolerates-some-buggy-devices.patch
rtc-cmos-display-hpet-emulation-mode.patch
rtc-avoid-legacy-drivers-with-generic-framework.patch
