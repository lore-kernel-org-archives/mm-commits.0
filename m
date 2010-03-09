From: akpm@linux-foundation.org
Subject: [merged] mfgpt-move-clocksource-menu.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:05:28 -0800
Message-ID: <201003091905.o29J5Sow031124@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46420 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755823Ab0CITGW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:06:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, dilinger@collabora.co.uk, mm-commits@vger.kernel.org


The patch titled
     MFGPT: move clocksource menu
has been removed from the -mm tree.  Its filename was
     mfgpt-move-clocksource-menu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -212,6 +212,15 @@ config CS5535_MFGPT_DEFAULT_IRQ
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

linux-next.patch
xfs-needs-list_sort.patch
vmwgfx-depends-on-fb.patch
dib3000mc-reduce-large-stack-usage.patch
dib7000p-reduce-large-stack-usage.patch
documentation-timers-split-txt-and-source-files.patch
documentation-laptop-split-txt-and-source-files.patch
documentation-fs-split-txt-and-source-files.patch
documentation-vm-split-txt-and-source-files.patch
doc-submitchecklist-add-rule-1.patch
cgroups-subsystem-module-unloading-fix.patch
memcg-move-charges-of-anonymous-swap-fix.patch
memcg-improve-performance-in-moving-swap-charge-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
dma-mappingh-add-the-dma_unmap-state-api-fix-2.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

