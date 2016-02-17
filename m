From: akpm@linux-foundation.org
Subject: + proc-add-proc-pid-timerslack_ns-interface.patch added to -mm
 tree
Date: Wed, 17 Feb 2016 11:37:51 -0800
Message-ID: <56c4cc0f.NQjKSJiM+knhIuPB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46112 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030213AbcBQThw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Feb 2016 14:37:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: john.stultz@linaro.org, arjan@linux.intel.com, kandoiruchi@google.com, keescook@chromium.org, kernel-team@android.com, orenl@cellrox.com, romlem@android.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: add /proc/<pid>/timerslack_ns interface
has been added to the -mm tree.  Its filename is
     proc-add-proc-pid-timerslack_ns-interface.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-add-proc-pid-timerslack_ns-interface.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-add-proc-pid-timerslack_ns-interface.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: John Stultz <john.stultz@linaro.org>
Subject: proc: add /proc/<pid>/timerslack_ns interface

This patch provides a proc/PID/timerslack_ns interface which exposes a
task's timerslack value in nanoseconds and allows it to be changed.

This allows power/performance management software to set timer slack for
other threads according to its policy for the thread (such as when the
thread is designated foreground vs.  background activity)

If the value written is non-zero, slack is set to that value.  Otherwise
sets it to the default for the thread.

This interface checks that the calling task has permissions to to use
PTRACE_MODE_ATTACH_FSCREDS on the target task, so that we can ensure
arbitrary apps do not change the timer slack for other apps.

Signed-off-by: John Stultz <john.stultz@linaro.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Oren Laadan <orenl@cellrox.com>
Cc: Ruchi Kandoi <kandoiruchi@google.com>
Cc: Rom Lemarchand <romlem@android.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   18 +++++++
 fs/proc/base.c                     |   69 +++++++++++++++++++++++++++
 2 files changed, 87 insertions(+)

diff -puN Documentation/filesystems/proc.txt~proc-add-proc-pid-timerslack_ns-interface Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~proc-add-proc-pid-timerslack_ns-interface
+++ a/Documentation/filesystems/proc.txt
@@ -43,6 +43,7 @@ Table of Contents
   3.7   /proc/<pid>/task/<tid>/children - Information about task children
   3.8   /proc/<pid>/fdinfo/<fd> - Information about opened file
   3.9   /proc/<pid>/map_files - Information about memory mapped files
+  3.10  /proc/<pid>/timerslack_ns - Task timerslack value
 
   4	Configuring procfs
   4.1	Mount options
@@ -1862,6 +1863,23 @@ time one can open(2) mappings from the l
 comparing their inode numbers to figure out which anonymous memory areas
 are actually shared.
 
+3.10	/proc/<pid>/timerslack_ns - Task timerslack value
+---------------------------------------------------------
+This file provides the value of the task's timerslack value in nanoseconds.
+This value specifies a amount of time that normal timers may be deferred
+in order to coalesce timers and avoid unnecessary wakeups.
+
+This allows a task's interactivity vs power consumption trade off to be
+adjusted.
+
+Writing 0 to the file will set the tasks timerslack to the default value.
+
+Valid values are from 0 - ULLONG_MAX
+
+An application setting the value must have PTRACE_MODE_ATTACH_FSCREDS level
+permissions on the task specified to change its timerslack_ns value.
+
+
 ------------------------------------------------------------------------------
 Configuring procfs
 ------------------------------------------------------------------------------
diff -puN fs/proc/base.c~proc-add-proc-pid-timerslack_ns-interface fs/proc/base.c
--- a/fs/proc/base.c~proc-add-proc-pid-timerslack_ns-interface
+++ a/fs/proc/base.c
@@ -2257,6 +2257,74 @@ static const struct file_operations proc
 	.release	= seq_release_private,
 };
 
+static ssize_t timerslack_ns_write(struct file *file, const char __user *buf,
+					size_t count, loff_t *offset)
+{
+	struct inode *inode = file_inode(file);
+	struct task_struct *p;
+	char buffer[PROC_NUMBUF];
+	u64 slack_ns;
+	int err;
+
+	memset(buffer, 0, sizeof(buffer));
+	if (count > sizeof(buffer) - 1)
+		count = sizeof(buffer) - 1;
+
+	if (copy_from_user(buffer, buf, count))
+		return -EFAULT;
+
+	err = kstrtoull(strstrip(buffer), 10, &slack_ns);
+	if (err < 0)
+		return err;
+
+	p = get_proc_task(inode);
+	if (!p)
+		return -ESRCH;
+
+	if (ptrace_may_access(p, PTRACE_MODE_ATTACH_FSCREDS)) {
+		if (slack_ns == 0)
+			p->timer_slack_ns = p->default_timer_slack_ns;
+		else
+			p->timer_slack_ns = slack_ns;
+	} else
+		count = -EINVAL;
+
+	put_task_struct(p);
+
+	return count;
+}
+
+static int timerslack_ns_show(struct seq_file *m, void *v)
+{
+	struct inode *inode = m->private;
+	struct task_struct *p;
+
+	p = get_proc_task(inode);
+	if (!p)
+		return -ESRCH;
+
+	task_lock(p);
+	seq_printf(m, "%llu\n", p->timer_slack_ns);
+	task_unlock(p);
+
+	put_task_struct(p);
+
+	return 0;
+}
+
+static int timerslack_ns_open(struct inode *inode, struct file *filp)
+{
+	return single_open(filp, timerslack_ns_show, inode);
+}
+
+static const struct file_operations proc_pid_set_timerslack_ns_operations = {
+	.open		= timerslack_ns_open,
+	.read		= seq_read,
+	.write		= timerslack_ns_write,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static int proc_pident_instantiate(struct inode *dir,
 	struct dentry *dentry, struct task_struct *task, const void *ptr)
 {
@@ -2831,6 +2899,7 @@ static const struct pid_entry tgid_base_
 #ifdef CONFIG_CHECKPOINT_RESTORE
 	REG("timers",	  S_IRUGO, proc_timers_operations),
 #endif
+	REG("timerslack_ns", S_IRUGO|S_IWUSR, proc_pid_set_timerslack_ns_operations),
 };
 
 static int proc_tgid_base_readdir(struct file *file, struct dir_context *ctx)
_

Patches currently in -mm which might be from john.stultz@linaro.org are

timer-convert-timer_slack_ns-from-unsigned-long-to-u64.patch
proc-add-proc-pid-timerslack_ns-interface.patch

