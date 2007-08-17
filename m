From: akpm@linux-foundation.org
Subject: + proc-export-a-processes-resource-limits-via-proc-pid.patch added to -mm tree
Date: Fri, 17 Aug 2007 14:31:57 -0700
Message-ID: <200708172131.l7HLVwOm030416@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41009 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755810AbXHQVdR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 17:33:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nhorman@tuxdriver.com


The patch titled
     proc: export a processes resource limits via proc/<pid>
has been added to the -mm tree.  Its filename is
     proc-export-a-processes-resource-limits-via-proc-pid.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: proc: export a processes resource limits via proc/<pid>
From: Neil Horman <nhorman@tuxdriver.com>

Currently, there exists no method for a process to query the resource
limits of another process.  They can be inferred via some mechanisms but
they cannot be explicitly determined.  Given that this information can be
usefull to know during the debugging of an application, I've written this
patch which exports all of a processes limits via /proc/<pid>/limits.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   69 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 69 insertions(+)

diff -puN fs/proc/base.c~proc-export-a-processes-resource-limits-via-proc-pid fs/proc/base.c
--- a/fs/proc/base.c~proc-export-a-processes-resource-limits-via-proc-pid
+++ a/fs/proc/base.c
@@ -73,6 +73,7 @@
 #include <linux/nsproxy.h>
 #include <linux/oom.h>
 #include <linux/elf.h>
+#include <linux/resource.h>
 #include "internal.h"
 
 /* NOTE:
@@ -322,6 +323,72 @@ static int proc_oom_score(struct task_st
 	return sprintf(buffer, "%lu\n", points);
 }
 
+struct limit_names {
+	char *name;
+	char *unit;
+};
+
+static const struct limit_names lnames[RLIM_NLIMITS] = {
+	[RLIMIT_CPU] = {"Max cpu time", "seconds"},
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
+	char *bufptr = buffer;
+
+	struct rlimit rlim[RLIM_NLIMITS];
+
+	read_lock(&tasklist_lock);
+	memcpy(rlim, task->signal->rlim, sizeof(struct rlimit) * RLIM_NLIMITS);
+	read_unlock(&tasklist_lock);
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
@@ -2016,6 +2083,7 @@ static const struct pid_entry tgid_base_
 	INF("environ",    S_IRUSR, pid_environ),
 	INF("auxv",       S_IRUSR, pid_auxv),
 	INF("status",     S_IRUGO, pid_status),
+	INF("limits",	  S_IRUSR, pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",      S_IRUGO|S_IWUSR, pid_sched),
 #endif
@@ -2306,6 +2374,7 @@ static const struct pid_entry tid_base_s
 	INF("environ",   S_IRUSR, pid_environ),
 	INF("auxv",      S_IRUSR, pid_auxv),
 	INF("status",    S_IRUGO, pid_status),
+	INF("limits",	 S_IRUSR, pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",     S_IRUGO|S_IWUSR, pid_sched),
 #endif
_

Patches currently in -mm which might be from nhorman@tuxdriver.com are

argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch
core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe.patch
core_pattern-ignore-rlimit_core-if-core_pattern-is-a-pipe-fix.patch
core_pattern-allow-passing-of-arguments-to-user-mode-helper-when-core_pattern-is-a-pipe.patch
core_pattern-fix-up-a-few-miscellaneous-bugs.patch
core_pattern-fix-up-a-few-miscellaneous-bugs-fix.patch
proc-export-a-processes-resource-limits-via-proc-pid.patch
proc-export-a-processes-resource-limits-via-proc-pid-fix.patch
