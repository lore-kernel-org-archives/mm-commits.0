From: akpm@linux-foundation.org
Subject: - deprecate-find_task_by_pid.patch removed from -mm tree
Date: Thu, 01 May 2008 02:31:16 -0700
Message-ID: <200805010931.m419VGsd030855@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755538AbYEAJbb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:31:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, ebiederm@xmission.com, sukadev@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Deprecate find_task_by_pid()
has been removed from the -mm tree.  Its filename was
     deprecate-find_task_by_pid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Deprecate find_task_by_pid()
From: Pavel Emelyanov <xemul@openvz.org>

There are some places that are known to operate on tasks'
global pids only:

* the rest_init() call (called on boot)
* the kgdb's getthread
* the create_kthread() (since the kthread is run in init ns)

So use the find_task_by_pid_ns(..., &init_pid_ns) there
and schedule the find_task_by_pid for removal.

[sukadev@us.ibm.com: Fix warning in kernel/pid.c]
Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |   18 ++++++++++++++++++
 include/linux/sched.h                      |    5 ++++-
 init/main.c                                |    2 +-
 kernel/kthread.c                           |    2 +-
 kernel/pid.c                               |    6 ------
 5 files changed, 24 insertions(+), 9 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~deprecate-find_task_by_pid Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~deprecate-find_task_by_pid
+++ a/Documentation/feature-removal-schedule.txt
@@ -138,6 +138,24 @@ Who:	Kay Sievers <kay.sievers@suse.de>
 
 ---------------------------
 
+What:	find_task_by_pid
+When:	2.6.26
+Why:	With pid namespaces, calling this funciton will return the
+	wrong task when called from inside a namespace.
+
+	The best way to save a task pid and find a task by this
+	pid later, is to find this task's struct pid pointer (or get
+	it directly from the task) and call pid_task() later.
+
+	If someone really needs to get a task by its pid_t, then
+	he most likely needs the find_task_by_vpid() to get the
+	task from the same namespace as the current task is in, but
+	this may be not so in general.
+
+Who:	Pavel Emelyanov <xemul@openvz.org>
+
+---------------------------
+
 What:	ACPI procfs interface
 When:	July 2008
 Why:	ACPI sysfs conversion should be finished by January 2008.
diff -puN include/linux/sched.h~deprecate-find_task_by_pid include/linux/sched.h
--- a/include/linux/sched.h~deprecate-find_task_by_pid
+++ a/include/linux/sched.h
@@ -1677,7 +1677,10 @@ extern struct pid_namespace init_pid_ns;
 extern struct task_struct *find_task_by_pid_type_ns(int type, int pid,
 		struct pid_namespace *ns);
 
-extern struct task_struct *find_task_by_pid(pid_t nr);
+static inline struct task_struct *__deprecated find_task_by_pid(pid_t nr)
+{
+	return find_task_by_pid_type_ns(PIDTYPE_PID, nr, &init_pid_ns);
+}
 extern struct task_struct *find_task_by_vpid(pid_t nr);
 extern struct task_struct *find_task_by_pid_ns(pid_t nr,
 		struct pid_namespace *ns);
diff -puN init/main.c~deprecate-find_task_by_pid init/main.c
--- a/init/main.c~deprecate-find_task_by_pid
+++ a/init/main.c
@@ -459,7 +459,7 @@ static void noinline __init_refok rest_i
 	kernel_thread(kernel_init, NULL, CLONE_FS | CLONE_SIGHAND);
 	numa_default_policy();
 	pid = kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
-	kthreadd_task = find_task_by_pid(pid);
+	kthreadd_task = find_task_by_pid_ns(pid, &init_pid_ns);
 	unlock_kernel();
 
 	/*
diff -puN kernel/kthread.c~deprecate-find_task_by_pid kernel/kthread.c
--- a/kernel/kthread.c~deprecate-find_task_by_pid
+++ a/kernel/kthread.c
@@ -98,7 +98,7 @@ static void create_kthread(struct kthrea
 		struct sched_param param = { .sched_priority = 0 };
 		wait_for_completion(&create->started);
 		read_lock(&tasklist_lock);
-		create->result = find_task_by_pid(pid);
+		create->result = find_task_by_pid_ns(pid, &init_pid_ns);
 		read_unlock(&tasklist_lock);
 		/*
 		 * root may have changed our (kthreadd's) priority or CPU mask.
diff -puN kernel/pid.c~deprecate-find_task_by_pid kernel/pid.c
--- a/kernel/pid.c~deprecate-find_task_by_pid
+++ a/kernel/pid.c
@@ -381,12 +381,6 @@ struct task_struct *find_task_by_pid_typ
 
 EXPORT_SYMBOL(find_task_by_pid_type_ns);
 
-struct task_struct *find_task_by_pid(pid_t nr)
-{
-	return find_task_by_pid_type_ns(PIDTYPE_PID, nr, &init_pid_ns);
-}
-EXPORT_SYMBOL(find_task_by_pid);
