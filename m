From: akpm@linux-foundation.org
Subject: [merged]
 sh-move-fpu_counter-into-arch-specific-thread_struct.patch removed from -mm tree
Date: Wed, 13 Nov 2013 12:40:06 -0800
Message-ID: <5283e3a6.dx3sFalddhOeIA9x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42884 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab3KMUkH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:40:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgupta@synopsys.com, paul.mundt@gmail.com, mingo@kernel.org, Vineet.Gupta1@synopsys.com

Subject: [merged] sh-move-fpu_counter-into-arch-specific-thread_struct.patch removed from -mm tree
To: Vineet.Gupta1@synopsys.com,mingo@kernel.org,paul.mundt@gmail.com,vgupta@synopsys.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:40:06 -0800


The patch titled
     Subject: sh: move fpu_counter into ARCH specific thread_struct
has been removed from the -mm tree.  Its filename was
     sh-move-fpu_counter-into-arch-specific-thread_struct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: sh: move fpu_counter into ARCH specific thread_struct

Only a couple of arches (sh/x86) use fpu_counter in task_struct so it can
be moved out into ARCH specific thread_struct, reducing the size of
task_struct for other arches.

Compile tested sh defconfig + sh4-linux-gcc (4.6.3)

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Paul Mundt <paul.mundt@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/fpu.h          |    2 +-
 arch/sh/include/asm/processor_32.h |   10 ++++++++++
 arch/sh/include/asm/processor_64.h |   10 ++++++++++
 arch/sh/kernel/cpu/fpu.c           |    2 +-
 arch/sh/kernel/process_32.c        |    6 +++---
 5 files changed, 25 insertions(+), 5 deletions(-)

diff -puN arch/sh/include/asm/fpu.h~sh-move-fpu_counter-into-arch-specific-thread_struct arch/sh/include/asm/fpu.h
--- a/arch/sh/include/asm/fpu.h~sh-move-fpu_counter-into-arch-specific-thread_struct
+++ a/arch/sh/include/asm/fpu.h
@@ -46,7 +46,7 @@ static inline void __unlazy_fpu(struct t
 		save_fpu(tsk);
 		release_fpu(regs);
 	} else
-		tsk->fpu_counter = 0;
+		tsk->thread.fpu_counter = 0;
 }
 
 static inline void unlazy_fpu(struct task_struct *tsk, struct pt_regs *regs)
diff -puN arch/sh/include/asm/processor_32.h~sh-move-fpu_counter-into-arch-specific-thread_struct arch/sh/include/asm/processor_32.h
--- a/arch/sh/include/asm/processor_32.h~sh-move-fpu_counter-into-arch-specific-thread_struct
+++ a/arch/sh/include/asm/processor_32.h
@@ -111,6 +111,16 @@ struct thread_struct {
 
 	/* Extended processor state */
 	union thread_xstate *xstate;
+
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
 
 #define INIT_THREAD  {						\
diff -puN arch/sh/include/asm/processor_64.h~sh-move-fpu_counter-into-arch-specific-thread_struct arch/sh/include/asm/processor_64.h
--- a/arch/sh/include/asm/processor_64.h~sh-move-fpu_counter-into-arch-specific-thread_struct
+++ a/arch/sh/include/asm/processor_64.h
@@ -126,6 +126,16 @@ struct thread_struct {
 
 	/* floating point info */
 	union thread_xstate *xstate;
+
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
 
 #define INIT_MMAP \
diff -puN arch/sh/kernel/cpu/fpu.c~sh-move-fpu_counter-into-arch-specific-thread_struct arch/sh/kernel/cpu/fpu.c
--- a/arch/sh/kernel/cpu/fpu.c~sh-move-fpu_counter-into-arch-specific-thread_struct
+++ a/arch/sh/kernel/cpu/fpu.c
@@ -44,7 +44,7 @@ void __fpu_state_restore(void)
 	restore_fpu(tsk);
 
 	task_thread_info(tsk)->status |= TS_USEDFPU;
-	tsk->fpu_counter++;
+	tsk->thread.fpu_counter++;
 }
 
 void fpu_state_restore(struct pt_regs *regs)
diff -puN arch/sh/kernel/process_32.c~sh-move-fpu_counter-into-arch-specific-thread_struct arch/sh/kernel/process_32.c
--- a/arch/sh/kernel/process_32.c~sh-move-fpu_counter-into-arch-specific-thread_struct
+++ a/arch/sh/kernel/process_32.c
@@ -156,7 +156,7 @@ int copy_thread(unsigned long clone_flag
 #endif
 		ti->addr_limit = KERNEL_DS;
 		ti->status &= ~TS_USEDFPU;
-		p->fpu_counter = 0;
+		p->thread.fpu_counter = 0;
 		return 0;
 	}
 	*childregs = *current_pt_regs();
@@ -189,7 +189,7 @@ __switch_to(struct task_struct *prev, st
 	unlazy_fpu(prev, task_pt_regs(prev));
 
 	/* we're going to use this soon, after a few expensive things */
-	if (next->fpu_counter > 5)
+	if (next->thread.fpu_counter > 5)
 		prefetch(next_t->xstate);
 
 #ifdef CONFIG_MMU
@@ -207,7 +207,7 @@ __switch_to(struct task_struct *prev, st
 	 * restore of the math state immediately to avoid the trap; the
 	 * chances of needing FPU soon are obviously high now
 	 */
-	if (next->fpu_counter > 5)
+	if (next->thread.fpu_counter > 5)
 		__fpu_state_restore();
 
 	return prev;
_

Patches currently in -mm which might be from Vineet.Gupta1@synopsys.com are

origin.patch

