From: akpm@linux-foundation.org
Subject: [merged]
 proc-convert-proc-pid-schedstat-to-seq_file-interface.patch removed from
 -mm tree
Date: Tue, 12 Aug 2014 12:40:08 -0700
Message-ID: <53ea6d98.DPjIh+c0b4SKC6Jz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:56515 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083AbaHLTkJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:40:09 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so2670724pab.0
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:40:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: convert /proc/$PID/schedstat to seq_file interface
has been removed from the -mm tree.  Its filename was
     proc-convert-proc-pid-schedstat-to-seq_file-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: convert /proc/$PID/schedstat to seq_file interface

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN fs/proc/base.c~proc-convert-proc-pid-schedstat-to-seq_file-interface fs/proc/base.c
--- a/fs/proc/base.c~proc-convert-proc-pid-schedstat-to-seq_file-interface
+++ a/fs/proc/base.c
@@ -310,9 +310,10 @@ static int proc_pid_stack(struct seq_fil
 /*
  * Provides /proc/PID/schedstat
  */
-static int proc_pid_schedstat(struct task_struct *task, char *buffer)
+static int proc_pid_schedstat(struct seq_file *m, struct pid_namespace *ns,
+			      struct pid *pid, struct task_struct *task)
 {
-	return sprintf(buffer, "%llu %llu %lu\n",
+	return seq_printf(m, "%llu %llu %lu\n",
 			(unsigned long long)task->se.sum_exec_runtime,
 			(unsigned long long)task->sched_info.run_delay,
 			task->sched_info.pcount);
@@ -2604,7 +2605,7 @@ static const struct pid_entry tgid_base_
 	ONE("stack",      S_IRUSR, proc_pid_stack),
 #endif
 #ifdef CONFIG_SCHEDSTATS
-	INF("schedstat",  S_IRUGO, proc_pid_schedstat),
+	ONE("schedstat",  S_IRUGO, proc_pid_schedstat),
 #endif
 #ifdef CONFIG_LATENCYTOP
 	REG("latency",  S_IRUGO, proc_lstats_operations),
@@ -2942,7 +2943,7 @@ static const struct pid_entry tid_base_s
 	ONE("stack",      S_IRUSR, proc_pid_stack),
 #endif
 #ifdef CONFIG_SCHEDSTATS
-	INF("schedstat", S_IRUGO, proc_pid_schedstat),
+	ONE("schedstat", S_IRUGO, proc_pid_schedstat),
 #endif
 #ifdef CONFIG_LATENCYTOP
 	REG("latency",  S_IRUGO, proc_lstats_operations),
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch

