From: akpm@linux-foundation.org
Subject: [merged] panic-change-nmi_panic-from-macro-to-function.patch
 removed from -mm tree
Date: Wed, 23 Mar 2016 10:42:18 -0700
Message-ID: <56f2d57a.9QBiywz7ORX13xhL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59329 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756516AbcCWRmT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:42:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidehiro.kawai.ez@hitachi.com, bp@suse.de, d.hatayama@jp.fujitsu.com, gobinda.cemk07@gmail.com, javi.merino@arm.com, linux@rasmusvillemoes.dk, mhocko@suse.com, mina86@mina86.com, nicolas.iooss_linux@m4x.org, rostedt@goodmis.org, tglx@linutronix.de, tj@kernel.org, vkuznets@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: panic: change nmi_panic from macro to function
has been removed from the -mm tree.  Its filename was
     panic-change-nmi_panic-from-macro-to-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: panic: change nmi_panic from macro to function

commit 1717f2096b54 ("panic, x86: Fix re-entrance problem due to panic on
NMI") and commit 58c5661f2144 ("panic, x86: Allow CPUs to save registers
even if looping in NMI context") introduced nmi_panic() which prevents
concurrent/recursive execution of panic().  It also saves registers for
the crash dump on x86.

However, there are some cases where NMI handlers still use panic().  This
patch set partially replaces them with nmi_panic() in those cases.

Even this patchset is applied, some NMI or similar handlers (e.g.  MCE
handler) continue to use panic().  This is because I can't test them well
and actual problems won't happen.  For example, the possibility that
normal panic and panic on MCE happen simultaneously is very low.


This patch (of 3):

Convert nmi_panic() to a proper function and export it instead of
exporting internal implementation details to modules, for obvious
reasons.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Acked-by: Borislav Petkov <bp@suse.de>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Cc: Javi Merino <javi.merino@arm.com>
Cc: Gobinda Charan Maji <gobinda.cemk07@gmail.com>
Cc: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |   21 +--------------------
 kernel/panic.c         |   20 ++++++++++++++++++++
 2 files changed, 21 insertions(+), 20 deletions(-)

diff -puN include/linux/kernel.h~panic-change-nmi_panic-from-macro-to-function include/linux/kernel.h
--- a/include/linux/kernel.h~panic-change-nmi_panic-from-macro-to-function
+++ a/include/linux/kernel.h
@@ -255,7 +255,7 @@ extern long (*panic_blink)(int state);
 __printf(1, 2)
 void panic(const char *fmt, ...)
 	__noreturn __cold;
-void nmi_panic_self_stop(struct pt_regs *);
+void nmi_panic(struct pt_regs *regs, const char *msg);
 extern void oops_enter(void);
 extern void oops_exit(void);
 void print_oops_end_marker(void);
@@ -457,25 +457,6 @@ extern atomic_t panic_cpu;
 #define PANIC_CPU_INVALID	-1
 
 /*
- * A variant of panic() called from NMI context. We return if we've already
- * panicked on this CPU. If another CPU already panicked, loop in
- * nmi_panic_self_stop() which can provide architecture dependent code such
- * as saving register state for crash dump.
- */
-#define nmi_panic(regs, fmt, ...)					\
-do {									\
-	int old_cpu, cpu;						\
-									\
-	cpu = raw_smp_processor_id();					\
-	old_cpu = atomic_cmpxchg(&panic_cpu, PANIC_CPU_INVALID, cpu);	\
-									\
-	if (old_cpu == PANIC_CPU_INVALID)				\
-		panic(fmt, ##__VA_ARGS__);				\
-	else if (old_cpu != cpu)					\
-		nmi_panic_self_stop(regs);				\
-} while (0)
-
-/*
  * Only to be used by arch init code. If the user over-wrote the default
  * CONFIG_PANIC_TIMEOUT, honor it.
  */
diff -puN kernel/panic.c~panic-change-nmi_panic-from-macro-to-function kernel/panic.c
--- a/kernel/panic.c~panic-change-nmi_panic-from-macro-to-function
+++ a/kernel/panic.c
@@ -73,6 +73,26 @@ void __weak nmi_panic_self_stop(struct p
 
 atomic_t panic_cpu = ATOMIC_INIT(PANIC_CPU_INVALID);
 
+/*
+ * A variant of panic() called from NMI context. We return if we've already
+ * panicked on this CPU. If another CPU already panicked, loop in
+ * nmi_panic_self_stop() which can provide architecture dependent code such
+ * as saving register state for crash dump.
+ */
+void nmi_panic(struct pt_regs *regs, const char *msg)
+{
+	int old_cpu, cpu;
+
+	cpu = raw_smp_processor_id();
+	old_cpu = atomic_cmpxchg(&panic_cpu, PANIC_CPU_INVALID, cpu);
+
+	if (old_cpu == PANIC_CPU_INVALID)
+		panic("%s", msg);
+	else if (old_cpu != cpu)
+		nmi_panic_self_stop(regs);
+}
+EXPORT_SYMBOL(nmi_panic);
+
 /**
  *	panic - halt the system
  *	@fmt: The text string to print
_

Patches currently in -mm which might be from hidehiro.kawai.ez@hitachi.com are


