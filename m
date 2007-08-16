From: akpm@linux-foundation.org
Subject: + uml-remove-sysdep-threadh.patch added to -mm tree
Date: Thu, 16 Aug 2007 14:14:14 -0700
Message-ID: <200708162114.l7GLEEvU007077@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59253 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751937AbXHPVOZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Aug 2007 17:14:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: remove sysdep/thread.h
has been added to the -mm tree.  Its filename is
     uml-remove-sysdep-threadh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: remove sysdep/thread.h
From: Jeff Dike <jdike@addtoit.com>

This patch removes thread.h, which turns out not to be needed any more.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/sysdep-i386/kernel-offsets.h |    1 -
 arch/um/include/sysdep-i386/sigcontext.h     |    3 ++-
 arch/um/include/sysdep-i386/thread.h         |    8 --------
 arch/um/include/sysdep-x86_64/thread.h       |    6 ------
 arch/um/sys-i386/ptrace_user.c               |    1 -
 5 files changed, 2 insertions(+), 17 deletions(-)

diff -puN arch/um/include/sysdep-i386/kernel-offsets.h~uml-remove-sysdep-threadh arch/um/include/sysdep-i386/kernel-offsets.h
--- a/arch/um/include/sysdep-i386/kernel-offsets.h~uml-remove-sysdep-threadh
+++ a/arch/um/include/sysdep-i386/kernel-offsets.h
@@ -17,6 +17,5 @@
 
 void foo(void)
 {
-	OFFSET(HOST_TASK_DEBUGREGS, task_struct, thread.arch.debugregs);
 #include <common-offsets.h>
 }
diff -puN arch/um/include/sysdep-i386/sigcontext.h~uml-remove-sysdep-threadh arch/um/include/sysdep-i386/sigcontext.h
--- a/arch/um/include/sysdep-i386/sigcontext.h~uml-remove-sysdep-threadh
+++ a/arch/um/include/sysdep-i386/sigcontext.h
@@ -7,7 +7,8 @@
 #define __SYS_SIGCONTEXT_I386_H
 
 #include "uml-config.h"
-#include <sysdep/sc.h>
+#include "skas.h"
+#include "sysdep/sc.h"
 
 #define IP_RESTART_SYSCALL(ip) ((ip) -= 2)
 
diff -puN arch/um/include/sysdep-i386/thread.h~uml-remove-sysdep-threadh /dev/null
--- a/arch/um/include/sysdep-i386/thread.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef __UM_THREAD_H
-#define __UM_THREAD_H
-
-#include <kern_constants.h>
-
-#define TASK_DEBUGREGS(task) ((unsigned long *) &(((char *) (task))[HOST_TASK_DEBUGREGS]))
-
-#endif
diff -puN arch/um/include/sysdep-x86_64/thread.h~uml-remove-sysdep-threadh /dev/null
--- a/arch/um/include/sysdep-x86_64/thread.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __UM_THREAD_H
-#define __UM_THREAD_H
-
-#include <kern_constants.h>
-
-#endif
diff -puN arch/um/sys-i386/ptrace_user.c~uml-remove-sysdep-threadh arch/um/sys-i386/ptrace_user.c
--- a/arch/um/sys-i386/ptrace_user.c~uml-remove-sysdep-threadh
+++ a/arch/um/sys-i386/ptrace_user.c
@@ -11,7 +11,6 @@
 /* Grr, asm/user.h includes asm/ptrace.h, so has to follow ptrace_user.h */
 #include <asm/user.h>
 #include "kern_util.h"
-#include "sysdep/thread.h"
 #include "user.h"
 #include "os.h"
 #include "uml-config.h"
_

Patches currently in -mm which might be from jdike@addtoit.com are

introduce-config_check_signature-was-re-uninline.patch
git-kvm.patch
hostfs-convert-to-new-aops.patch
uml-move-userspace-code-to-userspace-file.patch
uml-tidy-recently-moved-code.patch
uml-fix-error-cleanup-ordering.patch
uml-console-subsystem-tidying.patch
uml-fix-console-writing-bugs.patch
uml-console-tidying.patch
uml-stop-using-libc-asm-pageh.patch
uml-fix-an-ipv6-libc-vs-kernel-symbol-clash.patch
uml-fix-nonremovability-of-watchdog.patch
uml-stop-specially-protecting-kernel-stacks.patch
uml-stop-saving-process-fp-state.patch
uml-physmem-code-tidying.patch
uml-add-vde-networking-support.patch
uml-remove-unnecessary-hostfs_getattr.patch
uml-throw-out-config_mode_tt.patch
uml-remove-sysdep-threadh.patch
uml-style-fixes-pass-1.patch
uml-throw-out-choose_mode.patch
uml-style-fixes-pass-2.patch
uml-remove-code-made-redundant-by-choose_mode-removal.patch
uml-style-fixes-pass-3.patch
uml-remove-__u64-usage-from-physical-memory-subsystem.patch
uml-get-rid-of-do_longjmp.patch
uml-fold-mmu_context_skas-into-mm_context.patch
uml-rename-pt_regs-general-purpose-register-file.patch
uml-free-ldt-state-on-process-exit.patch
uml-remove-os_-usage-from-userspace-files.patch
uml-replace-clone-with-fork.patch
