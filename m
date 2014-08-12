From: akpm@linux-foundation.org
Subject: [merged]
 proc-convert-proc-pid-syscall-to-seq_file-interface.patch removed from -mm
 tree
Date: Tue, 12 Aug 2014 12:40:02 -0700
Message-ID: <53ea6d92.1z00DfxIAJ7Yb4t8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yk0-f201.google.com ([209.85.160.201]:37151 "EHLO
	mail-yk0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070AbaHLTkD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:40:03 -0400
Received: by mail-yk0-f201.google.com with SMTP id 142so1307995ykq.0
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:40:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: convert /proc/$PID/syscall to seq_file interface
has been removed from the -mm tree.  Its filename was
     proc-convert-proc-pid-syscall-to-seq_file-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: convert /proc/$PID/syscall to seq_file interface

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN fs/proc/base.c~proc-convert-proc-pid-syscall-to-seq_file-interface fs/proc/base.c
--- a/fs/proc/base.c~proc-convert-proc-pid-syscall-to-seq_file-interface
+++ a/fs/proc/base.c
@@ -482,7 +482,8 @@ static int proc_pid_limits(struct seq_fi
 }
 
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
-static int proc_pid_syscall(struct task_struct *task, char *buffer)
+static int proc_pid_syscall(struct seq_file *m, struct pid_namespace *ns,
+			    struct pid *pid, struct task_struct *task)
 {
 	long nr;
 	unsigned long args[6], sp, pc;
@@ -491,11 +492,11 @@ static int proc_pid_syscall(struct task_
 		return res;
 
 	if (task_current_syscall(task, &nr, args, 6, &sp, &pc))
-		res = sprintf(buffer, "running\n");
+		seq_puts(m, "running\n");
 	else if (nr < 0)
-		res = sprintf(buffer, "%ld 0x%lx 0x%lx\n", nr, sp, pc);
+		seq_printf(m, "%ld 0x%lx 0x%lx\n", nr, sp, pc);
 	else
-		res = sprintf(buffer,
+		seq_printf(m,
 		       "%ld 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx\n",
 		       nr,
 		       args[0], args[1], args[2], args[3], args[4], args[5],
@@ -2564,7 +2565,7 @@ static const struct pid_entry tgid_base_
 #endif
 	REG("comm",      S_IRUGO|S_IWUSR, proc_pid_set_comm_operations),
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
-	INF("syscall",    S_IRUSR, proc_pid_syscall),
+	ONE("syscall",    S_IRUSR, proc_pid_syscall),
 #endif
 	INF("cmdline",    S_IRUGO, proc_pid_cmdline),
 	ONE("stat",       S_IRUGO, proc_tgid_stat),
@@ -2900,7 +2901,7 @@ static const struct pid_entry tid_base_s
 #endif
 	REG("comm",      S_IRUGO|S_IWUSR, proc_pid_set_comm_operations),
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
-	INF("syscall",   S_IRUSR, proc_pid_syscall),
+	ONE("syscall",   S_IRUSR, proc_pid_syscall),
 #endif
 	INF("cmdline",   S_IRUGO, proc_pid_cmdline),
 	ONE("stat",      S_IRUGO, proc_tid_stat),
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch

