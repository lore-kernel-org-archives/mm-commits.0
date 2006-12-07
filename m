From: akpm@osdl.org
Subject: - swsusp-untangle-thaw_processes.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:59:44 -0800
Message-ID: <200612072259.kB7MxieS029546@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51073 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163679AbWLGW7y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:59:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, nigel@suspend2.net, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     swsusp: Untangle thaw_processes
has been removed from the -mm tree.  Its filename was
     swsusp-untangle-thaw_processes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: swsusp: Untangle thaw_processes
From: "Rafael J. Wysocki" <rjw@sisk.pl>

Move the loop from thaw_processes() to a separate function and call it
independently for kernel threads and user space processes so that the order
of thawing tasks is clearly visible.

Drop thaw_kernel_threads() which is never used.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Nigel Cunningham <nigel@suspend2.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/freezer.h |    6 ----
 kernel/power/process.c  |   53 ++++++++++++++++++++------------------
 2 files changed, 30 insertions(+), 29 deletions(-)

diff -puN include/linux/freezer.h~swsusp-untangle-thaw_processes include/linux/freezer.h
--- a/include/linux/freezer.h~swsusp-untangle-thaw_processes
+++ a/include/linux/freezer.h
@@ -1,8 +1,5 @@
 /* Freezer declarations */
 
-#define FREEZER_KERNEL_THREADS 0
-#define FREEZER_ALL_THREADS 1
-
 #ifdef CONFIG_PM
 /*
  * Check if a process has been frozen
@@ -60,8 +57,7 @@ static inline void frozen_process(struct
 
 extern void refrigerator(void);
 extern int freeze_processes(void);
-#define thaw_processes() do { thaw_some_processes(FREEZER_ALL_THREADS); } while(0)
-#define thaw_kernel_threads() do { thaw_some_processes(FREEZER_KERNEL_THREADS); } while(0)
+extern void thaw_processes(void);
 
 static inline int try_to_freeze(void)
 {
diff -puN kernel/power/process.c~swsusp-untangle-thaw_processes kernel/power/process.c
--- a/kernel/power/process.c~swsusp-untangle-thaw_processes
+++ a/kernel/power/process.c
@@ -20,6 +20,8 @@
  */
 #define TIMEOUT	(20 * HZ)
 
+#define FREEZER_KERNEL_THREADS 0
+#define FREEZER_USER_SPACE 1
 
 static inline int freezeable(struct task_struct * p)
 {
@@ -79,6 +81,11 @@ static void cancel_freezing(struct task_
 	}
 }
 
+static inline int is_user_space(struct task_struct *p)
+{
+	return p->mm && !(p->flags & PF_BORROWED_MM);
+}
+
 /* 0 = success, else # of processes that we failed to stop */
 int freeze_processes(void)
 {
@@ -103,10 +110,9 @@ int freeze_processes(void)
 				cancel_freezing(p);
 				continue;
 			}
-			if (p->mm && !(p->flags & PF_BORROWED_MM)) {
-				/* The task is a user-space one.
-				 * Freeze it unless there's a vfork completion
-				 * pending
+			if (is_user_space(p)) {
+				/* Freeze the task unless there is a vfork
+				 * completion pending
 				 */
 				if (!p->vfork_done)
 					freeze_process(p);
@@ -155,31 +161,30 @@ int freeze_processes(void)
 	return 0;
 }
 
-void thaw_some_processes(int all)
+static void thaw_tasks(int thaw_user_space)
 {
 	struct task_struct *g, *p;
-	int pass = 0; /* Pass 0 = Kernel space, 1 = Userspace */
 
-	printk("Restarting tasks... ");
 	read_lock(&tasklist_lock);
-	do {
-		do_each_thread(g, p) {
-			/*
-			 * is_user = 0 if kernel thread or borrowed mm,
-			 * 1 otherwise.
-			 */
-			int is_user = !!(p->mm && !(p->flags & PF_BORROWED_MM));
-			if (!freezeable(p) || (is_user != pass))
-				continue;
-			if (!thaw_process(p))
-				printk(KERN_INFO
-					"Strange, %s not stopped\n", p->comm);
-		} while_each_thread(g, p);
-
-		pass++;
-	} while (pass < 2 && all);
-
+	do_each_thread(g, p) {
+		if (!freezeable(p))
+			continue;
+
+		if (is_user_space(p) == !thaw_user_space)
+			continue;
+
+		if (!thaw_process(p))
+			printk(KERN_WARNING " Strange, %s not stopped\n",
+				p->comm );
+	} while_each_thread(g, p);
 	read_unlock(&tasklist_lock);
+}
+
+void thaw_processes(void)
+{
+	printk("Restarting tasks ... ");
+	thaw_tasks(FREEZER_KERNEL_THREADS);
+	thaw_tasks(FREEZER_USER_SPACE);
 	schedule();
 	printk("done.\n");
 }
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
md-change-lifetime-rules-for-md-devices.patch

