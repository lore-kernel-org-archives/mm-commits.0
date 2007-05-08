From: akpm@linux-foundation.org
Subject: + rename-thread_info-to-stack-fix-2.patch added to -mm tree
Date: Tue, 08 May 2007 13:48:27 -0700
Message-ID: <200705082048.l48KmRwI001237@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934320AbXEHUsg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 16:48:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zippel@linux-m68k.org


The patch titled
     rename-thread_info-to-stack-fix 2
has been added to the -mm tree.  Its filename is
     rename-thread_info-to-stack-fix-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rename-thread_info-to-stack-fix 2
From: Roman Zippel <zippel@linux-m68k.org>

The two changes to asm-offsets.c belong to second rename patch and the
rest is for the first wrapper patch.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/kernel/ptrace.c    |    6 +++---
 include/asm-alpha/thread_info.h  |    8 ++++----
 include/asm-blackfin/processor.h |    6 +++---
 include/asm-blackfin/system.h    |    4 ++--
 4 files changed, 12 insertions(+), 12 deletions(-)

diff -puN arch/blackfin/kernel/ptrace.c~rename-thread_info-to-stack-fix-2 arch/blackfin/kernel/ptrace.c
--- a/arch/blackfin/kernel/ptrace.c~rename-thread_info-to-stack-fix-2
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
 
diff -puN include/asm-alpha/thread_info.h~rename-thread_info-to-stack-fix-2 include/asm-alpha/thread_info.h
--- a/include/asm-alpha/thread_info.h~rename-thread_info-to-stack-fix-2
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
diff -puN include/asm-blackfin/processor.h~rename-thread_info-to-stack-fix-2 include/asm-blackfin/processor.h
--- a/include/asm-blackfin/processor.h~rename-thread_info-to-stack-fix-2
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
diff -puN include/asm-blackfin/system.h~rename-thread_info-to-stack-fix-2 include/asm-blackfin/system.h
--- a/include/asm-blackfin/system.h~rename-thread_info-to-stack-fix-2
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
_

Patches currently in -mm which might be from zippel@linux-m68k.org are

origin.patch
is_power_of_2-in-fs-hfs.patch
optimize-timespec_trunc.patch
allow-arch-to-initialize-arch-field-of-the-module-structure.patch
wrap-access-to-thread_info.patch
wrap-access-to-thread_info-fix.patch
rename-thread_info-to-stack.patch
rename-thread_info-to-stack-fix.patch
rename-thread_info-to-stack-fix-2.patch
