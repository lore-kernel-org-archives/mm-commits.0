From: akpm@linux-foundation.org
Subject: + hwmon-coretemp-documentation-update-and-cleanup-update.patch added to -mm tree
Date: Thu, 29 Jul 2010 12:35:05 -0700
Message-ID: <201007291935.o6TJZ5Tn029420@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33787 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757393Ab0G2Tfu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Jul 2010 15:35:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gong.chen@linux.intel.com, guenter.roeck@ericsson.com, huaxu.wan@intel.com, khali@linux-fr.org, r.marek@assembler.cz


The patch titled
     hwmon-coretemp-documentation-update-and-cleanup-update
has been added to the -mm tree.  Its filename is
     hwmon-coretemp-documentation-update-and-cleanup-update.patch

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
Subject: hwmon-coretemp-documentation-update-and-cleanup-update
From: Chen Gong <gong.chen@linux.intel.com>

Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
Cc: Rudolf Marek <r.marek@assembler.cz>
Cc: Huaxu Wan <huaxu.wan@intel.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/hwmon/coretemp |    9 +++++----
 drivers/hwmon/coretemp.c     |    4 ++--
 2 files changed, 7 insertions(+), 6 deletions(-)

diff -puN Documentation/hwmon/coretemp~hwmon-coretemp-documentation-update-and-cleanup-update Documentation/hwmon/coretemp
--- a/Documentation/hwmon/coretemp~hwmon-coretemp-documentation-update-and-cleanup-update
+++ a/Documentation/hwmon/coretemp
@@ -21,8 +21,8 @@ Temperature is measured in degrees Celsi
 1 degree C. Valid temperatures are from 0 to TjMax degrees C, because
 the actual value of temperature register is in fact a delta from TjMax.
 
-Temperature known as TjMax is the maximum junction temperature of processor.
-Intel defines this temperature as 80C or 105C. At this temperature, protection
+Temperature known as TjMax is the maximum junction temperature of processor,
+which depends on the CPU model. See table below. At this temperature, protection
 mechanism will perform actions to forcibly cool down the processor. Alarm
 may be raised, if the temperature grows enough (more than TjMax) to trigger
 the Out-Of-Spec bit. Following table summarizes the exported sysfs files:
@@ -65,8 +65,8 @@ Process		Processor					TjMax(C)
 
 45nm		Xeon Processors 5200 Dual-Core
 		X5282, X5272, X5270, X5260			90
-		E5240, E5220, E5205				90
-		E5205, E5220					70
+		E5240						90
+		E5205, E5220					70, 90
 		L5240						70
 		L5238, L5215					95
 
@@ -76,6 +76,7 @@ Process		Processor					TjMax(C)
 		Z510/500					90
 		N475/470/455/450				100
 		N280/270					90
+		330/230						125
 
 45nm		Core2 Processors
 		Solo ULV SU3500/3300				100
diff -puN drivers/hwmon/coretemp.c~hwmon-coretemp-documentation-update-and-cleanup-update drivers/hwmon/coretemp.c
--- a/drivers/hwmon/coretemp.c~hwmon-coretemp-documentation-update-and-cleanup-update
+++ a/drivers/hwmon/coretemp.c
@@ -54,12 +54,12 @@ struct coretemp_data {
 	const char *name;
 	u32 id;
 	u16 core_id;
-	u8 alarm;
 	char valid;		/* zero until following fields are valid */
 	unsigned long last_updated;	/* in jiffies */
 	int temp;
 	int tjmax;
 	int ttarget;
+	u8 alarm;
 };
 
 /*
@@ -308,7 +308,7 @@ static int __devinit coretemp_probe(stru
 #ifdef CONFIG_SMP
 	data->core_id = c->cpu_core_id;
 #endif
-	data->name = DRVNAME;
+	data->name = "coretemp";
 	mutex_init(&data->update_lock);
 
 	/* test if we can access the THERM_STATUS MSR */
_

Patches currently in -mm which might be from gong.chen@linux.intel.com are

origin.patch
hwmon-coretemp-update-hotplug-condition-check.patch
hwmon-coretemp-enable-coretemp-device-add-operation-failure.patch
hwmon-coretemp-documentation-update-and-cleanup.patch
hwmon-coretemp-documentation-update-and-cleanup-update.patch
drivers-hwmon-coretempc-remove-unneeded-ifdef-config_hotplug_cpu.patch

