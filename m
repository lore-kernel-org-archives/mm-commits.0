From: akpm@linux-foundation.org
Subject: + coredump-update-coredump-related-headers.patch added to -mm tree
Date: Wed, 15 Aug 2012 16:18:22 -0700
Message-ID: <20120815231823.7AEB7100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-iy0-f202.google.com ([209.85.210.202]:63837 "EHLO
	mail-iy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab2HOXSZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Aug 2012 19:18:25 -0400
Received: by ialo24 with SMTP id o24so166176ial.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Aug 2012 16:18:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alex.page.kelly@gmail.com, josh@joshtriplett.org, keescook@chromium.org, serge.hallyn@canonical.com


The patch titled
     Subject: coredump: update coredump-related headers
has been added to the -mm tree.  Its filename is
     coredump-update-coredump-related-headers.patch

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

coredump-move-core-dump-functionality-into-its-own-file.patch
coredump-make-core-dump-functionality-optional.patch
coredump-update-coredump-related-headers.patch

