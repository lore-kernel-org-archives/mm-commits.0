From: akpm@linux-foundation.org
Subject: + uml-remove-task_protections.patch added to -mm tree
Date: Wed, 09 May 2007 21:07:56 -0700
Message-ID: <200705100407.l4A47uJa011600@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757150AbXEJEIB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 00:08:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: remove task_protections
has been added to the -mm tree.  Its filename is
     uml-remove-task_protections.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: remove task_protections
From: Jeff Dike <jdike@addtoit.com>

Replaced task_protections with stack_protections since they do the same
thing, and task_protections was misnamed anyway.

This needs THREAD_SIZE, so that's imported via common-offsets.h

Also tidied up the code in the vicinity.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/common-offsets.h |    2 ++
 arch/um/include/os.h             |    1 -
 arch/um/kernel/tt/exec_kern.c    |    2 +-
 arch/um/kernel/tt/process_kern.c |    2 +-
 arch/um/kernel/um_arch.c         |    2 +-
 arch/um/os-Linux/util.c          |   23 +++--------------------
 6 files changed, 8 insertions(+), 24 deletions(-)

diff -puN arch/um/include/common-offsets.h~uml-remove-task_protections arch/um/include/common-offsets.h
--- a/arch/um/include/common-offsets.h~uml-remove-task_protections
+++ a/arch/um/include/common-offsets.h
@@ -28,3 +28,5 @@ DEFINE(UM_NR_CPUS, NR_CPUS);
 
 /* For crypto assembler code. */
 DEFINE(crypto_tfm_ctx_offset, offsetof(struct crypto_tfm, __crt_ctx));
+
+DEFINE(UM_THREAD_SIZE, THREAD_SIZE);
diff -puN arch/um/include/os.h~uml-remove-task_protections arch/um/include/os.h
--- a/arch/um/include/os.h~uml-remove-task_protections
+++ a/arch/um/include/os.h
@@ -272,7 +272,6 @@ extern void do_longjmp(void *p, int val)
 
 /* util.c */
 extern void stack_protections(unsigned long address);
-extern void task_protections(unsigned long address);
 extern int raw(int fd);
 extern void setup_machinename(char *machine_out);
 extern void setup_hostinfo(char *buf, int len);
diff -puN arch/um/kernel/tt/exec_kern.c~uml-remove-task_protections arch/um/kernel/tt/exec_kern.c
--- a/arch/um/kernel/tt/exec_kern.c~uml-remove-task_protections
+++ a/arch/um/kernel/tt/exec_kern.c
@@ -57,7 +57,7 @@ void flush_thread_tt(void)
 	enable_timer();
 	free_page(stack);
 	protect_memory(uml_reserved, high_physmem - uml_reserved, 1, 1, 0, 1);
-	task_protections((unsigned long) current_thread);
+	stack_protections((unsigned long) current_thread);
 	force_flush_all();
 	unblock_signals();
 }
diff -puN arch/um/kernel/tt/process_kern.c~uml-remove-task_protections arch/um/kernel/tt/process_kern.c
--- a/arch/um/kernel/tt/process_kern.c~uml-remove-task_protections
+++ a/arch/um/kernel/tt/process_kern.c
@@ -209,7 +209,7 @@ void finish_fork_handler(int sig)
 	if(current->mm != current->parent->mm)
 		protect_memory(uml_reserved, high_physmem - uml_reserved, 1, 
 			       1, 0, 1);
-	task_protections((unsigned long) current_thread);
+	stack_protections((unsigned long) current_thread);
 
 	free_page(current->thread.temp_stack);
 	local_irq_disable();
diff -puN arch/um/kernel/um_arch.c~uml-remove-task_protections arch/um/kernel/um_arch.c
--- a/arch/um/kernel/um_arch.c~uml-remove-task_protections
+++ a/arch/um/kernel/um_arch.c
@@ -459,7 +459,7 @@ int __init linux_main(int argc, char **a
 
 	uml_postsetup();
 
-	task_protections((unsigned long) &init_thread_info);
+	stack_protections((unsigned long) &init_thread_info);
 	os_flush_stdout();
 
 	return CHOOSE_MODE(start_uml_tt(), start_uml_skas());
diff -puN arch/um/os-Linux/util.c~uml-remove-task_protections arch/um/os-Linux/util.c
--- a/arch/um/os-Linux/util.c~uml-remove-task_protections
+++ a/arch/um/os-Linux/util.c
@@ -33,25 +33,8 @@
 
 void stack_protections(unsigned long address)
 {
-	int prot = PROT_READ | PROT_WRITE | PROT_EXEC;
-
-	if(mprotect((void *) address, UM_KERN_PAGE_SIZE, prot) < 0)
-		panic("protecting stack failed, errno = %d", errno);
-}
-
-void task_protections(unsigned long address)
-{
-	unsigned long guard = address + UM_KERN_PAGE_SIZE;
-	unsigned long stack = guard + UM_KERN_PAGE_SIZE;
-	int prot = 0, pages;
-
-#ifdef notdef
-	if(mprotect((void *) stack, UM_KERN_PAGE_SIZE, prot) < 0)
-		panic("protecting guard page failed, errno = %d", errno);
-#endif
-	pages = (1 << UML_CONFIG_KERNEL_STACK_ORDER) - 2;
-	prot = PROT_READ | PROT_WRITE | PROT_EXEC;
-	if(mprotect((void *) stack, pages * UM_KERN_PAGE_SIZE, prot) < 0)
+	if(mprotect((void *) address, UM_THREAD_SIZE,
+		    PROT_READ | PROT_WRITE | PROT_EXEC) < 0)
 		panic("protecting stack failed, errno = %d", errno);
 }
 
@@ -72,7 +55,7 @@ int raw(int fd)
 
 	/* XXX tcsetattr could have applied only some changes
 	 * (and cfmakeraw() is a set of changes) */
-	return(0);
+	return 0;
 }
 
 void setup_machinename(char *machine_out)
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-remove-task_protections.patch
uml-use-um_thread_size-in-userspace-code.patch
uml-tidy-irq-code.patch
uml-irq-stacks.patch
uml-monitor-stack-usage.patch
uml-shrink-kernel-stacks.patch
