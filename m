From: akpm@linux-foundation.org
Subject: + cpuidle-make-cpuidle-sysfs-driver-governor-switch-off-by-default.patch added to -mm tree
Date: Thu, 07 Jun 2007 17:49:00 -0700
Message-ID: <200706080049.l580n02E014054@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59846 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965633AbXFHAtI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jun 2007 20:49:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com


The patch titled
     cpuidle: make cpuidle sysfs driver/governor switch off by default
has been added to the -mm tree.  Its filename is
     cpuidle-make-cpuidle-sysfs-driver-governor-switch-off-by-default.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cpuidle: make cpuidle sysfs driver/governor switch off by default
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

Make default cpuidle sysfs to show current_governor and current_driver in
read-only mode.  More elaborate available_governors and available_drivers with
writeable current_governor and current_driver interface only appear with
"cpuidle_sysfs_switch" boot parameter.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpuidle/cpuidle.c |    1 -
 drivers/cpuidle/sysfs.c   |   22 +++++++++++++++++++++-
 2 files changed, 21 insertions(+), 2 deletions(-)

diff -puN drivers/cpuidle/cpuidle.c~cpuidle-make-cpuidle-sysfs-driver-governor-switch-off-by-default drivers/cpuidle/cpuidle.c
--- a/drivers/cpuidle/cpuidle.c~cpuidle-make-cpuidle-sysfs-driver-governor-switch-off-by-default
+++ a/drivers/cpuidle/cpuidle.c
@@ -25,7 +25,6 @@ DEFINE_MUTEX(cpuidle_lock);
 LIST_HEAD(cpuidle_detected_devices);
 static void (*pm_idle_old)(void);
 
-
 /**
  * cpuidle_idle_call - the main idle loop
  *
diff -puN drivers/cpuidle/sysfs.c~cpuidle-make-cpuidle-sysfs-driver-governor-switch-off-by-default drivers/cpuidle/sysfs.c
--- a/drivers/cpuidle/sysfs.c~cpuidle-make-cpuidle-sysfs-driver-governor-switch-off-by-default
+++ a/drivers/cpuidle/sysfs.c
@@ -13,6 +13,14 @@
 
 #include "cpuidle.h"
 
+static unsigned int sysfs_switch;
+static int __init cpuidle_sysfs_setup(char *unused)
+{
+	sysfs_switch = 1;
+	return 1;
+}
+__setup("cpuidle_sysfs_switch", cpuidle_sysfs_setup);
+
 static ssize_t show_available_drivers(struct sys_device *dev, char *buf)
 {
 	ssize_t i = 0;
@@ -127,6 +135,15 @@ static ssize_t store_current_governor(st
 	return count;
 }
 
+static SYSDEV_ATTR(current_driver_ro, 0444, show_current_driver, NULL);
+static SYSDEV_ATTR(current_governor_ro, 0444, show_current_governor, NULL);
+
+static struct attribute *cpuclass_default_attrs[] = {
+	&attr_current_driver_ro.attr,
+	&attr_current_governor_ro.attr,
+	NULL
+};
+
 static SYSDEV_ATTR(available_drivers, 0444, show_available_drivers, NULL);
 static SYSDEV_ATTR(available_governors, 0444, show_available_governors, NULL);
 static SYSDEV_ATTR(current_driver, 0644, show_current_driver,
@@ -134,7 +151,7 @@ static SYSDEV_ATTR(current_driver, 0644,
 static SYSDEV_ATTR(current_governor, 0644, show_current_governor,
 	store_current_governor);
 
-static struct attribute *cpuclass_default_attrs[] = {
+static struct attribute *cpuclass_switch_attrs[] = {
 	&attr_available_drivers.attr,
 	&attr_available_governors.attr,
 	&attr_current_driver.attr,
@@ -152,6 +169,9 @@ static struct attribute_group cpuclass_a
  */
 int cpuidle_add_class_sysfs(struct sysdev_class *cls)
 {
+	if (sysfs_switch)
+		cpuclass_attr_group.attrs = cpuclass_switch_attrs;
+
 	return sysfs_create_group(&cls->kset.kobj, &cpuclass_attr_group);
 }
 
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

git-acpi.patch
cpuidle-menu-governor-and-hrtimer-compile-fix.patch
cpuidle-reenable-proc-acpi-power-interface-for-the-time-being.patch
cpuidle-fix-the-uninitialized-variable-in-sysfs-routine.patch
cpuidle-menu-governor-change-the-early-break-condition.patch
cpuidle-make-cpuidle-sysfs-driver-governor-switch-off-by-default.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default.patch
cpuidle-first-round-of-documentation-updates.patch
git-acpi-add-exports.patch
git-cpufreq.patch
make-usb-autosuspend-timer-1-sec-jiffy-aligned.patch
round_jiffies-for-i386-and-x86-64-non-critical-corrected-mce-polling.patch
add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
