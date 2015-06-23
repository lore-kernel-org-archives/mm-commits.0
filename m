From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Tue, 23 Jun 2015 12:22:58 -0700
Message-ID: <5589b212.KOWYswLsbD5p1L/u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58217 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900AbbFWTW7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Jun 2015 15:22:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: a
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: a

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/memory-barriers.txt                           |   18 ----
 arch/x86/Kconfig                                            |    3 
 arch/x86/kernel/cpu/mcheck/mce.c                            |    6 -
 arch/x86/kvm/cpuid.c                                        |    3 
 arch/x86/kvm/x86.c                                          |   10 --
 drivers/clocksource/Makefile                                |    3 
 drivers/firmware/efi/efi.c                                  |    4 -
 drivers/iommu/amd_iommu.c                                   |   23 ------
 drivers/iommu/dmar.c                                        |    4 -
 drivers/iommu/intel_irq_remapping.c                         |   37 ----------
 include/linux/rcupdate.h                                    |   20 -----
 include/linux/seqlock.h                                     |    4 -
 init/Kconfig                                                |   12 ---
 kernel/rcu/tree.c                                           |   30 --------
 kernel/rcu/tree.h                                           |    5 -
 kernel/rcu/tree_plugin.h                                    |   19 -----
 kernel/sched/core.c                                         |    4 -
 kernel/sched/deadline.c                                     |    4 -
 tools/testing/selftests/rcutorture/configs/rcu/TREE04       |    4 -
 tools/testing/selftests/rcutorture/doc/TREE_RCU-kconfig.txt |    4 -
 20 files changed, 2 insertions(+), 215 deletions(-)

diff -puN Documentation/memory-barriers.txt~linux-next-git-rejects Documentation/memory-barriers.txt
--- a/Documentation/memory-barriers.txt~linux-next-git-rejects
+++ a/Documentation/memory-barriers.txt
@@ -718,11 +718,7 @@ equal to zero, in which case the compile
 transform the above code into the following:
 
 	q = READ_ONCE_CTRL(a);
-<<<<<<< HEAD
-	ACCESS_ONCE(b) = p;
-=======
 	WRITE_ONCE(b, p);
->>>>>>> linux-next/akpm-base
 	do_something_else();
 
 Given this transformation, the CPU is not required to respect the ordering
@@ -750,24 +746,15 @@ You must also be careful not to rely too
 evaluation.  Consider this example:
 
 	q = READ_ONCE_CTRL(a);
-<<<<<<< HEAD
-	if (a || 1 > 0)
-		ACCESS_ONCE(b) = 1;
-=======
 	if (q || 1 > 0)
 		WRITE_ONCE(b, 1);
->>>>>>> linux-next/akpm-base
 
 Because the first condition cannot fault and the second condition is
 always true, the compiler can transform this example as following,
 defeating control dependency:
 
 	q = READ_ONCE_CTRL(a);
-<<<<<<< HEAD
-	ACCESS_ONCE(b) = 1;
-=======
 	WRITE_ONCE(b, 1);
->>>>>>> linux-next/akpm-base
 
 This example underscores the need to ensure that the compiler cannot
 out-guess your code.  More generally, although READ_ONCE() does force
@@ -811,12 +798,7 @@ In summary:
 
   (*) Control dependencies must be headed by READ_ONCE_CTRL().
       Or, as a much less preferable alternative, interpose
-<<<<<<< HEAD
-      be headed by READ_ONCE() or an ACCESS_ONCE() read and must
-      have smp_read_barrier_depends() between this read and the
-=======
       smp_read_barrier_depends() between a READ_ONCE() and the
->>>>>>> linux-next/akpm-base
       control-dependent write.
 
   (*) Control dependencies can order prior loads against later stores.
diff -puN arch/x86/Kconfig~linux-next-git-rejects arch/x86/Kconfig
--- a/arch/x86/Kconfig~linux-next-git-rejects
+++ a/arch/x86/Kconfig
@@ -51,11 +51,8 @@ config X86
 	select CLONE_BACKWARDS			if X86_32
 	select COMPAT_OLD_SIGACTION		if IA32_EMULATION
 	select DCACHE_WORD_ACCESS
-<<<<<<< HEAD
-=======
 	select EDAC_ATOMIC_SCRUB
 	select EDAC_SUPPORT
->>>>>>> linux-next/akpm-base
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_CLOCKEVENTS_BROADCAST	if X86_64 || (X86_32 && X86_LOCAL_APIC)
 	select GENERIC_CLOCKEVENTS_MIN_ADJUST
diff -puN arch/x86/kernel/cpu/mcheck/mce.c~linux-next-git-rejects arch/x86/kernel/cpu/mcheck/mce.c
--- a/arch/x86/kernel/cpu/mcheck/mce.c~linux-next-git-rejects
+++ a/arch/x86/kernel/cpu/mcheck/mce.c
@@ -54,15 +54,9 @@ static DEFINE_MUTEX(mce_chrdev_read_mute
 
 #define rcu_dereference_check_mce(p) \
 ({ \
-<<<<<<< HEAD
-	rcu_lockdep_assert(rcu_read_lock_sched_held() || \
-			   lockdep_is_held(&mce_chrdev_read_mutex), \
-			   "suspicious rcu_dereference_check_mce() usage"); \
-=======
 	RCU_LOCKDEP_WARN(!rcu_read_lock_sched_held() && \
 			 !lockdep_is_held(&mce_chrdev_read_mutex), \
 			 "suspicious rcu_dereference_check_mce() usage"); \
->>>>>>> linux-next/akpm-base
 	smp_load_acquire(&(p)); \
 })
 
diff -puN arch/x86/kvm/cpuid.c~linux-next-git-rejects arch/x86/kvm/cpuid.c
--- a/arch/x86/kvm/cpuid.c~linux-next-git-rejects
+++ a/arch/x86/kvm/cpuid.c
@@ -16,11 +16,8 @@
 #include <linux/module.h>
 #include <linux/vmalloc.h>
 #include <linux/uaccess.h>
-<<<<<<< HEAD
-=======
 #include <asm/fpu/api.h>
 #include <asm/fpu/internal.h>
->>>>>>> linux-next/akpm-base
 #include <asm/user.h>
 #include <asm/fpu/xstate.h>
 #include "cpuid.h"
diff -puN arch/x86/kvm/x86.c~linux-next-git-rejects arch/x86/kvm/x86.c
--- a/arch/x86/kvm/x86.c~linux-next-git-rejects
+++ a/arch/x86/kvm/x86.c
@@ -7479,17 +7479,11 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct k
 	return 0;
 }
 
-<<<<<<< HEAD
-static void fx_init(struct kvm_vcpu *vcpu)
-{
-	fpstate_init(&vcpu->arch.guest_fpu.state);
-=======
 static void fx_init(struct kvm_vcpu *vcpu, bool init_event)
 {
 	if (!init_event)
 		fpstate_init(&vcpu->arch.guest_fpu.state);
 
->>>>>>> linux-next/akpm-base
 	if (cpu_has_xsaves)
 		vcpu->arch.guest_fpu.state.xsave.header.xcomp_bv =
 			host_xcr0 | XSTATE_COMPACTION_ENABLED;
@@ -7848,11 +7842,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *
 		goto fail_free_mce_banks;
 	}
 
-<<<<<<< HEAD
-	fx_init(vcpu);
-=======
 	fx_init(vcpu, false);
->>>>>>> linux-next/akpm-base
 
 	vcpu->arch.ia32_tsc_adjust_msr = 0x0;
 	vcpu->arch.pv_time_enabled = false;
diff -puN drivers/clocksource/Makefile~linux-next-git-rejects drivers/clocksource/Makefile
--- a/drivers/clocksource/Makefile~linux-next-git-rejects
+++ a/drivers/clocksource/Makefile
@@ -47,10 +47,7 @@ obj-$(CONFIG_MTK_TIMER)		+= mtk_timer.o
 
 obj-$(CONFIG_ARM_ARCH_TIMER)		+= arm_arch_timer.o
 obj-$(CONFIG_ARM_GLOBAL_TIMER)		+= arm_global_timer.o
-<<<<<<< HEAD
-=======
 obj-$(CONFIG_ARM_TIMER_SP804)		+= timer-sp804.o
->>>>>>> linux-next/akpm-base
 obj-$(CONFIG_ARMV7M_SYSTICK)		+= armv7m_systick.o
 obj-$(CONFIG_CLKSRC_METAG_GENERIC)	+= metag_generic.o
 obj-$(CONFIG_ARCH_HAS_TICK_BROADCAST)	+= dummy_timer.o
diff -puN drivers/firmware/efi/efi.c~linux-next-git-rejects drivers/firmware/efi/efi.c
--- a/drivers/firmware/efi/efi.c~linux-next-git-rejects
+++ a/drivers/firmware/efi/efi.c
@@ -66,10 +66,6 @@ static int __init parse_efi_cmdline(char
 early_param("efi", parse_efi_cmdline);
 
 struct kobject *efi_kobj;
-<<<<<<< HEAD
-static struct kobject *efivars_kobj;
-=======
->>>>>>> linux-next/akpm-base
 
 /*
  * Let's not leave out systab information that snuck into
diff -puN drivers/iommu/amd_iommu.c~linux-next-git-rejects drivers/iommu/amd_iommu.c
--- a/drivers/iommu/amd_iommu.c~linux-next-git-rejects
+++ a/drivers/iommu/amd_iommu.c
@@ -4089,7 +4089,6 @@ static int amd_ir_set_affinity(struct ir
 	struct irq_cfg *cfg = irqd_cfg(data);
 	struct irq_data *parent = data->parent_data;
 	int ret;
-<<<<<<< HEAD
 
 	ret = parent->chip->irq_set_affinity(parent, mask, force);
 	if (ret < 0 || ret == IRQ_SET_MASK_OK_DONE)
@@ -4110,28 +4109,6 @@ static int amd_ir_set_affinity(struct ir
 	 */
 	send_cleanup_vector(cfg);
 
-=======
-
-	ret = parent->chip->irq_set_affinity(parent, mask, force);
-	if (ret < 0 || ret == IRQ_SET_MASK_OK_DONE)
-		return ret;
-
-	/*
-	 * Atomically updates the IRTE with the new destination, vector
-	 * and flushes the interrupt entry cache.
-	 */
-	ir_data->irte_entry.fields.vector = cfg->vector;
-	ir_data->irte_entry.fields.destination = cfg->dest_apicid;
-	modify_irte(irte_info->devid, irte_info->index, ir_data->irte_entry);
-
-	/*
-	 * After this point, all the interrupts will start arriving
-	 * at the new destination. So, time to cleanup the previous
-	 * vector allocation.
-	 */
-	send_cleanup_vector(cfg);
-
->>>>>>> linux-next/akpm-base
 	return IRQ_SET_MASK_OK_DONE;
 }
 
diff -puN drivers/iommu/dmar.c~linux-next-git-rejects drivers/iommu/dmar.c
--- a/drivers/iommu/dmar.c~linux-next-git-rejects
+++ a/drivers/iommu/dmar.c
@@ -1646,11 +1646,7 @@ int dmar_set_interrupt(struct intel_iomm
 	if (irq > 0) {
 		iommu->irq = irq;
 	} else {
-<<<<<<< HEAD
-		pr_err("IOMMU: no free vectors\n");
-=======
 		pr_err("No free IRQ vectors\n");
->>>>>>> linux-next/akpm-base
 		return -EINVAL;
 	}
 
diff -puN drivers/iommu/intel_irq_remapping.c~linux-next-git-rejects drivers/iommu/intel_irq_remapping.c
--- a/drivers/iommu/intel_irq_remapping.c~linux-next-git-rejects
+++ a/drivers/iommu/intel_irq_remapping.c
@@ -11,10 +11,7 @@
 #include <linux/irq.h>
 #include <linux/intel-iommu.h>
 #include <linux/acpi.h>
-<<<<<<< HEAD
-=======
 #include <linux/crash_dump.h>
->>>>>>> linux-next/akpm-base
 #include <linux/irqdomain.h>
 #include <asm/io_apic.h>
 #include <asm/smp.h>
@@ -84,8 +81,6 @@ static struct irq_domain_ops intel_ir_do
 static void iommu_disable_irq_remapping(struct intel_iommu *iommu);
 static int __init parse_ioapics_under_ir(void);
 
-<<<<<<< HEAD
-=======
 static bool ir_pre_enabled(struct intel_iommu *iommu)
 {
 	return (iommu->flags & VTD_FLAG_IRQ_REMAP_PRE_ENABLED);
@@ -105,7 +100,6 @@ static void init_ir_status(struct intel_
 		iommu->flags |= VTD_FLAG_IRQ_REMAP_PRE_ENABLED;
 }
 
->>>>>>> linux-next/akpm-base
 static int alloc_irte(struct intel_iommu *iommu, int irq,
 		      struct irq_2_iommu *irq_iommu, u16 count)
 {
@@ -722,26 +716,6 @@ error:
  * Set Posted-Interrupts capability.
  */
 static inline void set_irq_posting_cap(void)
-<<<<<<< HEAD
-{
-	struct dmar_drhd_unit *drhd;
-	struct intel_iommu *iommu;
-
-	if (!disable_irq_post) {
-		intel_irq_remap_ops.capability |= 1 << IRQ_POSTING_CAP;
-
-		for_each_iommu(iommu, drhd)
-			if (!cap_pi_support(iommu->cap)) {
-				intel_irq_remap_ops.capability &=
-						~(1 << IRQ_POSTING_CAP);
-				break;
-			}
-	}
-}
-
-static int __init intel_enable_irq_remapping(void)
-=======
->>>>>>> linux-next/akpm-base
 {
 	struct dmar_drhd_unit *drhd;
 	struct intel_iommu *iommu;
@@ -1194,16 +1168,6 @@ static int intel_ir_set_vcpu_affinity(st
 
 	return 0;
 }
-<<<<<<< HEAD
-
-static struct irq_chip intel_ir_chip = {
-	.irq_ack = ir_ack_apic_edge,
-	.irq_set_affinity = intel_ir_set_affinity,
-	.irq_compose_msi_msg = intel_ir_compose_msi_msg,
-	.irq_set_vcpu_affinity = intel_ir_set_vcpu_affinity,
-};
-
-=======
 
 static struct irq_chip intel_ir_chip = {
 	.irq_ack = ir_ack_apic_edge,
@@ -1212,7 +1176,6 @@ static struct irq_chip intel_ir_chip = {
 	.irq_set_vcpu_affinity = intel_ir_set_vcpu_affinity,
 };
 
->>>>>>> linux-next/akpm-base
 static void intel_irq_remapping_prepare_irte(struct intel_ir_data *data,
 					     struct irq_cfg *irq_cfg,
 					     struct irq_alloc_info *info,
diff -puN include/linux/rcupdate.h~linux-next-git-rejects include/linux/rcupdate.h
--- a/include/linux/rcupdate.h~linux-next-git-rejects
+++ a/include/linux/rcupdate.h
@@ -624,24 +624,6 @@ static inline void rcu_preempt_sleep_che
 #define RCU_INITIALIZER(v) (typeof(*(v)) __force __rcu *)(v)
 
 /**
-<<<<<<< HEAD
- * lockless_dereference() - safely load a pointer for later dereference
- * @p: The pointer to load
- *
- * Similar to rcu_dereference(), but for situations where the pointed-to
- * object's lifetime is managed by something other than RCU.  That
- * "something other" might be reference counting or simple immortality.
- */
-#define lockless_dereference(p) \
-({ \
-	typeof(p) _________p1 = READ_ONCE(p); \
-	smp_read_barrier_depends(); /* Dependency order vs. p above. */ \
-	(_________p1); \
-})
-
-/**
-=======
->>>>>>> linux-next/akpm-base
  * rcu_assign_pointer() - assign to RCU-protected pointer
  * @p: pointer to assign to
  * @v: value to assign (publish)
@@ -984,7 +966,7 @@ static inline notrace void rcu_read_lock
 /*
  * rcu_read_unlock_sched - marks the end of a RCU-classic critical section
  *
- * See rcu_read_lock_sched for more information.
+ * See rcu_read_loqck_sched for more information.
  */
 static inline void rcu_read_unlock_sched(void)
 {
diff -puN include/linux/seqlock.h~linux-next-git-rejects include/linux/seqlock.h
--- a/include/linux/seqlock.h~linux-next-git-rejects
+++ a/include/linux/seqlock.h
@@ -275,16 +275,12 @@ static inline void raw_write_seqcount_ba
 	s->sequence++;
 }
 
-<<<<<<< HEAD
-/*
-=======
 static inline int raw_read_seqcount_latch(seqcount_t *s)
 {
 	return lockless_dereference(s->sequence);
 }
 
 /**
->>>>>>> linux-next/akpm-base
  * raw_write_seqcount_latch - redirect readers to even/odd copy
  * @s: pointer to seqcount_t
  *
diff -puN init/Kconfig~linux-next-git-rejects init/Kconfig
--- a/init/Kconfig~linux-next-git-rejects
+++ a/init/Kconfig
@@ -550,18 +550,6 @@ config RCU_STALL_COMMON
 config CONTEXT_TRACKING
        bool
 
-<<<<<<< HEAD
-config RCU_USER_QS
-	bool
-	help
-	  This option sets hooks on kernel / userspace boundaries and
-	  puts RCU in extended quiescent state when the CPU runs in
-	  userspace. It means that when a CPU runs in userspace, it is
-	  excluded from the global RCU state machine and thus doesn't
-	  try to keep the timer tick on for RCU.
-
-=======
->>>>>>> linux-next/akpm-base
 config CONTEXT_TRACKING_FORCE
 	bool "Force context tracking"
 	depends on CONTEXT_TRACKING
diff -puN kernel/rcu/tree.c~linux-next-git-rejects kernel/rcu/tree.c
--- a/kernel/rcu/tree.c~linux-next-git-rejects
+++ a/kernel/rcu/tree.c
@@ -1173,17 +1173,11 @@ static void rcu_check_gp_kthread_starvat
 	j = jiffies;
 	gpa = READ_ONCE(rsp->gp_activity);
 	if (j - gpa > 2 * HZ)
-<<<<<<< HEAD
-		pr_err("%s kthread starved for %ld jiffies! g%lu c%lu f%#x\n",
-		       rsp->name, j - gpa,
-		       rsp->gpnum, rsp->completed, rsp->gp_flags);
-=======
 		pr_err("%s kthread starved for %ld jiffies! g%lu c%lu f%#x s%d ->state=%#lx\n",
 		       rsp->name, j - gpa,
 		       rsp->gpnum, rsp->completed,
 		       rsp->gp_flags, rsp->gp_state,
 		       rsp->gp_kthread ? rsp->gp_kthread->state : 0);
->>>>>>> linux-next/akpm-base
 }
 
 /*
@@ -4025,15 +4019,9 @@ static void __init rcu_init_levelspread(
 	int i;
 
 	if (rcu_fanout_exact) {
-<<<<<<< HEAD
-		rsp->levelspread[rcu_num_lvls - 1] = rcu_fanout_leaf;
-		for (i = rcu_num_lvls - 2; i >= 0; i--)
-			rsp->levelspread[i] = RCU_FANOUT;
-=======
 		levelspread[rcu_num_lvls - 1] = rcu_fanout_leaf;
 		for (i = rcu_num_lvls - 2; i >= 0; i--)
 			levelspread[i] = RCU_FANOUT;
->>>>>>> linux-next/akpm-base
 	} else {
 		int ccur;
 		int cprv;
@@ -4159,19 +4147,6 @@ static void __init rcu_init_geometry(voi
 		rcu_fanout_leaf, nr_cpu_ids);
 
 	/*
-<<<<<<< HEAD
-	 * Compute number of nodes that can be handled an rcu_node tree
-	 * with the given number of levels.  Setting rcu_capacity[0] makes
-	 * some of the arithmetic easier.
-	 */
-	rcu_capacity[0] = 1;
-	rcu_capacity[1] = rcu_fanout_leaf;
-	for (i = 2; i <= MAX_RCU_LVLS; i++)
-		rcu_capacity[i] = rcu_capacity[i - 1] * RCU_FANOUT;
-
-	/*
-=======
->>>>>>> linux-next/akpm-base
 	 * The boot-time rcu_fanout_leaf parameter is only permitted
 	 * to increase the leaf-level fanout, not decrease it.  Of course,
 	 * the leaf-level fanout cannot exceed the number of bits in
@@ -4179,13 +4154,8 @@ static void __init rcu_init_geometry(voi
 	 * time values if these limits are exceeded.
 	 */
 	if (rcu_fanout_leaf < RCU_FANOUT_LEAF ||
-<<<<<<< HEAD
-	    rcu_fanout_leaf > sizeof(unsigned long) * 8 ||
-	    n > rcu_capacity[MAX_RCU_LVLS]) {
-=======
 	    rcu_fanout_leaf > sizeof(unsigned long) * 8) {
 		rcu_fanout_leaf = RCU_FANOUT_LEAF;
->>>>>>> linux-next/akpm-base
 		WARN_ON(1);
 		return;
 	}
diff -puN kernel/rcu/tree.h~linux-next-git-rejects kernel/rcu/tree.h
--- a/kernel/rcu/tree.h~linux-next-git-rejects
+++ a/kernel/rcu/tree.h
@@ -36,11 +36,6 @@
  * Of course, your mileage may vary.
  */
 
-<<<<<<< HEAD
-#define MAX_RCU_LVLS 4
-
-=======
->>>>>>> linux-next/akpm-base
 #ifdef CONFIG_RCU_FANOUT
 #define RCU_FANOUT CONFIG_RCU_FANOUT
 #else /* #ifdef CONFIG_RCU_FANOUT */
diff -puN kernel/rcu/tree_plugin.h~linux-next-git-rejects kernel/rcu/tree_plugin.h
--- a/kernel/rcu/tree_plugin.h~linux-next-git-rejects
+++ a/kernel/rcu/tree_plugin.h
@@ -1,4 +1,4 @@
-/*
+q/*
  * Read-Copy Update mechanism for mutual exclusion (tree-based version)
  * Internal non-public definitions that provide either classic
  * or preemptible semantics.
@@ -82,15 +82,8 @@ static void __init rcu_bootup_announce_o
 		pr_info("\tRCU lockdep checking is enabled.\n");
 	if (IS_ENABLED(CONFIG_RCU_TORTURE_TEST_RUNNABLE))
 		pr_info("\tRCU torture testing starts during boot.\n");
-<<<<<<< HEAD
-	if (IS_ENABLED(CONFIG_RCU_CPU_STALL_INFO))
-		pr_info("\tAdditional per-CPU info printed with stalls.\n");
-	if (NUM_RCU_LVL_4 != 0)
-		pr_info("\tFour-level hierarchy is enabled.\n");
-=======
 	if (RCU_NUM_LVLS >= 4)
 		pr_info("\tFour(or more)-level hierarchy is enabled.\n");
->>>>>>> linux-next/akpm-base
 	if (RCU_FANOUT_LEAF != 16)
 		pr_info("\tBuild-time adjustment of leaf fanout to %d.\n",
 			RCU_FANOUT_LEAF);
@@ -725,12 +718,7 @@ void synchronize_rcu_expedited(void)
 	 */
 	while (!mutex_trylock(&sync_rcu_preempt_exp_mutex)) {
 		if (ULONG_CMP_LT(snap,
-<<<<<<< HEAD
-		    READ_ONCE(sync_rcu_preempt_exp_count))) {
-			put_online_cpus();
-=======
 		    READ_ONCE(sync_rcu_preempt_exp_count)))
->>>>>>> linux-next/akpm-base
 			goto mb_ret; /* Others did our work for us. */
 		if (trycount++ < 10) {
 			udelay(trycount * num_online_cpus());
@@ -739,12 +727,7 @@ void synchronize_rcu_expedited(void)
 			return;
 		}
 	}
-<<<<<<< HEAD
-	if (ULONG_CMP_LT(snap, READ_ONCE(sync_rcu_preempt_exp_count))) {
-		put_online_cpus();
-=======
 	if (ULONG_CMP_LT(snap, READ_ONCE(sync_rcu_preempt_exp_count)))
->>>>>>> linux-next/akpm-base
 		goto unlock_mb_ret; /* Others did our work for us. */
 
 	/* force all RCU readers onto ->blkd_tasks lists. */
diff -puN kernel/sched/core.c~linux-next-git-rejects kernel/sched/core.c
--- a/kernel/sched/core.c~linux-next-git-rejects
+++ a/kernel/sched/core.c
@@ -3044,11 +3044,7 @@ static void __sched __schedule(void)
 		raw_spin_unlock_irq(&rq->lock);
 	}
 
-<<<<<<< HEAD
-	post_schedule(rq);
-=======
 	balance_callback(rq);
->>>>>>> linux-next/akpm-base
 }
 
 static inline void sched_submit_work(struct task_struct *tsk)
diff -puN kernel/sched/deadline.c~linux-next-git-rejects kernel/sched/deadline.c
--- a/kernel/sched/deadline.c~linux-next-git-rejects
+++ a/kernel/sched/deadline.c
@@ -548,9 +548,6 @@ static int start_dl_timer(struct task_st
 	if (ktime_us_delta(act, now) < 0)
 		return 0;
 
-<<<<<<< HEAD
-	hrtimer_start(&dl_se->dl_timer, act, HRTIMER_MODE_ABS);
-=======
 	/*
 	 * !enqueued will guarantee another callback; even if one is already in
 	 * progress. This ensures a balanced {get,put}_task_struct().
@@ -564,7 +561,6 @@ static int start_dl_timer(struct task_st
 		get_task_struct(p);
 		hrtimer_start(timer, act, HRTIMER_MODE_ABS);
 	}
->>>>>>> linux-next/akpm-base
 
 	return 1;
 }
diff -puN tools/testing/selftests/rcutorture/configs/rcu/TREE04~linux-next-git-rejects tools/testing/selftests/rcutorture/configs/rcu/TREE04
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE04~linux-next-git-rejects
+++ a/tools/testing/selftests/rcutorture/configs/rcu/TREE04
@@ -17,9 +17,5 @@ CONFIG_RCU_FANOUT=4
 CONFIG_RCU_FANOUT_LEAF=4
 CONFIG_RCU_NOCB_CPU=n
 CONFIG_DEBUG_LOCK_ALLOC=n
-<<<<<<< HEAD
-CONFIG_RCU_CPU_STALL_INFO=n
-=======
->>>>>>> linux-next/akpm-base
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
 CONFIG_RCU_EXPERT=y
diff -puN tools/testing/selftests/rcutorture/doc/TREE_RCU-kconfig.txt~linux-next-git-rejects tools/testing/selftests/rcutorture/doc/TREE_RCU-kconfig.txt
--- a/tools/testing/selftests/rcutorture/doc/TREE_RCU-kconfig.txt~linux-next-git-rejects
+++ a/tools/testing/selftests/rcutorture/doc/TREE_RCU-kconfig.txt
@@ -16,10 +16,6 @@ CONFIG_PROVE_LOCKING -- Do several, cove
 CONFIG_PROVE_RCU -- Hardwired to CONFIG_PROVE_LOCKING.
 CONFIG_RCU_BOOST -- one of PREEMPT_RCU.
 CONFIG_RCU_KTHREAD_PRIO -- set to 2 for _BOOST testing.
-<<<<<<< HEAD
-CONFIG_RCU_CPU_STALL_INFO -- Now default, avoid at least twice.
-=======
->>>>>>> linux-next/akpm-base
 CONFIG_RCU_FANOUT -- Cover hierarchy, but overlap with others.
 CONFIG_RCU_FANOUT_LEAF -- Do one non-default.
 CONFIG_RCU_FAST_NO_HZ -- Do one, but not with CONFIG_RCU_NOCB_CPU_ALL.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger-fix.patch
mm.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing-v3-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
mm-meminit-inline-some-helper-functions-fix.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix.patch
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix-fix.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
fs-userfaultfdc-work-around-i386-build-error.patch
hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages-fix.patch
mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths-checkpatch-fixes.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
zswap-runtime-enable-disable-fix.patch
prctl-more-prctlpr_set_mm_-checks-fix.patch
proc-fix-page_size-limit-of-proc-pid-cmdline-fix.patch
maintainers-davidlohr-has-moved.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
radix-tree-replace-preallocated-node-array-with-linked-list-fix.patch
checkpatch-emit-an-error-when-theres-a-diff-in-a-changelog.patch
init-do_mounts-add-create_dev-failure-log-fix.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch
ipcshm-move-bug_on-check-into-shm_lock-fix.patch
scsi-resolve-sg-buffer-const-ness-issue-fix.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-block-nvme-corec-fix-build-with-gcc-444.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

