From: akpm@linux-foundation.org
Subject: - sched-add-debug-checks-to-idle-functions.patch removed from -mm tree
Date: Thu, 01 May 2008 02:34:03 -0700
Message-ID: <200805010934.m419Y3wQ031182@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33916 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758140AbYEAJeP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:34:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, justinmattock@gmail.com, mingo@elte.hu, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     sched: add debug checks to idle functions
has been removed from the -mm tree.  Its filename was
     sched-add-debug-checks-to-idle-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sched: add debug checks to idle functions
From: Andrew Morton <akpm@linux-foundation.org>

cpuidle might be calling these with local interrupts enabled.

Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Justin Mattock" <justinmattock@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/sched.c~sched-add-debug-checks-to-idle-functions kernel/sched.c
--- a/kernel/sched.c~sched-add-debug-checks-to-idle-functions
+++ a/kernel/sched.c
@@ -1150,6 +1150,7 @@ void sched_clock_idle_sleep_event(void)
 {
 	struct rq *rq = cpu_rq(smp_processor_id());
 
+	WARN_ON(!irqs_disabled());
 	spin_lock(&rq->lock);
 	__update_rq_clock(rq);
 	spin_unlock(&rq->lock);
@@ -1165,6 +1166,7 @@ void sched_clock_idle_wakeup_event(u64 d
 	struct rq *rq = cpu_rq(smp_processor_id());
 	u64 now = sched_clock();
 
+	WARN_ON(!irqs_disabled());
 	rq->idle_clock += delta_ns;
 	/*
 	 * Override the previous timestamp and ignore all
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
revert-memory-hotplug-register-section-node-id-to-free.patch
pci-export-resource_wc-in-pci-sysfs-fix.patch
disable-the-memory-controller-by-default-v3.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
pnp-fix-printk-format-warnings-fix-checkpatch-fixes.patch
git-x86-fixup.patch
rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline-cleanup.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
git-dvb.patch
i2c-renesas-highlander-fpga-smbus-support.patch
git-hwmon.patch
touch-screen-driver-for-the-superh-migor-board.patch
git-kvm.patch
pata_atiixp-simplex-clear.patch
git-m32r.patch
git-mips.patch
git-mips-git-rejects.patch
git-mmc.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
power_supply-bump-ec-version-check-that-we-refuse-to-run-with-in-olpc_battery-checkpatch-fixes.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
git-sched.patch
drivers-base-topologyc-add-conditionals-around-show_cpumap.patch
add-rcu_assign_index-if-ever-needed.patch
git-scsi-misc.patch
scsi-fix-section-mismatch-in-aic94xx.patch
drivers-scsi-mvsasc-fix-build-warnings.patch
aic79xx_core-remove-ascii-art.patch
sparc32-export-empty_zero_page.patch
git-unionfs.patch
git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch
ext4-is-busted-on-m68k.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
add-warn_on_secs-macro.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
sxc-fix-printk-warnings-on-sparc32.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
x86-ioremap-add-checks-for-virtual-addresses-fix.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

