From: akpm@linux-foundation.org
Subject: + drivers-thermal-thermal_sysc-fix-key-f70f4b50-not-in-data-in-thermal_sys.patch added to -mm tree
Date: Fri, 02 Apr 2010 16:45:31 -0700
Message-ID: <201004022345.o32NjVDC011927@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49342 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754079Ab0DBXpv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Apr 2010 19:45:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sergey.senozhatsky@gmail.com, ebiederm@xmission.com, gregkh@suse.de, len.brown@intel.com, rui.zhang@intel.com, w.sang@pengutronix.de


The patch titled
     drivers/thermal/thermal_sys.c: fix 'key f70f4b50 not in .data' in thermal_sys
has been added to the -mm tree.  Its filename is
     drivers-thermal-thermal_sysc-fix-key-f70f4b50-not-in-data-in-thermal_sys.patch

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
Subject: drivers/thermal/thermal_sys.c: fix 'key f70f4b50 not in .data' in thermal_sys
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

Initialize sysfs attributes before device_create_file call.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=15548

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <gregkh@suse.de>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/thermal_sys.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/thermal/thermal_sys.c~drivers-thermal-thermal_sysc-fix-key-f70f4b50-not-in-data-in-thermal_sys drivers/thermal/thermal_sys.c
--- a/drivers/thermal/thermal_sys.c~drivers-thermal-thermal_sysc-fix-key-f70f4b50-not-in-data-in-thermal_sys
+++ a/drivers/thermal/thermal_sys.c
@@ -506,6 +506,7 @@ thermal_add_hwmon_sysfs(struct thermal_z
 	tz->temp_input.attr.attr.name = tz->temp_input.name;
 	tz->temp_input.attr.attr.mode = 0444;
 	tz->temp_input.attr.show = temp_input_show;
+	sysfs_attr_init(&tz->temp_input.attr.attr);
 	result = device_create_file(hwmon->device, &tz->temp_input.attr);
 	if (result)
 		goto unregister_hwmon_device;
@@ -518,6 +519,7 @@ thermal_add_hwmon_sysfs(struct thermal_z
 			tz->temp_crit.attr.attr.name = tz->temp_crit.name;
 			tz->temp_crit.attr.attr.mode = 0444;
 			tz->temp_crit.attr.show = temp_crit_show;
+			sysfs_attr_init(&tz->temp_crit.attr.attr);
 			result = device_create_file(hwmon->device,
 						    &tz->temp_crit.attr);
 			if (result)
@@ -726,6 +728,7 @@ int thermal_zone_bind_cooling_device(str
 		goto release_idr;
 
 	sprintf(dev->attr_name, "cdev%d_trip_point", dev->id);
+	sysfs_attr_init(&dev->attr.attr);
 	dev->attr.attr.name = dev->attr_name;
 	dev->attr.attr.mode = 0444;
 	dev->attr.show = thermal_cooling_device_trip_point_show;
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

drivers-thermal-thermal_sysc-fix-key-f70f4b50-not-in-data-in-thermal_sys.patch

