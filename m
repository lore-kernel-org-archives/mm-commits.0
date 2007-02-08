From: akpm@linux-foundation.org
Subject: - sony_acpi-addacpi_bus_generate-event.patch removed from -mm tree
Date: Thu, 08 Feb 2007 01:13:13 -0800
Message-ID: <200702080913.l189DDwM010301@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34605 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423169AbXBHJNZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 04:13:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stelian@popies.net, malattia@linux.it, nilton.volpato@gmail.com, mm-commits@vger.kernel.org


The patch titled
     sony_acpi: add acpi_bus_generate event
has been removed from the -mm tree.  Its filename was
     sony_acpi-addacpi_bus_generate-event.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sony_acpi: add acpi_bus_generate event
From: Stelian Pop <stelian@popies.net>

Added acpi_bus_generate event for forwarding Fn-keys pressed to acpi subsystem,
and made correspondent necessary changes for this to work.


Allow the existence of a setter method without a getter and viceversa,
additionaly set /proc file permissions reflecting it.  Fix also the error
exit path.

Signed-off-by: Mattia Dongili <malattia@linux.it>
Signed-off-by: Nilton Volpato <nilton.volpato@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sony_acpi.c |   75 ++++++++++++++++++++++---------------
 1 file changed, 45 insertions(+), 30 deletions(-)

diff -puN drivers/acpi/sony_acpi.c~sony_acpi-addacpi_bus_generate-event drivers/acpi/sony_acpi.c
--- a/drivers/acpi/sony_acpi.c~sony_acpi-addacpi_bus_generate-event
+++ a/drivers/acpi/sony_acpi.c
@@ -54,6 +54,7 @@ MODULE_PARM_DESC(debug, "set this to 1 (
 
 static acpi_handle sony_acpi_handle;
 static struct proc_dir_entry *sony_acpi_dir;
+static struct acpi_device *sony_acpi_acpi_device = NULL;
 
 static int sony_backlight_update_status(struct backlight_device *bd);
 static int sony_backlight_get_brightness(struct backlight_device *bd);
@@ -270,7 +271,9 @@ static int sony_acpi_resume(struct acpi_
 
 static void sony_acpi_notify(acpi_handle handle, u32 event, void *data)
 {
-	printk(LOG_PFX "sony_acpi_notify\n");
+	if (debug)
+		printk(LOG_PFX "sony_acpi_notify, event: %d\n", event);
+	acpi_bus_generate_event(sony_acpi_acpi_device, 1, event);
 }
 
 static acpi_status sony_walk_callback(acpi_handle handle, u32 level,
@@ -293,8 +296,11 @@ static int sony_acpi_add(struct acpi_dev
 	acpi_status status;
 	int result;
 	acpi_handle handle;
+	mode_t proc_file_mode;
 	struct sony_acpi_value *item;
 
+	sony_acpi_acpi_device = device;
+
 	sony_acpi_handle = device->handle;
 
 	acpi_driver_data(device) = NULL;
@@ -308,16 +314,16 @@ static int sony_acpi_add(struct acpi_dev
 			result = -ENODEV;
 			goto outwalk;
 		}
+	}
 
-		status = acpi_install_notify_handler(sony_acpi_handle,
-						     ACPI_DEVICE_NOTIFY,
-						     sony_acpi_notify,
-						     NULL);
-		if (ACPI_FAILURE(status)) {
-			printk(LOG_PFX "unable to install notify handler\n");
-			result = -ENODEV;
-			goto outnotify;
-		}
+	status = acpi_install_notify_handler(sony_acpi_handle,
+					     ACPI_DEVICE_NOTIFY,
+					     sony_acpi_notify,
+					     NULL);
+	if (ACPI_FAILURE(status)) {
+		printk(LOG_PFX "unable to install notify handler\n");
+		result = -ENODEV;
+		goto outnotify;
 	}
 
 	if (ACPI_SUCCESS(acpi_get_handle(sony_acpi_handle, "GBRT", &handle))) {
@@ -329,20 +335,31 @@ static int sony_acpi_add(struct acpi_dev
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
 
-		item->proc = create_proc_entry(item->name, 0600,
+		item->proc = create_proc_entry(item->name, proc_file_mode,
 					       acpi_device_dir(device));
 		if (!item->proc) {
 			printk(LOG_PFX "unable to create proc entry\n");
@@ -361,17 +378,15 @@ static int sony_acpi_add(struct acpi_dev
 	return 0;
 
 outproc:
-	if (debug) {
-		status = acpi_remove_notify_handler(sony_acpi_handle,
-						    ACPI_DEVICE_NOTIFY,
-						    sony_acpi_notify);
-		if (ACPI_FAILURE(status))
-			printk(LOG_PFX "unable to remove notify handler\n");
-	}
-outnotify:
 	for (item = sony_acpi_values; item->name; ++item)
 		if (item->proc)
 			remove_proc_entry(item->name, acpi_device_dir(device));
+outnotify:
+	status = acpi_remove_notify_handler(sony_acpi_handle,
+					    ACPI_DEVICE_NOTIFY,
+					    sony_acpi_notify);
+	if (ACPI_FAILURE(status))
+		printk(LOG_PFX "unable to remove notify handler\n");
 outwalk:
 	return result;
 }
@@ -384,13 +399,13 @@ static int sony_acpi_remove(struct acpi_
 	if (sony_backlight_device)
 		backlight_device_unregister(sony_backlight_device);
 
-	if (debug) {
-		status = acpi_remove_notify_handler(sony_acpi_handle,
-						    ACPI_DEVICE_NOTIFY,
-						    sony_acpi_notify);
-		if (ACPI_FAILURE(status))
-			printk(LOG_PFX "unable to remove notify handler\n");
-	}
+	sony_acpi_acpi_device = NULL;
+
+	status = acpi_remove_notify_handler(sony_acpi_handle,
+					    ACPI_DEVICE_NOTIFY,
+					    sony_acpi_notify);
+	if (ACPI_FAILURE(status))
+		printk(LOG_PFX "unable to remove notify handler\n");
 
 	for (item = sony_acpi_values; item->name; ++item)
 		if (item->proc)
_

Patches currently in -mm which might be from stelian@popies.net are

git-acpi.patch
sony_acpi-addacpi_bus_generate-event.patch
