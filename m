From: akpm@linux-foundation.org
Subject: - proc-rewrite-do_task_stat-to-correctly-handle-pid-namespaces.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:12:00 -0800
Message-ID: <200802082011.m18KBfO6010137@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50890 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754742AbYBHVB6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:01:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, adobriyan@gmail.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     proc: rewrite do_task_stat to correctly handle pid namespaces.
has been removed from the -mm tree.  Its filename was
     proc-rewrite-do_task_stat-to-correctly-handle-pid-namespaces.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: rewrite do_task_stat to correctly handle pid namespaces.
From: Eric W. Biederman <ebiederm@xmission.com>

Currently (as pointed out by Oleg) do_task_stat has a race when calling
task_pid_nr_ns with the task exiting.  In addition do_task_stat is not
currently displaying information in the context of the pid namespace that
mounted the /proc filesystem.  So "cut -d' ' -f 1 /proc/<pid>/stat" may not
equal <pid>.

This patch fixes the problem by converting to a single_open seq_file show
method.  Getting the pid namespace from the filesystem superblock instead of
current, and simply using the the struct pid from the inode instead of
attempting to get that same pid from the task.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c    |   24 ++++++++++++------------
 fs/proc/base.c     |    4 ++--
 fs/proc/internal.h |    9 ++++++---
 3 files changed, 20 insertions(+), 17 deletions(-)

diff -puN fs/proc/array.c~proc-rewrite-do_task_stat-to-correctly-handle-pid-namespaces fs/proc/array.c
--- a/fs/proc/array.c~proc-rewrite-do_task_stat-to-correctly-handle-pid-namespaces
+++ a/fs/proc/array.c
@@ -77,6 +77,7 @@
 #include <linux/cpuset.h>
 #include <linux/rcupdate.h>
 #include <linux/delayacct.h>
+#include <linux/seq_file.h>
 #include <linux/pid_namespace.h>
 
 #include <asm/pgtable.h>
@@ -390,14 +391,14 @@ static cputime_t task_gtime(struct task_
 	return p->gtime;
 }
 
-static int do_task_stat(struct task_struct *task, char *buffer, int whole)
+static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
+			struct pid *pid, struct task_struct *task, int whole)
 {
 	unsigned long vsize, eip, esp, wchan = ~0UL;
 	long priority, nice;
 	int tty_pgrp = -1, tty_nr = 0;
 	sigset_t sigign, sigcatch;
 	char state;
-	int res;
 	pid_t ppid = 0, pgid = -1, sid = -1;
 	int num_threads = 0;
 	struct mm_struct *mm;
@@ -409,9 +410,6 @@ static int do_task_stat(struct task_stru
 	unsigned long rsslim = 0;
 	char tcomm[sizeof(task->comm)];
 	unsigned long flags;
-	struct pid_namespace *ns;
-
-	ns = current->nsproxy->pid_ns;
 
 	state = *get_task_state(task);
 	vsize = eip = esp = 0;
@@ -498,10 +496,10 @@ static int do_task_stat(struct task_stru
 	/* convert nsec -> ticks */
 	start_time = nsec_to_clock_t(start_time);
 
-	res = sprintf(buffer, "%d (%s) %c %d %d %d %d %d %u %lu \
+	seq_printf(m, "%d (%s) %c %d %d %d %d %d %u %lu \
 %lu %lu %lu %lu %lu %ld %ld %ld %ld %d 0 %llu %lu %ld %lu %lu %lu %lu %lu \
 %lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld\n",
-		task_pid_nr_ns(task, ns),
+		pid_nr_ns(pid, ns),
 		tcomm,
 		state,
 		ppid,
@@ -550,17 +548,19 @@ static int do_task_stat(struct task_stru
 		cputime_to_clock_t(cgtime));
 	if (mm)
 		mmput(mm);
-	return res;
+	return 0;
 }
 
-int proc_tid_stat(struct task_struct *task, char *buffer)
+int proc_tid_stat(struct seq_file *m, struct pid_namespace *ns,
+			struct pid *pid, struct task_struct *task)
 {
-	return do_task_stat(task, buffer, 0);
+	return do_task_stat(m, ns, pid, task, 0);
 }
 
-int proc_tgid_stat(struct task_struct *task, char *buffer)
+int proc_tgid_stat(struct seq_file *m, struct pid_namespace *ns,
+			struct pid *pid, struct task_struct *task)
 {
-	return do_task_stat(task, buffer, 1);
+	return do_task_stat(m, ns, pid, task, 1);
 }
 
 int proc_pid_statm(struct task_struct *task, char *buffer)
diff -puN fs/proc/base.c~proc-rewrite-do_task_stat-to-correctly-handle-pid-namespaces fs/proc/base.c
--- a/fs/proc/base.c~proc-rewrite-do_task_stat-to-correctly-handle-pid-namespaces
+++ a/fs/proc/base.c
@@ -2280,7 +2280,7 @@ static const struct pid_entry tgid_base_
 	REG("sched",      S_IRUGO|S_IWUSR, pid_sched),
 #endif
 	INF("cmdline",    S_IRUGO, pid_cmdline),
-	INF("stat",       S_IRUGO, tgid_stat),
+	ONE("stat",       S_IRUGO, tgid_stat),
 	INF("statm",      S_IRUGO, pid_statm),
 	REG("maps",       S_IRUGO, maps),
 #ifdef CONFIG_NUMA
@@ -2611,7 +2611,7 @@ static const struct pid_entry tid_base_s
 	REG("sched",     S_IRUGO|S_IWUSR, pid_sched),
 #endif
 	INF("cmdline",   S_IRUGO, pid_cmdline),
-	INF("stat",      S_IRUGO, tid_stat),
+	ONE("stat",      S_IRUGO, tid_stat),
 	INF("statm",     S_IRUGO, pid_statm),
 	REG("maps",      S_IRUGO, maps),
 #ifdef CONFIG_NUMA
diff -puN fs/proc/internal.h~proc-rewrite-do_task_stat-to-correctly-handle-pid-namespaces fs/proc/internal.h
--- a/fs/proc/internal.h~proc-rewrite-do_task_stat-to-correctly-handle-pid-namespaces
+++ a/fs/proc/internal.h
@@ -46,10 +46,13 @@ extern int nommu_vma_show(struct seq_fil
 
 extern int maps_protect;
 
-extern void create_seq_entry(char *name, mode_t mode, const struct file_operations *f);
+extern void create_seq_entry(char *name, mode_t mode,
+				const struct file_operations *f);
 extern int proc_exe_link(struct inode *, struct dentry **, struct vfsmount **);
-extern int proc_tid_stat(struct task_struct *,  char *);
-extern int proc_tgid_stat(struct task_struct *, char *);
+extern int proc_tid_stat(struct seq_file *m, struct pid_namespace *ns,
+				struct pid *pid, struct task_struct *task);
+extern int proc_tgid_stat(struct seq_file *m, struct pid_namespace *ns,
+				struct pid *pid, struct task_struct *task);
 extern int proc_pid_status(struct task_struct *, char *);
 extern int proc_pid_statm(struct task_struct *, char *);
 extern loff_t mem_lseek(struct file *file, loff_t offset, int orig);
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
use-find_task_by_vpid-in-audit-code.patch
ia64-fix-ptrace-inside-a-namespace.patch
mips-use-find_task_by_vpid-in-system-calls.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
git-x86.patch
deprecate-find_task_by_pid-kgdb.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
