From: akpm@linux-foundation.org
Subject: - uml-eliminate-hz.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:38:36 -0700
Message-ID: <200710162038.l9GKcaqn015463@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39290 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933622AbXJPVX5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:23:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     uml: eliminate hz()
has been removed from the -mm tree.  Its filename was
     uml-eliminate-hz.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-kvm.patch
uml-header_ops-conversion-needed-for-non-ethernet-drivers.patch
bitops-introduce-lock-ops.patch
