From: akpm@linux-foundation.org
Subject: + rtc-kconfig-clarification.patch added to -mm tree
Date: Mon, 14 May 2007 22:56:54 -0700
Message-ID: <200705150556.l4F5urhn002712@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45236 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756111AbXEOF5V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 01:57:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     rtc kconfig clarification
has been added to the -mm tree.  Its filename is
     rtc-kconfig-clarification.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rtc kconfig clarification
From: David Brownell <david-b@pacbell.net>

Make drivers/rtc/Kconfig be clearer about what the various "interfaces"
actually mean, by showing path names.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/Kconfig~rtc-kconfig-clarification drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-kconfig-clarification
+++ a/drivers/rtc/Kconfig
@@ -59,7 +59,7 @@ comment "RTC interfaces"
 	depends on RTC_CLASS
 
 config RTC_INTF_SYSFS
-	boolean "sysfs"
+	boolean "/sys/class/rtc/rtcN (sysfs)"
 	depends on RTC_CLASS && SYSFS
 	default RTC_CLASS
 	help
@@ -70,7 +70,7 @@ config RTC_INTF_SYSFS
 	  will be called rtc-sysfs.
 
 config RTC_INTF_PROC
-	boolean "proc"
+	boolean "/proc/driver/rtc (procfs for rtc0)"
 	depends on RTC_CLASS && PROC_FS
 	default RTC_CLASS
 	help
@@ -82,7 +82,7 @@ config RTC_INTF_PROC
 	  will be called rtc-proc.
 
 config RTC_INTF_DEV
-	boolean "dev"
+	boolean "/dev/rtcN (character devices)"
 	depends on RTC_CLASS
 	default RTC_CLASS
 	help
_

Patches currently in -mm which might be from david-b@pacbell.net are

acpi-driver-model-flags-and-platform_enable_wake.patch
update-documentation-driver-model-platformtxt.patch
git-leds.patch
at91-fix-enable-disable_irq_wake-symmetry-in-pcmcia-driver.patch
rtc-ds1307-cleanups.patch
gpio-interface-loosens-call-restrictions.patch
rtc-omap-build-fix.patch
rtc-kconfig-clarification.patch
use-menuconfig-objects-ii-rtc.patch
