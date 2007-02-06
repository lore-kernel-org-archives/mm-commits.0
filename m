From: akpm@linux-foundation.org
Subject: - sony_acpi-addacpi_bus_generate-event-fix.patch removed from -mm tree
Date: Mon, 05 Feb 2007 16:07:09 -0800
Message-ID: <200702060008.l1608C8I003656@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40500 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965121AbXBFAIX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 19:08:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: malattia@linux.it, mm-commits@vger.kernel.org


The patch titled
     Allow easier debugging for the unknown SNC methods.
has been removed from the -mm tree.  Its filename was
     sony_acpi-addacpi_bus_generate-event-fix.patch

This patch was dropped because it was folded into sony_acpi-addacpi_bus_generate-event.patch

------------------------------------------------------
Subject: Allow easier debugging for the unknown SNC methods.
From: Mattia Dongili <malattia@linux.it>

Allow the existence of a setter method without a getter and viceversa,
additionaly set /proc file permissions reflecting it.  Fix also the error
exit path.

Signed-off-by: Mattia Dongili <malattia@linux.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/acpi/sony_acpi.c |   30 +++++++++++++++++++++---------
 1 files changed, 21 insertions(+), 9 deletions(-)

diff -puN drivers/acpi/sony_acpi.c~sony_acpi-addacpi_bus_generate-event-fix drivers/acpi/sony_acpi.c
--- a/drivers/acpi/sony_acpi.c~sony_acpi-addacpi_bus_generate-event-fix
+++ a/drivers/acpi/sony_acpi.c
@@ -296,6 +296,7 @@ static int sony_acpi_add(struct acpi_dev
 	acpi_status status;
 	int result;
 	acpi_handle handle;
+	mode_t proc_file_mode;
 	struct sony_acpi_value *item;
 
 	sony_acpi_acpi_device = device;
@@ -334,20 +335,31 @@ static int sony_acpi_add(struct acpi_dev
 	}
 
 	for (item = sony_acpi_values; item->name; ++item) {
+		proc_file_mode = 0;
+
 		if (!debug && item->debug)
 			continue;
 
 		if (item->acpiget &&
-		    ACPI_FAILURE(acpi_get_handle(sony_acpi_handle,
+		    ACPI_SUCCESS(acpi_get_handle(sony_acpi_handle,
 		    		 item->acpiget, &handle)))
-		    	continue;
+			proc_file_mode = S_IRUSR;
+		else
+			printk(LOG_PFX "unable to get ACPI handle for %s (get)\n",
+					item->name);
 
 		if (item->acpiset &&
-		    ACPI_FAILURE(acpi_get_handle(sony_acpi_handle,
+		    ACPI_SUCCESS(acpi_get_handle(sony_acpi_handle,
 		    		 item->acpiset, &handle)))
-		    	continue;
+			proc_file_mode |= S_IWUSR;
+		else
+			printk(LOG_PFX "unable to get ACPI handle for %s (set)\n",
+					item->name);
+
+		if (proc_file_mode == 0)
+			continue;
 
-		item->proc = create_proc_entry(item->name, 0666,
+		item->proc = create_proc_entry(item->name, proc_file_mode,
 					       acpi_device_dir(device));
 		if (!item->proc) {
 			printk(LOG_PFX "unable to create proc entry\n");
@@ -366,15 +378,15 @@ static int sony_acpi_add(struct acpi_dev
 	return 0;
 
 outproc:
+	for (item = sony_acpi_values; item->name; ++item)
+		if (item->proc)
+			remove_proc_entry(item->name, acpi_device_dir(device));
+outnotify:
 	status = acpi_remove_notify_handler(sony_acpi_handle,
 					    ACPI_DEVICE_NOTIFY,
 					    sony_acpi_notify);
 	if (ACPI_FAILURE(status))
 		printk(LOG_PFX "unable to remove notify handler\n");
-outnotify:
-	for (item = sony_acpi_values; item->name; ++item)
-		if (item->proc)
-			remove_proc_entry(item->name, acpi_device_dir(device));
 outwalk:
 	return result;
 }
_

Patches currently in -mm which might be from malattia@linux.it are

sony_acpi-addacpi_bus_generate-event.patch
sony_acpi-addacpi_bus_generate-event-fix.patch
sony_acpi-add-lanpower-and-audiopower-controls.patch
sony_acpi-allow-multiple-sony_acpi_values-for-the-same-name.patch
sony_acpi-fix-sony_acpi-backlight-registration-and-unregistration.patch
rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix-3.patch
fix-x86_64-mm-i386-config-core2.patch
