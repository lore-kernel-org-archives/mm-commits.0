From: akpm@linux-foundation.org
Subject: - uml-style-fixes.patch removed from -mm tree
Date: Tue, 13 May 2008 14:32:23 -0700
Message-ID: <200805132132.m4DLWNDX000679@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42215 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759622AbYEMVco (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:32:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     uml: style fixes
has been removed from the -mm tree.  Its filename was
     uml-style-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
asm-alphah8300umv850xtensa-paramh-unbreak-hz-for-userspace.patch
arch-um-kernel-irqc-clean-up-some-functions.patch
arch-um-kernel-memc-remove-arch_validate.patch
uml-make-several-more-things-static.patch

