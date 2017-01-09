From: akpm@linux-foundation.org
Subject: + mm-add-new-mmgrab-helper.patch added to -mm tree
Date: Mon, 09 Jan 2017 15:20:26 -0800
Message-ID: <58741aba.MwSLcx4FHME+tO39%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45842 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932083AbdAIXTA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2017 18:19:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vegard.nossum@oracle.com, mhocko@suse.com, peterz@infradead.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add new mmgrab() helper
has been added to the -mm tree.  Its filename is
     mm-add-new-mmgrab-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-new-mmgrab-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-new-mmgrab-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: mm: add new mmgrab() helper

Apart from adding the helper function itself, the rest of the kernel is
converted mechanically using:

  git grep -l 'atomic_inc.*mm_count' | xargs sed -i 's/atomic_inc(&\(.*\)->mm_count);/mmgrab\(\1\);/'
  git grep -l 'atomic_inc.*mm_count' | xargs sed -i 's/atomic_inc(&\(.*\)\.mm_count);/mmgrab\(\&\1\);/'

This is needed for a later patch that hooks into the helper, but might be
a worthwhile cleanup on its own.

(Michal Hocko provided most of the kerneldoc comment.)

Link: http://lkml.kernel.org/r/20161218123229.22952-1-vegard.nossum@oracle.com
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/smp.c                  |    2 -
 arch/arc/kernel/smp.c                    |    2 -
 arch/arm/kernel/smp.c                    |    2 -
 arch/arm64/kernel/smp.c                  |    2 -
 arch/blackfin/mach-common/smp.c          |    2 -
 arch/hexagon/kernel/smp.c                |    2 -
 arch/ia64/kernel/setup.c                 |    2 -
 arch/m32r/kernel/setup.c                 |    2 -
 arch/metag/kernel/smp.c                  |    2 -
 arch/mips/kernel/traps.c                 |    2 -
 arch/mn10300/kernel/smp.c                |    2 -
 arch/parisc/kernel/smp.c                 |    2 -
 arch/powerpc/kernel/smp.c                |    2 -
 arch/s390/kernel/processor.c             |    2 -
 arch/score/kernel/traps.c                |    2 -
 arch/sh/kernel/smp.c                     |    2 -
 arch/sparc/kernel/leon_smp.c             |    2 -
 arch/sparc/kernel/smp_64.c               |    2 -
 arch/sparc/kernel/sun4d_smp.c            |    2 -
 arch/sparc/kernel/sun4m_smp.c            |    2 -
 arch/sparc/kernel/traps_32.c             |    2 -
 arch/sparc/kernel/traps_64.c             |    2 -
 arch/tile/kernel/smpboot.c               |    2 -
 arch/x86/kernel/cpu/common.c             |    4 +--
 arch/xtensa/kernel/smp.c                 |    2 -
 drivers/gpu/drm/amd/amdkfd/kfd_process.c |    2 -
 drivers/gpu/drm/i915/i915_gem_userptr.c  |    2 -
 drivers/infiniband/hw/hfi1/file_ops.c    |    2 -
 fs/proc/base.c                           |    4 +--
 fs/userfaultfd.c                         |    2 -
 include/linux/sched.h                    |   22 +++++++++++++++++++++
 kernel/exit.c                            |    2 -
 kernel/futex.c                           |    2 -
 kernel/sched/core.c                      |    4 +--
 mm/khugepaged.c                          |    2 -
 mm/ksm.c                                 |    2 -
 mm/mmu_context.c                         |    2 -
 mm/mmu_notifier.c                        |    2 -
 mm/oom_kill.c                            |    4 +--
 virt/kvm/kvm_main.c                      |    2 -
 40 files changed, 65 insertions(+), 43 deletions(-)

diff -puN arch/alpha/kernel/smp.c~mm-add-new-mmgrab-helper arch/alpha/kernel/smp.c
--- a/arch/alpha/kernel/smp.c~mm-add-new-mmgrab-helper
+++ a/arch/alpha/kernel/smp.c
@@ -144,7 +144,7 @@ smp_callin(void)
 		alpha_mv.smp_callin();
 
 	/* All kernel threads share the same mm context.  */
-	atomic_inc(&init_mm.mm_count);
+	mmgrab(&init_mm);
 	current->active_mm = &init_mm;
 
 	/* inform the notifiers about the new cpu */
diff -puN arch/arc/kernel/smp.c~mm-add-new-mmgrab-helper arch/arc/kernel/smp.c
--- a/arch/arc/kernel/smp.c~mm-add-new-mmgrab-helper
+++ a/arch/arc/kernel/smp.c
@@ -125,7 +125,7 @@ void start_kernel_secondary(void)
 	setup_processor();
 
 	atomic_inc(&mm->mm_users);
-	atomic_inc(&mm->mm_count);
+	mmgrab(mm);
 	current->active_mm = mm;
 	cpumask_set_cpu(cpu, mm_cpumask(mm));
 
diff -puN arch/arm/kernel/smp.c~mm-add-new-mmgrab-helper arch/arm/kernel/smp.c
--- a/arch/arm/kernel/smp.c~mm-add-new-mmgrab-helper
+++ a/arch/arm/kernel/smp.c
@@ -371,7 +371,7 @@ asmlinkage void secondary_start_kernel(v
 	 * reference and switch to it.
 	 */
 	cpu = smp_processor_id();
-	atomic_inc(&mm->mm_count);
+	mmgrab(mm);
 	current->active_mm = mm;
 	cpumask_set_cpu(cpu, mm_cpumask(mm));
 
diff -puN arch/arm64/kernel/smp.c~mm-add-new-mmgrab-helper arch/arm64/kernel/smp.c
--- a/arch/arm64/kernel/smp.c~mm-add-new-mmgrab-helper
+++ a/arch/arm64/kernel/smp.c
@@ -222,7 +222,7 @@ asmlinkage void secondary_start_kernel(v
 	 * All kernel threads share the same mm context; grab a
 	 * reference and switch to it.
 	 */
-	atomic_inc(&mm->mm_count);
+	mmgrab(mm);
 	current->active_mm = mm;
 
 	/*
diff -puN arch/blackfin/mach-common/smp.c~mm-add-new-mmgrab-helper arch/blackfin/mach-common/smp.c
--- a/arch/blackfin/mach-common/smp.c~mm-add-new-mmgrab-helper
+++ a/arch/blackfin/mach-common/smp.c
@@ -308,7 +308,7 @@ void secondary_start_kernel(void)
 
 	/* Attach the new idle task to the global mm. */
 	atomic_inc(&mm->mm_users);
-	atomic_inc(&mm->mm_count);
+	mmgrab(mm);
 	current->active_mm = mm;
 
 	preempt_disable();
diff -puN arch/hexagon/kernel/smp.c~mm-add-new-mmgrab-helper arch/hexagon/kernel/smp.c
--- a/arch/hexagon/kernel/smp.c~mm-add-new-mmgrab-helper
+++ a/arch/hexagon/kernel/smp.c
@@ -162,7 +162,7 @@ void start_secondary(void)
 	);
 
 	/*  Set the memory struct  */
-	atomic_inc(&init_mm.mm_count);
+	mmgrab(&init_mm);
 	current->active_mm = &init_mm;
 
 	cpu = smp_processor_id();
diff -puN arch/ia64/kernel/setup.c~mm-add-new-mmgrab-helper arch/ia64/kernel/setup.c
--- a/arch/ia64/kernel/setup.c~mm-add-new-mmgrab-helper
+++ a/arch/ia64/kernel/setup.c
@@ -992,7 +992,7 @@ cpu_init (void)
 	 */
 	ia64_setreg(_IA64_REG_CR_DCR,  (  IA64_DCR_DP | IA64_DCR_DK | IA64_DCR_DX | IA64_DCR_DR
 					| IA64_DCR_DA | IA64_DCR_DD | IA64_DCR_LC));
-	atomic_inc(&init_mm.mm_count);
+	mmgrab(&init_mm);
 	current->active_mm = &init_mm;
 	BUG_ON(current->mm);
 
diff -puN arch/m32r/kernel/setup.c~mm-add-new-mmgrab-helper arch/m32r/kernel/setup.c
--- a/arch/m32r/kernel/setup.c~mm-add-new-mmgrab-helper
+++ a/arch/m32r/kernel/setup.c
@@ -403,7 +403,7 @@ void __init cpu_init (void)
 	printk(KERN_INFO "Initializing CPU#%d\n", cpu_id);
 
 	/* Set up and load the per-CPU TSS and LDT */
-	atomic_inc(&init_mm.mm_count);
+	mmgrab(&init_mm);
 	current->active_mm = &init_mm;
 	if (current->mm)
 		BUG();
diff -puN arch/metag/kernel/smp.c~mm-add-new-mmgrab-helper arch/metag/kernel/smp.c
--- a/arch/metag/kernel/smp.c~mm-add-new-mmgrab-helper
+++ a/arch/metag/kernel/smp.c
@@ -345,7 +345,7 @@ asmlinkage void secondary_start_kernel(v
 	 * reference and switch to it.
 	 */
 	atomic_inc(&mm->mm_users);
-	atomic_inc(&mm->mm_count);
+	mmgrab(mm);
 	current->active_mm = mm;
 	cpumask_set_cpu(cpu, mm_cpumask(mm));
 	enter_lazy_tlb(mm, current);
diff -puN arch/mips/kernel/traps.c~mm-add-new-mmgrab-helper arch/mips/kernel/traps.c
--- a/arch/mips/kernel/traps.c~mm-add-new-mmgrab-helper
+++ a/arch/mips/kernel/traps.c
@@ -2232,7 +2232,7 @@ void per_cpu_trap_init(bool is_boot_cpu)
 	if (!cpu_data[cpu].asid_cache)
 		cpu_data[cpu].asid_cache = asid_first_version(cpu);
 
-	atomic_inc(&init_mm.mm_count);
+	mmgrab(&init_mm);
 	current->active_mm = &init_mm;
 	BUG_ON(current->mm);
 	enter_lazy_tlb(&init_mm, current);
diff -puN arch/mn10300/kernel/smp.c~mm-add-new-mmgrab-helper arch/mn10300/kernel/smp.c
--- a/arch/mn10300/kernel/smp.c~mm-add-new-mmgrab-helper
+++ a/arch/mn10300/kernel/smp.c
@@ -589,7 +589,7 @@ static void __init smp_cpu_init(void)
 	}
 	printk(KERN_INFO "Initializing CPU#%d\n", cpu_id);
 
-	atomic_inc(&init_mm.mm_count);
+	mmgrab(&init_mm);
 	current->active_mm = &init_mm;
 	BUG_ON(current->mm);
 
diff -puN arch/parisc/kernel/smp.c~mm-add-new-mmgrab-helper arch/parisc/kernel/smp.c
--- a/arch/parisc/kernel/smp.c~mm-add-new-mmgrab-helper
+++ a/arch/parisc/kernel/smp.c
@@ -279,7 +279,7 @@ smp_cpu_init(int cpunum)
 	set_cpu_online(cpunum, true);
 
 	/* Initialise the idle task for this CPU */
-	atomic_inc(&init_mm.mm_count);
+	mmgrab(&init_mm);
 	current->active_mm = &init_mm;
 	BUG_ON(current->mm);
 	enter_lazy_tlb(&init_mm, current);
diff -puN arch/powerpc/kernel/smp.c~mm-add-new-mmgrab-helper arch/powerpc/kernel/smp.c
--- a/arch/powerpc/kernel/smp.c~mm-add-new-mmgrab-helper
+++ a/arch/powerpc/kernel/smp.c
@@ -707,7 +707,7 @@ void start_secondary(void *unused)
 	unsigned int cpu = smp_processor_id();
 	int i, base;
 
-	atomic_inc(&init_mm.mm_count);
+	mmgrab(&init_mm);
 	current->active_mm = &init_mm;
 
 	smp_store_cpu_info(cpu);
diff -puN arch/s390/kernel/processor.c~mm-add-new-mmgrab-helper arch/s390/kernel/processor.c
--- a/arch/s390/kernel/processor.c~mm-add-new-mmgrab-helper
+++ a/arch/s390/kernel/processor.c
@@ -73,7 +73,7 @@ void cpu_init(void)
 	get_cpu_id(id);
 	if (machine_has_cpu_mhz)
 		update_cpu_mhz(NULL);
-	atomic_inc(&init_mm.mm_count);
+	mmgrab(&init_mm);
 	current->active_mm = &init_mm;
 	BUG_ON(current->mm);
 	enter_lazy_tlb(&init_mm, current);
diff -puN arch/score/kernel/traps.c~mm-add-new-mmgrab-helper arch/score/kernel/traps.c
--- a/arch/score/kernel/traps.c~mm-add-new-mmgrab-helper
+++ a/arch/score/kernel/traps.c
@@ -336,7 +336,7 @@ void __init trap_init(void)
 	set_except_vector(18, handle_dbe);
 	flush_icache_range(DEBUG_VECTOR_BASE_ADDR, IRQ_VECTOR_BASE_ADDR);
 
-	atomic_inc(&init_mm.mm_count);
+	mmgrab(&init_mm);
 	current->active_mm = &init_mm;
 	cpu_cache_init();
 }
diff -puN arch/sh/kernel/smp.c~mm-add-new-mmgrab-helper arch/sh/kernel/smp.c
--- a/arch/sh/kernel/smp.c~mm-add-new-mmgrab-helper
+++ a/arch/sh/kernel/smp.c
@@ -178,7 +178,7 @@ asmlinkage void start_secondary(void)
 	struct mm_struct *mm = &init_mm;
 
 	enable_mmu();
-	atomic_inc(&mm->mm_count);
+	mmgrab(mm);
 	atomic_inc(&mm->mm_users);
 	current->active_mm = mm;
 #ifdef CONFIG_MMU
diff -puN arch/sparc/kernel/leon_smp.c~mm-add-new-mmgrab-helper arch/sparc/kernel/leon_smp.c
--- a/arch/sparc/kernel/leon_smp.c~mm-add-new-mmgrab-helper
+++ a/arch/sparc/kernel/leon_smp.c
@@ -93,7 +93,7 @@ void leon_cpu_pre_online(void *arg)
 			     : "memory" /* paranoid */);
 
 	/* Attach to the address space of init_task. */
-	atomic_inc(&init_mm.mm_count);
+	mmgrab(&init_mm);
 	current->active_mm = &init_mm;
 
 	while (!cpumask_test_cpu(cpuid, &smp_commenced_mask))
diff -puN arch/sparc/kernel/smp_64.c~mm-add-new-mmgrab-helper arch/sparc/kernel/smp_64.c
--- a/arch/sparc/kernel/smp_64.c~mm-add-new-mmgrab-helper
+++ a/arch/sparc/kernel/smp_64.c
@@ -122,7 +122,7 @@ void smp_callin(void)
 	current_thread_info()->new_child = 0;
 
 	/* Attach to the address space of init_task. */
-	atomic_inc(&init_mm.mm_count);
+	mmgrab(&init_mm);
 	current->active_mm = &init_mm;
 
 	/* inform the notifiers about the new cpu */
diff -puN arch/sparc/kernel/sun4d_smp.c~mm-add-new-mmgrab-helper arch/sparc/kernel/sun4d_smp.c
--- a/arch/sparc/kernel/sun4d_smp.c~mm-add-new-mmgrab-helper
+++ a/arch/sparc/kernel/sun4d_smp.c
@@ -93,7 +93,7 @@ void sun4d_cpu_pre_online(void *arg)
 	show_leds(cpuid);
 
 	/* Attach to the address space of init_task. */
-	atomic_inc(&init_mm.mm_count);
+	mmgrab(&init_mm);
 	current->active_mm = &init_mm;
 
 	local_ops->cache_all();
diff -puN arch/sparc/kernel/sun4m_smp.c~mm-add-new-mmgrab-helper arch/sparc/kernel/sun4m_smp.c
--- a/arch/sparc/kernel/sun4m_smp.c~mm-add-new-mmgrab-helper
+++ a/arch/sparc/kernel/sun4m_smp.c
@@ -59,7 +59,7 @@ void sun4m_cpu_pre_online(void *arg)
 			     : "memory" /* paranoid */);
 
 	/* Attach to the address space of init_task. */
-	atomic_inc(&init_mm.mm_count);
+	mmgrab(&init_mm);
 	current->active_mm = &init_mm;
 
 	while (!cpumask_test_cpu(cpuid, &smp_commenced_mask))
diff -puN arch/sparc/kernel/traps_32.c~mm-add-new-mmgrab-helper arch/sparc/kernel/traps_32.c
--- a/arch/sparc/kernel/traps_32.c~mm-add-new-mmgrab-helper
+++ a/arch/sparc/kernel/traps_32.c
@@ -448,7 +448,7 @@ void trap_init(void)
 		thread_info_offsets_are_bolixed_pete();
 
 	/* Attach to the address space of init_task. */
-	atomic_inc(&init_mm.mm_count);
+	mmgrab(&init_mm);
 	current->active_mm = &init_mm;
 
 	/* NOTE: Other cpus have this done as they are started
diff -puN arch/sparc/kernel/traps_64.c~mm-add-new-mmgrab-helper arch/sparc/kernel/traps_64.c
--- a/arch/sparc/kernel/traps_64.c~mm-add-new-mmgrab-helper
+++ a/arch/sparc/kernel/traps_64.c
@@ -2764,6 +2764,6 @@ void __init trap_init(void)
 	/* Attach to the address space of init_task.  On SMP we
 	 * do this in smp.c:smp_callin for other cpus.
 	 */
-	atomic_inc(&init_mm.mm_count);
+	mmgrab(&init_mm);
 	current->active_mm = &init_mm;
 }
diff -puN arch/tile/kernel/smpboot.c~mm-add-new-mmgrab-helper arch/tile/kernel/smpboot.c
--- a/arch/tile/kernel/smpboot.c~mm-add-new-mmgrab-helper
+++ a/arch/tile/kernel/smpboot.c
@@ -160,7 +160,7 @@ static void start_secondary(void)
 	__this_cpu_write(current_asid, min_asid);
 
 	/* Set up this thread as another owner of the init_mm */
-	atomic_inc(&init_mm.mm_count);
+	mmgrab(&init_mm);
 	current->active_mm = &init_mm;
 	if (current->mm)
 		BUG();
diff -puN arch/x86/kernel/cpu/common.c~mm-add-new-mmgrab-helper arch/x86/kernel/cpu/common.c
--- a/arch/x86/kernel/cpu/common.c~mm-add-new-mmgrab-helper
+++ a/arch/x86/kernel/cpu/common.c
@@ -1491,7 +1491,7 @@ void cpu_init(void)
 	for (i = 0; i <= IO_BITMAP_LONGS; i++)
 		t->io_bitmap[i] = ~0UL;
 
-	atomic_inc(&init_mm.mm_count);
+	mmgrab(&init_mm);
 	me->active_mm = &init_mm;
 	BUG_ON(me->mm);
 	enter_lazy_tlb(&init_mm, me);
@@ -1542,7 +1542,7 @@ void cpu_init(void)
 	/*
 	 * Set up and load the per-CPU TSS and LDT
 	 */
-	atomic_inc(&init_mm.mm_count);
+	mmgrab(&init_mm);
 	curr->active_mm = &init_mm;
 	BUG_ON(curr->mm);
 	enter_lazy_tlb(&init_mm, curr);
diff -puN arch/xtensa/kernel/smp.c~mm-add-new-mmgrab-helper arch/xtensa/kernel/smp.c
--- a/arch/xtensa/kernel/smp.c~mm-add-new-mmgrab-helper
+++ a/arch/xtensa/kernel/smp.c
@@ -136,7 +136,7 @@ void secondary_start_kernel(void)
 	/* All kernel threads share the same mm context. */
 
 	atomic_inc(&mm->mm_users);
-	atomic_inc(&mm->mm_count);
+	mmgrab(mm);
 	current->active_mm = mm;
 	cpumask_set_cpu(cpu, mm_cpumask(mm));
 	enter_lazy_tlb(mm, current);
diff -puN drivers/gpu/drm/amd/amdkfd/kfd_process.c~mm-add-new-mmgrab-helper drivers/gpu/drm/amd/amdkfd/kfd_process.c
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c~mm-add-new-mmgrab-helper
+++ a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -262,7 +262,7 @@ static void kfd_process_notifier_release
 	 * and because the mmu_notifier_unregister function also drop
 	 * mm_count we need to take an extra count here.
 	 */
-	atomic_inc(&p->mm->mm_count);
+	mmgrab(p->mm);
 	mmu_notifier_unregister_no_release(&p->mmu_notifier, p->mm);
 	mmu_notifier_call_srcu(&p->rcu, &kfd_process_destroy_delayed);
 }
diff -puN drivers/gpu/drm/i915/i915_gem_userptr.c~mm-add-new-mmgrab-helper drivers/gpu/drm/i915/i915_gem_userptr.c
--- a/drivers/gpu/drm/i915/i915_gem_userptr.c~mm-add-new-mmgrab-helper
+++ a/drivers/gpu/drm/i915/i915_gem_userptr.c
@@ -334,7 +334,7 @@ i915_gem_userptr_init__mm_struct(struct
 		mm->i915 = to_i915(obj->base.dev);
 
 		mm->mm = current->mm;
-		atomic_inc(&current->mm->mm_count);
+		mmgrab(current->mm);
 
 		mm->mn = NULL;
 
diff -puN drivers/infiniband/hw/hfi1/file_ops.c~mm-add-new-mmgrab-helper drivers/infiniband/hw/hfi1/file_ops.c
--- a/drivers/infiniband/hw/hfi1/file_ops.c~mm-add-new-mmgrab-helper
+++ a/drivers/infiniband/hw/hfi1/file_ops.c
@@ -185,7 +185,7 @@ static int hfi1_file_open(struct inode *
 	if (fd) {
 		fd->rec_cpu_num = -1; /* no cpu affinity by default */
 		fd->mm = current->mm;
-		atomic_inc(&fd->mm->mm_count);
+		mmgrab(fd->mm);
 		fp->private_data = fd;
 	} else {
 		fp->private_data = NULL;
diff -puN fs/proc/base.c~mm-add-new-mmgrab-helper fs/proc/base.c
--- a/fs/proc/base.c~mm-add-new-mmgrab-helper
+++ a/fs/proc/base.c
@@ -766,7 +766,7 @@ struct mm_struct *proc_mem_open(struct i
 
 		if (!IS_ERR_OR_NULL(mm)) {
 			/* ensure this mm_struct can't be freed */
-			atomic_inc(&mm->mm_count);
+			mmgrab(mm);
 			/* but do not pin its memory */
 			mmput(mm);
 		}
@@ -1064,7 +1064,7 @@ static int __set_oom_adj(struct file *fi
 		if (p) {
 			if (atomic_read(&p->mm->mm_users) > 1) {
 				mm = p->mm;
-				atomic_inc(&mm->mm_count);
+				mmgrab(mm);
 			}
 			task_unlock(p);
 		}
diff -puN fs/userfaultfd.c~mm-add-new-mmgrab-helper fs/userfaultfd.c
--- a/fs/userfaultfd.c~mm-add-new-mmgrab-helper
+++ a/fs/userfaultfd.c
@@ -1719,7 +1719,7 @@ static struct file *userfaultfd_file_cre
 	ctx->released = false;
 	ctx->mm = current->mm;
 	/* prevent the mm struct to be freed */
-	atomic_inc(&ctx->mm->mm_count);
+	mmgrab(ctx->mm);
 
 	file = anon_inode_getfile("[userfaultfd]", &userfaultfd_fops, ctx,
 				  O_RDWR | (flags & UFFD_SHARED_FCNTL_FLAGS));
diff -puN include/linux/sched.h~mm-add-new-mmgrab-helper include/linux/sched.h
--- a/include/linux/sched.h~mm-add-new-mmgrab-helper
+++ a/include/linux/sched.h
@@ -2899,6 +2899,28 @@ static inline unsigned long sigsp(unsign
  */
 extern struct mm_struct * mm_alloc(void);
 
+/**
+ * mmgrab() - Pin a &struct mm_struct.
+ * @mm: The &struct mm_struct to pin.
+ *
+ * Make sure that @mm will not get freed even after the owning task
+ * exits. This doesn't guarantee that the associated address space
+ * will still exist later on and mmget_not_zero() has to be used before
+ * accessing it.
+ *
+ * This is a preferred way to to pin @mm for a longer/unbounded amount
+ * of time.
+ *
+ * Use mmdrop() to release the reference acquired by mmgrab().
+ *
+ * See also <Documentation/vm/active_mm.txt> for an in-depth explanation
+ * of &mm_struct.mm_count vs &mm_struct.mm_users.
+ */
+static inline void mmgrab(struct mm_struct *mm)
+{
+	atomic_inc(&mm->mm_count);
+}
+
 /* mmdrop drops the mm and the page tables */
 extern void __mmdrop(struct mm_struct *);
 static inline void mmdrop(struct mm_struct *mm)
diff -puN kernel/exit.c~mm-add-new-mmgrab-helper kernel/exit.c
--- a/kernel/exit.c~mm-add-new-mmgrab-helper
+++ a/kernel/exit.c
@@ -509,7 +509,7 @@ static void exit_mm(void)
 		__set_current_state(TASK_RUNNING);
 		down_read(&mm->mmap_sem);
 	}
-	atomic_inc(&mm->mm_count);
+	mmgrab(mm);
 	BUG_ON(mm != current->active_mm);
 	/* more a memory barrier than a real lock */
 	task_lock(current);
diff -puN kernel/futex.c~mm-add-new-mmgrab-helper kernel/futex.c
--- a/kernel/futex.c~mm-add-new-mmgrab-helper
+++ a/kernel/futex.c
@@ -338,7 +338,7 @@ static inline bool should_fail_futex(boo
 
 static inline void futex_get_mm(union futex_key *key)
 {
-	atomic_inc(&key->private.mm->mm_count);
+	mmgrab(key->private.mm);
 	/*
 	 * Ensure futex_get_mm() implies a full barrier such that
 	 * get_futex_key() implies a full barrier. This is relied upon
diff -puN kernel/sched/core.c~mm-add-new-mmgrab-helper kernel/sched/core.c
--- a/kernel/sched/core.c~mm-add-new-mmgrab-helper
+++ a/kernel/sched/core.c
@@ -2878,7 +2878,7 @@ context_switch(struct rq *rq, struct tas
 
 	if (!mm) {
 		next->active_mm = oldmm;
-		atomic_inc(&oldmm->mm_count);
+		mmgrab(oldmm);
 		enter_lazy_tlb(oldmm, next);
 	} else
 		switch_mm_irqs_off(oldmm, mm, next);
@@ -7687,7 +7687,7 @@ void __init sched_init(void)
 	/*
 	 * The boot idle thread does lazy MMU switching as well:
 	 */
-	atomic_inc(&init_mm.mm_count);
+	mmgrab(&init_mm);
 	enter_lazy_tlb(&init_mm, current);
 
 	/*
diff -puN mm/khugepaged.c~mm-add-new-mmgrab-helper mm/khugepaged.c
--- a/mm/khugepaged.c~mm-add-new-mmgrab-helper
+++ a/mm/khugepaged.c
@@ -420,7 +420,7 @@ int __khugepaged_enter(struct mm_struct
 	list_add_tail(&mm_slot->mm_node, &khugepaged_scan.mm_head);
 	spin_unlock(&khugepaged_mm_lock);
 
-	atomic_inc(&mm->mm_count);
+	mmgrab(mm);
 	if (wakeup)
 		wake_up_interruptible(&khugepaged_wait);
 
diff -puN mm/ksm.c~mm-add-new-mmgrab-helper mm/ksm.c
--- a/mm/ksm.c~mm-add-new-mmgrab-helper
+++ a/mm/ksm.c
@@ -1813,7 +1813,7 @@ int __ksm_enter(struct mm_struct *mm)
 	spin_unlock(&ksm_mmlist_lock);
 
 	set_bit(MMF_VM_MERGEABLE, &mm->flags);
-	atomic_inc(&mm->mm_count);
+	mmgrab(mm);
 
 	if (needs_wakeup)
 		wake_up_interruptible(&ksm_thread_wait);
diff -puN mm/mmu_context.c~mm-add-new-mmgrab-helper mm/mmu_context.c
--- a/mm/mmu_context.c~mm-add-new-mmgrab-helper
+++ a/mm/mmu_context.c
@@ -25,7 +25,7 @@ void use_mm(struct mm_struct *mm)
 	task_lock(tsk);
 	active_mm = tsk->active_mm;
 	if (active_mm != mm) {
-		atomic_inc(&mm->mm_count);
+		mmgrab(mm);
 		tsk->active_mm = mm;
 	}
 	tsk->mm = mm;
diff -puN mm/mmu_notifier.c~mm-add-new-mmgrab-helper mm/mmu_notifier.c
--- a/mm/mmu_notifier.c~mm-add-new-mmgrab-helper
+++ a/mm/mmu_notifier.c
@@ -275,7 +275,7 @@ static int do_mmu_notifier_register(stru
 		mm->mmu_notifier_mm = mmu_notifier_mm;
 		mmu_notifier_mm = NULL;
 	}
-	atomic_inc(&mm->mm_count);
+	mmgrab(mm);
 
 	/*
 	 * Serialize the update against mmu_notifier_unregister. A
diff -puN mm/oom_kill.c~mm-add-new-mmgrab-helper mm/oom_kill.c
--- a/mm/oom_kill.c~mm-add-new-mmgrab-helper
+++ a/mm/oom_kill.c
@@ -660,7 +660,7 @@ static void mark_oom_victim(struct task_
 
 	/* oom_mm is bound to the signal struct life time. */
 	if (!cmpxchg(&tsk->signal->oom_mm, NULL, mm))
-		atomic_inc(&tsk->signal->oom_mm->mm_count);
+		mmgrab(tsk->signal->oom_mm);
 
 	/*
 	 * Make sure that the task is woken up from uninterruptible sleep
@@ -877,7 +877,7 @@ static void oom_kill_process(struct oom_
 
 	/* Get a reference to safely compare mm after task_unlock(victim) */
 	mm = victim->mm;
-	atomic_inc(&mm->mm_count);
+	mmgrab(mm);
 	/*
 	 * We should send SIGKILL before setting TIF_MEMDIE in order to prevent
 	 * the OOM victim from depleting the memory reserves from the user
diff -puN virt/kvm/kvm_main.c~mm-add-new-mmgrab-helper virt/kvm/kvm_main.c
--- a/virt/kvm/kvm_main.c~mm-add-new-mmgrab-helper
+++ a/virt/kvm/kvm_main.c
@@ -616,7 +616,7 @@ static struct kvm *kvm_create_vm(unsigne
 		return ERR_PTR(-ENOMEM);
 
 	spin_lock_init(&kvm->mmu_lock);
-	atomic_inc(&current->mm->mm_count);
+	mmgrab(current->mm);
 	kvm->mm = current->mm;
 	kvm_eventfd_init(kvm);
 	mutex_init(&kvm->lock);
_

Patches currently in -mm which might be from vegard.nossum@oracle.com are

mm-add-new-mmgrab-helper.patch
mm-add-new-mmget-helper.patch
mm-use-mmget_not_zero-helper.patch
mm-clarify-mm_structmm_userscount-documentation.patch

