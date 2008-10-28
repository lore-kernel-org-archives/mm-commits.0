From: akpm@linux-foundation.org
Subject: + oom-print-triggering-tasks-cpuset-and-mems-allowed.patch added to -mm tree
Date: Tue, 28 Oct 2008 14:45:49 -0700
Message-ID: <200810282145.m9SLjncv013531@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48694 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752411AbYJ1Vpy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 17:45:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, menage@google.com


The patch titled
     oom: print triggering task's cpuset and mems allowed
has been added to the -mm tree.  Its filename is
     oom-print-triggering-tasks-cpuset-and-mems-allowed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom: print triggering task's cpuset and mems allowed
From: David Rientjes <rientjes@google.com>

When cpusets are enabled, it's necessary to print the triggering task's
set of allowable nodes so the subsequently printed meminfo can be
interpreted correctly.

We also print the task's cpuset name for informational purposes.

Cc: Paul Menage <menage@google.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpuset.h |    6 ++++++
 kernel/cpuset.c        |   34 ++++++++++++++++++++++++++++++++++
 mm/oom_kill.c          |    1 +
 3 files changed, 41 insertions(+)

diff -puN include/linux/cpuset.h~oom-print-triggering-tasks-cpuset-and-mems-allowed include/linux/cpuset.h
--- a/include/linux/cpuset.h~oom-print-triggering-tasks-cpuset-and-mems-allowed
+++ a/include/linux/cpuset.h
@@ -80,6 +80,8 @@ extern int current_cpuset_is_being_rebou
 
 extern void rebuild_sched_domains(void);
 
+extern void cpuset_print_task_mems_allowed(struct task_struct *p);
+
 #else /* !CONFIG_CPUSETS */
 
 static inline int cpuset_init_early(void) { return 0; }
@@ -163,6 +165,10 @@ static inline void rebuild_sched_domains
 	partition_sched_domains(1, NULL, NULL);
 }
 
+static inline void cpuset_print_task_mems_allowed(struct task_struct *p)
+{
+}
+
 #endif /* !CONFIG_CPUSETS */
 
 #endif /* _LINUX_CPUSET_H */
diff -puN kernel/cpuset.c~oom-print-triggering-tasks-cpuset-and-mems-allowed kernel/cpuset.c
--- a/kernel/cpuset.c~oom-print-triggering-tasks-cpuset-and-mems-allowed
+++ a/kernel/cpuset.c
@@ -239,6 +239,17 @@ static struct cpuset top_cpuset = {
 static DEFINE_MUTEX(callback_mutex);
 
 /*
+ * cpuset_buffer_lock protects both the cpuset_name and cpuset_nodelist
+ * buffers.  They are statically allocated to prevent using excess stack
+ * when calling cpuset_print_task_mems_allowed().
+ */
+#define CPUSET_NAME_LEN		(128)
+#define	CPUSET_NODELIST_LEN	(256)
+static char cpuset_name[CPUSET_NAME_LEN];
+static char cpuset_nodelist[CPUSET_NODELIST_LEN];
+static DEFINE_SPINLOCK(cpuset_buffer_lock);
+
+/*
  * This is ugly, but preserves the userspace API for existing cpuset
  * users. If someone tries to mount the "cpuset" filesystem, we
  * silently switch it to mount "cgroup" instead
@@ -2339,6 +2350,29 @@ int cpuset_mems_allowed_intersects(const
 	return nodes_intersects(tsk1->mems_allowed, tsk2->mems_allowed);
 }
 
+/**
+ * cpuset_print_task_mems_allowed - prints task's cpuset and mems_allowed
+ * @task: pointer to task_struct of some task.
+ *
+ * Description: Prints @task's name, cpuset name, and cached copy of its
+ * mems_allowed to the kernel log.  Must hold task_lock(task) to allow
+ * dereferencing task_cs(task).
+ */
+void cpuset_print_task_mems_allowed(struct task_struct *tsk)
+{
+	struct dentry *dentry;
+
+	dentry = task_cs(tsk)->css.cgroup->dentry;
+	spin_lock(&cpuset_buffer_lock);
+	snprintf(cpuset_name, CPUSET_NAME_LEN,
+		 dentry ? (const char *)dentry->d_name.name : "/");
+	nodelist_scnprintf(cpuset_nodelist, CPUSET_NODELIST_LEN,
+			   tsk->mems_allowed);
+	printk(KERN_INFO "%s cpuset=%s mems_allowed=%s\n",
+	       tsk->comm, cpuset_name, cpuset_nodelist);
+	spin_unlock(&cpuset_buffer_lock);
+}
+
 /*
  * Collection of memory_pressure is suppressed unless
  * this flag is enabled by writing "1" to the special
diff -puN mm/oom_kill.c~oom-print-triggering-tasks-cpuset-and-mems-allowed mm/oom_kill.c
--- a/mm/oom_kill.c~oom-print-triggering-tasks-cpuset-and-mems-allowed
+++ a/mm/oom_kill.c
@@ -393,6 +393,7 @@ static int oom_kill_process(struct task_
 		printk(KERN_WARNING "%s invoked oom-killer: "
 			"gfp_mask=0x%x, order=%d, oomkilladj=%d\n",
 			current->comm, gfp_mask, order, current->oomkilladj);
+		cpuset_print_task_mems_allowed(current);
 		dump_stack();
 		show_mem();
 		if (sysctl_oom_dump_tasks)
_

Patches currently in -mm which might be from rientjes@google.com are

oom-do-not-dump-task-state-for-non-thread-group-leaders.patch
vmemmap-warn-about-page_structs-with-remote-distance.patch
oom-fix-zone_scan_mutex-name.patch
oom-print-triggering-tasks-cpuset-and-mems-allowed.patch

