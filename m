From: akpm@linux-foundation.org
Subject: + proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch added to -mm tree
Date: Thu, 29 Nov 2007 16:36:10 -0800
Message-ID: <200711300036.lAU0aAaq015304@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37664 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760951AbXK3Agv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 19:36:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, clg@fr.ibm.com, heiko.carstens@de.ibm.com, menage@google.com, morgan@kernel.org, pj@sgi.com, rientjes@google.com, schwidefsky@de.ibm.com, serue@us.ibm.com, xemul@openvz.org


The patch titled
     proc: seqfile convert proc_pid_status to properly handle pid namespaces
has been added to the -mm tree.  Its filename is
     proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: proc: seqfile convert proc_pid_status to properly handle pid namespaces
From: Eric W. Biederman <ebiederm@xmission.com>

Currently we possibly lookup the pid in the wrong pid namespace.  So
seq_file convert proc_pid_status which ensures the proper pid namespaces is
passed in.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Andrew Morgan <morgan@kernel.org>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/traps.c     |   23 ++----
 fs/proc/array.c              |  126 +++++++++++++++------------------
 fs/proc/base.c               |    4 -
 fs/proc/internal.h           |    3 
 fs/proc/task_mmu.c           |    6 -
 fs/proc/task_nommu.c         |    2 
 include/asm-s390/processor.h |    2 
 include/linux/cpuset.h       |    8 +-
 include/linux/proc_fs.h      |    3 
 kernel/cpuset.c              |   18 ++--
 10 files changed, 97 insertions(+), 98 deletions(-)

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
@@ -269,67 +267,65 @@ static inline char *task_sig(struct task
 	}
 	rcu_read_unlock();
 
-	buffer += sprintf(buffer, "Threads:\t%d\n", num_threads);
-	buffer += sprintf(buffer, "SigQ:\t%lu/%lu\n", qsize, qlim);
+	seq_printf(m, "Threads:\t%d\n", num_threads);
+	seq_printf(m, "SigQ:\t%lu/%lu\n", qsize, qlim);
 
 	/* render them all */
-	buffer = render_sigset_t("SigPnd:\t", &pending, buffer);
-	buffer = render_sigset_t("ShdPnd:\t", &shpending, buffer);
-	buffer = render_sigset_t("SigBlk:\t", &blocked, buffer);
-	buffer = render_sigset_t("SigIgn:\t", &ignored, buffer);
-	buffer = render_sigset_t("SigCgt:\t", &caught, buffer);
-
-	return buffer;
+	render_sigset_t(m, "SigPnd:\t", &pending);
+	render_sigset_t(m, "ShdPnd:\t", &shpending);
+	render_sigset_t(m, "SigBlk:\t", &blocked);
+	render_sigset_t(m, "SigIgn:\t", &ignored);
+	render_sigset_t(m, "SigCgt:\t", &caught);
 }
 
-static char *render_cap_t(const char *header, kernel_cap_t *a, char *buffer)
+static void render_cap_t(struct seq_file *m, const char *header, kernel_cap_t *a)
 {
 	unsigned __capi;
 
-	buffer += sprintf(buffer, "%s", header);
+	seq_printf(m, "%s", header);
 	CAP_FOR_EACH_U32(__capi) {
-		buffer += sprintf(buffer, "%08x",
-				  a->cap[(_LINUX_CAPABILITY_U32S-1) - __capi]);
+		seq_printf(m, "%08x",
+			   a->cap[(_LINUX_CAPABILITY_U32S-1) - __capi]);
 	}
-	return buffer + sprintf(buffer, "\n");
+	seq_printf(m, "\n");
 }
 
-static inline char *task_cap(struct task_struct *p, char *buffer)
+static inline void task_cap(struct seq_file *m, struct task_struct *p)
 {
-	buffer = render_cap_t("CapInh:\t", &p->cap_inheritable, buffer);
-	buffer = render_cap_t("CapPrm:\t", &p->cap_permitted, buffer);
-	return render_cap_t("CapEff:\t", &p->cap_effective, buffer);
+	render_cap_t(m, "CapInh:\t", &p->cap_inheritable);
+	render_cap_t(m, "CapPrm:\t", &p->cap_permitted);
+	render_cap_t(m, "CapEff:\t", &p->cap_effective);
 }
 
-static inline char *task_context_switch_counts(struct task_struct *p,
-						char *buffer)
+static inline void task_context_switch_counts(struct seq_file *m,
+						struct task_struct *p)
 {
-	return buffer + sprintf(buffer, "voluntary_ctxt_switches:\t%lu\n"
-			    "nonvoluntary_ctxt_switches:\t%lu\n",
-			    p->nvcsw,
-			    p->nivcsw);
+	seq_printf(m,	"voluntary_ctxt_switches:\t%lu\n"
+			"nonvoluntary_ctxt_switches:\t%lu\n",
+			p->nvcsw,
+			p->nivcsw);
 }
 
-int proc_pid_status(struct task_struct *task, char *buffer)
+int proc_pid_status(struct seq_file *m, struct pid_namespace *ns, struct pid *pid,
+			struct task_struct *task)
 {
-	char *orig = buffer;
 	struct mm_struct *mm = get_task_mm(task);
 
-	buffer = task_name(task, buffer);
-	buffer = task_state(task, buffer);
+	task_name(m, task);
+	task_state(m, ns, pid, task);
 
 	if (mm) {
-		buffer = task_mem(mm, buffer);
+		task_mem(m, mm);
 		mmput(mm);
 	}
-	buffer = task_sig(task, buffer);
-	buffer = task_cap(task, buffer);
-	buffer = cpuset_task_status_allowed(task, buffer);
+	task_sig(m, task);
+	task_cap(m, task);
+	cpuset_task_status_allowed(m, task);
 #if defined(CONFIG_S390)
-	buffer = task_show_regs(task, buffer);
+	task_show_regs(m, task);
 #endif
-	buffer = task_context_switch_counts(task, buffer);
-	return buffer - orig;
+	task_context_switch_counts(m, task);
+	return 0;
 }
 
 /*
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
@@ -2503,7 +2503,7 @@ static const struct pid_entry tid_base_s
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
 extern int proc_pid_statm(struct seq_file *m, struct pid_namespace *ns,
 				struct pid *pid, struct task_struct *task);
 extern loff_t mem_lseek(struct file *file, loff_t offset, int orig);
diff -puN fs/proc/task_mmu.c~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces
+++ a/fs/proc/task_mmu.c
@@ -9,13 +9,14 @@
 #include <linux/mempolicy.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
+#include <linux/seq_file.h>
 
 #include <asm/elf.h>
 #include <asm/uaccess.h>
 #include <asm/tlbflush.h>
 #include "internal.h"
 
-char *task_mem(struct mm_struct *mm, char *buffer)
+void task_mem(struct seq_file *m, struct mm_struct *mm)
 {
 	unsigned long data, text, lib;
 	unsigned long hiwater_vm, total_vm, hiwater_rss, total_rss;
@@ -37,7 +38,7 @@ char *task_mem(struct mm_struct *mm, cha
 	data = mm->total_vm - mm->shared_vm - mm->stack_vm;
 	text = (PAGE_ALIGN(mm->end_code) - (mm->start_code & PAGE_MASK)) >> 10;
 	lib = (mm->exec_vm << (PAGE_SHIFT-10)) - text;
-	buffer += sprintf(buffer,
+	seq_printf(m,
 		"VmPeak:\t%8lu kB\n"
 		"VmSize:\t%8lu kB\n"
 		"VmLck:\t%8lu kB\n"
@@ -56,7 +57,6 @@ char *task_mem(struct mm_struct *mm, cha
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
@@ -181,7 +181,7 @@ extern unsigned long thread_saved_pc(str
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
@@ -119,7 +119,8 @@ struct dentry *proc_pid_lookup(struct in
 int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir);
 unsigned long task_vsize(struct mm_struct *);
 int task_statm(struct mm_struct *, int *, int *, int *, int *);
-char *task_mem(struct mm_struct *, char *);
+void task_mem(struct seq_file *, struct mm_struct *);
+void clear_refs_smap(struct mm_struct *mm);
 
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

origin.patch
proc-fix-null-i_fop-oops.patch
proc-remove-races-from-proc_id_readdir.patch
the-namespaces-compatibility-list.patch
git-net.patch
sysctl-add-register_sysctl_paths-function.patch
sysctl-add-register_sysctl_paths-function-checkpatch-fixes.patch
sysctl-remember-the-ctl_table-we-passed-to-register_sysctl_paths.patch
sysctl-infrastructure-for-per-namespace-sysctls.patch
sysctl-infrastructure-for-per-namespace-sysctls-checkpatch-fixes.patch
net-implement-the-per-network-namespace-sysctl-infrastructure.patch
quirk-enable-msi-mapping-on-ht1000.patch
quirk-enable-msi-mapping-on-ht1000-v2.patch
fix-proc-net-breakage.patch
fix-proc-dcache-deadlock-in-do_exit.patch
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
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-add-scan_global_lru-macro.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-nid-zid-helper-function-for-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-active-inactive-counter.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-mapper_ratio-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-active-inactive-imbalance-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup-fix.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup-fix-2.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-the-number-of-pages-to-be-scanned-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity-fix.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lock-for-cgroup.patch
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
proc-seqfile-convert-proc_pid_statm.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-proper-pidns-handling-for-proc-self.patch
proc-fix-the-threaded-proc-self.patch
sys_setpgid-simplify-pid-ns-interaction.patch
fix-setsid-for-sub-namespace-sbin-init.patch
teach-set_special_pids-to-use-struct-pid.patch
move-daemonized-kernel-threads-into-the-swappers-session.patch
start-the-global-sbin-init-with-00-special-pids.patch
