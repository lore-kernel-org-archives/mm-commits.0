From: akpm@linux-foundation.org
Subject: [merged] thermal_sys-convert-printks-to-pr_level.patch removed from -mm tree
Date: Fri, 23 Mar 2012 11:22:45 -0700
Message-ID: <20120323182245.62EB5A02EB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:40028 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759160Ab2CWSWs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 14:22:48 -0400
Received: by lbbgj3 with SMTP id gj3so183552lbb.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 11:22:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, jj@chaosbits.net, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: thermal_sys: convert printks to pr_<level>
has been removed from the -mm tree.  Its filename was
     thermal_sys-convert-printks-to-pr_level.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
get_maintainer-use-a-default-unknown-s-status-role.patch
get_maintainerpl-add-support-for-moderated-lists.patch
maintainers-fix-remoteproc-f-typo.patch
maintainers-update-mca-section.patch
maintainers-update-git-urls-for-26-deletions.patch
maintainers-add-status-to-alpha-architecture.patch
maintainers-add-s-maintained-to-clkdev-and-clk-sections.patch
include-and-checkpatch-prefer-__scanf-to-__attribute__formatscanf.patch
checkpatch-add-some-strict-coding-style-checks.patch
checkpatch-add-some-strict-coding-style-checks-v3.patch
checkpatchpl-be-silent-when-q-and-ignore-is-given.patch
checkpatch-catch-usage-when-not-at-the-beginning-of-defination.patch
checkpatch-allow-simple-character-constants-in-defines.patch
checkpatch-handle-string-concatenation-in-simple-defines.patch
checkpatch-high-precidence-operators-do-not-require-additional-parentheses-in-defines.patch
checkpatch-add-to-type-extensions.patch
checkpatch-add-strict-tests-for-braces-comments-and-casts.patch
checkpatch-add-strict-test-for-strings-split-across-multiple-lines.patch
checkpatch-warn-on-use-of-yield.patch
checkpatch-whitespace-add-remove-blank-lines.patch
checkpatch-check-for-quoted-strings-broken-across-lines.patch
checkpatch-suggest-pr_level-over-printkkern_level.patch

