From: akpm@linux-foundation.org
Subject: - proc-export-a-processes-resource-limits-via-proc-pid.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:53:04 -0700
Message-ID: <200710192253.l9JMr4ff024398@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41025 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966653AbXJSXGH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:06:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nhorman@tuxdriver.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     proc: export a processes resource limits via /proc/pid
has been removed from the -mm tree.  Its filename was
     proc-export-a-processes-resource-limits-via-proc-pid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: proc: export a processes resource limits via /proc/pid
From: Neil Horman <nhorman@tuxdriver.com>

Currently, there exists no method for a process to query the resource
limits of another process.  They can be inferred via some mechanisms but
they cannot be explicitly determined.  Given that this information can be
usefull to know during the debugging of an application, I've written this
patch which exports all of a processes limits via /proc/<pid>/limits.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   75 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

diff -puN fs/proc/base.c~proc-export-a-processes-resource-limits-via-proc-pid fs/proc/base.c
--- a/fs/proc/base.c~proc-export-a-processes-resource-limits-via-proc-pid
+++ a/fs/proc/base.c
@@ -63,6 +63,7 @@
 #include <linux/mm.h>
 #include <linux/rcupdate.h>
 #include <linux/kallsyms.h>
+#include <linux/resource.h>
 #include <linux/module.h>
 #include <linux/mount.h>
 #include <linux/security.h>
@@ -303,6 +304,78 @@ static int proc_oom_score(struct task_st
 	return sprintf(buffer, "%lu\n", points);
 }
 
+struct limit_names {
+	char *name;
+	char *unit;
+};
+
+static const struct limit_names lnames[RLIM_NLIMITS] = {
+	[RLIMIT_CPU] = {"Max cpu time", "ms"},
+	[RLIMIT_FSIZE] = {"Max file size", "bytes"},
+	[RLIMIT_DATA] = {"Max data size", "bytes"},
+	[RLIMIT_STACK] = {"Max stack size", "bytes"},
+	[RLIMIT_CORE] = {"Max core file size", "bytes"},
+	[RLIMIT_RSS] = {"Max resident set", "bytes"},
+	[RLIMIT_NPROC] = {"Max processes", "processes"},
+	[RLIMIT_NOFILE] = {"Max open files", "files"},
+	[RLIMIT_MEMLOCK] = {"Max locked memory", "bytes"},
+	[RLIMIT_AS] = {"Max address space", "bytes"},
+	[RLIMIT_LOCKS] = {"Max file locks", "locks"},
+	[RLIMIT_SIGPENDING] = {"Max pending signals", "signals"},
+	[RLIMIT_MSGQUEUE] = {"Max msgqueue size", "bytes"},
+	[RLIMIT_NICE] = {"Max nice priority", NULL},
+	[RLIMIT_RTPRIO] = {"Max realtime priority", NULL},
+};
+
+/* Display limits for a process */
+static int proc_pid_limits(struct task_struct *task, char *buffer)
+{
+	unsigned int i;
+	int count = 0;
+	unsigned long flags;
+	char *bufptr = buffer;
+
+	struct rlimit rlim[RLIM_NLIMITS];
+
+	rcu_read_lock();
+	if (!lock_task_sighand(task,&flags)) {
+		rcu_read_unlock();
+		return 0;
+	}
+	memcpy(rlim, task->signal->rlim, sizeof(struct rlimit) * RLIM_NLIMITS);
+	unlock_task_sighand(task, &flags);
+	rcu_read_unlock();
+
+	/*
+	 * print the file header
+	 */
+	count += sprintf(&bufptr[count], "%-25s %-20s %-20s %-10s\n",
+			"Limit", "Soft Limit", "Hard Limit", "Units");
+
+	for (i = 0; i < RLIM_NLIMITS; i++) {
+		if (rlim[i].rlim_cur == RLIM_INFINITY)
+			count += sprintf(&bufptr[count], "%-25s %-20s ",
+					 lnames[i].name, "unlimited");
+		else
+			count += sprintf(&bufptr[count], "%-25s %-20lu ",
+					 lnames[i].name, rlim[i].rlim_cur);
+
+		if (rlim[i].rlim_max == RLIM_INFINITY)
+			count += sprintf(&bufptr[count], "%-20s ", "unlimited");
+		else
+			count += sprintf(&bufptr[count], "%-20lu ",
+					 rlim[i].rlim_max);
+
+		if (lnames[i].unit)
+			count += sprintf(&bufptr[count], "%-10s\n",
+					 lnames[i].unit);
+		else
+			count += sprintf(&bufptr[count], "\n");
+	}
+
+	return count;
+}
+
 /************************************************************************/
 /*                       Here the fs part begins                        */
 /************************************************************************/
@@ -2110,6 +2183,7 @@ static const struct pid_entry tgid_base_
 	REG("environ",    S_IRUSR, environ),
 	INF("auxv",       S_IRUSR, pid_auxv),
 	INF("status",     S_IRUGO, pid_status),
+	INF("limits",	  S_IRUSR, pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",      S_IRUGO|S_IWUSR, pid_sched),
 #endif
@@ -2435,6 +2509,7 @@ static const struct pid_entry tid_base_s
 	REG("environ",   S_IRUSR, environ),
 	INF("auxv",      S_IRUSR, pid_auxv),
 	INF("status",    S_IRUGO, pid_status),
+	INF("limits",	 S_IRUSR, pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",     S_IRUGO|S_IWUSR, pid_sched),
 #endif
_

Patches currently in -mm which might be from nhorman@tuxdriver.com are

origin.patch
