From: akpm@linux-foundation.org
Subject: - misc-fix-platform-driver-hotplug-coldplug.patch removed from -mm tree
Date: Wed, 16 Apr 2008 15:54:51 -0700
Message-ID: <200804162254.m3GMspSo011060@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42001 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756400AbYDPWzc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Apr 2008 18:55:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kay.sievers@vrfy.org, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     misc: fix platform driver hotplug/coldplug
has been removed from the -mm tree.  Its filename was
     misc-fix-platform-driver-hotplug-coldplug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: misc: fix platform driver hotplug/coldplug
From: Kay Sievers <kay.sievers@vrfy.org>

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf, the platform modalias is
prefixed with "platform:".  Add MODULE_ALIAS() to the hotpluggable 'misc'
platform drivers, to re-enable auto loading.

[dbrownell@users.sourceforge.net:  bugfix, registration fixes]
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/atmel-ssc.c              |    2 ++
 drivers/misc/atmel_pwm.c              |    1 +
 drivers/misc/hdpuftrs/hdpu_cpustate.c |    2 ++
 drivers/misc/hdpuftrs/hdpu_nexus.c    |    2 ++
 4 files changed, 7 insertions(+)

diff -puN drivers/misc/atmel-ssc.c~misc-fix-platform-driver-hotplug-coldplug drivers/misc/atmel-ssc.c
--- a/drivers/misc/atmel-ssc.c~misc-fix-platform-driver-hotplug-coldplug
+++ a/drivers/misc/atmel-ssc.c
@@ -154,6 +154,7 @@ static struct platform_driver ssc_driver
 	.remove		= __devexit_p(ssc_remove),
 	.driver		= {
 		.name		= "ssc",
+		.owner		= THIS_MODULE,
 	},
 };
 
@@ -172,3 +173,4 @@ module_exit(ssc_exit);
 MODULE_AUTHOR("Hans-Christian Egtvedt <hcegtvedt@atmel.com>");
 MODULE_DESCRIPTION("SSC driver for Atmel AVR32 and AT91");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:ssc");
diff -puN drivers/misc/atmel_pwm.c~misc-fix-platform-driver-hotplug-coldplug drivers/misc/atmel_pwm.c
--- a/drivers/misc/atmel_pwm.c~misc-fix-platform-driver-hotplug-coldplug
+++ a/drivers/misc/atmel_pwm.c
@@ -407,3 +407,4 @@ module_exit(pwm_exit);
 
 MODULE_DESCRIPTION("Driver for AT32/AT91 PWM module");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:atmel_pwm");
diff -puN drivers/misc/hdpuftrs/hdpu_cpustate.c~misc-fix-platform-driver-hotplug-coldplug drivers/misc/hdpuftrs/hdpu_cpustate.c
--- a/drivers/misc/hdpuftrs/hdpu_cpustate.c~misc-fix-platform-driver-hotplug-coldplug
+++ a/drivers/misc/hdpuftrs/hdpu_cpustate.c
@@ -164,6 +164,7 @@ static struct platform_driver hdpu_cpust
 	.remove = hdpu_cpustate_remove,
 	.driver = {
 		.name = HDPU_CPUSTATE_NAME,
+		.owner = THIS_MODULE,
 	},
 };
 
@@ -248,3 +249,4 @@ module_exit(cpustate_exit);
 
 MODULE_AUTHOR("Brian Waite");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:" HDPU_CPUSTATE_NAME);
diff -puN drivers/misc/hdpuftrs/hdpu_nexus.c~misc-fix-platform-driver-hotplug-coldplug drivers/misc/hdpuftrs/hdpu_nexus.c
--- a/drivers/misc/hdpuftrs/hdpu_nexus.c~misc-fix-platform-driver-hotplug-coldplug
+++ a/drivers/misc/hdpuftrs/hdpu_nexus.c
@@ -55,6 +55,7 @@ static struct platform_driver hdpu_nexus
 	.remove = hdpu_nexus_remove,
 	.driver = {
 		.name = HDPU_NEXUS_NAME,
+		.owner = THIS_MODULE,
 	},
 };
 
@@ -151,3 +152,4 @@ module_exit(nexus_exit);
 
 MODULE_AUTHOR("Brian Waite");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:" HDPU_NEXUS_NAME);
_

Patches currently in -mm which might be from kay.sievers@vrfy.org are

origin.patch
git-alsa-tiwai.patch
macintosh-windfarm-fix-platform-driver-hotplug-coldplug.patch
input-fix-platform-driver-hotplug-coldplug.patch
ata-ide-fix-platform-driver-hotplug-coldplug.patch
mtd-maps-fix-platform-driver-hotplug-coldplug.patch
mtd-nand-fix-platform-driver-hotplug-coldplug.patch
net-drivers-fix-platform-driver-hotplug-coldplug.patch
scsi-fix-platform-driver-hotplug-coldplug.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
infrastructure-to-debug-dynamic-objects.patch
debugobjects-add-documentation.patch
debugobjects-add-timer-specific-object-debugging-code.patch
add-hrtimer-specific-debugobjects-code.patch
cpu-change-cpu_sys_devices-from-array-to-per_cpu-variable.patch

