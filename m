From: akpm@linux-foundation.org
Subject: [obsolete] kernel-smpc-relocate-some-code.patch removed from -mm tree
Date: Thu, 30 Jul 2009 17:14:04 -0700
Message-ID: <200907310014.n6V0E4c2006789@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51853 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753146AbZGaAOp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 20:14:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jens.axboe@oracle.com, mingo@elte.hu, nickpiggin@yahoo.com.au, peterz@infradead.org, rusty@rustcorp.com.au, xiaoguangrong@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     kernel/smp.c: relocate some code
has been removed from the -mm tree.  Its filename was
     kernel-smpc-relocate-some-code.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/smp.c: relocate some code
From: Andrew Morton <akpm@linux-foundation.org>

Move hotplug_cfd() to the end of the file so that we can see what changes
the next patch (generic-ipi: fix the race between
generic_smp_call_function_*() and hotplug_cfd()) actually makes to that
function.

Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smp.c |  102 ++++++++++++++++++++++++-------------------------
 1 file changed, 51 insertions(+), 51 deletions(-)

diff -puN kernel/smp.c~kernel-smpc-relocate-some-code kernel/smp.c
--- a/kernel/smp.c~kernel-smpc-relocate-some-code
+++ a/kernel/smp.c
@@ -40,57 +40,6 @@ struct call_single_queue {
 
 static DEFINE_PER_CPU(struct call_function_data, cfd_data);
 
-static int
-hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
-{
-	long cpu = (long)hcpu;
-	struct call_function_data *cfd = &per_cpu(cfd_data, cpu);
-
-	switch (action) {
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
-		if (!zalloc_cpumask_var_node(&cfd->cpumask, GFP_KERNEL,
-				cpu_to_node(cpu)))
-			return NOTIFY_BAD;
-		break;
-
-#ifdef CONFIG_HOTPLUG_CPU
-	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
-
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
-		free_cpumask_var(cfd->cpumask);
-		break;
-#endif
-	};
-
-	return NOTIFY_OK;
-}
-
-static struct notifier_block __cpuinitdata hotplug_cfd_notifier = {
-	.notifier_call		= hotplug_cfd,
-};
-
-static int __cpuinit init_call_single_data(void)
-{
-	void *cpu = (void *)(long)smp_processor_id();
-	int i;
-
-	for_each_possible_cpu(i) {
-		struct call_single_queue *q = &per_cpu(call_single_queue, i);
-
-		spin_lock_init(&q->lock);
-		INIT_LIST_HEAD(&q->list);
-	}
-
-	hotplug_cfd(&hotplug_cfd_notifier, CPU_UP_PREPARE, cpu);
-	register_cpu_notifier(&hotplug_cfd_notifier);
-
-	return 0;
-}
-early_initcall(init_call_single_data);
-
 /*
  * csd_lock/csd_unlock used to serialize access to per-cpu csd resources
  *
@@ -489,3 +438,54 @@ void ipi_call_unlock_irq(void)
 {
 	spin_unlock_irq(&call_function.lock);
 }
+
+static int
+hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
+{
+	long cpu = (long)hcpu;
+	struct call_function_data *cfd = &per_cpu(cfd_data, cpu);
+
+	switch (action) {
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		if (!zalloc_cpumask_var_node(&cfd->cpumask, GFP_KERNEL,
+				cpu_to_node(cpu)))
+			return NOTIFY_BAD;
+		break;
+
+#ifdef CONFIG_HOTPLUG_CPU
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
+
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		free_cpumask_var(cfd->cpumask);
+		break;
+#endif
+	};
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block __cpuinitdata hotplug_cfd_notifier = {
+	.notifier_call		= hotplug_cfd,
+};
+
+static int __cpuinit init_call_single_data(void)
+{
+	void *cpu = (void *)(long)smp_processor_id();
+	int i;
+
+	for_each_possible_cpu(i) {
+		struct call_single_queue *q = &per_cpu(call_single_queue, i);
+
+		spin_lock_init(&q->lock);
+		INIT_LIST_HEAD(&q->list);
+	}
+
+	hotplug_cfd(&hotplug_cfd_notifier, CPU_UP_PREPARE, cpu);
+	register_cpu_notifier(&hotplug_cfd_notifier);
+
+	return 0;
+}
+early_initcall(init_call_single_data);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-pty-rework-the-pty-layer-to-use-the-normal-buffering-logic.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
arch-x86-kernel-tscc-smi-workaround-for-pit_expect_msb-checkpatch-fixes.patch
x86-add-reboot-fixup-for-compulab-sbc-fitpc2-board-cleanup.patch
platform_device_add_data-use-kmemdup.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
leds-gpio-leds-fix-typographics-fault-checkpatch-fixes.patch
leds-fix-coding-style-in-worker-thread-code-for-ledtrig-gpio-checkpatch-fixes.patch
proc-connector-add-event-for-process-becoming-session-leader.patch
3x59x-fix-pci-resource-management-checkpatch-fixes.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse-fix.patch
scsi-make-scsi-sg-v4-driver-enabled-by-default-and-remove-experimental-dependency-since-udev-depends-on-bsg-checkpatch-fixes.patch
drivers-usb-gadget-s3c2410_udcc-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
fs-fix-overflow-in-sys_mount-for-in-kernel-calls-fix.patch
vfs-optimize-touch_time-too-fix.patch
watchdog-add-sbc-fitpc2-watchdog-driver-fix.patch
mm-make-set_mempolicympol_interleav-n_high_memory-aware-fix.patch
revert-mm-prevent-balance_dirty_pages-from-doing-too-much-work.patch
arch-x86-oprofile-op_model_amdc-fix-op_amd_handle_ibs-return-type.patch
include-linux-clocksourceh-coding-style-tweaks.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
memory-hotplug-update-zone-pcp-at-memory-online-fix.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
ummunotify-userspace-support-for-mmu-notifications-cleanup.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch
generic-ipi-make-struct-call_function_data-lockless-cleanup.patch
kernel-smpc-relocate-some-code.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix-fix.patch
rtc-philips-nxp-pcf2123-driver-v03-fix.patch
kernel-irq-export-symbols-needed-by-gpio-add-intel-moorestown-platform-langwell-chip-gpio-driverpatch.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4-cleanup.patch
v3-minixfs-add-missing-directory-type-checking-checkpatch-fixes.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch-fixes.patch
exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9-checkpatch-fixes.patch
elf-clean-up-fill_note_info-fix.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

