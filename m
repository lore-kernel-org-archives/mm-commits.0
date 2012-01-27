From: akpm@linux-foundation.org
Subject: + thermal_sys-convert-printks-to-pr_level.patch added to -mm tree
Date: Thu, 26 Jan 2012 16:55:07 -0800
Message-ID: <20120127005507.D82CFA049C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:35607 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab2A0AzK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2012 19:55:10 -0500
Received: by werb13 with SMTP id b13so79120wer.1
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2012 16:55:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, jj@chaosbits.net, lenb@kernel.org


The patch titled
     Subject: thermal_sys: convert printks to pr_<level>
has been added to the -mm tree.  Its filename is
     thermal_sys-convert-printks-to-pr_level.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: thermal_sys: convert printks to pr_<level>

Use the current logging style.

Remove PREFIX, add pr_fmt, convert the printks.  All dmesg output now
prefixed with "thermal_sys: ".

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Jesper Juhl <jj@chaosbits.net>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/thermal_sys.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN drivers/thermal/thermal_sys.c~thermal_sys-convert-printks-to-pr_level drivers/thermal/thermal_sys.c
--- a/drivers/thermal/thermal_sys.c~thermal_sys-convert-printks-to-pr_level
+++ a/drivers/thermal/thermal_sys.c
@@ -23,6 +23,8 @@
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/err.h>
@@ -39,8 +41,6 @@ MODULE_AUTHOR("Zhang Rui");
 MODULE_DESCRIPTION("Generic thermal management sysfs support");
 MODULE_LICENSE("GPL");
 
-#define PREFIX "Thermal: "
-
 struct thermal_cooling_device_instance {
 	int id;
 	char name[THERMAL_NAME_LENGTH];
@@ -1023,8 +1023,7 @@ void thermal_zone_device_update(struct t
 
 	if (tz->ops->get_temp(tz, &temp)) {
 		/* get_temp failed - retry it later */
-		printk(KERN_WARNING PREFIX "failed to read out thermal zone "
-		       "%d\n", tz->id);
+		pr_warn("failed to read out thermal zone %d\n", tz->id);
 		goto leave;
 	}
 
@@ -1039,9 +1038,8 @@ void thermal_zone_device_update(struct t
 					ret = tz->ops->notify(tz, count,
 							      trip_type);
 				if (!ret) {
-					printk(KERN_EMERG
-					       "Critical temperature reached (%ld C), shutting down.\n",
-					       temp/1000);
+					pr_emerg("Critical temperature reached (%ld C), shutting down\n",
+						 temp/1000);
 					orderly_poweroff(true);
 				}
 			}
@@ -1345,7 +1343,7 @@ int thermal_generate_netlink_event(u32 o
 
 	result = genlmsg_multicast(skb, 0, thermal_event_mcgrp.id, GFP_ATOMIC);
 	if (result)
-		printk(KERN_INFO "failed to send netlink event:%d", result);
+		pr_info("failed to send netlink event:%d\n", result);
 
 	return result;
 }
_
Subject: Subject: thermal_sys: convert printks to pr_<level>

Patches currently in -mm which might be from joe@perches.com are

origin.patch
maintainers-update-partitions-block-f-patterns.patch
maintainers-remove-imx5-section.patch
maintainers-remove-staging-sections.patch
maintainers-update-lguest-f-patterns.patch
linux-next.patch
thermal_sys-remove-unnecessary-line-continuations.patch
thermal_sys-remove-obfuscating-used-once-macros.patch
thermal_sys-kernel-style-cleanups.patch
thermal_sys-convert-printks-to-pr_level.patch
maintainers-staging-cx25821-add-l-linux-media.patch
maintainers-fix-remoteproc-f-typo.patch
include-and-checkpatch-prefer-__scanf-to-__attribute__formatscanf.patch

