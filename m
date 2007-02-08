From: akpm@linux-foundation.org
Subject: - sony_acpi-fix-sony_acpi-backlight-registration-and-unregistration.patch removed from -mm tree
Date: Thu, 08 Feb 2007 01:13:23 -0800
Message-ID: <200702080913.l189DNok010313@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34608 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423169AbXBHJN3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 04:13:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: malattia@linux.it, mm-commits@vger.kernel.org


The patch titled
     sony_acpi: fix sony_acpi backlight registration and unregistration
has been removed from the -mm tree.  Its filename was
     sony_acpi-fix-sony_acpi-backlight-registration-and-unregistration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sony_acpi: fix sony_acpi backlight registration and unregistration
From: Mattia Dongili <malattia@linux.it>

Initialize the current brightness if the driver registration was successful
and unregister the driver in the error exit path.

Signed-off-by: Mattia Dongili <malattia@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sony_acpi.c |    8 ++++++++
 1 file changed, 8 insertions(+)

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

git-acpi.patch
sony_acpi-fix-sony_acpi-backlight-registration-and-unregistration.patch
rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues.patch
