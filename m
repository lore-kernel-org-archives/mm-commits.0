From: akpm@linux-foundation.org
Subject: + mfgpt-move-clocksource-menu.patch added to -mm tree
Date: Wed, 30 Dec 2009 13:58:17 -0800
Message-ID: <200912302158.nBULwH3a004677@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752073AbZL3V60 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Dec 2009 16:58:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, dilinger@collabora.co.uk


The patch titled
     MFGPT: move clocksource menu
has been added to the -mm tree.  Its filename is
     mfgpt-move-clocksource-menu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MFGPT: move clocksource menu
From: Randy Dunlap <randy.dunlap@oracle.com>

Move the CS5535 MFGPT hrtimer kconfig option to be with the other MFGPT
options.  This makes it easier to find and also removes it from the main
"Device Drivers" menu, where it should not have been.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Andres Salomon <dilinger@collabora.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/Kconfig             |    2 --
 drivers/clocksource/Kconfig |    9 ---------
 drivers/misc/Kconfig        |    9 +++++++++
 3 files changed, 9 insertions(+), 11 deletions(-)

diff -puN drivers/Kconfig~mfgpt-move-clocksource-menu drivers/Kconfig
--- a/drivers/Kconfig~mfgpt-move-clocksource-menu
+++ a/drivers/Kconfig
@@ -96,8 +96,6 @@ source "drivers/edac/Kconfig"
 
 source "drivers/rtc/Kconfig"
 
-source "drivers/clocksource/Kconfig"
-
 source "drivers/dma/Kconfig"
 
 source "drivers/dca/Kconfig"
diff -puN drivers/clocksource/Kconfig~mfgpt-move-clocksource-menu /dev/null
--- a/drivers/clocksource/Kconfig
+++ /dev/null
@@ -1,9 +0,0 @@
-config CS5535_CLOCK_EVENT_SRC
-	tristate "CS5535/CS5536 high-res timer (MFGPT) events"
-	depends on GENERIC_TIME && GENERIC_CLOCKEVENTS && CS5535_MFGPT
-	help
-	  This driver provides a clock event source based on the MFGPT
-	  timer(s) in the CS5535 and CS5536 companion chips.
-	  MFGPTs have a better resolution and max interval than the
-	  generic PIT, and are suitable for use as high-res timers.
-
diff -puN drivers/misc/Kconfig~mfgpt-move-clocksource-menu drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~mfgpt-move-clocksource-menu
+++ a/drivers/misc/Kconfig
@@ -240,6 +240,15 @@ config CS5535_MFGPT_DEFAULT_IRQ
 	  want to use a different IRQ by default.  This is here for
 	  architectures to set as necessary.
 
+config CS5535_CLOCK_EVENT_SRC
+	tristate "CS5535/CS5536 high-res timer (MFGPT) events"
+	depends on GENERIC_TIME && GENERIC_CLOCKEVENTS && CS5535_MFGPT
+	help
+	  This driver provides a clock event source based on the MFGPT
+	  timer(s) in the CS5535 and CS5536 companion chips.
+	  MFGPTs have a better resolution and max interval than the
+	  generic PIT, and are suitable for use as high-res timers.
+
 config HP_ILO
 	tristate "Channel interface driver for HP iLO/iLO2 processor"
 	depends on PCI
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

docs-large-update-to-ioctl-numbertxt.patch
linux-next.patch
documentation-update-ring-buffer-designtxt.patch
mfgpt-move-clocksource-menu.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

