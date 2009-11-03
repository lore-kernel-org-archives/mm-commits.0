From: akpm@linux-foundation.org
Subject: + acpi-thermal-add-eol-to-the-trip_point_n_type-strings.patch added to -mm tree
Date: Mon, 02 Nov 2009 16:01:13 -0800
Message-ID: <200911030001.nA301D9W007280@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54694 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757351AbZKCACO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2009 19:02:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amit.kucheria@canonical.com, lenb@kernel.org, rui.zhang@intel.com


The patch titled
     acpi: thermal: add EOL to the trip_point_N_type strings
has been added to the -mm tree.  Its filename is
     acpi-thermal-add-eol-to-the-trip_point_n_type-strings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

acpi-thermal-add-eol-to-the-trip_point_n_type-strings.patch

