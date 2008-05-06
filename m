From: akpm@linux-foundation.org
Subject: + uml-style-fixes.patch added to -mm tree
Date: Tue, 06 May 2008 13:49:05 -0700
Message-ID: <200805062049.m46Kn55C026540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46350 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756649AbYEFUtK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 16:49:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com, xiyou.wangcong@gmail.com


The patch titled
     uml: style fixes
has been added to the -mm tree.  Its filename is
     uml-style-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: style fixes
From: Jeff Dike <jdike@addtoit.com>

A few random style fixes.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/skas_ptrace.h            |   13 +------------
 arch/um/include/sysdep-i386/sigcontext.h |    2 +-
 arch/um/kernel/um_arch.c                 |    2 +-
 arch/um/os-Linux/skas/process.c          |    2 +-
 4 files changed, 4 insertions(+), 15 deletions(-)

diff -puN arch/um/include/skas_ptrace.h~uml-style-fixes arch/um/include/skas_ptrace.h
--- a/arch/um/include/skas_ptrace.h~uml-style-fixes
+++ a/arch/um/include/skas_ptrace.h
@@ -1,5 +1,5 @@
 /* 
- * Copyright (C) 2000, 2001, 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
@@ -12,14 +12,3 @@
 #include "sysdep/skas_ptrace.h"
 
 #endif
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/include/sysdep-i386/sigcontext.h~uml-style-fixes arch/um/include/sysdep-i386/sigcontext.h
--- a/arch/um/include/sysdep-i386/sigcontext.h~uml-style-fixes
+++ a/arch/um/include/sysdep-i386/sigcontext.h
@@ -10,7 +10,7 @@
 
 #define IP_RESTART_SYSCALL(ip) ((ip) -= 2)
 
-#define GET_FAULTINFO_FROM_SC(fi,sc) \
+#define GET_FAULTINFO_FROM_SC(fi, sc) \
 	{ \
 		(fi).cr2 = SC_CR2(sc); \
 		(fi).error_code = SC_ERR(sc); \
diff -puN arch/um/kernel/um_arch.c~uml-style-fixes arch/um/kernel/um_arch.c
--- a/arch/um/kernel/um_arch.c~uml-style-fixes
+++ a/arch/um/kernel/um_arch.c
@@ -150,7 +150,7 @@ __uml_setup("root=", uml_root_setup,
 static int __init no_skas_debug_setup(char *line, int *add)
 {
 	printf("'debug' is not necessary to gdb UML in skas mode - run \n");
-	printf("'gdb linux'");
+	printf("'gdb linux'\n");
 
 	return 0;
 }
diff -puN arch/um/os-Linux/skas/process.c~uml-style-fixes arch/um/os-Linux/skas/process.c
--- a/arch/um/os-Linux/skas/process.c~uml-style-fixes
+++ a/arch/um/os-Linux/skas/process.c
@@ -442,7 +442,7 @@ void userspace(struct uml_pt_regs *regs)
 				unblock_signals();
 				break;
 			default:
-			        printk(UM_KERN_ERR "userspace - child stopped "
+				printk(UM_KERN_ERR "userspace - child stopped "
 				       "with signal %d\n", sig);
 				fatal_sigsegv();
 			}
_

Patches currently in -mm which might be from jdike@addtoit.com are

linux-next.patch
uml-fix-inconsistence-due-to-tty_operation-change.patch
uml-redo-host-capability-detection-and-disabling.patch
uml-tidy-stub-management-code.patch
uml-style-fixes.patch
uml-random-driver-fixes.patch
uml-random-driver-style-fixes.patch
uml-hppfs-fixes.patch
uml-move-hppfs_kernc-to-hppfsc.patch
uml-tidy-ptrace-interface.patch
uml-fix-errno-return.patch
uml-track-and-make-up-lost-ticks.patch
uml-fix-build-when-slob-is-enabled.patch
uml-remove-unused-header.patch
uml-fix-bad-ntp-interaction-with-clock.patch
uml-use-__spin_lock_unlocked.patch
uml-physical-memory-shouldnt-include-initial-stack.patch
arch-um-kernel-irqc-clean-up-some-functions.patch
arch-um-kernel-memc-remove-arch_validate.patch
uml-make-several-more-things-static.patch

