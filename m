From: akpm@linux-foundation.org
Subject: - audit-rework-execve-audit.patch removed from -mm tree
Date: Wed, 06 Jun 2007 10:19:42 -0700
Message-ID: <200706061719.l56HJgGW002164@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58809 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754675AbXFFRUn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2007 13:20:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, aaw@google.com, linux-audit@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     audit: rework execve audit
has been removed from the -mm tree.  Its filename was
     audit-rework-execve-audit.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: audit: rework execve audit
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

The purpose of audit_bprm() is to log the argv array to a userspace daemon at
the end of the execve system call.  Since user-space hasn't had time to run,
this array is still in pristine state on the process' stack; so no need to
copy it, we can just grab it from there.

In order to minimize the damage to audit_log_*() copy each string into a
temporary kernel buffer first.

Currently the audit code requires that the full argument vector fits in a
single packet.  So currently it does clip the argv size to a (sysctl) limit,
but only when execve auditing is enabled.

If the audit protocol gets extended to allow for multiple packets this check
can be removed.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ollie Wild <aaw@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <linux-audit@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c               |    3 +
 include/linux/binfmts.h |    1 
 kernel/auditsc.c        |   76 +++++++++++++++++++++++++++-----------
 kernel/sysctl.c         |   11 +++++
 4 files changed, 70 insertions(+), 21 deletions(-)

diff -puN fs/exec.c~audit-rework-execve-audit fs/exec.c
--- a/fs/exec.c~audit-rework-execve-audit
+++ a/fs/exec.c
@@ -1154,6 +1154,7 @@ int do_execve(char * filename,
 {
 	struct linux_binprm *bprm;
 	struct file *file;
+	unsigned long tmp;
 	int retval;
 	int i;
 
@@ -1208,9 +1209,11 @@ int do_execve(char * filename,
 	if (retval < 0)
 		goto out;
 
+	tmp = bprm->p;
 	retval = copy_strings(bprm->argc, argv, bprm);
 	if (retval < 0)
 		goto out;
+	bprm->argv_len = tmp - bprm->p;
 
 	retval = search_binary_handler(bprm,regs);
 	if (retval >= 0) {
diff -puN include/linux/binfmts.h~audit-rework-execve-audit include/linux/binfmts.h
--- a/include/linux/binfmts.h~audit-rework-execve-audit
+++ a/include/linux/binfmts.h
@@ -40,6 +40,7 @@ struct linux_binprm{
 	unsigned interp_flags;
 	unsigned interp_data;
 	unsigned long loader, exec;
+	unsigned long argv_len;
 };
 
 #define BINPRM_FLAGS_ENFORCE_NONDUMP_BIT 0
diff -puN kernel/auditsc.c~audit-rework-execve-audit kernel/auditsc.c
--- a/kernel/auditsc.c~audit-rework-execve-audit
+++ a/kernel/auditsc.c
@@ -156,7 +156,7 @@ struct audit_aux_data_execve {
 	struct audit_aux_data	d;
 	int argc;
 	int envc;
-	char mem[0];
+	struct mm_struct *mm;
 };
 
 struct audit_aux_data_socketcall {
@@ -834,6 +834,47 @@ static int audit_log_pid_context(struct 
 	return rc;
 }
 
+static void audit_log_execve_info(struct audit_buffer *ab,
+		struct audit_aux_data_execve *axi)
+{
+	int i;
+	long len;
+	const char __user *p = (const char __user *)axi->mm->arg_start;
+
+	if (axi->mm != current->mm)
+		return; /* execve failed, no additional info */
+
+	for (i = 0; i < axi->argc; i++, p += len) {
+		long ret;
+		char *tmp;
+
+		len = strnlen_user(p, MAX_ARG_PAGES*PAGE_SIZE);
+		/*
+		 * We just created this mm, if we can't find the strings
+		 * we just copied in something is _very_ wrong.
+		 */
+		BUG_ON(!len);
+
+		tmp = kmalloc(len, GFP_KERNEL);
+		if (!tmp) {
+			audit_panic("out of memory for argv string\n");
+			break;
+		}
+
+		ret = copy_from_user(tmp, p, len);
+		/*
+		 * There is no reason for this copy to be short.
+		 */
+		BUG_ON(ret);
+
+		audit_log_format(ab, "a%d=", i);
+		audit_log_untrustedstring(ab, tmp);
+		audit_log_format(ab, "\n");
+
+		kfree(tmp);
+	}
+}
+
 static void audit_log_exit(struct audit_context *context, struct task_struct *tsk)
 {
 	int i, call_panic = 0;
@@ -974,13 +1015,7 @@ static void audit_log_exit(struct audit_
 
 		case AUDIT_EXECVE: {
 			struct audit_aux_data_execve *axi = (void *)aux;
-			int i;
-			const char *p;
-			for (i = 0, p = axi->mem; i < axi->argc; i++) {
-				audit_log_format(ab, "a%d=", i);
-				p = audit_log_untrustedstring(ab, p);
-				audit_log_format(ab, "\n");
-			}
+			audit_log_execve_info(ab, axi);
 			break; }
 
 		case AUDIT_SOCKETCALL: {
@@ -1824,32 +1859,31 @@ int __audit_ipc_set_perm(unsigned long q
 	return 0;
 }
 
+int audit_argv_kb = 32;
+
 int audit_bprm(struct linux_binprm *bprm)
 {
 	struct audit_aux_data_execve *ax;
 	struct audit_context *context = current->audit_context;
-	unsigned long p, next;
-	void *to;
 
 	if (likely(!audit_enabled || !context || context->dummy))
 		return 0;
 
-	ax = kmalloc(sizeof(*ax) + PAGE_SIZE * MAX_ARG_PAGES - bprm->p,
-				GFP_KERNEL);
+	/*
+	 * Even though the stack code doesn't limit the arg+env size any more,
+	 * the audit code requires that _all_ arguments be logged in a single
+	 * netlink skb. Hence cap it :-(
+	 */
+	if (bprm->argv_len > (audit_argv_kb << 10))
+		return -E2BIG;
+
+	ax = kmalloc(sizeof(*ax), GFP_KERNEL);
 	if (!ax)
 		return -ENOMEM;
 
 	ax->argc = bprm->argc;
 	ax->envc = bprm->envc;
-	for (p = bprm->p, to = ax->mem; p < MAX_ARG_PAGES*PAGE_SIZE; p = next) {
-		struct page *page = bprm->page[p / PAGE_SIZE];
-		void *kaddr = kmap(page);
-		next = (p + PAGE_SIZE) & ~(PAGE_SIZE - 1);
-		memcpy(to, kaddr + (p & (PAGE_SIZE - 1)), next - p);
-		to += next - p;
-		kunmap(page);
-	}
-
+	ax->mm = bprm->mm;
 	ax->d.type = AUDIT_EXECVE;
 	ax->d.next = context->aux;
 	context->aux = (void *)ax;
diff -puN kernel/sysctl.c~audit-rework-execve-audit kernel/sysctl.c
--- a/kernel/sysctl.c~audit-rework-execve-audit
+++ a/kernel/sysctl.c
@@ -81,6 +81,7 @@ extern int percpu_pagelist_fraction;
 extern int compat_log;
 extern int maps_protect;
 extern int sysctl_stat_interval;
+extern int audit_argv_kb;
 
 /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
 static int maxolduid = 65535;
@@ -266,6 +267,16 @@ static ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
+#ifdef CONFIG_AUDITSYSCALL
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "audit_argv_kb",
+		.data		= &audit_argv_kb,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
 	{
 		.ctl_name	= KERN_CORE_USES_PID,
 		.procname	= "core_uses_pid",
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

lumpy-reclaim-v4.patch
split-mmap.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
audit-rework-execve-audit.patch
audit-rework-execve-audit-fix.patch
mm-move_page_tables_up.patch
mm-variable-length-argument-support.patch
mm-variable-length-argument-support-fix.patch
fix-raw_spinlock_t-vs-lockdep.patch
lockdep-sanitise-config_prove_locking.patch
lockdep-reduce-the-ifdeffery.patch
lockstat-core-infrastructure.patch
lockstat-core-infrastructure-fix.patch
lockstat-core-infrastructure-fix-fix.patch
lockstat-human-readability-tweaks.patch
lockstat-human-readability-tweaks-fix.patch
lockstat-hook-into-spinlock_t-rwlock_t-rwsem-and-mutex.patch
