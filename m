From: akpm@linux-foundation.org
Subject: [merged] thermal-hide-config_thermal_hwmon.patch removed from -mm tree
Date: Wed, 03 Aug 2011 11:59:47 -0700
Message-ID: <201108031857.p73IvGKP006723@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755361Ab1HCS6E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2011 14:58:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, guenter.roeck@ericsson.com, len.brown@intel.com, rene.herman@gmail.com, mm-commits@vger.kernel.org


The patch titled
     thermal: hide CONFIG_THERMAL_HWMON
has been removed from the -mm tree.  Its filename was
     thermal-hide-config_thermal_hwmon.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thermal: hide CONFIG_THERMAL_HWMON
From: Jean Delvare <khali@linux-fr.org>

It's about time to revert 16d752397301b9 ("thermal: Create
CONFIG_THERMAL_HWMON=n").  Anybody running a kernel >= 2.6.40 would also
be running a recent enough version of lm-sensors.

Actually having CONFIG_THERMAL_HWMON is pretty convenient so instead of
dropping it, we keep it but hide it.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Rene Herman <rene.herman@gmail.com>
Cc: Len Brown <len.brown@intel.com>
Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |    9 ---------
 drivers/thermal/Kconfig                    |    8 ++------
 2 files changed, 2 insertions(+), 15 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~thermal-hide-config_thermal_hwmon Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~thermal-hide-config_thermal_hwmon
+++ a/Documentation/feature-removal-schedule.txt
@@ -296,15 +296,6 @@ Who:	Ravikiran Thirumalai <kiran@scalex8
 
 ---------------------------
 
-What:	CONFIG_THERMAL_HWMON
-When:	January 2009
-Why:	This option was introduced just to allow older lm-sensors userspace
-	to keep working over the upgrade to 2.6.26. At the scheduled time of
-	removal fixed lm-sensors (2.x or 3.x) should be readily available.
-Who:	Rene Herman <rene.herman@gmail.com>
-
----------------------------
-
 What:	Code that is now under CONFIG_WIRELESS_EXT_SYSFS
 	(in net/core/net-sysfs.c)
 When:	After the only user (hal) has seen a release with the patches
diff -puN drivers/thermal/Kconfig~thermal-hide-config_thermal_hwmon drivers/thermal/Kconfig
--- a/drivers/thermal/Kconfig~thermal-hide-config_thermal_hwmon
+++ a/drivers/thermal/Kconfig
@@ -14,11 +14,7 @@ menuconfig THERMAL
 	  If you want this support, you should say Y or M here.
 
 config THERMAL_HWMON
-	bool "Hardware monitoring support"
+	bool
 	depends on THERMAL
 	depends on HWMON=y || HWMON=THERMAL
-	help
-	  The generic thermal sysfs driver's hardware monitoring support
-	  requires a 2.10.7/3.0.2 or later lm-sensors userspace.
