From: akpm@linux-foundation.org
Subject: + misc-add-possibility-to-remove-misc-devices-during-suspend-resume.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:12:36 -0800
Message-ID: <200801270512.m0R5CX62030921@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56132 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751181AbYA0FPH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:15:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, greg@kroah.com, kay.sievers@vrfy.org, lenb@kernel.org, linville@tuxdriver.com, mb@bu3sch.de, pavel@ucw.cz, rpurdie@rpsys.net, stern@rowland.harvard.edu


The patch titled
     Misc: Add possibility to remove misc devices during suspend/resume
has been added to the -mm tree.  Its filename is
     misc-add-possibility-to-remove-misc-devices-during-suspend-resume.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Misc: Add possibility to remove misc devices during suspend/resume
From: Rafael J. Wysocki <rjw@sisk.pl>

Make it possible to unregister a misc device object in a safe way during a
suspend/resume cycle.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Len Brown <lenb@kernel.org>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/misc.c        |   13 +++++++++----
 include/linux/miscdevice.h |   10 +++++++++-
 2 files changed, 18 insertions(+), 5 deletions(-)

diff -puN drivers/char/misc.c~misc-add-possibility-to-remove-misc-devices-during-suspend-resume drivers/char/misc.c
--- a/drivers/char/misc.c~misc-add-possibility-to-remove-misc-devices-during-suspend-resume
+++ a/drivers/char/misc.c
@@ -232,8 +232,9 @@ int misc_register(struct miscdevice * mi
 }
 
 /**
- *	misc_deregister - unregister a miscellaneous device
+ *	__misc_deregister - unregister a miscellaneous device
  *	@misc: device to unregister
+ *	@suspended: to be set if the function is used during suspend/resume
  *
  *	Unregister a miscellaneous device that was previously
  *	successfully registered with misc_register(). Success
@@ -241,7 +242,7 @@ int misc_register(struct miscdevice * mi
  *	indicates an error.
  */
 
-int misc_deregister(struct miscdevice * misc)
+int __misc_deregister(struct miscdevice *misc, bool suspended)
 {
 	int i = misc->minor;
 
@@ -250,7 +251,11 @@ int misc_deregister(struct miscdevice * 
 
 	mutex_lock(&misc_mtx);
 	list_del(&misc->list);
-	device_destroy(misc_class, MKDEV(MISC_MAJOR, misc->minor));
+	if (suspended)
+		destroy_suspended_device(misc_class,
+					MKDEV(MISC_MAJOR, misc->minor));
+	else
+		device_destroy(misc_class, MKDEV(MISC_MAJOR, misc->minor));
 	if (i < DYNAMIC_MINORS && i>0) {
 		misc_minors[i>>3] &= ~(1 << (misc->minor & 7));
 	}
@@ -259,7 +264,7 @@ int misc_deregister(struct miscdevice * 
 }
 
 EXPORT_SYMBOL(misc_register);
-EXPORT_SYMBOL(misc_deregister);
+EXPORT_SYMBOL(__misc_deregister);
 
 static int __init misc_init(void)
 {
diff -puN include/linux/miscdevice.h~misc-add-possibility-to-remove-misc-devices-during-suspend-resume include/linux/miscdevice.h
--- a/include/linux/miscdevice.h~misc-add-possibility-to-remove-misc-devices-during-suspend-resume
+++ a/include/linux/miscdevice.h
@@ -43,7 +43,15 @@ struct miscdevice  {
 };
 
 extern int misc_register(struct miscdevice * misc);
-extern int misc_deregister(struct miscdevice * misc);
+extern int __misc_deregister(struct miscdevice *misc, bool suspended);
+static inline int misc_deregister(struct miscdevice *misc)
+{
+	return __misc_deregister(misc, false);
+}
+static inline int misc_deregister_suspended(struct miscdevice *misc)
+{
+	return __misc_deregister(misc, true);
+}
 
 #define MODULE_ALIAS_MISCDEV(minor)				\
 	MODULE_ALIAS("char-major-" __stringify(MISC_MAJOR)	\
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
cpufreq-revert-get-core-affinity-from-acpi_processor_preregister_performance.patch
gregkh-driver-kset-convert-to-kobj_sysfs_ops-vs-git-acpi.patch
git-x86.patch
git-x86-vs-pm-acquire-device-locks-on-suspend-rev-3.patch
git-xfs.patch
page-allocator-clean-up-pcp-draining-functions.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix-fix.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
pm-export-device_pm_schedule_removal.patch
misc-add-possibility-to-remove-misc-devices-during-suspend-resume.patch
hwrng-add-possibility-to-remove-hwrng-devices-during-suspend-resume.patch
leds-add-possibility-to-remove-leds-classdevs-during-suspend-resume.patch
b43-avoid-unregistering-device-objects-during-suspend.patch
proc-fix-the-threaded-proc-self.patch
shrink_slab-handle-bad-shrinkers.patch
