From: akpm@linux-foundation.org
Subject: + um-clean-up-vm-flagsh.patch added to -mm tree
Date: Fri, 17 Jun 2011 14:25:52 -0700
Message-ID: <201106172125.p5HLPqac001853@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751519Ab1FQV0j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Jun 2011 17:26:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@nod.at, mhocko@suse.cz, randy.dunlap@oracle.com


The patch titled
     um: clean up vm-flags.h
has been added to the -mm tree.  Its filename is
     um-clean-up-vm-flagsh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um: clean up vm-flags.h
From: Richard Weinberger <richard@nod.at>

There is no need to define VM_{STACK,DATA}_DEFAULT_FLAGS as variable. 
It's also useless to test for TIF_IA32 as 64bit UML has no IA32 emulation.

Signed-off-by: Richard Weinberger <richard@nod.at>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
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
