From: akpm@linux-foundation.org
Subject: - rename-thread_info-to-stack.patch removed from -mm tree
Date: Wed, 09 May 2007 14:54:20 -0700
Message-ID: <200705092154.l49LsKXX003163@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58321 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759411AbXEIV6Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:58:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zippel@linux-m68k.org, ak@muc.de, benh@kernel.crashing.org, blaisorblade@yahoo.it, chris@zankel.net, davem@davemloft.net, dhowells@redhat.com, geert@linux-m68k.org, gerg@uclinux.org, heiko.carstens@de.ibm.com, hskinnemoen@atmel.com, ink@jurassic.park.msu.ru, jdike@addtoit.com, kkojima@rr.iij4u.or.jp, lethal@linux-sh.org, paulus@samba.org, ralf@linux-mips.org, rc@rc0.org.uk, rmk@arm.linux.org.uk, rth@twiddle.net, schwidefsky@de.ibm.com, spyro@f2s.com, starvik@axis.com, takata@linux-m32r.org, tony.luck@intel.com, uclinux-v850@lsi.nec.co.jp, wli@holomorphy.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     rename thread_info to stack
has been removed from the -mm tree.  Its filename was
     rename-thread_info-to-stack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rename thread_info to stack
From: Roman Zippel <zippel@linux-m68k.org>

This finally renames the thread_info field in task structure to stack, so that
the assumptions about this field are gone and archs have more freedom about
placing the thread_info structure.

Nonbroken archs which have a proper thread pointer can do the access to both
current thread and task structure via a single pointer.

It'll allow for a few more cleanups of the fork code, from which e.g.  ia64
could benefit.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
[akpm@linux-foundation.org: build fix]
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Ian Molton <spyro@f2s.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Kazumoto Kojima <kkojima@rr.iij4u.or.jp>
Cc: Richard Curnow <rc@rc0.org.uk>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Cc: Miles Bader <uclinux-v850@lsi.nec.co.jp>
Cc: Andi Kleen <ak@muc.de>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/kernel/ptrace.c     |    6 +++---
 arch/h8300/kernel/asm-offsets.c   |    2 +-
 arch/ia64/kernel/mca.c            |    2 +-
 arch/mips/kernel/asm-offsets.c    |    2 +-
 arch/parisc/kernel/asm-offsets.c  |    2 +-
 arch/powerpc/kernel/asm-offsets.c |    2 +-
 arch/ppc/kernel/asm-offsets.c     |    2 +-
 arch/s390/kernel/asm-offsets.c    |    2 +-
 arch/sparc/kernel/asm-offsets.c   |    2 +-
 arch/v850/kernel/asm-offsets.c    |    2 +-
 arch/xtensa/kernel/asm-offsets.c  |    2 +-
 include/asm-alpha/thread_info.h   |    8 ++++----
 include/asm-blackfin/processor.h  |    6 +++---
 include/asm-blackfin/system.h     |    4 ++--
 include/asm-m68k/thread_info.h    |    6 +++---
 include/asm-x86_64/system.h       |    2 +-
 include/linux/init_task.h         |    2 +-
 include/linux/sched.h             |    8 ++++----
 kernel/fork.c                     |    4 ++--
 19 files changed, 33 insertions(+), 33 deletions(-)

diff -puN arch/blackfin/kernel/ptrace.c~rename-thread_info-to-stack arch/blackfin/kernel/ptrace.c
--- a/arch/blackfin/kernel/ptrace.c~rename-thread_info-to-stack
+++ a/arch/blackfin/kernel/ptrace.c
@@ -73,7 +73,7 @@
 static inline struct pt_regs *get_user_regs(struct task_struct *task)
 {
 	return (struct pt_regs *)
-	    ((unsigned long)task->thread_info +
+	    ((unsigned long)task_stack_page(task) +
 	     (THREAD_SIZE - sizeof(struct pt_regs)));
 }
 
@@ -99,7 +99,7 @@ static inline long get_reg(struct task_s
 	unsigned char *reg_ptr;
 
 	struct pt_regs *regs =
-	    (struct pt_regs *)((unsigned long)task->thread_info +
+	    (struct pt_regs *)((unsigned long)task_stack_page(task) +
 			       (THREAD_SIZE - sizeof(struct pt_regs)));
 	reg_ptr = (char *)regs;
 
@@ -125,7 +125,7 @@ put_reg(struct task_struct *task, int re
 	char * reg_ptr;
 
 	struct pt_regs *regs =
-	    (struct pt_regs *)((unsigned long)task->thread_info +
+	    (struct pt_regs *)((unsigned long)task_stack_page(task) +
 			       (THREAD_SIZE - sizeof(struct pt_regs)));
 	reg_ptr = (char *)regs;
 
diff -puN arch/h8300/kernel/asm-offsets.c~rename-thread_info-to-stack arch/h8300/kernel/asm-offsets.c
--- a/arch/h8300/kernel/asm-offsets.c~rename-thread_info-to-stack
+++ a/arch/h8300/kernel/asm-offsets.c
@@ -30,7 +30,7 @@ int main(void)
 	DEFINE(TASK_PTRACE, offsetof(struct task_struct, ptrace));
 	DEFINE(TASK_BLOCKED, offsetof(struct task_struct, blocked));
 	DEFINE(TASK_THREAD, offsetof(struct task_struct, thread));
-	DEFINE(TASK_THREAD_INFO, offsetof(struct task_struct, thread_info));
+	DEFINE(TASK_THREAD_INFO, offsetof(struct task_struct, stack));
 	DEFINE(TASK_MM, offsetof(struct task_struct, mm));
 	DEFINE(TASK_ACTIVE_MM, offsetof(struct task_struct, active_mm));
 
diff -puN arch/ia64/kernel/mca.c~rename-thread_info-to-stack arch/ia64/kernel/mca.c
--- a/arch/ia64/kernel/mca.c~rename-thread_info-to-stack
+++ a/arch/ia64/kernel/mca.c
@@ -1689,7 +1689,7 @@ format_mca_init_stack(void *mca_data, un
 	ti->preempt_count = 1;
 	ti->task = p;
 	ti->cpu = cpu;
-	p->thread_info = ti;
+	p->stack = ti;
 	p->state = TASK_UNINTERRUPTIBLE;
 	cpu_set(cpu, p->cpus_allowed);
 	INIT_LIST_HEAD(&p->tasks);
diff -puN arch/mips/kernel/asm-offsets.c~rename-thread_info-to-stack arch/mips/kernel/asm-offsets.c
--- a/arch/mips/kernel/asm-offsets.c~rename-thread_info-to-stack
+++ a/arch/mips/kernel/asm-offsets.c
@@ -82,7 +82,7 @@ void output_task_defines(void)
 {
 	text("/* MIPS task_struct offsets. */");
 	offset("#define TASK_STATE         ", struct task_struct, state);
-	offset("#define TASK_THREAD_INFO   ", struct task_struct, thread_info);
+	offset("#define TASK_THREAD_INFO   ", struct task_struct, stack);
 	offset("#define TASK_FLAGS         ", struct task_struct, flags);
 	offset("#define TASK_MM            ", struct task_struct, mm);
 	offset("#define TASK_PID           ", struct task_struct, pid);
diff -puN arch/parisc/kernel/asm-offsets.c~rename-thread_info-to-stack arch/parisc/kernel/asm-offsets.c
--- a/arch/parisc/kernel/asm-offsets.c~rename-thread_info-to-stack
+++ a/arch/parisc/kernel/asm-offsets.c
@@ -54,7 +54,7 @@
 
 int main(void)
 {
-	DEFINE(TASK_THREAD_INFO, offsetof(struct task_struct, thread_info));
+	DEFINE(TASK_THREAD_INFO, offsetof(struct task_struct, stack));
 	DEFINE(TASK_STATE, offsetof(struct task_struct, state));
 	DEFINE(TASK_FLAGS, offsetof(struct task_struct, flags));
 	DEFINE(TASK_SIGPENDING, offsetof(struct task_struct, pending));
diff -puN arch/powerpc/kernel/asm-offsets.c~rename-thread_info-to-stack arch/powerpc/kernel/asm-offsets.c
--- a/arch/powerpc/kernel/asm-offsets.c~rename-thread_info-to-stack
+++ a/arch/powerpc/kernel/asm-offsets.c
@@ -58,7 +58,7 @@ int main(void)
 #ifdef CONFIG_PPC64
 	DEFINE(AUDITCONTEXT, offsetof(struct task_struct, audit_context));
 #else
-	DEFINE(THREAD_INFO, offsetof(struct task_struct, thread_info));
+	DEFINE(THREAD_INFO, offsetof(struct task_struct, stack));
 	DEFINE(PTRACE, offsetof(struct task_struct, ptrace));
 #endif /* CONFIG_PPC64 */
 
diff -puN arch/ppc/kernel/asm-offsets.c~rename-thread_info-to-stack arch/ppc/kernel/asm-offsets.c
--- a/arch/ppc/kernel/asm-offsets.c~rename-thread_info-to-stack
+++ a/arch/ppc/kernel/asm-offsets.c
@@ -35,7 +35,7 @@ int
 main(void)
 {
 	DEFINE(THREAD, offsetof(struct task_struct, thread));
-	DEFINE(THREAD_INFO, offsetof(struct task_struct, thread_info));
+	DEFINE(THREAD_INFO, offsetof(struct task_struct, stack));
 	DEFINE(MM, offsetof(struct task_struct, mm));
 	DEFINE(PTRACE, offsetof(struct task_struct, ptrace));
 	DEFINE(KSP, offsetof(struct thread_struct, ksp));
diff -puN arch/s390/kernel/asm-offsets.c~rename-thread_info-to-stack arch/s390/kernel/asm-offsets.c
--- a/arch/s390/kernel/asm-offsets.c~rename-thread_info-to-stack
+++ a/arch/s390/kernel/asm-offsets.c
@@ -15,7 +15,7 @@
 
 int main(void)
 {
-	DEFINE(__THREAD_info, offsetof(struct task_struct, thread_info),);
+	DEFINE(__THREAD_info, offsetof(struct task_struct, stack),);
 	DEFINE(__THREAD_ksp, offsetof(struct task_struct, thread.ksp),);
 	DEFINE(__THREAD_per, offsetof(struct task_struct, thread.per_info),);
 	DEFINE(__THREAD_mm_segment,
diff -puN arch/sparc/kernel/asm-offsets.c~rename-thread_info-to-stack arch/sparc/kernel/asm-offsets.c
--- a/arch/sparc/kernel/asm-offsets.c~rename-thread_info-to-stack
+++ a/arch/sparc/kernel/asm-offsets.c
@@ -28,7 +28,7 @@ int foo(void)
 	DEFINE(AOFF_task_gid, offsetof(struct task_struct, gid));
 	DEFINE(AOFF_task_euid, offsetof(struct task_struct, euid));
 	DEFINE(AOFF_task_egid, offsetof(struct task_struct, egid));
-	/* DEFINE(THREAD_INFO, offsetof(struct task_struct, thread_info)); */
+	/* DEFINE(THREAD_INFO, offsetof(struct task_struct, stack)); */
 	DEFINE(ASIZ_task_uid,	sizeof(current->uid));
 	DEFINE(ASIZ_task_gid,	sizeof(current->gid));
 	DEFINE(ASIZ_task_euid,	sizeof(current->euid));
diff -puN arch/v850/kernel/asm-offsets.c~rename-thread_info-to-stack arch/v850/kernel/asm-offsets.c
--- a/arch/v850/kernel/asm-offsets.c~rename-thread_info-to-stack
+++ a/arch/v850/kernel/asm-offsets.c
@@ -29,7 +29,7 @@ int main (void)
 	DEFINE (TASK_PTRACE, offsetof (struct task_struct, ptrace));
 	DEFINE (TASK_BLOCKED, offsetof (struct task_struct, blocked));
 	DEFINE (TASK_THREAD, offsetof (struct task_struct, thread));
-	DEFINE (TASK_THREAD_INFO, offsetof (struct task_struct, thread_info));
+	DEFINE (TASK_THREAD_INFO, offsetof (struct task_struct, stack));
 	DEFINE (TASK_MM, offsetof (struct task_struct, mm));
 	DEFINE (TASK_ACTIVE_MM, offsetof (struct task_struct, active_mm));
 	DEFINE (TASK_PID, offsetof (struct task_struct, pid));
diff -puN arch/xtensa/kernel/asm-offsets.c~rename-thread_info-to-stack arch/xtensa/kernel/asm-offsets.c
--- a/arch/xtensa/kernel/asm-offsets.c~rename-thread_info-to-stack
+++ a/arch/xtensa/kernel/asm-offsets.c
@@ -70,7 +70,7 @@ int main(void)
 	DEFINE(TASK_ACTIVE_MM, offsetof (struct task_struct, active_mm));
 	DEFINE(TASK_PID, offsetof (struct task_struct, pid));
 	DEFINE(TASK_THREAD, offsetof (struct task_struct, thread));
-	DEFINE(TASK_THREAD_INFO, offsetof (struct task_struct, thread_info));
+	DEFINE(TASK_THREAD_INFO, offsetof (struct task_struct, stack));
 	DEFINE(TASK_STRUCT_SIZE, sizeof (struct task_struct));
 	BLANK();
 
diff -puN include/asm-alpha/thread_info.h~rename-thread_info-to-stack include/asm-alpha/thread_info.h
--- a/include/asm-alpha/thread_info.h~rename-thread_info-to-stack
+++ a/include/asm-alpha/thread_info.h
@@ -97,7 +97,7 @@ register struct thread_info *__current_t
 				 1 << TIF_UAC_SIGBUS)
 
 #define SET_UNALIGN_CTL(task,value)	({				     \
-	(task)->thread_info->flags = (((task)->thread_info->flags &	     \
+	task_thread_info(task)->flags = ((task_thread_info(task)->flags &    \
 		~ALPHA_UAC_MASK)					     \
 		| (((value) << ALPHA_UAC_SHIFT)       & (1<<TIF_UAC_NOPRINT))\
 		| (((value) << (ALPHA_UAC_SHIFT + 1)) & (1<<TIF_UAC_SIGBUS)) \
@@ -105,11 +105,11 @@ register struct thread_info *__current_t
 	0; })
 
 #define GET_UNALIGN_CTL(task,value)	({				\
-	put_user(((task)->thread_info->flags & (1 << TIF_UAC_NOPRINT))	\
+	put_user((task_thread_info(task)->flags & (1 << TIF_UAC_NOPRINT))\
 		  >> ALPHA_UAC_SHIFT					\
-		 | ((task)->thread_info->flags & (1 << TIF_UAC_SIGBUS))	\
+		 | (task_thread_info(task)->flags & (1 << TIF_UAC_SIGBUS))\
 		 >> (ALPHA_UAC_SHIFT + 1)				\
-		 | ((task)->thread_info->flags & (1 << TIF_UAC_NOFIX))	\
+		 | (task_thread_info(task)->flags & (1 << TIF_UAC_NOFIX))\
 		 >> (ALPHA_UAC_SHIFT - 1),				\
 		 (int __user *)(value));				\
 	})
diff -puN include/asm-blackfin/processor.h~rename-thread_info-to-stack include/asm-blackfin/processor.h
--- a/include/asm-blackfin/processor.h~rename-thread_info-to-stack
+++ a/include/asm-blackfin/processor.h
@@ -58,10 +58,10 @@ do {									\
 	(_regs)->pc = (_pc);						\
 	if (current->mm)						\
 		(_regs)->p5 = current->mm->start_data;			\
-	current->thread_info->l1_task_info.stack_start			\
+	task_thread_info(current)->l1_task_info.stack_start		\
 		= (void *)current->mm->context.stack_start;		\
-	current->thread_info->l1_task_info.lowest_sp = (void *)(_usp);	       	\
-	memcpy(L1_SCRATCH_TASK_INFO, &current->thread_info->l1_task_info,	\
+	task_thread_info(current)->l1_task_info.lowest_sp = (void *)(_usp); \
+	memcpy(L1_SCRATCH_TASK_INFO, &task_thread_info(current)->l1_task_info, \
 		sizeof(*L1_SCRATCH_TASK_INFO));				\
 	wrusp(_usp);							\
 } while(0)
diff -puN include/asm-blackfin/system.h~rename-thread_info-to-stack include/asm-blackfin/system.h
--- a/include/asm-blackfin/system.h~rename-thread_info-to-stack
+++ a/include/asm-blackfin/system.h
@@ -239,9 +239,9 @@ asmlinkage struct task_struct *resume(st
 
 #define switch_to(prev,next,last) \
 do {    \
-	memcpy (&prev->thread_info->l1_task_info, L1_SCRATCH_TASK_INFO, \
+	memcpy (&task_thread_info(prev)->l1_task_info, L1_SCRATCH_TASK_INFO, \
 		sizeof *L1_SCRATCH_TASK_INFO); \
-	memcpy (L1_SCRATCH_TASK_INFO, &next->thread_info->l1_task_info, \
+	memcpy (L1_SCRATCH_TASK_INFO, &task_thread_info(next)->l1_task_info, \
 		sizeof *L1_SCRATCH_TASK_INFO); \
 	(last) = resume (prev, next);   \
 } while (0)
diff -puN include/asm-m68k/thread_info.h~rename-thread_info-to-stack include/asm-m68k/thread_info.h
--- a/include/asm-m68k/thread_info.h~rename-thread_info-to-stack
+++ a/include/asm-m68k/thread_info.h
@@ -37,17 +37,17 @@ struct thread_info {
 #define init_stack		(init_thread_union.stack)
 
 #define task_thread_info(tsk)	(&(tsk)->thread.info)
-#define task_stack_page(tsk)	((void *)(tsk)->thread_info)
+#define task_stack_page(tsk)	((tsk)->stack)
 #define current_thread_info()	task_thread_info(current)
 
 #define __HAVE_THREAD_FUNCTIONS
 
 #define setup_thread_stack(p, org) ({			\
-	*(struct task_struct **)(p)->thread_info = (p);	\
+	*(struct task_struct **)(p)->stack = (p);	\
 	task_thread_info(p)->task = (p);		\
 })
 
-#define end_of_stack(p) ((unsigned long *)(p)->thread_info + 1)
+#define end_of_stack(p) ((unsigned long *)(p)->stack + 1)
 
 /* entry.S relies on these definitions!
  * bits 0-7 are tested at every exception exit
diff -puN include/asm-x86_64/system.h~rename-thread_info-to-stack include/asm-x86_64/system.h
--- a/include/asm-x86_64/system.h~rename-thread_info-to-stack
+++ a/include/asm-x86_64/system.h
@@ -39,7 +39,7 @@
 		       [threadrsp] "i" (offsetof(struct task_struct, thread.rsp)), \
 		       [ti_flags] "i" (offsetof(struct thread_info, flags)),\
 		       [tif_fork] "i" (TIF_FORK),			  \
-		       [thread_info] "i" (offsetof(struct task_struct, thread_info)), \
+		       [thread_info] "i" (offsetof(struct task_struct, stack)), \
 		       [pda_pcurrent] "i" (offsetof(struct x8664_pda, pcurrent))   \
 		     : "memory", "cc" __EXTRA_CLOBBER)
     
diff -puN include/linux/init_task.h~rename-thread_info-to-stack include/linux/init_task.h
--- a/include/linux/init_task.h~rename-thread_info-to-stack
+++ a/include/linux/init_task.h
@@ -95,7 +95,7 @@ extern struct group_info init_groups;
 #define INIT_TASK(tsk)	\
 {									\
 	.state		= 0,						\
-	.thread_info	= &init_thread_info,				\
+	.stack		= &init_thread_info,				\
 	.usage		= ATOMIC_INIT(2),				\
 	.flags		= 0,						\
 	.lock_depth	= -1,						\
diff -puN include/linux/sched.h~rename-thread_info-to-stack include/linux/sched.h
--- a/include/linux/sched.h~rename-thread_info-to-stack
+++ a/include/linux/sched.h
@@ -817,7 +817,7 @@ struct prio_array;
 
 struct task_struct {
 	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
-	struct thread_info *thread_info;
+	void *stack;
 	atomic_t usage;
 	unsigned int flags;	/* per process flags, defined below */
 	unsigned int ptrace;
@@ -1514,8 +1514,8 @@ static inline void unlock_task_sighand(s
 
 #ifndef __HAVE_THREAD_FUNCTIONS
 
-#define task_thread_info(task) (task)->thread_info
-#define task_stack_page(task) ((void*)((task)->thread_info))
+#define task_thread_info(task)	((struct thread_info *)(task)->stack)
+#define task_stack_page(task)	((task)->stack)
 
 static inline void setup_thread_stack(struct task_struct *p, struct task_struct *org)
 {
@@ -1525,7 +1525,7 @@ static inline void setup_thread_stack(st
 
 static inline unsigned long *end_of_stack(struct task_struct *p)
 {
-	return (unsigned long *)(p->thread_info + 1);
+	return (unsigned long *)(task_thread_info(p) + 1);
 }
 
 #endif
diff -puN kernel/fork.c~rename-thread_info-to-stack kernel/fork.c
--- a/kernel/fork.c~rename-thread_info-to-stack
+++ a/kernel/fork.c
@@ -106,7 +106,7 @@ static struct kmem_cache *mm_cachep;
 
 void free_task(struct task_struct *tsk)
 {
-	free_thread_info(tsk->thread_info);
+	free_thread_info(tsk->stack);
 	rt_mutex_debug_task_free(tsk);
 	free_task_struct(tsk);
 }
@@ -176,7 +176,7 @@ static struct task_struct *dup_task_stru
 	}
 
 	*tsk = *orig;
-	tsk->thread_info = ti;
+	tsk->stack = ti;
 	setup_thread_stack(tsk, orig);
 
 #ifdef CONFIG_CC_STACKPROTECTOR
_

Patches currently in -mm which might be from zippel@linux-m68k.org are

origin.patch
