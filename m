From: akpm@linux-foundation.org
Subject: + proc-export-a-processes-resource-limits-via-proc-pid.patch added to -mm tree
Date: Mon, 20 Aug 2007 14:42:40 -0700
Message-ID: <200708202142.l7KLgeaI024614@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54106 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751254AbXHTVnp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 17:43:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nhorman@tuxdriver.com, oleg@tv-sign.ru


The patch titled
     proc: export a processes resource limits via /proc/pid
has been added to the -mm tree.  Its filename is
     proc-export-a-processes-resource-limits-via-proc-pid.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 75 insertions(+)

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
@@ -324,6 +325,78 @@ static int proc_oom_score(struct task_st
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
@@ -2025,6 +2098,7 @@ static const struct pid_entry tgid_base_
 	INF("environ",    S_IRUSR, pid_environ),
 	INF("auxv",       S_IRUSR, pid_auxv),
 	INF("status",     S_IRUGO, pid_status),
+	INF("limits",	  S_IRUSR, pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",      S_IRUGO|S_IWUSR, pid_sched),
 #endif
@@ -2353,6 +2427,7 @@ static const struct pid_entry tid_base_s
 	INF("environ",   S_IRUSR, pid_environ),
 	INF("auxv",      S_IRUSR, pid_auxv),
 	INF("status",    S_IRUGO, pid_status),
+	INF("limits",	 S_IRUSR, pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",     S_IRUGO|S_IWUSR, pid_sched),
 #endif
_

Patches currently in -mm which might be from nhorman@tuxdriver.com are

git-net.patch
argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch
core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe.patch
core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe-fix.patch
core_pattern-allow-passing-of-arguments-to-user-mode-helper-when-core_pattern-is-a-pipe.patch
core_pattern-fix-up-a-few-miscellaneous-bugs.patch
core_pattern-fix-up-a-few-miscellaneous-bugs-fix.patch
proc-export-a-processes-resource-limits-via-proc-pid.patch
