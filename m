From: akpm@linux-foundation.org
Subject: - proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch removed from -mm tree
Date: Mon, 19 Nov 2007 22:59:20 -0800
Message-ID: <200711200659.lAK6xKkB019082@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45604 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751892AbXKTG7l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Nov 2007 01:59:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, adobriyan@gmail.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     proc: seqfile convert proc_pid_status to properly handle pid namespaces
has been removed from the -mm tree.  Its filename was
     proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: proc: seqfile convert proc_pid_status to properly handle pid namespaces
From: Eric W. Biederman <ebiederm@xmission.com>

Currently we possibly lookup the pid in the wrong pid namespace.  So seq_file
convert proc_pid_status which ensures the proper pid namespaces is passed in,
and ensures that we don't overflow any internal buffers when generating
/proc/<pid>/status

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/traps.c     |   23 ++++++-------
 fs/proc/array.c              |   58 +++++++++++++++------------------
 fs/proc/base.c               |    4 +-
 fs/proc/internal.h           |    3 +
 fs/proc/task_mmu.c           |    5 +-
 fs/proc/task_nommu.c         |    2 -
 include/asm-s390/processor.h |    2 -
 include/linux/cpuset.h       |    8 ++--
 include/linux/proc_fs.h      |    2 -
 kernel/cpuset.c              |   18 +++++-----
 10 files changed, 62 insertions(+), 63 deletions(-)

diff -puN arch/s390/kernel/traps.c~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces arch/s390/kernel/traps.c
--- a/arch/s390/kernel/traps.c~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces
+++ a/arch/s390/kernel/traps.c
@@ -218,41 +218,40 @@ void show_registers(struct pt_regs *regs
 }	
 
 /* This is called from fs/proc/array.c */
-char *task_show_regs(struct task_struct *task, char *buffer)
+void task_show_regs(struct seq_file *m, struct task_struct *task)
 {
 	struct pt_regs *regs;
 
 	regs = task_pt_regs(task);
-	buffer += sprintf(buffer, "task: %p, ksp: %p\n",
+	seq_printf(m, "task: %p, ksp: %p\n",
 		       task, (void *)task->thread.ksp);
-	buffer += sprintf(buffer, "User PSW : %p %p\n",
+	seq_printf(m, "User PSW : %p %p\n",
 		       (void *) regs->psw.mask, (void *)regs->psw.addr);
 
-	buffer += sprintf(buffer, "User GPRS: " FOURLONG,
+	seq_printf(m, "User GPRS: " FOURLONG,
 			  regs->gprs[0], regs->gprs[1],
 			  regs->gprs[2], regs->gprs[3]);
-	buffer += sprintf(buffer, "           " FOURLONG,
+	seq_printf(m, "           " FOURLONG,
 			  regs->gprs[4], regs->gprs[5],
 			  regs->gprs[6], regs->gprs[7]);
-	buffer += sprintf(buffer, "           " FOURLONG,
+	seq_printf(m, "           " FOURLONG,
 			  regs->gprs[8], regs->gprs[9],
 			  regs->gprs[10], regs->gprs[11]);
-	buffer += sprintf(buffer, "           " FOURLONG,
+	seq_printf(m, "           " FOURLONG,
 			  regs->gprs[12], regs->gprs[13],
 			  regs->gprs[14], regs->gprs[15]);
-	buffer += sprintf(buffer, "User ACRS: %08x %08x %08x %08x\n",
+	seq_printf(m, "User ACRS: %08x %08x %08x %08x\n",
 			  task->thread.acrs[0], task->thread.acrs[1],
 			  task->thread.acrs[2], task->thread.acrs[3]);
-	buffer += sprintf(buffer, "           %08x %08x %08x %08x\n",
+	seq_printf(m, "           %08x %08x %08x %08x\n",
 			  task->thread.acrs[4], task->thread.acrs[5],
 			  task->thread.acrs[6], task->thread.acrs[7]);
-	buffer += sprintf(buffer, "           %08x %08x %08x %08x\n",
+	seq_printf(m, "           %08x %08x %08x %08x\n",
 			  task->thread.acrs[8], task->thread.acrs[9],
 			  task->thread.acrs[10], task->thread.acrs[11]);
-	buffer += sprintf(buffer, "           %08x %08x %08x %08x\n",
+	seq_printf(m, "           %08x %08x %08x %08x\n",
 			  task->thread.acrs[12], task->thread.acrs[13],
 			  task->thread.acrs[14], task->thread.acrs[15]);
-	return buffer;
 }
 
 static DEFINE_SPINLOCK(die_lock);
diff -puN fs/proc/array.c~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces fs/proc/array.c
--- a/fs/proc/array.c~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces
+++ a/fs/proc/array.c
@@ -89,18 +89,21 @@
 do { memcpy(buffer, string, strlen(string)); \
      buffer += strlen(string); } while (0)
 
-static inline char *task_name(struct task_struct *p, char *buf)
+static inline void task_name(struct seq_file *m, struct task_struct *p)
 {
 	int i;
+	char *buf, *end;
 	char *name;
 	char tcomm[sizeof(p->comm)];
 
 	get_task_comm(tcomm, p);
 
-	ADDBUF(buf, "Name:\t");
+	end = m->buf + m->size;
+	buf = m->buf + m->count;
+	seq_printf(m, "Name:\n");
 	name = tcomm;
 	i = sizeof(tcomm);
-	do {
+	while (i && (buf < end)) {
 		unsigned char c = *name;
 		name++;
 		i--;
@@ -108,20 +111,21 @@ static inline char *task_name(struct tas
 		if (!c)
 			break;
 		if (c == '\\') {
-			buf[1] = c;
-			buf += 2;
+			buf++;
+			if (buf < end)
+				*buf++ = c;
 			continue;
 		}
 		if (c == '\n') {
-			buf[0] = '\\';
-			buf[1] = 'n';
-			buf += 2;
+			*buf++ = '\\';
+			if (buf < end)
+				*buf++ = 'n';
 			continue;
 		}
 		buf++;
-	} while (i);
-	*buf = '\n';
-	return buf+1;
+	}
+	m->count = buf - m->buf;
+	seq_printf(m, "\n");
 }
 
 /*
@@ -152,21 +156,20 @@ static inline const char *get_task_state
 	return *p;
 }
 
-static inline char *task_state(struct task_struct *p, char *buffer)
+static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
+				struct pid *pid, struct task_struct *p)
 {
 	struct group_info *group_info;
 	int g;
 	struct fdtable *fdt = NULL;
-	struct pid_namespace *ns;
 	pid_t ppid, tpid;
 
-	ns = current->nsproxy->pid_ns;
 	rcu_read_lock();
 	ppid = pid_alive(p) ?
 		task_tgid_nr_ns(rcu_dereference(p->real_parent), ns) : 0;
 	tpid = pid_alive(p) && p->ptrace ?
 		task_ppid_nr_ns(rcu_dereference(p->parent), ns) : 0;
-	buffer += sprintf(buffer,
+	seq_printf(m,
 		"State:\t%s\n"
 		"Tgid:\t%d\n"
 		"Pid:\t%d\n"
@@ -176,7 +179,7 @@ static inline char *task_state(struct ta
 		"Gid:\t%d\t%d\t%d\t%d\n",
 		get_task_state(p),
 		task_tgid_nr_ns(p, ns),
-		task_pid_nr_ns(p, ns),
+		pid_nr_ns(pid, ns),
 		ppid, tpid,
 		p->uid, p->euid, p->suid, p->fsuid,
 		p->gid, p->egid, p->sgid, p->fsgid);
@@ -184,7 +187,7 @@ static inline char *task_state(struct ta
 	task_lock(p);
 	if (p->files)
 		fdt = files_fdtable(p->files);
-	buffer += sprintf(buffer,
+	seq_printf(m,
 		"FDSize:\t%d\n"
 		"Groups:\t",
 		fdt ? fdt->max_fds : 0);
@@ -195,20 +198,17 @@ static inline char *task_state(struct ta
 	task_unlock(p);
 
 	for (g = 0; g < min(group_info->ngroups, NGROUPS_SMALL); g++)
-		buffer += sprintf(buffer, "%d ", GROUP_AT(group_info, g));
+		seq_printf(m, "%d ", GROUP_AT(group_info, g));
 	put_group_info(group_info);
 
-	buffer += sprintf(buffer, "\n");
-	return buffer;
+	seq_printf(m, "\n");
 }
 
-static char *render_sigset_t(const char *header, sigset_t *set, char *buffer)
+static void render_sigset_t(struct seq_file *m, const char *header, sigset_t *set)
 {
-	int i, len;
+	int i;
 
-	len = strlen(header);
-	memcpy(buffer, header, len);
-	buffer += len;
+	seq_printf(m, "%s", header);
 
 	i = _NSIG;
 	do {
@@ -219,12 +219,10 @@ static char *render_sigset_t(const char 
 		if (sigismember(set, i+2)) x |= 2;
 		if (sigismember(set, i+3)) x |= 4;
 		if (sigismember(set, i+4)) x |= 8;
-		*buffer++ = (x < 10 ? '0' : 'a' - 10) + x;
+		seq_printf(m, "%x", x);
 	} while (i >= 4);
 
-	*buffer++ = '\n';
-	*buffer = 0;
-	return buffer;
+	seq_printf(m, "\n");
 }
 
 static void collect_sigign_sigcatch(struct task_struct *p, sigset_t *ign,
@@ -242,7 +240,7 @@ static void collect_sigign_sigcatch(stru
 	}
 }
 
-static inline char *task_sig(struct task_struct *p, char *buffer)
+static inline void task_sig(struct seq_file *m, struct task_struct *p)
 {
 	unsigned long flags;
 	sigset_t pending, shpending, blocked, ignored, caught;
diff -puN fs/proc/base.c~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces fs/proc/base.c
--- a/fs/proc/base.c~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces
+++ a/fs/proc/base.c
@@ -2175,7 +2175,7 @@ static const struct pid_entry tgid_base_
 	DIR("fdinfo",     S_IRUSR|S_IXUSR, fdinfo),
 	REG("environ",    S_IRUSR, environ),
 	INF("auxv",       S_IRUSR, pid_auxv),
-	INF("status",     S_IRUGO, pid_status),
+	ONE("status",     S_IRUGO, pid_status),
 	INF("limits",	  S_IRUSR, pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",      S_IRUGO|S_IWUSR, pid_sched),
@@ -2502,7 +2502,7 @@ static const struct pid_entry tid_base_s
 	DIR("fdinfo",    S_IRUSR|S_IXUSR, fdinfo),
 	REG("environ",   S_IRUSR, environ),
 	INF("auxv",      S_IRUSR, pid_auxv),
-	INF("status",    S_IRUGO, pid_status),
+	ONE("status",    S_IRUGO, pid_status),
 	INF("limits",	 S_IRUSR, pid_limits),
 #ifdef CONFIG_SCHED_DEBUG
 	REG("sched",     S_IRUGO|S_IWUSR, pid_sched),
diff -puN fs/proc/internal.h~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces fs/proc/internal.h
--- a/fs/proc/internal.h~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces
+++ a/fs/proc/internal.h
@@ -51,7 +51,8 @@ extern int proc_tid_stat(struct seq_file
 				struct pid *pid, struct task_struct *task);
 extern int proc_tgid_stat(struct seq_file *m, struct pid_namespace *ns,
 				struct pid *pid, struct task_struct *task);
-extern int proc_pid_status(struct task_struct *, char *);
+extern int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
+				struct pid *pid, struct task_struct *task);
 extern int proc_pid_statm(struct task_struct *, char *);
 extern loff_t mem_lseek(struct file *file, loff_t offset, int orig);
 
diff -puN fs/proc/task_mmu.c~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces
+++ a/fs/proc/task_mmu.c
@@ -15,7 +15,7 @@
 #include <asm/tlbflush.h>
 #include "internal.h"
 
-char *task_mem(struct mm_struct *mm, char *buffer)
+void task_mem(struct seq_file *m, struct mm_struct *mm)
 {
 	unsigned long data, text, lib;
 	unsigned long hiwater_vm, total_vm, hiwater_rss, total_rss;
@@ -37,7 +37,7 @@ char *task_mem(struct mm_struct *mm, cha
 	data = mm->total_vm - mm->shared_vm - mm->stack_vm;
 	text = (PAGE_ALIGN(mm->end_code) - (mm->start_code & PAGE_MASK)) >> 10;
 	lib = (mm->exec_vm << (PAGE_SHIFT-10)) - text;
-	buffer += sprintf(buffer,
+	seq_printf(m,
 		"VmPeak:\t%8lu kB\n"
 		"VmSize:\t%8lu kB\n"
 		"VmLck:\t%8lu kB\n"
@@ -56,7 +56,6 @@ char *task_mem(struct mm_struct *mm, cha
 		data << (PAGE_SHIFT-10),
 		mm->stack_vm << (PAGE_SHIFT-10), text, lib,
 		(PTRS_PER_PTE*sizeof(pte_t)*mm->nr_ptes) >> 10);
-	return buffer;
 }
 
 unsigned long task_vsize(struct mm_struct *mm)
diff -puN fs/proc/task_nommu.c~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces fs/proc/task_nommu.c
--- a/fs/proc/task_nommu.c~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces
+++ a/fs/proc/task_nommu.c
@@ -12,7 +12,7 @@
  * each process that owns it. Non-shared memory is counted
  * accurately.
  */
-char *task_mem(struct mm_struct *mm, char *buffer)
+void task_mem(struct seq_file *m, struct mm_struct *mm)
 {
 	struct vm_list_struct *vml;
 	unsigned long bytes = 0, sbytes = 0, slack = 0;
diff -puN include/asm-s390/processor.h~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces include/asm-s390/processor.h
--- a/include/asm-s390/processor.h~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces
+++ a/include/asm-s390/processor.h
@@ -188,7 +188,7 @@ extern unsigned long thread_saved_pc(str
 /*
  * Print register of task into buffer. Used in fs/proc/array.c.
  */
-extern char *task_show_regs(struct task_struct *task, char *buffer);
+extern void task_show_regs(struct seq_file *m, struct task_struct *task);
 
 extern void show_registers(struct pt_regs *regs);
 extern void show_code(struct pt_regs *regs);
diff -puN include/linux/cpuset.h~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces include/linux/cpuset.h
--- a/include/linux/cpuset.h~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces
+++ a/include/linux/cpuset.h
@@ -57,7 +57,8 @@ extern int cpuset_memory_pressure_enable
 extern void __cpuset_memory_pressure_bump(void);
 
 extern const struct file_operations proc_cpuset_operations;
-extern char *cpuset_task_status_allowed(struct task_struct *task, char *buffer);
+struct seq_file;
+extern void cpuset_task_status_allowed(struct seq_file *m, struct task_struct *task);
 
 extern void cpuset_lock(void);
 extern void cpuset_unlock(void);
@@ -126,10 +127,9 @@ static inline int cpuset_mems_allowed_in
 
 static inline void cpuset_memory_pressure_bump(void) {}
 
-static inline char *cpuset_task_status_allowed(struct task_struct *task,
-							char *buffer)
+static inline void cpuset_task_status_allowed(struct seq_file *m,
+						struct task_struct *task)
 {
-	return buffer;
 }
 
 static inline void cpuset_lock(void) {}
diff -puN include/linux/proc_fs.h~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces
+++ a/include/linux/proc_fs.h
@@ -115,7 +115,7 @@ struct dentry *proc_pid_lookup(struct in
 int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir);
 unsigned long task_vsize(struct mm_struct *);
 int task_statm(struct mm_struct *, int *, int *, int *, int *);
-char *task_mem(struct mm_struct *, char *);
+void task_mem(struct seq_file *, struct mm_struct *);
 
 struct proc_dir_entry *de_get(struct proc_dir_entry *de);
 void de_put(struct proc_dir_entry *de);
diff -puN kernel/cpuset.c~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces kernel/cpuset.c
--- a/kernel/cpuset.c~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces
+++ a/kernel/cpuset.c
@@ -2219,13 +2219,15 @@ const struct file_operations proc_cpuset
 #endif /* CONFIG_PROC_PID_CPUSET */
 
 /* Display task cpus_allowed, mems_allowed in /proc/<pid>/status file. */
-char *cpuset_task_status_allowed(struct task_struct *task, char *buffer)
+void cpuset_task_status_allowed(struct seq_file *m, struct task_struct *task)
 {
-	buffer += sprintf(buffer, "Cpus_allowed:\t");
-	buffer += cpumask_scnprintf(buffer, PAGE_SIZE, task->cpus_allowed);
-	buffer += sprintf(buffer, "\n");
-	buffer += sprintf(buffer, "Mems_allowed:\t");
-	buffer += nodemask_scnprintf(buffer, PAGE_SIZE, task->mems_allowed);
-	buffer += sprintf(buffer, "\n");
-	return buffer;
+	int len;
+	seq_printf(m, "Cpus_allowed:\t");
+	m->count += cpumask_scnprintf(m->buf + m->count, m->size - m->count,
+					task->cpus_allowed);
+	seq_printf(m, "\n");
+	seq_printf(m, "Mems_allowed:\t");
+	m->count += nodemask_scnprintf(m->buf + m->count, m->size - m->count,
+					task->mems_allowed);
+	seq_printf(buffer, "\n");
 }
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
proc-proper-pidns-handling-for-proc-self.patch
