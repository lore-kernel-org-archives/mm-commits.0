From: akpm@linux-foundation.org
Subject: [merged] acpi-thermal-add-eol-to-the-trip_point_n_type-strings.patch removed from -mm tree
Date: Mon, 09 Nov 2009 11:54:55 -0800
Message-ID: <200911091954.nA9Jst4F022657@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49582 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753774AbZKITzT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2009 14:55:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amit.kucheria@canonical.com, lenb@kernel.org, rui.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     acpi: thermal: add EOL to the trip_point_N_type strings
has been removed from the -mm tree.  Its filename was
     acpi-thermal-add-eol-to-the-trip_point_n_type-strings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: thermal: add EOL to the trip_point_N_type strings
From: Amit Kucheria <amit.kucheria@canonical.com>

Make the trip_point_N_type sysfs files return a string ending in EOL for
consistency with other sysfs files.

Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/thermal/thermal_sys.c~acpi-thermal-add-eol-to-the-trip_point_n_type-strings drivers/thermal/thermal_sys.c
--- a/drivers/thermal/thermal_sys.c~acpi-thermal-add-eol-to-the-trip_point_n_type-strings
+++ a/drivers/thermal/thermal_sys.c
@@ -180,15 +180,15 @@ trip_point_type_show(struct device *dev,
 
 	switch (type) {
 	case THERMAL_TRIP_CRITICAL:
-		return sprintf(buf, "critical");
+		return sprintf(buf, "critical\n");
 	case THERMAL_TRIP_HOT:
-		return sprintf(buf, "hot");
+		return sprintf(buf, "hot\n");
 	case THERMAL_TRIP_PASSIVE:
-		return sprintf(buf, "passive");
+		return sprintf(buf, "passive\n");
 	case THERMAL_TRIP_ACTIVE:
-		return sprintf(buf, "active");
+		return sprintf(buf, "active\n");
 	default:
-		return sprintf(buf, "unknown");
+		return sprintf(buf, "unknown\n");
 	}
 }
 
_

Patches currently in -mm which might be from amit.kucheria@canonical.com are

origin.patch

