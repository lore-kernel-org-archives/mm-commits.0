From: akpm@linux-foundation.org
Subject: [failures] acpi-put-acpi_battery_get-set_alarm-into-config_acpi_sysfs_power.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:42:41 -0800
Message-ID: <201003091942.o29Jgf4I000937@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34372 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752058Ab0CITnQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:43:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rakib.mullick@gmail.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi: put acpi_battery_get/set_alarm into  CONFIG_ACPI_SYSFS_POWER
has been removed from the -mm tree.  Its filename was
     acpi-put-acpi_battery_get-set_alarm-into-config_acpi_sysfs_power.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: put acpi_battery_get/set_alarm into  CONFIG_ACPI_SYSFS_POWER
From: Rakib Mullick <rakib.mullick@gmail.com>

acpi_battery_get/set_alarm is only used when CONFIG_ACPI_SYSFS_POWER=y. 
So put this two functions under CONFIG_ACPI_SYSFS_POWER by shifting it
upward.

We were warned by the following warnings:

drivers/acpi/sbs.c:399: warning: `acpi_battery_get_alarm' defined but not used
drivers/acpi/sbs.c:406: warning: `acpi_battery_set_alarm' defined but not used

Also fixes a checkpatch warning in acpi_ac_get_present.

ERROR: space prohibited after that '&' (ctx:WxW)
#13: FILE: drivers/acpi/sbs.c:405:
+				 0x13, (u8 *) & status);
 				              ^

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sbs.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff -puN drivers/acpi/sbs.c~acpi-put-acpi_battery_get-set_alarm-into-config_acpi_sysfs_power drivers/acpi/sbs.c
--- a/drivers/acpi/sbs.c~acpi-put-acpi_battery_get-set_alarm-into-config_acpi_sysfs_power
+++ a/drivers/acpi/sbs.c
@@ -400,6 +400,20 @@ static int acpi_battery_get_state(struct
 	return result;
 }
 
+static int acpi_ac_get_present(struct acpi_sbs *sbs)
+{
+	int result;
+	u16 status;
+
+	result = acpi_smbus_read(sbs->hc, SMBUS_READ_WORD, ACPI_SBS_CHARGER,
+				 0x13, (u8 *) &status);
+	if (!result)
+		sbs->charger_present = (status >> 15) & 0x1;
+	return result;
+}
+
+#ifdef CONFIG_ACPI_SYSFS_POWER
+
 static int acpi_battery_get_alarm(struct acpi_battery *battery)
 {
 	return acpi_smbus_read(battery->sbs->hc, SMBUS_READ_WORD,
@@ -436,19 +450,6 @@ static int acpi_battery_set_alarm(struct
 	return ret;
 }
 
-static int acpi_ac_get_present(struct acpi_sbs *sbs)
-{
-	int result;
-	u16 status;
-
-	result = acpi_smbus_read(sbs->hc, SMBUS_READ_WORD, ACPI_SBS_CHARGER,
-				 0x13, (u8 *) & status);
-	if (!result)
-		sbs->charger_present = (status >> 15) & 0x1;
-	return result;
-}
