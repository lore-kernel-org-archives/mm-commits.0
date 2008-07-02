From: akpm@linux-foundation.org
Subject: - drivers-acpi-video-fix-brightness-allocation-v3.patch removed from -mm tree
Date: Wed, 02 Jul 2008 00:47:41 -0700
Message-ID: <200807020747.m627lf47005666@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54858 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760824AbYGBHsZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 03:48:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia.jomantaite@gmail.com, lenb@kernel.org, rui.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     drivers/acpi/video: fix brightness allocation
has been removed from the -mm tree.  Its filename was
     drivers-acpi-video-fix-brightness-allocation-v3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/acpi/video: fix brightness allocation
From: Julia Jomantaite <julia.jomantaite@gmail.com>

Fix use of uninitialized device->brightness.

Signed-off-by: Julia Jomantaite <julia.jomantaite@gmail.com>
Acked-by: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/video.c |  123 ++++++++++++++++++++++++-----------------
 1 file changed, 73 insertions(+), 50 deletions(-)

diff -puN drivers/acpi/video.c~drivers-acpi-video-fix-brightness-allocation-v3 drivers/acpi/video.c
--- a/drivers/acpi/video.c~drivers-acpi-video-fix-brightness-allocation-v3
+++ a/drivers/acpi/video.c
@@ -631,6 +631,76 @@ acpi_video_bus_DOS(struct acpi_video_bus
  *  	device	: video output device (LCD, CRT, ..)
  *
  *  Return Value:
+ *  	Maximum brightness level
+ *
+ *  Allocate and initialize device->brightness.
+ */
+
+static int
+acpi_video_init_brightness(struct acpi_video_device *device)
+{
+	union acpi_object *obj = NULL;
+	int i, max_level = 0, count = 0;
+	union acpi_object *o;
+	struct acpi_video_device_brightness *br = NULL;
+
+	if (!ACPI_SUCCESS(acpi_video_device_lcd_query_levels(device, &obj))) {
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Could not query available "
+						"LCD brightness level\n"));
+		goto out;
+	}
+
+	if (obj->package.count < 2)
+		goto out;
+
+	br = kzalloc(sizeof(*br), GFP_KERNEL);
+	if (!br) {
+		printk(KERN_ERR "can't allocate memory\n");
+		goto out;
+	}
+
+	br->levels = kmalloc(obj->package.count * sizeof *(br->levels),
+				GFP_KERNEL);
+	if (!br->levels)
+		goto out_free;
+
+	for (i = 0; i < obj->package.count; i++) {
+		o = (union acpi_object *)&obj->package.elements[i];
+		if (o->type != ACPI_TYPE_INTEGER) {
+			printk(KERN_ERR PREFIX "Invalid data\n");
+			continue;
+		}
+		br->levels[count] = (u32) o->integer.value;
+
+		if (br->levels[count] > max_level)
+			max_level = br->levels[count];
+		count++;
+	}
+
+	if (count < 2)
+		goto out_free_levels;
+
+	br->count = count;
+	device->brightness = br;
+	ACPI_DEBUG_PRINT((ACPI_DB_INFO,	"found %d brightness levels\n",	count));
+	kfree(obj);
+	return max_level;
+
+out_free_levels:
+	kfree(br->levels);
+out_free:
+	kfree(br);
+out:
+	device->brightness = NULL;
+	kfree(obj);
+	return 0;
+}
+
+/*
+ *  Arg:
+ *  	device	: video output device (LCD, CRT, ..)
+ *
+ *  Return Value:
  *  	None
  *
  *  Find out all required AML methods defined under the output
@@ -640,10 +710,7 @@ acpi_video_bus_DOS(struct acpi_video_bus
 static void acpi_video_device_find_cap(struct acpi_video_device *device)
 {
 	acpi_handle h_dummy1;
-	int i;
 	u32 max_level = 0;
-	union acpi_object *obj = NULL;
-	struct acpi_video_device_brightness *br = NULL;
 
 
 	memset(&device->cap, 0, sizeof(device->cap));
@@ -672,53 +739,7 @@ static void acpi_video_device_find_cap(s
 		device->cap._DSS = 1;
 	}
 
-	if (ACPI_SUCCESS(acpi_video_device_lcd_query_levels(device, &obj))) {
-
-		if (obj->package.count >= 2) {
-			int count = 0;
-			union acpi_object *o;
-
-			br = kzalloc(sizeof(*br), GFP_KERNEL);
-			if (!br) {
-				printk(KERN_ERR "can't allocate memory\n");
-			} else {
-				br->levels = kmalloc(obj->package.count *
-						     sizeof *(br->levels), GFP_KERNEL);
-				if (!br->levels)
-					goto out;
-
-				for (i = 0; i < obj->package.count; i++) {
-					o = (union acpi_object *)&obj->package.
-					    elements[i];
-					if (o->type != ACPI_TYPE_INTEGER) {
-						printk(KERN_ERR PREFIX "Invalid data\n");
-						continue;
-					}
-					br->levels[count] = (u32) o->integer.value;
-
-					if (br->levels[count] > max_level)
-						max_level = br->levels[count];
-					count++;
-				}
-			      out:
-				if (count < 2) {
-					kfree(br->levels);
-					kfree(br);
-				} else {
-					br->count = count;
-					device->brightness = br;
-					ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-							  "found %d brightness levels\n",
-							  count));
-				}
-			}
-		}
-
-	} else {
-		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Could not query available LCD brightness level\n"));
-	}
