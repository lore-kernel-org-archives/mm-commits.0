From: akpm@linux-foundation.org
Subject: + pm-disable-usermode-helper-before-hibernation-and-suspend.patch added to -mm tree
Date: Mon, 04 Jun 2007 21:41:04 -0700
Message-ID: <200706050441.l554f3RT029426@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59619 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754612AbXFEEla (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2007 00:41:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, nigel@nigel.suspend2.net, pavel@ucw.cz


The patch titled
     PM: disable usermode helper before hibernation and suspend
has been added to the -mm tree.  Its filename is
     pm-disable-usermode-helper-before-hibernation-and-suspend.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PM: disable usermode helper before hibernation and suspend
From: Rafael J. Wysocki <rjw@sisk.pl>

Use a hibernation and suspend notifier to disable the user mode helper before
a hibernation/suspend and enable it after the operation.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Nigel Cunningham <nigel@nigel.suspend2.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |   31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff -puN kernel/kmod.c~pm-disable-usermode-helper-before-hibernation-and-suspend kernel/kmod.c
--- a/kernel/kmod.c~pm-disable-usermode-helper-before-hibernation-and-suspend
+++ a/kernel/kmod.c
@@ -33,6 +33,8 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/resource.h>
+#include <linux/notifier.h>
+#include <linux/suspend.h>
 #include <asm/uaccess.h>
 
 extern int max_threads;
@@ -46,6 +48,14 @@ static struct workqueue_struct *khelper_
 */
 char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe";
 
+/*
+ * If set, both call_usermodehelper_keys() and call_usermodehelper_pipe() exit
+ * immediately returning -EBUSY.  Used for preventing user land processes from
+ * being created after the user land has been frozen during a system-wide
+ * hibernation or suspend operation.
+ */
+static int usermodehelper_disabled;
+
 /**
  * request_module - try to load a kernel module
  * @fmt:     printf style format string for the name of the module
@@ -265,6 +275,24 @@ static void __call_usermodehelper(struct
 	}
 }
 
+static int usermodehelper_pm_callback(struct notifier_block *nfb,
+					unsigned long action,
+					void *ignored)
+{
+	switch (action) {
+	case PM_HIBERNATION_PREPARE:
+	case PM_SUSPEND_PREPARE:
+		usermodehelper_disabled = 1;
+		return NOTIFY_OK;
+	case PM_POST_HIBERNATION:
+	case PM_POST_SUSPEND:
+		usermodehelper_disabled = 0;
+		return NOTIFY_OK;
+	}
+
+	return NOTIFY_DONE;
+}
+
 /**
  * call_usermodehelper_setup - prepare to call a usermode helper
  * @path - path to usermode executable
@@ -374,7 +402,7 @@ int call_usermodehelper_exec(struct subp
 		goto out;
 	}
 
-	if (!khelper_wq) {
+	if (!khelper_wq || usermodehelper_disabled) {
 		retval = -EBUSY;
 		goto out;
 	}
@@ -431,4 +459,5 @@ void __init usermodehelper_init(void)
 {
 	khelper_wq = create_singlethread_workqueue("khelper");
 	BUG_ON(!khelper_wq);
+	pm_notifier(usermodehelper_pm_callback, 0);
 }
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
mtrr-atomicity-fix.patch
x86_64-pm_trace-support.patch
i386-do-not-restore-reserved-memory-after-hibernation.patch
acpi-preserve-the-ebx-value-in-acpi_copy_wakeup_routine.patch
freezer-make-kernel-threads-nonfreezable-by-default.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix-fix.patch
freezer-make-kernel-threads-nonfreezable-by-default-fix-2.patch
freezer-run-show_state-when-freezing-times-out.patch
pm-do-not-require-dev-spew-to-get-pm_debug.patch
swsusp-remove-incorrect-code-from-userc.patch
swsusp-remove-code-duplication-between-diskc-and-userc.patch
swsusp-introduce-restore-platform-operations.patch
swsusp-fix-hibernation-code-ordering.patch
hibernation-prepare-to-enter-the-low-power-state.patch
freezer-avoid-freezing-kernel-threads-prematurely.patch
freezer-use-__set_current_state-in-refrigerator.patch
freezer-return-int-from-freeze_processes.patch
freezer-remove-redundant-check-in-try_to_freeze_tasks.patch
pm-introduce-hibernation-and-suspend-notifiers.patch
pm-introduce-hibernation-and-suspend-notifiers-tidy.patch
pm-disable-usermode-helper-before-hibernation-and-suspend.patch
shrink_slab-handle-bad-shrinkers.patch
