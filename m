From: akpm@linux-foundation.org
Subject: + sn-validate-smp_affinity-mask-on-intr-redirect-fix-2.patch added to -mm tree
Date: Tue, 08 May 2007 13:34:38 -0700
Message-ID: <200705082034.l48KYcCQ000719@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966442AbXEHUel (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 16:34:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jpk@sgi.com, tony.luck@intel.com


The patch titled
     sn-validate-smp_affinity-mask-on-intr-redirect-fix-2
has been added to the -mm tree.  Its filename is
     sn-validate-smp_affinity-mask-on-intr-redirect-fix-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sn-validate-smp_affinity-mask-on-intr-redirect-fix-2
From: Andrew Morton <akpm@linux-foundation.org>

Cc: John Keller <jpk@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-ia64/irq.h |    4 ++++
 1 files changed, 4 insertions(+)

diff -puN include/asm-ia64/irq.h~sn-validate-smp_affinity-mask-on-intr-redirect-fix-2 include/asm-ia64/irq.h
--- a/include/asm-ia64/irq.h~sn-validate-smp_affinity-mask-on-intr-redirect-fix-2
+++ a/include/asm-ia64/irq.h
@@ -11,6 +11,9 @@
  * 02/29/00     D.Mosberger	moved most things into hw_irq.h
  */
 
+#include <linux/types.h>
+#include <linux/cpumask.h>
+
 #define NR_IRQS		256
 #define NR_IRQ_VECTORS	NR_IRQS
 
@@ -29,6 +32,7 @@ extern void disable_irq (unsigned int);
 extern void disable_irq_nosync (unsigned int);
 extern void enable_irq (unsigned int);
 extern void set_irq_affinity_info (unsigned int irq, int dest, int redir);
+bool is_affinity_mask_valid(cpumask_t cpumask);
 
 #define is_affinity_mask_valid is_affinity_mask_valid
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-move-common-segment-checks-to-separate-helper-function-v7.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection.patch
fix-cycladesh-for-x86_64-and-probably-others.patch
rtc-add-rtc-rs5c313-driver.patch
enlarge-console-name.patch
move-die-notifier-handling-to-common-code.patch
fix-sscanf-%n-match-at-end-of-input-string.patch
parport-dev-driver-model-support.patch
add-support-for-deferrable-timers-respun.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
move-timekeeping-code-to-timekeepingc.patch
fix-kevents-childs-priority-greediness.patch
enhance-initcall_debug-measure-latency.patch
dtlk-fix-error-checks-in-module_init.patch
document-spin_lock_unlocked-rw_lock_unlocked-deprecation.patch
consolidate-asm-consth-to-linux-consth.patch
driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core.patch
speedup-divides-by-cpu_power-in-scheduler.patch
utimensat-implementation.patch
revert-rtc-add-rtc_merge_alarm.patch
kprobes-the-on-off-knob-thru-debugfs-updated.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
x86-serial-convert-legacy-com-ports-to-platform-devices.patch
char-cyclades-conditions-cleanup.patch
char-cyclades-probe-cleanup.patch
fbdev-hecuba-framebuffer-driver.patch
vt-add-color-support-to-the-underline-and-italic-attributes-fix.patch
sm501fb-printk-warning-fixes.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
git-avr32.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed-powerpc-fixes.patch
git-dvb-fixup.patch
cinergyt2-fix-file-release-handler.patch
git-hid-fixup.patch
sn-validate-smp_affinity-mask-on-intr-redirect-fix.patch
sn-validate-smp_affinity-mask-on-intr-redirect-fix-2.patch
git-ieee1394.patch
sbp2-include-fixes.patch
ieee1394-iso-needs-schedh.patch
git-jfs.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
git-mtd.patch
git-e1000.patch
git-e1000-fixup-2.patch
git-battery-fix.patch
git-nfs-printk-warning-fixes.patch
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
