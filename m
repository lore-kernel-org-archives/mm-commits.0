From: akpm@linux-foundation.org
Subject: + uml-stop-specially-protecting-kernel-stacks.patch added to -mm tree
Date: Mon, 06 Aug 2007 12:50:19 -0700
Message-ID: <200708061950.l76JoJoD011793@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47791 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758753AbXHFTub (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 15:50:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: stop specially protecting kernel stacks
has been added to the -mm tree.  Its filename is
     uml-stop-specially-protecting-kernel-stacks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: stop specially protecting kernel stacks
From: Jeff Dike <jdike@addtoit.com>

Map all of physical memory as executable to avoid having to change stack
protections during fork and exit.

unprotect_stack is now called only from MODE_TT code, so it is marked as such.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/kern_util.h |    2 ++
 arch/um/kernel/init_task.c  |    2 ++
 arch/um/kernel/physmem.c    |    2 +-
 arch/um/kernel/process.c    |    5 ++---
 4 files changed, 7 insertions(+), 4 deletions(-)

diff -puN arch/um/include/kern_util.h~uml-stop-specially-protecting-kernel-stacks arch/um/include/kern_util.h
--- a/arch/um/include/kern_util.h~uml-stop-specially-protecting-kernel-stacks
+++ a/arch/um/include/kern_util.h
@@ -82,7 +82,9 @@ extern void check_stack_overflow(void *p
 extern void relay_signal(int sig, union uml_pt_regs *regs);
 extern int user_context(unsigned long sp);
 extern void timer_irq(union uml_pt_regs *regs);
+#ifdef CONFIG_MODE_TT
 extern void unprotect_stack(unsigned long stack);
+#endif
 extern void do_uml_exitcalls(void);
 extern int attach_debugger(int idle_pid, int pid, int stop);
 extern int config_gdb(char *str);
diff -puN arch/um/kernel/init_task.c~uml-stop-specially-protecting-kernel-stacks arch/um/kernel/init_task.c
--- a/arch/um/kernel/init_task.c~uml-stop-specially-protecting-kernel-stacks
+++ a/arch/um/kernel/init_task.c
@@ -47,7 +47,9 @@ union thread_union cpu0_irqstack
 	__attribute__((__section__(".data.init_irqstack"))) =
 		{ INIT_THREAD_INFO(init_task) };
 
+#ifdef CONFIG_MODE_TT
 void unprotect_stack(unsigned long stack)
 {
 	os_protect_memory((void *) stack, THREAD_SIZE, 1, 1, 0);
 }
+#endif
diff -puN arch/um/kernel/physmem.c~uml-stop-specially-protecting-kernel-stacks arch/um/kernel/physmem.c
--- a/arch/um/kernel/physmem.c~uml-stop-specially-protecting-kernel-stacks
+++ a/arch/um/kernel/physmem.c
@@ -105,7 +105,7 @@ void __init setup_physmem(unsigned long 
 
 	offset = uml_reserved - uml_physmem;
 	err = os_map_memory((void *) uml_reserved, physmem_fd, offset,
-			    len - offset, 1, 1, 0);
+			    len - offset, 1, 1, 1);
 	if(err < 0){
 		os_print_error(err, "Mapping memory");
 		exit(1);
diff -puN arch/um/kernel/process.c~uml-stop-specially-protecting-kernel-stacks arch/um/kernel/process.c
--- a/arch/um/kernel/process.c~uml-stop-specially-protecting-kernel-stacks
+++ a/arch/um/kernel/process.c
@@ -82,9 +82,9 @@ unsigned long alloc_stack(int order, int
 	if (atomic)
 		flags = GFP_ATOMIC;
 	page = __get_free_pages(flags, order);
-	if(page == 0)
+	if (page == 0)
 		return 0;
-	stack_protections(page);
+
 	return page;
 }
 
@@ -141,7 +141,6 @@ void release_thread(struct task_struct *
 
 void exit_thread(void)
 {
-	unprotect_stack((unsigned long) current_thread);
 }
 
 void *get_current(void)
_

Patches currently in -mm which might be from jdike@addtoit.com are

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
