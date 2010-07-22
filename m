From: akpm@linux-foundation.org
Subject: + hwmon-coretemp-update-hotplug-condition-check.patch added to -mm tree
Date: Thu, 22 Jul 2010 14:24:15 -0700
Message-ID: <201007222124.o6MLOFke013128@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34110 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759331Ab0GVVZN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Jul 2010 17:25:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gong.chen@linux.intel.com, guenter.roeck@ericsson.com, huaxu.wan@intel.com, khali@linux-fr.org, r.marek@assembler.cz


The patch titled
     hwmon: coretemp: update hotplug condition check
has been added to the -mm tree.  Its filename is
     hwmon-coretemp-update-hotplug-condition-check.patch

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
Subject: hwmon: coretemp: update hotplug condition check
From: Chen Gong <gong.chen@linux.intel.com>

Fix two errors in hotplug.  One is for hotplug notifier.  The other is
unnecessary driver unregister.  Because even none of online cpus supports
coretemp, we can't assume new onlined cpu doesn't support it either.  If
related driver is unregistered there we have no chance to use coretemp
from then on.

Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
Cc: Rudolf Marek <r.marek@assembler.cz>
Cc: Huaxu Wan <huaxu.wan@intel.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/coretemp.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/hwmon/coretemp.c~hwmon-coretemp-update-hotplug-condition-check drivers/hwmon/coretemp.c
--- a/drivers/hwmon/coretemp.c~hwmon-coretemp-update-hotplug-condition-check
+++ a/drivers/hwmon/coretemp.c
@@ -502,10 +502,13 @@ static int __cpuinit coretemp_cpu_callba
 
 	switch (action) {
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 	case CPU_DOWN_FAILED:
+	case CPU_DOWN_FAILED_FROZEN:
 		coretemp_device_add(cpu);
 		break;
 	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
 		coretemp_device_remove(cpu);
 		break;
 	}
@@ -566,7 +569,9 @@ exit_devices_unreg:
 	}
 	mutex_unlock(&pdev_list_mutex);
 exit_driver_unreg:
+#ifndef CONFIG_HOTPLUG_CPU
 	platform_driver_unregister(&coretemp_driver);
+#endif
 exit:
 	return err;
 }
_

Patches currently in -mm which might be from gong.chen@linux.intel.com are

linux-next.patch
hwmon-coretemp-update-hotplug-condition-check.patch
hwmon-coretemp-enable-coretemp-device-add-operation-failure.patch
hwmon-coretemp-documentation-update-and-cleanup.patch
drivers-hwmon-coretempc-remove-unneeded-ifdef-config_hotplug_cpu.patch

