From: akpm@linux-foundation.org
Subject: + rename-thread_info-to-stack.patch added to -mm tree
Date: Wed, 02 May 2007 21:27:31 -0700
Message-ID: <200705030427.l434RVbf004709@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51664 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767382AbXECE1t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 00:27:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zippel@linux-m68k.org


The patch titled
     rename thread_info to stack
has been added to the -mm tree.  Its filename is
     rename-thread_info-to-stack.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rename thread_info to stack
From: Roman Zippel <zippel@linux-m68k.org>

This finally renames the thread_info field in task structure to stack, so that
the assumptions about this field are gone and archs have more freedom about
placing the thread_info structure.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

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
 include/asm-m68k/thread_info.h    |    6 +++---
 include/linux/init_task.h         |    2 +-
 include/linux/sched.h             |    8 ++++----
 kernel/fork.c                     |    4 ++--
 14 files changed, 20 insertions(+), 20 deletions(-)

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
diff -puN include/linux/init_task.h~rename-thread_info-to-stack include/linux/init_task.h
--- a/include/linux/init_task.h~rename-thread_info-to-stack
+++ a/include/linux/init_task.h
@@ -118,7 +118,7 @@ extern struct group_info init_groups;
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
@@ -832,7 +832,7 @@ struct prio_array;
 
 struct task_struct {
 	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
-	struct thread_info *thread_info;
+	void *stack;
 	atomic_t usage;
 	unsigned int flags;	/* per process flags, defined below */
 	unsigned int ptrace;
@@ -1529,8 +1529,8 @@ static inline void unlock_task_sighand(s
 
 #ifndef __HAVE_THREAD_FUNCTIONS
 
-#define task_thread_info(task) (task)->thread_info
-#define task_stack_page(task) ((void*)((task)->thread_info))
+#define task_thread_info(task)	((struct thread_info *)(task)->stack)
+#define task_stack_page(task)	((task)->stack)
 
 static inline void setup_thread_stack(struct task_struct *p, struct task_struct *org)
 {
@@ -1540,7 +1540,7 @@ static inline void setup_thread_stack(st
 
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
@@ -177,7 +177,7 @@ static struct task_struct *dup_task_stru
 	}
 
 	*tsk = *orig;
-	tsk->thread_info = ti;
+	tsk->stack = ti;
 	setup_thread_stack(tsk, orig);
 
 #ifdef CONFIG_CC_STACKPROTECTOR
_

Patches currently in -mm which might be from zippel@linux-m68k.org are

origin.patch
introduce-config_has_dma.patch
remove-unused-header-file-arch-m68k-atari-atasoundh.patch
spin_lock_unlocked-cleanup-in-arch-m68k.patch
git-kbuild.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
is_power_of_2-in-fs-hfs.patch
optimize-timespec_trunc.patch
allow-arch-to-initialize-arch-field-of-the-module-structure.patch
wrap-access-to-thread_info.patch
rename-thread_info-to-stack.patch
