From: akpm@linux-foundation.org
Subject: - acpi-battery-remove-cycle-from-battery-removal.patch removed from -mm tree
Date: Thu, 08 Nov 2007 10:29:31 -0800
Message-ID: <200711081829.lA8ITV6r008391@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35988 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760783AbXKHS37 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2007 13:29:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: astarikovskiy@suse.de, eike-kernel@sf-tec.de, hannes-kernel@saeurebad.de, lenb@kernel.org, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     ACPI: Battery: remove cycle from battery removal
has been removed from the -mm tree.  Its filename was
     acpi-battery-remove-cycle-from-battery-removal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ACPI: Battery: remove cycle from battery removal
From: Alexey Starikovskiy <astarikovskiy@suse.de>

get_property() should not call battery_update() on absent battery to
avoid cycle and oops.

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Tested-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Acked-by: Johannes Weiner <hannes-kernel@saeurebad.de>
Cc: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/battery.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/acpi/battery.c~acpi-battery-remove-cycle-from-battery-removal drivers/acpi/battery.c
--- a/drivers/acpi/battery.c~acpi-battery-remove-cycle-from-battery-removal
+++ a/drivers/acpi/battery.c
@@ -132,7 +132,7 @@ static int acpi_battery_technology(struc
 	return POWER_SUPPLY_TECHNOLOGY_UNKNOWN;
 }
 
-static int acpi_battery_update(struct acpi_battery *battery);
+static int acpi_battery_get_state(struct acpi_battery *battery);
 
 static int acpi_battery_get_property(struct power_supply *psy,
 				     enum power_supply_property psp,
@@ -140,10 +140,11 @@ static int acpi_battery_get_property(str
 {
 	struct acpi_battery *battery = to_acpi_battery(psy);
 
-	if ((!acpi_battery_present(battery)) &&
-	     psp != POWER_SUPPLY_PROP_PRESENT)
+	if (acpi_battery_present(battery)) {
+		/* run battery update only if it is present */
+		acpi_battery_get_state(battery);
+	} else if (psp != POWER_SUPPLY_PROP_PRESENT)
 		return -ENODEV;
-	acpi_battery_update(battery);
 	switch (psp) {
 	case POWER_SUPPLY_PROP_STATUS:
 		if (battery->state & 0x01)
@@ -457,6 +458,7 @@ static void sysfs_remove_battery(struct 
 		return;
 	device_remove_file(battery->bat.dev, &alarm_attr);
 	power_supply_unregister(&battery->bat);
+	battery->bat.dev = NULL;
 }
 
 static int acpi_battery_update(struct acpi_battery *battery)
_

Patches currently in -mm which might be from astarikovskiy@suse.de are

origin.patch
acpi-battery-remove-cycle-from-battery-removal.patch
git-acpi.patch
make-proc-acpi-ac_adapter-dependent-on-acpi_procfs.patch
acpi-ac-update-ac-state-on-resume.patch
