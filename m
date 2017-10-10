From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Tue, 10 Oct 2017 12:49:57 -0700
Message-ID: <20171010194957.orT4lBtlM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41924 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751804AbdJJTt6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Oct 2017 15:49:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/boot/dts/hsdk.dts      |    9 --
 arch/powerpc/kernel/mce_power.c |    8 --
 arch/powerpc/kernel/watchdog.c  |   18 ----
 arch/x86/kvm/vmx.c              |    5 -
 drivers/mmc/core/block.c        |    3 
 drivers/mmc/core/queue.c        |   19 ----
 drivers/mmc/core/queue.h        |    5 -
 drivers/tty/serial/fsl_lpuart.c |    3 
 fs/btrfs/extent_io.c            |    4 -
 include/linux/nmi.h             |    6 -
 kernel/smpboot.c                |    7 -
 kernel/watchdog.c               |  119 ------------------------------
 lib/kobject_uevent.c            |    3 
 net/dsa/slave.c                 |    4 -
 tools/include/uapi/linux/bpf.h  |    3 
 15 files changed, 216 deletions(-)

diff -puN arch/arc/boot/dts/hsdk.dts~linux-next-git-rejects arch/arc/boot/dts/hsdk.dts
--- a/arch/arc/boot/dts/hsdk.dts~linux-next-git-rejects
+++ a/arch/arc/boot/dts/hsdk.dts
@@ -103,15 +103,6 @@
 
 		ranges = <0x00000000 0xf0000000 0x10000000>;
 
-<<<<<<< HEAD
-		cgu_rst: reset-controller@8a0 {
-			compatible = "snps,hsdk-reset";
-			#reset-cells = <1>;
-			reg = <0x8A0 0x4>, <0xFF0 0x4>;
-		};
-
-=======
->>>>>>> linux-next/akpm-base
 		core_clk: core-clk@0 {
 			compatible = "snps,hsdk-core-pll-clock";
 			reg = <0x00 0x10>, <0x14B8 0x4>;
diff -puN arch/powerpc/kernel/mce_power.c~linux-next-git-rejects arch/powerpc/kernel/mce_power.c
--- a/arch/powerpc/kernel/mce_power.c~linux-next-git-rejects
+++ a/arch/powerpc/kernel/mce_power.c
@@ -626,11 +626,7 @@ long __machine_check_early_realmode_p9(s
 {
 	/*
 	 * On POWER9 DD2.1 and below, it's possible to get a machine check
-<<<<<<< HEAD
-	 * caused by a paste instruction where only DSISR bit 25 is set. This
-=======
 	 * caused by a paste instruction where only DSISR bit 30 is set. This
->>>>>>> linux-next/akpm-base
 	 * will result in the MCE handler seeing an unknown event and the kernel
 	 * crashing. An MCE that occurs like this is spurious, so we don't need
 	 * to do anything in terms of servicing it. If there is something that
@@ -638,11 +634,7 @@ long __machine_check_early_realmode_p9(s
 	 * correct DSISR so that it can be serviced properly. So detect this
 	 * case and mark it as handled.
 	 */
-<<<<<<< HEAD
-	if (SRR1_MC_LOADSTORE(regs->msr) && regs->dsisr == 0x02000000)
-=======
 	if (SRR1_MC_LOADSTORE(regs->msr) && regs->dsisr == 0x40000000)
->>>>>>> linux-next/akpm-base
 		return 1;
 
 	return mce_handle_error(regs, mce_p9_derror_table, mce_p9_ierror_table);
diff -puN arch/powerpc/kernel/watchdog.c~linux-next-git-rejects arch/powerpc/kernel/watchdog.c
--- a/arch/powerpc/kernel/watchdog.c~linux-next-git-rejects
+++ a/arch/powerpc/kernel/watchdog.c
@@ -355,23 +355,6 @@ static void watchdog_calc_timeouts(void)
 	wd_timer_period_ms = watchdog_thresh * 1000 * 2 / 5;
 }
 
-<<<<<<< HEAD
-void watchdog_nmi_stop(void)
-{
-	int cpu;
-
-	for_each_cpu(cpu, &wd_cpus_enabled)
-		stop_wd_on_cpu(cpu);
-}
-
-void watchdog_nmi_start(void)
-{
-	int cpu;
-
-	watchdog_calc_timeouts();
-	for_each_cpu_and(cpu, cpu_online_mask, &watchdog_cpumask)
-		start_wd_on_cpu(cpu);
-=======
 void watchdog_nmi_reconfigure(bool run)
 {
 	int cpu;
@@ -386,7 +369,6 @@ void watchdog_nmi_reconfigure(bool run)
 			start_wd_on_cpu(cpu);
 	}
 	cpus_read_unlock();
->>>>>>> linux-next/akpm-base
 }
 
 /*
diff -puN arch/x86/kvm/vmx.c~linux-next-git-rejects arch/x86/kvm/vmx.c
--- a/arch/x86/kvm/vmx.c~linux-next-git-rejects
+++ a/arch/x86/kvm/vmx.c
@@ -11730,13 +11730,8 @@ static void __pi_post_block(struct kvm_v
 
 		/* set 'NV' to 'notification vector' */
 		new.nv = POSTED_INTR_VECTOR;
-<<<<<<< HEAD
-	} while (cmpxchg64(&pi_desc->control, old.control,
-			   new.control) != old.control);
-=======
 	} while (cmpxchg(&pi_desc->control, old.control,
 			new.control) != old.control);
->>>>>>> linux-next/akpm-base
 
 	if (!WARN_ON_ONCE(vcpu->pre_pcpu == -1)) {
 		spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
diff -puN drivers/mmc/core/block.c~linux-next-git-rejects drivers/mmc/core/block.c
--- a/drivers/mmc/core/block.c~linux-next-git-rejects
+++ a/drivers/mmc/core/block.c
@@ -1690,15 +1690,12 @@ static void mmc_blk_data_prep(struct mmc
 	}
 
 	mqrq->areq.mrq = &brq->mrq;
-<<<<<<< HEAD
-=======
 
 	if (do_rel_wr_p)
 		*do_rel_wr_p = do_rel_wr;
 
 	if (do_data_tag_p)
 		*do_data_tag_p = do_data_tag;
->>>>>>> linux-next/akpm-base
 }
 
 static void mmc_blk_rw_rq_prep(struct mmc_queue_req *mqrq,
diff -puN drivers/mmc/core/queue.c~linux-next-git-rejects drivers/mmc/core/queue.c
--- a/drivers/mmc/core/queue.c~linux-next-git-rejects
+++ a/drivers/mmc/core/queue.c
@@ -215,12 +215,6 @@ int mmc_init_queue(struct mmc_queue *mq,
 	struct mmc_host *host = card->host;
 	int ret = -ENOMEM;
 
-<<<<<<< HEAD
-	if (mmc_dev(host)->dma_mask && *mmc_dev(host)->dma_mask)
-		limit = (u64)dma_max_pfn(mmc_dev(host)) << PAGE_SHIFT;
-
-=======
->>>>>>> linux-next/akpm-base
 	mq->card = card;
 	mq->queue = blk_alloc_queue(GFP_KERNEL);
 	if (!mq->queue)
@@ -239,19 +233,6 @@ int mmc_init_queue(struct mmc_queue *mq,
 	}
 
 	blk_queue_prep_rq(mq->queue, mmc_prep_request);
-<<<<<<< HEAD
-	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, mq->queue);
-	queue_flag_clear_unlocked(QUEUE_FLAG_ADD_RANDOM, mq->queue);
-	if (mmc_can_erase(card))
-		mmc_queue_setup_discard(mq->queue, card);
-
-	blk_queue_bounce_limit(mq->queue, limit);
-	blk_queue_max_hw_sectors(mq->queue,
-		min(host->max_blk_count, host->max_req_size / 512));
-	blk_queue_max_segments(mq->queue, host->max_segs);
-	blk_queue_max_segment_size(mq->queue, host->max_seg_size);
-=======
->>>>>>> linux-next/akpm-base
 
 	mmc_setup_queue(mq, card);
 
diff -puN drivers/mmc/core/queue.h~linux-next-git-rejects drivers/mmc/core/queue.h
--- a/drivers/mmc/core/queue.h~linux-next-git-rejects
+++ a/drivers/mmc/core/queue.h
@@ -82,10 +82,5 @@ extern void mmc_queue_suspend(struct mmc
 extern void mmc_queue_resume(struct mmc_queue *);
 extern unsigned int mmc_queue_map_sg(struct mmc_queue *,
 				     struct mmc_queue_req *);
-<<<<<<< HEAD
-
-extern int mmc_access_rpmb(struct mmc_queue *);
-=======
->>>>>>> linux-next/akpm-base
 
 #endif
diff -puN drivers/tty/serial/fsl_lpuart.c~linux-next-git-rejects drivers/tty/serial/fsl_lpuart.c
--- a/drivers/tty/serial/fsl_lpuart.c~linux-next-git-rejects
+++ a/drivers/tty/serial/fsl_lpuart.c
@@ -2210,8 +2210,6 @@ static int lpuart_probe(struct platform_
 	ret = uart_add_one_port(&lpuart_reg, &sport->port);
 	if (ret)
 		goto failed_attach_port;
-<<<<<<< HEAD
-=======
 
 	of_get_rs485_mode(np, &sport->port.rs485);
 
@@ -2230,7 +2228,6 @@ static int lpuart_probe(struct platform_
 		sport->port.rs485.flags |= SER_RS485_RTS_ON_SEND;
 		writeb(UARTMODEM_TXRTSE, sport->port.membase + UARTMODEM);
 	}
->>>>>>> linux-next/akpm-base
 
 	sport->dma_tx_chan = dma_request_slave_channel(sport->port.dev, "tx");
 	if (!sport->dma_tx_chan)
diff -puN fs/btrfs/extent_io.c~linux-next-git-rejects fs/btrfs/extent_io.c
--- a/fs/btrfs/extent_io.c~linux-next-git-rejects
+++ a/fs/btrfs/extent_io.c
@@ -4056,11 +4056,7 @@ static void flush_epd_write_bio(struct e
 	if (epd->bio) {
 		int ret;
 
-<<<<<<< HEAD
-		ret = submit_one_bio(epd->bio, 0, epd->bio_flags);
-=======
 		ret = submit_one_bio(epd->bio, 0, 0);
->>>>>>> linux-next/akpm-base
 		BUG_ON(ret < 0); /* -ENOMEM */
 		epd->bio = NULL;
 	}
diff -puN include/linux/nmi.h~linux-next-git-rejects include/linux/nmi.h
--- a/include/linux/nmi.h~linux-next-git-rejects
+++ a/include/linux/nmi.h
@@ -109,13 +109,7 @@ static inline int hardlockup_detector_pe
 # endif
 #endif
 
-<<<<<<< HEAD
-void watchdog_nmi_stop(void);
-void watchdog_nmi_start(void);
-int watchdog_nmi_probe(void);
-=======
 void watchdog_nmi_reconfigure(bool run);
->>>>>>> linux-next/akpm-base
 
 /**
  * touch_nmi_watchdog - restart NMI watchdog timeout.
diff -puN kernel/smpboot.c~linux-next-git-rejects kernel/smpboot.c
--- a/kernel/smpboot.c~linux-next-git-rejects
+++ a/kernel/smpboot.c
@@ -351,11 +351,7 @@ void smpboot_update_cpumask_percpu_threa
 	static struct cpumask tmp;
 	unsigned int cpu;
 
-<<<<<<< HEAD
-	lockdep_assert_cpus_held();
-=======
 	get_online_cpus();
->>>>>>> linux-next/akpm-base
 	mutex_lock(&smpboot_threads_lock);
 
 	/* Park threads that were exclusively enabled on the old mask. */
@@ -371,10 +367,7 @@ void smpboot_update_cpumask_percpu_threa
 	cpumask_copy(old, new);
 
 	mutex_unlock(&smpboot_threads_lock);
-<<<<<<< HEAD
-=======
 	put_online_cpus();
->>>>>>> linux-next/akpm-base
 }
 
 static DEFINE_PER_CPU(atomic_t, cpu_hotplug_state) = ATOMIC_INIT(CPU_POST_DEAD);
diff -puN kernel/watchdog.c~linux-next-git-rejects kernel/watchdog.c
--- a/kernel/watchdog.c~linux-next-git-rejects
+++ a/kernel/watchdog.c
@@ -47,10 +47,7 @@ int __read_mostly watchdog_thresh = 10;
 int __read_mostly nmi_watchdog_available;
 
 struct cpumask watchdog_allowed_mask __read_mostly;
-<<<<<<< HEAD
-=======
 static bool softlockup_threads_initialized __read_mostly;
->>>>>>> linux-next/akpm-base
 
 struct cpumask watchdog_cpumask __read_mostly;
 unsigned long *watchdog_cpumask_bits = cpumask_bits(&watchdog_cpumask);
@@ -126,29 +123,6 @@ int __weak __init watchdog_nmi_probe(voi
 }
 
 /**
-<<<<<<< HEAD
- * watchdog_nmi_stop - Stop the watchdog for reconfiguration
- *
- * The reconfiguration steps are:
- * watchdog_nmi_stop();
- * update_variables();
- * watchdog_nmi_start();
- */
-void __weak watchdog_nmi_stop(void) { }
-
-/**
- * watchdog_nmi_start - Start the watchdog after reconfiguration
- *
- * Counterpart to watchdog_nmi_stop().
- *
- * The following variables have been updated in update_variables() and
- * contain the currently valid configuration:
- * - watchdog_enabled
- * - watchdog_thresh
- * - watchdog_cpumask
- */
-void __weak watchdog_nmi_start(void) { }
-=======
  * watchdog_nmi_reconfigure - Optional function to reconfigure NMI watchdogs
  * @run:	If false stop the watchdogs on all enabled CPUs
  *		If true start the watchdogs on all enabled CPUs
@@ -167,7 +141,6 @@ void __weak watchdog_nmi_start(void) { }
  * After the call the variables can be changed again.
  */
 void __weak watchdog_nmi_reconfigure(bool run) { }
->>>>>>> linux-next/akpm-base
 
 /**
  * lockup_detector_update_enable - Update the sysctl enable bit
@@ -554,14 +527,6 @@ static struct smp_hotplug_thread watchdo
 static void softlockup_update_smpboot_threads(void)
 {
 	lockdep_assert_held(&watchdog_mutex);
-<<<<<<< HEAD
-
-	if (!softlockup_threads_initialized)
-		return;
-
-	smpboot_update_cpumask_percpu_thread(&watchdog_threads,
-					     &watchdog_allowed_mask);
-=======
 
 	if (!softlockup_threads_initialized)
 		return;
@@ -569,7 +534,6 @@ static void softlockup_update_smpboot_th
 	smpboot_update_cpumask_percpu_thread(&watchdog_threads,
 					     &watchdog_allowed_mask);
 	__lockup_detector_cleanup();
->>>>>>> linux-next/akpm-base
 }
 
 /* Temporarily park all watchdog threads */
@@ -586,82 +550,14 @@ static void softlockup_unpark_threads(vo
 	softlockup_update_smpboot_threads();
 }
 
-<<<<<<< HEAD
-static void lockup_detector_reconfigure(void)
-{
-	cpus_read_lock();
-	watchdog_nmi_stop();
-=======
 static void softlockup_reconfigure_threads(void)
 {
 	watchdog_nmi_reconfigure(false);
->>>>>>> linux-next/akpm-base
 	softlockup_park_all_threads();
 	set_sample_period();
 	lockup_detector_update_enable();
 	if (watchdog_enabled && watchdog_thresh)
 		softlockup_unpark_threads();
-<<<<<<< HEAD
-	watchdog_nmi_start();
-	cpus_read_unlock();
-	/*
-	 * Must be called outside the cpus locked section to prevent
-	 * recursive locking in the perf code.
-	 */
-	__lockup_detector_cleanup();
-}
-
-/*
- * Create the watchdog thread infrastructure and configure the detector(s).
- *
- * The threads are not unparked as watchdog_allowed_mask is empty.  When
- * the threads are sucessfully initialized, take the proper locks and
- * unpark the threads in the watchdog_cpumask if the watchdog is enabled.
- */
-static __init void lockup_detector_setup(void)
-{
-	int ret;
-
-	/*
-	 * If sysctl is off and watchdog got disabled on the command line,
-	 * nothing to do here.
-	 */
-	lockup_detector_update_enable();
-
-	if (!IS_ENABLED(CONFIG_SYSCTL) &&
-	    !(watchdog_enabled && watchdog_thresh))
-		return;
-
-	ret = smpboot_register_percpu_thread_cpumask(&watchdog_threads,
-						     &watchdog_allowed_mask);
-	if (ret) {
-		pr_err("Failed to initialize soft lockup detector threads\n");
-		return;
-	}
-
-	mutex_lock(&watchdog_mutex);
-	softlockup_threads_initialized = true;
-	lockup_detector_reconfigure();
-	mutex_unlock(&watchdog_mutex);
-}
-
-#else /* CONFIG_SOFTLOCKUP_DETECTOR */
-static inline int watchdog_park_threads(void) { return 0; }
-static inline void watchdog_unpark_threads(void) { }
-static inline int watchdog_enable_all_cpus(void) { return 0; }
-static inline void watchdog_disable_all_cpus(void) { }
-static void lockup_detector_reconfigure(void)
-{
-	cpus_read_lock();
-	watchdog_nmi_stop();
-	lockup_detector_update_enable();
-	watchdog_nmi_start();
-	cpus_read_unlock();
-}
-static inline void lockup_detector_setup(void)
-{
-	lockup_detector_reconfigure();
-=======
 	watchdog_nmi_reconfigure(true);
 }
 
@@ -710,7 +606,6 @@ static void softlockup_reconfigure_threa
 	watchdog_nmi_reconfigure(false);
 	lockup_detector_update_enable();
 	watchdog_nmi_reconfigure(true);
->>>>>>> linux-next/akpm-base
 }
 #endif /* !CONFIG_SOFTLOCKUP_DETECTOR */
 
@@ -750,11 +645,7 @@ static void proc_watchdog_update(void)
 {
 	/* Remove impossible cpus to keep sysctl output clean. */
 	cpumask_and(&watchdog_cpumask, &watchdog_cpumask, cpu_possible_mask);
-<<<<<<< HEAD
-	lockup_detector_reconfigure();
-=======
 	softlockup_reconfigure_threads();
->>>>>>> linux-next/akpm-base
 }
 
 /*
@@ -773,15 +664,9 @@ static int proc_watchdog_common(int whic
 				void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int err, old, *param = table->data;
-<<<<<<< HEAD
-
-	mutex_lock(&watchdog_mutex);
-
-=======
 
 	mutex_lock(&watchdog_mutex);
 
->>>>>>> linux-next/akpm-base
 	if (!write) {
 		/*
 		 * On read synchronize the userspace interface. This is a
@@ -887,9 +772,5 @@ void __init lockup_detector_init(void)
 
 	if (!watchdog_nmi_probe())
 		nmi_watchdog_available = true;
-<<<<<<< HEAD
-	lockup_detector_setup();
-=======
 	softlockup_init_threads();
->>>>>>> linux-next/akpm-base
 }
diff -puN lib/kobject_uevent.c~linux-next-git-rejects lib/kobject_uevent.c
--- a/lib/kobject_uevent.c~linux-next-git-rejects
+++ a/lib/kobject_uevent.c
@@ -314,8 +314,6 @@ static void zap_modalias_env(struct kobj
 	}
 }
 
-<<<<<<< HEAD
-=======
 static int kobject_uevent_net_broadcast(struct kobject *kobj,
 					struct kobj_uevent_env *env,
 					const char *action_string,
@@ -365,7 +363,6 @@ static int kobject_uevent_net_broadcast(
 	return retval;
 }
 
->>>>>>> linux-next/akpm-base
 /**
  * kobject_uevent_env - send an uevent with environmental data
  *
diff -puN net/dsa/slave.c~linux-next-git-rejects net/dsa/slave.c
--- a/net/dsa/slave.c~linux-next-git-rejects
+++ a/net/dsa/slave.c
@@ -1188,11 +1188,7 @@ int dsa_slave_create(struct dsa_port *po
 	return 0;
 
 out_phy:
-<<<<<<< HEAD
-	phy_disconnect(p->phy);
-=======
 	phy_disconnect(slave_dev->phydev);
->>>>>>> linux-next/akpm-base
 	if (of_phy_is_fixed_link(p->dp->dn))
 		of_phy_deregister_fixed_link(p->dp->dn);
 out_free:
diff -puN tools/include/uapi/linux/bpf.h~linux-next-git-rejects tools/include/uapi/linux/bpf.h
--- a/tools/include/uapi/linux/bpf.h~linux-next-git-rejects
+++ a/tools/include/uapi/linux/bpf.h
@@ -644,10 +644,7 @@ union bpf_attr {
 	FN(redirect_map),		\
 	FN(sk_redirect_map),		\
 	FN(sock_map_update),		\
-<<<<<<< HEAD
-=======
 	FN(xdp_adjust_meta),
->>>>>>> linux-next/akpm-base
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
of-provide-of_n_addrsize_cells-wrappers-for-config_of-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-sysctl-make-numa-stats-configurable-fix.patch
mm-sysctl-make-numa-stats-configurable-fix-fix.patch
mm-mmu_notifier-avoid-double-notification-when-it-is-useless-checkpatch-fixes.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch
pid-replace-pid-bitmap-implementation-with-idr-api-checkpatch-fixes.patch
pid-remove-pidhash-checkpatch-fixes.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

