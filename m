From: akpm@linux-foundation.org
Subject: [merged] procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:55:04 -0800
Message-ID: <200912152155.nBFLt43V015435@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43264 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761271AbZLOVzV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:55:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnstul@us.ibm.com, Sean_Foley@ca.ibm.com, andi@firstfloor.org, arjan@infradead.org, dvhltc@us.ibm.com, fultonm@ca.ibm.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     procfs: allow threads to rename siblings via /proc/pid/tasks/tid/comm
has been removed from the -mm tree.  Its filename was
     procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: procfs: allow threads to rename siblings via /proc/pid/tasks/tid/comm
From: john stultz <johnstul@us.ibm.com>

Setting a thread's comm to be something unique is a very useful ability
and is helpful for debugging complicated threaded applications.  However
currently the only way to set a thread name is for the thread to name
itself via the PR_SET_NAME prctl.

However, there may be situations where it would be advantageous for a
thread dispatcher to be naming the threads its managing, rather then
having the threads self-describe themselves.  This sort of behavior is
available on other systems via the pthread_setname_np() interface.

This patch exports a task's comm via proc/pid/comm and
proc/pid/task/tid/comm interfaces, and allows thread siblings to write to
these values.

[akpm@linux-foundation.org: cleanups]
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Mike Fulton <fultonm@ca.ibm.com>
Cc: Sean Foley <Sean_Foley@ca.ibm.com>
Cc: Darren Hart <dvhltc@us.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    9 +++
 fs/exec.c                          |    9 +++
 fs/proc/base.c                     |   68 +++++++++++++++++++++++++++
 3 files changed, 86 insertions(+)

diff -puN Documentation/filesystems/proc.txt~procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm
+++ a/Documentation/filesystems/proc.txt
@@ -38,6 +38,7 @@ Table of Contents
   3.3	/proc/<pid>/io - Display the IO accounting fields
   3.4	/proc/<pid>/coredump_filter - Core dump filtering settings
   3.5	/proc/<pid>/mountinfo - Information about mounts
+  3.6	/proc/<pid>/comm  & /proc/<pid>/task/<tid>/comm
 
 
 ------------------------------------------------------------------------------
@@ -1409,3 +1410,11 @@ For more information on mount propagatio
 
   Documentation/filesystems/sharedsubtree.txt
 
+
+3.6	/proc/<pid>/comm  & /proc/<pid>/task/<tid>/comm
+--------------------------------------------------------
+These files provide a method to access a tasks comm value. It also allows for
+a task to set its own or one of its thread siblings comm value. The comm value
+is limited in size compared to the cmdline value, so writing anything longer
+then the kernel's TASK_COMM_LEN (currently 16 chars) will result in a truncated
+comm value.
diff -puN fs/exec.c~procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm fs/exec.c
--- a/fs/exec.c~procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm
+++ a/fs/exec.c
@@ -923,6 +923,15 @@ char *get_task_comm(char *buf, struct ta
 void set_task_comm(struct task_struct *tsk, char *buf)
 {
 	task_lock(tsk);
+
+	/*
+	 * Threads may access current->comm without holding
+	 * the task lock, so write the string carefully.
+	 * Readers without a lock may see incomplete new
+	 * names but are safe from non-terminating string reads.
+	 */
+	memset(tsk->comm, 0, TASK_COMM_LEN);
+	wmb();
 	strlcpy(tsk->comm, buf, sizeof(tsk->comm));
 	task_unlock(tsk);
 	perf_event_comm(tsk);
diff -puN fs/proc/base.c~procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm fs/proc/base.c
--- a/fs/proc/base.c~procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm
+++ a/fs/proc/base.c
@@ -1265,6 +1265,72 @@ static const struct file_operations proc
 
 #endif
 
+static ssize_t comm_write(struct file *file, const char __user *buf,
+				size_t count, loff_t *offset)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct task_struct *p;
+	char buffer[TASK_COMM_LEN];
+
+	memset(buffer, 0, sizeof(buffer));
+	if (count > sizeof(buffer) - 1)
+		count = sizeof(buffer) - 1;
+	if (copy_from_user(buffer, buf, count))
+		return -EFAULT;
+
+	p = get_proc_task(inode);
+	if (!p)
+		return -ESRCH;
+
+	if (same_thread_group(current, p))
+		set_task_comm(p, buffer);
+	else
+		count = -EINVAL;
+
+	put_task_struct(p);
+
+	return count;
+}
+
+static int comm_show(struct seq_file *m, void *v)
+{
+	struct inode *inode = m->private;
+	struct task_struct *p;
+
+	p = get_proc_task(inode);
+	if (!p)
+		return -ESRCH;
+
+	task_lock(p);
+	seq_printf(m, "%s\n", p->comm);
+	task_unlock(p);
+
+	put_task_struct(p);
+
+	return 0;
+}
+
+static int comm_open(struct inode *inode, struct file *filp)
+{
+	int ret;
+
+	ret = single_open(filp, comm_show, NULL);
+	if (!ret) {
+		struct seq_file *m = filp->private_data;
+
+		m->private = inode;
+	}
+	return ret;
+}
+
+static const struct file_operations proc_pid_set_comm_operations = {
+	.open		= comm_open,
+	.read		= seq_read,
+	.write		= comm_write,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 /*
  * We added or removed a vma mapping the executable. The vmas are only mapped
  * during exec and are not mapped with the mmap system call.
@@ -2504,6 +2570,7 @@ static const struct pid_entry tgid_base_
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",      S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
+	REG("comm",      S_IRUGO|S_IWUSR, proc_pid_set_comm_operations),
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 	INF("syscall",    S_IRUSR, proc_pid_syscall),
 #endif
@@ -2838,6 +2905,7 @@ static const struct pid_entry tid_base_s
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",     S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
+	REG("comm",      S_IRUGO|S_IWUSR, proc_pid_set_comm_operations),
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 	INF("syscall",   S_IRUSR, proc_pid_syscall),
 #endif
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

origin.patch
linux-next.patch
clocksource-add-argument-to-resume-callback.patch
clocksource-start-cmt-at-clocksource-resume.patch
clocksource-start-cmt-at-clocksource-resume-v2.patch
clocksource-add-suspend-callback.patch
cris-convert-to-use-arch_gettimeoffset.patch
timecompare-fix-half-y2k38-problem-in-timecompare_update-while-calculating-offset.patch

