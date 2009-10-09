From: akpm@linux-foundation.org
Subject: [wrecked] acpi-clean-up-videoc-boundary-checks-and-types.patch removed from -mm tree
Date: Fri, 09 Oct 2009 15:00:04 -0700
Message-ID: <200910092200.n99M04Vq010122@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934646AbZJIWB5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Oct 2009 18:01:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@infradead.org, arjan@linux.intel.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi: clean up video.c boundary checks and types
has been removed from the -mm tree.  Its filename was
     acpi-clean-up-videoc-boundary-checks-and-types.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: clean up video.c boundary checks and types
From: Arjan van de Ven <arjan@infradead.org>

proc.c and video.c are a bit sloppy around types and style, confusing gcc
for a new feature that'll be in 2.6.33 and will cause a warning on the
current code.

This patch changes

if  (foo + 1 > sizeof bar)

into

if (foo >= sizeof(bar))

which is more kernel-style.

it also changes a variable in proc.c to unsigned; it gets assigned a value
from an unsigned type, and is then only compared for > not for negative,
so using unsigned is just outright the right type

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/acpi/proc.c~acpi-clean-up-videoc-boundary-checks-and-types drivers/acpi/proc.c
--- a/drivers/acpi/proc.c~acpi-clean-up-videoc-boundary-checks-and-types
+++ a/drivers/acpi/proc.c
@@ -393,7 +393,7 @@ acpi_system_write_wakeup_device(struct f
 	struct list_head *node, *next;
 	char strbuf[5];
 	char str[5] = "";
-	int len = count;
+	unsigned int len = count;
 	struct acpi_device *found_dev = NULL;
 
 	if (len > 4)
diff -puN drivers/acpi/video.c~acpi-clean-up-videoc-boundary-checks-and-types drivers/acpi/video.c
--- a/drivers/acpi/video.c~acpi-clean-up-videoc-boundary-checks-and-types
+++ a/drivers/acpi/video.c
@@ -1218,7 +1218,7 @@ acpi_video_device_write_state(struct fil
 	u32 state = 0;
 
 
-	if (!dev || count + 1 > sizeof str)
+	if (!dev || count >= sizeof(str))
 		return -EINVAL;
 
 	if (copy_from_user(str, buffer, count))
@@ -1275,7 +1275,7 @@ acpi_video_device_write_brightness(struc
 	int i;
 
 
-	if (!dev || !dev->brightness || count + 1 > sizeof str)
+	if (!dev || !dev->brightness || count >= sizeof(str))
 		return -EINVAL;
 
 	if (copy_from_user(str, buffer, count))
@@ -1557,7 +1557,7 @@ acpi_video_bus_write_POST(struct file *f
 	unsigned long long opt, options;
 
 
-	if (!video || count + 1 > sizeof str)
+	if (!video || count >= sizeof(str))
 		return -EINVAL;
 
 	status = acpi_video_bus_POST_options(video, &options);
@@ -1597,7 +1597,7 @@ acpi_video_bus_write_DOS(struct file *fi
 	unsigned long opt;
 
 
-	if (!video || count + 1 > sizeof str)
+	if (!video || count >= sizeof(str))
 		return -EINVAL;
 
 	if (copy_from_user(str, buffer, count))
_

Patches currently in -mm which might be from arjan@infradead.org are

origin.patch
linux-next.patch
acpi-clean-up-videoc-boundary-checks-and-types.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch

