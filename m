From: akpm@linux-foundation.org
Subject: - signal-timer-event-fds-v9-signalfd-core-fix.patch removed from -mm tree
Date: Mon, 30 Apr 2007 13:30:44 -0700
Message-ID: <200704302030.l3UKUih6014290@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50253 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946805AbXD3Uar (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 16:30:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davidel@xmailserver.org, mm-commits@vger.kernel.org


The patch titled
     signal-timer-event-fds-v9-signalfd-core fix
has been removed from the -mm tree.  Its filename was
     signal-timer-event-fds-v9-signalfd-core-fix.patch

This patch was dropped because it was folded into signal-timer-event-fds-v9-signalfd-core.patch

------------------------------------------------------
Subject: signal-timer-event-fds-v9-signalfd-core fix
From: Andrew Morton <akpm@linux-foundation.org>

i386:

fs/signalfd.c: In function 'signalfd_copyinfo':
fs/signalfd.c:179: warning: cast from pointer to integer of different size
fs/signalfd.c:179: warning: cast from pointer to integer of different size
fs/signalfd.c:179: warning: cast from pointer to integer of different size
fs/signalfd.c:179: warning: cast from pointer to integer of different size
fs/signalfd.c:186: warning: cast from pointer to integer of different size
fs/signalfd.c:186: warning: cast from pointer to integer of different size
fs/signalfd.c:186: warning: cast from pointer to integer of different size
fs/signalfd.c:186: warning: cast from pointer to integer of different size
fs/signalfd.c:202: warning: cast from pointer to integer of different size
fs/signalfd.c:202: warning: cast from pointer to integer of different size
fs/signalfd.c:202: warning: cast from pointer to integer of different size
fs/signalfd.c:202: warning: cast from pointer to integer of different size

Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/signalfd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/signalfd.c~signal-timer-event-fds-v9-signalfd-core-fix fs/signalfd.c
--- a/fs/signalfd.c~signal-timer-event-fds-v9-signalfd-core-fix
+++ a/fs/signalfd.c
@@ -176,14 +176,14 @@ static int signalfd_copyinfo(struct sign
 	case __SI_TIMER:
 		 err |= __put_user(kinfo->si_tid, &uinfo->tid);
 		 err |= __put_user(kinfo->si_overrun, &uinfo->overrun);
-		 err |= __put_user(kinfo->si_ptr, &uinfo->svptr);
+		 err |= __put_user((long)kinfo->si_ptr, &uinfo->svptr);
 		break;
 	case __SI_POLL:
 		err |= __put_user(kinfo->si_band, &uinfo->band);
 		err |= __put_user(kinfo->si_fd, &uinfo->fd);
 		break;
 	case __SI_FAULT:
-		err |= __put_user(kinfo->si_addr, &uinfo->addr);
+		err |= __put_user((long)kinfo->si_addr, &uinfo->addr);
 #ifdef __ARCH_SI_TRAPNO
 		err |= __put_user(kinfo->si_trapno, &uinfo->trapno);
 #endif
@@ -199,7 +199,7 @@ static int signalfd_copyinfo(struct sign
 	case __SI_MESGQ: /* But this is */
 		err |= __put_user(kinfo->si_pid, &uinfo->pid);
 		err |= __put_user(kinfo->si_uid, &uinfo->uid);
-		err |= __put_user(kinfo->si_ptr, &uinfo->svptr);
+		err |= __put_user((long)kinfo->si_ptr, &uinfo->svptr);
 		break;
 	default: /* this is just in case for now ... */
 		err |= __put_user(kinfo->si_pid, &uinfo->pid);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
zlib-backout.patch
extend-print_symbol-capability.patch
add-kvasprintf.patch
add-kvasprintf-fix.patch
slab-introduce-krealloc.patch
git-acpi.patch
git-alsa.patch
git-alsa-fixup.patch
git-agpgart.patch
git-powerpc.patch
git-powerpc-fixup.patch
ppc4xx_sgdma-needs-dma_mappingh.patch
revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed.patch
ida-implement-idr-based-id-allocator-fix.patch
more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
even-more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
even-even-more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
git-drm.patch
git-dvb.patch
git-dvb-vs-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-ieee1394-fixup.patch
sbp2-include-fixes.patch
ieee1394-iso-needs-schedh.patch
git-input.patch
git-input-fixup.patch
git-jfs.patch
git-kvm.patch
git-libata-all.patch
ata-printk-warning-fixes.patch
drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-mmc-build-fix.patch
git-netdev-all.patch
ne-add-platform_driver-fix.patch
git-e1000.patch
git-e1000-fixup-2.patch
git-net-vs-git-netdev-all.patch
sctp-fix-sctp_getsockopt_local_addrs_old-to-use-local-storage.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio.patch
git-ocfs2.patch
git-parisc.patch
rm9000-serial-driver.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
git-s390-vs-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
s390-net-lcs-convert-to-the-kthread-api.patch
git-sh-fixup.patch
git-scsi-misc.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
i386-__inquire_remote_apic-printk-warning-fix.patch
xfs-clean-up-shrinker-games.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range-fix.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
smaps-add-clear_refs-file-to-clear-reference.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
mm-move-common-segment-checks-to-separate-helper-function-v7.patch
slab-mark-set_up_list3s-__init.patch
slub-core.patch
mm-optimize-kill_bdev.patch
lazy-freeing-of-memory-through-madv_free.patch
lazy-freeing-of-memory-through-madv_free-vs-mm-madvise-avoid-exclusive-mmap_sem.patch
srmcons-fix-kmallocgfp_kernel-inside-spinlock.patch
uml-driver-formatting-fixes-fix.patch
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
cache-pipe-buf-page-address-for-non-highmem-arch.patch
add-support-for-deferrable-timers-respun.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
move-timekeeping-code-to-timekeepingc.patch
fix-kevents-childs-priority-greediness.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount.patch
enhance-initcall_debug-measure-latency.patch
expose-range-checking-functions-from-arch-specific.patch
dtlk-fix-error-checks-in-module_init.patch
document-spin_lock_unlocked-rw_lock_unlocked-deprecation.patch
upper-32-bits.patch
driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
kthread-dont-depend-on-work-queues-take-2.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
speedup-divides-by-cpu_power-in-scheduler.patch
utimensat-implementation.patch
revert-rtc-add-rtc_merge_alarm.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
kprobes-the-on-off-knob-thru-debugfs-updated.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
linux-kernel-markers-i386-optimization.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-fds-v9-signalfd-core-fix.patch
signal-timer-event-fds-v9-signalfd-core-fix-fix.patch
signal-timer-event-fds-v9-timerfd-core-fix.patch
signal-timer-event-fds-v9-eventfd-core-fix.patch
signal-timer-event-fds-v9-eventfd-core-fix-fix.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-wire-up-i386-system-calls.patch
x86-serial-convert-legacy-com-ports-to-platform-devices-fix.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
fs-convert-core-functions-to-zero_user_page-pass-kmap-type.patch
fs-convert-core-functions-to-zero_user_page-fix-2.patch
ntfs-use-zero_user_page-fix.patch
reiser4-slab-allocators-remove-slab_debug_initial-flag.patch
fbdev-hecuba-framebuffer-driver.patch
vt-add-color-support-to-the-underline-and-italic-attributes-fix.patch
sm501fb-printk-warning-fixes.patch
integrity-new-hooks-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
git-gccbug-fixup.patch
w1-build-fix.patch
