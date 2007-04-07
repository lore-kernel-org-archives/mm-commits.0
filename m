From: akpm@linux-foundation.org
Subject: + sanitize-printks.patch added to -mm tree
Date: Fri, 06 Apr 2007 18:32:33 -0700
Message-ID: <200704070132.l371WX8j024878@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42013 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964931AbXDGBfM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 21:35:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: malattia@linux.it, lenb@kernel.org, stelian@popies.net


The patch titled
     sony-laptop: sanitize printks
has been added to the -mm tree.  Its filename is
     sanitize-printks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sony-laptop: sanitize printks
From: Mattia Dongili <malattia@linux.it>

Unify printks to resemble a unique driver :)

Signed-off-by: Mattia Dongili <malattia@linux.it>
Cc: Len Brown <lenb@kernel.org>
Cc: Stelian Pop <stelian@popies.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sony-laptop.c |   40 ++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff -puN drivers/misc/sony-laptop.c~sanitize-printks drivers/misc/sony-laptop.c
--- a/drivers/misc/sony-laptop.c~sanitize-printks
+++ a/drivers/misc/sony-laptop.c
@@ -64,20 +64,19 @@
 #include <linux/sonypi.h>
 
 #define DRV_PFX			"sony-laptop: "
-#define LOG_PFX			KERN_WARNING DRV_PFX
 #define dprintk(msg...)		do {			\
-	if (debug) printk(LOG_PFX  msg);		\
+	if (debug) printk(KERN_WARNING DRV_PFX  msg);	\
 } while (0)
 
 #define SONY_LAPTOP_DRIVER_VERSION	"0.5"
 
 #define SONY_NC_CLASS		"sony-nc"
 #define SONY_NC_HID		"SNY5001"
-#define SONY_NC_DRIVER_NAME	"Sony Notebook Control"
+#define SONY_NC_DRIVER_NAME	"Sony Notebook Control Driver"
 
 #define SONY_PIC_CLASS		"sony-pic"
 #define SONY_PIC_HID		"SNY6001"
-#define SONY_PIC_DRIVER_NAME	"Sony Programmable IO Control"
+#define SONY_PIC_DRIVER_NAME	"Sony Programmable IO Control Driver"
 
 MODULE_AUTHOR("Stelian Pop, Mattia Dongili");
 MODULE_DESCRIPTION("Sony laptop extras driver (SPIC and SNC ACPI device)");
@@ -518,7 +517,7 @@ static int acpi_callgetfunc(acpi_handle 
 		return 0;
 	}
 
-	printk(LOG_PFX "acpi_callreadfunc failed\n");
+	printk(KERN_WARNING DRV_PFX "acpi_callreadfunc failed\n");
 
 	return -1;
 }
@@ -544,7 +543,7 @@ static int acpi_callsetfunc(acpi_handle 
 	if (status == AE_OK) {
 		if (result != NULL) {
 			if (out_obj.type != ACPI_TYPE_INTEGER) {
-				printk(LOG_PFX "acpi_evaluate_object bad "
+				printk(KERN_WARNING DRV_PFX "acpi_evaluate_object bad "
 				       "return type\n");
 				return -1;
 			}
@@ -553,7 +552,7 @@ static int acpi_callsetfunc(acpi_handle 
 		return 0;
 	}
 
-	printk(LOG_PFX "acpi_evaluate_object failed\n");
+	printk(KERN_WARNING DRV_PFX "acpi_evaluate_object failed\n");
 
 	return -1;
 }
@@ -689,7 +688,7 @@ static acpi_status sony_walk_callback(ac
 	node = (struct acpi_namespace_node *)handle;
 	operand = (union acpi_operand_object *)node->object;
 
-	printk(LOG_PFX "method: name: %4.4s, args %X\n", node->name.ascii,
+	printk(KERN_WARNING DRV_PFX "method: name: %4.4s, args %X\n", node->name.ascii,
 	       (u32) operand->method.param_count);
 
 	return AE_OK;
@@ -724,6 +723,9 @@ static int sony_nc_add(struct acpi_devic
 	acpi_handle handle;
 	struct sony_nc_value *item;
 
+	printk(KERN_INFO DRV_PFX "%s v%s.\n",
+		SONY_NC_DRIVER_NAME, SONY_LAPTOP_DRIVER_VERSION);
+
 	sony_nc_acpi_device = device;
 	strcpy(acpi_device_class(device), "sony/hotkey");
 
@@ -733,7 +735,7 @@ static int sony_nc_add(struct acpi_devic
 		status = acpi_walk_namespace(ACPI_TYPE_METHOD, sony_nc_acpi_handle,
 					     1, sony_walk_callback, NULL, NULL);
 		if (ACPI_FAILURE(status)) {
-			printk(LOG_PFX "unable to walk acpi resources\n");
+			printk(KERN_WARNING DRV_PFX "unable to walk acpi resources\n");
 			result = -ENODEV;
 			goto outwalk;
 		}
@@ -751,7 +753,7 @@ static int sony_nc_add(struct acpi_devic
 					     ACPI_DEVICE_NOTIFY,
 					     sony_acpi_notify, NULL);
 	if (ACPI_FAILURE(status)) {
-		printk(LOG_PFX "unable to install notify handler\n");
+		printk(KERN_WARNING DRV_PFX "unable to install notify handler\n");
 		result = -ENODEV;
 		goto outinput;
 	}
@@ -762,7 +764,7 @@ static int sony_nc_add(struct acpi_devic
 								  &sony_backlight_ops);
 
 		if (IS_ERR(sony_backlight_device)) {
-			printk(LOG_PFX "unable to register backlight device\n");
+			printk(KERN_WARNING DRV_PFX "unable to register backlight device\n");
 			sony_backlight_device = NULL;
 		} else {
 			sony_backlight_device->props.brightness =
@@ -817,8 +819,6 @@ static int sony_nc_add(struct acpi_devic
 		}
 	}
 
-	printk(KERN_INFO SONY_NC_DRIVER_NAME " successfully installed\n");
-
 	return 0;
 
       out_sysfs:
@@ -835,7 +835,7 @@ static int sony_nc_add(struct acpi_devic
 					    ACPI_DEVICE_NOTIFY,
 					    sony_acpi_notify);
 	if (ACPI_FAILURE(status))
-		printk(LOG_PFX "unable to remove notify handler\n");
+		printk(KERN_WARNING DRV_PFX "unable to remove notify handler\n");
 
       outinput:
 	sony_laptop_remove_input();
@@ -858,7 +858,7 @@ static int sony_nc_remove(struct acpi_de
 					    ACPI_DEVICE_NOTIFY,
 					    sony_acpi_notify);
 	if (ACPI_FAILURE(status))
-		printk(LOG_PFX "unable to remove notify handler\n");
+		printk(KERN_WARNING DRV_PFX "unable to remove notify handler\n");
 
 	for (item = sony_nc_values; item->name; ++item) {
 		device_remove_file(&sony_pf_device->dev, &item->devattr);
@@ -866,8 +866,7 @@ static int sony_nc_remove(struct acpi_de
 
 	sony_pf_remove();
 	sony_laptop_remove_input();
-
-	printk(KERN_INFO SONY_NC_DRIVER_NAME " successfully removed\n");
+	dprintk(SONY_NC_DRIVER_NAME " removed.\n");
 
 	return 0;
 }
@@ -1645,7 +1644,7 @@ static int sony_pic_remove(struct acpi_d
 	spic_dev.cur_ioport = NULL;
 	spic_dev.cur_irq = NULL;
 
-	dprintk("removed.\n");
+	dprintk(SONY_PIC_DRIVER_NAME " removed.\n");
 	return 0;
 }
 
@@ -1655,9 +1654,8 @@ static int sony_pic_add(struct acpi_devi
 	struct sony_pic_ioport *io, *tmp_io;
 	struct sony_pic_irq *irq, *tmp_irq;
 
-	printk(KERN_INFO DRV_PFX
-		"Sony Programmable I/O Controller Driver v%s.\n",
-		SONY_LAPTOP_DRIVER_VERSION);
+	printk(KERN_INFO DRV_PFX "%s v%s.\n",
+		SONY_PIC_DRIVER_NAME, SONY_LAPTOP_DRIVER_VERSION);
 
 	spic_dev.acpi_dev = device;
 	strcpy(acpi_device_class(device), "sony/hotkey");
_

Patches currently in -mm which might be from malattia@linux.it are

remove-acpi-references-from-variable-and-function-names.patch
prepare-the-platform-driver-for-multiple-users.patch
add-debug-macros-also-used-by-the-sonypi-reimplementation.patch
add-sny6001-device-handling-sonypi-reimplementation.patch
unify-the-input-subsystem-event-forwarding.patch
additional-platform-attributes-coming-from-sny6001.patch
sanitize-printks.patch
update-documentation-and-kconfig-help.patch
git-cpufreq.patch
