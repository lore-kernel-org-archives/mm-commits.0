Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFE37ECAAD5
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 04:57:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiILE5D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Sep 2022 00:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiILE4r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2022 00:56:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2684727DE4
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 21:56:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F3A1B80BA9
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 04:56:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A8BC433C1;
        Mon, 12 Sep 2022 04:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662958590;
        bh=X2mDgNG+rGpGAF6QbJX6xDEN0P9vQwwah4jOaMMAlhM=;
        h=Date:To:From:Subject:From;
        b=i+Sf+AmIfeBtLbsLfBmRLjCzF/w7mPjcWjT3F+wOlXDVTcAxQWPdr9WHb20J8EBjG
         joZFw4M/tduI3k4vyABwu81jprvI2IW3Hz0vV9elDkZMvqh3jUp2WfuIw8wwo0AnFJ
         uIk2QvlKk2dIb3tLgNZeZUbDKhD/gbJ6cP+NHsY4=
Date:   Sun, 11 Sep 2022 21:56:29 -0700
To:     mm-commits@vger.kernel.org, ysato@users.osdn.me, will@kernel.org,
        vgupta@kernel.org, tsbogend@alpha.franken.de, tglx@linutronix.de,
        svens@linux.ibm.com, stefan.kristiansson@saunalahti.fi,
        shorne@gmail.com, rmk+kernel@armlinux.org.uk, richard@nod.at,
        richard.henderson@linaro.org, paul.walmsley@sifive.com,
        palmer@dabbelt.com, npiggin@gmail.com, mpe@ellerman.id.au,
        monstr@monstr.eu, mingo@redhat.com, mattst88@gmail.com,
        kernel@xen0n.name, jonas@southpole.se, johannes@sipsolutions.net,
        jcmvbkbc@gmail.com, James.Bottomley@HansenPartnership.com,
        ink@jurassic.park.msu.ru, hca@linux.ibm.com, guoren@kernel.org,
        gor@linux.ibm.com, geert@linux-m68k.org, dinguyen@kernel.org,
        deller@gmx.de, davem@davemloft.net, dave.hansen@linux.intel.com,
        dalias@libc.org, chris@zankel.net, christophe.leroy@csgroup.eu,
        chenhuacai@kernel.org, catalin.marinas@arm.com, bp@alien8.de,
        borntraeger@linux.ibm.com, bcain@quicinc.com,
        anton.ivanov@cambridgegreys.com, agordeev@linux.ibm.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-exit-cleanup-release_thread.patch removed from -mm tree
Message-Id: <20220912045630.30A8BC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kernel: exit: cleanup release_thread()
has been removed from the -mm tree.  Its filename was
     kernel-exit-cleanup-release_thread.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: kernel: exit: cleanup release_thread()
Date: Fri, 19 Aug 2022 09:44:06 +0800

Only x86 has own release_thread(), introduce a new weak release_thread()
function to clean empty definitions in other ARCHs.

Link: https://lkml.kernel.org/r/20220819014406.32266-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Guo Ren <guoren@kernel.org>				[csky]
Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Brian Cain <bcain@quicinc.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>			[powerpc]
Acked-by: Stafford Horne <shorne@gmail.com>			[openrisc]
Acked-by: Catalin Marinas <catalin.marinas@arm.com>		[arm64]
Acked-by: Huacai Chen <chenhuacai@kernel.org>			[LoongArch]
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Chris Zankel <chris@zankel.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Guo Ren <guoren@kernel.org> [csky]
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Rich Felker <dalias@libc.org>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Xuerui Wang <kernel@xen0n.name>
Cc: Yoshinori Sato <ysato@users.osdn.me>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/processor.h      |    2 --
 arch/alpha/kernel/process.c             |    5 -----
 arch/arc/include/asm/processor.h        |    3 ---
 arch/arm/include/asm/processor.h        |    3 ---
 arch/arm/kernel/process.c               |    4 ----
 arch/arm64/include/asm/processor.h      |    3 ---
 arch/arm64/kernel/process.c             |    4 ----
 arch/csky/include/asm/processor.h       |    5 -----
 arch/hexagon/include/asm/processor.h    |    4 ----
 arch/hexagon/kernel/process.c           |    7 -------
 arch/ia64/include/asm/processor.h       |    7 -------
 arch/loongarch/include/asm/processor.h  |    3 ---
 arch/m68k/include/asm/processor.h       |    5 -----
 arch/microblaze/include/asm/processor.h |    5 -----
 arch/mips/include/asm/processor.h       |    3 ---
 arch/nios2/include/asm/processor.h      |    5 -----
 arch/openrisc/include/asm/processor.h   |    1 -
 arch/openrisc/kernel/process.c          |    4 ----
 arch/parisc/include/asm/processor.h     |    3 ---
 arch/parisc/kernel/process.c            |    4 ----
 arch/powerpc/include/asm/processor.h    |    1 -
 arch/powerpc/kernel/process.c           |    5 -----
 arch/riscv/include/asm/processor.h      |    5 -----
 arch/s390/include/asm/processor.h       |    3 ---
 arch/sh/include/asm/processor_32.h      |    3 ---
 arch/sh/kernel/process_32.c             |    5 -----
 arch/sparc/include/asm/processor_32.h   |    3 ---
 arch/sparc/include/asm/processor_64.h   |    3 ---
 arch/um/include/asm/processor-generic.h |    4 ----
 arch/x86/include/asm/processor.h        |    3 ---
 arch/xtensa/include/asm/processor.h     |    3 ---
 include/linux/sched/task.h              |    3 +++
 kernel/exit.c                           |    4 ++++
 33 files changed, 7 insertions(+), 118 deletions(-)

--- a/arch/alpha/include/asm/processor.h~kernel-exit-cleanup-release_thread
+++ a/arch/alpha/include/asm/processor.h
@@ -36,8 +36,6 @@ extern void start_thread(struct pt_regs
 
 /* Free all resources held by a thread. */
 struct task_struct;
-extern void release_thread(struct task_struct *);
-
 unsigned long __get_wchan(struct task_struct *p);
 
 #define KSTK_EIP(tsk) (task_pt_regs(tsk)->pc)
--- a/arch/alpha/kernel/process.c~kernel-exit-cleanup-release_thread
+++ a/arch/alpha/kernel/process.c
@@ -225,11 +225,6 @@ flush_thread(void)
 	current_thread_info()->pcb.unique = 0;
 }
 
-void
-release_thread(struct task_struct *dead_task)
-{
-}
-
 /*
  * Copy architecture-specific thread state
  */
--- a/arch/arc/include/asm/processor.h~kernel-exit-cleanup-release_thread
+++ a/arch/arc/include/asm/processor.h
@@ -43,9 +43,6 @@ struct task_struct;
 #define task_pt_regs(p) \
 	((struct pt_regs *)(THREAD_SIZE + (void *)task_stack_page(p)) - 1)
 
-/* Free all resources held by a thread */
-#define release_thread(thread) do { } while (0)
-
 /*
  * A lot of busy-wait loops in SMP are based off of non-volatile data otherwise
  * get optimised away by gcc
--- a/arch/arm64/include/asm/processor.h~kernel-exit-cleanup-release_thread
+++ a/arch/arm64/include/asm/processor.h
@@ -323,9 +323,6 @@ static inline bool is_ttbr1_addr(unsigne
 /* Forward declaration, a strange C thing */
 struct task_struct;
 
-/* Free all resources held by a thread. */
-extern void release_thread(struct task_struct *);
-
 unsigned long __get_wchan(struct task_struct *p);
 
 void update_sctlr_el1(u64 sctlr);
--- a/arch/arm64/kernel/process.c~kernel-exit-cleanup-release_thread
+++ a/arch/arm64/kernel/process.c
@@ -279,10 +279,6 @@ void flush_thread(void)
 	flush_tagged_addr_state();
 }
 
-void release_thread(struct task_struct *dead_task)
-{
-}
-
 void arch_release_task_struct(struct task_struct *tsk)
 {
 	fpsimd_release_task(tsk);
--- a/arch/arm/include/asm/processor.h~kernel-exit-cleanup-release_thread
+++ a/arch/arm/include/asm/processor.h
@@ -81,9 +81,6 @@ static inline void arch_thread_struct_wh
 /* Forward declaration, a strange C thing */
 struct task_struct;
 
-/* Free all resources held by a thread. */
-extern void release_thread(struct task_struct *);
-
 unsigned long __get_wchan(struct task_struct *p);
 
 #define task_pt_regs(p) \
--- a/arch/arm/kernel/process.c~kernel-exit-cleanup-release_thread
+++ a/arch/arm/kernel/process.c
@@ -232,10 +232,6 @@ void flush_thread(void)
 	thread_notify(THREAD_NOTIFY_FLUSH, thread);
 }
 
-void release_thread(struct task_struct *dead_task)
-{
-}
-
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 
 int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
--- a/arch/csky/include/asm/processor.h~kernel-exit-cleanup-release_thread
+++ a/arch/csky/include/asm/processor.h
@@ -69,11 +69,6 @@ do {									\
 /* Forward declaration, a strange C thing */
 struct task_struct;
 
-/* Free all resources held by a thread. */
-static inline void release_thread(struct task_struct *dead_task)
-{
-}
-
 /* Prepare to copy thread state - unlazy all lazy status */
 #define prepare_to_copy(tsk)    do { } while (0)
 
--- a/arch/hexagon/include/asm/processor.h~kernel-exit-cleanup-release_thread
+++ a/arch/hexagon/include/asm/processor.h
@@ -60,10 +60,6 @@ struct thread_struct {
 #define KSTK_EIP(tsk) (pt_elr(task_pt_regs(tsk)))
 #define KSTK_ESP(tsk) (pt_psp(task_pt_regs(tsk)))
 
-/*  Free all resources held by a thread; defined in process.c  */
-extern void release_thread(struct task_struct *dead_task);
-
-/* Get wait channel for task P.  */
 extern unsigned long __get_wchan(struct task_struct *p);
 
 /*  The following stuff is pretty HEXAGON specific.  */
--- a/arch/hexagon/kernel/process.c~kernel-exit-cleanup-release_thread
+++ a/arch/hexagon/kernel/process.c
@@ -113,13 +113,6 @@ int copy_thread(struct task_struct *p, c
 }
 
 /*
- * Release any architecture-specific resources locked by thread
- */
-void release_thread(struct task_struct *dead_task)
-{
-}
-
-/*
  * Some archs flush debug and FPU info here
  */
 void flush_thread(void)
--- a/arch/ia64/include/asm/processor.h~kernel-exit-cleanup-release_thread
+++ a/arch/ia64/include/asm/processor.h
@@ -318,13 +318,6 @@ struct thread_struct {
 struct mm_struct;
 struct task_struct;
 
-/*
- * Free all resources held by a thread. This is called after the
- * parent of DEAD_TASK has collected the exit status of the task via
- * wait().
- */
-#define release_thread(dead_task)
-
 /* Get wait channel for task P.  */
 extern unsigned long __get_wchan (struct task_struct *p);
 
--- a/arch/loongarch/include/asm/processor.h~kernel-exit-cleanup-release_thread
+++ a/arch/loongarch/include/asm/processor.h
@@ -176,9 +176,6 @@ struct thread_struct {
 
 struct task_struct;
 
-/* Free all resources held by a thread. */
-#define release_thread(thread) do { } while (0)
-
 enum idle_boot_override {IDLE_NO_OVERRIDE = 0, IDLE_HALT, IDLE_NOMWAIT, IDLE_POLL};
 
 extern unsigned long		boot_option_idle_override;
--- a/arch/m68k/include/asm/processor.h~kernel-exit-cleanup-release_thread
+++ a/arch/m68k/include/asm/processor.h
@@ -145,11 +145,6 @@ static inline void start_thread(struct p
 /* Forward declaration, a strange C thing */
 struct task_struct;
 
-/* Free all resources held by a thread. */
-static inline void release_thread(struct task_struct *dead_task)
-{
-}
-
 unsigned long __get_wchan(struct task_struct *p);
 void show_registers(struct pt_regs *regs);
 
--- a/arch/microblaze/include/asm/processor.h~kernel-exit-cleanup-release_thread
+++ a/arch/microblaze/include/asm/processor.h
@@ -63,11 +63,6 @@ struct thread_struct {
 	.pgdir = swapper_pg_dir, \
 }
 
-/* Free all resources held by a thread. */
-static inline void release_thread(struct task_struct *dead_task)
-{
-}
-
 unsigned long __get_wchan(struct task_struct *p);
 
 /* The size allocated for kernel stacks. This _must_ be a power of two! */
--- a/arch/mips/include/asm/processor.h~kernel-exit-cleanup-release_thread
+++ a/arch/mips/include/asm/processor.h
@@ -344,9 +344,6 @@ struct thread_struct {
 
 struct task_struct;
 
-/* Free all resources held by a thread. */
-#define release_thread(thread) do { } while(0)
-
 /*
  * Do necessary setup to start up a newly executed thread.
  */
--- a/arch/nios2/include/asm/processor.h~kernel-exit-cleanup-release_thread
+++ a/arch/nios2/include/asm/processor.h
@@ -64,11 +64,6 @@ extern void start_thread(struct pt_regs
 
 struct task_struct;
 
-/* Free all resources held by a thread. */
-static inline void release_thread(struct task_struct *dead_task)
-{
-}
-
 extern unsigned long __get_wchan(struct task_struct *p);
 
 #define task_pt_regs(p) \
--- a/arch/openrisc/include/asm/processor.h~kernel-exit-cleanup-release_thread
+++ a/arch/openrisc/include/asm/processor.h
@@ -72,7 +72,6 @@ struct thread_struct {
 
 
 void start_thread(struct pt_regs *regs, unsigned long nip, unsigned long sp);
-void release_thread(struct task_struct *);
 unsigned long __get_wchan(struct task_struct *p);
 
 #define cpu_relax()     barrier()
--- a/arch/openrisc/kernel/process.c~kernel-exit-cleanup-release_thread
+++ a/arch/openrisc/kernel/process.c
@@ -125,10 +125,6 @@ void show_regs(struct pt_regs *regs)
 	show_registers(regs);
 }
 
-void release_thread(struct task_struct *dead_task)
-{
-}
-
 /*
  * Copy the thread-specific (arch specific) info from the current
  * process to the new one p
--- a/arch/parisc/include/asm/processor.h~kernel-exit-cleanup-release_thread
+++ a/arch/parisc/include/asm/processor.h
@@ -266,9 +266,6 @@ on downward growing arches, it looks lik
 
 struct mm_struct;
 
-/* Free all resources held by a thread. */
-extern void release_thread(struct task_struct *);
-
 extern unsigned long __get_wchan(struct task_struct *p);
 
 #define KSTK_EIP(tsk)	((tsk)->thread.regs.iaoq[0])
--- a/arch/parisc/kernel/process.c~kernel-exit-cleanup-release_thread
+++ a/arch/parisc/kernel/process.c
@@ -146,10 +146,6 @@ void flush_thread(void)
 	*/
 }
 
-void release_thread(struct task_struct *dead_task)
-{
-}
-
 /*
  * Idle thread support
  *
--- a/arch/powerpc/include/asm/processor.h~kernel-exit-cleanup-release_thread
+++ a/arch/powerpc/include/asm/processor.h
@@ -75,7 +75,6 @@ extern int _chrp_type;
 
 struct task_struct;
 void start_thread(struct pt_regs *regs, unsigned long fdptr, unsigned long sp);
-void release_thread(struct task_struct *);
 
 #define TS_FPR(i) fp_state.fpr[i][TS_FPROFFSET]
 #define TS_CKFPR(i) ckfp_state.fpr[i][TS_FPROFFSET]
--- a/arch/powerpc/kernel/process.c~kernel-exit-cleanup-release_thread
+++ a/arch/powerpc/kernel/process.c
@@ -1655,11 +1655,6 @@ EXPORT_SYMBOL_GPL(set_thread_tidr);
 
 #endif /* CONFIG_PPC64 */
 
-void
-release_thread(struct task_struct *t)
-{
-}
-
 /*
  * this gets called so that we can store coprocessor state into memory and
  * copy the current task into the new thread.
--- a/arch/riscv/include/asm/processor.h~kernel-exit-cleanup-release_thread
+++ a/arch/riscv/include/asm/processor.h
@@ -65,11 +65,6 @@ static inline void arch_thread_struct_wh
 extern void start_thread(struct pt_regs *regs,
 			unsigned long pc, unsigned long sp);
 
-/* Free all resources held by a thread. */
-static inline void release_thread(struct task_struct *dead_task)
-{
-}
-
 extern unsigned long __get_wchan(struct task_struct *p);
 
 
--- a/arch/s390/include/asm/processor.h~kernel-exit-cleanup-release_thread
+++ a/arch/s390/include/asm/processor.h
@@ -186,9 +186,6 @@ struct pt_regs;
 void show_registers(struct pt_regs *regs);
 void show_cacheinfo(struct seq_file *m);
 
-/* Free all resources held by a thread. */
-static inline void release_thread(struct task_struct *tsk) { }
-
 /* Free guarded storage control block */
 void guarded_storage_release(struct task_struct *tsk);
 void gs_load_bc_cb(struct pt_regs *regs);
--- a/arch/sh/include/asm/processor_32.h~kernel-exit-cleanup-release_thread
+++ a/arch/sh/include/asm/processor_32.h
@@ -127,9 +127,6 @@ struct task_struct;
 
 extern void start_thread(struct pt_regs *regs, unsigned long new_pc, unsigned long new_sp);
 
-/* Free all resources held by a thread. */
-extern void release_thread(struct task_struct *);
-
 /*
  * FPU lazy state save handling.
  */
--- a/arch/sh/kernel/process_32.c~kernel-exit-cleanup-release_thread
+++ a/arch/sh/kernel/process_32.c
@@ -84,11 +84,6 @@ void flush_thread(void)
 #endif
 }
 
-void release_thread(struct task_struct *dead_task)
-{
-	/* do nothing */
-}
-
 asmlinkage void ret_from_fork(void);
 asmlinkage void ret_from_kernel_thread(void);
 
--- a/arch/sparc/include/asm/processor_32.h~kernel-exit-cleanup-release_thread
+++ a/arch/sparc/include/asm/processor_32.h
@@ -80,9 +80,6 @@ static inline void start_thread(struct p
 			     : "memory");
 }
 
-/* Free all resources held by a thread. */
-#define release_thread(tsk)		do { } while(0)
-
 unsigned long __get_wchan(struct task_struct *);
 
 #define task_pt_regs(tsk) ((tsk)->thread.kregs)
--- a/arch/sparc/include/asm/processor_64.h~kernel-exit-cleanup-release_thread
+++ a/arch/sparc/include/asm/processor_64.h
@@ -176,9 +176,6 @@ do { \
 	regs->tstate &= ~TSTATE_PEF;	\
 } while (0)
 
-/* Free all resources held by a thread. */
-#define release_thread(tsk)		do { } while (0)
-
 unsigned long __get_wchan(struct task_struct *task);
 
 #define task_pt_regs(tsk) (task_thread_info(tsk)->kregs)
--- a/arch/um/include/asm/processor-generic.h~kernel-exit-cleanup-release_thread
+++ a/arch/um/include/asm/processor-generic.h
@@ -55,10 +55,6 @@ struct thread_struct {
 	.request		= { 0 } \
 }
 
-static inline void release_thread(struct task_struct *task)
-{
-}
-
 /*
  * User space process size: 3GB (default).
  */
--- a/arch/x86/include/asm/processor.h~kernel-exit-cleanup-release_thread
+++ a/arch/x86/include/asm/processor.h
@@ -587,9 +587,6 @@ static inline void load_sp0(unsigned lon
 
 #endif /* CONFIG_PARAVIRT_XXL */
 
-/* Free all resources held by a thread. */
-extern void release_thread(struct task_struct *);
-
 unsigned long __get_wchan(struct task_struct *p);
 
 /*
--- a/arch/xtensa/include/asm/processor.h~kernel-exit-cleanup-release_thread
+++ a/arch/xtensa/include/asm/processor.h
@@ -221,9 +221,6 @@ struct thread_struct {
 struct task_struct;
 struct mm_struct;
 
-/* Free all resources held by a thread. */
-#define release_thread(thread) do { } while(0)
-
 extern unsigned long __get_wchan(struct task_struct *p);
 
 #define KSTK_EIP(tsk)		(task_pt_regs(tsk)->pc)
--- a/include/linux/sched/task.h~kernel-exit-cleanup-release_thread
+++ a/include/linux/sched/task.h
@@ -127,6 +127,9 @@ static inline void put_task_struct_many(
 
 void put_task_struct_rcu_user(struct task_struct *task);
 
+/* Free all architecture-specific resources held by a thread. */
+void release_thread(struct task_struct *dead_task);
+
 #ifdef CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT
 extern int arch_task_struct_size __read_mostly;
 #else
--- a/kernel/exit.c~kernel-exit-cleanup-release_thread
+++ a/kernel/exit.c
@@ -183,6 +183,10 @@ void put_task_struct_rcu_user(struct tas
 		call_rcu(&task->rcu, delayed_put_task_struct);
 }
 
+void __weak release_thread(struct task_struct *dead_task)
+{
+}
+
 void release_task(struct task_struct *p)
 {
 	struct task_struct *leader;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-reuse-pageblock_start-end_pfn-macro.patch
mm-add-pageblock_align-macro.patch
mm-add-pageblock_aligned-macro.patch
memblock-tests-add-new-pageblock-related-macro.patch

