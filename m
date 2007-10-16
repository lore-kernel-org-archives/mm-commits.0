From: akpm@linux-foundation.org
Subject: - uml-stop-specially-protecting-kernel-stacks.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:37:04 -0700
Message-ID: <200710162037.l9GKb49E015260@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54864 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754483AbXJPVHy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: stop specially protecting kernel stacks
has been removed from the -mm tree.  Its filename was
     uml-stop-specially-protecting-kernel-stacks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-kvm.patch
uml-header_ops-conversion-needed-for-non-ethernet-drivers.patch
bitops-introduce-lock-ops.patch
