From: akpm@linux-foundation.org
Subject: [merged] um-clean-up-vm-flagsh.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:54:17 -0700
Message-ID: <201107260753.p6Q7rKCs003220@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47501 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753126Ab1GZHyA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:54:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@nod.at, mhocko@suse.cz, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     um: clean up vm-flags.h
has been removed from the -mm tree.  Its filename was
     um-clean-up-vm-flagsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um: clean up vm-flags.h
From: Richard Weinberger <richard@nod.at>

There is no need to define VM_{STACK,DATA}_DEFAULT_FLAGS as variable. 
It's also useless to test for TIF_IA32 as 64bit UML has no IA32 emulation.

Signed-off-by: Richard Weinberger <richard@nod.at>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/sys-x86_64/Makefile                 |    2 -
 arch/um/sys-x86_64/mem.c                    |   16 -----------
 arch/um/sys-x86_64/shared/sysdep/vm-flags.h |   26 ++----------------
 3 files changed, 5 insertions(+), 39 deletions(-)

diff -puN arch/um/sys-x86_64/Makefile~um-clean-up-vm-flagsh arch/um/sys-x86_64/Makefile
--- a/arch/um/sys-x86_64/Makefile~um-clean-up-vm-flagsh
+++ a/arch/um/sys-x86_64/Makefile
@@ -4,7 +4,7 @@
 # Licensed under the GPL
 #
 
-obj-y = bug.o bugs.o delay.o fault.o ldt.o mem.o ptrace.o ptrace_user.o \
+obj-y = bug.o bugs.o delay.o fault.o ldt.o ptrace.o ptrace_user.o \
 	setjmp.o signal.o stub.o stub_segv.o syscalls.o syscall_table.o \
 	sysrq.o ksyms.o tls.o
 
diff -puN arch/um/sys-x86_64/mem.c~um-clean-up-vm-flagsh /dev/null
--- a/arch/um/sys-x86_64/mem.c
+++ /dev/null
@@ -1,16 +0,0 @@
-/*
- * Copyright 2003 PathScale, Inc.
- *
- * Licensed under the GPL
- */
-
-#include "linux/mm.h"
-#include "asm/page.h"
-#include "asm/mman.h"
-
-unsigned long vm_stack_flags = __VM_STACK_FLAGS;
-unsigned long vm_stack_flags32 = __VM_STACK_FLAGS;
-unsigned long vm_data_default_flags = __VM_DATA_DEFAULT_FLAGS;
-unsigned long vm_data_default_flags32 = __VM_DATA_DEFAULT_FLAGS;
-unsigned long vm_force_exec32 = PROT_EXEC;
-
diff -puN arch/um/sys-x86_64/shared/sysdep/vm-flags.h~um-clean-up-vm-flagsh arch/um/sys-x86_64/shared/sysdep/vm-flags.h
--- a/arch/um/sys-x86_64/shared/sysdep/vm-flags.h~um-clean-up-vm-flagsh
+++ a/arch/um/sys-x86_64/shared/sysdep/vm-flags.h
@@ -7,27 +7,9 @@
 #ifndef __VM_FLAGS_X86_64_H
 #define __VM_FLAGS_X86_64_H
 
-#define __VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | VM_EXEC | \
-				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
-#define __VM_STACK_FLAGS 	(VM_GROWSDOWN | VM_READ | VM_WRITE | \
-				 VM_EXEC | VM_MAYREAD | VM_MAYWRITE | \
-				 VM_MAYEXEC)
-
-extern unsigned long vm_stack_flags, vm_stack_flags32;
-extern unsigned long vm_data_default_flags, vm_data_default_flags32;
-extern unsigned long vm_force_exec32;
-
-#ifdef TIF_IA32
-#define VM_DATA_DEFAULT_FLAGS \
-	(test_thread_flag(TIF_IA32) ? vm_data_default_flags32 : \
-	  vm_data_default_flags)
-
-#define VM_STACK_DEFAULT_FLAGS \
-	(test_thread_flag(TIF_IA32) ? vm_stack_flags32 : vm_stack_flags)
-#endif
-
-#define VM_DATA_DEFAULT_FLAGS vm_data_default_flags
