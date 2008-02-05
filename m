From: akpm@linux-foundation.org
Subject: - misc-add-possibility-to-remove-misc-devices-during-suspend-resume.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:34:15 -0800
Message-ID: <200802052233.m15MXucK012466@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34313 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762904AbYBEWpf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:45:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, greg@kroah.com, kay.sievers@vrfy.org, lenb@kernel.org, linville@tuxdriver.com, mb@bu3sch.de, pavel@ucw.cz, rpurdie@rpsys.net, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     Misc: Add possibility to remove misc devices during suspend/resume
has been removed from the -mm tree.  Its filename was
     misc-add-possibility-to-remove-misc-devices-during-suspend-resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-x86.patch
git-xfs.patch
proc-fix-the-threaded-proc-self.patch
shrink_slab-handle-bad-shrinkers.patch
