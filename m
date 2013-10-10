From: akpm@linux-foundation.org
Subject: + x86-move-fpu_counter-into-arch-specific-thread_struct.patch
 added to -mm tree
Date: Thu, 10 Oct 2013 14:40:13 -0700
Message-ID: <52571ebd.14srexR+03kERROt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38351 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756303Ab3JJVkO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Oct 2013 17:40:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgupta@synopsys.com, paul.mundt@gmail.com, mingo@kernel.org, Vineet.Gupta1@synopsys.com

Subject: + x86-move-fpu_counter-into-arch-specific-thread_struct.patch added to -mm tree
To: Vineet.Gupta1@synopsys.com,mingo@kernel.org,paul.mundt@gmail.com,vgupta@synopsys.com
From: akpm@linux-foundation.org
Date: Thu, 10 Oct 2013 14:40:13 -0700


The patch titled
     Subject: x86: move fpu_counter into ARCH specific thread_struct
has been added to the -mm tree.  Its filename is
     x86-move-fpu_counter-into-arch-specific-thread_struct.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-move-fpu_counter-into-arch-specific-thread_struct.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-move-fpu_counter-into-arch-specific-thread_struct.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: x86: move fpu_counter into ARCH specific thread_struct

Only a couple of arches (sh/x86) use fpu_counter in task_struct so it can
be moved out into ARCH specific thread_struct, reducing the size of
task_struct for other arches.

Compile tested i386_defconfig + gcc 4.7.3

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mundt <paul.mundt@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/fpu-internal.h |   10 +++++-----
 arch/x86/include/asm/processor.h    |    9 +++++++++
 arch/x86/kernel/i387.c              |    2 +-
 arch/x86/kernel/process_32.c        |    4 ++--
 arch/x86/kernel/process_64.c        |    2 +-
 arch/x86/kernel/traps.c             |    2 +-
 6 files changed, 19 insertions(+), 10 deletions(-)

diff -puN arch/x86/include/asm/fpu-internal.h~x86-move-fpu_counter-into-arch-specific-thread_struct arch/x86/include/asm/fpu-internal.h
--- a/arch/x86/include/asm/fpu-internal.h~x86-move-fpu_counter-into-arch-specific-thread_struct
+++ a/arch/x86/include/asm/fpu-internal.h
@@ -365,7 +365,7 @@ static inline void drop_fpu(struct task_
 	 * Forget coprocessor state..
 	 */
 	preempt_disable();
-	tsk->fpu_counter = 0;
+	tsk->thread.fpu_counter = 0;
 	__drop_fpu(tsk);
 	clear_used_math();
 	preempt_enable();
@@ -424,7 +424,7 @@ static inline fpu_switch_t switch_fpu_pr
 	 * or if the past 5 consecutive context-switches used math.
 	 */
 	fpu.preload = tsk_used_math(new) && (use_eager_fpu() ||
-					     new->fpu_counter > 5);
+					     new->thread.fpu_counter > 5);
 	if (__thread_has_fpu(old)) {
 		if (!__save_init_fpu(old))
 			cpu = ~0;
@@ -433,16 +433,16 @@ static inline fpu_switch_t switch_fpu_pr
 
 		/* Don't change CR0.TS if we just switch! */
 		if (fpu.preload) {
-			new->fpu_counter++;
+			new->thread.fpu_counter++;
 			__thread_set_has_fpu(new);
 			prefetch(new->thread.fpu.state);
 		} else if (!use_eager_fpu())
 			stts();
 	} else {
-		old->fpu_counter = 0;
+		old->thread.fpu_counter = 0;
 		old->thread.fpu.last_cpu = ~0;
 		if (fpu.preload) {
-			new->fpu_counter++;
+			new->thread.fpu_counter++;
 			if (!use_eager_fpu() && fpu_lazy_restore(new, cpu))
 				fpu.preload = 0;
 			else
diff -puN arch/x86/include/asm/processor.h~x86-move-fpu_counter-into-arch-specific-thread_struct arch/x86/include/asm/processor.h
--- a/arch/x86/include/asm/processor.h~x86-move-fpu_counter-into-arch-specific-thread_struct
+++ a/arch/x86/include/asm/processor.h
@@ -488,6 +488,15 @@ struct thread_struct {
 	unsigned long		iopl;
 	/* Max allowed port in the bitmap, in bytes: */
 	unsigned		io_bitmap_max;
+	/*
+	 * fpu_counter contains the number of consecutive context switches
+	 * that the FPU is used. If this is over a threshold, the lazy fpu
+	 * saving becomes unlazy to save the trap. This is an unsigned char
+	 * so that after 256 times the counter wraps and the behavior turns
+	 * lazy again; this to deal with bursty apps that only use FPU for
+	 * a short time
+	 */
+	unsigned char fpu_counter;
 };
 
 /*
diff -puN arch/x86/kernel/i387.c~x86-move-fpu_counter-into-arch-specific-thread_struct arch/x86/kernel/i387.c
--- a/arch/x86/kernel/i387.c~x86-move-fpu_counter-into-arch-specific-thread_struct
+++ a/arch/x86/kernel/i387.c
@@ -100,7 +100,7 @@ void unlazy_fpu(struct task_struct *tsk)
 		__save_init_fpu(tsk);
 		__thread_fpu_end(tsk);
 	} else
-		tsk->fpu_counter = 0;
+		tsk->thread.fpu_counter = 0;
 	preempt_enable();
 }
 EXPORT_SYMBOL(unlazy_fpu);
diff -puN arch/x86/kernel/process_32.c~x86-move-fpu_counter-into-arch-specific-thread_struct arch/x86/kernel/process_32.c
--- a/arch/x86/kernel/process_32.c~x86-move-fpu_counter-into-arch-specific-thread_struct
+++ a/arch/x86/kernel/process_32.c
@@ -153,7 +153,7 @@ int copy_thread(unsigned long clone_flag
 		childregs->orig_ax = -1;
 		childregs->cs = __KERNEL_CS | get_kernel_rpl();
 		childregs->flags = X86_EFLAGS_IF | X86_EFLAGS_FIXED;
-		p->fpu_counter = 0;
+		p->thread.fpu_counter = 0;
 		p->thread.io_bitmap_ptr = NULL;
 		memset(p->thread.ptrace_bps, 0, sizeof(p->thread.ptrace_bps));
 		return 0;
@@ -166,7 +166,7 @@ int copy_thread(unsigned long clone_flag
 	p->thread.ip = (unsigned long) ret_from_fork;
 	task_user_gs(p) = get_user_gs(current_pt_regs());
 
-	p->fpu_counter = 0;
+	p->thread.fpu_counter = 0;
 	p->thread.io_bitmap_ptr = NULL;
 	tsk = current;
 	err = -ENOMEM;
diff -puN arch/x86/kernel/process_64.c~x86-move-fpu_counter-into-arch-specific-thread_struct arch/x86/kernel/process_64.c
--- a/arch/x86/kernel/process_64.c~x86-move-fpu_counter-into-arch-specific-thread_struct
+++ a/arch/x86/kernel/process_64.c
@@ -163,7 +163,7 @@ int copy_thread(unsigned long clone_flag
 	p->thread.sp = (unsigned long) childregs;
 	p->thread.usersp = me->thread.usersp;
 	set_tsk_thread_flag(p, TIF_FORK);
-	p->fpu_counter = 0;
+	p->thread.fpu_counter = 0;
 	p->thread.io_bitmap_ptr = NULL;
 
 	savesegment(gs, p->thread.gsindex);
diff -puN arch/x86/kernel/traps.c~x86-move-fpu_counter-into-arch-specific-thread_struct arch/x86/kernel/traps.c
--- a/arch/x86/kernel/traps.c~x86-move-fpu_counter-into-arch-specific-thread_struct
+++ a/arch/x86/kernel/traps.c
@@ -653,7 +653,7 @@ void math_state_restore(void)
 		return;
 	}
 
-	tsk->fpu_counter++;
+	tsk->thread.fpu_counter++;
 }
 EXPORT_SYMBOL_GPL(math_state_restore);
 
_

Patches currently in -mm which might be from Vineet.Gupta1@synopsys.com are

sh-move-fpu_counter-into-arch-specific-thread_struct.patch
x86-move-fpu_counter-into-arch-specific-thread_struct.patch
sched-remove-arch-specific-fpu_counter-from-task_struct.patch

