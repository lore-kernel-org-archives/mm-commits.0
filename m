From: akpm@osdl.org
Subject: + sony_acpi-fix-sony_acpi-backlight-registration-and-unregistration.patch added to -mm tree
Date: Mon, 22 Jan 2007 14:25:53 -0800
Message-ID: <200701222225.l0MMPrae003959@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58133 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932528AbXAVW0E (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jan 2007 17:26:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: malattia@linux.it


The patch titled
     sony_acpi: fix sony_acpi backlight registration and unregistration
has been added to the -mm tree.  Its filename is
     sony_acpi-fix-sony_acpi-backlight-registration-and-unregistration.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sony_acpi: fix sony_acpi backlight registration and unregistration
From: Mattia Dongili <malattia@linux.it>

Initialize the current brightness if the driver registration was successful
and unregister the driver in the error exit path.

Signed-off-by: Mattia Dongili <malattia@linux.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/acpi/sony_acpi.c |    8 ++++++++
 1 files changed, 8 insertions(+)

diff -puN drivers/acpi/sony_acpi.c~sony_acpi-fix-sony_acpi-backlight-registration-and-unregistration drivers/acpi/sony_acpi.c
--- a/drivers/acpi/sony_acpi.c~sony_acpi-fix-sony_acpi-backlight-registration-and-unregistration
+++ a/drivers/acpi/sony_acpi.c
@@ -354,9 +354,14 @@ static int sony_acpi_add(struct acpi_dev
 	if (ACPI_SUCCESS(acpi_get_handle(sony_acpi_handle, "GBRT", &handle))) {
 		sony_backlight_device = backlight_device_register("sony", NULL,
 					NULL, &sony_backlight_properties);
+
 	        if (IS_ERR(sony_backlight_device)) {
         	        printk(LOG_PFX "unable to register backlight device\n");
+			sony_backlight_device = NULL;
 		}
+		else
+			sony_backlight_properties.brightness =
+				sony_backlight_get_brightness(sony_backlight_device);
 	}
 
 	for (item = sony_acpi_values; item->name; ++item) {
@@ -400,6 +405,9 @@ static int sony_acpi_add(struct acpi_dev
 	return 0;
 
 outproc:
+	if (sony_backlight_device)
+		backlight_device_unregister(sony_backlight_device);
+
 	for (item = sony_acpi_values; item->name; ++item)
 		if (item->proc)
 			remove_proc_entry(item->name, acpi_device_dir(device));
_

Patches currently in -mm which might be from malattia@linux.it are

sony_acpi-addacpi_bus_generate-event.patch
sony_acpi-addacpi_bus_generate-event-fix.patch
sony_acpi-add-lanpower-and-audiopower-controls.patch
sony_acpi-allow-multiple-sony_acpi_values-for-the-same-name.patch
sony_acpi-fix-sony_acpi-backlight-registration-and-unregistration.patch
rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix-3.patch
fix-x86_64-mm-i386-config-core2.patch
