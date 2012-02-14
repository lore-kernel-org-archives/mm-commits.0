From: akpm@linux-foundation.org
Subject: + fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch added to -mm tree
Date: Tue, 14 Feb 2012 15:15:36 -0800
Message-ID: <20120214231538.64738A023F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:37357 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932616Ab2BNXPj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Feb 2012 18:15:39 -0500
Received: by ghrr17 with SMTP id r17so69008ghr.1
        for <mm-commits@vger.kernel.org>; Tue, 14 Feb 2012 15:15:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, keescook@chromium.org, oleg@redhat.com, serge.hallyn@canonical.com, xemul@parallels.com


The patch titled
     Subject: fs, proc: introduce /proc/<pid>/task/<tid>/children entry
has been added to the -mm tree.  Its filename is
     fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: fs, proc: introduce /proc/<pid>/task/<tid>/children entry

When we do checkpoint of a task we need to know the list of children the
task, has but there is no easy and fast way to generate reverse
parent->children chain from arbitrary <pid> (while a parent pid is
provided in "PPid" field of /proc/<pid>/status).

So instead of walking over all pids in the system (creating one big
process tree in memory, just to figure out which children a task has) --
we add explicit /proc/<pid>/task/<tid>/children entry, because the kernel
already has this kind of information but it is not yet exported.

This is a first level children, not the whole process tree.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   18 +++
 fs/proc/array.c                    |  123 +++++++++++++++++++++++++++
 fs/proc/base.c                     |    3 
 fs/proc/internal.h                 |    1 
 4 files changed, 145 insertions(+)

diff -puN Documentation/filesystems/proc.txt~fs-proc-introduce-proc-pid-task-tid-children-entry-v9 Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~fs-proc-introduce-proc-pid-task-tid-children-entry-v9
+++ a/Documentation/filesystems/proc.txt
@@ -40,6 +40,7 @@ Table of Contents
   3.4	/proc/<pid>/coredump_filter - Core dump filtering settings
   3.5	/proc/<pid>/mountinfo - Information about mounts
   3.6	/proc/<pid>/comm  & /proc/<pid>/task/<tid>/comm
+  3.7   /proc/<pid>/task/<tid>/children - Information about task children
 
   4	Configuring procfs
   4.1	Mount options
@@ -1549,6 +1550,23 @@ then the kernel's TASK_COMM_LEN (current
 comm value.
 
 
+3.7	/proc/<pid>/task/<tid>/children - Information about task children
+-------------------------------------------------------------------------
+This file provides a fast way to retrieve first level children pids
+of a task pointed by <pid>/<tid> pair. The format is a space separated
+stream of pids.
+
+Note the "first level" here -- if a child has own children they will
+not be listed here, one needs to read /proc/<children-pid>/task/<tid>/children
+to obtain the descendants.
+
+Since this interface is intended to be fast and cheap it doesn't
+guarantee to provide precise results and some children might be
+skipped, especially if they've exited right after we printed their
+pids, so one need to either stop or freeze processes being inspected
+if precise results are needed.
+
+
 ------------------------------------------------------------------------------
 Configuring procfs
 ------------------------------------------------------------------------------
diff -puN fs/proc/array.c~fs-proc-introduce-proc-pid-task-tid-children-entry-v9 fs/proc/array.c
--- a/fs/proc/array.c~fs-proc-introduce-proc-pid-task-tid-children-entry-v9
+++ a/fs/proc/array.c
@@ -556,3 +556,126 @@ int proc_pid_statm(struct seq_file *m, s
 
 	return 0;
 }
+
+#ifdef CONFIG_CHECKPOINT_RESTORE
+static struct pid *
+get_children_pid(struct inode *inode, struct pid *pid_prev, loff_t pos)
+{
+	struct task_struct *start, *task;
+	struct pid *pid = NULL;
+
+	read_lock(&tasklist_lock);
+
+	start = pid_task(proc_pid(inode), PIDTYPE_PID);
+	if (!start)
+		goto out;
+
+	/*
+	 * Lets try to continue searching first, this gives
+	 * us significant speedup on children-rich processes.
+	 */
+	if (pid_prev) {
+		task = pid_task(pid_prev, PIDTYPE_PID);
+		if (task && task->real_parent == start &&
+		    !(list_empty(&task->sibling))) {
+			if (list_is_last(&task->sibling, &start->children))
+				goto out;
+			task = list_first_entry(&task->sibling,
+						struct task_struct, sibling);
+			pid = get_pid(task_pid(task));
+			goto out;
+		}
+	}
+
+	/*
+	 * Slow search case.
+	 *
+	 * We might miss some children here if children
+	 * are exited while we were not holding the lock,
+	 * but it was never promised to be accurate that
+	 * much.
+	 *
+	 * "Just suppose that the parent sleeps, but N children
+	 *  exit after we printed their tids. Now the slow paths
+	 *  skips N extra children, we miss N tasks." (c)
+	 *
+	 * So one need to stop or freeze the leader and all
+	 * its children to get a precise result.
+	 */
+	list_for_each_entry(task, &start->children, sibling) {
+		if (pos-- == 0) {
+			pid = get_pid(task_pid(task));
+			break;
+		}
+	}
+
+out:
+	read_unlock(&tasklist_lock);
+	return pid;
+}
+
+static int children_seq_show(struct seq_file *seq, void *v)
+{
+	struct inode *inode = seq->private;
+	pid_t pid;
+
+	pid = pid_nr_ns(v, inode->i_sb->s_fs_info);
+	return seq_printf(seq, "%d ", pid);
+}
+
+static void *children_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	return get_children_pid(seq->private, NULL, *pos);
+}
+
+static void *children_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct pid *pid;
+
+	pid = get_children_pid(seq->private, v, *pos + 1);
+	put_pid(v);
+
+	++*pos;
+	return pid;
+}
+
+static void children_seq_stop(struct seq_file *seq, void *v)
+{
+	put_pid(v);
+}
+
+static const struct seq_operations children_seq_ops = {
+	.start	= children_seq_start,
+	.next	= children_seq_next,
+	.stop	= children_seq_stop,
+	.show	= children_seq_show,
+};
+
+static int children_seq_open(struct inode *inode, struct file *file)
+{
+	struct seq_file *m;
+	int ret;
+
+	ret = seq_open(file, &children_seq_ops);
+	if (ret)
+		return ret;
+
+	m = file->private_data;
+	m->private = inode;
+
+	return ret;
+}
+
+int children_seq_release(struct inode *inode, struct file *file)
+{
+	seq_release(inode, file);
+	return 0;
+}
+
+const struct file_operations proc_tid_children_operations = {
+	.open    = children_seq_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = children_seq_release,
+};
+#endif /* CONFIG_CHECKPOINT_RESTORE */
diff -puN fs/proc/base.c~fs-proc-introduce-proc-pid-task-tid-children-entry-v9 fs/proc/base.c
--- a/fs/proc/base.c~fs-proc-introduce-proc-pid-task-tid-children-entry-v9
+++ a/fs/proc/base.c
@@ -3365,6 +3365,9 @@ static const struct pid_entry tid_base_s
 	ONE("stat",      S_IRUGO, proc_tid_stat),
 	ONE("statm",     S_IRUGO, proc_pid_statm),
 	REG("maps",      S_IRUGO, proc_maps_operations),
+#ifdef CONFIG_CHECKPOINT_RESTORE
+	REG("children",  S_IRUGO, proc_tid_children_operations),
+#endif
 #ifdef CONFIG_NUMA
 	REG("numa_maps", S_IRUGO, proc_numa_maps_operations),
 #endif
diff -puN fs/proc/internal.h~fs-proc-introduce-proc-pid-task-tid-children-entry-v9 fs/proc/internal.h
--- a/fs/proc/internal.h~fs-proc-introduce-proc-pid-task-tid-children-entry-v9
+++ a/fs/proc/internal.h
@@ -56,6 +56,7 @@ extern int proc_pid_statm(struct seq_fil
 				struct pid *pid, struct task_struct *task);
 extern loff_t mem_lseek(struct file *file, loff_t offset, int orig);
 
+extern const struct file_operations proc_tid_children_operations;
 extern const struct file_operations proc_maps_operations;
 extern const struct file_operations proc_numa_maps_operations;
 extern const struct file_operations proc_smaps_operations;
_
Subject: Subject: fs, proc: introduce /proc/<pid>/task/<tid>/children entry

Patches currently in -mm which might be from gorcunov@openvz.org are

linux-next.patch
sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch
c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch

