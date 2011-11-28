From: akpm@linux-foundation.org
Subject: [merged] mrst-battery-fixes.patch removed from -mm tree
Date: Mon, 28 Nov 2011 12:59:41 -0800
Message-ID: <201111282101.pASKxfDN006139@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:33420 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231Ab1K1VBm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2011 16:01:42 -0500
Received: by wwp14 with SMTP id 14so158705wwp.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2011 13:01:41 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: major_lee@wistrom.com, alan@linux.intel.com, feng.tang@intel.com, hpa@zytor.com, major_lee@wistron.com, mathias.nyman@linux.intel.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mrst: battery fixes
has been removed from the -mm tree.  Its filename was
     mrst-battery-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Major Lee <major_lee@wistrom.com>
Subject: mrst: battery fixes

When DCDC input line over current detecting, PMIC will change charging
current automatically.  Logging event is enough.

[akpm@linux-foundation.org: fix build]
Signed-off-by: Major Lee <major_lee@wistron.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/intel_mid_battery.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/power/intel_mid_battery.c~mrst-battery-fixes drivers/power/intel_mid_battery.c
--- a/drivers/power/intel_mid_battery.c~mrst-battery-fixes
+++ a/drivers/power/intel_mid_battery.c
@@ -61,7 +61,8 @@ MODULE_PARM_DESC(debug, "Flag to enable 
 #define PMIC_BATT_CHR_SBATDET_MASK	(1 << 5)
 #define PMIC_BATT_CHR_SDCLMT_MASK	(1 << 6)
 #define PMIC_BATT_CHR_SUSBOVP_MASK	(1 << 7)
-#define PMIC_BATT_CHR_EXCPT_MASK	0xC6
+#define PMIC_BATT_CHR_EXCPT_MASK	0x86
+
 #define PMIC_BATT_ADC_ACCCHRG_MASK	(1 << 31)
 #define PMIC_BATT_ADC_ACCCHRGVAL_MASK	0x7FFFFFFF
 
@@ -304,11 +305,6 @@ static void pmic_battery_read_status(str
 			pbi->batt_status = POWER_SUPPLY_STATUS_NOT_CHARGING;
 			pmic_battery_log_event(BATT_EVENT_BATOVP_EXCPT);
 			batt_exception = 1;
-		} else if (r8 & PMIC_BATT_CHR_SDCLMT_MASK) {
-			pbi->batt_health = POWER_SUPPLY_HEALTH_OVERVOLTAGE;
-			pbi->batt_status = POWER_SUPPLY_STATUS_NOT_CHARGING;
-			pmic_battery_log_event(BATT_EVENT_DCLMT_EXCPT);
-			batt_exception = 1;
 		} else if (r8 & PMIC_BATT_CHR_STEMP_MASK) {
 			pbi->batt_health = POWER_SUPPLY_HEALTH_OVERHEAT;
 			pbi->batt_status = POWER_SUPPLY_STATUS_NOT_CHARGING;
@@ -316,6 +312,10 @@ static void pmic_battery_read_status(str
 			batt_exception = 1;
 		} else {
 			pbi->batt_health = POWER_SUPPLY_HEALTH_GOOD;
+			if (r8 & PMIC_BATT_CHR_SDCLMT_MASK) {
+				/* PMIC will change charging current automatically */
+				pmic_battery_log_event(BATT_EVENT_DCLMT_EXCPT);
+			}
 		}
 	}
 
_

Patches currently in -mm which might be from major_lee@wistrom.com are

linux-next.patch

