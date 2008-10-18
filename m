From: akpm@linux-foundation.org
Subject: - container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:41:46 -0700
Message-ID: <200810182341.m9INfkhe000382@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42173 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751006AbYJRXmC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:42:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthltc@us.ibm.com, clg@fr.ibm.com, pavel@suse.cz, rjw@sisk.pl, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     container freezer: uninline thaw_process()
has been removed from the -mm tree.  Its filename was
     container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process.patch

This patch was dropped because it was folded into container-freezer-implement-freezer-cgroup-subsystem.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: container freezer: uninline thaw_process()
From: Matt Helsley <matthltc@us.ibm.com>

Now that the cgroup freezer system also calls thaw_process() inlining
these functions uses more space.  Uninlining returns some space:

Before:
	text	data	bss	dec	hex	filename
	4260872	275532	290816	4827220 49a854	vmlinux
After:
	text	data	bss	dec	hex	filename
	4260852	275532	290816	4827200	49a840	vmlinux

Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Pavel Machek <pavel@suse.cz>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/freezer.h |   29 +++--------------------------
 kernel/freezer.c        |   31 +++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 26 deletions(-)

diff -puN include/linux/freezer.h~container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process include/linux/freezer.h
--- a/include/linux/freezer.h~container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process
+++ a/include/linux/freezer.h
@@ -46,34 +46,11 @@ static inline bool should_send_signal(st
 
 /*
  * Wake up a frozen process
- *
- * task_lock() is needed to prevent the race with refrigerator() which may
- * occur if the freezing of tasks fails.  Namely, without the lock, if the
- * freezing of tasks failed, thaw_tasks() might have run before a task in
- * refrigerator() could call frozen_process(), in which case the task would be
- * frozen and no one would thaw it.
  */
-static inline int __thaw_process(struct task_struct *p)
-{
-	if (frozen(p)) {
-		p->flags &= ~PF_FROZEN;
-		return 1;
-	}
-	clear_freeze_flag(p);
-	return 0;
-}
+extern int __thaw_process(struct task_struct *p);
 
-static inline int thaw_process(struct task_struct *p)
-{
-	task_lock(p);
-	if (__thaw_process(p) == 1) {
-		task_unlock(p);
-		wake_up_process(p);
-		return 1;
-	}
-	task_unlock(p);
-	return 0;
-}
+/* Takes and releases task alloc lock using task_lock() */
+extern int thaw_process(struct task_struct *p);
 
 extern void refrigerator(void);
 extern int freeze_processes(void);
diff -puN kernel/freezer.c~container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process kernel/freezer.c
--- a/kernel/freezer.c~container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process
+++ a/kernel/freezer.c
@@ -120,3 +120,34 @@ void cancel_freezing(struct task_struct 
 		spin_unlock_irqrestore(&p->sighand->siglock, flags);
 	}
 }
+
+/*
+ * Wake up a frozen process
+ *
+ * task_lock() is needed to prevent the race with refrigerator() which may
+ * occur if the freezing of tasks fails.  Namely, without the lock, if the
+ * freezing of tasks failed, thaw_tasks() might have run before a task in
+ * refrigerator() could call frozen_process(), in which case the task would be
+ * frozen and no one would thaw it.
+ */
+int __thaw_process(struct task_struct *p)
+{
+	if (frozen(p)) {
+		p->flags &= ~PF_FROZEN;
+		return 1;
+	}
+	clear_freeze_flag(p);
+	return 0;
+}
+
+int thaw_process(struct task_struct *p)
+{
+	task_lock(p);
+	if (__thaw_process(p) == 1) {
+		task_unlock(p);
+		wake_up_process(p);
+		return 1;
+	}
+	task_unlock(p);
+	return 0;
+}
_

Patches currently in -mm which might be from matthltc@us.ibm.com are

container-freezer-add-tif_freeze-flag-to-all-architectures.patch
container-freezer-make-refrigerator-always-available.patch
container-freezer-implement-freezer-cgroup-subsystem.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process-fix.patch
container-freezer-implement-freezer-cgroup-subsystem-cleanup-comment.patch
container-freezer-skip-frozen-cgroups-during-power-management-resume.patch
container-freezer-prevent-frozen-tasks-or-cgroups-from-changing.patch
container-freezer-make-freezer-state-names-less-generic.patch
container-freezer-rename-check_if_frozen.patch
container-freezer-document-the-cgroup-freezer-subsystem.patch

