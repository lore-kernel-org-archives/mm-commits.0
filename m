From: akpm@linux-foundation.org
Subject: + audit-rework-execve-audit.patch added to -mm tree
Date: Tue, 26 Jun 2007 15:59:06 -0700
Message-ID: <200706262259.l5QMx7iQ004247__10372.0571184114$1182898774$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53033 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751114AbXFZW70 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 18:59:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, aaw@google.com, linux-audit@redhat.com


The patch titled
     audit: rework execve audit
has been added to the -mm tree.  Its filename is
     audit-rework-execve-audit.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: <linux-audit@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c               |    3 +
 include/linux/binfmts.h |    1 
 kernel/auditsc.c        |   84 ++++++++++++++++++++++++++++----------
 kernel/sysctl.c         |   11 ++++
 4 files changed, 78 insertions(+), 21 deletions(-)

diff -puN fs/exec.c~audit-rework-execve-audit fs/exec.c
--- a/fs/exec.c~audit-rework-execve-audit
+++ a/fs/exec.c
@@ -1154,6 +1154,7 @@ int do_execve(char * filename,
 {
 	struct linux_binprm *bprm;
 	struct file *file;
+	unsigned long env_p;
 	int retval;
 	int i;
 
@@ -1208,9 +1209,11 @@ int do_execve(char * filename,
 	if (retval < 0)
 		goto out;
 
+	env_p = bprm->p;
 	retval = copy_strings(bprm->argc, argv, bprm);
 	if (retval < 0)
 		goto out;
+	bprm->argv_len = env_p - bprm->p;
 
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
@@ -153,7 +153,7 @@ struct audit_aux_data_execve {
 	struct audit_aux_data	d;
 	int argc;
 	int envc;
-	char mem[0];
+	struct mm_struct *mm;
 };
 
 struct audit_aux_data_socketcall {
@@ -831,6 +831,55 @@ static int audit_log_pid_context(struct 
 	return rc;
 }
 
+static void audit_log_execve_info(struct audit_buffer *ab,
+		struct audit_aux_data_execve *axi)
+{
+	int i;
+	long len, ret;
+	const char __user *p = (const char __user *)axi->mm->arg_start;
+	char *buf;
+
+	if (axi->mm != current->mm)
+		return; /* execve failed, no additional info */
+
+	for (i = 0; i < axi->argc; i++, p += len) {
+		len = strnlen_user(p, MAX_ARG_PAGES*PAGE_SIZE);
+		/*
+		 * We just created this mm, if we can't find the strings
+		 * we just copied into it something is _very_ wrong. Similar
+		 * for strings that are too long, we should not have created
+		 * any.
+		 */
+		if (!len || len > MAX_ARG_STRLEN) {
+			WARN_ON(1);
+			send_sig(SIGKILL, current, 0);
+		}
+
+		buf = kmalloc(len, GFP_KERNEL);
+		if (!buf) {
+			audit_panic("out of memory for argv string\n");
+			break;
+		}
+
+		ret = copy_from_user(buf, p, len);
+		/*
+		 * There is no reason for this copy to be short. We just
+		 * copied them here, and the mm hasn't been exposed to user-
+		 * space yet.
+		 */
+		if (!ret) {
+			WARN_ON(1);
+			send_sig(SIGKILL, current, 0);
+		}
+
+		audit_log_format(ab, "a%d=", i);
+		audit_log_untrustedstring(ab, buf);
+		audit_log_format(ab, "\n");
+
+		kfree(buf);
+	}
+}
+
 static void audit_log_exit(struct audit_context *context, struct task_struct *tsk)
 {
 	int i, call_panic = 0;
@@ -971,13 +1020,7 @@ static void audit_log_exit(struct audit_
 
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
@@ -1821,32 +1864,31 @@ int __audit_ipc_set_perm(unsigned long q
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
@@ -78,6 +78,7 @@ extern int percpu_pagelist_fraction;
 extern int compat_log;
 extern int maps_protect;
 extern int sysctl_stat_interval;
+extern int audit_argv_kb;
 
 /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
 static int maxolduid = 65535;
@@ -946,6 +947,16 @@ static ctl_table binfmt_misc_table[] = {
 	{ .ctl_name = 0 }
 };
 #endif
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
 
 static ctl_table fs_table[] = {
 	{
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

lumpy-reclaim-v4.patch
split-mmap.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-pci-generic-helper-function-fix.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-iova-allocation-and-management-routines-fix.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-intel-iommu-driver-fix.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
intel-iommu-iommu-floppy-workaround-fix.patch
arch-personality-independent-stack-top.patch
audit-rework-execve-audit.patch
mm-variable-length-argument-support.patch
mm-variable-length-argument-support-fix.patch
fix-raw_spinlock_t-vs-lockdep.patch
lockdep-sanitise-config_prove_locking.patch
lockdep-reduce-the-ifdeffery.patch
lockstat-core-infrastructure.patch
lockstat-core-infrastructure-fix.patch
lockstat-core-infrastructure-fix-fix.patch
lockstat-core-infrastructure-fix-fix-fix.patch
lockstat-human-readability-tweaks.patch
lockstat-human-readability-tweaks-fix.patch
lockstat-hook-into-spinlock_t-rwlock_t-rwsem-and-mutex.patch
lockdep-various-fixes.patch
lockdep-various-fixes-checkpatch.patch
lockdep-fixup-sk_callback_lock-annotation.patch
lockstat-measure-lock-bouncing.patch
lockstat-measure-lock-bouncing-checkpatch.patch
lockstat-better-class-name-representation.patch
