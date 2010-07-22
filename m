From: akpm@linux-foundation.org
Subject: + hwmon-coretemp-documentation-update-and-cleanup.patch added to -mm tree
Date: Thu, 22 Jul 2010 14:24:19 -0700
Message-ID: <201007222124.o6MLOJqN013137@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53646 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758681Ab0GVVZN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Jul 2010 17:25:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gong.chen@linux.intel.com, guenter.roeck@ericsson.com, huaxu.wan@intel.com, khali@linux-fr.org, r.marek@assembler.cz


The patch titled
     hwmon: coretemp: documentation update and cleanup
has been added to the -mm tree.  Its filename is
     hwmon-coretemp-documentation-update-and-cleanup.patch

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
Subject: hwmon: coretemp: documentation update and cleanup
From: Chen Gong <gong.chen@linux.intel.com>

Update coretemp supported CPU TjMax lists and some cleanup work.

Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
Cc: Rudolf Marek <r.marek@assembler.cz>
Cc: Huaxu Wan <huaxu.wan@intel.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/hwmon/coretemp |  102 ++++++++++++++++++++++++++++++++-
 drivers/hwmon/Kconfig        |    2 
 drivers/hwmon/coretemp.c     |    4 -
 3 files changed, 104 insertions(+), 4 deletions(-)

diff -puN Documentation/hwmon/coretemp~hwmon-coretemp-documentation-update-and-cleanup Documentation/hwmon/coretemp
--- a/Documentation/hwmon/coretemp~hwmon-coretemp-documentation-update-and-cleanup
+++ a/Documentation/hwmon/coretemp
@@ -22,7 +22,7 @@ Temperature is measured in degrees Celsi
 the actual value of temperature register is in fact a delta from TjMax.
 
 Temperature known as TjMax is the maximum junction temperature of processor.
-Intel defines this temperature as 85C or 100C. At this temperature, protection
+Intel defines this temperature as 80C or 105C. At this temperature, protection
 mechanism will perform actions to forcibly cool down the processor. Alarm
 may be raised, if the temperature grows enough (more than TjMax) to trigger
 the Out-Of-Spec bit. Following table summarizes the exported sysfs files:
@@ -38,3 +38,103 @@ temp1_label	 - Contains string "Core X",
 The TjMax temperature is set to 85 degrees C if undocumented model specific
 register (UMSR) 0xee has bit 30 set. If not the TjMax is 100 degrees C as
 (sometimes) documented in processor datasheet.
+
+Appendix A. Known TjMax lists (TBD):
+Some information comes from ark.intel.com
+
+Process		Processor					TjMax(C)
+
+32nm		Core i3/i5/i7 Processors
+		i7 660UM/640/620, 640LM/620, 620M, 610E		105
+		i5 540UM/520/430, 540M/520/450/430		105
+		i3 330E, 370M/350/330				90 rPGA, 105 BGA
+		i3 330UM					105
+
+32nm		Core i7 Extreme Processors
+		980X						100
+
+32nm		Celeron Processors
+		U3400						105
+		P4505/P4500 					90
+
+45nm		Xeon Processors 5400 Quad-Core
+		X5492, X5482, X5472, X5470, X5460, X5450	85
+		E5472, E5462, E5450/40/30/20/10/05		85
+		L5408						95
+		L5430, L5420, L5410				70
+
+45nm		Xeon Processors 5200 Dual-Core
+		X5282, X5272, X5270, X5260			90
+		E5240, E5220, E5205				90
+		E5205, E5220					70
+		L5240						70
+		L5238, L5215					95
+
+45nm		Atom Processors
+		D525/510/425/410				100
+		Z560/550/540/530P/530/520PT/520/515/510PT/510P	90
+		Z510/500					90
+		N475/470/455/450				100
+		N280/270					90
+
+45nm		Core2 Processors
+		Solo ULV SU3500/3300				100
+		T9900/9800/9600/9550/9500/9400/9300/8300/8100	105
+		T6670/6500/6400					105
+		T6600						90
+		SU9600/9400/9300				105
+		SP9600/9400					105
+		SL9600/9400/9380/9300				105
+		P9700/9600/9500/8800/8700/8600/8400/7570	105
+		P7550/7450					90
+
+45nm		Core2 Quad Processors
+		Q9100/9000					100
+
+45nm		Core2 Extreme Processors
+		X9100/9000					105
+		QX9300						100
+
+45nm		Core i3/i5/i7 Processors
+		i7 940XM/920					100
+		i7 840QM/820/740/720				100
+
+45nm		Celeron Processors
+		SU2300						100
+		900 						105
+
+65nm		Core2 Duo Processors
+		Solo U2200, U2100				100
+		U7700/7600/7500					100
+		T7800/7700/7600/7500/7400/7300/7250/7200/7100	100
+		T5870/5670/5600/5550/5500/5470/5450/5300/5270	100
+		T5250						100
+		T5800/5750/5200					85
+		L7700/7500/7400/7300/7200			100
+
+65nm		Core2 Extreme Processors
+		X7900/7800					100
+
+65nm		Core Duo Processors
+		U2500/2400					100
+		T2700/2600/2450/2400/2350/2300E/2300/2250/2050	100
+		L2500/2400/2300					100
+
+65nm		Core Solo Processors
+		U1500/1400/1300					100
+		T1400/1350/1300/1250				100
+
+65nm		Xeon Processors 5000 Quad-Core
+		X5000						90-95
+		E5000						80
+		L5000						70
+		L5318						95
+
+65nm		Xeon Processors 5000 Dual-Core
+		5080, 5063, 5060, 5050, 5030			80-90
+		5160, 5150, 5148, 5140, 5130, 5120, 5110	80
+		L5138						100
+
+65nm		Celeron Processors
+		T1700/1600					100
+		560/550/540/530					100
diff -puN drivers/hwmon/Kconfig~hwmon-coretemp-documentation-update-and-cleanup drivers/hwmon/Kconfig
--- a/drivers/hwmon/Kconfig~hwmon-coretemp-documentation-update-and-cleanup
+++ a/drivers/hwmon/Kconfig
@@ -405,7 +405,7 @@ config SENSORS_CORETEMP
 	help
 	  If you say yes here you get support for the temperature
 	  sensor inside your CPU. Most of the family 6 CPUs
-	  are supported. Check documentation/driver for details.
+	  are supported. Check Documentation/hwmon/coretemp for details.
 
 config SENSORS_IBMAEM
 	tristate "IBM Active Energy Manager temperature/power sensors and control"
diff -puN drivers/hwmon/coretemp.c~hwmon-coretemp-documentation-update-and-cleanup drivers/hwmon/coretemp.c
--- a/drivers/hwmon/coretemp.c~hwmon-coretemp-documentation-update-and-cleanup
+++ a/drivers/hwmon/coretemp.c
@@ -54,12 +54,12 @@ struct coretemp_data {
 	const char *name;
 	u32 id;
 	u16 core_id;
+	u8 alarm;
 	char valid;		/* zero until following fields are valid */
 	unsigned long last_updated;	/* in jiffies */
 	int temp;
 	int tjmax;
 	int ttarget;
-	u8 alarm;
 };
 
 /*
@@ -308,7 +308,7 @@ static int __devinit coretemp_probe(stru
 #ifdef CONFIG_SMP
 	data->core_id = c->cpu_core_id;
 #endif
-	data->name = "coretemp";
+	data->name = DRVNAME;
 	mutex_init(&data->update_lock);
 
 	/* test if we can access the THERM_STATUS MSR */
_

Patches currently in -mm which might be from gong.chen@linux.intel.com are

linux-next.patch
hwmon-coretemp-update-hotplug-condition-check.patch
hwmon-coretemp-enable-coretemp-device-add-operation-failure.patch
hwmon-coretemp-documentation-update-and-cleanup.patch
drivers-hwmon-coretempc-remove-unneeded-ifdef-config_hotplug_cpu.patch

