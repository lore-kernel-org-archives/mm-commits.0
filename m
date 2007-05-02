From: akpm@linux-foundation.org
Subject: - revert-rm-pointless-dmaengine-exports.patch removed from -mm tree
Date: Tue, 01 May 2007 22:45:57 -0700
Message-ID: <200705020545.l425jvS5014725@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37934 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992787AbXEBFqA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 May 2007 01:46:00 -0400
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l425jwHp005653
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 1 May 2007 22:45:59 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     revert rm-pointless-dmaengine-exports
has been removed from the -mm tree.  Its filename was
     revert-rm-pointless-dmaengine-exports.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: revert rm-pointless-dmaengine-exports
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/dmaengine.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff -puN drivers/dma/dmaengine.c~revert-rm-pointless-dmaengine-exports drivers/dma/dmaengine.c
--- a/drivers/dma/dmaengine.c~revert-rm-pointless-dmaengine-exports
+++ a/drivers/dma/dmaengine.c
@@ -176,7 +176,6 @@ void dma_chan_cleanup(struct kref *kref)
 	chan->client = NULL;
 	kref_put(&chan->device->refcount, dma_async_device_cleanup);
 }
-EXPORT_SYMBOL(dma_chan_cleanup);
 
 static void dma_chan_free_rcu(struct rcu_head *rcu)
 {
@@ -262,7 +261,6 @@ struct dma_client *dma_async_client_regi
 
 	return client;
 }
-EXPORT_SYMBOL(dma_async_client_register);
 
 /**
  * dma_async_client_unregister - unregister a client and free the &dma_client
@@ -289,7 +287,6 @@ void dma_async_client_unregister(struct 
 	kfree(client);
 	dma_chans_rebalance();
 }
-EXPORT_SYMBOL(dma_async_client_unregister);
 
 /**
  * dma_async_client_chan_request - request DMA channels
@@ -307,7 +304,6 @@ void dma_async_client_chan_request(struc
 	client->chans_desired = number;
 	dma_chans_rebalance();
 }
-EXPORT_SYMBOL(dma_async_client_chan_request);
 
 /**
  * dma_async_device_register - registers DMA devices found
@@ -350,7 +346,6 @@ int dma_async_device_register(struct dma
 
 	return 0;
 }
-EXPORT_SYMBOL(dma_async_device_register);
 
 /**
  * dma_async_device_cleanup - function called when all references are released
@@ -395,12 +390,23 @@ void dma_async_device_unregister(struct 
 	kref_put(&device->refcount, dma_async_device_cleanup);
 	wait_for_completion(&device->done);
 }
-EXPORT_SYMBOL(dma_async_device_unregister);
 
 static int __init dma_bus_init(void)
 {
 	mutex_init(&dma_list_mutex);
 	return class_register(&dma_devclass);
 }
+
 subsys_initcall(dma_bus_init);
 
+EXPORT_SYMBOL(dma_async_client_register);
+EXPORT_SYMBOL(dma_async_client_unregister);
+EXPORT_SYMBOL(dma_async_client_chan_request);
+EXPORT_SYMBOL(dma_async_memcpy_buf_to_buf);
+EXPORT_SYMBOL(dma_async_memcpy_buf_to_pg);
+EXPORT_SYMBOL(dma_async_memcpy_pg_to_pg);
+EXPORT_SYMBOL(dma_async_memcpy_complete);
+EXPORT_SYMBOL(dma_async_memcpy_issue_pending);
+EXPORT_SYMBOL(dma_async_device_register);
+EXPORT_SYMBOL(dma_async_device_unregister);
+EXPORT_SYMBOL(dma_chan_cleanup);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
zlib-backout.patch
slab-introduce-krealloc.patch
git-acpi.patch
git-alsa.patch
git-agpgart.patch
git-arm.patch
git-avr32.patch
revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed.patch
ida-implement-idr-based-id-allocator-fix.patch
more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
even-more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
even-even-more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
git-drm.patch
git-gfs2-nmw.patch
git-ieee1394.patch
sbp2-include-fixes.patch
ieee1394-iso-needs-schedh.patch
git-input.patch
git-jfs.patch
git-kvm.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-mmc.patch
git-mmc-build-fix.patch
ne-add-platform_driver-fix.patch
git-e1000.patch
git-e1000-fixup-2.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio.patch
git-ocfs2.patch
git-parisc.patch
git-r8169.patch
rm9000-serial-driver.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
git-s390-vs-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
s390-net-lcs-convert-to-the-kthread-api.patch
git-sh-fixup.patch
git-scsi-misc.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
git-unionfs.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
i386-__inquire_remote_apic-printk-warning-fix.patch
xfs-clean-up-shrinker-games.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range-fix.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
smaps-add-clear_refs-file-to-clear-reference.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
mm-move-common-segment-checks-to-separate-helper-function-v7.patch
slab-mark-set_up_list3s-__init.patch
slub-core.patch
mm-optimize-kill_bdev.patch
lazy-freeing-of-memory-through-madv_free.patch
lazy-freeing-of-memory-through-madv_free-vs-mm-madvise-avoid-exclusive-mmap_sem.patch
srmcons-fix-kmallocgfp_kernel-inside-spinlock.patch
uml-driver-formatting-fixes-fix.patch
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
