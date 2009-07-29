From: akpm@linux-foundation.org
Subject: + mm-introduce-proc-pid-oom_adj_child.patch added to -mm tree
Date: Wed, 29 Jul 2009 16:13:57 -0700
Message-ID: <200907292313.n6TNDwRO002781@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42978 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755071AbZG2XOV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 19:14:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kosaki.motohiro@jp.fujitsu.com, menage@google.com, riel@redhat.com


The patch titled
     mm: introduce /proc/<pid>/oom_adj_child
has been added to the -mm tree.  Its filename is
     mm-introduce-proc-pid-oom_adj_child.patch

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
Subject: mm: introduce /proc/<pid>/oom_adj_child
From: David Rientjes <rientjes@google.com>

It's helpful to be able to specify an oom_adj value for newly forked
children that do not share memory with the parent.

Before making oom_adj values a characteristic of a task's mm in
2ff05b2b4eac2e63d345fc731ea151a060247f53 ("oom: move oom_adj value from
task_struct to mm_struct"), it was possible to change the oom_adj value of
a vfork() child prior to execve() without implicitly changing the oom_adj
value of the parent.  With the new behavior, the oom_adj values of both
threads would change since they represent the same memory.

That change was necessary to fix an oom killer livelock which would occur
when a child would be selected for oom kill prior to execve() and the task
could not be killed because it shared memory with an OOM_DISABLE parent. 
In fact, only the most negative (most immune) oom_adj value for all
threads sharing the same memory would actually be used by the oom killer,
leaving inconsistencies amongst all other threads having
/proc/pid/oom_score values).

This patch adds a new per-process parameter: /proc/pid/oom_adj_child. 
This defaults to mirror the value of /proc/pid/oom_adj but may be changed
so that mm's initialized by their children are preferred over the parent
by the oom killer.  Setting oom_adj_child to be less (i.e.  more immune)
than the task's oom_adj value itself is governed by the CAP_SYS_RESOURCE
capability.

When a mm is initialized, the initial oom_adj value will be set to the
parent's oom_adj_child.  This allows tasks to elevate the oom_adj value of
a vfork'd child prior to execve() before the execution actually takes
place.

Furthermore, /proc/pid/oom_adj_child is inherited from the task that
forked it.

Cc: Rik van Riel <riel@redhat.com>
Cc: Paul Menage <menage@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   38 +++++++++++----
 fs/proc/base.c                     |   68 +++++++++++++++++++++++++++
 include/linux/sched.h              |    1 
 kernel/fork.c                      |    3 -
 4 files changed, 101 insertions(+), 9 deletions(-)

diff -puN Documentation/filesystems/proc.txt~mm-introduce-proc-pid-oom_adj_child Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~mm-introduce-proc-pid-oom_adj_child
+++ a/Documentation/filesystems/proc.txt
@@ -34,10 +34,11 @@ Table of Contents
 
   3	Per-Process Parameters
   3.1	/proc/<pid>/oom_adj - Adjust the oom-killer score
-  3.2	/proc/<pid>/oom_score - Display current oom-killer score
-  3.3	/proc/<pid>/io - Display the IO accounting fields
-  3.4	/proc/<pid>/coredump_filter - Core dump filtering settings
-  3.5	/proc/<pid>/mountinfo - Information about mounts
+  3.2	/proc/<pid>/oom_adj_child - Change default oom_adj for children
+  3.3	/proc/<pid>/oom_score - Display current oom-killer score
+  3.4	/proc/<pid>/io - Display the IO accounting fields
+  3.5	/proc/<pid>/coredump_filter - Core dump filtering settings
+  3.6	/proc/<pid>/mountinfo - Information about mounts
 
 
 ------------------------------------------------------------------------------
@@ -1219,7 +1220,28 @@ The task with the highest badness score 
 are killed, process itself will be killed in an OOM situation when it does
 not have children or some of them disabled oom like described above.
 
-3.2 /proc/<pid>/oom_score - Display current oom-killer score
+
+3.2 /proc/<pid>/oom_adj_child - Change default oom_adj for children
+-------------------------------------------------------------------
+
+This file can be used to change the default oom_adj value for children when a
+new mm is initialized.  The oom_adj value for a child's mm is typically the
+task's oom_adj value itself, however this value can be altered by writing to
+this file.
+
+This is particularly helpful when a child is vfork'd and its mm following exec
+should have a higher priority oom_adj value than its parent.  The new mm will
+default to oom_adj_child of the parent task.
+
+oom_adj_child will mirror oom_adj whenever the latter changes for all tasks
+that share its memory.  This avoids having to set both values when simply
+tuning oom_adj and that value should be inherited by all children.
+
+Setting oom_adj_child to be more immune than the task's mm itself (i.e. less
+than oom_adj) is governed by the CAP_SYS_RESOURCE capability.
+
+
+3.3 /proc/<pid>/oom_score - Display current oom-killer score
 -------------------------------------------------------------
 
 This file can be used to check the current score used by the oom-killer is for
@@ -1227,7 +1249,7 @@ any given <pid>. Use it together with /p
 process should be killed in an out-of-memory situation.
 
 
-3.3  /proc/<pid>/io - Display the IO accounting fields
+3.4  /proc/<pid>/io - Display the IO accounting fields
 -------------------------------------------------------
 
 This file contains IO statistics for each running process
@@ -1329,7 +1351,7 @@ those 64-bit counters, process A could s
 More information about this can be found within the taskstats documentation in
 Documentation/accounting.
 
-3.4 /proc/<pid>/coredump_filter - Core dump filtering settings
+3.5 /proc/<pid>/coredump_filter - Core dump filtering settings
 ---------------------------------------------------------------
 When a process is dumped, all anonymous memory is written to a core file as
 long as the size of the core file isn't limited. But sometimes we don't want
@@ -1373,7 +1395,7 @@ For example:
   $ echo 0x7 > /proc/self/coredump_filter
   $ ./some_program
 
-3.5	/proc/<pid>/mountinfo - Information about mounts
+3.6	/proc/<pid>/mountinfo - Information about mounts
 --------------------------------------------------------
 
 This file contains lines of the form:
diff -puN fs/proc/base.c~mm-introduce-proc-pid-oom_adj_child fs/proc/base.c
--- a/fs/proc/base.c~mm-introduce-proc-pid-oom_adj_child
+++ a/fs/proc/base.c
@@ -1022,6 +1022,7 @@ static ssize_t oom_adjust_write(struct f
 				size_t count, loff_t *ppos)
 {
 	struct task_struct *task;
+	struct task_struct *g, *p;
 	char buffer[PROC_NUMBUF], *end;
 	int oom_adjust;
 
@@ -1050,6 +1051,12 @@ static ssize_t oom_adjust_write(struct f
 		put_task_struct(task);
 		return -EACCES;
 	}
+	read_lock(&tasklist_lock);
+	do_each_thread(g, p) {
+		if (p->mm && p->mm == task->mm)
+			p->oom_adj_child = oom_adjust;
+	} while_each_thread(g, p);
+	read_unlock(&tasklist_lock);
 	task->mm->oom_adj = oom_adjust;
 	task_unlock(task);
 	put_task_struct(task);
@@ -1063,6 +1070,65 @@ static const struct file_operations proc
 	.write		= oom_adjust_write,
 };
 
+static ssize_t oom_adj_child_read(struct file *file, char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
+	char buffer[PROC_NUMBUF];
+	size_t len;
+	int oom_adj_child;
+
+	if (!task)
+		return -ESRCH;
+	oom_adj_child = task->oom_adj_child;
+	put_task_struct(task);
+
+	len = snprintf(buffer, sizeof(buffer), "%i\n", oom_adj_child);
+
+	return simple_read_from_buffer(buf, count, ppos, buffer, len);
+}
+
+static ssize_t oom_adj_child_write(struct file *file, const char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	struct task_struct *task;
+	char buffer[PROC_NUMBUF], *end;
+	int oom_adj_child;
+
+	memset(buffer, 0, sizeof(buffer));
+	if (count > sizeof(buffer) - 1)
+		count = sizeof(buffer) - 1;
+	if (copy_from_user(buffer, buf, count))
+		return -EFAULT;
+	oom_adj_child = simple_strtol(buffer, &end, 0);
+	if ((oom_adj_child < OOM_ADJUST_MIN ||
+	     oom_adj_child > OOM_ADJUST_MAX) && oom_adj_child != OOM_DISABLE)
+		return -EINVAL;
+	if (*end == '\n')
+		end++;
+	task = get_proc_task(file->f_path.dentry->d_inode);
+	if (!task)
+		return -ESRCH;
+	task_lock(task);
+	if (task->mm && oom_adj_child < task->mm->oom_adj &&
+	    !capable(CAP_SYS_RESOURCE)) {
+		task_unlock(task);
+		put_task_struct(task);
+		return -EINVAL;
+	}
+	task_unlock(task);
+	task->oom_adj_child = oom_adj_child;
+	put_task_struct(task);
+	if (end - buffer == 0)
+		return -EIO;
+	return end - buffer;
+}
+
+static const struct file_operations proc_oom_adj_child_operations = {
+	.read		= oom_adj_child_read,
+	.write		= oom_adj_child_write,
+};
+
 #ifdef CONFIG_AUDITSYSCALL
 #define TMPBUFLEN 21
 static ssize_t proc_loginuid_read(struct file * file, char __user * buf,
@@ -2547,6 +2613,7 @@ static const struct pid_entry tgid_base_
 #endif
 	INF("oom_score",  S_IRUGO, proc_oom_score),
 	REG("oom_adj",    S_IRUGO|S_IWUSR, proc_oom_adjust_operations),
+	REG("oom_adj_child",	S_IRUGO|S_IWUSR, proc_oom_adj_child_operations),
 #ifdef CONFIG_AUDITSYSCALL
 	REG("loginuid",   S_IWUSR|S_IRUGO, proc_loginuid_operations),
 	REG("sessionid",  S_IRUGO, proc_sessionid_operations),
@@ -2885,6 +2952,7 @@ static const struct pid_entry tid_base_s
 #endif
 	INF("oom_score", S_IRUGO, proc_oom_score),
 	REG("oom_adj",   S_IRUGO|S_IWUSR, proc_oom_adjust_operations),
+	REG("oom_adj_child",	S_IRUGO|S_IWUSR, proc_oom_adj_child_operations),
 #ifdef CONFIG_AUDITSYSCALL
 	REG("loginuid",  S_IWUSR|S_IRUGO, proc_loginuid_operations),
 	REG("sessionid",  S_IRUSR, proc_sessionid_operations),
diff -puN include/linux/sched.h~mm-introduce-proc-pid-oom_adj_child include/linux/sched.h
--- a/include/linux/sched.h~mm-introduce-proc-pid-oom_adj_child
+++ a/include/linux/sched.h
@@ -1211,6 +1211,7 @@ struct task_struct {
 	 * a short time
 	 */
 	unsigned char fpu_counter;
+	s8 oom_adj_child;	/* Default child OOM-kill score adjustment */
 #ifdef CONFIG_BLK_DEV_IO_TRACE
 	unsigned int btrace_seq;
 #endif
diff -puN kernel/fork.c~mm-introduce-proc-pid-oom_adj_child kernel/fork.c
--- a/kernel/fork.c~mm-introduce-proc-pid-oom_adj_child
+++ a/kernel/fork.c
@@ -442,7 +442,7 @@ static struct mm_struct * mm_init(struct
 	INIT_LIST_HEAD(&mm->mmlist);
 	mm->flags = (current->mm) ?
 		(current->mm->flags & MMF_INIT_MASK) : default_dump_filter;
-	mm->oom_adj = (current->mm) ? current->mm->oom_adj : 0;
+	mm->oom_adj = p->oom_adj_child;
 	mm->core_state = NULL;
 	mm->nr_ptes = 0;
 	set_mm_counter(mm, file_rss, 0);
@@ -696,6 +696,7 @@ good_mm:
 
 	tsk->mm = mm;
 	tsk->active_mm = mm;
+	tsk->oom_adj_child = mm->oom_adj;
 	return 0;
 
 fail_nomem:
_

Patches currently in -mm which might be from rientjes@google.com are

mm-avoid-endless-looping-for-oom-killed-tasks.patch
mm-copy-over-oom_adj-value-at-fork-time.patch
page-allocator-allow-too-high-order-warning-messages-to-be-suppressed-with-__gfp_nowarn.patch
linux-next.patch
mm-remove-obsoleted-alloc_pages-cpuset-comment.patch
hugetlb-balance-freeing-of-huge-pages-across-nodes.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages-fix.patch
hugetlb-clean-up-and-update-huge-pages-documentation.patch
mm-oom-analysis-add-per-zone-statistics-to-show_free_areas.patch
mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
mm-oom-analysis-show-kernel-stack-usage-in-proc-meminfo-and-oom-log-output.patch
mm-oom-analysis-add-shmem-vmstat.patch
mm-update-alloc_flags-after-oom-killer-has-been-called.patch
pagemap-clear_refs-modify-to-specify-anon-or-mapped-vma-clearing.patch
mm-make-set_mempolicympol_interleav-n_high_memory-aware.patch
mm-make-set_mempolicympol_interleav-n_high_memory-aware-fix.patch
mm-introduce-proc-pid-oom_adj_child.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch

