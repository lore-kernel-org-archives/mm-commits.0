From: akpm@linux-foundation.org
Subject: + pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation.patch added to -mm tree
Date: Mon, 11 Aug 2008 15:21:02 -0700
Message-ID: <200808112221.m7BML2QU024689@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43580 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753134AbYHKWVN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 18:21:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, pavel@suse.cz, stern@rowland.harvard.edu


The patch titled
     pm: rework disabling of user mode helpers during suspend/hibernation
has been added to the -mm tree.  Its filename is
     pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation.patch

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
Subject: pm: rework disabling of user mode helpers during suspend/hibernation
From: "Rafael J. Wysocki" <rjw@sisk.pl>

We currently use a PM notifier to disable user mode helpers before suspend
and hibernation and to re-enable them during resume.  However, this is not
an ideal solution, because if any drivers want to upload firmware into
memory before suspend, they have to use a PM notifier for this purpose and
there is no guarantee that the ordering of PM notifiers will be as
expected (ie.  the notifier that disables user mode helpers has to be run
after the driver's notifier used for uploading the firmware).

For this reason, it seems better to move the disabling and enabling of
user mode helpers to separate functions that will be called by the PM core
as necessary.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kmod.h |    5 +++
 kernel/kmod.c        |   65 +++++++++++++++++------------------------
 kernel/power/disk.c  |   11 ++++++
 kernel/power/main.c  |    7 ++++
 kernel/power/user.c  |   10 +++++-
 5 files changed, 60 insertions(+), 38 deletions(-)

diff -puN include/linux/kmod.h~pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation include/linux/kmod.h
--- a/include/linux/kmod.h~pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation
+++ a/include/linux/kmod.h
@@ -99,4 +99,9 @@ struct file;
 extern int call_usermodehelper_pipe(char *path, char *argv[], char *envp[],
 				    struct file **filp);
 
+#ifdef CONFIG_PM_SLEEP
+extern int usermodehelper_disable(void);
+extern void usermodehelper_enable(void);
+#endif
+
 #endif /* __LINUX_KMOD_H__ */
diff -puN kernel/kmod.c~pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation kernel/kmod.c
--- a/kernel/kmod.c~pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation
+++ a/kernel/kmod.c
@@ -270,7 +270,7 @@ static void __call_usermodehelper(struct
 	}
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 /*
  * If set, call_usermodehelper_exec() will exit immediately returning -EBUSY
  * (used for preventing user land processes from being created after the user
@@ -293,39 +293,37 @@ static DECLARE_WAIT_QUEUE_HEAD(running_h
  */
 #define RUNNING_HELPERS_TIMEOUT	(5 * HZ)
 
-static int usermodehelper_pm_callback(struct notifier_block *nfb,
-					unsigned long action,
-					void *ignored)
+/**
+ * usermodehelper_disable - prevent new helpers from being started
+ */
+int usermodehelper_disable(void)
 {
 	long retval;
 
-	switch (action) {
-	case PM_HIBERNATION_PREPARE:
-	case PM_SUSPEND_PREPARE:
-		usermodehelper_disabled = 1;
-		smp_mb();
-		/*
-		 * From now on call_usermodehelper_exec() won't start any new
-		 * helpers, so it is sufficient if running_helpers turns out to
-		 * be zero at one point (it may be increased later, but that
-		 * doesn't matter).
-		 */
-		retval = wait_event_timeout(running_helpers_waitq,
+	usermodehelper_disabled = 1;
+	smp_mb();
+	/*
+	 * From now on call_usermodehelper_exec() won't start any new
+	 * helpers, so it is sufficient if running_helpers turns out to
+	 * be zero at one point (it may be increased later, but that
+	 * doesn't matter).
+	 */
+	retval = wait_event_timeout(running_helpers_waitq,
 					atomic_read(&running_helpers) == 0,
 					RUNNING_HELPERS_TIMEOUT);
-		if (retval) {
-			return NOTIFY_OK;
-		} else {
-			usermodehelper_disabled = 0;
-			return NOTIFY_BAD;
-		}
-	case PM_POST_HIBERNATION:
-	case PM_POST_SUSPEND:
-		usermodehelper_disabled = 0;
-		return NOTIFY_OK;
-	}
+	if (retval)
+		return 0;
 
-	return NOTIFY_DONE;
+	usermodehelper_disabled = 0;
+	return -EAGAIN;
+}
+
+/**
+ * usermodehelper_enable - allow new helpers to be started again
+ */
+void usermodehelper_enable(void)
+{
+	usermodehelper_disabled = 0;
 }
 
 static void helper_lock(void)
@@ -339,18 +337,12 @@ static void helper_unlock(void)
 	if (atomic_dec_and_test(&running_helpers))
 		wake_up(&running_helpers_waitq);
 }
-
-static void register_pm_notifier_callback(void)
-{
-	pm_notifier(usermodehelper_pm_callback, 0);
-}
-#else /* CONFIG_PM */
+#else /* CONFIG_PM_SLEEP */
 #define usermodehelper_disabled	0
 
 static inline void helper_lock(void) {}
 static inline void helper_unlock(void) {}
-static inline void register_pm_notifier_callback(void) {}
-#endif /* CONFIG_PM */
+#endif /* CONFIG_PM_SLEEP */
 
 /**
  * call_usermodehelper_setup - prepare to call a usermode helper
@@ -531,5 +523,4 @@ void __init usermodehelper_init(void)
 {
 	khelper_wq = create_singlethread_workqueue("khelper");
 	BUG_ON(!khelper_wq);
-	register_pm_notifier_callback();
 }
diff -puN kernel/power/disk.c~pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation kernel/power/disk.c
--- a/kernel/power/disk.c~pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation
+++ a/kernel/power/disk.c
@@ -21,6 +21,7 @@
 #include <linux/console.h>
 #include <linux/cpu.h>
 #include <linux/freezer.h>
+#include <linux/kmod.h>
 
 #include "power.h"
 
@@ -513,6 +514,10 @@ int hibernate(void)
 	if (error)
 		goto Exit;
 
+	error = usermodehelper_disable();
+	if (error)
+		goto Exit;
+
 	/* Allocate memory management structures */
 	error = create_basic_memory_bitmaps();
 	if (error)
@@ -551,6 +556,7 @@ int hibernate(void)
 	thaw_processes();
  Finish:
 	free_basic_memory_bitmaps();
+	usermodehelper_enable();
  Exit:
 	pm_notifier_call_chain(PM_POST_HIBERNATION);
 	pm_restore_console();
@@ -627,6 +633,10 @@ static int software_resume(void)
 	if (error)
 		goto Finish;
 
+	error = usermodehelper_disable();
+	if (error)
+		goto Finish;
+
 	error = create_basic_memory_bitmaps();
 	if (error)
 		goto Finish;
@@ -649,6 +659,7 @@ static int software_resume(void)
 	thaw_processes();
  Done:
 	free_basic_memory_bitmaps();
+	usermodehelper_enable();
  Finish:
 	pm_notifier_call_chain(PM_POST_RESTORE);
 	pm_restore_console();
diff -puN kernel/power/main.c~pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation kernel/power/main.c
--- a/kernel/power/main.c~pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation
+++ a/kernel/power/main.c
@@ -21,6 +21,7 @@
 #include <linux/freezer.h>
 #include <linux/vmstat.h>
 #include <linux/syscalls.h>
+#include <linux/kmod.h>
 
 #include "power.h"
 
@@ -236,6 +237,10 @@ static int suspend_prepare(void)
 	if (error)
 		goto Finish;
 
+	error = usermodehelper_disable();
+	if (error)
+		goto Finish;
+
 	if (suspend_freeze_processes()) {
 		error = -EAGAIN;
 		goto Thaw;
@@ -255,6 +260,7 @@ static int suspend_prepare(void)
 
  Thaw:
 	suspend_thaw_processes();
+	usermodehelper_enable();
  Finish:
 	pm_notifier_call_chain(PM_POST_SUSPEND);
 	pm_restore_console();
@@ -373,6 +379,7 @@ int suspend_devices_and_enter(suspend_st
 static void suspend_finish(void)
 {
 	suspend_thaw_processes();
+	usermodehelper_enable();
 	pm_notifier_call_chain(PM_POST_SUSPEND);
 	pm_restore_console();
 }
diff -puN kernel/power/user.c~pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation kernel/power/user.c
--- a/kernel/power/user.c~pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation
+++ a/kernel/power/user.c
@@ -212,13 +212,20 @@ static long snapshot_ioctl(struct file *
 	case SNAPSHOT_FREEZE:
 		if (data->frozen)
 			break;
+
 		printk("Syncing filesystems ... ");
 		sys_sync();
 		printk("done.\n");
 
-		error = freeze_processes();
+		error = usermodehelper_disable();
 		if (error)
+			break;
+
+		error = freeze_processes();
+		if (error) {
 			thaw_processes();
+			usermodehelper_enable();
+		}
 		if (!error)
 			data->frozen = 1;
 		break;
@@ -227,6 +234,7 @@ static long snapshot_ioctl(struct file *
 		if (!data->frozen || data->ready)
 			break;
 		thaw_processes();
+		usermodehelper_enable();
 		data->frozen = 0;
 		break;
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

linux-next.patch
skge-adapt-skge-to-use-reworked-pci-pm.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation.patch
shrink_slab-handle-bad-shrinkers.patch

