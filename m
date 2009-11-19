From: akpm@linux-foundation.org
Subject: + procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm.patch added to -mm tree
Date: Thu, 19 Nov 2009 13:24:16 -0800
Message-ID: <200911192124.nAJLOGoY029430@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38182 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756097AbZKSVZF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Nov 2009 16:25:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnstul@us.ibm.com, Sean_Foley@ca.ibm.com, andi@firstfloor.org, arjan@infradead.org, dvhltc@us.ibm.com, fultonm@ca.ibm.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     procfs: allow threads to rename siblings via /proc/pid/tasks/tid/comm
has been added to the -mm tree.  Its filename is
     procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm.patch

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

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Mike Fulton <fultonm@ca.ibm.com>
Cc: Sean Foley <Sean_Foley@ca.ibm.com>
Cc: Darren Hart <dvhltc@us.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c      |    9 +++++
 fs/proc/base.c |   74 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 83 insertions(+)

diff -puN fs/exec.c~procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm fs/exec.c
--- a/fs/exec.c~procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm
+++ a/fs/exec.c
@@ -924,6 +924,15 @@ char *get_task_comm(char *buf, struct ta
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
@@ -1265,6 +1265,78 @@ static const struct file_operations proc
 
 #endif
 
+
+
+static ssize_t
+comm_write(struct file *file, const char __user *buf,
+	    size_t count, loff_t *offset)
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
+
+static const struct file_operations proc_pid_set_comm_operations = {
+	.open		= comm_open,
+	.read		= seq_read,
+	.write		= comm_write,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+
 /*
  * We added or removed a vma mapping the executable. The vmas are only mapped
  * during exec and are not mapped with the mmap system call.
@@ -2504,6 +2576,7 @@ static const struct pid_entry tgid_base_
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",      S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
+	REG("comm",      S_IRUGO|S_IWUSR, proc_pid_set_comm_operations),
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 	INF("syscall",    S_IRUSR, proc_pid_syscall),
 #endif
@@ -2838,6 +2911,7 @@ static const struct pid_entry tid_base_s
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",     S_IRUGO|S_IWUSR, proc_pid_sched_operations),
 #endif
+	REG("comm",      S_IRUGO|S_IWUSR, proc_pid_set_comm_operations),
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
 	INF("syscall",   S_IRUSR, proc_pid_syscall),
 #endif
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

linux-next.patch
procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm.patch
procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm-cleanup.patch
cris-convert-to-use-arch_gettimeoffset.patch
timecompare-fix-half-y2k38-problem-in-timecompare_update-while-calculating-offset.patch
cs5535-add-a-generic-mfgpt-driver.patch
cs5535-add-a-generic-clock-event-mfgpt-driver.patch
cs5535-move-the-divil-msr-definition-into-linux-cs5535h.patch
cs5535-move-vsa2-checks-into-linux-cs5535h.patch
cs5535-define-lxfb-gxfb-msrs-in-linux-cs5535h.patch
cs5535-drop-the-geode-specific-mfgpt-gpio-code.patch

