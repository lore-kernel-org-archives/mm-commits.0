From: akpm@linux-foundation.org
Subject: + freezer-introduce-freezer-firendly-waiting-macros.patch added to -mm tree
Date: Mon, 23 Jul 2007 16:48:17 -0700
Message-ID: <200707232348.l6NNmIvN018378@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52687 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760988AbXGWXsn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 19:48:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, nigel@nigel.suspend2.net, pavel@ucw.cz


The patch titled
     freezer: introduce freezer-firendly waiting macros
has been added to the -mm tree.  Its filename is
     freezer-introduce-freezer-firendly-waiting-macros.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: freezer: introduce freezer-firendly waiting macros
From: Rafael J. Wysocki <rjw@sisk.pl>

Introduce freezer-friendly wrappers around wait_event_interruptible() and
wait_event_interruptible_timeout(), originally defined in <linux/wait.h>, to
be used in freezable kernel threads.  Make some of the freezable kernel
threads use them.

This is necessary for the freezer to stop sending signals to kernel threads,
which is implemented in the next patch.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/gameport/gameport.c         |    3 -
 drivers/input/serio/serio.c               |    3 -
 drivers/input/touchscreen/ucb1400_ts.c    |    3 -
 drivers/media/dvb/dvb-core/dvb_frontend.c |    3 -
 drivers/usb/core/hub.c                    |    3 -
 drivers/usb/storage/usb.c                 |    5 --
 include/linux/freezer.h                   |   42 +++++++++++++++++++-
 7 files changed, 47 insertions(+), 15 deletions(-)

diff -puN drivers/input/gameport/gameport.c~freezer-introduce-freezer-firendly-waiting-macros drivers/input/gameport/gameport.c
--- a/drivers/input/gameport/gameport.c~freezer-introduce-freezer-firendly-waiting-macros
+++ a/drivers/input/gameport/gameport.c
@@ -448,9 +448,8 @@ static int gameport_thread(void *nothing
 	set_freezable();
 	do {
 		gameport_handle_event();
-		wait_event_interruptible(gameport_wait,
+		wait_event_freezable(gameport_wait,
 			kthread_should_stop() || !list_empty(&gameport_event_list));
-		try_to_freeze();
 	} while (!kthread_should_stop());
 
 	printk(KERN_DEBUG "gameport: kgameportd exiting\n");
diff -puN drivers/input/serio/serio.c~freezer-introduce-freezer-firendly-waiting-macros drivers/input/serio/serio.c
--- a/drivers/input/serio/serio.c~freezer-introduce-freezer-firendly-waiting-macros
+++ a/drivers/input/serio/serio.c
@@ -387,9 +387,8 @@ static int serio_thread(void *nothing)
 	set_freezable();
 	do {
 		serio_handle_event();
-		wait_event_interruptible(serio_wait,
+		wait_event_freezable(serio_wait,
 			kthread_should_stop() || !list_empty(&serio_event_list));
-		try_to_freeze();
 	} while (!kthread_should_stop());
 
 	printk(KERN_DEBUG "serio: kseriod exiting\n");
diff -puN drivers/input/touchscreen/ucb1400_ts.c~freezer-introduce-freezer-firendly-waiting-macros drivers/input/touchscreen/ucb1400_ts.c
--- a/drivers/input/touchscreen/ucb1400_ts.c~freezer-introduce-freezer-firendly-waiting-macros
+++ a/drivers/input/touchscreen/ucb1400_ts.c
@@ -334,10 +334,9 @@ static int ucb1400_ts_thread(void *_ucb)
 			timeout = msecs_to_jiffies(10);
 		}
 
-		wait_event_interruptible_timeout(ucb->ts_wait,
+		wait_event_freezable_timeout(ucb->ts_wait,
 			ucb->irq_pending || ucb->ts_restart || kthread_should_stop(),
 			timeout);
-		try_to_freeze();
 	}
 
 	/* Send the "pen off" if we are stopping with the pen still active */
diff -puN drivers/media/dvb/dvb-core/dvb_frontend.c~freezer-introduce-freezer-firendly-waiting-macros drivers/media/dvb/dvb-core/dvb_frontend.c
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c~freezer-introduce-freezer-firendly-waiting-macros
+++ a/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -528,7 +528,8 @@ static int dvb_frontend_thread(void *dat
 		up(&fepriv->sem);	    /* is locked when we enter the thread... */
 restart:
 		timeout = wait_event_interruptible_timeout(fepriv->wait_queue,
-			dvb_frontend_should_wakeup(fe) || kthread_should_stop(),
+			dvb_frontend_should_wakeup(fe) || kthread_should_stop()
+				|| freezing(current),
 			fepriv->delay);
 
 		if (kthread_should_stop() || dvb_frontend_is_exiting(fe)) {
diff -puN drivers/usb/core/hub.c~freezer-introduce-freezer-firendly-waiting-macros drivers/usb/core/hub.c
--- a/drivers/usb/core/hub.c~freezer-introduce-freezer-firendly-waiting-macros
+++ a/drivers/usb/core/hub.c
@@ -2731,10 +2731,9 @@ static int hub_thread(void *__unused)
 	set_freezable();
 	do {
 		hub_events();
-		wait_event_interruptible(khubd_wait,
+		wait_event_freezable(khubd_wait,
 				!list_empty(&hub_event_list) ||
 				kthread_should_stop());
-		try_to_freeze();
 	} while (!kthread_should_stop() || !list_empty(&hub_event_list));
 
 	pr_debug("%s: khubd exiting\n", usbcore_name);
diff -puN drivers/usb/storage/usb.c~freezer-introduce-freezer-firendly-waiting-macros drivers/usb/storage/usb.c
--- a/drivers/usb/storage/usb.c~freezer-introduce-freezer-firendly-waiting-macros
+++ a/drivers/usb/storage/usb.c
@@ -923,12 +923,9 @@ static int usb_stor_scan_thread(void * _
 	if (delay_use > 0) {
 		printk(KERN_DEBUG "usb-storage: waiting for device "
 				"to settle before scanning\n");
-retry:
-		wait_event_interruptible_timeout(us->delay_wait,
+		wait_event_freezable_timeout(us->delay_wait,
 				test_bit(US_FLIDX_DISCONNECTING, &us->flags),
 				delay_use * HZ);
-		if (try_to_freeze())
-			goto retry;
 	}
 
 	/* If the device is still connected, perform the scanning */
diff -puN include/linux/freezer.h~freezer-introduce-freezer-firendly-waiting-macros include/linux/freezer.h
--- a/include/linux/freezer.h~freezer-introduce-freezer-firendly-waiting-macros
+++ a/include/linux/freezer.h
@@ -4,6 +4,7 @@
 #define FREEZER_H_INCLUDED
 
 #include <linux/sched.h>
+#include <linux/wait.h>
 
 #ifdef CONFIG_PM
 /*
@@ -126,7 +127,37 @@ static inline void set_freezable(void)
 	current->flags &= ~PF_NOFREEZE;
 }
 
-#else
+/*
+ * Freezer-friendly wrappers around wait_event_interruptible() and
+ * wait_event_interruptible_timeout(), originally defined in <linux/wait.h>
+ */
+
+#define wait_event_freezable(wq, condition)				\
+({									\
+	int __ret;							\
+	do {								\
+		__ret = wait_event_interruptible(wq, 			\
+				(condition) || freezing(current));	\
+		if (__ret && !freezing(current))			\
+			break;						\
+		else if (!(condition))					\
+			__ret = -ERESTARTSYS;				\
+	} while (try_to_freeze());					\
+	__ret;								\
+})
+
+
+#define wait_event_freezable_timeout(wq, condition, timeout)		\
+({									\
+	long __ret = timeout;						\
+	do {								\
+		__ret = wait_event_interruptible_timeout(wq,		\
+				(condition) || freezing(current),	\
+				__ret); 				\
+	} while (try_to_freeze());					\
+	__ret;								\
+})
+#else /* CONFIG_PM */
 static inline int frozen(struct task_struct *p) { return 0; }
 static inline int freezing(struct task_struct *p) { return 0; }
 static inline void set_freeze_flag(struct task_struct *p) {}
@@ -143,6 +174,13 @@ static inline void freezer_do_not_count(
 static inline void freezer_count(void) {}
 static inline int freezer_should_skip(struct task_struct *p) { return 0; }
 static inline void set_freezable(void) {}
-#endif
+
+#define wait_event_freezable(wq, condition)				\
+		wait_event_interruptible(wq, condition)
+
+#define wait_event_freezable_timeout(wq, condition, timeout)		\
+		wait_event_interruptible_timeout(wq, condition, timeout)
+
+#endif /* CONFIG_PM */
 
 #endif	/* FREEZER_H_INCLUDED */
_

Patches currently in -mm which might be from rjw@sisk.pl are

git-acpi.patch
pm-move-definition-of-struct-pm_ops-to-suspendh.patch
pm-rename-struct-pm_ops-and-related-things.patch
pm-rework-struct-platform_suspend_ops.patch
pm-fix-compilation-of-suspend-code-if-config_pm-is-unset.patch
pm-make-suspend_ops-static.patch
pm-rework-struct-hibernation_ops.patch
pm-rename-hibernation_ops-to-platform_hibernation_ops.patch
freezer-document-relationship-with-memory-shrinking.patch
freezer-do-not-sync-filesystems-from-freeze_processes.patch
freezer-prevent-new-tasks-from-inheriting-tif_freeze-set.patch
freezer-introduce-freezer-firendly-waiting-macros.patch
freezer-do-not-send-signals-to-kernel-threads.patch
shrink_slab-handle-bad-shrinkers.patch
