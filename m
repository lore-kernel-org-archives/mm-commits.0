From: akpm@linux-foundation.org
Subject: - revert-clockevents-fix-resume-logic.patch removed from -mm tree
Date: Mon, 12 Nov 2007 22:12:26 -0800
Message-ID: <200711130619.lAD6JNZm029678@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48185 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750699AbXKMGU6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Nov 2007 01:20:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, johnstul@us.ibm.com, mingo@elte.hu, rjw@sisk.pl, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     revert "clockevents: fix resume logic"
has been removed from the -mm tree.  Its filename was
     revert-clockevents-fix-resume-logic.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: revert "clockevents: fix resume logic"
From: Andrew Morton <akpm@linux-foundation.org>

Revert:

commit 18de5bc4c1f1f1fa5e14f354a7603bd6e9d4e3b6
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Sat Jul 21 04:37:34 2007 -0700

    clockevents: fix resume logic
    
    We need to make sure, that the clockevent devices are resumed, before
    the tick is resumed. The current resume logic does not guarantee this.
    
    Add CLOCK_EVT_MODE_RESUME and call the set mode functions of the clock
    event devices before resuming the tick / oneshot functionality.
    
    Fixup the existing users.
    
    Thanks to Nigel Cunningham for tracking down a long standing thinko,
    which affected the jinxed VAIO.


It causes the following on the Vaio:

- resume-from-ram gets stuck and requires repeated hitting of a key for it
  to make progress

- `reboot -f' fails in the same way, with the same fix

- the system time after resume is wrong: it is behind the hwclock time by a
  period which appears to be equal to the time spent in suspend


Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-davinci/time.c      |    2 
 arch/arm/mach-imx/time.c          |    1 
 arch/arm/mach-ixp4xx/common.c     |    2 
 arch/arm/mach-omap1/time.c        |    1 
 arch/arm/plat-omap/timer32k.c     |    2 
 arch/i386/kernel/apic.c           |    3 -
 arch/i386/kernel/hpet.c           |   71 ++++++++++++++++++++++++++--
 arch/i386/kernel/i8253.c          |   29 +++++------
 arch/i386/kernel/vmiclock.c       |    1 
 arch/i386/xen/time.c              |    3 -
 arch/sh/kernel/timers/timer-tmu.c |    1 
 arch/sparc64/kernel/time.c        |    1 
 drivers/lguest/lguest.c           |    2 
 include/linux/clockchips.h        |    1 
 kernel/time/tick-broadcast.c      |    6 --
 kernel/time/tick-common.c         |   16 ++----
 16 files changed, 88 insertions(+), 54 deletions(-)

diff -puN arch/arm/mach-davinci/time.c~a arch/arm/mach-davinci/time.c
--- a/arch/arm/mach-davinci/time.c~a
+++ a/arch/arm/mach-davinci/time.c
@@ -285,8 +285,6 @@ static void davinci_set_mode(enum clock_
 	case CLOCK_EVT_MODE_SHUTDOWN:
 		t->opts = TIMER_OPTS_DISABLED;
 		break;
-	case CLOCK_EVT_MODE_RESUME:
-		break;
 	}
 }
 
diff -puN arch/arm/mach-imx/time.c~a arch/arm/mach-imx/time.c
--- a/arch/arm/mach-imx/time.c~a
+++ a/arch/arm/mach-imx/time.c
@@ -159,7 +159,6 @@ static void imx_set_mode(enum clock_even
 		break;
 	case CLOCK_EVT_MODE_SHUTDOWN:
 	case CLOCK_EVT_MODE_UNUSED:
-	case CLOCK_EVT_MODE_RESUME:
 		/* Left event sources disabled, no more interrupts appears */
 		break;
 	}
diff -puN arch/arm/mach-ixp4xx/common.c~a arch/arm/mach-ixp4xx/common.c
--- a/arch/arm/mach-ixp4xx/common.c~a
+++ a/arch/arm/mach-ixp4xx/common.c
@@ -459,8 +459,6 @@ static void ixp4xx_set_mode(enum clock_e
 	default:
 		osrt = opts = 0;
 		break;
-	case CLOCK_EVT_MODE_RESUME:
-		break;
 	}
 
 	*IXP4XX_OSRT1 = osrt | opts;
diff -puN arch/arm/mach-omap1/time.c~a arch/arm/mach-omap1/time.c
--- a/arch/arm/mach-omap1/time.c~a
+++ a/arch/arm/mach-omap1/time.c
@@ -156,7 +156,6 @@ static void omap_mpu_set_mode(enum clock
 		break;
 	case CLOCK_EVT_MODE_UNUSED:
 	case CLOCK_EVT_MODE_SHUTDOWN:
-	case CLOCK_EVT_MODE_RESUME:
 		break;
 	}
 }
diff -puN arch/arm/plat-omap/timer32k.c~a arch/arm/plat-omap/timer32k.c
--- a/arch/arm/plat-omap/timer32k.c~a
+++ a/arch/arm/plat-omap/timer32k.c
@@ -157,8 +157,6 @@ static void omap_32k_timer_set_mode(enum
 	case CLOCK_EVT_MODE_UNUSED:
 	case CLOCK_EVT_MODE_SHUTDOWN:
 		break;
-	case CLOCK_EVT_MODE_RESUME:
-		break;
 	}
 }
 
diff -puN arch/i386/kernel/apic.c~a arch/i386/kernel/apic.c
--- a/arch/x86/kernel/apic_32.c~a
+++ a/arch/x86/kernel/apic_32.c
@@ -264,9 +264,6 @@ static void lapic_timer_setup(enum clock
 		v |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
 		apic_write_around(APIC_LVTT, v);
 		break;
-	case CLOCK_EVT_MODE_RESUME:
-		/* Nothing to do here */
-		break;
 	}
 
 	local_irq_restore(flags);
diff -puN arch/i386/kernel/hpet.c~a arch/i386/kernel/hpet.c
--- a/arch/x86/kernel/hpet_32.c~a
+++ a/arch/x86/kernel/hpet_32.c
@@ -188,10 +188,6 @@ static void hpet_set_mode(enum clock_eve
 		cfg &= ~HPET_TN_ENABLE;
 		hpet_writel(cfg, HPET_T0_CFG);
 		break;
-
-	case CLOCK_EVT_MODE_RESUME:
-		hpet_enable_int();
-		break;
 	}
 }
 
@@ -222,7 +218,6 @@ static struct clocksource clocksource_hp
 	.mask		= HPET_MASK,
 	.shift		= HPET_SHIFT,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
-	.resume		= hpet_start_counter,
 };
 
 /*
@@ -319,6 +314,7 @@ int __init hpet_enable(void)
 
 	clocksource_register(&clocksource_hpet);
 
+
 	if (id & HPET_ID_LEGSUP) {
 		hpet_enable_int();
 		hpet_reserve_platform_timers(id);
@@ -551,3 +547,68 @@ irqreturn_t hpet_rtc_interrupt(int irq, 
 	return IRQ_HANDLED;
 }
 #endif
+
+
+/*
+ * Suspend/resume part
+ */
+
+#ifdef CONFIG_PM
+
+static int hpet_suspend(struct sys_device *sys_device, pm_message_t state)
+{
+	unsigned long cfg = hpet_readl(HPET_CFG);
+
+	cfg &= ~(HPET_CFG_ENABLE|HPET_CFG_LEGACY);
+	hpet_writel(cfg, HPET_CFG);
+
+	return 0;
+}
+
+static int hpet_resume(struct sys_device *sys_device)
+{
+	unsigned int id;
+
+	hpet_start_counter();
+
+	id = hpet_readl(HPET_ID);
+
+	if (id & HPET_ID_LEGSUP)
+		hpet_enable_int();
+
+	return 0;
+}
+
+static struct sysdev_class hpet_class = {
+	set_kset_name("hpet"),
+	.suspend	= hpet_suspend,
+	.resume		= hpet_resume,
+};
+
+static struct sys_device hpet_device = {
+	.id		= 0,
+	.cls		= &hpet_class,
+};
+
+
+static __init int hpet_register_sysfs(void)
+{
+	int err;
+
+	if (!is_hpet_capable())
+		return 0;
+
+	err = sysdev_class_register(&hpet_class);
+
+	if (!err) {
+		err = sysdev_register(&hpet_device);
+		if (err)
+			sysdev_class_unregister(&hpet_class);
+	}
+
+	return err;
+}
+
+device_initcall(hpet_register_sysfs);
+
+#endif
diff -puN arch/i386/kernel/i8253.c~a arch/i386/kernel/i8253.c
--- a/arch/x86/kernel/i8253_32.c~a
+++ a/arch/x86/kernel/i8253_32.c
@@ -3,11 +3,11 @@
  *
  */
 #include <linux/clockchips.h>
-#include <linux/init.h>
-#include <linux/interrupt.h>
+#include <linux/spinlock.h>
 #include <linux/jiffies.h>
+#include <linux/sysdev.h>
 #include <linux/module.h>
-#include <linux/spinlock.h>
+#include <linux/init.h>
 
 #include <asm/smp.h>
 #include <asm/delay.h>
@@ -40,27 +40,26 @@ static void init_pit_timer(enum clock_ev
 	case CLOCK_EVT_MODE_PERIODIC:
 		/* binary, mode 2, LSB/MSB, ch 0 */
 		outb_p(0x34, PIT_MODE);
+		udelay(10);
 		outb_p(LATCH & 0xff , PIT_CH0);	/* LSB */
+		udelay(10);
 		outb(LATCH >> 8 , PIT_CH0);	/* MSB */
 		break;
 
+	/*
+	 * Avoid unnecessary state transitions, as it confuses
+	 * Geode / Cyrix based boxen.
+	 */
 	case CLOCK_EVT_MODE_SHUTDOWN:
+		if (evt->mode == CLOCK_EVT_MODE_UNUSED)
+			break;
 	case CLOCK_EVT_MODE_UNUSED:
-		if (evt->mode == CLOCK_EVT_MODE_PERIODIC ||
-		    evt->mode == CLOCK_EVT_MODE_ONESHOT) {
-			outb_p(0x30, PIT_MODE);
-			outb_p(0, PIT_CH0);
-			outb_p(0, PIT_CH0);
-		}
-		break;
-
+		if (evt->mode == CLOCK_EVT_MODE_SHUTDOWN)
+			break;
 	case CLOCK_EVT_MODE_ONESHOT:
 		/* One shot setup */
 		outb_p(0x38, PIT_MODE);
-		break;
-
-	case CLOCK_EVT_MODE_RESUME:
-		/* Nothing to do here */
+		udelay(10);
 		break;
 	}
 	spin_unlock_irqrestore(&i8253_lock, flags);
diff -puN arch/i386/kernel/vmiclock.c~a arch/i386/kernel/vmiclock.c
--- a/arch/x86/kernel/vmiclock_32.c~a
+++ a/arch/x86/kernel/vmiclock_32.c
@@ -143,7 +143,6 @@ static void vmi_timer_set_mode(enum cloc
 
 	switch (mode) {
 	case CLOCK_EVT_MODE_ONESHOT:
-	case CLOCK_EVT_MODE_RESUME:
 		break;
 	case CLOCK_EVT_MODE_PERIODIC:
 		cycles_per_hz = vmi_timer_ops.get_cycle_frequency();
diff -puN arch/i386/xen/time.c~a arch/i386/xen/time.c
--- a/arch/x86/xen/time.c~a
+++ a/arch/x86/xen/time.c
@@ -412,7 +412,6 @@ static void xen_timerop_set_mode(enum cl
 		break;
 
 	case CLOCK_EVT_MODE_ONESHOT:
-	case CLOCK_EVT_MODE_RESUME:
 		break;
 
 	case CLOCK_EVT_MODE_UNUSED:
@@ -475,8 +474,6 @@ static void xen_vcpuop_set_mode(enum clo
 		    HYPERVISOR_vcpu_op(VCPUOP_stop_periodic_timer, cpu, NULL))
 			BUG();
 		break;
-	case CLOCK_EVT_MODE_RESUME:
-		break;
 	}
 }
 
diff -puN arch/sh/kernel/timers/timer-tmu.c~a arch/sh/kernel/timers/timer-tmu.c
--- a/arch/sh/kernel/timers/timer-tmu.c~a
+++ a/arch/sh/kernel/timers/timer-tmu.c
@@ -80,7 +80,6 @@ static void tmu_set_mode(enum clock_even
 		break;
 	case CLOCK_EVT_MODE_UNUSED:
 	case CLOCK_EVT_MODE_SHUTDOWN:
-	case CLOCK_EVT_MODE_RESUME:
 		break;
 	}
 }
diff -puN arch/sparc64/kernel/time.c~a arch/sparc64/kernel/time.c
--- a/arch/sparc64/kernel/time.c~a
+++ a/arch/sparc64/kernel/time.c
@@ -882,7 +882,6 @@ static void sparc64_timer_setup(enum clo
 {
 	switch (mode) {
 	case CLOCK_EVT_MODE_ONESHOT:
-	case CLOCK_EVT_MODE_RESUME:
 		break;
 
 	case CLOCK_EVT_MODE_SHUTDOWN:
diff -puN drivers/lguest/lguest.c~a drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c~a
+++ a/drivers/lguest/lguest.c
@@ -730,8 +730,6 @@ static void lguest_clockevent_set_mode(e
 		break;
 	case CLOCK_EVT_MODE_PERIODIC:
 		BUG();
-	case CLOCK_EVT_MODE_RESUME:
-		break;
 	}
 }
 
diff -puN include/linux/clockchips.h~a include/linux/clockchips.h
--- a/include/linux/clockchips.h~a
+++ a/include/linux/clockchips.h
@@ -23,7 +23,6 @@ enum clock_event_mode {
 	CLOCK_EVT_MODE_SHUTDOWN,
 	CLOCK_EVT_MODE_PERIODIC,
 	CLOCK_EVT_MODE_ONESHOT,
-	CLOCK_EVT_MODE_RESUME,
 };
 
 /* Clock event notification values */
diff -puN kernel/time/tick-broadcast.c~a kernel/time/tick-broadcast.c
--- a/kernel/time/tick-broadcast.c~a
+++ a/kernel/time/tick-broadcast.c
@@ -55,7 +55,7 @@ cpumask_t *tick_get_broadcast_mask(void)
  */
 static void tick_broadcast_start_periodic(struct clock_event_device *bc)
 {
-	if (bc)
+	if (bc && bc->mode == CLOCK_EVT_MODE_SHUTDOWN)
 		tick_setup_periodic(bc, 1);
 }
 
@@ -316,7 +316,7 @@ void tick_suspend_broadcast(void)
 	spin_lock_irqsave(&tick_broadcast_lock, flags);
 
 	bc = tick_broadcast_device.evtdev;
-	if (bc)
+	if (bc && tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC)
 		clockevents_set_mode(bc, CLOCK_EVT_MODE_SHUTDOWN);
 
 	spin_unlock_irqrestore(&tick_broadcast_lock, flags);
@@ -333,8 +333,6 @@ int tick_resume_broadcast(void)
 	bc = tick_broadcast_device.evtdev;
 
 	if (bc) {
-		clockevents_set_mode(bc, CLOCK_EVT_MODE_RESUME);
-
 		switch (tick_broadcast_device.mode) {
 		case TICKDEV_MODE_PERIODIC:
 			if(!cpus_empty(tick_broadcast_mask))
diff -puN kernel/time/tick-common.c~a kernel/time/tick-common.c
--- a/kernel/time/tick-common.c~a
+++ a/kernel/time/tick-common.c
@@ -318,17 +318,12 @@ static void tick_resume(void)
 {
 	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
 	unsigned long flags;
-	int broadcast = tick_resume_broadcast();
 
 	spin_lock_irqsave(&tick_device_lock, flags);
-	clockevents_set_mode(td->evtdev, CLOCK_EVT_MODE_RESUME);
-
-	if (!broadcast) {
-		if (td->mode == TICKDEV_MODE_PERIODIC)
-			tick_setup_periodic(td->evtdev, 0);
-		else
-			tick_resume_oneshot();
-	}
+	if (td->mode == TICKDEV_MODE_PERIODIC)
+		tick_setup_periodic(td->evtdev, 0);
+	else
+		tick_resume_oneshot();
 	spin_unlock_irqrestore(&tick_device_lock, flags);
 }
 
@@ -365,7 +360,8 @@ static int tick_notify(struct notifier_b
 		break;
 
 	case CLOCK_EVT_NOTIFY_RESUME:
-		tick_resume();
+		if (!tick_resume_broadcast())
+			tick_resume();
 		break;
 
 	default:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
uml-update-address-space-affected-by-pud_clear-checkpatch-fixes.patch
improve-cgroup-printks-fix.patch
proc-fix-proc_kill_inodes-to-kill-dentries-on-all-proc-superblocks-checkpatch-fixes.patch
acpi-make-acpi_procfs-default-to-y.patch
get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components-checkpatch-fixes.patch
revert-task-control-groups-example-cpu-accounting-subsystem.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200-fix.patch
acpi-add-reboot-mechanism.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm.patch
agk-dm-dm-ioctl-move-compat-code-fix.patch
unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc.patch
unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc-fix.patch
git-dvb.patch
git-hwmon.patch
ia64-slim-down-__clear_bit_unlock-checkpatch-fixes.patch
elantech-touchpad-driver-fix.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-detect-checkpatch-fixes.patch
ide-arm-hack.patch
git-mmc.patch
git-mtd.patch
lmc_ioctl-dont-return-with-locks-held-fix.patch
git-netdev-all.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
bluetooth-uninlining.patch
nfs-stop-sillyname-renames-and-unmounts-from-racing-checkpatch-fixes.patch
git-nfsd-fixup.patch
quirk_vialatency-omit-reading-pci-revision-id-checkpatch-fixes.patch
git-s390.patch
fix-build-breakage-if-sysfs-fix.patch
ips-trim-trailing-whitespace-checkpatch-fixes.patch
scsi-gdth-kill-unneeded-irq-argument-checkpatch-fixes.patch
scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers-checkpatch-fixes.patch
bidi-support-scsi_data_buffer-broke-qla1280.patch
git-unionfs.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
git-wireless.patch
jiffies_round-jiffies_round_relative-conversion-rt2x00-checkpatch-fixes.patch
git-ipwireless_cs.patch
git-x86.patch
git-x86-broke-lguest.patch
git-x86-broke-xen-too.patch
git-x86-inlining-borkage.patch
oprofile-op_model_athalonc-support-for-amd-family10h-barcelona-performance-counters-checkpatch-fixes.patch
i386-and-x86_64-randomize-brk-fix.patch
x86-arch_register_cpu-section-fix.patch
mips-undo-locking-on-error-path-returns-checkpatch-fixes.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
fix-64kb-blocksize-in-ext3-directories-checkpatch-fixes.patch
file-capabilities-allow-sigcont-within-session-v2-checkpatch-fixes.patch
x86-disable-preemption-in-delay_tsc.patch
tty-fix-network-driver-interactions-with-tcget-set-checkpatch-fixes.patch
x86-early_quirks-cleanup.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix-2.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
revert-capabilities-clean-up-file-capability-reading.patch
revert-capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
cris-build-fixes-atomich-needs-compilerh-fix.patch
cris-build-fixes-update-eth_v10c-ethernet-driver-fix.patch
cris-build-fixes-fixes-in-arch-cris-kernel-timec-checkpatch-fixes.patch
cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two-checkpatch-fixes.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-improve-detection-of-host-cmov-checkpatch-fixes.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
procfs-detect-duplicate-names.patch
kernel-printkc-concerns-about-the-console-handover.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
pie-executable-randomization.patch
pie-executable-randomization-uninlining.patch
pie-executable-randomization-checkpatch-fixes.patch
riscom8-fix-smp-brokenness-fix.patch
use-macros-instead-of-task_-flags-checkpatch-fixes.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
remove-warnings-for-longstanding-conditions-fix.patch
parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch
remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
allow-auto-destruction-of-loop-devices-checkpatch-fixes.patch
remove-__attribute_used__-checkpatch-fixes.patch
read_current_time-cleanups.patch
sync_sb_inodes-propagate-errors.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
64-bit-i_version-afs-fixes.patch
ridiculous-ext3-costs-was-re-page-fault-costs.patch
kill-filp_open-checkpatch-fixes.patch
rename-open_namei-to-open_pathname-fix.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly-checkpatch-fixes.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
cgroup-simplify-space-stripping-fix.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch
memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
one-less-parameter-to-__d_path-checkpatch-fixes.patch
d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
suppress-aout-library-support-if-config_binfmt_aout-checkpatch-fixes.patch
usb-net2280-cant-have-a-function-called-checkpatch-fixes.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
w1-build-fix.patch
