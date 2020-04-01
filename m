From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Tue, 31 Mar 2020 18:07:40 -0700
Message-ID: <20200401010740.MfREMVWnU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387890AbgDABHm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 31 Mar 2020 21:07:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
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

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/usb/generic.txt |    4 
 MAINTAINERS                                       |    3 
 arch/x86/include/asm/sighandling.h                |    4 
 arch/x86/kernel/Makefile                          |    3 
 arch/x86/kvm/vmx/vmx.h                            |    4 
 drivers/clocksource/timer-vf-pit.c                |    4 
 drivers/irqchip/irq-xilinx-intc.c                 |   14 
 drivers/mtd/spi-nor/Kconfig                       |   77 --
 drivers/mtd/spi-nor/Makefile                      |   10 
 drivers/pwm/pwm-omap-dmtimer.c                    |   32 -
 drivers/staging/octeon/ethernet-tx.c              |    7 
 fs/btrfs/disk-io.c                                |   20 
 fs/btrfs/extent_io.c                              |   11 
 fs/btrfs/transaction.c                            |    3 
 include/linux/irqflags.h                          |   11 
 include/linux/usb/audio-v2.h                      |    3 
 kernel/events/core.c                              |   20 
 kernel/irq/handle.c                               |    4 
 kernel/rcu/tree.c                                 |   20 
 kernel/rcu/tree_stall.h                           |   16 
 kernel/rcu/update.c                               |  367 ------------
 21 files changed, 637 deletions(-)

--- a/arch/x86/include/asm/sighandling.h~linux-next-git-rejects
+++ a/arch/x86/include/asm/sighandling.h
@@ -14,8 +14,4 @@
 			 X86_EFLAGS_CF | X86_EFLAGS_RF)
 
 void signal_fault(struct pt_regs *regs, void __user *frame, char *where);
-<<<<<<< HEAD
-
-=======
->>>>>>> linux-next/akpm-base
 #endif /* _ASM_X86_SIGHANDLING_H */
--- a/arch/x86/kernel/Makefile~linux-next-git-rejects
+++ a/arch/x86/kernel/Makefile
@@ -28,13 +28,10 @@ KASAN_SANITIZE_dumpstack_$(BITS).o			:=
 KASAN_SANITIZE_stacktrace.o				:= n
 KASAN_SANITIZE_paravirt.o				:= n
 
-<<<<<<< HEAD
-=======
 # With some compiler versions the generated code results in boot hangs, caused
 # by several compilation units. To be safe, disable all instrumentation.
 KCSAN_SANITIZE := n
 
->>>>>>> linux-next/akpm-base
 OBJECT_FILES_NON_STANDARD_test_nx.o			:= y
 OBJECT_FILES_NON_STANDARD_paravirt_patch.o		:= y
 
--- a/arch/x86/kvm/vmx/vmx.h~linux-next-git-rejects
+++ a/arch/x86/kvm/vmx/vmx.h
@@ -12,10 +12,6 @@
 #include "vmcs.h"
 
 extern const u32 vmx_msr_index[];
-<<<<<<< HEAD
-extern u64 host_efer;
-=======
->>>>>>> linux-next/akpm-base
 
 #define MSR_TYPE_R	1
 #define MSR_TYPE_W	2
--- a/Documentation/devicetree/bindings/usb/generic.txt~linux-next-git-rejects
+++ a/Documentation/devicetree/bindings/usb/generic.txt
@@ -34,11 +34,7 @@ Optional properties:
  - usb-role-switch: boolean, indicates that the device is capable of assigning
 			the USB data role (USB host or USB device) for a given
 			USB connector, such as Type-C, Type-B(micro).
-<<<<<<< HEAD
-			see connector/usb-connector.txt.
-=======
 			see connector/usb-connector.yaml.
->>>>>>> linux-next/akpm-base
  - role-switch-default-mode: indicating if usb-role-switch is enabled, the
 			device default operation mode of controller while usb
 			role is USB_ROLE_NONE. Valid arguments are "host" and
--- a/drivers/clocksource/timer-vf-pit.c~linux-next-git-rejects
+++ a/drivers/clocksource/timer-vf-pit.c
@@ -129,11 +129,7 @@ static int __init pit_clockevent_init(un
 	__raw_writel(PITTFLG_TIF, clkevt_base + PITTFLG);
 
 	BUG_ON(request_irq(irq, pit_timer_interrupt, IRQF_TIMER | IRQF_IRQPOLL,
-<<<<<<< HEAD
-			   "VF pit timer", &clockevent_pit);
-=======
 			   "VF pit timer", &clockevent_pit));
->>>>>>> linux-next/akpm-base
 
 	clockevent_pit.cpumask = cpumask_of(0);
 	clockevent_pit.irq = irq;
--- a/drivers/irqchip/irq-xilinx-intc.c~linux-next-git-rejects
+++ a/drivers/irqchip/irq-xilinx-intc.c
@@ -111,15 +111,6 @@ static struct irq_chip intc_dev = {
 };
 
 static unsigned int xintc_get_irq_local(struct xintc_irq_chip *irqc)
-<<<<<<< HEAD
-{
-	unsigned int irq = 0;
-	u32 hwirq;
-
-	hwirq = xintc_read(irqc, IVR);
-	if (hwirq != -1U)
-		irq = irq_find_mapping(irqc->root_domain, hwirq);
-=======
 {
 	unsigned int irq = 0;
 	u32 hwirq;
@@ -141,7 +132,6 @@ unsigned int xintc_get_irq(void)
 	hwirq = xintc_read(primary_intc, IVR);
 	if (hwirq != -1U)
 		irq = irq_find_mapping(primary_intc->root_domain, hwirq);
->>>>>>> linux-next/akpm-base
 
 	pr_debug("irq-xilinx: hwirq=%d, irq=%d\n", hwirq, irq);
 
@@ -274,11 +264,7 @@ static int __init xilinx_intc_of_init(st
 		}
 	} else {
 		primary_intc = irqc;
-<<<<<<< HEAD
-		set_handle_irq(xil_intc_handle_irq);
-=======
 		irq_set_default_host(primary_intc->root_domain);
->>>>>>> linux-next/akpm-base
 	}
 
 	return 0;
--- a/drivers/mtd/spi-nor/Kconfig~linux-next-git-rejects
+++ a/drivers/mtd/spi-nor/Kconfig
@@ -24,83 +24,6 @@ config MTD_SPI_NOR_USE_4K_SECTORS
 	  Please note that some tools/drivers/filesystems may not work with
 	  4096 B erase size (e.g. UBIFS requires 15 KiB as a minimum).
 
-<<<<<<< HEAD
-config SPI_ASPEED_SMC
-	tristate "Aspeed flash controllers in SPI mode"
-	depends on ARCH_ASPEED || COMPILE_TEST
-	depends on HAS_IOMEM && OF
-	help
-	  This enables support for the Firmware Memory controller (FMC)
-	  in the Aspeed AST2500/AST2400 SoCs when attached to SPI NOR chips,
-	  and support for the SPI flash memory controller (SPI) for
-	  the host firmware. The implementation only supports SPI NOR.
-
-config SPI_CADENCE_QUADSPI
-	tristate "Cadence Quad SPI controller"
-	depends on OF && (ARM || ARM64 || COMPILE_TEST)
-	help
-	  Enable support for the Cadence Quad SPI Flash controller.
-
-	  Cadence QSPI is a specialized controller for connecting an SPI
-	  Flash over 1/2/4-bit wide bus. Enable this option if you have a
-	  device with a Cadence QSPI controller and want to access the
-	  Flash as an MTD device.
-
-config SPI_HISI_SFC
-	tristate "Hisilicon FMC SPI-NOR Flash Controller(SFC)"
-	depends on ARCH_HISI || COMPILE_TEST
-	depends on HAS_IOMEM
-	help
-	  This enables support for HiSilicon FMC SPI-NOR flash controller.
-
-config SPI_NXP_SPIFI
-	tristate "NXP SPI Flash Interface (SPIFI)"
-	depends on OF && (ARCH_LPC18XX || COMPILE_TEST)
-	depends on HAS_IOMEM
-	help
-	  Enable support for the NXP LPC SPI Flash Interface controller.
-
-	  SPIFI is a specialized controller for connecting serial SPI
-	  Flash. Enable this option if you have a device with a SPIFI
-	  controller and want to access the Flash as a mtd device.
-
-config SPI_INTEL_SPI
-	tristate
-
-config SPI_INTEL_SPI_PCI
-	tristate "Intel PCH/PCU SPI flash PCI driver (DANGEROUS)"
-	depends on X86 && PCI
-	select SPI_INTEL_SPI
-	help
-	  This enables PCI support for the Intel PCH/PCU SPI controller in
-	  master mode. This controller is present in modern Intel hardware
-	  and is used to hold BIOS and other persistent settings. Using
-	  this driver it is possible to upgrade BIOS directly from Linux.
-
-	  Say N here unless you know what you are doing. Overwriting the
-	  SPI flash may render the system unbootable.
-
-	  To compile this driver as a module, choose M here: the module
-	  will be called intel-spi-pci.
-
-config SPI_INTEL_SPI_PLATFORM
-	tristate "Intel PCH/PCU SPI flash platform driver (DANGEROUS)"
-	depends on X86
-	select SPI_INTEL_SPI
-	help
-	  This enables platform support for the Intel PCH/PCU SPI
-	  controller in master mode. This controller is present in modern
-	  Intel hardware and is used to hold BIOS and other persistent
-	  settings. Using this driver it is possible to upgrade BIOS
-	  directly from Linux.
-
-	  Say N here unless you know what you are doing. Overwriting the
-	  SPI flash may render the system unbootable.
-
-	  To compile this driver as a module, choose M here: the module
-	  will be called intel-spi-platform.
-=======
 source "drivers/mtd/spi-nor/controllers/Kconfig"
->>>>>>> linux-next/akpm-base
 
 endif # MTD_SPI_NOR
--- a/drivers/mtd/spi-nor/Makefile~linux-next-git-rejects
+++ a/drivers/mtd/spi-nor/Makefile
@@ -18,13 +18,3 @@ spi-nor-objs			+= winbond.o
 spi-nor-objs			+= xilinx.o
 spi-nor-objs			+= xmc.o
 obj-$(CONFIG_MTD_SPI_NOR)	+= spi-nor.o
-<<<<<<< HEAD
-obj-$(CONFIG_SPI_ASPEED_SMC)	+= aspeed-smc.o
-obj-$(CONFIG_SPI_CADENCE_QUADSPI)	+= cadence-quadspi.o
-obj-$(CONFIG_SPI_HISI_SFC)	+= hisi-sfc.o
-obj-$(CONFIG_SPI_NXP_SPIFI)	+= nxp-spifi.o
-obj-$(CONFIG_SPI_INTEL_SPI)	+= intel-spi.o
-obj-$(CONFIG_SPI_INTEL_SPI_PCI)	+= intel-spi-pci.o
-obj-$(CONFIG_SPI_INTEL_SPI_PLATFORM)	+= intel-spi-platform.o
-=======
->>>>>>> linux-next/akpm-base
--- a/drivers/pwm/pwm-omap-dmtimer.c~linux-next-git-rejects
+++ a/drivers/pwm/pwm-omap-dmtimer.c
@@ -228,38 +228,14 @@ static int pwm_omap_dmtimer_config(struc
 	load_value = (DM_TIMER_MAX - period_cycles) + 1;
 	match_value = load_value + duty_cycles - 1;
 
-<<<<<<< HEAD
-	/*
-	 * We MUST stop the associated dual-mode timer before attempting to
-	 * write its registers, but calls to omap_dm_timer_start/stop must
-	 * be balanced so check if timer is active before calling timer_stop.
-	 */
-	timer_active = pm_runtime_active(&omap->dm_timer_pdev->dev);
-	if (timer_active)
-		omap->pdata->stop(omap->dm_timer);
-
-=======
->>>>>>> linux-next/akpm-base
 	omap->pdata->set_load(omap->dm_timer, load_value);
 	omap->pdata->set_match(omap->dm_timer, true, match_value);
 
 	dev_dbg(chip->dev, "load value: %#08x (%d), match value: %#08x (%d)\n",
 		load_value, load_value,	match_value, match_value);
 
-<<<<<<< HEAD
-	omap->pdata->set_pwm(omap->dm_timer,
-			      pwm_get_polarity(pwm) == PWM_POLARITY_INVERSED,
-			      true,
-			      PWM_OMAP_DMTIMER_TRIGGER_OVERFLOW_AND_COMPARE,
-			      true);
-
-	/* If config was called while timer was running it must be reenabled. */
-	if (timer_active)
-		pwm_omap_dmtimer_start(omap);
-=======
 	return 0;
 }
->>>>>>> linux-next/akpm-base
 
 /**
  * pwm_omap_dmtimer_set_polarity() - Changes the polarity of the pwm dm timer.
@@ -304,13 +280,6 @@ static int pwm_omap_dmtimer_apply(struct
 	int ret = 0;
 
 	mutex_lock(&omap->mutex);
-<<<<<<< HEAD
-	omap->pdata->set_pwm(omap->dm_timer,
-			      polarity == PWM_POLARITY_INVERSED,
-			      true,
-			      PWM_OMAP_DMTIMER_TRIGGER_OVERFLOW_AND_COMPARE,
-			      true);
-=======
 
 	if (pwm_omap_dmtimer_is_enabled(omap) && !state->enabled) {
 		omap->pdata->stop(omap->dm_timer);
@@ -335,7 +304,6 @@ static int pwm_omap_dmtimer_apply(struct
 	}
 
 unlock_mutex:
->>>>>>> linux-next/akpm-base
 	mutex_unlock(&omap->mutex);
 
 	return ret;
--- a/drivers/staging/octeon/ethernet-tx.c~linux-next-git-rejects
+++ a/drivers/staging/octeon/ethernet-tx.c
@@ -352,17 +352,10 @@ int cvm_oct_xmit(struct sk_buff *skb, st
 	skb_dst_set(skb, NULL);
 	skb_ext_reset(skb);
 	nf_reset_ct(skb);
-<<<<<<< HEAD
-	skb_reset_redirect(skb);
-
-#ifdef CONFIG_NET_SCHED
-	skb->tc_index = 0;
-=======
 
 #ifdef CONFIG_NET_SCHED
 	skb->tc_index = 0;
 	skb_reset_redirect(skb);
->>>>>>> linux-next/akpm-base
 #endif /* CONFIG_NET_SCHED */
 #endif /* REUSE_SKBUFFS_WITHOUT_FREE */
 
--- a/fs/btrfs/disk-io.c~linux-next-git-rejects
+++ a/fs/btrfs/disk-io.c
@@ -2702,10 +2702,7 @@ void btrfs_init_fs_info(struct btrfs_fs_
 #endif
 	btrfs_init_balance(fs_info);
 	btrfs_init_async_reclaim_work(&fs_info->async_reclaim_work);
-<<<<<<< HEAD
-=======
 	btrfs_init_async_delayed_ref_work(fs_info);
->>>>>>> linux-next/akpm-base
 
 	spin_lock_init(&fs_info->block_group_cache_lock);
 	fs_info->block_group_cache_tree = RB_ROOT;
@@ -2847,7 +2844,6 @@ int __cold open_ctree(struct super_block
 	if (ret) {
 		err = ret;
 		goto fail;
-<<<<<<< HEAD
 	}
 
 	/* These need to be init'ed before we start creating inodes and such. */
@@ -2862,22 +2858,6 @@ int __cold open_ctree(struct super_block
 		goto fail;
 	}
 
-=======
-	}
-
-	/* These need to be init'ed before we start creating inodes and such. */
-	tree_root = btrfs_alloc_root(fs_info, BTRFS_ROOT_TREE_OBJECTID,
-				     GFP_KERNEL);
-	fs_info->tree_root = tree_root;
-	chunk_root = btrfs_alloc_root(fs_info, BTRFS_CHUNK_TREE_OBJECTID,
-				      GFP_KERNEL);
-	fs_info->chunk_root = chunk_root;
-	if (!tree_root || !chunk_root) {
-		err = -ENOMEM;
-		goto fail;
-	}
-
->>>>>>> linux-next/akpm-base
 	fs_info->btree_inode = new_inode(sb);
 	if (!fs_info->btree_inode) {
 		err = -ENOMEM;
--- a/fs/btrfs/extent_io.c~linux-next-git-rejects
+++ a/fs/btrfs/extent_io.c
@@ -63,7 +63,6 @@ void btrfs_extent_buffer_leak_debug_chec
 {
 	struct extent_buffer *eb;
 	unsigned long flags;
-<<<<<<< HEAD
 
 	/*
 	 * If we didn't get into open_ctree our allocated_ebs will not be
@@ -72,16 +71,6 @@ void btrfs_extent_buffer_leak_debug_chec
 	if (!fs_info->allocated_ebs.next)
 		return;
 
-=======
-
-	/*
-	 * If we didn't get into open_ctree our allocated_ebs will not be
-	 * initialized, so just skip this.
-	 */
-	if (!fs_info->allocated_ebs.next)
-		return;
-
->>>>>>> linux-next/akpm-base
 	spin_lock_irqsave(&fs_info->eb_leak_lock, flags);
 	while (!list_empty(&fs_info->allocated_ebs)) {
 		eb = list_first_entry(&fs_info->allocated_ebs,
--- a/fs/btrfs/transaction.c~linux-next-git-rejects
+++ a/fs/btrfs/transaction.c
@@ -955,10 +955,7 @@ static int __btrfs_end_transaction(struc
 	if (throttle)
 		btrfs_run_delayed_iputs(info);
 
-<<<<<<< HEAD
-=======
 	total_delayed_refs = trans->total_delayed_refs;
->>>>>>> linux-next/akpm-base
 	if (TRANS_ABORTED(trans) ||
 	    test_bit(BTRFS_FS_STATE_ERROR, &info->fs_state)) {
 		wake_up_process(info->transaction_kthread);
--- a/include/linux/irqflags.h~linux-next-git-rejects
+++ a/include/linux/irqflags.h
@@ -40,11 +40,7 @@ do {						\
 	if (!current->hardirq_context++)	\
 		current->hardirq_threaded = 0;	\
 } while (0)
-<<<<<<< HEAD
-# define lockdep_hardirq_threaded()		\
-=======
 # define trace_hardirq_threaded()		\
->>>>>>> linux-next/akpm-base
 do {						\
 	current->hardirq_threaded = 1;		\
 } while (0)
@@ -97,19 +93,12 @@ do {						\
 #else
 # define trace_hardirqs_on()		do { } while (0)
 # define trace_hardirqs_off()		do { } while (0)
-<<<<<<< HEAD
-=======
 # define trace_hardirq_threaded()	do { } while (0)
->>>>>>> linux-next/akpm-base
 # define lockdep_hardirq_context(p)	0
 # define lockdep_softirq_context(p)	0
 # define lockdep_hardirqs_enabled(p)	0
 # define lockdep_softirqs_enabled(p)	0
 # define lockdep_hardirq_enter()	do { } while (0)
-<<<<<<< HEAD
-# define lockdep_hardirq_threaded()	do { } while (0)
-=======
->>>>>>> linux-next/akpm-base
 # define lockdep_hardirq_exit()		do { } while (0)
 # define lockdep_softirq_enter()	do { } while (0)
 # define lockdep_softirq_exit()		do { } while (0)
--- a/include/linux/usb/audio-v2.h~linux-next-git-rejects
+++ a/include/linux/usb/audio-v2.h
@@ -154,8 +154,6 @@ struct uac2_feature_unit_descriptor {
 	/* bmaControls is actually u32,
 	 * but u8 is needed for the hybrid parser */
 	__u8 bmaControls[]; /* variable length */
-<<<<<<< HEAD
-=======
 } __attribute__((packed));
 
 /* 4.7.2.10 Effect Unit Descriptor */
@@ -168,7 +166,6 @@ struct uac2_effect_unit_descriptor {
 	__le16 wEffectType;
 	__u8 bSourceID;
 	__u8 bmaControls[]; /* variable length */
->>>>>>> linux-next/akpm-base
 } __attribute__((packed));
 
 /* 4.9.2 Class-Specific AS Interface Descriptor */
--- a/kernel/events/core.c~linux-next-git-rejects
+++ a/kernel/events/core.c
@@ -3552,15 +3552,9 @@ static noinline int visit_groups_merge(s
 			.nr = 0,
 			.size = cpuctx->heap_size,
 		};
-<<<<<<< HEAD
 
 		lockdep_assert_held(&cpuctx->ctx.lock);
 
-=======
-
-		lockdep_assert_held(&cpuctx->ctx.lock);
-
->>>>>>> linux-next/akpm-base
 #ifdef CONFIG_CGROUP_PERF
 		if (cpuctx->cgrp)
 			css = &cpuctx->cgrp->css;
@@ -3633,17 +3627,10 @@ ctx_pinned_sched_in(struct perf_event_co
 		    struct perf_cpu_context *cpuctx)
 {
 	int can_add_hw = 1;
-<<<<<<< HEAD
 
 	if (ctx != &cpuctx->ctx)
 		cpuctx = NULL;
 
-=======
-
-	if (ctx != &cpuctx->ctx)
-		cpuctx = NULL;
-
->>>>>>> linux-next/akpm-base
 	visit_groups_merge(cpuctx, &ctx->pinned_groups,
 			   smp_processor_id(),
 			   merge_sched_in, &can_add_hw);
@@ -3654,17 +3641,10 @@ ctx_flexible_sched_in(struct perf_event_
 		      struct perf_cpu_context *cpuctx)
 {
 	int can_add_hw = 1;
-<<<<<<< HEAD
-
-	if (ctx != &cpuctx->ctx)
-		cpuctx = NULL;
-
-=======
 
 	if (ctx != &cpuctx->ctx)
 		cpuctx = NULL;
 
->>>>>>> linux-next/akpm-base
 	visit_groups_merge(cpuctx, &ctx->flexible_groups,
 			   smp_processor_id(),
 			   merge_sched_in, &can_add_hw);
--- a/kernel/irq/handle.c~linux-next-git-rejects
+++ a/kernel/irq/handle.c
@@ -150,11 +150,7 @@ irqreturn_t __handle_irq_event_percpu(st
 		 */
 		if (irq_settings_can_thread(desc) &&
 		    !(action->flags & (IRQF_NO_THREAD | IRQF_PERCPU | IRQF_ONESHOT)))
-<<<<<<< HEAD
-			lockdep_hardirq_threaded();
-=======
 			trace_hardirq_threaded();
->>>>>>> linux-next/akpm-base
 
 		trace_irq_handler_entry(irq, action);
 		res = action->handler(irq, action->dev_id);
--- a/kernel/rcu/tree.c~linux-next-git-rejects
+++ a/kernel/rcu/tree.c
@@ -867,22 +867,16 @@ static __always_inline void rcu_nmi_ente
 		   rdp->dynticks_nmi_nesting == DYNTICK_IRQ_NONIDLE &&
 		   READ_ONCE(rdp->rcu_urgent_qs) &&
 		   !READ_ONCE(rdp->rcu_forced_tick)) {
-<<<<<<< HEAD
-=======
 		// We get here only if we had already exited the extended
 		// quiescent state and this was an interrupt (not an NMI).
 		// Therefore, (1) RCU is already watching and (2) The fact
 		// that we are in an interrupt handler and that the rcu_node
 		// lock is an irq-disabled lock prevents self-deadlock.
 		// So we can safely recheck under the lock.
->>>>>>> linux-next/akpm-base
 		raw_spin_lock_rcu_node(rdp->mynode);
 		if (rdp->rcu_urgent_qs && !rdp->rcu_forced_tick) {
-<<<<<<< HEAD
-=======
 			// A nohz_full CPU is in the kernel and RCU
 			// needs a quiescent state.  Turn on the tick!
->>>>>>> linux-next/akpm-base
 			WRITE_ONCE(rdp->rcu_forced_tick, true);
 			tick_dep_set_cpu(rdp->cpu, TICK_DEP_BIT_RCU);
 		}
@@ -1268,11 +1262,7 @@ static bool rcu_start_this_gp(struct rcu
 		trace_rcu_this_gp(rnp, rdp, gp_seq_req, TPS("NoGPkthread"));
 		goto unlock_out;
 	}
-<<<<<<< HEAD
-	trace_rcu_grace_period(rcu_state.name, rcu_state.gp_seq, TPS("newreq"));
-=======
 	trace_rcu_grace_period(rcu_state.name, data_race(rcu_state.gp_seq), TPS("newreq"));
->>>>>>> linux-next/akpm-base
 	ret = true;  /* Caller must wake GP kthread. */
 unlock_out:
 	/* Push furthest requested GP to leaf node and rcu_data structure. */
@@ -1747,15 +1737,11 @@ static void rcu_gp_fqs_loop(void)
 			trace_rcu_grace_period(rcu_state.name, rcu_state.gp_seq,
 					       TPS("fqsstart"));
 			rcu_gp_fqs(first_gp_fqs);
-<<<<<<< HEAD
-			first_gp_fqs = false;
-=======
 			gf = 0;
 			if (first_gp_fqs) {
 				first_gp_fqs = false;
 				gf = rcu_state.cbovld ? RCU_GP_FLAG_OVLD : 0;
 			}
->>>>>>> linux-next/akpm-base
 			trace_rcu_grace_period(rcu_state.name, rcu_state.gp_seq,
 					       TPS("fqsend"));
 			cond_resched_tasks_rcu_qs();
@@ -2998,11 +2984,8 @@ static inline bool queue_kfree_rcu_work(
 				krcp->head = NULL;
 			}
 
-<<<<<<< HEAD
-=======
 			WRITE_ONCE(krcp->count, 0);
 
->>>>>>> linux-next/akpm-base
 			/*
 			 * One work is per one batch, so there are two "free channels",
 			 * "bhead_free" and "head_free" the batch can handle. It can be
@@ -3138,11 +3121,8 @@ void kfree_call_rcu(struct rcu_head *hea
 		head->next = krcp->head;
 		krcp->head = head;
 	}
-<<<<<<< HEAD
-=======
 
 	WRITE_ONCE(krcp->count, krcp->count + 1);
->>>>>>> linux-next/akpm-base
 
 	// Set timer to drain after KFREE_DRAIN_JIFFIES.
 	if (rcu_scheduler_active == RCU_SCHEDULER_RUNNING &&
--- a/kernel/rcu/tree_stall.h~linux-next-git-rejects
+++ a/kernel/rcu/tree_stall.h
@@ -621,29 +621,17 @@ void show_rcu_gp_kthreads(void)
 	pr_info("%s: wait state: %s(%d) ->state: %#lx delta ->gp_activity %lu ->gp_req_activity %lu ->gp_wake_time %lu ->gp_wake_seq %ld ->gp_seq %ld ->gp_seq_needed %ld ->gp_flags %#x\n",
 		rcu_state.name, gp_state_getname(rcu_state.gp_state),
 		rcu_state.gp_state, t ? t->state : 0x1ffffL,
-<<<<<<< HEAD
-		ja, jr, jw, (long)READ_ONCE(rcu_state.gp_wake_seq),
-		(long)READ_ONCE(rcu_state.gp_seq),
-		(long)READ_ONCE(rcu_get_root()->gp_seq_needed),
-		READ_ONCE(rcu_state.gp_flags));
-=======
 		ja, jr, jw, (long)data_race(rcu_state.gp_wake_seq),
 		(long)data_race(rcu_state.gp_seq),
 		(long)data_race(rcu_get_root()->gp_seq_needed),
 		data_race(rcu_state.gp_flags));
->>>>>>> linux-next/akpm-base
 	rcu_for_each_node_breadth_first(rnp) {
 		if (ULONG_CMP_GE(READ_ONCE(rcu_state.gp_seq),
 				 READ_ONCE(rnp->gp_seq_needed)))
 			continue;
 		pr_info("\trcu_node %d:%d ->gp_seq %ld ->gp_seq_needed %ld\n",
-<<<<<<< HEAD
-			rnp->grplo, rnp->grphi, (long)READ_ONCE(rnp->gp_seq),
-			(long)READ_ONCE(rnp->gp_seq_needed));
-=======
 			rnp->grplo, rnp->grphi, (long)data_race(rnp->gp_seq),
 			(long)data_race(rnp->gp_seq_needed));
->>>>>>> linux-next/akpm-base
 		if (!rcu_is_leaf_node(rnp))
 			continue;
 		for_each_leaf_node_possible_cpu(rnp, cpu) {
@@ -653,11 +641,7 @@ void show_rcu_gp_kthreads(void)
 					 READ_ONCE(rdp->gp_seq_needed)))
 				continue;
 			pr_info("\tcpu %d ->gp_seq_needed %ld\n",
-<<<<<<< HEAD
-				cpu, (long)READ_ONCE(rdp->gp_seq_needed));
-=======
 				cpu, (long)data_race(rdp->gp_seq_needed));
->>>>>>> linux-next/akpm-base
 		}
 	}
 	for_each_possible_cpu(cpu) {
--- a/kernel/rcu/update.c~linux-next-git-rejects
+++ a/kernel/rcu/update.c
@@ -501,373 +501,6 @@ module_param(rcu_cpu_stall_timeout, int,
 int rcu_cpu_stall_suppress_at_boot __read_mostly; // !0 = suppress boot stalls.
 EXPORT_SYMBOL_GPL(rcu_cpu_stall_suppress_at_boot);
 module_param(rcu_cpu_stall_suppress_at_boot, int, 0444);
-<<<<<<< HEAD
-
-#ifdef CONFIG_TASKS_RCU
-
-/*
- * Simple variant of RCU whose quiescent states are voluntary context
- * switch, cond_resched_rcu_qs(), user-space execution, and idle.
- * As such, grace periods can take one good long time.  There are no
- * read-side primitives similar to rcu_read_lock() and rcu_read_unlock()
- * because this implementation is intended to get the system into a safe
- * state for some of the manipulations involved in tracing and the like.
- * Finally, this implementation does not support high call_rcu_tasks()
- * rates from multiple CPUs.  If this is required, per-CPU callback lists
- * will be needed.
- */
-
-/* Global list of callbacks and associated lock. */
-static struct rcu_head *rcu_tasks_cbs_head;
-static struct rcu_head **rcu_tasks_cbs_tail = &rcu_tasks_cbs_head;
-static DECLARE_WAIT_QUEUE_HEAD(rcu_tasks_cbs_wq);
-static DEFINE_RAW_SPINLOCK(rcu_tasks_cbs_lock);
-
-/* Track exiting tasks in order to allow them to be waited for. */
-DEFINE_STATIC_SRCU(tasks_rcu_exit_srcu);
-
-/* Control stall timeouts.  Disable with <= 0, otherwise jiffies till stall. */
-#define RCU_TASK_STALL_TIMEOUT (HZ * 60 * 10)
-static int rcu_task_stall_timeout __read_mostly = RCU_TASK_STALL_TIMEOUT;
-module_param(rcu_task_stall_timeout, int, 0644);
-
-static struct task_struct *rcu_tasks_kthread_ptr;
-
-/**
- * call_rcu_tasks() - Queue an RCU for invocation task-based grace period
- * @rhp: structure to be used for queueing the RCU updates.
- * @func: actual callback function to be invoked after the grace period
- *
- * The callback function will be invoked some time after a full grace
- * period elapses, in other words after all currently executing RCU
- * read-side critical sections have completed. call_rcu_tasks() assumes
- * that the read-side critical sections end at a voluntary context
- * switch (not a preemption!), cond_resched_rcu_qs(), entry into idle,
- * or transition to usermode execution.  As such, there are no read-side
- * primitives analogous to rcu_read_lock() and rcu_read_unlock() because
- * this primitive is intended to determine that all tasks have passed
- * through a safe state, not so much for data-strcuture synchronization.
- *
- * See the description of call_rcu() for more detailed information on
- * memory ordering guarantees.
- */
-void call_rcu_tasks(struct rcu_head *rhp, rcu_callback_t func)
-{
-	unsigned long flags;
-	bool needwake;
-
-	rhp->next = NULL;
-	rhp->func = func;
-	raw_spin_lock_irqsave(&rcu_tasks_cbs_lock, flags);
-	needwake = !rcu_tasks_cbs_head;
-	WRITE_ONCE(*rcu_tasks_cbs_tail, rhp);
-	rcu_tasks_cbs_tail = &rhp->next;
-	raw_spin_unlock_irqrestore(&rcu_tasks_cbs_lock, flags);
-	/* We can't create the thread unless interrupts are enabled. */
-	if (needwake && READ_ONCE(rcu_tasks_kthread_ptr))
-		wake_up(&rcu_tasks_cbs_wq);
-}
-EXPORT_SYMBOL_GPL(call_rcu_tasks);
-
-/**
- * synchronize_rcu_tasks - wait until an rcu-tasks grace period has elapsed.
- *
- * Control will return to the caller some time after a full rcu-tasks
- * grace period has elapsed, in other words after all currently
- * executing rcu-tasks read-side critical sections have elapsed.  These
- * read-side critical sections are delimited by calls to schedule(),
- * cond_resched_tasks_rcu_qs(), idle execution, userspace execution, calls
- * to synchronize_rcu_tasks(), and (in theory, anyway) cond_resched().
- *
- * This is a very specialized primitive, intended only for a few uses in
- * tracing and other situations requiring manipulation of function
- * preambles and profiling hooks.  The synchronize_rcu_tasks() function
- * is not (yet) intended for heavy use from multiple CPUs.
- *
- * Note that this guarantee implies further memory-ordering guarantees.
- * On systems with more than one CPU, when synchronize_rcu_tasks() returns,
- * each CPU is guaranteed to have executed a full memory barrier since the
- * end of its last RCU-tasks read-side critical section whose beginning
- * preceded the call to synchronize_rcu_tasks().  In addition, each CPU
- * having an RCU-tasks read-side critical section that extends beyond
- * the return from synchronize_rcu_tasks() is guaranteed to have executed
- * a full memory barrier after the beginning of synchronize_rcu_tasks()
- * and before the beginning of that RCU-tasks read-side critical section.
- * Note that these guarantees include CPUs that are offline, idle, or
- * executing in user mode, as well as CPUs that are executing in the kernel.
- *
- * Furthermore, if CPU A invoked synchronize_rcu_tasks(), which returned
- * to its caller on CPU B, then both CPU A and CPU B are guaranteed
- * to have executed a full memory barrier during the execution of
- * synchronize_rcu_tasks() -- even if CPU A and CPU B are the same CPU
- * (but again only if the system has more than one CPU).
- */
-void synchronize_rcu_tasks(void)
-{
-	/* Complain if the scheduler has not started.  */
-	RCU_LOCKDEP_WARN(rcu_scheduler_active == RCU_SCHEDULER_INACTIVE,
-			 "synchronize_rcu_tasks called too soon");
-
-	/* Wait for the grace period. */
-	wait_rcu_gp(call_rcu_tasks);
-}
-EXPORT_SYMBOL_GPL(synchronize_rcu_tasks);
-
-/**
- * rcu_barrier_tasks - Wait for in-flight call_rcu_tasks() callbacks.
- *
- * Although the current implementation is guaranteed to wait, it is not
- * obligated to, for example, if there are no pending callbacks.
- */
-void rcu_barrier_tasks(void)
-{
-	/* There is only one callback queue, so this is easy.  ;-) */
-	synchronize_rcu_tasks();
-}
-EXPORT_SYMBOL_GPL(rcu_barrier_tasks);
-
-/* See if tasks are still holding out, complain if so. */
-static void check_holdout_task(struct task_struct *t,
-			       bool needreport, bool *firstreport)
-{
-	int cpu;
-
-	if (!READ_ONCE(t->rcu_tasks_holdout) ||
-	    t->rcu_tasks_nvcsw != READ_ONCE(t->nvcsw) ||
-	    !READ_ONCE(t->on_rq) ||
-	    (IS_ENABLED(CONFIG_NO_HZ_FULL) &&
-	     !is_idle_task(t) && t->rcu_tasks_idle_cpu >= 0)) {
-		WRITE_ONCE(t->rcu_tasks_holdout, false);
-		list_del_init(&t->rcu_tasks_holdout_list);
-		put_task_struct(t);
-		return;
-	}
-	rcu_request_urgent_qs_task(t);
-	if (!needreport)
-		return;
-	if (*firstreport) {
-		pr_err("INFO: rcu_tasks detected stalls on tasks:\n");
-		*firstreport = false;
-	}
-	cpu = task_cpu(t);
-	pr_alert("%p: %c%c nvcsw: %lu/%lu holdout: %d idle_cpu: %d/%d\n",
-		 t, ".I"[is_idle_task(t)],
-		 "N."[cpu < 0 || !tick_nohz_full_cpu(cpu)],
-		 t->rcu_tasks_nvcsw, t->nvcsw, t->rcu_tasks_holdout,
-		 t->rcu_tasks_idle_cpu, cpu);
-	sched_show_task(t);
-}
-
-/* RCU-tasks kthread that detects grace periods and invokes callbacks. */
-static int __noreturn rcu_tasks_kthread(void *arg)
-{
-	unsigned long flags;
-	struct task_struct *g, *t;
-	unsigned long lastreport;
-	struct rcu_head *list;
-	struct rcu_head *next;
-	LIST_HEAD(rcu_tasks_holdouts);
-	int fract;
-
-	/* Run on housekeeping CPUs by default.  Sysadm can move if desired. */
-	housekeeping_affine(current, HK_FLAG_RCU);
-
-	/*
-	 * Each pass through the following loop makes one check for
-	 * newly arrived callbacks, and, if there are some, waits for
-	 * one RCU-tasks grace period and then invokes the callbacks.
-	 * This loop is terminated by the system going down.  ;-)
-	 */
-	for (;;) {
-
-		/* Pick up any new callbacks. */
-		raw_spin_lock_irqsave(&rcu_tasks_cbs_lock, flags);
-		list = rcu_tasks_cbs_head;
-		rcu_tasks_cbs_head = NULL;
-		rcu_tasks_cbs_tail = &rcu_tasks_cbs_head;
-		raw_spin_unlock_irqrestore(&rcu_tasks_cbs_lock, flags);
-
-		/* If there were none, wait a bit and start over. */
-		if (!list) {
-			wait_event_interruptible(rcu_tasks_cbs_wq,
-						 READ_ONCE(rcu_tasks_cbs_head));
-			if (!rcu_tasks_cbs_head) {
-				WARN_ON(signal_pending(current));
-				schedule_timeout_interruptible(HZ/10);
-			}
-			continue;
-		}
-
-		/*
-		 * Wait for all pre-existing t->on_rq and t->nvcsw
-		 * transitions to complete.  Invoking synchronize_rcu()
-		 * suffices because all these transitions occur with
-		 * interrupts disabled.  Without this synchronize_rcu(),
-		 * a read-side critical section that started before the
-		 * grace period might be incorrectly seen as having started
-		 * after the grace period.
-		 *
-		 * This synchronize_rcu() also dispenses with the
-		 * need for a memory barrier on the first store to
-		 * ->rcu_tasks_holdout, as it forces the store to happen
-		 * after the beginning of the grace period.
-		 */
-		synchronize_rcu();
-
-		/*
-		 * There were callbacks, so we need to wait for an
-		 * RCU-tasks grace period.  Start off by scanning
-		 * the task list for tasks that are not already
-		 * voluntarily blocked.  Mark these tasks and make
-		 * a list of them in rcu_tasks_holdouts.
-		 */
-		rcu_read_lock();
-		for_each_process_thread(g, t) {
-			if (t != current && READ_ONCE(t->on_rq) &&
-			    !is_idle_task(t)) {
-				get_task_struct(t);
-				t->rcu_tasks_nvcsw = READ_ONCE(t->nvcsw);
-				WRITE_ONCE(t->rcu_tasks_holdout, true);
-				list_add(&t->rcu_tasks_holdout_list,
-					 &rcu_tasks_holdouts);
-			}
-		}
-		rcu_read_unlock();
-
-		/*
-		 * Wait for tasks that are in the process of exiting.
-		 * This does only part of the job, ensuring that all
-		 * tasks that were previously exiting reach the point
-		 * where they have disabled preemption, allowing the
-		 * later synchronize_rcu() to finish the job.
-		 */
-		synchronize_srcu(&tasks_rcu_exit_srcu);
-
-		/*
-		 * Each pass through the following loop scans the list
-		 * of holdout tasks, removing any that are no longer
-		 * holdouts.  When the list is empty, we are done.
-		 */
-		lastreport = jiffies;
-
-		/* Start off with HZ/10 wait and slowly back off to 1 HZ wait*/
-		fract = 10;
-
-		for (;;) {
-			bool firstreport;
-			bool needreport;
-			int rtst;
-			struct task_struct *t1;
-
-			if (list_empty(&rcu_tasks_holdouts))
-				break;
-
-			/* Slowly back off waiting for holdouts */
-			schedule_timeout_interruptible(HZ/fract);
-
-			if (fract > 1)
-				fract--;
-
-			rtst = READ_ONCE(rcu_task_stall_timeout);
-			needreport = rtst > 0 &&
-				     time_after(jiffies, lastreport + rtst);
-			if (needreport)
-				lastreport = jiffies;
-			firstreport = true;
-			WARN_ON(signal_pending(current));
-			list_for_each_entry_safe(t, t1, &rcu_tasks_holdouts,
-						rcu_tasks_holdout_list) {
-				check_holdout_task(t, needreport, &firstreport);
-				cond_resched();
-			}
-		}
-
-		/*
-		 * Because ->on_rq and ->nvcsw are not guaranteed
-		 * to have a full memory barriers prior to them in the
-		 * schedule() path, memory reordering on other CPUs could
-		 * cause their RCU-tasks read-side critical sections to
-		 * extend past the end of the grace period.  However,
-		 * because these ->nvcsw updates are carried out with
-		 * interrupts disabled, we can use synchronize_rcu()
-		 * to force the needed ordering on all such CPUs.
-		 *
-		 * This synchronize_rcu() also confines all
-		 * ->rcu_tasks_holdout accesses to be within the grace
-		 * period, avoiding the need for memory barriers for
-		 * ->rcu_tasks_holdout accesses.
-		 *
-		 * In addition, this synchronize_rcu() waits for exiting
-		 * tasks to complete their final preempt_disable() region
-		 * of execution, cleaning up after the synchronize_srcu()
-		 * above.
-		 */
-		synchronize_rcu();
-
-		/* Invoke the callbacks. */
-		while (list) {
-			next = list->next;
-			local_bh_disable();
-			list->func(list);
-			local_bh_enable();
-			list = next;
-			cond_resched();
-		}
-		/* Paranoid sleep to keep this from entering a tight loop */
-		schedule_timeout_uninterruptible(HZ/10);
-	}
-}
-
-/* Spawn rcu_tasks_kthread() at core_initcall() time. */
-static int __init rcu_spawn_tasks_kthread(void)
-{
-	struct task_struct *t;
-
-	t = kthread_run(rcu_tasks_kthread, NULL, "rcu_tasks_kthread");
-	if (WARN_ONCE(IS_ERR(t), "%s: Could not start Tasks-RCU grace-period kthread, OOM is now expected behavior\n", __func__))
-		return 0;
-	smp_mb(); /* Ensure others see full kthread. */
-	WRITE_ONCE(rcu_tasks_kthread_ptr, t);
-	return 0;
-}
-core_initcall(rcu_spawn_tasks_kthread);
-
-/* Do the srcu_read_lock() for the above synchronize_srcu().  */
-void exit_tasks_rcu_start(void) __acquires(&tasks_rcu_exit_srcu)
-{
-	preempt_disable();
-	current->rcu_tasks_idx = __srcu_read_lock(&tasks_rcu_exit_srcu);
-	preempt_enable();
-}
-
-/* Do the srcu_read_unlock() for the above synchronize_srcu().  */
-void exit_tasks_rcu_finish(void) __releases(&tasks_rcu_exit_srcu)
-{
-	preempt_disable();
-	__srcu_read_unlock(&tasks_rcu_exit_srcu, current->rcu_tasks_idx);
-	preempt_enable();
-}
-
-#endif /* #ifdef CONFIG_TASKS_RCU */
-
-#ifndef CONFIG_TINY_RCU
-
-/*
- * Print any non-default Tasks RCU settings.
- */
-static void __init rcu_tasks_bootup_oddness(void)
-{
-#ifdef CONFIG_TASKS_RCU
-	if (rcu_task_stall_timeout != RCU_TASK_STALL_TIMEOUT)
-		pr_info("\tTasks-RCU CPU stall warnings timeout set to %d (rcu_task_stall_timeout).\n", rcu_task_stall_timeout);
-	else
-		pr_info("\tTasks RCU enabled.\n");
-#endif /* #ifdef CONFIG_TASKS_RCU */
-}
-
-#endif /* #ifndef CONFIG_TINY_RCU */
-=======
->>>>>>> linux-next/akpm-base
 
 #ifdef CONFIG_PROVE_RCU
 
--- a/MAINTAINERS~linux-next-git-rejects
+++ a/MAINTAINERS
@@ -6389,8 +6389,6 @@ F:	include/trace/events/mdio.h
 F:	include/uapi/linux/mdio.h
 F:	include/uapi/linux/mii.h
 
-<<<<<<< HEAD
-=======
 EXFAT FILE SYSTEM
 M:	Namjae Jeon <namjae.jeon@samsung.com>
 M:	Sungjong Seo <sj1557.seo@samsung.com>
@@ -6398,7 +6396,6 @@ L:	linux-fsdevel@vger.kernel.org
 S:	Maintained
 F:	fs/exfat/
 
->>>>>>> linux-next/akpm-base
 EXT2 FILE SYSTEM
 M:	Jan Kara <jack@suse.com>
 L:	linux-ext4@vger.kernel.org
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-gup-track-foll_pin-pages-fix-2-fix.patch
mm-swap-make-page_evictable-inline-fix.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
mm-mmap-add-trace-point-of-vm_unmapped_area-fix.patch
selftest-add-mremap_dontunmap-selftest-fix.patch
selftest-add-mremap_dontunmap-selftest-v7-checkpatch-fixes.patch
hugetlb_cgroup-add-reservation-accounting-for-private-mappings-fix.patch
hugetlb_cgroup-add-accounting-for-shared-mappings-fix.patch
mm-hugetlbc-fix-printk-format-warning-for-32-bit-phys_addr_t-fix.patch
mm-migratec-migrate-pg_readahead-flag-fix.patch
hv_balloon-dont-check-for-memhp_auto_online-manually-fix.patch
proc-faster-open-read-close-with-permanent-files-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-fix.patch
linux-next-git-rejects.patch
drivers-net-ethernet-mellanox-mlx4-crdumpc-fix-build-with-gcc-720.patch
mm-add-vm_insert_pages-fix.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch
seq_read-info-message-about-buggy-next-functions-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
