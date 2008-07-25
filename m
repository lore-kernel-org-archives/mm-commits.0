From: akpm@linux-foundation.org
Subject: - pidns-remove-find_task_by_pid-unused-for-a-long-time.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:02:33 -0700
Message-ID: <200807252302.m6PN2Xnx003834@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754732AbYGYXGo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:06:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, ebiederm@xmission.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     pidns: remove find_task_by_pid, unused for a long time
has been removed from the -mm tree.  Its filename was
     pidns-remove-find_task_by_pid-unused-for-a-long-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pidns: remove find_task_by_pid, unused for a long time
From: Pavel Emelyanov <xemul@openvz.org>

It seems to me that it was a mistake marking this function as deprecated
and scheduling it for removal, rather than resolutely removing it after
the last caller's death.

Anyway - better late, then never.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |   18 ------------------
 include/linux/pid.h                        |    2 +-
 include/linux/sched.h                      |    6 ------
 3 files changed, 1 insertion(+), 25 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~pidns-remove-find_task_by_pid-unused-for-a-long-time Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~pidns-remove-find_task_by_pid-unused-for-a-long-time
+++ a/Documentation/feature-removal-schedule.txt
@@ -138,24 +138,6 @@ Who:	Kay Sievers <kay.sievers@suse.de>
 
 ---------------------------
 
-What:	find_task_by_pid
-When:	2.6.26
-Why:	With pid namespaces, calling this funciton will return the
-	wrong task when called from inside a namespace.
-
-	The best way to save a task pid and find a task by this
-	pid later, is to find this task's struct pid pointer (or get
-	it directly from the task) and call pid_task() later.
-
-	If someone really needs to get a task by its pid_t, then
-	he most likely needs the find_task_by_vpid() to get the
-	task from the same namespace as the current task is in, but
-	this may be not so in general.
-
-Who:	Pavel Emelyanov <xemul@openvz.org>
-
----------------------------
-
 What:	ACPI procfs interface
 When:	July 2008
 Why:	ACPI sysfs conversion should be finished by January 2008.
diff -puN include/linux/pid.h~pidns-remove-find_task_by_pid-unused-for-a-long-time include/linux/pid.h
--- a/include/linux/pid.h~pidns-remove-find_task_by_pid-unused-for-a-long-time
+++ a/include/linux/pid.h
@@ -107,7 +107,7 @@ extern struct pid_namespace init_pid_ns;
  * find_pid_ns() finds the pid in the namespace specified
  * find_vpid() finr the pid by its virtual id, i.e. in the current namespace
  *
- * see also find_task_by_pid() set in include/linux/sched.h
+ * see also find_task_by_vpid() set in include/linux/sched.h
  */
 extern struct pid *find_pid_ns(int nr, struct pid_namespace *ns);
 extern struct pid *find_vpid(int nr);
diff -puN include/linux/sched.h~pidns-remove-find_task_by_pid-unused-for-a-long-time include/linux/sched.h
--- a/include/linux/sched.h~pidns-remove-find_task_by_pid-unused-for-a-long-time
+++ a/include/linux/sched.h
@@ -1715,8 +1715,6 @@ extern struct pid_namespace init_pid_ns;
  *      finds a task by its pid in the specified namespace
  * find_task_by_vpid():
  *      finds a task by its virtual pid
- * find_task_by_pid():
- *      finds a task by its global pid
  *
  * see also find_vpid() etc in include/linux/pid.h
  */
@@ -1724,10 +1722,6 @@ extern struct pid_namespace init_pid_ns;
 extern struct task_struct *find_task_by_pid_type_ns(int type, int pid,
 		struct pid_namespace *ns);
 
-static inline struct task_struct *__deprecated find_task_by_pid(pid_t nr)
-{
-	return find_task_by_pid_type_ns(PIDTYPE_PID, nr, &init_pid_ns);
-}
 extern struct task_struct *find_task_by_vpid(pid_t nr);
 extern struct task_struct *find_task_by_pid_ns(pid_t nr,
 		struct pid_namespace *ns);
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
reiser4.patch

