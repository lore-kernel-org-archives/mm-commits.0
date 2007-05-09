From: akpm@linux-foundation.org
Subject: - gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed-powerpc-fixes.patch removed from -mm tree
Date: Tue, 08 May 2007 22:40:09 -0600
Message-ID: <200705090440.l494eBUT014564@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59809 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754410AbXEIEkm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 00:40:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, greg@kroah.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed powerpc fixes
has been removed from the -mm tree.  Its filename was
     gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed-powerpc-fixes.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed powerpc fixes
From: Andrew Morton <akpm@linux-foundation.org>

Might be wrong.

Cc: Greg KH <greg@kroah.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/pseries/power.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff -puN arch/powerpc/platforms/pseries/power.c~gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed-powerpc-fixes arch/powerpc/platforms/pseries/power.c
--- a/arch/powerpc/platforms/pseries/power.c~gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed-powerpc-fixes
+++ a/arch/powerpc/platforms/pseries/power.c
@@ -28,13 +28,13 @@
 
 unsigned long rtas_poweron_auto; /* default and normal state is 0 */
 
-static ssize_t auto_poweron_show(struct kset *kset, char *buf)
+static ssize_t auto_poweron_show(struct subsystem *subsys, char *buf)
 {
         return sprintf(buf, "%lu\n", rtas_poweron_auto);
 }
 
 static ssize_t
-auto_poweron_store(struct kset *kset, const char *buf, size_t n)
+auto_poweron_store(struct subsystem *subsys, const char *buf, size_t n)
 {
 	int ret;
 	unsigned long ups_restart;
@@ -72,7 +72,8 @@ static int __init pm_init(void)
 {
         int error = subsystem_register(&power_subsys);
         if (!error)
-                error = sysfs_create_group(&power_subsys.kobj, &attr_group);
+                error = sysfs_create_group(&power_subsys.kset.kobj,
+					&attr_group);
         return error;
 }
 core_initcall(pm_init);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
git-avr32.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed-powerpc-fixes.patch
cinergyt2-fix-file-release-handler.patch
git-hid-fixup.patch
sn-validate-smp_affinity-mask-on-intr-redirect-fix.patch
sn-validate-smp_affinity-mask-on-intr-redirect-fix-2.patch
git-ieee1394.patch
sbp2-include-fixes.patch
ieee1394-iso-needs-schedh.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
git-mtd.patch
git-e1000.patch
git-e1000-fixup-2.patch
git-battery-fix.patch
git-parisc.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
git-scsi-misc.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
git-unionfs.patch
auerswald-fix-file-release-handler.patch
git-watchdog.patch
git-wireless.patch
git-wireless-fixup.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
i386-add-support-for-picopower-irq-router-fix.patch
xfs-clean-up-shrinker-games.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
swsusp-clean-up-print.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount.patch
upper-32-bits.patch
lib-hexdump-fix.patch
pasemi-hardware-rng-driver-tidy.patch
nbd-check-the-return-value-of-sysfs_create_file-fix.patch
mutex_lock_interruptible-add-__must_check.patch
mutex_lock_interruptible-add-__must_check-must-fix.patch
afs-implement-basic-file-write-support-fix.patch
tty-add-compat_ioctl-fix.patch
blacklist-dell-optiplex-320-from-using-the-hpet-fix.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
kthread-dont-depend-on-work-queues-take-2.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
make-cancel_rearming_delayed_work-reliable-spelling.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
linux-kernel-markers-i386-optimization.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-fds-v9-timerfd-core.patch
signal-timer-event-fds-v9-eventfd-core.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-wire-up-i386-system-calls.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
fs-convert-core-functions-to-zero_user_page-pass-kmap-type.patch
fs-convert-core-functions-to-zero_user_page-fix-2.patch
ntfs-use-zero_user_page-fix.patch
make-vm-statistics-update-interval-configurable-fix.patch
rename-thread_info-to-stack-fix.patch
reiser4-slab-allocators-remove-slab_debug_initial-flag.patch
integrity-new-hooks-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
w1-build-fix.patch
