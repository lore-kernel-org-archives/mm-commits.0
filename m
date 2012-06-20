From: akpm@linux-foundation.org
Subject: + thermal-fix-potential-out-of-bounds-memory-access.patch added to -mm tree
Date: Wed, 20 Jun 2012 14:44:03 -0700
Message-ID: <20120620214403.A2F6FA0353@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:47837 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737Ab2FTVoF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jun 2012 17:44:05 -0400
Received: by wibhn6 with SMTP id hn6so270811wib.1
        for <mm-commits@vger.kernel.org>; Wed, 20 Jun 2012 14:44:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@roeck-us.net, len.brown@intel.com, lenb@kernel.org


The patch titled
     Subject: thermal: fix potential out-of-bounds memory access
has been added to the -mm tree.  Its filename is
     thermal-fix-potential-out-of-bounds-memory-access.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: thermal: fix potential out-of-bounds memory access

Patches currently in -mm which might be from linux@roeck-us.net are

origin.patch
linux-next.patch
thermal-fix-potential-out-of-bounds-memory-access.patch

