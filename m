From: akpm@osdl.org
Subject: - swsusp-thaw-userspace-and-kernel-space-separately.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:59:31 -0800
Message-ID: <200612072259.kB7MxV7g029528@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51049 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163687AbWLGW7p (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:59:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ncunningham@linuxmail.org, nigel@suspend2.net, pavel@ucw.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     swsusp: thaw userspace and kernel space separately
has been removed from the -mm tree.  Its filename was
     swsusp-thaw-userspace-and-kernel-space-separately.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: swsusp: thaw userspace and kernel space separately
From: Nigel Cunningham <ncunningham@linuxmail.org>

Modify process thawing so that we can thaw kernel space without thawing
userspace, and thaw kernelspace first.  This will be useful in later
patches, where I intend to get swsusp thawing kernel threads only before
seeking to free memory.

Signed-off-by: Nigel Cunningham <nigel@suspend2.net>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/freezer.h |    9 ++++++++-
 kernel/power/process.c  |   25 ++++++++++++++++++-------
 2 files changed, 26 insertions(+), 8 deletions(-)

diff -puN include/linux/freezer.h~swsusp-thaw-userspace-and-kernel-space-separately include/linux/freezer.h
--- a/include/linux/freezer.h~swsusp-thaw-userspace-and-kernel-space-separately
+++ a/include/linux/freezer.h
@@ -1,5 +1,8 @@
 /* Freezer declarations */
 
+#define FREEZER_KERNEL_THREADS 0
+#define FREEZER_ALL_THREADS 1
+
 #ifdef CONFIG_PM
 /*
  * Check if a process has been frozen
@@ -57,7 +60,8 @@ static inline void frozen_process(struct
 
 extern void refrigerator(void);
 extern int freeze_processes(void);
-extern void thaw_processes(void);
+#define thaw_processes() do { thaw_some_processes(FREEZER_ALL_THREADS); } while(0)
+#define thaw_kernel_threads() do { thaw_some_processes(FREEZER_KERNEL_THREADS); } while(0)
 
 static inline int try_to_freeze(void)
 {
@@ -67,6 +71,9 @@ static inline int try_to_freeze(void)
 	} else
 		return 0;
 }
+
+extern void thaw_some_processes(int all);
+
 #else
 static inline int frozen(struct task_struct *p) { return 0; }
 static inline int freezing(struct task_struct *p) { return 0; }
diff -puN kernel/power/process.c~swsusp-thaw-userspace-and-kernel-space-separately kernel/power/process.c
--- a/kernel/power/process.c~swsusp-thaw-userspace-and-kernel-space-separately
+++ a/kernel/power/process.c
@@ -153,18 +153,29 @@ int freeze_processes(void)
 	return 0;
 }
 
-void thaw_processes(void)
+void thaw_some_processes(int all)
 {
 	struct task_struct *g, *p;
+	int pass = 0; /* Pass 0 = Kernel space, 1 = Userspace */
 
 	printk("Restarting tasks... ");
 	read_lock(&tasklist_lock);
-	do_each_thread(g, p) {
-		if (!freezeable(p))
-			continue;
-		if (!thaw_process(p))
-			printk(KERN_INFO "Strange, %s not stopped\n", p->comm);
-	} while_each_thread(g, p);
+	do {
+		do_each_thread(g, p) {
+			/*
+			 * is_user = 0 if kernel thread or borrowed mm,
+			 * 1 otherwise.
+			 */
+			int is_user = !!(p->mm && !(p->flags & PF_BORROWED_MM));
+			if (!freezeable(p) || (is_user != pass))
+				continue;
+			if (!thaw_process(p))
+				printk(KERN_INFO
+					"Strange, %s not stopped\n", p->comm);
+		} while_each_thread(g, p);
+
+		pass++;
+	} while (pass < 2 && all);
 
 	read_unlock(&tasklist_lock);
 	schedule();
_

Patches currently in -mm which might be from ncunningham@linuxmail.org are

origin.patch

