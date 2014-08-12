From: akpm@linux-foundation.org
Subject: [merged] proc-convert-proc-pid-limits-to-seq_file-interface.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:40:00 -0700
Message-ID: <53ea6d90.2n03nlydLVlQ5Quc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:35643 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062AbaHLTkB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:40:01 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so2670673pab.0
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:40:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: convert /proc/$PID/limits to seq_file interface
has been removed from the -mm tree.  Its filename was
     proc-convert-proc-pid-limits-to-seq_file-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: convert /proc/$PID/limits to seq_file interface

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff -puN fs/proc/base.c~proc-convert-proc-pid-limits-to-seq_file-interface fs/proc/base.c
--- a/fs/proc/base.c~proc-convert-proc-pid-limits-to-seq_file-interface
+++ a/fs/proc/base.c
@@ -440,12 +440,11 @@ static const struct limit_names lnames[R
 };
 
 /* Display limits for a process */
-static int proc_pid_limits(struct task_struct *task, char *buffer)
+static int proc_pid_limits(struct seq_file *m, struct pid_namespace *ns,
+			   struct pid *pid, struct task_struct *task)
 {
 	unsigned int i;
-	int count = 0;
 	unsigned long flags;
-	char *bufptr = buffer;
 
 	struct rlimit rlim[RLIM_NLIMITS];
 
@@ -457,31 +456,29 @@ static int proc_pid_limits(struct task_s
 	/*
 	 * print the file header
 	 */
-	count += sprintf(&bufptr[count], "%-25s %-20s %-20s %-10s\n",
+       seq_printf(m, "%-25s %-20s %-20s %-10s\n",
 			"Limit", "Soft Limit", "Hard Limit", "Units");
 
 	for (i = 0; i < RLIM_NLIMITS; i++) {
 		if (rlim[i].rlim_cur == RLIM_INFINITY)
-			count += sprintf(&bufptr[count], "%-25s %-20s ",
+			seq_printf(m, "%-25s %-20s ",
 					 lnames[i].name, "unlimited");
 		else
-			count += sprintf(&bufptr[count], "%-25s %-20lu ",
+			seq_printf(m, "%-25s %-20lu ",
 					 lnames[i].name, rlim[i].rlim_cur);
 
 		if (rlim[i].rlim_max == RLIM_INFINITY)
-			count += sprintf(&bufptr[count], "%-20s ", "unlimited");
+			seq_printf(m, "%-20s ", "unlimited");
 		else
-			count += sprintf(&bufptr[count], "%-20lu ",
-					 rlim[i].rlim_max);
+			seq_printf(m, "%-20lu ", rlim[i].rlim_max);
 
 		if (lnames[i].unit)
-			count += sprintf(&bufptr[count], "%-10s\n",
-					 lnames[i].unit);
+			seq_printf(m, "%-10s\n", lnames[i].unit);
 		else
-			count += sprintf(&bufptr[count], "\n");
+			seq_putc(m, '\n');
 	}
 
-	return count;
+	return 0;
 }
 
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
@@ -2558,7 +2555,7 @@ static const struct pid_entry tgid_base_
 	ONE("auxv",       S_IRUSR, proc_pid_auxv),
 	ONE("status",     S_IRUGO, proc_pid_status),
 	ONE("personality", S_IRUSR, proc_pid_personality),
-	INF("limits",	  S_IRUGO, proc_pid_limits),
+	ONE("limits",	  S_IRUGO, proc_pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",      S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
@@ -2897,7 +2894,7 @@ static const struct pid_entry tid_base_s
 	ONE("auxv",      S_IRUSR, proc_pid_auxv),
 	ONE("status",    S_IRUGO, proc_pid_status),
 	ONE("personality", S_IRUSR, proc_pid_personality),
-	INF("limits",	 S_IRUGO, proc_pid_limits),
+	ONE("limits",	 S_IRUGO, proc_pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",     S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch

