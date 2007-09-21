From: akpm@linux-foundation.org
Subject: + uml-eliminate-hz.patch added to -mm tree
Date: Thu, 20 Sep 2007 21:45:20 -0700
Message-ID: <200709210445.l8L4jKWx019091@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43391 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750841AbXIUEqG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 00:46:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com, tglx@linutronix.de


The patch titled
     uml: eliminate hz()
has been added to the -mm tree.  Its filename is
     uml-eliminate-hz.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: eliminate hz()
From: Jeff Dike <jdike@addtoit.com>

Eliminate hz() since its only purpose was to provide a kernel-space constant
to userspace code.  This can be done instead by providing the constant
directly through kernel_constants.h.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/common-offsets.h |    2 ++
 arch/um/include/kern_util.h      |    1 -
 arch/um/kernel/time.c            |    5 -----
 arch/um/os-Linux/skas/process.c  |    5 +++--
 arch/um/os-Linux/time.c          |    7 +++----
 5 files changed, 8 insertions(+), 12 deletions(-)

diff -puN arch/um/include/common-offsets.h~uml-eliminate-hz arch/um/include/common-offsets.h
--- a/arch/um/include/common-offsets.h~uml-eliminate-hz
+++ a/arch/um/include/common-offsets.h
@@ -32,3 +32,5 @@ DEFINE(UM_GFP_ATOMIC, GFP_ATOMIC);
 DEFINE(crypto_tfm_ctx_offset, offsetof(struct crypto_tfm, __crt_ctx));
 
 DEFINE(UM_THREAD_SIZE, THREAD_SIZE);
+
+DEFINE(UM_HZ, HZ);
diff -puN arch/um/include/kern_util.h~uml-eliminate-hz arch/um/include/kern_util.h
--- a/arch/um/include/kern_util.h~uml-eliminate-hz
+++ a/arch/um/include/kern_util.h
@@ -64,7 +64,6 @@ extern void paging_init(void);
 extern void init_flush_vm(void);
 extern void *syscall_sp(void *t);
 extern void syscall_trace(struct uml_pt_regs *regs, int entryexit);
-extern int hz(void);
 extern unsigned int do_IRQ(int irq, struct uml_pt_regs *regs);
 extern void interrupt_end(void);
 extern void initial_thread_cb(void (*proc)(void *), void *arg);
diff -puN arch/um/kernel/time.c~uml-eliminate-hz arch/um/kernel/time.c
--- a/arch/um/kernel/time.c~uml-eliminate-hz
+++ a/arch/um/kernel/time.c
@@ -11,11 +11,6 @@
 #include "kern_util.h"
 #include "os.h"
 
-int hz(void)
-{
-	return HZ;
-}
-
 /*
  * Scheduler clock - returns current time in nanosec units.
  */
diff -puN arch/um/os-Linux/skas/process.c~uml-eliminate-hz arch/um/os-Linux/skas/process.c
--- a/arch/um/os-Linux/skas/process.c~uml-eliminate-hz
+++ a/arch/um/os-Linux/skas/process.c
@@ -392,8 +392,9 @@ int copy_context_skas0(unsigned long new
 	*data = ((struct stub_data) { .offset	= MMAP_OFFSET(new_offset),
 				      .fd	= new_fd,
 				      .timer    = ((struct itimerval)
-					            { { 0, 1000000 / hz() },
-						      { 0, 1000000 / hz() }})});
+					            { { 0, 1000000 / UM_HZ },
+						      { 0, 1000000 / UM_HZ }})
+				 });
 	err = ptrace_setregs(pid, thread_regs);
 	if (err < 0)
 		panic("copy_context_skas0 : PTRACE_SETREGS failed, "
diff -puN arch/um/os-Linux/time.c~uml-eliminate-hz arch/um/os-Linux/time.c
--- a/arch/um/os-Linux/time.c~uml-eliminate-hz
+++ a/arch/um/os-Linux/time.c
@@ -8,14 +8,13 @@
 #include <signal.h>
 #include <time.h>
 #include <sys/time.h>
-#include "kern_util.h"
 #include "kern_constants.h"
 #include "os.h"
 #include "user.h"
 
 int set_interval(int is_virtual)
 {
-	int usec = 1000000/hz();
+	int usec = 1000000/UM_HZ;
 	int timer_type = is_virtual ? ITIMER_VIRTUAL : ITIMER_REAL;
 	struct itimerval interval = ((struct itimerval) { { 0, usec },
 							  { 0, usec } });
@@ -43,8 +42,8 @@ void disable_timer(void)
 void switch_timers(int to_real)
 {
 	struct itimerval disable = ((struct itimerval) { { 0, 0 }, { 0, 0 }});
-	struct itimerval enable = ((struct itimerval) { { 0, 1000000/hz() },
-							{ 0, 1000000/hz() }});
+	struct itimerval enable = ((struct itimerval) { { 0, 1000000/UM_HZ },
+							{ 0, 1000000/UM_HZ }});
 	int old, new;
 
 	if (to_real) {
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
uml-stop-saving-process-fp-state-fix.patch
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
uml-rename-pt_regs-general-purpose-register-file-fix.patch
uml-free-ldt-state-on-process-exit.patch
uml-remove-os_-usage-from-userspace-files.patch
uml-replace-clone-with-fork.patch
uml-fix-inlines.patch
uml-userspace-files-should-call-libc-directly.patch
uml-clean-up-tlb-flush-path.patch
uml-remove-unneeded-if-from-hostfs.patch
uml-fix-hostfs-style.patch
uml-dont-use-glibc-asm-userh.patch
uml-floating-point-signal-delivery-fixes.patch
uml-ptrace-floating-point-fixes.patch
uml-coredumping-floating-point-fixes.patch
uml-sysrq-and-mconsole-fixes.patch
uml-style-fixes-in-fp-code.patch
uml-eliminate-floating-point-state-from-register-file.patch
uml-remove-unused-file.patch
uml-more-idiomatic-parameter-parsing.patch
uml-eliminate-hz.patch
uml-fix-timer-switching.patch
uml-simplify-interval-setting.patch
uml-separate-timer-initialization.patch
uml-generic_time-support.patch
uml-generic_clockevents-support.patch
uml-clocksource-support.patch
uml-tickless-support.patch
uml-eliminate-interrupts-in-the-idle-loop.patch
uml-eliminate-sigalrm.patch
uml-use-sec_per_sec-constants.patch
bitops-introduce-lock-ops.patch
