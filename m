From: akpm@linux-foundation.org
Subject: - uml-use-um_thread_size-in-userspace-code.patch removed from -mm tree
Date: Fri, 11 May 2007 22:33:24 -0700
Message-ID: <200705120533.l4C5XOKc002102@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44206 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752573AbXELFda (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:33:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: use UM_THREAD_SIZE in userspace code
has been removed from the -mm tree.  Its filename was
     uml-use-um_thread_size-in-userspace-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: use UM_THREAD_SIZE in userspace code
From: Jeff Dike <jdike@addtoit.com>

Now that we have UM_THREAD_SIZE, we can replace the calculations in
user-space code (an earlier patch took care of the kernel side of the
house).

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/init_task.c      |    3 +--
 arch/um/os-Linux/skas/process.c |    7 +++----
 2 files changed, 4 insertions(+), 6 deletions(-)

diff -puN arch/um/kernel/init_task.c~uml-use-um_thread_size-in-userspace-code arch/um/kernel/init_task.c
--- a/arch/um/kernel/init_task.c~uml-use-um_thread_size-in-userspace-code
+++ a/arch/um/kernel/init_task.c
@@ -44,8 +44,7 @@ __attribute__((__section__(".data.init_t
 
 void unprotect_stack(unsigned long stack)
 {
-	os_protect_memory((void *) stack, (1 << CONFIG_KERNEL_STACK_ORDER) * PAGE_SIZE,
-		       1, 1, 0);
+	os_protect_memory((void *) stack, THREAD_SIZE, 1, 1, 0);
 }
 
 /*
diff -puN arch/um/os-Linux/skas/process.c~uml-use-um_thread_size-in-userspace-code arch/um/os-Linux/skas/process.c
--- a/arch/um/os-Linux/skas/process.c~uml-use-um_thread_size-in-userspace-code
+++ a/arch/um/os-Linux/skas/process.c
@@ -490,8 +490,8 @@ void map_stub_pages(int fd, unsigned lon
 void new_thread(void *stack, jmp_buf *buf, void (*handler)(void))
 {
 	(*buf)[0].JB_IP = (unsigned long) handler;
-	(*buf)[0].JB_SP = (unsigned long) stack +
-		(PAGE_SIZE << UML_CONFIG_KERNEL_STACK_ORDER) - sizeof(void *);
+	(*buf)[0].JB_SP = (unsigned long) stack + UM_THREAD_SIZE -
+		sizeof(void *);
 }
 
 #define INIT_JMP_NEW_THREAD 0
@@ -533,8 +533,7 @@ int start_idle_thread(void *stack, jmp_b
 	case INIT_JMP_NEW_THREAD:
 		(*switch_buf)[0].JB_IP = (unsigned long) new_thread_handler;
 		(*switch_buf)[0].JB_SP = (unsigned long) stack +
-			(PAGE_SIZE << UML_CONFIG_KERNEL_STACK_ORDER) -
-			sizeof(void *);
+			UM_THREAD_SIZE - sizeof(void *);
 		break;
 	case INIT_JMP_CALLBACK:
 		(*cb_proc)(cb_arg);
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
