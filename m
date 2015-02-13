From: akpm@linux-foundation.org
Subject: [merged]
 all-arches-signal-move-restart_block-to-struct-task_struct.patch removed
 from -mm tree
Date: Fri, 13 Feb 2015 12:21:45 -0800
Message-ID: <54de5cd9.iccTzykKzYibZm4c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49026 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbbBMUVs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:21:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@amacapital.net, a-jacquiot@ti.com, benh@kernel.crashing.org, catalin.marinas@arm.com, chris@zankel.net, cmetcalf@ezchip.com, davem@davemloft.net, deller@gmx.de, dhowells@redhat.com, egtvedt@samfundet.no, geert@linux-m68k.org, gxt@mprc.pku.edu.cn, heiko.carstens@de.ibm.com, hpa@zytor.com, hskinnemoen@gmail.com, ink@jurassic.park.msu.ru, james.hogan@imgtec.com, jcmvbkbc@gmail.com, jejb@parisc-linux.org, jesper.nilsson@axis.com, jonas@southpole.se, keescook@chromium.org, lennox.wu@gmail.com, linux@roeck-us.net, liqin.linux@gmail.com, mattst88@gmail.com, mingo@kernel.org, monstr@monstr.eu, mpe@ellerman.id.au, msalter@redhat.com, oleg@redhat.com, paulus@samba.org, ralf@linux-mips.org, realmz6@gmail.com, richard@nod.at, rkuo@codeaurora.org, rmk@arm.linux.org.uk, rth@twiddle.net, schwidefsky@de.ibm.com, starvik@axis.com, tglx@linutronix.de, tony.luck@intel.com, vgupta@syn


The patch titled
     Subject: all arches, signal: move restart_block to struct task_struct
has been removed from the -mm tree.  Its filename was
     all-arches-signal-move-restart_block-to-struct-task_struct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Lutomirski <luto@amacapital.net>
Subject: all arches, signal: move restart_block to struct task_struct

If an attacker can cause a controlled kernel stack overflow, overwriting
the restart block is a very juicy exploit target.  This is because the
restart_block is held in the same memory allocation as the kernel stack.

Moving the restart block to struct task_struct prevents this exploit by
making the restart_block harder to locate.

Note that there are other fields in thread_info that are also easy
targets, at least on some architectures.

It's also a decent simplification, since the restart code is more or less
identical on all architectures.

[james.hogan@imgtec.com: metag: align thread_info::supervisor_stack]
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: David Miller <davem@davemloft.net>
Acked-by: Richard Weinberger <richard@nod.at>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Steven Miao <realmz6@gmail.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
Tested-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Chen Liqin <liqin.linux@gmail.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: James Hogan <james.hogan@imgtec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/thread_info.h      |    5 -----
 arch/alpha/kernel/signal.c                |    2 +-
 arch/arc/include/asm/thread_info.h        |    4 ----
 arch/arc/kernel/signal.c                  |    2 +-
 arch/arm/include/asm/thread_info.h        |    4 ----
 arch/arm/kernel/signal.c                  |    4 ++--
 arch/arm64/include/asm/thread_info.h      |    4 ----
 arch/arm64/kernel/signal.c                |    2 +-
 arch/arm64/kernel/signal32.c              |    4 ++--
 arch/avr32/include/asm/thread_info.h      |    4 ----
 arch/avr32/kernel/asm-offsets.c           |    1 -
 arch/avr32/kernel/signal.c                |    2 +-
 arch/blackfin/include/asm/thread_info.h   |    4 ----
 arch/blackfin/kernel/signal.c             |    2 +-
 arch/c6x/include/asm/thread_info.h        |    4 ----
 arch/c6x/kernel/signal.c                  |    2 +-
 arch/cris/arch-v10/kernel/signal.c        |    2 +-
 arch/cris/arch-v32/kernel/signal.c        |    2 +-
 arch/cris/include/asm/thread_info.h       |    4 ----
 arch/frv/include/asm/thread_info.h        |    4 ----
 arch/frv/kernel/asm-offsets.c             |    1 -
 arch/frv/kernel/signal.c                  |    2 +-
 arch/hexagon/include/asm/thread_info.h    |    4 ----
 arch/hexagon/kernel/signal.c              |    2 +-
 arch/ia64/include/asm/thread_info.h       |    4 ----
 arch/ia64/kernel/signal.c                 |    2 +-
 arch/m32r/include/asm/thread_info.h       |    5 -----
 arch/m32r/kernel/signal.c                 |    2 +-
 arch/m68k/include/asm/thread_info.h       |    4 ----
 arch/m68k/kernel/signal.c                 |    4 ++--
 arch/metag/include/asm/thread_info.h      |    6 +-----
 arch/metag/kernel/signal.c                |    2 +-
 arch/microblaze/include/asm/thread_info.h |    4 ----
 arch/microblaze/kernel/signal.c           |    2 +-
 arch/mips/include/asm/thread_info.h       |    4 ----
 arch/mips/kernel/asm-offsets.c            |    1 -
 arch/mips/kernel/signal.c                 |    2 +-
 arch/mips/kernel/signal32.c               |    2 +-
 arch/mn10300/include/asm/thread_info.h    |    4 ----
 arch/mn10300/kernel/asm-offsets.c         |    1 -
 arch/mn10300/kernel/signal.c              |    2 +-
 arch/openrisc/include/asm/thread_info.h   |    4 ----
 arch/openrisc/kernel/signal.c             |    2 +-
 arch/parisc/include/asm/thread_info.h     |    4 ----
 arch/parisc/kernel/signal.c               |    2 +-
 arch/powerpc/include/asm/thread_info.h    |    4 ----
 arch/powerpc/kernel/signal_32.c           |    4 ++--
 arch/powerpc/kernel/signal_64.c           |    2 +-
 arch/s390/include/asm/thread_info.h       |    4 ----
 arch/s390/kernel/compat_signal.c          |    2 +-
 arch/s390/kernel/signal.c                 |    2 +-
 arch/score/include/asm/thread_info.h      |    4 ----
 arch/score/kernel/asm-offsets.c           |    1 -
 arch/score/kernel/signal.c                |    2 +-
 arch/sh/include/asm/thread_info.h         |    4 ----
 arch/sh/kernel/asm-offsets.c              |    1 -
 arch/sh/kernel/signal_32.c                |    4 ++--
 arch/sh/kernel/signal_64.c                |    4 ++--
 arch/sparc/include/asm/thread_info_32.h   |    6 ------
 arch/sparc/include/asm/thread_info_64.h   |   12 +++---------
 arch/sparc/kernel/signal32.c              |    4 ++--
 arch/sparc/kernel/signal_32.c             |    2 +-
 arch/sparc/kernel/signal_64.c             |    2 +-
 arch/sparc/kernel/traps_64.c              |    2 --
 arch/tile/include/asm/thread_info.h       |    4 ----
 arch/tile/kernel/signal.c                 |    2 +-
 arch/um/include/asm/thread_info.h         |    4 ----
 arch/unicore32/include/asm/thread_info.h  |    4 ----
 arch/unicore32/kernel/signal.c            |    2 +-
 arch/x86/ia32/ia32_signal.c               |    2 +-
 arch/x86/include/asm/thread_info.h        |    4 ----
 arch/x86/kernel/signal.c                  |    2 +-
 arch/x86/um/signal.c                      |    2 +-
 arch/xtensa/include/asm/thread_info.h     |    5 -----
 arch/xtensa/kernel/signal.c               |    2 +-
 fs/select.c                               |    2 +-
 include/linux/init_task.h                 |    3 +++
 include/linux/sched.h                     |    2 ++
 kernel/compat.c                           |    5 ++---
 kernel/futex.c                            |    2 +-
 kernel/signal.c                           |    2 +-
 kernel/time/alarmtimer.c                  |    2 +-
 kernel/time/hrtimer.c                     |    2 +-
 kernel/time/posix-cpu-timers.c            |    3 +--
 84 files changed, 62 insertions(+), 194 deletions(-)

diff -puN arch/alpha/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct arch/alpha/include/asm/thread_info.h
--- a/arch/alpha/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/alpha/include/asm/thread_info.h
@@ -27,8 +27,6 @@ struct thread_info {
 	int bpt_nsaved;
 	unsigned long bpt_addr[2];		/* breakpoint handling  */
 	unsigned int bpt_insn[2];
-
-	struct restart_block	restart_block;
 };
 
 /*
@@ -40,9 +38,6 @@ struct thread_info {
 	.exec_domain	= &default_exec_domain,	\
 	.addr_limit	= KERNEL_DS,		\
 	.preempt_count	= INIT_PREEMPT_COUNT,	\
-	.restart_block = {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff -puN arch/alpha/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/alpha/kernel/signal.c
--- a/arch/alpha/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/alpha/kernel/signal.c
@@ -150,7 +150,7 @@ restore_sigcontext(struct sigcontext __u
 	struct switch_stack *sw = (struct switch_stack *)regs - 1;
 	long i, err = __get_user(regs->pc, &sc->sc_pc);
 
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	sw->r26 = (unsigned long) ret_from_sys_call;
 
diff -puN arch/arc/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct arch/arc/include/asm/thread_info.h
--- a/arch/arc/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/arc/include/asm/thread_info.h
@@ -46,7 +46,6 @@ struct thread_info {
 	struct exec_domain *exec_domain;/* execution domain */
 	__u32 cpu;			/* current CPU */
 	unsigned long thr_ptr;		/* TLS ptr */
-	struct restart_block restart_block;
 };
 
 /*
@@ -62,9 +61,6 @@ struct thread_info {
 	.cpu        = 0,			\
 	.preempt_count  = INIT_PREEMPT_COUNT,	\
 	.addr_limit = KERNEL_DS,		\
-	.restart_block  = {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 }
 
 #define init_thread_info    (init_thread_union.thread_info)
diff -puN arch/arc/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/arc/kernel/signal.c
--- a/arch/arc/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/arc/kernel/signal.c
@@ -104,7 +104,7 @@ SYSCALL_DEFINE0(rt_sigreturn)
 	struct pt_regs *regs = current_pt_regs();
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	/* Since we stacked the signal on a word boundary,
 	 * then 'sp' should be word aligned here.  If it's
diff -puN arch/arm/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct arch/arm/include/asm/thread_info.h
--- a/arch/arm/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/arm/include/asm/thread_info.h
@@ -68,7 +68,6 @@ struct thread_info {
 #ifdef CONFIG_ARM_THUMBEE
 	unsigned long		thumbee_state;	/* ThumbEE Handler Base register */
 #endif
-	struct restart_block	restart_block;
 };
 
 #define INIT_THREAD_INFO(tsk)						\
@@ -81,9 +80,6 @@ struct thread_info {
 	.cpu_domain	= domain_val(DOMAIN_USER, DOMAIN_MANAGER) |	\
 			  domain_val(DOMAIN_KERNEL, DOMAIN_MANAGER) |	\
 			  domain_val(DOMAIN_IO, DOMAIN_CLIENT),		\
-	.restart_block	= {						\
-		.fn	= do_no_restart_syscall,			\
-	},								\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff -puN arch/arm/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/arm/kernel/signal.c
--- a/arch/arm/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/arm/kernel/signal.c
@@ -191,7 +191,7 @@ asmlinkage int sys_sigreturn(struct pt_r
 	struct sigframe __user *frame;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	/*
 	 * Since we stacked the signal on a 64-bit boundary,
@@ -221,7 +221,7 @@ asmlinkage int sys_rt_sigreturn(struct p
 	struct rt_sigframe __user *frame;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	/*
 	 * Since we stacked the signal on a 64-bit boundary,
diff -puN arch/arm64/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct arch/arm64/include/asm/thread_info.h
--- a/arch/arm64/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/arm64/include/asm/thread_info.h
@@ -48,7 +48,6 @@ struct thread_info {
 	mm_segment_t		addr_limit;	/* address limit */
 	struct task_struct	*task;		/* main task structure */
 	struct exec_domain	*exec_domain;	/* execution domain */
-	struct restart_block	restart_block;
 	int			preempt_count;	/* 0 => preemptable, <0 => bug */
 	int			cpu;		/* cpu */
 };
@@ -60,9 +59,6 @@ struct thread_info {
 	.flags		= 0,						\
 	.preempt_count	= INIT_PREEMPT_COUNT,				\
 	.addr_limit	= KERNEL_DS,					\
-	.restart_block	= {						\
-		.fn	= do_no_restart_syscall,			\
-	},								\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff -puN arch/arm64/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/arm64/kernel/signal.c
--- a/arch/arm64/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/arm64/kernel/signal.c
@@ -131,7 +131,7 @@ asmlinkage long sys_rt_sigreturn(struct
 	struct rt_sigframe __user *frame;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	/*
 	 * Since we stacked the signal on a 128-bit boundary, then 'sp' should
diff -puN arch/arm64/kernel/signal32.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/arm64/kernel/signal32.c
--- a/arch/arm64/kernel/signal32.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/arm64/kernel/signal32.c
@@ -347,7 +347,7 @@ asmlinkage int compat_sys_sigreturn(stru
 	struct compat_sigframe __user *frame;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	/*
 	 * Since we stacked the signal on a 64-bit boundary,
@@ -381,7 +381,7 @@ asmlinkage int compat_sys_rt_sigreturn(s
 	struct compat_rt_sigframe __user *frame;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	/*
 	 * Since we stacked the signal on a 64-bit boundary,
diff -puN arch/avr32/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct arch/avr32/include/asm/thread_info.h
--- a/arch/avr32/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/avr32/include/asm/thread_info.h
@@ -30,7 +30,6 @@ struct thread_info {
 						   saved by debug handler
 						   when setting up
 						   trampoline */
-	struct restart_block	restart_block;
 	__u8			supervisor_stack[0];
 };
 
@@ -41,9 +40,6 @@ struct thread_info {
 	.flags		= 0,						\
 	.cpu		= 0,						\
 	.preempt_count	= INIT_PREEMPT_COUNT,				\
-	.restart_block	= {						\
-		.fn	= do_no_restart_syscall				\
-	}								\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff -puN arch/avr32/kernel/asm-offsets.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/avr32/kernel/asm-offsets.c
--- a/arch/avr32/kernel/asm-offsets.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/avr32/kernel/asm-offsets.c
@@ -18,7 +18,6 @@ void foo(void)
 	OFFSET(TI_preempt_count, thread_info, preempt_count);
 	OFFSET(TI_rar_saved, thread_info, rar_saved);
 	OFFSET(TI_rsr_saved, thread_info, rsr_saved);
-	OFFSET(TI_restart_block, thread_info, restart_block);
 	BLANK();
 	OFFSET(TSK_active_mm, task_struct, active_mm);
 	BLANK();
diff -puN arch/avr32/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/avr32/kernel/signal.c
--- a/arch/avr32/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/avr32/kernel/signal.c
@@ -69,7 +69,7 @@ asmlinkage int sys_rt_sigreturn(struct p
 	sigset_t set;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	frame = (struct rt_sigframe __user *)regs->sp;
 	pr_debug("SIG return: frame = %p\n", frame);
diff -puN arch/blackfin/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct arch/blackfin/include/asm/thread_info.h
--- a/arch/blackfin/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/blackfin/include/asm/thread_info.h
@@ -42,7 +42,6 @@ struct thread_info {
 	int cpu;		/* cpu we're on */
 	int preempt_count;	/* 0 => preemptable, <0 => BUG */
 	mm_segment_t addr_limit;	/* address limit */
-	struct restart_block restart_block;
 #ifndef CONFIG_SMP
 	struct l1_scratch_task_info l1_task_info;
 #endif
@@ -58,9 +57,6 @@ struct thread_info {
 	.flags		= 0,			\
 	.cpu		= 0,			\
 	.preempt_count	= INIT_PREEMPT_COUNT,	\
-	.restart_block	= {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 }
 #define init_thread_info	(init_thread_union.thread_info)
 #define init_stack		(init_thread_union.stack)
diff -puN arch/blackfin/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/blackfin/kernel/signal.c
--- a/arch/blackfin/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/blackfin/kernel/signal.c
@@ -44,7 +44,7 @@ rt_restore_sigcontext(struct pt_regs *re
 	int err = 0;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 #define RESTORE(x) err |= __get_user(regs->x, &sc->sc_##x)
 
diff -puN arch/c6x/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct arch/c6x/include/asm/thread_info.h
--- a/arch/c6x/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/c6x/include/asm/thread_info.h
@@ -45,7 +45,6 @@ struct thread_info {
 	int			cpu;		/* cpu we're on */
 	int			preempt_count;	/* 0 = preemptable, <0 = BUG */
 	mm_segment_t		addr_limit;	/* thread address space */
-	struct restart_block	restart_block;
 };
 
 /*
@@ -61,9 +60,6 @@ struct thread_info {
 	.cpu		= 0,			\
 	.preempt_count	= INIT_PREEMPT_COUNT,	\
 	.addr_limit	= KERNEL_DS,		\
-	.restart_block	= {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff -puN arch/c6x/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/c6x/kernel/signal.c
--- a/arch/c6x/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/c6x/kernel/signal.c
@@ -68,7 +68,7 @@ asmlinkage int do_rt_sigreturn(struct pt
 	sigset_t set;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	/*
 	 * Since we stacked the signal on a dword boundary,
diff -puN arch/cris/arch-v10/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/cris/arch-v10/kernel/signal.c
--- a/arch/cris/arch-v10/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/cris/arch-v10/kernel/signal.c
@@ -67,7 +67,7 @@ restore_sigcontext(struct pt_regs *regs,
 	unsigned long old_usp;
 
         /* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	/* restore the regs from &sc->regs (same as sc, since regs is first)
 	 * (sc is already checked for VERIFY_READ since the sigframe was
diff -puN arch/cris/arch-v32/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/cris/arch-v32/kernel/signal.c
--- a/arch/cris/arch-v32/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/cris/arch-v32/kernel/signal.c
@@ -59,7 +59,7 @@ restore_sigcontext(struct pt_regs *regs,
 	unsigned long old_usp;
 
         /* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	/*
 	 * Restore the registers from &sc->regs. sc is already checked
diff -puN arch/cris/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct arch/cris/include/asm/thread_info.h
--- a/arch/cris/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/cris/include/asm/thread_info.h
@@ -38,7 +38,6 @@ struct thread_info {
 					 	   0-0xBFFFFFFF for user-thead
 						   0-0xFFFFFFFF for kernel-thread
 						*/
-	struct restart_block    restart_block;
 	__u8			supervisor_stack[0];
 };
 
@@ -56,9 +55,6 @@ struct thread_info {
 	.cpu		= 0,				\
 	.preempt_count	= INIT_PREEMPT_COUNT,		\
 	.addr_limit	= KERNEL_DS,			\
-	.restart_block = {				\
-		       .fn = do_no_restart_syscall,	\
-	},						\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff -puN arch/frv/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct arch/frv/include/asm/thread_info.h
--- a/arch/frv/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/frv/include/asm/thread_info.h
@@ -41,7 +41,6 @@ struct thread_info {
 						 * 0-0xBFFFFFFF for user-thead
 						 * 0-0xFFFFFFFF for kernel-thread
 						 */
-	struct restart_block    restart_block;
 
 	__u8			supervisor_stack[0];
 };
@@ -65,9 +64,6 @@ struct thread_info {
 	.cpu		= 0,			\
 	.preempt_count	= INIT_PREEMPT_COUNT,	\
 	.addr_limit	= KERNEL_DS,		\
-	.restart_block = {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff -puN arch/frv/kernel/asm-offsets.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/frv/kernel/asm-offsets.c
--- a/arch/frv/kernel/asm-offsets.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/frv/kernel/asm-offsets.c
@@ -40,7 +40,6 @@ void foo(void)
 	OFFSET(TI_CPU,			thread_info, cpu);
 	OFFSET(TI_PREEMPT_COUNT,	thread_info, preempt_count);
 	OFFSET(TI_ADDR_LIMIT,		thread_info, addr_limit);
-	OFFSET(TI_RESTART_BLOCK,	thread_info, restart_block);
 	BLANK();
 
 	/* offsets into register file storage */
diff -puN arch/frv/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/frv/kernel/signal.c
--- a/arch/frv/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/frv/kernel/signal.c
@@ -62,7 +62,7 @@ static int restore_sigcontext(struct sig
 	unsigned long tbr, psr;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	tbr = user->i.tbr;
 	psr = user->i.psr;
diff -puN arch/hexagon/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct arch/hexagon/include/asm/thread_info.h
--- a/arch/hexagon/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/hexagon/include/asm/thread_info.h
@@ -56,7 +56,6 @@ struct thread_info {
 	 * used for syscalls somehow;
 	 * seems to have a function pointer and four arguments
 	 */
-	struct restart_block    restart_block;
 	/* Points to the current pt_regs frame  */
 	struct pt_regs		*regs;
 	/*
@@ -83,9 +82,6 @@ struct thread_info {
 	.cpu            = 0,                    \
 	.preempt_count  = 1,                    \
 	.addr_limit     = KERNEL_DS,            \
-	.restart_block = {                      \
-		.fn = do_no_restart_syscall,    \
-	},                                      \
 	.sp = 0,				\
 	.regs = NULL,			\
 }
diff -puN arch/hexagon/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/hexagon/kernel/signal.c
--- a/arch/hexagon/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/hexagon/kernel/signal.c
@@ -239,7 +239,7 @@ asmlinkage int sys_rt_sigreturn(void)
 	sigset_t blocked;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	frame = (struct rt_sigframe __user *)pt_psp(regs);
 	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
diff -puN arch/ia64/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct arch/ia64/include/asm/thread_info.h
--- a/arch/ia64/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/ia64/include/asm/thread_info.h
@@ -27,7 +27,6 @@ struct thread_info {
 	__u32 status;			/* Thread synchronous flags */
 	mm_segment_t addr_limit;	/* user-level address space limit */
 	int preempt_count;		/* 0=premptable, <0=BUG; will also serve as bh-counter */
-	struct restart_block restart_block;
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 	__u64 ac_stamp;
 	__u64 ac_leave;
@@ -46,9 +45,6 @@ struct thread_info {
 	.cpu		= 0,			\
 	.addr_limit	= KERNEL_DS,		\
 	.preempt_count	= INIT_PREEMPT_COUNT,	\
-	.restart_block = {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 }
 
 #ifndef ASM_OFFSETS_C
diff -puN arch/ia64/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/ia64/kernel/signal.c
--- a/arch/ia64/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/ia64/kernel/signal.c
@@ -46,7 +46,7 @@ restore_sigcontext (struct sigcontext __
 	long err;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	/* restore scratch that always needs gets updated during signal delivery: */
 	err  = __get_user(flags, &sc->sc_flags);
diff -puN arch/m32r/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct arch/m32r/include/asm/thread_info.h
--- a/arch/m32r/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/m32r/include/asm/thread_info.h
@@ -34,7 +34,6 @@ struct thread_info {
 					 	   0-0xBFFFFFFF for user-thread
 						   0-0xFFFFFFFF for kernel-thread
 						*/
-	struct restart_block    restart_block;
 
 	__u8			supervisor_stack[0];
 };
@@ -49,7 +48,6 @@ struct thread_info {
 #define TI_CPU		0x00000010
 #define TI_PRE_COUNT	0x00000014
 #define TI_ADDR_LIMIT	0x00000018
-#define TI_RESTART_BLOCK 0x000001C
 
 #endif
 
@@ -68,9 +66,6 @@ struct thread_info {
 	.cpu		= 0,			\
 	.preempt_count	= INIT_PREEMPT_COUNT,	\
 	.addr_limit	= KERNEL_DS,		\
-	.restart_block = {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff -puN arch/m32r/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/m32r/kernel/signal.c
--- a/arch/m32r/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/m32r/kernel/signal.c
@@ -48,7 +48,7 @@ restore_sigcontext(struct pt_regs *regs,
 	unsigned int err = 0;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 #define COPY(x)		err |= __get_user(regs->x, &sc->sc_##x)
 	COPY(r4);
diff -puN arch/m68k/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct arch/m68k/include/asm/thread_info.h
--- a/arch/m68k/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/m68k/include/asm/thread_info.h
@@ -31,7 +31,6 @@ struct thread_info {
 	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
 	__u32			cpu;		/* should always be 0 on m68k */
 	unsigned long		tp_value;	/* thread pointer */
-	struct restart_block    restart_block;
 };
 #endif /* __ASSEMBLY__ */
 
@@ -41,9 +40,6 @@ struct thread_info {
 	.exec_domain	= &default_exec_domain,	\
 	.addr_limit	= KERNEL_DS,		\
 	.preempt_count	= INIT_PREEMPT_COUNT,	\
-	.restart_block = {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 }
 
 #define init_stack		(init_thread_union.stack)
diff -puN arch/m68k/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/m68k/kernel/signal.c
--- a/arch/m68k/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/m68k/kernel/signal.c
@@ -655,7 +655,7 @@ restore_sigcontext(struct pt_regs *regs,
 	int err = 0;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	/* get previous context */
 	if (copy_from_user(&context, usc, sizeof(context)))
@@ -693,7 +693,7 @@ rt_restore_ucontext(struct pt_regs *regs
 	int err;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	err = __get_user(temp, &uc->uc_mcontext.version);
 	if (temp != MCONTEXT_VERSION)
diff -puN arch/metag/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct arch/metag/include/asm/thread_info.h
--- a/arch/metag/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/metag/include/asm/thread_info.h
@@ -35,9 +35,8 @@ struct thread_info {
 	int preempt_count;	/* 0 => preemptable, <0 => BUG */
 
 	mm_segment_t addr_limit;	/* thread address space */
-	struct restart_block restart_block;
 
-	u8 supervisor_stack[0];
+	u8 supervisor_stack[0] __aligned(8);
 };
 
 #else /* !__ASSEMBLY__ */
@@ -74,9 +73,6 @@ struct thread_info {
 	.cpu		= 0,			\
 	.preempt_count	= INIT_PREEMPT_COUNT,	\
 	.addr_limit	= KERNEL_DS,		\
-	.restart_block = {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff -puN arch/metag/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/metag/kernel/signal.c
--- a/arch/metag/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/metag/kernel/signal.c
@@ -48,7 +48,7 @@ static int restore_sigcontext(struct pt_
 	int err;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	err = metag_gp_regs_copyin(regs, 0, sizeof(struct user_gp_regs), NULL,
 				   &sc->regs);
diff -puN arch/microblaze/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct arch/microblaze/include/asm/thread_info.h
--- a/arch/microblaze/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/microblaze/include/asm/thread_info.h
@@ -71,7 +71,6 @@ struct thread_info {
 	__u32			cpu; /* current CPU */
 	__s32			preempt_count; /* 0 => preemptable,< 0 => BUG*/
 	mm_segment_t		addr_limit; /* thread address space */
-	struct restart_block	restart_block;
 
 	struct cpu_context	cpu_context;
 };
@@ -87,9 +86,6 @@ struct thread_info {
 	.cpu		= 0,			\
 	.preempt_count	= INIT_PREEMPT_COUNT,	\
 	.addr_limit	= KERNEL_DS,		\
-	.restart_block = {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff -puN arch/microblaze/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/microblaze/kernel/signal.c
--- a/arch/microblaze/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/microblaze/kernel/signal.c
@@ -89,7 +89,7 @@ asmlinkage long sys_rt_sigreturn(struct
 	int rval;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
 		goto badframe;
diff -puN arch/mips/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct arch/mips/include/asm/thread_info.h
--- a/arch/mips/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/mips/include/asm/thread_info.h
@@ -34,7 +34,6 @@ struct thread_info {
 						 * 0x7fffffff for user-thead
 						 * 0xffffffff for kernel-thread
 						 */
-	struct restart_block	restart_block;
 	struct pt_regs		*regs;
 	long			syscall;	/* syscall number */
 };
@@ -50,9 +49,6 @@ struct thread_info {
 	.cpu		= 0,			\
 	.preempt_count	= INIT_PREEMPT_COUNT,	\
 	.addr_limit	= KERNEL_DS,		\
-	.restart_block	= {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff -puN arch/mips/kernel/asm-offsets.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/mips/kernel/asm-offsets.c
--- a/arch/mips/kernel/asm-offsets.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/mips/kernel/asm-offsets.c
@@ -98,7 +98,6 @@ void output_thread_info_defines(void)
 	OFFSET(TI_CPU, thread_info, cpu);
 	OFFSET(TI_PRE_COUNT, thread_info, preempt_count);
 	OFFSET(TI_ADDR_LIMIT, thread_info, addr_limit);
-	OFFSET(TI_RESTART_BLOCK, thread_info, restart_block);
 	OFFSET(TI_REGS, thread_info, regs);
 	DEFINE(_THREAD_SIZE, THREAD_SIZE);
 	DEFINE(_THREAD_MASK, THREAD_MASK);
diff -puN arch/mips/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/mips/kernel/signal.c
--- a/arch/mips/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/mips/kernel/signal.c
@@ -243,7 +243,7 @@ int restore_sigcontext(struct pt_regs *r
 	int i;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	err |= __get_user(regs->cp0_epc, &sc->sc_pc);
 
diff -puN arch/mips/kernel/signal32.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/mips/kernel/signal32.c
--- a/arch/mips/kernel/signal32.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/mips/kernel/signal32.c
@@ -220,7 +220,7 @@ static int restore_sigcontext32(struct p
 	int i;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	err |= __get_user(regs->cp0_epc, &sc->sc_pc);
 	err |= __get_user(regs->hi, &sc->sc_mdhi);
diff -puN arch/mn10300/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct arch/mn10300/include/asm/thread_info.h
--- a/arch/mn10300/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/mn10300/include/asm/thread_info.h
@@ -50,7 +50,6 @@ struct thread_info {
 						   0-0xBFFFFFFF for user-thead
 						   0-0xFFFFFFFF for kernel-thread
 						*/
-	struct restart_block    restart_block;
 
 	__u8			supervisor_stack[0];
 };
@@ -80,9 +79,6 @@ struct thread_info {
 	.cpu		= 0,			\
 	.preempt_count	= INIT_PREEMPT_COUNT,	\
 	.addr_limit	= KERNEL_DS,		\
-	.restart_block = {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff -puN arch/mn10300/kernel/asm-offsets.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/mn10300/kernel/asm-offsets.c
--- a/arch/mn10300/kernel/asm-offsets.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/mn10300/kernel/asm-offsets.c
@@ -28,7 +28,6 @@ void foo(void)
 	OFFSET(TI_cpu,			thread_info, cpu);
 	OFFSET(TI_preempt_count,	thread_info, preempt_count);
 	OFFSET(TI_addr_limit,		thread_info, addr_limit);
-	OFFSET(TI_restart_block,	thread_info, restart_block);
 	BLANK();
 
 	OFFSET(REG_D0,			pt_regs, d0);
diff -puN arch/mn10300/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/mn10300/kernel/signal.c
--- a/arch/mn10300/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/mn10300/kernel/signal.c
@@ -40,7 +40,7 @@ static int restore_sigcontext(struct pt_
 	unsigned int err = 0;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	if (is_using_fpu(current))
 		fpu_kill_state(current);
diff -puN arch/openrisc/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct arch/openrisc/include/asm/thread_info.h
--- a/arch/openrisc/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/openrisc/include/asm/thread_info.h
@@ -57,7 +57,6 @@ struct thread_info {
 					       0-0x7FFFFFFF for user-thead
 					       0-0xFFFFFFFF for kernel-thread
 					     */
-	struct restart_block    restart_block;
 	__u8			supervisor_stack[0];
 
 	/* saved context data */
@@ -79,9 +78,6 @@ struct thread_info {
 	.cpu		= 0,				\
 	.preempt_count	= 1,				\
 	.addr_limit	= KERNEL_DS,			\
-	.restart_block  = {				\
-			  .fn = do_no_restart_syscall,	\
-	},						\
 	.ksp            = 0,                            \
 }
 
diff -puN arch/openrisc/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/openrisc/kernel/signal.c
--- a/arch/openrisc/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/openrisc/kernel/signal.c
@@ -46,7 +46,7 @@ static int restore_sigcontext(struct pt_
 	int err = 0;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	/*
 	 * Restore the regs from &sc->regs.
diff -puN arch/parisc/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct arch/parisc/include/asm/thread_info.h
--- a/arch/parisc/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/parisc/include/asm/thread_info.h
@@ -14,7 +14,6 @@ struct thread_info {
 	mm_segment_t addr_limit;	/* user-level address space limit */
 	__u32 cpu;			/* current CPU */
 	int preempt_count;		/* 0=premptable, <0=BUG; will also serve as bh-counter */
-	struct restart_block restart_block;
 };
 
 #define INIT_THREAD_INFO(tsk)			\
@@ -25,9 +24,6 @@ struct thread_info {
 	.cpu		= 0,			\
 	.addr_limit	= KERNEL_DS,		\
 	.preempt_count	= INIT_PREEMPT_COUNT,	\
-  	.restart_block	= {			\
-		.fn = do_no_restart_syscall	\
-	}					\
 }
 
 #define init_thread_info        (init_thread_union.thread_info)
diff -puN arch/parisc/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/parisc/kernel/signal.c
--- a/arch/parisc/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/parisc/kernel/signal.c
@@ -99,7 +99,7 @@ sys_rt_sigreturn(struct pt_regs *regs, i
 		sigframe_size = PARISC_RT_SIGFRAME_SIZE32;
 #endif
 
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	/* Unwind the user stack to get the rt_sigframe structure. */
 	frame = (struct rt_sigframe __user *)
diff -puN arch/powerpc/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct arch/powerpc/include/asm/thread_info.h
--- a/arch/powerpc/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/powerpc/include/asm/thread_info.h
@@ -43,7 +43,6 @@ struct thread_info {
 	int		cpu;			/* cpu we're on */
 	int		preempt_count;		/* 0 => preemptable,
 						   <0 => BUG */
-	struct restart_block restart_block;
 	unsigned long	local_flags;		/* private flags for thread */
 
 	/* low level flags - has atomic operations done on it */
@@ -59,9 +58,6 @@ struct thread_info {
 	.exec_domain =	&default_exec_domain,	\
 	.cpu =		0,			\
 	.preempt_count = INIT_PREEMPT_COUNT,	\
-	.restart_block = {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 	.flags =	0,			\
 }
 
diff -puN arch/powerpc/kernel/signal_32.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/powerpc/kernel/signal_32.c
--- a/arch/powerpc/kernel/signal_32.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/powerpc/kernel/signal_32.c
@@ -1231,7 +1231,7 @@ long sys_rt_sigreturn(int r3, int r4, in
 	int tm_restore = 0;
 #endif
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	rt_sf = (struct rt_sigframe __user *)
 		(regs->gpr[1] + __SIGNAL_FRAMESIZE + 16);
@@ -1504,7 +1504,7 @@ long sys_sigreturn(int r3, int r4, int r
 #endif
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	sf = (struct sigframe __user *)(regs->gpr[1] + __SIGNAL_FRAMESIZE);
 	sc = &sf->sctx;
diff -puN arch/powerpc/kernel/signal_64.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/powerpc/kernel/signal_64.c
--- a/arch/powerpc/kernel/signal_64.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/powerpc/kernel/signal_64.c
@@ -666,7 +666,7 @@ int sys_rt_sigreturn(unsigned long r3, u
 #endif
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	if (!access_ok(VERIFY_READ, uc, sizeof(*uc)))
 		goto badframe;
diff -puN arch/s390/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct arch/s390/include/asm/thread_info.h
--- a/arch/s390/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/s390/include/asm/thread_info.h
@@ -39,7 +39,6 @@ struct thread_info {
 	unsigned long		sys_call_table;	/* System call table address */
 	unsigned int		cpu;		/* current CPU */
 	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
-	struct restart_block	restart_block;
 	unsigned int		system_call;
 	__u64			user_timer;
 	__u64			system_timer;
@@ -56,9 +55,6 @@ struct thread_info {
 	.flags		= 0,			\
 	.cpu		= 0,			\
 	.preempt_count	= INIT_PREEMPT_COUNT,	\
-	.restart_block	= {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff -puN arch/s390/kernel/compat_signal.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/s390/kernel/compat_signal.c
--- a/arch/s390/kernel/compat_signal.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/s390/kernel/compat_signal.c
@@ -209,7 +209,7 @@ static int restore_sigregs32(struct pt_r
 	int i;
 
 	/* Alwys make any pending restarted system call return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	if (__copy_from_user(&user_sregs, &sregs->regs, sizeof(user_sregs)))
 		return -EFAULT;
diff -puN arch/s390/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/s390/kernel/signal.c
--- a/arch/s390/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/s390/kernel/signal.c
@@ -162,7 +162,7 @@ static int restore_sigregs(struct pt_reg
 	_sigregs user_sregs;
 
 	/* Alwys make any pending restarted system call return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	if (__copy_from_user(&user_sregs, sregs, sizeof(user_sregs)))
 		return -EFAULT;
diff -puN arch/score/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct arch/score/include/asm/thread_info.h
--- a/arch/score/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/score/include/asm/thread_info.h
@@ -42,7 +42,6 @@ struct thread_info {
 	 * 0-0xFFFFFFFF for kernel-thread
 	 */
 	mm_segment_t		addr_limit;
-	struct restart_block	restart_block;
 	struct pt_regs		*regs;
 };
 
@@ -58,9 +57,6 @@ struct thread_info {
 	.cpu		= 0,			\
 	.preempt_count	= 1,			\
 	.addr_limit	= KERNEL_DS,		\
-	.restart_block	= {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff -puN arch/score/kernel/asm-offsets.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/score/kernel/asm-offsets.c
--- a/arch/score/kernel/asm-offsets.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/score/kernel/asm-offsets.c
@@ -106,7 +106,6 @@ void output_thread_info_defines(void)
 	OFFSET(TI_CPU, thread_info, cpu);
 	OFFSET(TI_PRE_COUNT, thread_info, preempt_count);
 	OFFSET(TI_ADDR_LIMIT, thread_info, addr_limit);
-	OFFSET(TI_RESTART_BLOCK, thread_info, restart_block);
 	OFFSET(TI_REGS, thread_info, regs);
 	DEFINE(KERNEL_STACK_SIZE, THREAD_SIZE);
 	DEFINE(KERNEL_STACK_MASK, THREAD_MASK);
diff -puN arch/score/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/score/kernel/signal.c
--- a/arch/score/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/score/kernel/signal.c
@@ -141,7 +141,7 @@ score_rt_sigreturn(struct pt_regs *regs)
 	int sig;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	frame = (struct rt_sigframe __user *) regs->regs[0];
 	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
diff -puN arch/sh/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct arch/sh/include/asm/thread_info.h
--- a/arch/sh/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/sh/include/asm/thread_info.h
@@ -33,7 +33,6 @@ struct thread_info {
 	__u32			cpu;
 	int			preempt_count; /* 0 => preemptable, <0 => BUG */
 	mm_segment_t		addr_limit;	/* thread address space */
-	struct restart_block	restart_block;
 	unsigned long		previous_sp;	/* sp of previous stack in case
 						   of nested IRQ stacks */
 	__u8			supervisor_stack[0];
@@ -63,9 +62,6 @@ struct thread_info {
 	.cpu		= 0,			\
 	.preempt_count	= INIT_PREEMPT_COUNT,	\
 	.addr_limit	= KERNEL_DS,		\
-	.restart_block	= {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff -puN arch/sh/kernel/asm-offsets.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/sh/kernel/asm-offsets.c
--- a/arch/sh/kernel/asm-offsets.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/sh/kernel/asm-offsets.c
@@ -25,7 +25,6 @@ int main(void)
 	DEFINE(TI_FLAGS,	offsetof(struct thread_info, flags));
 	DEFINE(TI_CPU,		offsetof(struct thread_info, cpu));
 	DEFINE(TI_PRE_COUNT,	offsetof(struct thread_info, preempt_count));
-	DEFINE(TI_RESTART_BLOCK,offsetof(struct thread_info, restart_block));
 	DEFINE(TI_SIZE,		sizeof(struct thread_info));
 
 #ifdef CONFIG_HIBERNATION
diff -puN arch/sh/kernel/signal_32.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/sh/kernel/signal_32.c
--- a/arch/sh/kernel/signal_32.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/sh/kernel/signal_32.c
@@ -156,7 +156,7 @@ asmlinkage int sys_sigreturn(void)
 	int r0;
 
         /* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
 		goto badframe;
@@ -186,7 +186,7 @@ asmlinkage int sys_rt_sigreturn(void)
 	int r0;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
 		goto badframe;
diff -puN arch/sh/kernel/signal_64.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/sh/kernel/signal_64.c
--- a/arch/sh/kernel/signal_64.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/sh/kernel/signal_64.c
@@ -260,7 +260,7 @@ asmlinkage int sys_sigreturn(unsigned lo
 	long long ret;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
 		goto badframe;
@@ -294,7 +294,7 @@ asmlinkage int sys_rt_sigreturn(unsigned
 	long long ret;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
 		goto badframe;
diff -puN arch/sparc/include/asm/thread_info_32.h~all-arches-signal-move-restart_block-to-struct-task_struct arch/sparc/include/asm/thread_info_32.h
--- a/arch/sparc/include/asm/thread_info_32.h~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/sparc/include/asm/thread_info_32.h
@@ -47,8 +47,6 @@ struct thread_info {
 	struct reg_window32	reg_window[NSWINS];	/* align for ldd! */
 	unsigned long		rwbuf_stkptrs[NSWINS];
 	unsigned long		w_saved;
-
-	struct restart_block	restart_block;
 };
 
 /*
@@ -62,9 +60,6 @@ struct thread_info {
 	.flags		=	0,			\
 	.cpu		=	0,			\
 	.preempt_count	=	INIT_PREEMPT_COUNT,	\
-	.restart_block	= {				\
-		.fn	=	do_no_restart_syscall,	\
-	},						\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
@@ -103,7 +98,6 @@ register struct thread_info *current_thr
 #define TI_REG_WINDOW	0x30
 #define TI_RWIN_SPTRS	0x230
 #define TI_W_SAVED	0x250
-/* #define TI_RESTART_BLOCK 0x25n */ /* Nobody cares */
 
 /*
  * thread information flag bit numbers
diff -puN arch/sparc/include/asm/thread_info_64.h~all-arches-signal-move-restart_block-to-struct-task_struct arch/sparc/include/asm/thread_info_64.h
--- a/arch/sparc/include/asm/thread_info_64.h~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/sparc/include/asm/thread_info_64.h
@@ -58,8 +58,6 @@ struct thread_info {
 	unsigned long		gsr[7];
 	unsigned long		xfsr[7];
 
-	struct restart_block	restart_block;
-
 	struct pt_regs		*kern_una_regs;
 	unsigned int		kern_una_insn;
 
@@ -92,10 +90,9 @@ struct thread_info {
 #define TI_RWIN_SPTRS	0x000003c8
 #define TI_GSR		0x00000400
 #define TI_XFSR		0x00000438
-#define TI_RESTART_BLOCK 0x00000470
-#define TI_KUNA_REGS	0x000004a0
-#define TI_KUNA_INSN	0x000004a8
-#define TI_FPREGS	0x000004c0
+#define TI_KUNA_REGS	0x00000470
+#define TI_KUNA_INSN	0x00000478
+#define TI_FPREGS	0x00000480
 
 /* We embed this in the uppermost byte of thread_info->flags */
 #define FAULT_CODE_WRITE	0x01	/* Write access, implies D-TLB	   */
@@ -124,9 +121,6 @@ struct thread_info {
 	.current_ds	=	ASI_P,			\
 	.exec_domain	=	&default_exec_domain,	\
 	.preempt_count	=	INIT_PREEMPT_COUNT,	\
-	.restart_block	= {				\
-		.fn	=	do_no_restart_syscall,	\
-	},						\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff -puN arch/sparc/kernel/signal32.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/sparc/kernel/signal32.c
--- a/arch/sparc/kernel/signal32.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/sparc/kernel/signal32.c
@@ -150,7 +150,7 @@ void do_sigreturn32(struct pt_regs *regs
 	int err, i;
 	
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	synchronize_user_stack();
 
@@ -235,7 +235,7 @@ asmlinkage void do_rt_sigreturn32(struct
 	int err, i;
 	
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	synchronize_user_stack();
 	regs->u_regs[UREG_FP] &= 0x00000000ffffffffUL;
diff -puN arch/sparc/kernel/signal_32.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/sparc/kernel/signal_32.c
--- a/arch/sparc/kernel/signal_32.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/sparc/kernel/signal_32.c
@@ -70,7 +70,7 @@ asmlinkage void do_sigreturn(struct pt_r
 	int err;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	synchronize_user_stack();
 
diff -puN arch/sparc/kernel/signal_64.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/sparc/kernel/signal_64.c
--- a/arch/sparc/kernel/signal_64.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/sparc/kernel/signal_64.c
@@ -254,7 +254,7 @@ void do_rt_sigreturn(struct pt_regs *reg
 	int err;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	synchronize_user_stack ();
 	sf = (struct rt_signal_frame __user *)
diff -puN arch/sparc/kernel/traps_64.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/sparc/kernel/traps_64.c
--- a/arch/sparc/kernel/traps_64.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/sparc/kernel/traps_64.c
@@ -2730,8 +2730,6 @@ void __init trap_init(void)
 		     TI_NEW_CHILD != offsetof(struct thread_info, new_child) ||
 		     TI_CURRENT_DS != offsetof(struct thread_info,
 						current_ds) ||
-		     TI_RESTART_BLOCK != offsetof(struct thread_info,
-						  restart_block) ||
 		     TI_KUNA_REGS != offsetof(struct thread_info,
 					      kern_una_regs) ||
 		     TI_KUNA_INSN != offsetof(struct thread_info,
diff -puN arch/tile/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct arch/tile/include/asm/thread_info.h
--- a/arch/tile/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/tile/include/asm/thread_info.h
@@ -36,7 +36,6 @@ struct thread_info {
 
 	mm_segment_t		addr_limit;	/* thread address space
 						   (KERNEL_DS or USER_DS) */
-	struct restart_block	restart_block;
 	struct single_step_state *step_state;	/* single step state
 						   (if non-zero) */
 	int			align_ctl;	/* controls unaligned access */
@@ -57,9 +56,6 @@ struct thread_info {
 	.cpu		= 0,			\
 	.preempt_count	= INIT_PREEMPT_COUNT,	\
 	.addr_limit	= KERNEL_DS,		\
-	.restart_block	= {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 	.step_state	= NULL,			\
 	.align_ctl	= 0,			\
 }
diff -puN arch/tile/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/tile/kernel/signal.c
--- a/arch/tile/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/tile/kernel/signal.c
@@ -48,7 +48,7 @@ int restore_sigcontext(struct pt_regs *r
 	int err;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	/*
 	 * Enforce that sigcontext is like pt_regs, and doesn't mess
diff -puN arch/um/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct arch/um/include/asm/thread_info.h
--- a/arch/um/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/um/include/asm/thread_info.h
@@ -22,7 +22,6 @@ struct thread_info {
 	mm_segment_t		addr_limit;	/* thread address space:
 					 	   0-0xBFFFFFFF for user
 						   0-0xFFFFFFFF for kernel */
-	struct restart_block    restart_block;
 	struct thread_info	*real_thread;    /* Points to non-IRQ stack */
 };
 
@@ -34,9 +33,6 @@ struct thread_info {
 	.cpu =		0,			\
 	.preempt_count = INIT_PREEMPT_COUNT,	\
 	.addr_limit =	KERNEL_DS,		\
-	.restart_block =  {			\
-		.fn =  do_no_restart_syscall,	\
-	},					\
 	.real_thread = NULL,			\
 }
 
diff -puN arch/unicore32/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct arch/unicore32/include/asm/thread_info.h
--- a/arch/unicore32/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/unicore32/include/asm/thread_info.h
@@ -79,7 +79,6 @@ struct thread_info {
 #ifdef CONFIG_UNICORE_FPU_F64
 	struct fp_state		fpstate __attribute__((aligned(8)));
 #endif
-	struct restart_block	restart_block;
 };
 
 #define INIT_THREAD_INFO(tsk)						\
@@ -89,9 +88,6 @@ struct thread_info {
 	.flags		= 0,						\
 	.preempt_count	= INIT_PREEMPT_COUNT,				\
 	.addr_limit	= KERNEL_DS,					\
-	.restart_block	= {						\
-		.fn	= do_no_restart_syscall,			\
-	},								\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff -puN arch/unicore32/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/unicore32/kernel/signal.c
--- a/arch/unicore32/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/unicore32/kernel/signal.c
@@ -105,7 +105,7 @@ asmlinkage int __sys_rt_sigreturn(struct
 	struct rt_sigframe __user *frame;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	/*
 	 * Since we stacked the signal on a 64-bit boundary,
diff -puN arch/x86/ia32/ia32_signal.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/x86/ia32/ia32_signal.c
--- a/arch/x86/ia32/ia32_signal.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/x86/ia32/ia32_signal.c
@@ -169,7 +169,7 @@ static int ia32_restore_sigcontext(struc
 	u32 tmp;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	get_user_try {
 		/*
diff -puN arch/x86/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct arch/x86/include/asm/thread_info.h
--- a/arch/x86/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/x86/include/asm/thread_info.h
@@ -31,7 +31,6 @@ struct thread_info {
 	__u32			cpu;		/* current CPU */
 	int			saved_preempt_count;
 	mm_segment_t		addr_limit;
-	struct restart_block    restart_block;
 	void __user		*sysenter_return;
 	unsigned int		sig_on_uaccess_error:1;
 	unsigned int		uaccess_err:1;	/* uaccess failed */
@@ -45,9 +44,6 @@ struct thread_info {
 	.cpu		= 0,			\
 	.saved_preempt_count = INIT_PREEMPT_COUNT,	\
 	.addr_limit	= KERNEL_DS,		\
-	.restart_block = {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff -puN arch/x86/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/x86/kernel/signal.c
--- a/arch/x86/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/x86/kernel/signal.c
@@ -69,7 +69,7 @@ int restore_sigcontext(struct pt_regs *r
 	unsigned int err = 0;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	get_user_try {
 
diff -puN arch/x86/um/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/x86/um/signal.c
--- a/arch/x86/um/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/x86/um/signal.c
@@ -157,7 +157,7 @@ static int copy_sc_from_user(struct pt_r
 	int err, pid;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	err = copy_from_user(&sc, from, sizeof(sc));
 	if (err)
diff -puN arch/xtensa/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct arch/xtensa/include/asm/thread_info.h
--- a/arch/xtensa/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/xtensa/include/asm/thread_info.h
@@ -51,7 +51,6 @@ struct thread_info {
 	__s32			preempt_count;	/* 0 => preemptable,< 0 => BUG*/
 
 	mm_segment_t		addr_limit;	/* thread address space */
-	struct restart_block    restart_block;
 
 	unsigned long		cpenable;
 
@@ -72,7 +71,6 @@ struct thread_info {
 #define TI_CPU		 0x00000010
 #define TI_PRE_COUNT	 0x00000014
 #define TI_ADDR_LIMIT	 0x00000018
-#define TI_RESTART_BLOCK 0x000001C
 
 #endif
 
@@ -90,9 +88,6 @@ struct thread_info {
 	.cpu		= 0,			\
 	.preempt_count	= INIT_PREEMPT_COUNT,	\
 	.addr_limit	= KERNEL_DS,		\
-	.restart_block = {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff -puN arch/xtensa/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/xtensa/kernel/signal.c
--- a/arch/xtensa/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/arch/xtensa/kernel/signal.c
@@ -245,7 +245,7 @@ asmlinkage long xtensa_rt_sigreturn(long
 	int ret;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	if (regs->depc > 64)
 		panic("rt_sigreturn in double exception!\n");
diff -puN fs/select.c~all-arches-signal-move-restart_block-to-struct-task_struct fs/select.c
--- a/fs/select.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/fs/select.c
@@ -971,7 +971,7 @@ SYSCALL_DEFINE3(poll, struct pollfd __us
 	if (ret == -EINTR) {
 		struct restart_block *restart_block;
 
-		restart_block = &current_thread_info()->restart_block;
+		restart_block = &current->restart_block;
 		restart_block->fn = do_restart_poll;
 		restart_block->poll.ufds = ufds;
 		restart_block->poll.nfds = nfds;
diff -puN include/linux/init_task.h~all-arches-signal-move-restart_block-to-struct-task_struct include/linux/init_task.h
--- a/include/linux/init_task.h~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/include/linux/init_task.h
@@ -193,6 +193,9 @@ extern struct task_group root_task_group
 	.nr_cpus_allowed= NR_CPUS,					\
 	.mm		= NULL,						\
 	.active_mm	= &init_mm,					\
+	.restart_block = {						\
+		.fn = do_no_restart_syscall,				\
+	},								\
 	.se		= {						\
 		.group_node 	= LIST_HEAD_INIT(tsk.se.group_node),	\
 	},								\
diff -puN include/linux/sched.h~all-arches-signal-move-restart_block-to-struct-task_struct include/linux/sched.h
--- a/include/linux/sched.h~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/include/linux/sched.h
@@ -1370,6 +1370,8 @@ struct task_struct {
 
 	unsigned long atomic_flags; /* Flags needing atomic access. */
 
+	struct restart_block restart_block;
+
 	pid_t pid;
 	pid_t tgid;
 
diff -puN kernel/compat.c~all-arches-signal-move-restart_block-to-struct-task_struct kernel/compat.c
--- a/kernel/compat.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/kernel/compat.c
@@ -276,8 +276,7 @@ COMPAT_SYSCALL_DEFINE2(nanosleep, struct
 	 * core implementation decides to return random nonsense.
 	 */
 	if (ret == -ERESTART_RESTARTBLOCK) {
-		struct restart_block *restart
-			= &current_thread_info()->restart_block;
+		struct restart_block *restart = &current->restart_block;
 
 		restart->fn = compat_nanosleep_restart;
 		restart->nanosleep.compat_rmtp = rmtp;
@@ -860,7 +859,7 @@ COMPAT_SYSCALL_DEFINE4(clock_nanosleep,
 		return -EFAULT;
 
 	if (err == -ERESTART_RESTARTBLOCK) {
-		restart = &current_thread_info()->restart_block;
+		restart = &current->restart_block;
 		restart->fn = compat_clock_nanosleep_restart;
 		restart->nanosleep.compat_rmtp = rmtp;
 	}
diff -puN kernel/futex.c~all-arches-signal-move-restart_block-to-struct-task_struct kernel/futex.c
--- a/kernel/futex.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/kernel/futex.c
@@ -2217,7 +2217,7 @@ retry:
 	if (!abs_time)
 		goto out;
 
-	restart = &current_thread_info()->restart_block;
+	restart = &current->restart_block;
 	restart->fn = futex_wait_restart;
 	restart->futex.uaddr = uaddr;
 	restart->futex.val = val;
diff -puN kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct kernel/signal.c
--- a/kernel/signal.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/kernel/signal.c
@@ -2501,7 +2501,7 @@ EXPORT_SYMBOL(unblock_all_signals);
  */
 SYSCALL_DEFINE0(restart_syscall)
 {
-	struct restart_block *restart = &current_thread_info()->restart_block;
+	struct restart_block *restart = &current->restart_block;
 	return restart->fn(restart);
 }
 
diff -puN kernel/time/alarmtimer.c~all-arches-signal-move-restart_block-to-struct-task_struct kernel/time/alarmtimer.c
--- a/kernel/time/alarmtimer.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/kernel/time/alarmtimer.c
@@ -788,7 +788,7 @@ static int alarm_timer_nsleep(const cloc
 			goto out;
 	}
 
-	restart = &current_thread_info()->restart_block;
+	restart = &current->restart_block;
 	restart->fn = alarm_timer_nsleep_restart;
 	restart->nanosleep.clockid = type;
 	restart->nanosleep.expires = exp.tv64;
diff -puN kernel/time/hrtimer.c~all-arches-signal-move-restart_block-to-struct-task_struct kernel/time/hrtimer.c
--- a/kernel/time/hrtimer.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/kernel/time/hrtimer.c
@@ -1583,7 +1583,7 @@ long hrtimer_nanosleep(struct timespec *
 			goto out;
 	}
 
-	restart = &current_thread_info()->restart_block;
+	restart = &current->restart_block;
 	restart->fn = hrtimer_nanosleep_restart;
 	restart->nanosleep.clockid = t.timer.base->clockid;
 	restart->nanosleep.rmtp = rmtp;
diff -puN kernel/time/posix-cpu-timers.c~all-arches-signal-move-restart_block-to-struct-task_struct kernel/time/posix-cpu-timers.c
--- a/kernel/time/posix-cpu-timers.c~all-arches-signal-move-restart_block-to-struct-task_struct
+++ a/kernel/time/posix-cpu-timers.c
@@ -1334,8 +1334,7 @@ static long posix_cpu_nsleep_restart(str
 static int posix_cpu_nsleep(const clockid_t which_clock, int flags,
 			    struct timespec *rqtp, struct timespec __user *rmtp)
 {
-	struct restart_block *restart_block =
-		&current_thread_info()->restart_block;
+	struct restart_block *restart_block = &current->restart_block;
 	struct itimerspec it;
 	int error;
 
_

Patches currently in -mm which might be from luto@amacapital.net are

origin.patch
init-remove-config_init_fallback.patch
seccomp-cap-seccomp_ret_errno-data-to-max_errno.patch
linux-next.patch

