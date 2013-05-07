From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects1.patch removed from -mm tree
Date: Tue, 07 May 2013 10:43:49 -0700
Message-ID: <20130507174349.675FD5A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:49048 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab3EGRnu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:43:50 -0400
Received: by mail-yh0-f73.google.com with SMTP id a41so84645yho.4
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:43:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects1.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt           |    3 
 arch/arm/boot/dts/at91sam9x5.dtsi             |    3 
 arch/arm/kvm/arm.c                            |  160 ----------------
 arch/arm/mach-bcm/board_bcm.c                 |    3 
 arch/arm/mach-omap2/omap_hwmod.c              |    3 
 arch/arm/mach-ux500/board-mop500-regulators.c |   10 -
 arch/arm/mach-vexpress/v2m.c                  |   20 --
 arch/arm64/lib/bitops.S                       |    8 
 arch/metag/mm/Kconfig                         |    8 
 arch/powerpc/mm/numa.c                        |    3 
 drivers/clk/tegra/clk.h                       |    8 
 drivers/clocksource/Makefile                  |    4 
 drivers/media/pci/bt8xx/bttv-i2c.c            |    7 
 drivers/staging/media/go7007/go7007-driver.c  |    8 
 fs/proc/internal.h                            |   25 --
 include/linux/blk_types.h                     |    4 
 include/linux/cgroup.h                        |   21 --
 include/linux/clockchips.h                    |    4 
 include/linux/res_counter.h                   |    4 
 kernel/cpu/idle.c                             |   13 -
 kernel/rcutree.c                              |    4 
 kernel/rcutree.h                              |    8 
 kernel/rcutree_plugin.h                       |   34 ---
 kernel/sched/sched.h                          |   14 -
 tools/Makefile                                |    8 
 25 files changed, 387 deletions(-)

diff -puN Documentation/kernel-parameters.txt~linux-next-git-rejects1 Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~linux-next-git-rejects1
+++ a/Documentation/kernel-parameters.txt
@@ -45,10 +45,7 @@ parameter is applicable:
 	AX25	Appropriate AX.25 support is enabled.
 	BLACKFIN Blackfin architecture is enabled.
 	CLK	Common clock infrastructure is enabled.
-<<<<<<< HEAD
-=======
 	CMA	Contiguous Memory Area support is enabled.
->>>>>>> linux-next/akpm-base
 	DRM	Direct Rendering Management support is enabled.
 	DYNAMIC_DEBUG Build in debug messages and enable them at runtime
 	EDD	BIOS Enhanced Disk Drive Services (EDD) is enabled
diff -puN arch/arm/boot/dts/at91sam9x5.dtsi~linux-next-git-rejects1 arch/arm/boot/dts/at91sam9x5.dtsi
--- a/arch/arm/boot/dts/at91sam9x5.dtsi~linux-next-git-rejects1
+++ a/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -362,8 +362,6 @@
 							 0 23 0x2 0x0>;	/* PA23 periph B SPI1_SPCK pin */
 					};
 				};
-<<<<<<< HEAD
-=======
 				i2c0 {
 					pinctrl_i2c0: i2c0-0 {
 						atmel,pins =
@@ -411,7 +409,6 @@
 							 1 5 0x0 0x2>;	/* PB5 gpio multidrive I2C2 clock */
 					};
 				};
->>>>>>> linux-next/akpm-base
 
 				pioA: gpio@fffff400 {
 					compatible = "atmel,at91sam9x5-gpio", "atmel,at91rm9200-gpio";
diff -puN arch/arm/kvm/arm.c~linux-next-git-rejects1 arch/arm/kvm/arm.c
--- a/arch/arm/kvm/arm.c~linux-next-git-rejects1
+++ a/arch/arm/kvm/arm.c
@@ -454,166 +454,6 @@ static void update_vttbr(struct kvm *kvm
 	spin_unlock(&kvm_vmid_lock);
 }
 
-<<<<<<< HEAD
-static int handle_svc_hyp(struct kvm_vcpu *vcpu, struct kvm_run *run)
-{
-	/* SVC called from Hyp mode should never get here */
-	kvm_debug("SVC called from Hyp mode shouldn't go here\n");
-	BUG();
-	return -EINVAL; /* Squash warning */
-}
-
-static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
-{
-	trace_kvm_hvc(*vcpu_pc(vcpu), *vcpu_reg(vcpu, 0),
-		      vcpu->arch.hsr & HSR_HVC_IMM_MASK);
-
-	if (kvm_psci_call(vcpu))
-		return 1;
-
-	kvm_inject_undefined(vcpu);
-	return 1;
-}
-
-static int handle_smc(struct kvm_vcpu *vcpu, struct kvm_run *run)
-{
-	if (kvm_psci_call(vcpu))
-		return 1;
-
-	kvm_inject_undefined(vcpu);
-	return 1;
-}
-
-static int handle_pabt_hyp(struct kvm_vcpu *vcpu, struct kvm_run *run)
-{
-	/* The hypervisor should never cause aborts */
-	kvm_err("Prefetch Abort taken from Hyp mode at %#08x (HSR: %#08x)\n",
-		vcpu->arch.hxfar, vcpu->arch.hsr);
-	return -EFAULT;
-}
-
-static int handle_dabt_hyp(struct kvm_vcpu *vcpu, struct kvm_run *run)
-{
-	/* This is either an error in the ws. code or an external abort */
-	kvm_err("Data Abort taken from Hyp mode at %#08x (HSR: %#08x)\n",
-		vcpu->arch.hxfar, vcpu->arch.hsr);
-	return -EFAULT;
-}
-
-typedef int (*exit_handle_fn)(struct kvm_vcpu *, struct kvm_run *);
-static exit_handle_fn arm_exit_handlers[] = {
-	[HSR_EC_WFI]		= kvm_handle_wfi,
-	[HSR_EC_CP15_32]	= kvm_handle_cp15_32,
-	[HSR_EC_CP15_64]	= kvm_handle_cp15_64,
-	[HSR_EC_CP14_MR]	= kvm_handle_cp14_access,
-	[HSR_EC_CP14_LS]	= kvm_handle_cp14_load_store,
-	[HSR_EC_CP14_64]	= kvm_handle_cp14_access,
-	[HSR_EC_CP_0_13]	= kvm_handle_cp_0_13_access,
-	[HSR_EC_CP10_ID]	= kvm_handle_cp10_id,
-	[HSR_EC_SVC_HYP]	= handle_svc_hyp,
-	[HSR_EC_HVC]		= handle_hvc,
-	[HSR_EC_SMC]		= handle_smc,
-	[HSR_EC_IABT]		= kvm_handle_guest_abort,
-	[HSR_EC_IABT_HYP]	= handle_pabt_hyp,
-	[HSR_EC_DABT]		= kvm_handle_guest_abort,
-	[HSR_EC_DABT_HYP]	= handle_dabt_hyp,
-};
-
-/*
- * A conditional instruction is allowed to trap, even though it
- * wouldn't be executed.  So let's re-implement the hardware, in
- * software!
- */
-static bool kvm_condition_valid(struct kvm_vcpu *vcpu)
-{
-	unsigned long cpsr, cond, insn;
-
-	/*
-	 * Exception Code 0 can only happen if we set HCR.TGE to 1, to
-	 * catch undefined instructions, and then we won't get past
-	 * the arm_exit_handlers test anyway.
-	 */
-	BUG_ON(((vcpu->arch.hsr & HSR_EC) >> HSR_EC_SHIFT) == 0);
-
-	/* Top two bits non-zero?  Unconditional. */
-	if (vcpu->arch.hsr >> 30)
-		return true;
-
-	cpsr = *vcpu_cpsr(vcpu);
-
-	/* Is condition field valid? */
-	if ((vcpu->arch.hsr & HSR_CV) >> HSR_CV_SHIFT)
-		cond = (vcpu->arch.hsr & HSR_COND) >> HSR_COND_SHIFT;
-	else {
-		/* This can happen in Thumb mode: examine IT state. */
-		unsigned long it;
-
-		it = ((cpsr >> 8) & 0xFC) | ((cpsr >> 25) & 0x3);
-
-		/* it == 0 => unconditional. */
-		if (it == 0)
-			return true;
-
-		/* The cond for this insn works out as the top 4 bits. */
-		cond = (it >> 4);
-	}
-
-	/* Shift makes it look like an ARM-mode instruction */
-	insn = cond << 28;
-	return arm_check_condition(insn, cpsr) != ARM_OPCODE_CONDTEST_FAIL;
-}
-
-/*
- * Return > 0 to return to guest, < 0 on error, 0 (and set exit_reason) on
- * proper exit to QEMU.
- */
-static int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
-		       int exception_index)
-{
-	unsigned long hsr_ec;
-
-	switch (exception_index) {
-	case ARM_EXCEPTION_IRQ:
-		return 1;
-	case ARM_EXCEPTION_UNDEFINED:
-		kvm_err("Undefined exception in Hyp mode at: %#08x\n",
-			vcpu->arch.hyp_pc);
-		BUG();
-		panic("KVM: Hypervisor undefined exception!\n");
-	case ARM_EXCEPTION_DATA_ABORT:
-	case ARM_EXCEPTION_PREF_ABORT:
-	case ARM_EXCEPTION_HVC:
-		hsr_ec = (vcpu->arch.hsr & HSR_EC) >> HSR_EC_SHIFT;
-
-		if (hsr_ec >= ARRAY_SIZE(arm_exit_handlers)
-		    || !arm_exit_handlers[hsr_ec]) {
-			kvm_err("Unknown exception class: %#08lx, "
-				"hsr: %#08x\n", hsr_ec,
-				(unsigned int)vcpu->arch.hsr);
-			BUG();
-		}
-
-		/*
-		 * See ARM ARM B1.14.1: "Hyp traps on instructions
-		 * that fail their condition code check"
-		 */
-		if (!kvm_condition_valid(vcpu)) {
-			bool is_wide = vcpu->arch.hsr & HSR_IL;
-			kvm_skip_instr(vcpu, is_wide);
-			return 1;
-		}
-
-		return arm_exit_handlers[hsr_ec](vcpu, run);
-	default:
-		kvm_pr_unimpl("Unsupported exception type: %d",
-			      exception_index);
-		run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		return 0;
-	}
-}
-
-=======
->>>>>>> linux-next/akpm-base
 static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 {
 	if (likely(vcpu->arch.has_run_once))
diff -puN arch/arm/mach-bcm/board_bcm.c~linux-next-git-rejects1 arch/arm/mach-bcm/board_bcm.c
--- a/arch/arm/mach-bcm/board_bcm.c~linux-next-git-rejects1
+++ a/arch/arm/mach-bcm/board_bcm.c
@@ -22,8 +22,6 @@
 #include <asm/mach/time.h>
 #include <asm/hardware/cache-l2x0.h>
 
-<<<<<<< HEAD
-=======
 
 #include "bcm_kona_smc.h"
 
@@ -42,7 +40,6 @@ static int __init kona_l2_cache_init(voi
 
 	return 0;
 }
->>>>>>> linux-next/akpm-base
 
 static void __init board_init(void)
 {
diff -puN arch/arm/mach-omap2/omap_hwmod.c~linux-next-git-rejects1 arch/arm/mach-omap2/omap_hwmod.c
--- a/arch/arm/mach-omap2/omap_hwmod.c~linux-next-git-rejects1
+++ a/arch/arm/mach-omap2/omap_hwmod.c
@@ -139,11 +139,8 @@
 #include <linux/slab.h>
 #include <linux/bootmem.h>
 #include <linux/cpu.h>
-<<<<<<< HEAD
-=======
 #include <linux/of.h>
 #include <linux/of_address.h>
->>>>>>> linux-next/akpm-base
 
 #include <asm/system_misc.h>
 
diff -puN arch/arm/mach-ux500/board-mop500-regulators.c~linux-next-git-rejects1 arch/arm/mach-ux500/board-mop500-regulators.c
--- a/arch/arm/mach-ux500/board-mop500-regulators.c~linux-next-git-rejects1
+++ a/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -333,7 +333,6 @@ static struct ab8500_regulator_reg_init
 	 * Vaux2Regu                = force off
 	 */
 	INIT_REGULATOR_REGISTER(AB8500_VAUX12REGU,             0x0f, 0x01),
-<<<<<<< HEAD
 	/*
 	 * Vaux3Regu                = force off
 	 */
@@ -341,15 +340,6 @@ static struct ab8500_regulator_reg_init
 	/*
 	 * Vaux1Sel                 = 2.8 V
 	 */
-=======
-	/*
-	 * Vaux3Regu                = force off
-	 */
-	INIT_REGULATOR_REGISTER(AB8500_VRF1VAUX3REGU,          0x03, 0x00),
-	/*
-	 * Vaux1Sel                 = 2.8 V
-	 */
->>>>>>> linux-next/akpm-base
 	INIT_REGULATOR_REGISTER(AB8500_VAUX1SEL,               0x0f, 0x0C),
 	/*
 	 * Vaux2Sel                 = 2.9 V
diff -puN arch/arm/mach-vexpress/v2m.c~linux-next-git-rejects1 arch/arm/mach-vexpress/v2m.c
--- a/arch/arm/mach-vexpress/v2m.c~linux-next-git-rejects1
+++ a/arch/arm/mach-vexpress/v2m.c
@@ -427,27 +427,7 @@ void __init v2m_dt_init_early(void)
 
 static void __init v2m_dt_timer_init(void)
 {
-<<<<<<< HEAD
-	struct device_node *node = NULL;
-
-	of_clk_init(NULL);
-
-	do {
-		node = of_find_compatible_node(node, NULL, "arm,sp804");
-	} while (node && vexpress_get_site_by_node(node) != VEXPRESS_SITE_MB);
-	if (node) {
-		pr_info("Using SP804 '%s' as a clock & events source\n",
-				node->full_name);
-		WARN_ON(clk_register_clkdev(of_clk_get_by_name(node,
-				"timclken1"), "v2m-timer0", "sp804"));
-		WARN_ON(clk_register_clkdev(of_clk_get_by_name(node,
-				"timclken2"), "v2m-timer1", "sp804"));
-		v2m_sp804_init(of_iomap(node, 0),
-				irq_of_parse_and_map(node, 0));
-	}
-=======
 	of_clk_init(NULL);
->>>>>>> linux-next/akpm-base
 
 	clocksource_of_init();
 
diff -puN arch/arm64/lib/bitops.S~linux-next-git-rejects1 arch/arm64/lib/bitops.S
--- a/arch/arm64/lib/bitops.S~linux-next-git-rejects1
+++ a/arch/arm64/lib/bitops.S
@@ -46,13 +46,6 @@ ENTRY(	\name	)
 	mov	x2, #1
 	add	x1, x1, x0, lsr #3	// Get word offset
 	lsl	x4, x2, x3		// Create mask
-<<<<<<< HEAD
-1:	ldaxr	x2, [x1]
-	lsr	x0, x2, x3		// Save old value of bit
-	\instr	x2, x2, x4		// toggle bit
-	stlxr	w5, x2, [x1]
-	cbnz	w5, 1b
-=======
 	smp_dmb	ish
 1:	ldxr	x2, [x1]
 	lsr	x0, x2, x3		// Save old value of bit
@@ -60,7 +53,6 @@ ENTRY(	\name	)
 	stxr	w2, x2, [x1]
 	cbnz	w2, 1b
 	smp_dmb	ish
->>>>>>> linux-next/akpm-base
 	and	x0, x0, #1
 3:	ret
 ENDPROC(\name	)
diff -puN arch/metag/mm/Kconfig~linux-next-git-rejects1 arch/metag/mm/Kconfig
--- a/arch/metag/mm/Kconfig~linux-next-git-rejects1
+++ a/arch/metag/mm/Kconfig
@@ -93,14 +93,6 @@ config ARCH_SPARSEMEM_ENABLE
 config ARCH_SPARSEMEM_DEFAULT
 	def_bool y
 
-<<<<<<< HEAD
-config MAX_ACTIVE_REGIONS
-	int
-	default "2" if SPARSEMEM
-	default "1"
-
-=======
->>>>>>> linux-next/akpm-base
 config ARCH_SELECT_MEMORY_MODEL
 	def_bool y
 
diff -puN arch/powerpc/mm/numa.c~linux-next-git-rejects1 arch/powerpc/mm/numa.c
--- a/arch/powerpc/mm/numa.c~linux-next-git-rejects1
+++ a/arch/powerpc/mm/numa.c
@@ -22,13 +22,10 @@
 #include <linux/pfn.h>
 #include <linux/cpuset.h>
 #include <linux/node.h>
-<<<<<<< HEAD
-=======
 #include <linux/stop_machine.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/uaccess.h>
->>>>>>> linux-next/akpm-base
 #include <linux/slab.h>
 #include <asm/sparsemem.h>
 #include <asm/prom.h>
diff -puN drivers/clk/tegra/clk.h~linux-next-git-rejects1 drivers/clk/tegra/clk.h
--- a/drivers/clk/tegra/clk.h~linux-next-git-rejects1
+++ a/drivers/clk/tegra/clk.h
@@ -468,12 +468,8 @@ struct tegra_periph_init_data {
 #define TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parent_names, _offset,\
 			_mux_shift, _mux_mask, _mux_flags, _div_shift,	\
 			_div_width, _div_frac_width, _div_flags, _regs,	\
-<<<<<<< HEAD
-			_clk_num, _enb_refcnt, _gate_flags, _clk_id, _table) \
-=======
 			_clk_num, _enb_refcnt, _gate_flags, _clk_id, _table,\
 			_flags) \
->>>>>>> linux-next/akpm-base
 	{								\
 		.name = _name,						\
 		.clk_id = _clk_id,					\
@@ -499,11 +495,7 @@ struct tegra_periph_init_data {
 			_mux_shift, BIT(_mux_width) - 1, _mux_flags,	\
 			_div_shift, _div_width, _div_frac_width, _div_flags, \
 			_regs, _clk_num, _enb_refcnt, _gate_flags, _clk_id,\
-<<<<<<< HEAD
-			NULL)
-=======
 			NULL, 0)
->>>>>>> linux-next/akpm-base
 
 /**
  * struct clk_super_mux - super clock
diff -puN drivers/clocksource/Makefile~linux-next-git-rejects1 drivers/clocksource/Makefile
--- a/drivers/clocksource/Makefile~linux-next-git-rejects1
+++ a/drivers/clocksource/Makefile
@@ -22,14 +22,10 @@ obj-$(CONFIG_ARCH_PRIMA2)	+= timer-prima
 obj-$(CONFIG_SUN4I_TIMER)	+= sun4i_timer.o
 obj-$(CONFIG_ARCH_TEGRA)	+= tegra20_timer.o
 obj-$(CONFIG_VT8500_TIMER)	+= vt8500_timer.o
-<<<<<<< HEAD
-obj-$(CONFIG_ARCH_BCM)		+= bcm_kona_timer.o
-=======
 obj-$(CONFIG_CADENCE_TTC_TIMER)	+= cadence_ttc_timer.o
 obj-$(CONFIG_ARCH_BCM)		+= bcm_kona_timer.o
 obj-$(CONFIG_CLKSRC_EXYNOS_MCT)	+= exynos_mct.o
 obj-$(CONFIG_CLKSRC_SAMSUNG_PWM)	+= samsung_pwm_timer.o
->>>>>>> linux-next/akpm-base
 
 obj-$(CONFIG_ARM_ARCH_TIMER)		+= arm_arch_timer.o
 obj-$(CONFIG_CLKSRC_METAG_GENERIC)	+= metag_generic.o
diff -puN drivers/media/pci/bt8xx/bttv-i2c.c~linux-next-git-rejects1 drivers/media/pci/bt8xx/bttv-i2c.c
--- a/drivers/media/pci/bt8xx/bttv-i2c.c~linux-next-git-rejects1
+++ a/drivers/media/pci/bt8xx/bttv-i2c.c
@@ -397,15 +397,8 @@ int init_bttv_i2c(struct bttv *btv)
 
 int fini_bttv_i2c(struct bttv *btv)
 {
-<<<<<<< HEAD
-	if (0 != btv->i2c_rc)
-		return 0;
-
-	return i2c_del_adapter(&btv->c.i2c_adap);
-=======
 	if (btv->i2c_rc == 0)
 		i2c_del_adapter(&btv->c.i2c_adap);
 
 	return 0;
->>>>>>> linux-next/akpm-base
 }
diff -puN drivers/staging/media/go7007/go7007-driver.c~linux-next-git-rejects1 drivers/staging/media/go7007/go7007-driver.c
--- a/drivers/staging/media/go7007/go7007-driver.c~linux-next-git-rejects1
+++ a/drivers/staging/media/go7007/go7007-driver.c
@@ -242,16 +242,8 @@ static void go7007_remove(struct v4l2_de
 	if (go->hpi_ops->release)
 		go->hpi_ops->release(go);
 	if (go->i2c_adapter_online) {
-<<<<<<< HEAD
-		if (i2c_del_adapter(&go->i2c_adapter) == 0)
-			go->i2c_adapter_online = 0;
-		else
-			v4l2_err(&go->v4l2_dev,
-				"error removing I2C adapter!\n");
-=======
 		i2c_del_adapter(&go->i2c_adapter);
 		go->i2c_adapter_online = 0;
->>>>>>> linux-next/akpm-base
 	}
 
 	kfree(go->boot_fw);
diff -puN fs/proc/internal.h~linux-next-git-rejects1 fs/proc/internal.h
--- a/fs/proc/internal.h~linux-next-git-rejects1
+++ a/fs/proc/internal.h
@@ -18,30 +18,6 @@
 struct ctl_table_header;
 struct mempolicy;
 
-<<<<<<< HEAD
-extern int proc_tid_stat(struct seq_file *m, struct pid_namespace *ns,
-				struct pid *pid, struct task_struct *task);
-extern int proc_tgid_stat(struct seq_file *m, struct pid_namespace *ns,
-				struct pid *pid, struct task_struct *task);
-extern int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
-				struct pid *pid, struct task_struct *task);
-extern int proc_pid_statm(struct seq_file *m, struct pid_namespace *ns,
-				struct pid *pid, struct task_struct *task);
-extern loff_t mem_lseek(struct file *file, loff_t offset, int orig);
-
-extern const struct file_operations proc_tid_children_operations;
-extern const struct file_operations proc_pid_maps_operations;
-extern const struct file_operations proc_tid_maps_operations;
-extern const struct file_operations proc_pid_numa_maps_operations;
-extern const struct file_operations proc_tid_numa_maps_operations;
-extern const struct file_operations proc_pid_smaps_operations;
-extern const struct file_operations proc_tid_smaps_operations;
-extern const struct file_operations proc_clear_refs_operations;
-extern const struct file_operations proc_pagemap_operations;
-extern const struct file_operations proc_net_operations;
-extern const struct inode_operations proc_net_inode_operations;
-extern const struct inode_operations proc_pid_link_inode_operations;
-=======
 /*
  * This is not completely implemented yet. The idea is to
  * create an in-memory tree (like the actual /proc filesystem
@@ -81,7 +57,6 @@ union proc_op {
 		struct pid_namespace *ns, struct pid *pid,
 		struct task_struct *task);
 };
->>>>>>> linux-next/akpm-base
 
 struct proc_inode {
 	struct pid *pid;
diff -puN include/linux/blk_types.h~linux-next-git-rejects1 include/linux/blk_types.h
--- a/include/linux/blk_types.h~linux-next-git-rejects1
+++ a/include/linux/blk_types.h
@@ -117,12 +117,8 @@ struct bio {
  * Flags starting here get preserved by bio_reset() - this includes
  * BIO_POOL_IDX()
  */
-<<<<<<< HEAD
-#define BIO_RESET_BITS	13
-=======
 #define BIO_RESET_BITS	12
 #define BIO_OWNS_VEC	12	/* bio_free() should free bvec */
->>>>>>> linux-next/akpm-base
 
 #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
 
diff -puN include/linux/cgroup.h~linux-next-git-rejects1 include/linux/cgroup.h
--- a/include/linux/cgroup.h~linux-next-git-rejects1
+++ a/include/linux/cgroup.h
@@ -49,7 +49,6 @@ extern int proc_cgroup_show(struct seq_f
 #define SUBSYS(_x) _x ## _subsys_id,
 enum cgroup_subsys_id {
 #define IS_SUBSYS_ENABLED(option) IS_BUILTIN(option)
-<<<<<<< HEAD
 #include <linux/cgroup_subsys.h>
 #undef IS_SUBSYS_ENABLED
 	CGROUP_BUILTIN_SUBSYS_COUNT,
@@ -59,17 +58,6 @@ enum cgroup_subsys_id {
 #define IS_SUBSYS_ENABLED(option) IS_MODULE(option)
 #include <linux/cgroup_subsys.h>
 #undef IS_SUBSYS_ENABLED
-=======
-#include <linux/cgroup_subsys.h>
-#undef IS_SUBSYS_ENABLED
-	CGROUP_BUILTIN_SUBSYS_COUNT,
-
-	__CGROUP_SUBSYS_TEMP_PLACEHOLDER = CGROUP_BUILTIN_SUBSYS_COUNT - 1,
-
-#define IS_SUBSYS_ENABLED(option) IS_MODULE(option)
-#include <linux/cgroup_subsys.h>
-#undef IS_SUBSYS_ENABLED
->>>>>>> linux-next/akpm-base
 	CGROUP_SUBSYS_COUNT,
 };
 #undef SUBSYS
@@ -664,21 +652,12 @@ static inline struct cgroup_subsys_state
  */
 #ifdef CONFIG_PROVE_RCU
 extern struct mutex cgroup_mutex;
-<<<<<<< HEAD
-#define task_subsys_state_check(task, subsys_id, __c)			\
-	rcu_dereference_check((task)->cgroups->subsys[(subsys_id)],	\
-			      lockdep_is_held(&(task)->alloc_lock) ||	\
-			      lockdep_is_held(&cgroup_mutex) || (__c))
-#else
-#define task_subsys_state_check(task, subsys_id, __c)			\
-=======
 #define task_subsys_state_check(task, subsys_id, __c)			\
 	rcu_dereference_check((task)->cgroups->subsys[(subsys_id)],	\
 			      lockdep_is_held(&(task)->alloc_lock) ||	\
 			      lockdep_is_held(&cgroup_mutex) || (__c))
 #else
 #define task_subsys_state_check(task, subsys_id, __c)			\
->>>>>>> linux-next/akpm-base
 	rcu_dereference((task)->cgroups->subsys[(subsys_id)])
 #endif
 
diff -puN include/linux/clockchips.h~linux-next-git-rejects1 include/linux/clockchips.h
--- a/include/linux/clockchips.h~linux-next-git-rejects1
+++ a/include/linux/clockchips.h
@@ -192,11 +192,7 @@ static inline void clockevents_notify(un
 static inline void clockevents_suspend(void) {}
 static inline void clockevents_resume(void) {}
 
-<<<<<<< HEAD
-#define clockevents_notify(reason, arg) do { } while (0)
-=======
 static inline void clockevents_notify(unsigned long reason, void *arg) {}
->>>>>>> linux-next/akpm-base
 static inline int tick_check_broadcast_expired(void) { return 0; }
 
 #endif
diff -puN include/linux/res_counter.h~linux-next-git-rejects1 include/linux/res_counter.h
--- a/include/linux/res_counter.h~linux-next-git-rejects1
+++ a/include/linux/res_counter.h
@@ -13,10 +13,6 @@
  * info about what this counter is.
  */
 
-<<<<<<< HEAD
-#include <linux/spinlock.h>
-=======
->>>>>>> linux-next/akpm-base
 #include <linux/errno.h>
 #include <linux/spinlock.h>
 
diff -puN kernel/cpu/idle.c~linux-next-git-rejects1 kernel/cpu/idle.c
--- a/kernel/cpu/idle.c~linux-next-git-rejects1
+++ a/kernel/cpu/idle.c
@@ -76,20 +76,7 @@ static void cpu_idle_loop(void)
 			local_irq_disable();
 			arch_cpu_idle_enter();
 
-<<<<<<< HEAD
-			/*
-			 * In poll mode we reenable interrupts and spin.
-			 *
-			 * Also if we detected in the wakeup from idle
-			 * path that the tick broadcast device expired
-			 * for us, we don't want to go deep idle as we
-			 * know that the IPI is going to arrive right
-			 * away
-			 */
-			if (cpu_idle_force_poll || tick_check_broadcast_expired()) {
-=======
 			if (cpu_idle_force_poll) {
->>>>>>> linux-next/akpm-base
 				cpu_idle_poll();
 			} else {
 				current_clr_polling();
diff -puN kernel/rcutree.c~linux-next-git-rejects1 kernel/rcutree.c
--- a/kernel/rcutree.c~linux-next-git-rejects1
+++ a/kernel/rcutree.c
@@ -1451,11 +1451,7 @@ static int rcu_gp_init(struct rcu_state
 					    rnp->grphi, rnp->qsmask);
 		raw_spin_unlock_irq(&rnp->lock);
 #ifdef CONFIG_PROVE_RCU_DELAY
-<<<<<<< HEAD
-		if ((prandom_u32() % (rcu_num_nodes * 8)) == 0 &&
-=======
 		if ((random32() % (rcu_num_nodes * 8)) == 0 &&
->>>>>>> linux-next/akpm-base
 		    system_state == SYSTEM_RUNNING)
 			schedule_timeout_uninterruptible(2);
 #endif /* #ifdef CONFIG_PROVE_RCU_DELAY */
diff -puN kernel/rcutree.h~linux-next-git-rejects1 kernel/rcutree.h
--- a/kernel/rcutree.h~linux-next-git-rejects1
+++ a/kernel/rcutree.h
@@ -530,20 +530,12 @@ static int rcu_nocb_needs_gp(struct rcu_
 static void rcu_nocb_gp_set(struct rcu_node *rnp, int nrq);
 static void rcu_nocb_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp);
 static void rcu_init_one_nocb(struct rcu_node *rnp);
-<<<<<<< HEAD
-static bool is_nocb_cpu(int cpu);
-=======
->>>>>>> linux-next/akpm-base
 static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
 			    bool lazy);
 static bool rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
 				      struct rcu_data *rdp);
 static void rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp);
 static void rcu_spawn_nocb_kthreads(struct rcu_state *rsp);
-<<<<<<< HEAD
-=======
-static void rcu_kick_nohz_cpu(int cpu);
->>>>>>> linux-next/akpm-base
 static bool init_nocb_callback_list(struct rcu_data *rdp);
 
 #endif /* #ifndef RCU_TREE_NONCORE */
diff -puN kernel/rcutree_plugin.h~linux-next-git-rejects1 kernel/rcutree_plugin.h
--- a/kernel/rcutree_plugin.h~linux-next-git-rejects1
+++ a/kernel/rcutree_plugin.h
@@ -1706,11 +1706,7 @@ static void rcu_prepare_for_idle(int cpu
 		return;
 
 	/* If this is a no-CBs CPU, no callbacks, just return. */
-<<<<<<< HEAD
-	if (is_nocb_cpu(cpu))
-=======
 	if (rcu_is_nocb_cpu(cpu))
->>>>>>> linux-next/akpm-base
 		return;
 
 	/*
@@ -1752,11 +1748,7 @@ static void rcu_cleanup_after_idle(int c
 	struct rcu_data *rdp;
 	struct rcu_state *rsp;
 
-<<<<<<< HEAD
-	if (is_nocb_cpu(cpu))
-=======
 	if (rcu_is_nocb_cpu(cpu))
->>>>>>> linux-next/akpm-base
 		return;
 	rcu_try_advance_all_cbs();
 	for_each_rcu_flavor(rsp) {
@@ -2294,7 +2286,6 @@ static bool init_nocb_callback_list(stru
 		return false;
 	rdp->nxttail[RCU_NEXT_TAIL] = NULL;
 	return true;
-<<<<<<< HEAD
 }
 
 #else /* #ifdef CONFIG_RCU_NOCB_CPU */
@@ -2313,26 +2304,6 @@ static void rcu_nocb_gp_set(struct rcu_n
 }
 
 static void rcu_init_one_nocb(struct rcu_node *rnp)
-=======
-}
-
-#else /* #ifdef CONFIG_RCU_NOCB_CPU */
-
-static int rcu_nocb_needs_gp(struct rcu_state *rsp)
-{
-	return 0;
-}
-
-static void rcu_nocb_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp)
->>>>>>> linux-next/akpm-base
-{
-}
-
-static void rcu_nocb_gp_set(struct rcu_node *rnp, int nrq)
-{
-}
-
-static void rcu_init_one_nocb(struct rcu_node *rnp)
 {
 }
 
@@ -2357,10 +2328,6 @@ static void __init rcu_spawn_nocb_kthrea
 }
 
 static bool init_nocb_callback_list(struct rcu_data *rdp)
-<<<<<<< HEAD
-{
-	return false;
-=======
 {
 	return false;
 }
@@ -2382,5 +2349,4 @@ static void rcu_kick_nohz_cpu(int cpu)
 	if (tick_nohz_full_cpu(cpu))
 		smp_send_reschedule(cpu);
 #endif /* #ifdef CONFIG_NO_HZ_FULL */
->>>>>>> linux-next/akpm-base
 }
diff -puN kernel/sched/sched.h~linux-next-git-rejects1 kernel/sched/sched.h
--- a/kernel/sched/sched.h~linux-next-git-rejects1
+++ a/kernel/sched/sched.h
@@ -959,15 +959,9 @@ static const u32 prio_to_wmult[40] = {
 #else
 #define ENQUEUE_WAKING		0
 #endif
-<<<<<<< HEAD
 
 #define DEQUEUE_SLEEP		1
 
-=======
-
-#define DEQUEUE_SLEEP		1
-
->>>>>>> linux-next/akpm-base
 struct sched_class {
 	const struct sched_class *next;
 
@@ -992,19 +986,11 @@ struct sched_class {
 
 	void (*set_cpus_allowed)(struct task_struct *p,
 				 const struct cpumask *newmask);
-<<<<<<< HEAD
-
-	void (*rq_online)(struct rq *rq);
-	void (*rq_offline)(struct rq *rq);
-#endif
-
-=======
 
 	void (*rq_online)(struct rq *rq);
 	void (*rq_offline)(struct rq *rq);
 #endif
 
->>>>>>> linux-next/akpm-base
 	void (*set_curr_task) (struct rq *rq);
 	void (*task_tick) (struct rq *rq, struct task_struct *p, int queued);
 	void (*task_fork) (struct task_struct *p);
diff -puN tools/Makefile~linux-next-git-rejects1 tools/Makefile
--- a/tools/Makefile~linux-next-git-rejects1
+++ a/tools/Makefile
@@ -35,11 +35,7 @@ help:
 cpupower: FORCE
 	$(call descend,power/$@)
 
-<<<<<<< HEAD
-cgroup firewire guest usb virtio vm: FORCE
-=======
 cgroup firewire guest usb virtio vm net: FORCE
->>>>>>> linux-next/akpm-base
 	$(call descend,$@)
 
 liblk: FORCE
@@ -73,11 +69,7 @@ install: cgroup_install cpupower_install
 cpupower_clean:
 	$(call descend,power/cpupower,clean)
 
-<<<<<<< HEAD
-cgroup_clean firewire_clean lguest_clean usb_clean virtio_clean vm_clean:
-=======
 cgroup_clean firewire_clean lguest_clean usb_clean virtio_clean vm_clean net_clean:
->>>>>>> linux-next/akpm-base
 	$(call descend,$(@:_clean=),clean)
 
 liblk_clean:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
revert-ipc-dont-allocate-a-copy-larger-than-max.patch
clear_refs-sanitize-accepted-commands-declaration.patch
include-linux-mmh-complete-the-mm_walk-definition.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
mm-vmallocc-add-vfree-comment.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
drivers-video-implement-a-simple-framebuffer-driver.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
revert-ipc_schedule_free-can-do-vfree-now.patch
ipc-introduce-obtaining-a-lockless-ipc-object.patch
ipcsem-do-not-hold-ipc-lock-more-than-necessary.patch
ipcsem-open-code-and-rename-sem_lock.patch
ipc-sysv-shared-memory-limited-to-8tib.patch
rapidio-make-enumeration-discovery-configurable-fix.patch
gadget-remove-only-user-of-aio-retry-checkpatch-fixes.patch
aio-remove-retry-based-aio-checkpatch-fixes.patch
aio-add-kiocb_cancel.patch
aio-make-aio_put_req-lockless-checkpatch-fixes.patch
aio-refcounting-cleanup-checkpatch-fixes.patch
wait-add-wait_event_hrtimeout.patch
aio-make-aio_read_evt-more-efficient-convert-to-hrtimers-checkpatch-fixes.patch
aio-use-cancellation-list-lazily.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
generic-dynamic-per-cpu-refcounting.patch
generic-dynamic-per-cpu-refcounting-checkpatch-fixes.patch
aio-dont-include-aioh-in-schedh.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-kill-ki_retry.patch
aio-kill-ki_retry-fix.patch
aio-kill-ki_retry-checkpatch-fixes.patch
block-prep-work-for-batch-completion-checkpatch-fixes.patch
block-prep-work-for-batch-completion-fix-2.patch
block-prep-work-for-batch-completion-fix-3.patch
block-prep-work-for-batch-completion-fix-3-fix.patch
block-prep-work-for-batch-completion-fix-4.patch
block-prep-work-for-batch-completion-fix-99.patch
block-aio-batch-completion-for-bios-kiocbs.patch
block-aio-batch-completion-for-bios-kiocbs-checkpatch-fixes.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
bpf-add-comments-explaining-the-schedule_work-operation.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

