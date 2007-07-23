From: akpm@linux-foundation.org
Subject: - rtc-kconfig-point-out-need-for-static-linkage.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:35:01 -0700
Message-ID: <200707230935.l6N9Z1CL016448@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34114 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759099AbXGWJp0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:45:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     rtc kconfig: point out need for static linkage
has been removed from the -mm tree.  Its filename was
     rtc-kconfig-point-out-need-for-static-linkage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc kconfig: point out need for static linkage
From: David Brownell <david-b@pacbell.net>

Various people have expressed surprise that their modular RTC drivers don't
seem to work for initializing the system time at boot.  To help avoid such
unpleasantness, make the Kconfig text point out that the driver probably
needs to be statically linked.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/rtc/Kconfig~rtc-kconfig-point-out-need-for-static-linkage drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-kconfig-point-out-need-for-static-linkage
+++ a/drivers/rtc/Kconfig
@@ -38,6 +38,9 @@ config RTC_HCTOSYS_DEVICE
 	  clock, usually rtc0.  Initialization is done when the system
 	  starts up, and when it resumes from a low power state.
 
+	  The driver for this RTC device must be loaded before late_initcall
+	  functions run, so it must usually be statically linked.
+
 	  This clock should be battery-backed, so that it reads the correct
 	  time when the system boots from a power-off state.  Otherwise, your
 	  system will need an external clock source (like an NTP server).
_

Patches currently in -mm which might be from david-b@pacbell.net are

git-acpi.patch
git-mmc.patch
git-mtd.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91.patch
