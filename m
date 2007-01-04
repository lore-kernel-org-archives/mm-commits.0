From: akpm@osdl.org
Subject: + sony_acpi-addacpi_bus_generate-event.patch added to -mm tree
Date: Thu, 04 Jan 2007 15:44:20 -0800
Message-ID: <200701042344.l04NiKnS002940@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36963 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030279AbXADXoi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 18:44:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stelian@popies.net, malattia@linux.it, nilton.volpato@gmail.com


The patch titled
     sony_acpi: add acpi_bus_generate event
has been added to the -mm tree.  Its filename is
     sony_acpi-addacpi_bus_generate-event.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sony_acpi: add acpi_bus_generate event
From: Stelian Pop <stelian@popies.net>

Added acpi_bus_generate event for forwarding Fn-keys pressed to acpi subsystem,
and made correspondent necessary changes for this to work.

Signed-off-by: Nilton Volpato <nilton.volpato@gmail.com>
Cc: Mattia Dongili <malattia@linux.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/acpi/sony_acpi.c |   53 +++++++++++++++++++------------------
 1 files changed, 28 insertions(+), 25 deletions(-)

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
@@ -295,6 +298,8 @@ static int sony_acpi_add(struct acpi_dev
 	acpi_handle handle;
 	struct sony_acpi_value *item;
 
+	sony_acpi_acpi_device = device;
+
 	sony_acpi_handle = device->handle;
 
 	acpi_driver_data(device) = NULL;
@@ -308,16 +313,16 @@ static int sony_acpi_add(struct acpi_dev
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
@@ -342,7 +347,7 @@ static int sony_acpi_add(struct acpi_dev
 		    		 item->acpiset, &handle)))
 		    	continue;
 
-		item->proc = create_proc_entry(item->name, 0600,
+		item->proc = create_proc_entry(item->name, 0666,
 					       acpi_device_dir(device));
 		if (!item->proc) {
 			printk(LOG_PFX "unable to create proc entry\n");
@@ -361,13 +366,11 @@ static int sony_acpi_add(struct acpi_dev
 	return 0;
 
 outproc:
-	if (debug) {
-		status = acpi_remove_notify_handler(sony_acpi_handle,
-						    ACPI_DEVICE_NOTIFY,
-						    sony_acpi_notify);
-		if (ACPI_FAILURE(status))
-			printk(LOG_PFX "unable to remove notify handler\n");
-	}
+	status = acpi_remove_notify_handler(sony_acpi_handle,
+					    ACPI_DEVICE_NOTIFY,
+					    sony_acpi_notify);
+	if (ACPI_FAILURE(status))
+		printk(LOG_PFX "unable to remove notify handler\n");
 outnotify:
 	for (item = sony_acpi_values; item->name; ++item)
 		if (item->proc)
@@ -384,13 +387,13 @@ static int sony_acpi_remove(struct acpi_
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

2.6-sony_acpi4.patch
sony_apci-resume.patch
acpi-add-backlight-support-to-the-sony_acpi.patch
sony_acpi-addacpi_bus_generate-event.patch
