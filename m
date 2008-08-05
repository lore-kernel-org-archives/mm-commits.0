From: akpm@linux-foundation.org
Subject: + cpuidle-make-sysfs-attributes-sysdev-class-attributes.patch added to -mm tree
Date: Tue, 05 Aug 2008 13:18:53 -0700
Message-ID: <200808052018.m75KIr3x021395@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54349 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764859AbYHEUTH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Aug 2008 16:19:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rabin@rab.in, ak@linux.intel.com, shaohua.li@intel.com, snakebyte@gmx.de


The patch titled
     cpuidle: make sysfs attributes sysdev class attributes
has been added to the -mm tree.  Its filename is
     cpuidle-make-sysfs-attributes-sysdev-class-attributes.patch

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
Subject: cpuidle: make sysfs attributes sysdev class attributes
From: Rabin Vincent <rabin@rab.in>

These attributes are really sysdev class attributes.  The incorrect
definition leads to an oops because of recent changes which make sysdev
attributes use a different prototype.

Based on Andi's f718cd4add5aea9d379faff92f162571e356cc5f ("sched: make
scheduler sysfs attributes sysdev class devices")

Reported-by: Eric Sesterhenn <snakebyte@gmx.de>
Signed-off-by: Rabin Vincent <rabin@rab.in>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: "Li, Shaohua" <shaohua.li@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpuidle/sysfs.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff -puN drivers/cpuidle/sysfs.c~cpuidle-make-sysfs-attributes-sysdev-class-attributes drivers/cpuidle/sysfs.c
--- a/drivers/cpuidle/sysfs.c~cpuidle-make-sysfs-attributes-sysdev-class-attributes
+++ a/drivers/cpuidle/sysfs.c
@@ -21,8 +21,8 @@ static int __init cpuidle_sysfs_setup(ch
 }
 __setup("cpuidle_sysfs_switch", cpuidle_sysfs_setup);
 
-static ssize_t show_available_governors(struct sys_device *dev,
-		struct sysdev_attribute *attr, char *buf)
+static ssize_t show_available_governors(struct sysdev_class *class,
+					char *buf)
 {
 	ssize_t i = 0;
 	struct cpuidle_governor *tmp;
@@ -40,8 +40,8 @@ out:
 	return i;
 }
 
-static ssize_t show_current_driver(struct sys_device *dev,
-		struct sysdev_attribute *attr, char *buf)
+static ssize_t show_current_driver(struct sysdev_class *class,
+				   char *buf)
 {
 	ssize_t ret;
 
@@ -55,8 +55,8 @@ static ssize_t show_current_driver(struc
 	return ret;
 }
 
-static ssize_t show_current_governor(struct sys_device *dev,
-			struct sysdev_attribute *attr, char *buf)
+static ssize_t show_current_governor(struct sysdev_class *class,
+				     char *buf)
 {
 	ssize_t ret;
 
@@ -70,9 +70,8 @@ static ssize_t show_current_governor(str
 	return ret;
 }
 
-static ssize_t store_current_governor(struct sys_device *dev,
-	struct sysdev_attribute *attr,
-	const char *buf, size_t count)
+static ssize_t store_current_governor(struct sysdev_class *class,
+				      const char *buf, size_t count)
 {
 	char gov_name[CPUIDLE_NAME_LEN];
 	int ret = -EINVAL;
@@ -104,8 +103,9 @@ static ssize_t store_current_governor(st
 		return count;
 }
 
-static SYSDEV_ATTR(current_driver, 0444, show_current_driver, NULL);
-static SYSDEV_ATTR(current_governor_ro, 0444, show_current_governor, NULL);
+static SYSDEV_CLASS_ATTR(current_driver, 0444, show_current_driver, NULL);
+static SYSDEV_CLASS_ATTR(current_governor_ro, 0444, show_current_governor,
+			 NULL);
 
 static struct attribute *cpuclass_default_attrs[] = {
 	&attr_current_driver.attr,
@@ -113,9 +113,10 @@ static struct attribute *cpuclass_defaul
 	NULL
 };
 
-static SYSDEV_ATTR(available_governors, 0444, show_available_governors, NULL);
-static SYSDEV_ATTR(current_governor, 0644, show_current_governor,
-	store_current_governor);
+static SYSDEV_CLASS_ATTR(available_governors, 0444, show_available_governors,
+			 NULL);
+static SYSDEV_CLASS_ATTR(current_governor, 0644, show_current_governor,
+			 store_current_governor);
 
 static struct attribute *cpuclass_switch_attrs[] = {
 	&attr_available_governors.attr,
_

Patches currently in -mm which might be from rabin@rab.in are

origin.patch
cpuidle-make-sysfs-attributes-sysdev-class-attributes.patch

