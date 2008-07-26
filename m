From: akpm@linux-foundation.org
Subject: - proc-pid-syscall.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:17:13 -0700
Message-ID: <200807262117.m6QLHDIC019916@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37582 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757991AbYGZVR6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:17:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, mingo@elte.hu, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     /proc/PID/syscall
has been removed from the -mm tree.  Its filename was
     proc-pid-syscall.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: /proc/PID/syscall
From: Roland McGrath <roland@redhat.com>

This adds /proc/PID/syscall and /proc/PID/task/TID/syscall magic files. 
These use task_current_syscall() to show the task's current system call
number and argument registers, stack pointer and PC.  For a task blocked
but not in a syscall, the file shows "-1" in place of the syscall number,
followed by only the SP and PC.  For a task that's not blocked, it shows
"running".

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff -puN fs/proc/base.c~proc-pid-syscall fs/proc/base.c
--- a/fs/proc/base.c~proc-pid-syscall
+++ a/fs/proc/base.c
@@ -509,6 +509,26 @@ static int proc_pid_limits(struct task_s
 	return count;
 }
 
+#ifdef CONFIG_HAVE_ARCH_TRACEHOOK
+static int proc_pid_syscall(struct task_struct *task, char *buffer)
+{
+	long nr;
+	unsigned long args[6], sp, pc;
+
+	if (task_current_syscall(task, &nr, args, 6, &sp, &pc))
+		return sprintf(buffer, "running\n");
+
+	if (nr < 0)
+		return sprintf(buffer, "%ld 0x%lx 0x%lx\n", nr, sp, pc);
+
+	return sprintf(buffer,
+		       "%ld 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx\n",
+		       nr,
+		       args[0], args[1], args[2], args[3], args[4], args[5],
+		       sp, pc);
+}
+#endif /* CONFIG_HAVE_ARCH_TRACEHOOK */
+
 /************************************************************************/
 /*                       Here the fs part begins                        */
 /************************************************************************/
@@ -2478,6 +2498,9 @@ static const struct pid_entry tgid_base_
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",      S_IRUGO|S_IWUSR, pid_sched),
 #endif
+#ifdef CONFIG_HAVE_ARCH_TRACEHOOK
+	INF("syscall",    S_IRUSR, pid_syscall),
+#endif
 	INF("cmdline",    S_IRUGO, pid_cmdline),
 	ONE("stat",       S_IRUGO, tgid_stat),
 	ONE("statm",      S_IRUGO, pid_statm),
@@ -2810,6 +2833,9 @@ static const struct pid_entry tid_base_s
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",     S_IRUGO|S_IWUSR, pid_sched),
 #endif
+#ifdef CONFIG_HAVE_ARCH_TRACEHOOK
+	INF("syscall",   S_IRUSR, pid_syscall),
+#endif
 	INF("cmdline",   S_IRUGO, pid_cmdline),
 	ONE("stat",      S_IRUGO, tid_stat),
 	ONE("statm",     S_IRUGO, pid_statm),
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
tracehook-syscall.patch
tracehook-config_have_arch_tracehook.patch
x86-tracehook_signal_handler.patch
x86-tracehook-syscall.patch
x86-tracehook-asm-syscallh.patch
x86-signals-use-asm-syscallh.patch
x86-tracehook-tif_notify_resume.patch
x86-tracehook-config_have_arch_tracehook.patch

