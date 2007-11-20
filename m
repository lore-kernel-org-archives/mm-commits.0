From: akpm@linux-foundation.org
Subject: + proc-rewrite-do_task_stat-to-correctly-handle-pid-namespaces.patch added to -mm tree
Date: Mon, 19 Nov 2007 16:59:32 -0800
Message-ID: <200711200059.lAK0xWIr005542@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43619 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752923AbXKTA7h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 19:59:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, adobriyan@gmail.com, oleg@tv-sign.ru


The patch titled
     proc: rewrite do_task_stat to correctly handle pid namespaces.
has been added to the -mm tree.  Its filename is
     proc-rewrite-do_task_stat-to-correctly-handle-pid-namespaces.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -379,14 +380,14 @@ static cputime_t task_gtime(struct task_
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
@@ -398,9 +399,6 @@ static int do_task_stat(struct task_stru
 	unsigned long rsslim = 0;
 	char tcomm[sizeof(task->comm)];
 	unsigned long flags;
-	struct pid_namespace *ns;
-
-	ns = current->nsproxy->pid_ns;
 
 	state = *get_task_state(task);
 	vsize = eip = esp = 0;
@@ -487,10 +485,10 @@ static int do_task_stat(struct task_stru
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
@@ -539,17 +537,19 @@ static int do_task_stat(struct task_stru
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
@@ -2181,7 +2181,7 @@ static const struct pid_entry tgid_base_
 	REG("sched",      S_IRUGO|S_IWUSR, pid_sched),
 #endif
 	INF("cmdline",    S_IRUGO, pid_cmdline),
-	INF("stat",       S_IRUGO, tgid_stat),
+	ONE("stat",       S_IRUGO, tgid_stat),
 	INF("statm",      S_IRUGO, pid_statm),
 	REG("maps",       S_IRUGO, maps),
 #ifdef CONFIG_NUMA
@@ -2508,7 +2508,7 @@ static const struct pid_entry tid_base_s
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
@@ -44,10 +44,13 @@ extern int nommu_vma_show(struct seq_fil
 
 extern int maps_protect;
 
-extern void create_seq_entry(char *name, mode_t mode, const struct file_operations *f);
+extern void create_seq_entry(char *name, mode_t mode,
+				const struct file_operations *f);
 extern int proc_exe_link(struct inode *, struct path *);
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

proc-fix-null-i_fop-oops.patch
proc-remove-races-from-proc_id_readdir.patch
git-s390.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-memcgroup-fix-try_to_free-order.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
memcgroup-reinstate-swapoff-mod.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch
memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch
memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch
memory-cgroup-enhancements-add-memorystat-file.patch
memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
memory-cgroup-enhancements-add-memorystat-file-printk-fix.patch
memory-cgroup-enhancements-add-pre_destroy-handler.patch
memory-cgroup-enhancements-implicit-force_empty-at-rmdir.patch
introduce-flags-for-reserve_bootmem.patch
use-bootmem_exclusive-for-kdump.patch
iget-stop-procfs-from-using-iget-and-read_inode.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
add-the-namespaces-config-option.patch
move-the-uts-namespace-under-uts_ns-option.patch
move-the-ipc-namespace-under-ipc_ns-option.patch
cleanup-the-code-managed-with-the-user_ns-option.patch
cleanup-the-code-managed-with-pid_ns-option.patch
mark-net_ns-with-depends-on-namespaces.patch
proc-implement-proc_single_file_operations.patch
proc-rewrite-do_task_stat-to-correctly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_statm.patch
