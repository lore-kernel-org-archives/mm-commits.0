From: akpm@osdl.org
Subject: - implementation-of-acpi_video_get_next_level.patch removed from -mm tree
Date: Wed, 20 Dec 2006 16:36:21 -0800
Message-ID: <200612210036.kBL0aLWv011186@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53248 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161095AbWLUAg0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 19:36:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux-kernel@ttuttle.net, len.brown@intel.com, mm-commits@vger.kernel.org


The patch titled
     Implementation of acpi_video_get_next_level()
has been removed from the -mm tree.  Its filename was
     implementation-of-acpi_video_get_next_level.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Implementation of acpi_video_get_next_level()
From: Thomas Tuttle <linux-kernel@ttuttle.net>

acpi_video_get_next_level was supposed to implement an algorithm to select
a new brightness level based on the old brightness level of an ACPI video
device, but it simply says "/* Fix me */" and returns the current
brightness.

This patch implements acpi_video_get_next_level properly.  It had to change
a few constants at the top of the file because they were (apparently)
wrong, but it appears to work on my Dell Inspiron e1405 (with BIOS A05
only--BIOS A04 doesn't seem to send ACPI video hotkey events).

[akpm@osdl.org: cleanups]
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Thomas Tuttle <linux-kernel@ttuttle.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/acpi/video.c |   41 ++++++++++++++++++++++++++++++++++-------
 1 files changed, 34 insertions(+), 7 deletions(-)

diff -puN drivers/acpi/video.c~implementation-of-acpi_video_get_next_level drivers/acpi/video.c
--- a/drivers/acpi/video.c~implementation-of-acpi_video_get_next_level
+++ a/drivers/acpi/video.c
@@ -3,6 +3,7 @@
  *
  *  Copyright (C) 2004 Luming Yu <luming.yu@intel.com>
  *  Copyright (C) 2004 Bruno Ducrot <ducrot@poupinou.org>
+ *  Copyright (C) 2006 Thomas Tuttle <linux-kernel@ttuttle.net>
  *
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  *
@@ -47,11 +48,11 @@
 #define ACPI_VIDEO_NOTIFY_NEXT_OUTPUT	0x83
 #define ACPI_VIDEO_NOTIFY_PREV_OUTPUT	0x84
 
-#define ACPI_VIDEO_NOTIFY_CYCLE_BRIGHTNESS	0x82
-#define	ACPI_VIDEO_NOTIFY_INC_BRIGHTNESS	0x83
-#define ACPI_VIDEO_NOTIFY_DEC_BRIGHTNESS	0x84
-#define ACPI_VIDEO_NOTIFY_ZERO_BRIGHTNESS	0x85
-#define ACPI_VIDEO_NOTIFY_DISPLAY_OFF		0x86
+#define ACPI_VIDEO_NOTIFY_CYCLE_BRIGHTNESS	0x85
+#define	ACPI_VIDEO_NOTIFY_INC_BRIGHTNESS	0x86
+#define ACPI_VIDEO_NOTIFY_DEC_BRIGHTNESS	0x87
+#define ACPI_VIDEO_NOTIFY_ZERO_BRIGHTNESS	0x88
+#define ACPI_VIDEO_NOTIFY_DISPLAY_OFF		0x89
 
 #define ACPI_VIDEO_HEAD_INVALID		(~0u - 1)
 #define ACPI_VIDEO_HEAD_END		(~0u)
@@ -1502,8 +1503,34 @@ static int
 acpi_video_get_next_level(struct acpi_video_device *device,
 			  u32 level_current, u32 event)
 {
-	/*Fix me */
-	return level_current;
+	int min, max, min_above, max_below, i, l;
+	max = max_below = 0;
+	min = min_above = 255;
+	for (i = 0; i < device->brightness->count; i++) {
+		l = device->brightness->levels[i];
+		if (l < min)
+			min = l;
+		if (l > max)
+			max = l;
+		if (l < min_above && l > level_current)
+			min_above = l;
+		if (l > max_below && l < level_current)
+			max_below = l;
+	}
+
+	switch (event) {
+	case ACPI_VIDEO_NOTIFY_CYCLE_BRIGHTNESS:
+		return (level_current < max) ? min_above : min;
+	case ACPI_VIDEO_NOTIFY_INC_BRIGHTNESS:
+		return (level_current < max) ? min_above : max;
+	case ACPI_VIDEO_NOTIFY_DEC_BRIGHTNESS:
+		return (level_current > min) ? max_below : min;
+	case ACPI_VIDEO_NOTIFY_ZERO_BRIGHTNESS:
+	case ACPI_VIDEO_NOTIFY_DISPLAY_OFF:
+		return 0;
+	default:
+		return level_current;
+	}
 }
 
 static void
_

Patches currently in -mm which might be from linux-kernel@ttuttle.net are

git-acpi.patch

