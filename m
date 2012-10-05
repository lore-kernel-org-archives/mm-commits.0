From: akpm@linux-foundation.org
Subject: [merged] coredump-update-coredump-related-headers.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:19:23 -0700
Message-ID: <20121005201924.2BE225C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:37923 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757185Ab2JEUT0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:19:26 -0400
Received: by mail-wi0-f202.google.com with SMTP id hr7so57973wib.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:19:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.page.kelly@gmail.com, josh@joshtriplett.org, keescook@chromium.org, serge.hallyn@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: update coredump-related headers
has been removed from the -mm tree.  Its filename was
     coredump-update-coredump-related-headers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alex Kelly <alex.page.kelly@gmail.com>
Subject: coredump: update coredump-related headers

Create a new header file, fs/coredump.h, which contains functions only
used by the new coredump.c.  It also moves do_coredump to the
include/linux/coredump.h header file, for consistency.

Signed-off-by: Alex Kelly <alex.page.kelly@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c            |    2 ++
 fs/coredump.h            |    6 ++++++
 fs/exec.c                |    1 +
 include/linux/binfmts.h  |    5 -----
 include/linux/coredump.h |    5 +++++
 include/linux/sched.h    |    1 -
 kernel/signal.c          |    1 +
 7 files changed, 15 insertions(+), 6 deletions(-)

diff -puN fs/coredump.c~coredump-update-coredump-related-headers fs/coredump.c
--- a/fs/coredump.c~coredump-update-coredump-related-headers
+++ a/fs/coredump.c
@@ -14,6 +14,7 @@
 #include <linux/key.h>
 #include <linux/personality.h>
 #include <linux/binfmts.h>
+#include <linux/coredump.h>
 #include <linux/utsname.h>
 #include <linux/pid_namespace.h>
 #include <linux/module.h>
@@ -39,6 +40,7 @@
 
 #include <trace/events/task.h>
 #include "internal.h"
+#include "coredump.h"
 
 #include <trace/events/sched.h>
 
diff -puN /dev/null fs/coredump.h
--- /dev/null
+++ a/fs/coredump.h
@@ -0,0 +1,6 @@
+#ifndef _FS_COREDUMP_H
+#define _FS_COREDUMP_H
+
+extern int __get_dumpable(unsigned long mm_flags);
+
+#endif
diff -puN fs/exec.c~coredump-update-coredump-related-headers fs/exec.c
--- a/fs/exec.c~coredump-update-coredump-related-headers
+++ a/fs/exec.c
@@ -63,6 +63,7 @@
 
 #include <trace/events/task.h>
 #include "internal.h"
+#include "coredump.h"
 
 #include <trace/events/sched.h>
 
diff -puN include/linux/binfmts.h~coredump-update-coredump-related-headers include/linux/binfmts.h
--- a/include/linux/binfmts.h~coredump-update-coredump-related-headers
+++ a/include/linux/binfmts.h
@@ -132,11 +132,6 @@ extern int copy_strings_kernel(int argc,
 			       struct linux_binprm *bprm);
 extern int prepare_bprm_creds(struct linux_binprm *bprm);
 extern void install_exec_creds(struct linux_binprm *bprm);
-#ifdef CONFIG_COREDUMP
-extern void do_coredump(long signr, int exit_code, struct pt_regs *regs);
-#else
-static inline void do_coredump(long signr, int exit_code, struct pt_regs *regs) {}
-#endif
 extern void set_binfmt(struct linux_binfmt *new);
 extern void free_bprm(struct linux_binprm *);
 
diff -puN include/linux/coredump.h~coredump-update-coredump-related-headers include/linux/coredump.h
--- a/include/linux/coredump.h~coredump-update-coredump-related-headers
+++ a/include/linux/coredump.h
@@ -11,5 +11,10 @@
  */
 extern int dump_write(struct file *file, const void *addr, int nr);
 extern int dump_seek(struct file *file, loff_t off);
+#ifdef CONFIG_COREDUMP
+extern void do_coredump(long signr, int exit_code, struct pt_regs *regs);
+#else
+static inline void do_coredump(long signr, int exit_code, struct pt_regs *regs) {}
+#endif
 
 #endif /* _LINUX_COREDUMP_H */
diff -puN include/linux/sched.h~coredump-update-coredump-related-headers include/linux/sched.h
--- a/include/linux/sched.h~coredump-update-coredump-related-headers
+++ a/include/linux/sched.h
@@ -405,7 +405,6 @@ static inline void arch_pick_mmap_layout
 
 extern void set_dumpable(struct mm_struct *mm, int value);
 extern int get_dumpable(struct mm_struct *mm);
-extern int __get_dumpable(unsigned long mm_flags);
 
 /* get/set_dumpable() values */
 #define SUID_DUMPABLE_DISABLED	0
diff -puN kernel/signal.c~coredump-update-coredump-related-headers kernel/signal.c
--- a/kernel/signal.c~coredump-update-coredump-related-headers
+++ a/kernel/signal.c
@@ -17,6 +17,7 @@
 #include <linux/fs.h>
 #include <linux/tty.h>
 #include <linux/binfmts.h>
+#include <linux/coredump.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/ptrace.h>
_

Patches currently in -mm which might be from alex.page.kelly@gmail.com are

origin.patch

