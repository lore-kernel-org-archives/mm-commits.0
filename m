From: akpm@linux-foundation.org
Subject: - dmi-dont-save-the-same-device-twice-was-smbios-dmi-add-type-41-=-onboard-devices-extended-information.patch removed from -mm tree
Date: Sun, 24 Feb 2008 16:44:58 -0800
Message-ID: <200802250044.m1P0iwjY006147@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36757 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754293AbYBYAsq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:48:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     dmi: don't save the same device twice
has been removed from the -mm tree.  Its filename was
     dmi-dont-save-the-same-device-twice-was-smbios-dmi-add-type-41-=-onboard-devices-extended-information.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dmi: don't save the same device twice
From: Jean Delvare <khali@linux-fr.org>

Now that we gather on-board devices from both DMI types 10 and 41, there is
a possibility that we list the same device twice.  In order to not confuse
drivers, and also to save memory, make sure that we do not add duplicate
devices to the dmi_devices list.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dmi_scan.c |   74 ++++++++++++++++++++--------------
 1 file changed, 44 insertions(+), 30 deletions(-)

diff -puN drivers/firmware/dmi_scan.c~dmi-dont-save-the-same-device-twice-was-smbios-dmi-add-type-41-=-onboard-devices-extended-information drivers/firmware/dmi_scan.c
--- a/drivers/firmware/dmi_scan.c~dmi-dont-save-the-same-device-twice-was-smbios-dmi-add-type-41-=-onboard-devices-extended-information
+++ a/drivers/firmware/dmi_scan.c
@@ -10,10 +10,9 @@
 
 static char dmi_empty_string[] = "        ";
 
-static char * __init dmi_string(const struct dmi_header *dm, u8 s)
+static const char * __init dmi_string_nosave(const struct dmi_header *dm, u8 s)
 {
 	const u8 *bp = ((u8 *) dm) + dm->length;
-	char *str = "";
 
 	if (s) {
 		s--;
@@ -28,14 +27,29 @@ static char * __init dmi_string(const st
 
 			if (!memcmp(bp, dmi_empty_string, cmp_len))
 				return dmi_empty_string;
-			str = dmi_alloc(len);
-			if (str != NULL)
-				strcpy(str, bp);
-			else
-				printk(KERN_ERR "dmi_string: cannot allocate %Zu bytes.\n", len);
+			return bp;
 		}
 	}
 
+	return "";
+}
+
+static char * __init dmi_string(const struct dmi_header *dm, u8 s)
+{
+	const char *bp = dmi_string_nosave(dm, s);
+	char *str;
+	size_t len;
+
+	if (bp == dmi_empty_string)
+		return dmi_empty_string;
+
+	len = strlen(bp) + 1;
+	str = dmi_alloc(len);
+	if (str != NULL)
+		strcpy(str, bp);
+	else
+		printk(KERN_ERR "dmi_string: cannot allocate %Zu bytes.\n", len);
+
 	return str;
 }
 
@@ -167,10 +181,30 @@ static void __init dmi_save_type(const s
 	dmi_ident[slot] = s;
 }
 
+static void __init dmi_save_one_device(int type, const char *name)
+{
+	struct dmi_device *dev;
+
+	/* No duplicate device */
+	if (dmi_find_device(type, name, NULL))
+		return;
+
+	dev = dmi_alloc(sizeof(*dev) + strlen(name) + 1);
+	if (!dev) {
+		printk(KERN_ERR "dmi_save_one_device: out of memory.\n");
+		return;
+	}
+
+	dev->type = type;
+	strcpy((char *)(dev + 1), name);
+	dev->name = (char *)(dev + 1);
+	dev->device_data = NULL;
+	list_add(&dev->list, &dmi_devices);
+}
+
 static void __init dmi_save_devices(const struct dmi_header *dm)
 {
 	int i, count = (dm->length - sizeof(struct dmi_header)) / 2;
-	struct dmi_device *dev;
 
 	for (i = 0; i < count; i++) {
 		const char *d = (char *)(dm + 1) + (i * 2);
@@ -179,16 +213,7 @@ static void __init dmi_save_devices(cons
 		if ((*d & 0x80) == 0)
 			continue;
 
-		dev = dmi_alloc(sizeof(*dev));
-		if (!dev) {
-			printk(KERN_ERR "dmi_save_devices: out of memory.\n");
-			break;
-		}
-
-		dev->type = *d++ & 0x7f;
-		dev->name = dmi_string(dm, *d);
-		dev->device_data = NULL;
-		list_add(&dev->list, &dmi_devices);
+		dmi_save_one_device(*d & 0x7f, dmi_string_nosave(dm, *(d + 1)));
 	}
 }
 
@@ -253,23 +278,12 @@ static void __init dmi_save_ipmi_device(
 static void __init dmi_save_extended_devices(const struct dmi_header *dm)
 {
 	const u8 *d = (u8*) dm + 5;
-	struct dmi_device *dev;
 
 	/* Skip disabled device */
 	if ((*d & 0x80) == 0)
 		return;
 
-	dev = dmi_alloc(sizeof(*dev));
-	if (!dev) {
-		printk(KERN_ERR "dmi_save_extended_devices: out of memory.\n");
-		return;
-	}
-
-	dev->type = *d-- & 0x7f;
-	dev->name = dmi_string(dm, *d);
-	dev->device_data = NULL;
-
-	list_add(&dev->list, &dmi_devices);
+	dmi_save_one_device(*d & 0x7f, dmi_string_nosave(dm, *(d - 1)));
 }
 
 /*
_

Patches currently in -mm which might be from khali@linux-fr.org are

mm-only-enforce-acpi-resource-conflict-checks.patch
oz99x-i2c-button-and-led-support-driver.patch
apanel-fix-kconfig-dependencies.patch
dmi-clean-up-dmi-helper-declarations.patch
rtc-add-support-for-the-s-35390a-rtc-chip.patch
rtc-add-support-for-the-s-35390a-rtc-chip-checkpatch-fixes.patch
