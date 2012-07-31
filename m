From: akpm@linux-foundation.org
Subject: [merged] coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:47:57 -0700
Message-ID: <20120731184758.3A91020004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:47128 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179Ab2GaSsB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:48:01 -0400
Received: by wibhr14 with SMTP id hr14so146899wib.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:48:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, akpm@linux-foundation.org, alan@linux.intel.com, dledford@redhat.com, ebiederm@xmission.com, james.l.morris@oracle.com, serge.hallyn@canonical.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: warn about unsafe suid_dumpable / core_pattern combo
has been removed from the -mm tree.  Its filename was
     coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: coredump: warn about unsafe suid_dumpable / core_pattern combo

When suid_dumpable=2, detect unsafe core_pattern settings and warn when
they are seen.

Signed-off-by: Kees Cook <keescook@chromium.org>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alan Cox <alan@linux.intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: James Morris <james.l.morris@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c             |   10 +++++-----
 include/linux/sched.h |    5 +++++
 kernel/sysctl.c       |   37 +++++++++++++++++++++++++++++++++++--
 3 files changed, 45 insertions(+), 7 deletions(-)

diff -puN fs/exec.c~coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo fs/exec.c
--- a/fs/exec.c~coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo
+++ a/fs/exec.c
@@ -2002,17 +2002,17 @@ static void coredump_finish(struct mm_st
 void set_dumpable(struct mm_struct *mm, int value)
 {
 	switch (value) {
-	case 0:
+	case SUID_DUMPABLE_DISABLED:
 		clear_bit(MMF_DUMPABLE, &mm->flags);
 		smp_wmb();
 		clear_bit(MMF_DUMP_SECURELY, &mm->flags);
 		break;
-	case 1:
+	case SUID_DUMPABLE_ENABLED:
 		set_bit(MMF_DUMPABLE, &mm->flags);
 		smp_wmb();
 		clear_bit(MMF_DUMP_SECURELY, &mm->flags);
 		break;
-	case 2:
+	case SUID_DUMPABLE_SAFE:
 		set_bit(MMF_DUMP_SECURELY, &mm->flags);
 		smp_wmb();
 		set_bit(MMF_DUMPABLE, &mm->flags);
@@ -2025,7 +2025,7 @@ static int __get_dumpable(unsigned long 
 	int ret;
 
 	ret = mm_flags & MMF_DUMPABLE_MASK;
-	return (ret >= 2) ? 2 : ret;
+	return (ret > SUID_DUMPABLE_ENABLED) ? SUID_DUMPABLE_SAFE : ret;
 }
 
 int get_dumpable(struct mm_struct *mm)
@@ -2142,7 +2142,7 @@ void do_coredump(long signr, int exit_co
 	 * so we dump it as root in mode 2, and only into a controlled
 	 * environment (pipe handler or fully qualified path).
 	 */
-	if (__get_dumpable(cprm.mm_flags) == 2) {
+	if (__get_dumpable(cprm.mm_flags) == SUID_DUMPABLE_SAFE) {
 		/* Setuid core dump mode */
 		flag = O_EXCL;		/* Stop rewrite attacks */
 		cred->fsuid = GLOBAL_ROOT_UID;	/* Dump root private */
diff -puN include/linux/sched.h~coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo include/linux/sched.h
--- a/include/linux/sched.h~coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo
+++ a/include/linux/sched.h
@@ -406,6 +406,11 @@ static inline void arch_pick_mmap_layout
 extern void set_dumpable(struct mm_struct *mm, int value);
 extern int get_dumpable(struct mm_struct *mm);
 
+/* get/set_dumpable() values */
+#define SUID_DUMPABLE_DISABLED	0
+#define SUID_DUMPABLE_ENABLED	1
+#define SUID_DUMPABLE_SAFE	2
+
 /* mm flags */
 /* dumpable bits */
 #define MMF_DUMPABLE      0  /* core dump is permitted */
diff -puN kernel/sysctl.c~coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo kernel/sysctl.c
--- a/kernel/sysctl.c~coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo
+++ a/kernel/sysctl.c
@@ -174,6 +174,11 @@ static int proc_dointvec_minmax_sysadmin
 				void __user *buffer, size_t *lenp, loff_t *ppos);
 #endif
 
+static int proc_dointvec_minmax_coredump(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp, loff_t *ppos);
+static int proc_dostring_coredump(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp, loff_t *ppos);
+
 #ifdef CONFIG_MAGIC_SYSRQ
 /* Note: sysrq code uses it's own private copy */
 static int __sysrq_enabled = SYSRQ_DEFAULT_ENABLE;
@@ -410,7 +415,7 @@ static struct ctl_table kern_table[] = {
 		.data		= core_pattern,
 		.maxlen		= CORENAME_MAX_SIZE,
 		.mode		= 0644,
-		.proc_handler	= proc_dostring,
+		.proc_handler	= proc_dostring_coredump,
 	},
 	{
 		.procname	= "core_pipe_limit",
@@ -1498,7 +1503,7 @@ static struct ctl_table fs_table[] = {
 		.data		= &suid_dumpable,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax_coredump,
 		.extra1		= &zero,
 		.extra2		= &two,
 	},
@@ -2009,6 +2014,34 @@ int proc_dointvec_minmax(struct ctl_tabl
 				do_proc_dointvec_minmax_conv, &param);
 }
 
+static void validate_coredump_safety(void)
+{
+	if (suid_dumpable == SUID_DUMPABLE_SAFE &&
+	    core_pattern[0] != '/' && core_pattern[0] != '|') {
+		printk(KERN_WARNING "Unsafe core_pattern used with "\
+			"suid_dumpable=2. Pipe handler or fully qualified "\
+			"core dump path required.\n");
+	}
+}
+
+static int proc_dointvec_minmax_coredump(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	int error = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+	if (!error)
+		validate_coredump_safety();
+	return error;
+}
+
+static int proc_dostring_coredump(struct ctl_table *table, int write,
+		  void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	int error = proc_dostring(table, write, buffer, lenp, ppos);
+	if (!error)
+		validate_coredump_safety();
+	return error;
+}
+
 static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int write,
 				     void __user *buffer,
 				     size_t *lenp, loff_t *ppos,
_

Patches currently in -mm which might be from keescook@chromium.org are

origin.patch
linux-next.patch

