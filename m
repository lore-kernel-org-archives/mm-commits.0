From: akpm@linux-foundation.org
Subject: + pid-namespaces-define-is_global_init-and-is_container_init.patch added to -mm tree
Date: Fri, 20 Jul 2007 15:41:39 -0700
Message-ID: <200707202241.l6KMfePC020283@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51777 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763212AbXGTWnQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 18:43:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: serue@us.ibm.com, clg@fr.ibm.com, dev@sw.ru, ebiederm@xmission.com, haveblue@us.ibm.com, herbert@13thfloor.at, sukadev@us.ibm.com, xemul@openvz.org


The patch titled
     pid namespaces: define is_global_init() and is_container_init()
has been added to the -mm tree.  Its filename is
     pid-namespaces-define-is_global_init-and-is_container_init.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pid namespaces: define is_global_init() and is_container_init()
From: Serge E. Hallyn <serue@us.ibm.com>

is_init() is an ambiguous name for the pid==1 check.  Split it into
is_global_init() and is_container_init().

A container init has it's tsk->pid == 1.

A global init also has it's tsk->pid == 1 and it's active pid namespace
is the init_pid_ns.  But rather than check the active pid namespace,
compare the task structure with 'init_pid_ns.child_reaper', which is
initialized during boot to the /sbin/init process and never changes.

Changelog:

	2.6.22-rc4-mm2-pidns1:
	- Use 'init_pid_ns.child_reaper' to determine if a given task is the
	  global init (/sbin/init) process. This would improve performance
	  and remove dependence on the task_pid().

	2.6.21-mm2-pidns2:

	- [Sukadev Bhattiprolu] Changed is_container_init() calls in {powerpc,
	  ppc,avr32}/traps.c for the _exception() call to is_global_init().
	  This way, we kill only the container if the container's init has a
	  bug rather than force a kernel panic.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Acked-by: Pavel Emelianov <xemul@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Herbert Poetzel <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/mm/fault.c                |    2 +-
 arch/arm/mm/fault.c                  |    2 +-
 arch/arm26/mm/fault.c                |    2 +-
 arch/avr32/kernel/traps.c            |    2 +-
 arch/avr32/mm/fault.c                |    6 +++---
 arch/i386/lib/usercopy.c             |    2 +-
 arch/i386/mm/fault.c                 |    2 +-
 arch/ia64/mm/fault.c                 |    2 +-
 arch/m68k/mm/fault.c                 |    2 +-
 arch/mips/mm/fault.c                 |    2 +-
 arch/powerpc/kernel/traps.c          |    2 +-
 arch/powerpc/mm/fault.c              |    2 +-
 arch/powerpc/platforms/pseries/ras.c |    2 +-
 arch/ppc/kernel/traps.c              |    2 +-
 arch/ppc/mm/fault.c                  |    2 +-
 arch/s390/lib/uaccess_pt.c           |    2 +-
 arch/s390/mm/fault.c                 |    2 +-
 arch/sh/mm/fault.c                   |    2 +-
 arch/sh64/mm/fault.c                 |    6 +++---
 arch/um/kernel/trap.c                |    2 +-
 arch/x86_64/mm/fault.c               |    2 +-
 arch/xtensa/mm/fault.c               |    2 +-
 drivers/char/sysrq.c                 |    2 +-
 include/linux/sched.h                |   12 ++++++++++--
 kernel/capability.c                  |    3 ++-
 kernel/exit.c                        |    2 +-
 kernel/kexec.c                       |    2 +-
 kernel/pid.c                         |    7 +++++++
 kernel/signal.c                      |    2 +-
 kernel/sysctl.c                      |    2 +-
 mm/oom_kill.c                        |    4 ++--
 security/commoncap.c                 |    3 ++-
 32 files changed, 54 insertions(+), 37 deletions(-)

diff -puN arch/alpha/mm/fault.c~pid-namespaces-define-is_global_init-and-is_container_init arch/alpha/mm/fault.c
--- a/arch/alpha/mm/fault.c~pid-namespaces-define-is_global_init-and-is_container_init
+++ a/arch/alpha/mm/fault.c
@@ -188,7 +188,7 @@ do_page_fault(unsigned long address, uns
 	/* We ran out of memory, or some other thing happened to us that
 	   made us unable to handle the page fault gracefully.  */
  out_of_memory:
-	if (is_init(current)) {
+	if (is_global_init(current)) {
 		yield();
 		down_read(&mm->mmap_sem);
 		goto survive;
diff -puN arch/arm/mm/fault.c~pid-namespaces-define-is_global_init-and-is_container_init arch/arm/mm/fault.c
--- a/arch/arm/mm/fault.c~pid-namespaces-define-is_global_init-and-is_container_init
+++ a/arch/arm/mm/fault.c
@@ -197,7 +197,7 @@ survive:
 	return fault;
 
 out_of_memory:
-	if (!is_init(tsk))
+	if (!is_global_init(tsk))
 		goto out;
 
 	/*
diff -puN arch/arm26/mm/fault.c~pid-namespaces-define-is_global_init-and-is_container_init arch/arm26/mm/fault.c
--- a/arch/arm26/mm/fault.c~pid-namespaces-define-is_global_init-and-is_container_init
+++ a/arch/arm26/mm/fault.c
@@ -185,7 +185,7 @@ survive:
 
 out_of_memory:
 	fault = -3; /* out of memory */
-	if (!is_init(tsk))
+	if (!is_global_init(tsk))
 		goto out;
 
 	/*
diff -puN arch/avr32/kernel/traps.c~pid-namespaces-define-is_global_init-and-is_container_init arch/avr32/kernel/traps.c
--- a/arch/avr32/kernel/traps.c~pid-namespaces-define-is_global_init-and-is_container_init
+++ a/arch/avr32/kernel/traps.c
@@ -89,7 +89,7 @@ void _exception(long signr, struct pt_re
 	 * generate the same exception over and over again and we get
 	 * nowhere.  Better to kill it and let the kernel panic.
 	 */
-	if (is_init(current)) {
+	if (is_global_init(current)) {
 		__sighandler_t handler;
 
 		spin_lock_irq(&current->sighand->siglock);
diff -puN arch/avr32/mm/fault.c~pid-namespaces-define-is_global_init-and-is_container_init arch/avr32/mm/fault.c
--- a/arch/avr32/mm/fault.c~pid-namespaces-define-is_global_init-and-is_container_init
+++ a/arch/avr32/mm/fault.c
@@ -160,7 +160,7 @@ bad_area:
 		if (exception_trace && printk_ratelimit())
 			printk("%s%s[%d]: segfault at %08lx pc %08lx "
 			       "sp %08lx ecr %lu\n",
-			       is_init(tsk) ? KERN_EMERG : KERN_INFO,
+			       is_global_init(tsk) ? KERN_EMERG : KERN_INFO,
 			       tsk->comm, tsk->pid, address, regs->pc,
 			       regs->sp, ecr);
 		_exception(SIGSEGV, regs, code, address);
@@ -209,7 +209,7 @@ no_context:
 	 */
 out_of_memory:
 	up_read(&mm->mmap_sem);
-	if (is_init(current)) {
+	if (is_global_init(current)) {
 		yield();
 		down_read(&mm->mmap_sem);
 		goto survive;
@@ -231,7 +231,7 @@ do_sigbus:
 	if (exception_trace)
 		printk("%s%s[%d]: bus error at %08lx pc %08lx "
 		       "sp %08lx ecr %lu\n",
-		       is_init(tsk) ? KERN_EMERG : KERN_INFO,
+		       is_global_init(tsk) ? KERN_EMERG : KERN_INFO,
 		       tsk->comm, tsk->pid, address, regs->pc,
 		       regs->sp, ecr);
 
diff -puN arch/i386/lib/usercopy.c~pid-namespaces-define-is_global_init-and-is_container_init arch/i386/lib/usercopy.c
--- a/arch/i386/lib/usercopy.c~pid-namespaces-define-is_global_init-and-is_container_init
+++ a/arch/i386/lib/usercopy.c
@@ -748,7 +748,7 @@ survive:
 			retval = get_user_pages(current, current->mm,
 					(unsigned long )to, 1, 1, 0, &pg, NULL);
 
-			if (retval == -ENOMEM && is_init(current)) {
+			if (retval == -ENOMEM && is_global_init(current)) {
 				up_read(&current->mm->mmap_sem);
 				congestion_wait(WRITE, HZ/50);
 				goto survive;
diff -puN arch/i386/mm/fault.c~pid-namespaces-define-is_global_init-and-is_container_init arch/i386/mm/fault.c
--- a/arch/i386/mm/fault.c~pid-namespaces-define-is_global_init-and-is_container_init
+++ a/arch/i386/mm/fault.c
@@ -594,7 +594,7 @@ no_context:
  */
 out_of_memory:
 	up_read(&mm->mmap_sem);
-	if (is_init(tsk)) {
+	if (is_global_init(tsk)) {
 		yield();
 		down_read(&mm->mmap_sem);
 		goto survive;
diff -puN arch/ia64/mm/fault.c~pid-namespaces-define-is_global_init-and-is_container_init arch/ia64/mm/fault.c
--- a/arch/ia64/mm/fault.c~pid-namespaces-define-is_global_init-and-is_container_init
+++ a/arch/ia64/mm/fault.c
@@ -270,7 +270,7 @@ ia64_do_page_fault (unsigned long addres
 
   out_of_memory:
 	up_read(&mm->mmap_sem);
-	if (is_init(current)) {
+	if (is_global_init(current)) {
 		yield();
 		down_read(&mm->mmap_sem);
 		goto survive;
diff -puN arch/m68k/mm/fault.c~pid-namespaces-define-is_global_init-and-is_container_init arch/m68k/mm/fault.c
--- a/arch/m68k/mm/fault.c~pid-namespaces-define-is_global_init-and-is_container_init
+++ a/arch/m68k/mm/fault.c
@@ -180,7 +180,7 @@ good_area:
  */
 out_of_memory:
 	up_read(&mm->mmap_sem);
-	if (is_init(current)) {
+	if (is_global_init(current)) {
 		yield();
 		down_read(&mm->mmap_sem);
 		goto survive;
diff -puN arch/mips/mm/fault.c~pid-namespaces-define-is_global_init-and-is_container_init arch/mips/mm/fault.c
--- a/arch/mips/mm/fault.c~pid-namespaces-define-is_global_init-and-is_container_init
+++ a/arch/mips/mm/fault.c
@@ -173,7 +173,7 @@ no_context:
  */
 out_of_memory:
 	up_read(&mm->mmap_sem);
-	if (is_init(tsk)) {
+	if (is_global_init(tsk)) {
 		yield();
 		down_read(&mm->mmap_sem);
 		goto survive;
diff -puN arch/powerpc/kernel/traps.c~pid-namespaces-define-is_global_init-and-is_container_init arch/powerpc/kernel/traps.c
--- a/arch/powerpc/kernel/traps.c~pid-namespaces-define-is_global_init-and-is_container_init
+++ a/arch/powerpc/kernel/traps.c
@@ -191,7 +191,7 @@ void _exception(int signr, struct pt_reg
 	 * generate the same exception over and over again and we get
 	 * nowhere.  Better to kill it and let the kernel panic.
 	 */
-	if (is_init(current)) {
+	if (is_global_init(current)) {
 		__sighandler_t handler;
 
 		spin_lock_irq(&current->sighand->siglock);
diff -puN arch/powerpc/mm/fault.c~pid-namespaces-define-is_global_init-and-is_container_init arch/powerpc/mm/fault.c
--- a/arch/powerpc/mm/fault.c~pid-namespaces-define-is_global_init-and-is_container_init
+++ a/arch/powerpc/mm/fault.c
@@ -370,7 +370,7 @@ bad_area_nosemaphore:
  */
 out_of_memory:
 	up_read(&mm->mmap_sem);
-	if (is_init(current)) {
+	if (is_global_init(current)) {
 		yield();
 		down_read(&mm->mmap_sem);
 		goto survive;
diff -puN arch/powerpc/platforms/pseries/ras.c~pid-namespaces-define-is_global_init-and-is_container_init arch/powerpc/platforms/pseries/ras.c
--- a/arch/powerpc/platforms/pseries/ras.c~pid-namespaces-define-is_global_init-and-is_container_init
+++ a/arch/powerpc/platforms/pseries/ras.c
@@ -332,7 +332,7 @@ static int recover_mce(struct pt_regs *r
 		   err->disposition == RTAS_DISP_NOT_RECOVERED &&
 		   err->target == RTAS_TARGET_MEMORY &&
 		   err->type == RTAS_TYPE_ECC_UNCORR &&
-		   !(current->pid == 0 || is_init(current))) {
+		   !(current->pid == 0 || is_global_init(current))) {
 		/* Kill off a user process with an ECC error */
 		printk(KERN_ERR "MCE: uncorrectable ecc error for pid %d\n",
 		       current->pid);
diff -puN arch/ppc/kernel/traps.c~pid-namespaces-define-is_global_init-and-is_container_init arch/ppc/kernel/traps.c
--- a/arch/ppc/kernel/traps.c~pid-namespaces-define-is_global_init-and-is_container_init
+++ a/arch/ppc/kernel/traps.c
@@ -121,7 +121,7 @@ void _exception(int signr, struct pt_reg
 	 * generate the same exception over and over again and we get
 	 * nowhere.  Better to kill it and let the kernel panic.
 	 */
-	if (is_init(current)) {
+	if (is_global_init(current)) {
 		__sighandler_t handler;
 
 		spin_lock_irq(&current->sighand->siglock);
diff -puN arch/ppc/mm/fault.c~pid-namespaces-define-is_global_init-and-is_container_init arch/ppc/mm/fault.c
--- a/arch/ppc/mm/fault.c~pid-namespaces-define-is_global_init-and-is_container_init
+++ a/arch/ppc/mm/fault.c
@@ -291,7 +291,7 @@ bad_area:
  */
 out_of_memory:
 	up_read(&mm->mmap_sem);
-	if (is_init(current)) {
+	if (is_global_init(current)) {
 		yield();
 		down_read(&mm->mmap_sem);
 		goto survive;
diff -puN arch/s390/lib/uaccess_pt.c~pid-namespaces-define-is_global_init-and-is_container_init arch/s390/lib/uaccess_pt.c
--- a/arch/s390/lib/uaccess_pt.c~pid-namespaces-define-is_global_init-and-is_container_init
+++ a/arch/s390/lib/uaccess_pt.c
@@ -64,7 +64,7 @@ out:
 
 out_of_memory:
 	up_read(&mm->mmap_sem);
-	if (is_init(current)) {
+	if (is_global_init(current)) {
 		yield();
 		down_read(&mm->mmap_sem);
 		goto survive;
diff -puN arch/s390/mm/fault.c~pid-namespaces-define-is_global_init-and-is_container_init arch/s390/mm/fault.c
--- a/arch/s390/mm/fault.c~pid-namespaces-define-is_global_init-and-is_container_init
+++ a/arch/s390/mm/fault.c
@@ -211,7 +211,7 @@ static int do_out_of_memory(struct pt_re
 	struct mm_struct *mm = tsk->mm;
 
 	up_read(&mm->mmap_sem);
-	if (is_init(tsk)) {
+	if (is_global_init(tsk)) {
 		yield();
 		down_read(&mm->mmap_sem);
 		return 1;
diff -puN arch/sh/mm/fault.c~pid-namespaces-define-is_global_init-and-is_container_init arch/sh/mm/fault.c
--- a/arch/sh/mm/fault.c~pid-namespaces-define-is_global_init-and-is_container_init
+++ a/arch/sh/mm/fault.c
@@ -203,7 +203,7 @@ no_context:
  */
 out_of_memory:
 	up_read(&mm->mmap_sem);
-	if (is_init(current)) {
+	if (is_global_init(current)) {
 		yield();
 		down_read(&mm->mmap_sem);
 		goto survive;
diff -puN arch/sh64/mm/fault.c~pid-namespaces-define-is_global_init-and-is_container_init arch/sh64/mm/fault.c
--- a/arch/sh64/mm/fault.c~pid-namespaces-define-is_global_init-and-is_container_init
+++ a/arch/sh64/mm/fault.c
@@ -278,7 +278,7 @@ bad_area:
 			show_regs(regs);
 #endif
 		}
-		if (is_init(tsk)) {
+		if (is_global_init(tsk)) {
 			panic("INIT had user mode bad_area\n");
 		}
 		tsk->thread.address = address;
@@ -320,14 +320,14 @@ no_context:
  * us unable to handle the page fault gracefully.
  */
 out_of_memory:
-	if (is_init(current)) {
+	if (is_global_init(current)) {
 		panic("INIT out of memory\n");
 		yield();
 		goto survive;
 	}
 	printk("fault:Out of memory\n");
 	up_read(&mm->mmap_sem);
-	if (is_init(current)) {
+	if (is_global_init(current)) {
 		yield();
 		down_read(&mm->mmap_sem);
 		goto survive;
diff -puN arch/um/kernel/trap.c~pid-namespaces-define-is_global_init-and-is_container_init arch/um/kernel/trap.c
--- a/arch/um/kernel/trap.c~pid-namespaces-define-is_global_init-and-is_container_init
+++ a/arch/um/kernel/trap.c
@@ -121,7 +121,7 @@ out_nosemaphore:
  * us unable to handle the page fault gracefully.
  */
 out_of_memory:
-	if (is_init(current)) {
+	if (is_global_init(current)) {
 		up_read(&mm->mmap_sem);
 		yield();
 		down_read(&mm->mmap_sem);
diff -puN arch/x86_64/mm/fault.c~pid-namespaces-define-is_global_init-and-is_container_init arch/x86_64/mm/fault.c
--- a/arch/x86_64/mm/fault.c~pid-namespaces-define-is_global_init-and-is_container_init
+++ a/arch/x86_64/mm/fault.c
@@ -557,7 +557,7 @@ no_context:
  */
 out_of_memory:
 	up_read(&mm->mmap_sem);
-	if (is_init(current)) {
+	if (is_global_init(current)) {
 		yield();
 		goto again;
 	}
diff -puN arch/xtensa/mm/fault.c~pid-namespaces-define-is_global_init-and-is_container_init arch/xtensa/mm/fault.c
--- a/arch/xtensa/mm/fault.c~pid-namespaces-define-is_global_init-and-is_container_init
+++ a/arch/xtensa/mm/fault.c
@@ -143,7 +143,7 @@ bad_area:
 	 */
 out_of_memory:
 	up_read(&mm->mmap_sem);
-	if (is_init(current)) {
+	if (is_global_init(current)) {
 		yield();
 		down_read(&mm->mmap_sem);
 		goto survive;
diff -puN drivers/char/sysrq.c~pid-namespaces-define-is_global_init-and-is_container_init drivers/char/sysrq.c
--- a/drivers/char/sysrq.c~pid-namespaces-define-is_global_init-and-is_container_init
+++ a/drivers/char/sysrq.c
@@ -250,7 +250,7 @@ static void send_sig_all(int sig)
 	struct task_struct *p;
 
 	for_each_process(p) {
-		if (p->mm && !is_init(p))
+		if (p->mm && !is_global_init(p))
 			/* Not swapper, init nor kernel thread */
 			force_sig(sig, p);
 	}
diff -puN include/linux/sched.h~pid-namespaces-define-is_global_init-and-is_container_init include/linux/sched.h
--- a/include/linux/sched.h~pid-namespaces-define-is_global_init-and-is_container_init
+++ a/include/linux/sched.h
@@ -1270,12 +1270,20 @@ static inline int pid_alive(struct task_
 }
 
 /**
- * is_init - check if a task structure is init
+ * is_global_init - check if a task structure is init
  * @tsk: Task structure to be checked.
  *
  * Check if a task structure is the first user space task the kernel created.
+ *
+ * TODO: We should inline this function after some cleanups in pid_namespace.h
+ */
+extern int is_global_init(struct task_struct *tsk);
+
+/*
+ * is_container_init:
+ * check whether in the task is init in it's own pid namespace.
  */
-static inline int is_init(struct task_struct *tsk)
+static inline int is_container_init(struct task_struct *tsk)
 {
 	return tsk->pid == 1;
 }
diff -puN kernel/capability.c~pid-namespaces-define-is_global_init-and-is_container_init kernel/capability.c
--- a/kernel/capability.c~pid-namespaces-define-is_global_init-and-is_container_init
+++ a/kernel/capability.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
+#include <linux/pid_namespace.h>
 #include <asm/uaccess.h>
 
 unsigned securebits = SECUREBITS_DEFAULT; /* systemwide security settings */
@@ -135,7 +136,7 @@ static inline int cap_set_all(kernel_cap
      int found = 0;
 
      do_each_thread(g, target) {
-             if (target == current || is_init(target))
+             if (target == current || is_container_init(target))
                      continue;
              found = 1;
 	     if (security_capset_check(target, effective, inheritable,
diff -puN kernel/exit.c~pid-namespaces-define-is_global_init-and-is_container_init kernel/exit.c
--- a/kernel/exit.c~pid-namespaces-define-is_global_init-and-is_container_init
+++ a/kernel/exit.c
@@ -231,7 +231,7 @@ static int will_become_orphaned_pgrp(str
 	do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
 		if (p == ignored_task
 				|| p->exit_state
-				|| is_init(p->real_parent))
+				|| is_global_init(p->real_parent))
 			continue;
 		if (task_pgrp(p->real_parent) != pgrp &&
 		    task_session(p->real_parent) == task_session(p)) {
diff -puN kernel/kexec.c~pid-namespaces-define-is_global_init-and-is_container_init kernel/kexec.c
--- a/kernel/kexec.c~pid-namespaces-define-is_global_init-and-is_container_init
+++ a/kernel/kexec.c
@@ -42,7 +42,7 @@ struct resource crashk_res = {
 
 int kexec_should_crash(struct task_struct *p)
 {
-	if (in_interrupt() || !p->pid || is_init(p) || panic_on_oops)
+	if (in_interrupt() || !p->pid || is_global_init(p) || panic_on_oops)
 		return 1;
 	return 0;
 }
diff -puN kernel/pid.c~pid-namespaces-define-is_global_init-and-is_container_init kernel/pid.c
--- a/kernel/pid.c~pid-namespaces-define-is_global_init-and-is_container_init
+++ a/kernel/pid.c
@@ -69,6 +69,13 @@ struct pid_namespace init_pid_ns = {
 	.last_pid = 0,
 	.child_reaper = &init_task
 };
+EXPORT_SYMBOL(init_pid_ns);
+
+int is_global_init(struct task_struct *tsk)
+{
+	return tsk == init_pid_ns.child_reaper;
+}
+EXPORT_SYMBOL(is_global_init);
 
 /*
  * Note: disable interrupts while the pidmap_lock is held as an
diff -puN kernel/signal.c~pid-namespaces-define-is_global_init-and-is_container_init kernel/signal.c
--- a/kernel/signal.c~pid-namespaces-define-is_global_init-and-is_container_init
+++ a/kernel/signal.c
@@ -257,7 +257,7 @@ flush_signal_handlers(struct task_struct
 
 int unhandled_signal(struct task_struct *tsk, int sig)
 {
-	if (is_init(tsk))
+	if (is_global_init(tsk))
 		return 1;
 	if (tsk->ptrace & PT_PTRACED)
 		return 0;
diff -puN kernel/sysctl.c~pid-namespaces-define-is_global_init-and-is_container_init kernel/sysctl.c
--- a/kernel/sysctl.c~pid-namespaces-define-is_global_init-and-is_container_init
+++ a/kernel/sysctl.c
@@ -1928,7 +1928,7 @@ int proc_dointvec_bset(ctl_table *table,
 		return -EPERM;
 	}
 
-	op = is_init(current) ? OP_SET : OP_AND;
+	op = is_global_init(current) ? OP_SET : OP_AND;
 	return do_proc_dointvec(table,write,filp,buffer,lenp,ppos,
 				do_proc_dointvec_bset_conv,&op);
 }
diff -puN mm/oom_kill.c~pid-namespaces-define-is_global_init-and-is_container_init mm/oom_kill.c
--- a/mm/oom_kill.c~pid-namespaces-define-is_global_init-and-is_container_init
+++ a/mm/oom_kill.c
@@ -222,7 +222,7 @@ static struct task_struct *select_bad_pr
 		if (!p->mm)
 			continue;
 		/* skip the init task */
-		if (is_init(p))
+		if (is_global_init(p))
 			continue;
 
 		/*
@@ -275,7 +275,7 @@ static struct task_struct *select_bad_pr
  */
 static void __oom_kill_task(struct task_struct *p, int verbose)
 {
-	if (is_init(p)) {
+	if (is_global_init(p)) {
 		WARN_ON(1);
 		printk(KERN_WARNING "tried to kill init!\n");
 		return;
diff -puN security/commoncap.c~pid-namespaces-define-is_global_init-and-is_container_init security/commoncap.c
--- a/security/commoncap.c~pid-namespaces-define-is_global_init-and-is_container_init
+++ a/security/commoncap.c
@@ -23,6 +23,7 @@
 #include <linux/xattr.h>
 #include <linux/hugetlb.h>
 #include <linux/mount.h>
+#include <linux/sched.h>
 
 int cap_netlink_send(struct sock *sk, struct sk_buff *skb)
 {
@@ -252,7 +253,7 @@ void cap_bprm_apply_creds (struct linux_
 	/* For init, we want to retain the capabilities set
 	 * in the init_task struct. Thus we skip the usual
 	 * capability rules */
-	if (!is_init(current)) {
+	if (!is_global_init(current)) {
 		current->cap_permitted = new_permitted;
 		current->cap_effective = bprm->cap_effective ?
 				new_permitted : 0;
_

Patches currently in -mm which might be from serue@us.ibm.com are

origin.patch
security-convert-lsm-into-a-static-interface.patch
security-convert-lsm-into-a-static-interface-fix.patch
implement-file-posix-capabilities.patch
implement-file-posix-capabilities-fix.patch
file-capabilities-introduce-cap_setfcap.patch
file-capabilities-get_file_caps-cleanups.patch
file-caps-update-selinux-xattr-hooks.patch
file-capabilities-clear-caps-cleanup.patch
file-capabilities-clear-caps-cleanup-fix.patch
file-capabilities-change-xattr-format-v2.patch
file-capabilities-change-fe-to-a-bool.patch
file-caps-clean-up-for-linux-capabilityh.patch
capabilityh-remove-include-of-currenth.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
task-containersv11-basic-task-container-framework.patch
task-containersv11-add-tasks-file-interface.patch
task-containersv11-add-fork-exit-hooks.patch
task-containersv11-add-container_clone-interface.patch
task-containersv11-add-procfs-interface.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
task-containersv11-automatic-userspace-notification-of-idle-containers.patch
task-containersv11-make-cpusets-a-client-of-containers.patch
task-containersv11-example-cpu-accounting-subsystem.patch
task-containersv11-simple-task-container-debug-info-subsystem.patch
containers-implement-namespace-tracking-subsystem.patch
pid-namespaces-round-up-the-api.patch
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
