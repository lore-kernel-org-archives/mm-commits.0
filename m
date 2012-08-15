From: akpm@linux-foundation.org
Subject: + coredump-make-core-dump-functionality-optional.patch added to -mm tree
Date: Wed, 15 Aug 2012 16:18:18 -0700
Message-ID: <20120815231819.ADA995C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:48017 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078Ab2HOXSV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Aug 2012 19:18:21 -0400
Received: by mail-ey0-f202.google.com with SMTP id c1so99469eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Aug 2012 16:18:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alex.page.kelly@gmail.com, josh@joshtriplett.org, keescook@chromium.org, serge.hallyn@canonical.com


The patch titled
     Subject: coredump: make core dump functionality optional
has been added to the -mm tree.  Its filename is
     coredump-make-core-dump-functionality-optional.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alex Kelly <alex.page.kelly@gmail.com>
Subject: coredump: make core dump functionality optional

Adds an expert Kconfig option, CONFIG_COREDUMP, which allows disabling of
core dump.  This saves approximately 2.6k in the compiled kernel, and
complements CONFIG_ELF_CORE, which now depends on it.

CONFIG_COREDUMP also disables coredump-related sysctls, except for
suid_dumpable and related functions, which are necessary for ptrace.

Signed-off-by: Alex Kelly <alex.page.kelly@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig.binfmt       |    8 ++++++++
 fs/Makefile             |    3 ++-
 include/linux/binfmts.h |    4 ++++
 init/Kconfig            |    1 +
 kernel/sysctl.c         |    6 +++++-
 5 files changed, 20 insertions(+), 2 deletions(-)

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
@@ -1247,6 +1247,7 @@ config BUG
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
@@ -404,6 +406,7 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+#ifdef CONFIG_COREDUMP
 	{
 		.procname	= "core_uses_pid",
 		.data		= &core_uses_pid,
@@ -425,6 +428,7 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+#endif
 #ifdef CONFIG_PROC_SYSCTL
 	{
 		.procname	= "tainted",
_

Patches currently in -mm which might be from alex.page.kelly@gmail.com are

coredump-move-core-dump-functionality-into-its-own-file.patch
coredump-make-core-dump-functionality-optional.patch
coredump-update-coredump-related-headers.patch

