From: akpm@linux-foundation.org
Subject: + git-nfs-printk-warning-fixes.patch added to -mm tree
Date: Fri, 04 May 2007 17:22:29 -0700
Message-ID: <200705050025.l450PLZ7003187@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40950 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423573AbXEEAZk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 20:25:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, bfields@fieldses.org, trond.myklebust@fys.uio.no


The patch titled
     git-nfs-printk-warning-fixes
has been added to the -mm tree.  Its filename is
     git-nfs-printk-warning-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-nfs-printk-warning-fixes
From: Andrew Morton <akpm@linux-foundation.org>

net/sunrpc/sched.c: In function 'rpc_malloc':
net/sunrpc/sched.c:766: warning: format '%u' expects type 'unsigned int', but argument 3 has type 'size_t'
net/sunrpc/sched.c: In function 'rpc_free':
net/sunrpc/sched.c:785: warning: format '%u' expects type 'unsigned int', but argument 2 has type 'size_t'

Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/sched.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN net/sunrpc/sched.c~git-nfs-printk-warning-fixes net/sunrpc/sched.c
--- a/net/sunrpc/sched.c~git-nfs-printk-warning-fixes
+++ a/net/sunrpc/sched.c
@@ -763,7 +763,7 @@ void *rpc_malloc(struct rpc_task *task, 
 	else
 		buf = kmalloc(size, gfp);
 	*buf = size;
-	dprintk("RPC: %5u allocated buffer of size %u at %p\n",
+	dprintk("RPC: %5u allocated buffer of size %zu at %p\n",
 			task->tk_pid, size, buf);
 	return (void *) ++buf;
 }
@@ -782,7 +782,7 @@ void rpc_free(void *buffer)
 	size = *buf;
 	buf--;
 
-	dprintk("RPC:       freeing buffer of size %u at %p\n",
+	dprintk("RPC:       freeing buffer of size %zu at %p\n",
 			size, buf);
 	if (size <= RPC_BUFFER_MAXSIZE)
 		mempool_free(buf, rpc_buffer_mempool);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slab-introduce-krealloc.patch
rm9000-serial-driver.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
smaps-add-clear_refs-file-to-clear-reference.patch
slab-mark-set_up_list3s-__init.patch
slub-core.patch
slub-allocate-smallest-object-size-if-the-user-asks-for-0-bytes-fix.patch
mm-optimize-kill_bdev.patch
get_unmapped_area-handles-map_fixed-in-hugetlbfs-fix.patch
srmcons-fix-kmallocgfp_kernel-inside-spinlock.patch
uml-driver-formatting-fixes-fix.patch
cx88-video-build-fix.patch
git-acpi.patch
git-alsa.patch
wm8750-typo-fix.patch
git-agpgart.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
git-arm.patch
git-avr32.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed.patch
git-drm.patch
cinergyt2-fix-file-release-handler.patch
git-gfs2-nmw.patch
git-hid-fixup.patch
git-ieee1394.patch
sbp2-include-fixes.patch
ieee1394-iso-needs-schedh.patch
git-input.patch
input-fix-aux-port-detection-with-some-i8042-chips-fix.patch
git-jfs.patch
git-kbuild.patch
git-kvm.patch
git-mmc.patch
git-mtd.patch
natsemi-allow-users-to-disable-workaround-for-dspcfg-reset-fix.patch
git-e1000.patch
git-e1000-fixup-2.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio.patch
git-nfs.patch
git-ocfs2.patch
git-parisc.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
git-sh-fixup.patch
git-scsi-misc.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
git-unionfs.patch
auerswald-fix-file-release-handler.patch
git-wireless.patch
fix-x86_64-mm-mtrr-save-the-mtrrs-of-the-bsp-before-booting-an-ap.patch
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
mm-move-common-segment-checks-to-separate-helper-function-v7.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
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
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount.patch
enhance-initcall_debug-measure-latency.patch
dtlk-fix-error-checks-in-module_init.patch
document-spin_lock_unlocked-rw_lock_unlocked-deprecation.patch
upper-32-bits.patch
driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core.patch
do_tty_write-can-block-even-with-o_nonblock-tidy.patch
lib-hexdump-fix.patch
pasemi-hardware-rng-driver-tidy.patch
nbd-check-the-return-value-of-sysfs_create_file-fix.patch
blacklist-dell-optiplex-320-from-using-the-hpet-fix.patch
tty-add-compat_ioctl-fix.patch
synclink_gt-add-compat_ioctl-fix.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
kthread-dont-depend-on-work-queues-take-2.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
make-cancel_rearming_delayed_work-reliable-spelling.patch
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
signal-timer-event-fds-v9-timerfd-core.patch
signal-timer-event-fds-v9-eventfd-core.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-wire-up-i386-system-calls.patch
x86-serial-convert-legacy-com-ports-to-platform-devices.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
fs-convert-core-functions-to-zero_user_page-pass-kmap-type.patch
fs-convert-core-functions-to-zero_user_page-fix-2.patch
ntfs-use-zero_user_page-fix.patch
make-vm-statistics-update-interval-configurable-fix.patch
acpi-keep-tsc-stable-when-lapic_timer_c2_ok-is-set-vs-x86_64-mm-log-reason-why-tsc-was-marked-unstable.patch
rename-thread_info-to-stack-fix.patch
char-cyclades-conditions-cleanup-fix.patch
char-cyclades-probe-cleanup-fix.patch
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
w1-build-fix.patch
libata-clean-up-sff-init-mess-fix.patch
git-wireless-build-fix.patch
atl1-use-dev_printk-macros-fix.patch
git-nfs-printk-warning-fixes.patch
