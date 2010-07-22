From: akpm@linux-foundation.org
Subject: + hwmon-coretemp-enable-coretemp-device-add-operation-failure.patch added to -mm tree
Date: Thu, 22 Jul 2010 14:24:17 -0700
Message-ID: <201007222124.o6MLOHdP013132@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43548 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751734Ab0GVVZN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Jul 2010 17:25:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gong.chen@linux.intel.com, guenter.roeck@ericsson.com, huaxu.wan@intel.com, khali@linux-fr.org, r.marek@assembler.cz


The patch titled
     hwmon: coretemp: enable coretemp device add operation failure
has been added to the -mm tree.  Its filename is
     hwmon-coretemp-enable-coretemp-device-add-operation-failure.patch

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
Subject: hwmon: coretemp: enable coretemp device add operation failure
From: Chen Gong <gong.chen@linux.intel.com>

If one coretemp device can't be added, it should allow subsequent adding
operation because every new-added device will create a new sysfs group,
not an additional sensor sys entry.

Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
Cc: Rudolf Marek <r.marek@assembler.cz>
Cc: Huaxu Wan <huaxu.wan@intel.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/coretemp.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff -puN drivers/hwmon/coretemp.c~hwmon-coretemp-enable-coretemp-device-add-operation-failure drivers/hwmon/coretemp.c
--- a/drivers/hwmon/coretemp.c~hwmon-coretemp-enable-coretemp-device-add-operation-failure
+++ a/drivers/hwmon/coretemp.c
@@ -540,12 +540,9 @@ static int __init coretemp_init(void)
 		 * sensors. We check this bit only, all the early CPUs
 		 * without thermal sensors will be filtered out.
 		 */
-		if (c->cpuid_level >= 6 && (cpuid_eax(0x06) & 0x01)) {
-			err = coretemp_device_add(i);
-			if (err)
-				goto exit_devices_unreg;
-
-		} else {
+		if (c->cpuid_level >= 6 && (cpuid_eax(0x06) & 0x01))
+			coretemp_device_add(i);
+		else {
 			printk(KERN_INFO DRVNAME ": CPU (model=0x%x)"
 				" has no thermal sensor.\n", c->x86_model);
 		}
@@ -560,14 +557,6 @@ static int __init coretemp_init(void)
 #endif
 	return 0;
 
-exit_devices_unreg:
-	mutex_lock(&pdev_list_mutex);
-	list_for_each_entry_safe(p, n, &pdev_list, list) {
-		platform_device_unregister(p->pdev);
-		list_del(&p->list);
-		kfree(p);
-	}
-	mutex_unlock(&pdev_list_mutex);
 exit_driver_unreg:
 #ifndef CONFIG_HOTPLUG_CPU
 	platform_driver_unregister(&coretemp_driver);
_

Patches currently in -mm which might be from gong.chen@linux.intel.com are

linux-next.patch
hwmon-coretemp-update-hotplug-condition-check.patch
hwmon-coretemp-enable-coretemp-device-add-operation-failure.patch
hwmon-coretemp-documentation-update-and-cleanup.patch
drivers-hwmon-coretempc-remove-unneeded-ifdef-config_hotplug_cpu.patch

