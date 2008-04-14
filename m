From: akpm@linux-foundation.org
Subject: + macintosh-windfarm-fix-platform-driver-hotplug-coldplug.patch added to -mm tree
Date: Sun, 13 Apr 2008 22:27:16 -0700
Message-ID: <200804140527.m3E5RGQg023043@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752484AbYDNF17 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Apr 2008 01:27:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kay.sievers@vrfy.org, benh@kernel.crashing.org, dbrownell@users.sourceforge.net, paulus@samba.org


The patch titled
     macintosh/windfarm: fix platform driver hotplug/coldplug
has been added to the -mm tree.  Its filename is
     macintosh-windfarm-fix-platform-driver-hotplug-coldplug.patch

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
Subject: macintosh/windfarm: fix platform driver hotplug/coldplug
From: Kay Sievers <kay.sievers@vrfy.org>

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf, the platform modalias is
prefixed with "platform:".  Add MODULE_ALIAS() to the hotpluggable "macintosh"
platform drivers, to re-enable auto loading.

[dbrownell@users.sourceforge.net: registration fixes]
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/macintosh/windfarm_pm112.c |    3 ++-
 drivers/macintosh/windfarm_pm81.c  |    4 ++--
 drivers/macintosh/windfarm_pm91.c  |    3 ++-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/macintosh/windfarm_pm112.c~macintosh-windfarm-fix-platform-driver-hotplug-coldplug drivers/macintosh/windfarm_pm112.c
--- a/drivers/macintosh/windfarm_pm112.c~macintosh-windfarm-fix-platform-driver-hotplug-coldplug
+++ a/drivers/macintosh/windfarm_pm112.c
@@ -668,7 +668,7 @@ static struct platform_driver wf_pm112_d
 	.remove = __devexit_p(wf_pm112_remove),
 	.driver = {
 		.name = "windfarm",
-		.bus = &platform_bus_type,
+		.owner	= THIS_MODULE,
 	},
 };
 
@@ -711,3 +711,4 @@ module_exit(wf_pm112_exit);
 MODULE_AUTHOR("Paul Mackerras <paulus@samba.org>");
 MODULE_DESCRIPTION("Thermal control for PowerMac11,2");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:windfarm");
diff -puN drivers/macintosh/windfarm_pm81.c~macintosh-windfarm-fix-platform-driver-hotplug-coldplug drivers/macintosh/windfarm_pm81.c
--- a/drivers/macintosh/windfarm_pm81.c~macintosh-windfarm-fix-platform-driver-hotplug-coldplug
+++ a/drivers/macintosh/windfarm_pm81.c
@@ -770,7 +770,7 @@ static struct platform_driver wf_smu_dri
         .remove = __devexit_p(wf_smu_remove),
 	.driver = {
 		.name = "windfarm",
-		.bus = &platform_bus_type,
+		.owner	= THIS_MODULE,
 	},
 };
 
@@ -810,4 +810,4 @@ module_exit(wf_smu_exit);
 MODULE_AUTHOR("Benjamin Herrenschmidt <benh@kernel.crashing.org>");
 MODULE_DESCRIPTION("Thermal control logic for iMac G5");
 MODULE_LICENSE("GPL");
-
+MODULE_ALIAS("platform:windfarm");
diff -puN drivers/macintosh/windfarm_pm91.c~macintosh-windfarm-fix-platform-driver-hotplug-coldplug drivers/macintosh/windfarm_pm91.c
--- a/drivers/macintosh/windfarm_pm91.c~macintosh-windfarm-fix-platform-driver-hotplug-coldplug
+++ a/drivers/macintosh/windfarm_pm91.c
@@ -702,7 +702,7 @@ static struct platform_driver wf_smu_dri
         .remove = __devexit_p(wf_smu_remove),
 	.driver = {
 		.name = "windfarm",
-		.bus = &platform_bus_type,
+		.owner	= THIS_MODULE,
 	},
 };
 
@@ -742,3 +742,4 @@ MODULE_AUTHOR("Benjamin Herrenschmidt <b
 MODULE_DESCRIPTION("Thermal control logic for PowerMac9,1");
 MODULE_LICENSE("GPL");
 
+MODULE_ALIAS("platform:windfarm");
_

Patches currently in -mm which might be from kay.sievers@vrfy.org are

mmc-fix-platform-driver-hotplug-coldplug.patch
leds-fix-platform-driver-hotplug-coldplug.patch
misc-fix-platform-driver-hotplug-coldplug.patch
pcmcia-fix-platform-driver-hotplug-coldplug.patch
serial-fix-platform-driver-hotplug-coldplug.patch
sound-fix-platform-driver-hotplug-coldplug.patch
pm-introduce-new-top-level-suspend-and-hibernation-callbacks-rev-7.patch
pm-introduce-new-top-level-suspend-and-hibernation-callbacks-rev-7-fix.patch
pm-new-suspend-and-hibernation-callbacks-for-platform-bus-type-rev-3.patch
pm-new-suspend-and-hibernation-callbacks-for-pci-bus-type-rev-3.patch
input-fix-platform-driver-hotplug-coldplug.patch
ata-ide-fix-platform-driver-hotplug-coldplug.patch
mtd-maps-fix-platform-driver-hotplug-coldplug.patch
mtd-nand-fix-platform-driver-hotplug-coldplug.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
infrastructure-to-debug-dynamic-objects.patch
debugobjects-add-documentation.patch
debugobjects-add-timer-specific-object-debugging-code.patch
add-hrtimer-specific-debugobjects-code.patch
cpu-change-cpu_sys_devices-from-array-to-per_cpu-variable.patch
macintosh-windfarm-fix-platform-driver-hotplug-coldplug.patch

