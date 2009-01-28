From: akpm@linux-foundation.org
Subject: [merged] dmi-introduce-dmi_first_match-to-make-the-interface-more-flexible.patch removed from -mm tree
Date: Wed, 28 Jan 2009 15:28:49 -0800
Message-ID: <200901282328.n0SNSnIr006751@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42601 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757583AbZA1X3x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Jan 2009 18:29:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, alan@lxorguk.ukuu.org.uk, elendil@planet.nl, fweisbec@gmail.com, jeff@garzik.org, maciej.rutecki@gmail.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     dmi: introduce dmi_first_match to make the interface more flexible
has been removed from the -mm tree.  Its filename was
     dmi-introduce-dmi_first_match-to-make-the-interface-more-flexible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dmi: introduce dmi_first_match to make the interface more flexible
From: Rafael J. Wysocki <rjw@sisk.pl>

Some notebooks from HP have the problem that their BIOSes attempt to spin
down hard drives before entering ACPI system states S4 and S5.  This leads
to a yo-yo effect during system power-off shutdown and the last phase of
hibernation when the disk is first spun down by the kernel and then almost
immediately turned on and off by the BIOS.  This, in turn, may result in
shortening the disk's life times.

To prevent this from happening we can blacklist the affected systems using
DMI information.  However, only the on-board controlles should be
blacklisted and their PCI slot numbers can be used for this purpose. 
Unfortunately the existing interface for checking DMI information of the
system is not very convenient for this purpose, because to use it, we
would have to define special callback functions or create a separate
struct dmi_system_id table for each blacklisted system.

To overcome this difficulty introduce a new function dmi_first_match()
returning a pointer to the first entry in an array of struct dmi_system_id
elements that matches the system DMI information.  Then, we can use this
pointer to access the entry's .driver_data field containing the additional
information, such as the PCI slot number, allowing us to do the desired
blacklisting.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Tested-by: Maciej Rutecki <maciej.rutecki@gmail.com>
Tested-by: Frans Pop <elendil@planet.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dmi_scan.c |   72 +++++++++++++++++++++++++---------
 include/linux/dmi.h         |    1 
 2 files changed, 55 insertions(+), 18 deletions(-)

diff -puN drivers/firmware/dmi_scan.c~dmi-introduce-dmi_first_match-to-make-the-interface-more-flexible drivers/firmware/dmi_scan.c
--- a/drivers/firmware/dmi_scan.c~dmi-introduce-dmi_first_match-to-make-the-interface-more-flexible
+++ a/drivers/firmware/dmi_scan.c
@@ -415,6 +415,29 @@ void __init dmi_scan_machine(void)
 }
 
 /**
+ *	dmi_matches - check if dmi_system_id structure matches system DMI data
+ *	@dmi: pointer to the dmi_system_id structure to check
+ */
+static bool dmi_matches(const struct dmi_system_id *dmi)
+{
+	int i;
+
+	WARN(!dmi_initialized, KERN_ERR "dmi check: not initialized yet.\n");
+
+	for (i = 0; i < ARRAY_SIZE(dmi->matches); i++) {
+		int s = dmi->matches[i].slot;
+		if (s == DMI_NONE)
+			continue;
+		if (dmi_ident[s]
+		    && strstr(dmi_ident[s], dmi->matches[i].substr))
+			continue;
+		/* No match */
+		return false;
+	}
+	return true;
+}
+
+/**
  *	dmi_check_system - check system DMI data
  *	@list: array of dmi_system_id structures to match against
  *		All non-null elements of the list must match
@@ -429,32 +452,45 @@ void __init dmi_scan_machine(void)
  */
 int dmi_check_system(const struct dmi_system_id *list)
 {
-	int i, count = 0;
-	const struct dmi_system_id *d = list;
+	int count = 0;
+	const struct dmi_system_id *d;
 
-	WARN(!dmi_initialized, KERN_ERR "dmi check: not initialized yet.\n");
-
-	while (d->ident) {
-		for (i = 0; i < ARRAY_SIZE(d->matches); i++) {
-			int s = d->matches[i].slot;
-			if (s == DMI_NONE)
-				continue;
-			if (dmi_ident[s] && strstr(dmi_ident[s], d->matches[i].substr))
-				continue;
-			/* No match */
-			goto fail;
+	for (d = list; d->ident; d++)
+		if (dmi_matches(d)) {
+			count++;
+			if (d->callback && d->callback(d))
+				break;
 		}
-		count++;
-		if (d->callback && d->callback(d))
-			break;
-fail:		d++;
-	}
 
 	return count;
 }
 EXPORT_SYMBOL(dmi_check_system);
 
 /**
+ *	dmi_first_match - find dmi_system_id structure matching system DMI data
+ *	@list: array of dmi_system_id structures to match against
+ *		All non-null elements of the list must match
+ *		their slot's (field index's) data (i.e., each
+ *		list string must be a substring of the specified
+ *		DMI slot's string data) to be considered a
+ *		successful match.
+ *
+ *	Walk the blacklist table until the first match is found.  Return the
+ *	pointer to the matching entry or NULL if there's no match.
+ */
+const struct dmi_system_id *dmi_first_match(const struct dmi_system_id *list)
+{
+	const struct dmi_system_id *d;
+
+	for (d = list; d->ident; d++)
+		if (dmi_matches(d))
+			return d;
+
+	return NULL;
+}
+EXPORT_SYMBOL(dmi_first_match);
+
+/**
  *	dmi_get_system_info - return DMI data value
  *	@field: data index (see enum dmi_field)
  *
diff -puN include/linux/dmi.h~dmi-introduce-dmi_first_match-to-make-the-interface-more-flexible include/linux/dmi.h
--- a/include/linux/dmi.h~dmi-introduce-dmi_first_match-to-make-the-interface-more-flexible
+++ a/include/linux/dmi.h
@@ -38,6 +38,7 @@ struct dmi_device {
 #ifdef CONFIG_DMI
 
 extern int dmi_check_system(const struct dmi_system_id *list);
+const struct dmi_system_id *dmi_first_match(const struct dmi_system_id *list);
 extern const char * dmi_get_system_info(int field);
 extern const struct dmi_device * dmi_find_device(int type, const char *name,
 	const struct dmi_device *from);
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
linux-next.patch
drivers-consolidate-driver_probe_done-loops-into-one-place.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
resume-wait-for-device-probing-to-finish.patch
misc-dell-laptop-should-depend-on-power_supply.patch
fbmem-copy_from-to_user-with-mutex-held-v3.patch
sata-ahci-blacklist-system-that-spins-off-disks-during-acpi-power-off.patch
shrink_slab-handle-bad-shrinkers.patch

