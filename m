From: akpm@linux-foundation.org
Subject: + acpi-sbs-fix-retval-warning.patch added to -mm tree
Date: Wed, 24 Oct 2007 16:23:22 -0700
Message-ID: <200710242323.l9ONNNmG017765@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58578 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752003AbXJXXXo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 19:23:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeff@garzik.org, jgarzik@redhat.com


The patch titled
     ACPI sbs: fix retval warning
has been added to the -mm tree.  Its filename is
     acpi-sbs-fix-retval-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ACPI sbs: fix retval warning
From: Jeff Garzik <jeff@garzik.org>

drivers/acpi/sbs.c: In function `acpi_battery_add':
drivers/acpi/sbs.c:811: warning: ignoring return value of `device_create_file', declared with attribute warn_unused_result

Additional cleanups:
* use struct acpi_battery in acpi_battery_remove() to clean up function
calls, just like acpi_battery_add() already does.

* un-indent unregister call, as it mistakenly gives the impression that
it belongs inside the 'if' test

* remove unneeded braces

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sbs.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff -puN drivers/acpi/sbs.c~acpi-sbs-fix-retval-warning drivers/acpi/sbs.c
--- a/drivers/acpi/sbs.c~acpi-sbs-fix-retval-warning
+++ a/drivers/acpi/sbs.c
@@ -113,6 +113,7 @@ struct acpi_battery {
 	u16 spec;
 	u8 id;
 	u8 present:1;
+	u8 have_sysfs:1;
 };
 
 #define to_acpi_battery(x) container_of(x, struct acpi_battery, bat);
@@ -808,7 +809,8 @@ static int acpi_battery_add(struct acpi_
 	}
 	battery->bat.get_property = acpi_sbs_battery_get_property;
 	result = power_supply_register(&sbs->device->dev, &battery->bat);
-	device_create_file(battery->bat.dev, &alarm_attr);
+	if (device_create_file(battery->bat.dev, &alarm_attr) == 0)
+		battery->have_sysfs = 1;
 	printk(KERN_INFO PREFIX "%s [%s]: Battery Slot [%s] (battery %s)\n",
 	       ACPI_SBS_DEVICE_NAME, acpi_device_bid(sbs->device),
 	       battery->name, sbs->battery->present ? "present" : "absent");
@@ -817,14 +819,16 @@ static int acpi_battery_add(struct acpi_
 
 static void acpi_battery_remove(struct acpi_sbs *sbs, int id)
 {
-	if (sbs->battery[id].bat.dev)
-		device_remove_file(sbs->battery[id].bat.dev, &alarm_attr);
-		power_supply_unregister(&sbs->battery[id].bat);
+	struct acpi_battery *battery = &sbs->battery[id];
+
+	if (battery->have_sysfs)
+		device_remove_file(battery->bat.dev, &alarm_attr);
+
+	power_supply_unregister(&battery->bat);
+
 #ifdef CONFIG_ACPI_PROCFS
-	if (sbs->battery[id].proc_entry) {
-		acpi_sbs_remove_fs(&(sbs->battery[id].proc_entry),
-				   acpi_battery_dir);
-	}
+	if (sbs->battery[id].proc_entry)
+		acpi_sbs_remove_fs(&battery->proc_entry, acpi_battery_dir);
 #endif
 }
 
_

Patches currently in -mm which might be from jeff@garzik.org are

git-jg-misc.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
scsi-expose-an-support-to-user-space.patch
libata-expose-an-to-user-space.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
scsi-use-notifier-chain-for-asynchronous-event.patch
git-wireless.patch
fix-versus-precedence-in-various-places.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
x86-fix-config_smp-warning-in-processorc.patch
acpi-sbs-fix-retval-warning.patch
riscom8-fix-smp-brokenness.patch
isdn-sc-fix-longstanding-warning.patch
mac80211-fix-warning-created-by-bit.patch
