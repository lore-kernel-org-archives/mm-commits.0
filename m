From: akpm@linux-foundation.org
Subject: - sony-laptop-add-debug-macros-also-used-by-the-sonypi-reimplementation.patch removed from -mm tree
Date: Wed, 11 Apr 2007 16:20:41 -0700
Message-ID: <200704112320.l3BNKfct017502@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35919 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161412AbXDKXV6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 19:21:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: malattia@linux.it, lenb@kernel.org, stelian@popies.net, mm-commits@vger.kernel.org


The patch titled
     sony-laptop: add debug macros also used by the sonypi reimplementation
has been removed from the -mm tree.  Its filename was
     sony-laptop-add-debug-macros-also-used-by-the-sonypi-reimplementation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sony-laptop: add debug macros also used by the sonypi reimplementation
From: Mattia Dongili <malattia@linux.it>

Signed-off-by: Mattia Dongili <malattia@linux.it>
Cc: Len Brown <lenb@kernel.org>
Cc: Stelian Pop <stelian@popies.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sony-laptop.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/misc/sony-laptop.c~add-debug-macros-also-used-by-the-sonypi-reimplementation drivers/misc/sony-laptop.c
--- a/drivers/misc/sony-laptop.c~add-debug-macros-also-used-by-the-sonypi-reimplementation
+++ a/drivers/misc/sony-laptop.c
@@ -35,6 +35,11 @@
 #include <acpi/acpi_bus.h>
 #include <asm/uaccess.h>
 
+#define LOG_PFX			KERN_WARNING "sony-laptop: "
+#define dprintk(msg...)		do {			\
+	if (debug) printk(KERN_WARNING LOG_PFX  msg);	\
+} while (0)
+
 #define SONY_NC_CLASS		"sony"
 #define SONY_NC_HID		"SNY5001"
 #define SONY_NC_DRIVER_NAME	"ACPI Sony Notebook Control Driver v0.4"
@@ -43,8 +48,6 @@
    0-based values */
 #define SONY_MAX_BRIGHTNESS	8
 
-#define LOG_PFX			KERN_WARNING "sony-laptop: "
-
 MODULE_AUTHOR("Stelian Pop, Mattia Dongili");
 MODULE_DESCRIPTION(SONY_NC_DRIVER_NAME);
 MODULE_LICENSE("GPL");
@@ -368,8 +371,7 @@ static struct backlight_ops sony_backlig
  */
 static void sony_acpi_notify(acpi_handle handle, u32 event, void *data)
 {
-	if (debug)
-		printk(LOG_PFX "sony_acpi_notify, event: %d\n", event);
+	dprintk("sony_acpi_notify, event: %d\n", event);
 	acpi_bus_generate_event(sony_nc_acpi_device, 1, event);
 }
 
@@ -472,9 +474,8 @@ static int sony_nc_add(struct acpi_devic
 			if (ACPI_SUCCESS(acpi_get_handle(sony_nc_acpi_handle,
 							 *item->acpiget,
 							 &handle))) {
-				if (debug)
-					printk(LOG_PFX "Found %s getter: %s\n",
-					       item->name, *item->acpiget);
+				dprintk("Found %s getter: %s\n",
+						item->name, *item->acpiget);
 				item->devattr.attr.mode |= S_IRUGO;
 				break;
 			}
@@ -485,9 +486,8 @@ static int sony_nc_add(struct acpi_devic
 			if (ACPI_SUCCESS(acpi_get_handle(sony_nc_acpi_handle,
 							 *item->acpiset,
 							 &handle))) {
-				if (debug)
-					printk(LOG_PFX "Found %s setter: %s\n",
-					       item->name, *item->acpiset);
+				dprintk("Found %s setter: %s\n",
+						item->name, *item->acpiset);
 				item->devattr.attr.mode |= S_IWUSR;
 				break;
 			}
_

Patches currently in -mm which might be from malattia@linux.it are

git-cpufreq.patch
