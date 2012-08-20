From: akpm@linux-foundation.org
Subject: [merged] thermal-fix-potential-out-of-bounds-memory-access.patch removed from -mm tree
Date: Mon, 20 Aug 2012 12:56:04 -0700
Message-ID: <20120820195607.60CFC200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:45267 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab2HTT4K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 15:56:10 -0400
Received: by lbbge1 with SMTP id ge1so313971lbb.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 12:56:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@roeck-us.net, len.brown@intel.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: thermal: fix potential out-of-bounds memory access
has been removed from the -mm tree.  Its filename was
     thermal-fix-potential-out-of-bounds-memory-access.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Guenter Roeck <linux@roeck-us.net>
Subject: thermal: fix potential out-of-bounds memory access

temp_crit.name and temp_input.name have a length of 16 bytes.  Using
THERMAL_NAME_LENGTH (20) as length parameter for snprintf() may result in
out-of-bounds memory accesses.  Replace it with sizeof().

Addresses Coverity #115679

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Cc: Len Brown <lenb@kernel.org>
Cc: "Brown, Len" <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/thermal_sys.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/thermal/thermal_sys.c~thermal-fix-potential-out-of-bounds-memory-access drivers/thermal/thermal_sys.c
--- a/drivers/thermal/thermal_sys.c~thermal-fix-potential-out-of-bounds-memory-access
+++ a/drivers/thermal/thermal_sys.c
@@ -590,7 +590,7 @@ thermal_add_hwmon_sysfs(struct thermal_z
 	temp->tz = tz;
 	hwmon->count++;
 
-	snprintf(temp->temp_input.name, THERMAL_NAME_LENGTH,
+	snprintf(temp->temp_input.name, sizeof(temp->temp_input.name),
 		 "temp%d_input", hwmon->count);
 	temp->temp_input.attr.attr.name = temp->temp_input.name;
 	temp->temp_input.attr.attr.mode = 0444;
@@ -603,7 +603,8 @@ thermal_add_hwmon_sysfs(struct thermal_z
 	if (tz->ops->get_crit_temp) {
 		unsigned long temperature;
 		if (!tz->ops->get_crit_temp(tz, &temperature)) {
-			snprintf(temp->temp_crit.name, THERMAL_NAME_LENGTH,
+			snprintf(temp->temp_crit.name,
+				 sizeof(temp->temp_crit.name),
 				"temp%d_crit", hwmon->count);
 			temp->temp_crit.attr.attr.name = temp->temp_crit.name;
 			temp->temp_crit.attr.attr.mode = 0444;
_

Patches currently in -mm which might be from linux@roeck-us.net are

linux-next.patch

