From: akpm@linux-foundation.org
Subject: - pm-disable-usermode-helper-before-hibernation-and-suspend.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:00:21 -0700
Message-ID: <200707192000.l6JK0Ldn019441@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39249 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761565AbXGSU1B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:27:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, nigel@nigel.suspend2.net, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     PM: disable usermode helper before hibernation and suspend
has been removed from the -mm tree.  Its filename was
     pm-disable-usermode-helper-before-hibernation-and-suspend.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PM: disable usermode helper before hibernation and suspend
From: Rafael J. Wysocki <rjw@sisk.pl>

Use a hibernation and suspend notifier to disable the user mode helper before
a hibernation/suspend and enable it after the operation.

[akpm@linux-foundation.org: build fix]
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
@@ -33,12 +33,22 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/resource.h>
+#include <linux/notifier.h>
+#include <linux/suspend.h>
 #include <asm/uaccess.h>
 
 extern int max_threads;
 
 static struct workqueue_struct *khelper_wq;
 
+/*
+ * If set, both call_usermodehelper_keys() and call_usermodehelper_pipe() exit
+ * immediately returning -EBUSY.  Used for preventing user land processes from
+ * being created after the user land has been frozen during a system-wide
+ * hibernation or suspend operation.
+ */
+static int usermodehelper_disabled;
+
 #ifdef CONFIG_KMOD
 
 /*
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
acpi-implement-the-set_target-callback-from-pm_ops.patch
acpi-add-acpi_pm_device_sleep_state-helper-routine.patch
pm-move-definition-of-struct-pm_ops-to-suspendh.patch
pm-rename-struct-pm_ops-and-related-things.patch
pm-rework-struct-platform_suspend_ops.patch
pm-fix-compilation-of-suspend-code-if-config_pm-is-unset.patch
pm-make-suspend_ops-static.patch
pm-rework-struct-hibernation_ops.patch
pm-rename-hibernation_ops-to-platform_hibernation_ops.patch
shrink_slab-handle-bad-shrinkers.patch
