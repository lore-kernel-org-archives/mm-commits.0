From: akpm@linux-foundation.org
Subject: [merged] acpi-battery-work-around-negative-s16-battery-current-on-acer.patch removed from -mm tree
Date: Mon, 31 Aug 2009 14:18:40 -0700
Message-ID: <200908312118.n7VLIe7D018331@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750829AbZHaVUN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Aug 2009 17:20:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hector@marcansoft.com, astarikovskiy@suse.de, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi battery: work around negative s16 battery current on Acer
has been removed from the -mm tree.  Its filename was
     acpi-battery-work-around-negative-s16-battery-current-on-acer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi battery: work around negative s16 battery current on Acer
From: Hector Martin <hector@marcansoft.com>

Acer Aspire 8930G laptops (and possibly others) report the battery current
as a 16-bit signed negative when it is charging.  It also reports it as
0x10000 when the current is 0.  This patch adds a quirk for this which
takes the absolute value of the reported current cast to an s16.  This is
a DSDT bug present in the latest BIOS revision (the EC register is 16 bits
signed and the DSDT attempts to take the 16-bit two's complement of this,
which works for discharge but not charge.  It also breaks zero values
because a 32-bit register is used and the high bits aren't thrown away).

I've enabled this for all Acer systems which report in mA units.  This
should be safe since it won't break compliant systems unless they report a
current above 32A, which is insane.  The patch also detects the valid
32-bit value -1, which indicates unknown status, and does not attempt the
fix in that case (note that this does not conflict with 16-bit -1, which
is 65535 as read normally and gets translated to 1mA).

Signed-off-by: Hector Martin <hector@marcansoft.com>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/battery.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff -puN drivers/acpi/battery.c~acpi-battery-work-around-negative-s16-battery-current-on-acer drivers/acpi/battery.c
--- a/drivers/acpi/battery.c~acpi-battery-work-around-negative-s16-battery-current-on-acer
+++ a/drivers/acpi/battery.c
@@ -87,6 +87,10 @@ static const struct acpi_device_id batte
 
 MODULE_DEVICE_TABLE(acpi, battery_device_ids);
 
+/* For buggy DSDTs that report negative 16-bit values for either charging
+ * or discharging current and/or report 0 as 65536 due to bad math.
+ */
+#define QUIRK_SIGNED16_CURRENT 0x0001
 
 struct acpi_battery {
 	struct mutex lock;
@@ -114,6 +118,7 @@ struct acpi_battery {
 	int state;
 	int power_unit;
 	u8 alarm_present;
+	long quirks;
 };
 
 #define to_acpi_battery(x) container_of(x, struct acpi_battery, bat);
@@ -392,6 +397,11 @@ static int acpi_battery_get_state(struct
 				 state_offsets, ARRAY_SIZE(state_offsets));
 	battery->update_time = jiffies;
 	kfree(buffer.pointer);
+
+	if ((battery->quirks & QUIRK_SIGNED16_CURRENT) &&
+	    battery->rate_now != -1)
+		battery->rate_now = abs((s16)battery->rate_now);
+
 	return result;
 }
 
@@ -497,6 +507,14 @@ static void sysfs_remove_battery(struct 
 }
 #endif
 
+static void acpi_battery_quirks(struct acpi_battery *battery)
+{
+	battery->quirks = 0;
+	if (dmi_name_in_vendors("Acer") && battery->power_unit) {
+		battery->quirks |= QUIRK_SIGNED16_CURRENT;
+	}
+}
+
 static int acpi_battery_update(struct acpi_battery *battery)
 {
 	int result, old_present = acpi_battery_present(battery);
@@ -515,6 +533,7 @@ static int acpi_battery_update(struct ac
 		result = acpi_battery_get_info(battery);
 		if (result)
 			return result;
+		acpi_battery_quirks(battery);
 		acpi_battery_init_alarm(battery);
 	}
 #ifdef CONFIG_ACPI_SYSFS_POWER
_

Patches currently in -mm which might be from hector@marcansoft.com are

linux-next.patch

