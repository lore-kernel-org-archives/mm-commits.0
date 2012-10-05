From: akpm@linux-foundation.org
Subject: [merged] coredump-make-core-dump-functionality-optional.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:19:20 -0700
Message-ID: <20121005201920.BDF19100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:37882 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757185Ab2JEUTW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:19:22 -0400
Received: by mail-vb0-f74.google.com with SMTP id s24so236864vbi.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:19:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.page.kelly@gmail.com, josh@joshtriplett.org, keescook@chromium.org, rdunlap@xenotime.net, serge.hallyn@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: make core dump functionality optional
has been removed from the -mm tree.  Its filename was
     coredump-make-core-dump-functionality-optional.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alex Kelly <alex.page.kelly@gmail.com>
Subject: coredump: make core dump functionality optional

Adds an expert Kconfig option, CONFIG_COREDUMP, which allows disabling of
core dump.  This saves approximately 2.6k in the compiled kernel, and
complements CONFIG_ELF_CORE, which now depends on it.

CONFIG_COREDUMP also disables coredump-related sysctls, except for
suid_dumpable and related functions, which are necessary for ptrace.

[akpm@linux-foundation.org: fix binfmt_aout.c build]
Signed-off-by: Alex Kelly <alex.page.kelly@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig.binfmt       |    8 +++++
 fs/Makefile             |    3 +-
 fs/binfmt_aout.c        |   52 +++++++++++++++++++-------------------
 include/linux/binfmts.h |    4 ++
 init/Kconfig            |    1 
 kernel/sysctl.c         |   12 ++++++++
 6 files changed, 53 insertions(+), 27 deletions(-)

diff -puN fs/Kconfig.binfmt~coredump-make-core-dump-functionality-optional fs/Kconfig.binfmt
--- a/fs/Kconfig.binfmt~coredump-make-core-dump-functionality-optional
+++ a/fs/Kconfig.binfmt
@@ -164,3 +164,11 @@ config BINFMT_MISC
 	  You may say M here for module support and later load the module when
 	  you have use for it; the module is called binfmt_misc. If you
 	  don't know what to answer at this point, say Y.
+
+config COREDUMP
+	bool "Enable core dump support" if EXPERT
+	default y
+	help
+	  This option enables support for performing core dumps. You almost
+	  certainly want to say Y here. Not necessary on systems that never
+	  need debugging or only ever run flawless code.
diff -puN fs/Makefile~coredump-make-core-dump-functionality-optional fs/Makefile
--- a/fs/Makefile~coredump-make-core-dump-functionality-optional
+++ a/fs/Makefile
@@ -11,7 +11,7 @@ obj-y :=	open.o read_write.o file_table.
 		attr.o bad_inode.o file.o filesystems.o namespace.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
 		pnode.o drop_caches.o splice.o sync.o utimes.o \
-		stack.o fs_struct.o statfs.o coredump.o
+		stack.o fs_struct.o statfs.o
 
 ifeq ($(CONFIG_BLOCK),y)
 obj-y +=	buffer.o bio.o block_dev.o direct-io.o mpage.o ioprio.o
@@ -48,6 +48,7 @@ obj-$(CONFIG_FS_MBCACHE)	+= mbcache.o
 obj-$(CONFIG_FS_POSIX_ACL)	+= posix_acl.o xattr_acl.o
 obj-$(CONFIG_NFS_COMMON)	+= nfs_common/
 obj-$(CONFIG_GENERIC_ACL)	+= generic_acl.o
+obj-$(CONFIG_COREDUMP)		+= coredump.o
 
 obj-$(CONFIG_FHANDLE)		+= fhandle.o
 
diff -puN fs/binfmt_aout.c~coredump-make-core-dump-functionality-optional fs/binfmt_aout.c
--- a/fs/binfmt_aout.c~coredump-make-core-dump-functionality-optional
+++ a/fs/binfmt_aout.c
@@ -32,31 +32,8 @@
 
 static int load_aout_binary(struct linux_binprm *, struct pt_regs * regs);
 static int load_aout_library(struct file*);
-static int aout_core_dump(struct coredump_params *cprm);
-
-static struct linux_binfmt aout_format = {
-	.module		= THIS_MODULE,
-	.load_binary	= load_aout_binary,
-	.load_shlib	= load_aout_library,
-	.core_dump	= aout_core_dump,
-	.min_coredump	= PAGE_SIZE
-};
-
-#define BAD_ADDR(x)	((unsigned long)(x) >= TASK_SIZE)
-
-static int set_brk(unsigned long start, unsigned long end)
-{
-	start = PAGE_ALIGN(start);
-	end = PAGE_ALIGN(end);
-	if (end > start) {
-		unsigned long addr;
-		addr = vm_brk(start, end - start);
-		if (BAD_ADDR(addr))
-			return addr;
-	}
-	return 0;
-}
 
+#ifdef CONFIG_COREDUMP
 /*
  * Routine writes a core dump image in the current directory.
  * Currently only a stub-function.
@@ -66,7 +43,6 @@ static int set_brk(unsigned long start, 
  * field, which also makes sure the core-dumps won't be recursive if the
  * dumping of the process results in another error..
  */
-
 static int aout_core_dump(struct coredump_params *cprm)
 {
 	struct file *file = cprm->file;
@@ -135,6 +111,32 @@ end_coredump:
 	set_fs(fs);
 	return has_dumped;
 }
+#else
+#define aout_core_dump NULL
+#endif
+
+static struct linux_binfmt aout_format = {
+	.module		= THIS_MODULE,
+	.load_binary	= load_aout_binary,
+	.load_shlib	= load_aout_library,
+	.core_dump	= aout_core_dump,
+	.min_coredump	= PAGE_SIZE
+};
+
+#define BAD_ADDR(x)	((unsigned long)(x) >= TASK_SIZE)
+
+static int set_brk(unsigned long start, unsigned long end)
+{
+	start = PAGE_ALIGN(start);
+	end = PAGE_ALIGN(end);
+	if (end > start) {
+		unsigned long addr;
+		addr = vm_brk(start, end - start);
+		if (BAD_ADDR(addr))
+			return addr;
+	}
+	return 0;
+}
 
 /*
  * create_aout_tables() parses the env- and arg-strings in new user
diff -puN include/linux/binfmts.h~coredump-make-core-dump-functionality-optional include/linux/binfmts.h
--- a/include/linux/binfmts.h~coredump-make-core-dump-functionality-optional
+++ a/include/linux/binfmts.h
@@ -132,7 +132,11 @@ extern int copy_strings_kernel(int argc,
 			       struct linux_binprm *bprm);
 extern int prepare_bprm_creds(struct linux_binprm *bprm);
 extern void install_exec_creds(struct linux_binprm *bprm);
+#ifdef CONFIG_COREDUMP
 extern void do_coredump(long signr, int exit_code, struct pt_regs *regs);
+#else
+static inline void do_coredump(long signr, int exit_code, struct pt_regs *regs) {}
+#endif
 extern void set_binfmt(struct linux_binfmt *new);
 extern void free_bprm(struct linux_binprm *);
 
diff -puN init/Kconfig~coredump-make-core-dump-functionality-optional init/Kconfig
--- a/init/Kconfig~coredump-make-core-dump-functionality-optional
+++ a/init/Kconfig
@@ -1199,6 +1199,7 @@ config BUG
           Just say Y.
 
 config ELF_CORE
+	depends on COREDUMP
 	default y
 	bool "Enable ELF core dumps" if EXPERT
 	help
diff -puN kernel/sysctl.c~coredump-make-core-dump-functionality-optional kernel/sysctl.c
--- a/kernel/sysctl.c~coredump-make-core-dump-functionality-optional
+++ a/kernel/sysctl.c
@@ -97,10 +97,12 @@
 extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
 extern int max_threads;
-extern int core_uses_pid;
 extern int suid_dumpable;
+#ifdef CONFIG_COREDUMP
+extern int core_uses_pid;
 extern char core_pattern[];
 extern unsigned int core_pipe_limit;
+#endif
 extern int pid_max;
 extern int min_free_kbytes;
 extern int pid_max_min, pid_max_max;
@@ -177,8 +179,10 @@ static int proc_dointvec_minmax_sysadmin
 
 static int proc_dointvec_minmax_coredump(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp, loff_t *ppos);
+#ifdef CONFIG_COREDUMP
 static int proc_dostring_coredump(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp, loff_t *ppos);
+#endif
 
 #ifdef CONFIG_MAGIC_SYSRQ
 /* Note: sysrq code uses it's own private copy */
@@ -404,6 +408,7 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+#ifdef CONFIG_COREDUMP
 	{
 		.procname	= "core_uses_pid",
 		.data		= &core_uses_pid,
@@ -425,6 +430,7 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+#endif
 #ifdef CONFIG_PROC_SYSCTL
 	{
 		.procname	= "tainted",
@@ -2036,12 +2042,14 @@ int proc_dointvec_minmax(struct ctl_tabl
 
 static void validate_coredump_safety(void)
 {
+#ifdef CONFIG_COREDUMP
 	if (suid_dumpable == SUID_DUMPABLE_SAFE &&
 	    core_pattern[0] != '/' && core_pattern[0] != '|') {
 		printk(KERN_WARNING "Unsafe core_pattern used with "\
 			"suid_dumpable=2. Pipe handler or fully qualified "\
 			"core dump path required.\n");
 	}
+#endif
 }
 
 static int proc_dointvec_minmax_coredump(struct ctl_table *table, int write,
@@ -2053,6 +2061,7 @@ static int proc_dointvec_minmax_coredump
 	return error;
 }
 
+#ifdef CONFIG_COREDUMP
 static int proc_dostring_coredump(struct ctl_table *table, int write,
 		  void __user *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -2061,6 +2070,7 @@ static int proc_dostring_coredump(struct
 		validate_coredump_safety();
 	return error;
 }
+#endif
 
 static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int write,
 				     void __user *buffer,
_

Patches currently in -mm which might be from alex.page.kelly@gmail.com are

origin.patch

