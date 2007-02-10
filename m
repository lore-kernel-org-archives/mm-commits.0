From: akpm@linux-foundation.org
Subject: - optional-zone_dma-in-the-vm-tidy.patch removed from -mm tree
Date: Sat, 10 Feb 2007 00:07:24 -0800
Message-ID: <200702100807.l1A87OET006880@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39226 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbXBJIH1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 03:07:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, clameter@engr.sgi.com, mm-commits@vger.kernel.org


The patch titled
     optional-zone_dma-in-the-vm-tidy
has been removed from the -mm tree.  Its filename was
     optional-zone_dma-in-the-vm-tidy.patch

This patch was dropped because it was folded into optional-zone_dma-in-the-vm.patch

------------------------------------------------------
Subject: optional-zone_dma-in-the-vm-tidy
From: Andrew Morton <akpm@osdl.org>

That was ugly.  Let's keep it simple.

Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/slab_def.h |   30 +++++++++++++++++++-----------
 mm/slab.c                |    2 ++
 2 files changed, 21 insertions(+), 11 deletions(-)

diff -puN include/linux/slab_def.h~optional-zone_dma-in-the-vm-tidy include/linux/slab_def.h
--- a/include/linux/slab_def.h~optional-zone_dma-in-the-vm-tidy
+++ a/include/linux/slab_def.h
@@ -21,8 +21,6 @@ struct cache_sizes {
 	struct kmem_cache	*cs_cachep;
 #ifdef CONFIG_ZONE_DMA
 	struct kmem_cache	*cs_dmacachep;
-#else
-#define cs_dmacachep cs_cachep
 #endif
 };
 extern struct cache_sizes malloc_sizes[];
@@ -43,9 +41,12 @@ static inline void *kmalloc(size_t size,
 			__you_cannot_kmalloc_that_much();
 		}
 found:
-		return kmem_cache_alloc((flags & GFP_DMA) ?
-			malloc_sizes[i].cs_dmacachep :
-			malloc_sizes[i].cs_cachep, flags);
+#ifdef CONFIG_ZONE_DMA
+		if (flags & GFP_DMA)
+			return kmem_cache_alloc(malloc_sizes[i].cs_dmacachep,
+						flags);
+#endif
+		return kmem_cache_alloc(malloc_sizes[i].cs_cachep, flags);
 	}
 	return __kmalloc(size, flags);
 }
@@ -66,9 +67,12 @@ static inline void *kzalloc(size_t size,
 			__you_cannot_kzalloc_that_much();
 		}
 found:
-		return kmem_cache_zalloc((flags & GFP_DMA) ?
-			malloc_sizes[i].cs_dmacachep :
-			malloc_sizes[i].cs_cachep, flags);
+#ifdef CONFIG_ZONE_DMA
+		if (flags & GFP_DMA)
+			return kmem_cache_zalloc(malloc_sizes[i].cs_dmacachep,
+						flags);
+#endif
+		return kmem_cache_zalloc(malloc_sizes[i].cs_cachep, flags);
 	}
 	return __kzalloc(size, flags);
 }
@@ -92,9 +96,13 @@ static inline void *kmalloc_node(size_t 
 			__you_cannot_kmalloc_that_much();
 		}
 found:
-		return kmem_cache_alloc_node((flags & GFP_DMA) ?
-			malloc_sizes[i].cs_dmacachep :
-			malloc_sizes[i].cs_cachep, flags, node);
+#ifdef CONFIG_ZONE_DMA
+		if (flags & GFP_DMA)
+			return kmem_cache_alloc_node(malloc_sizes[i].cs_dmacachep,
+						flags, node);
+#endif
+		return kmem_cache_alloc_node(malloc_sizes[i].cs_cachep,
+						flags, node);
 	}
 	return __kmalloc_node(size, flags, node);
 }
diff -puN mm/slab.c~optional-zone_dma-in-the-vm-tidy mm/slab.c
--- a/mm/slab.c~optional-zone_dma-in-the-vm-tidy
+++ a/mm/slab.c
@@ -793,8 +793,10 @@ static inline struct kmem_cache *__find_
 	 * has cs_{dma,}cachep==NULL. Thus no special case
 	 * for large kmalloc calls required.
 	 */
+#ifdef CONFIG_ZONE_DMA
 	if (unlikely(gfpflags & GFP_DMA))
 		return csizep->cs_dmacachep;
+#endif
 	return csizep->cs_cachep;
 }
 
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
avoid-excessive-sorting-of-early_node_map.patch
proc-zoneinfo-fix-vm-stats-display.patch
use-zvc-for-inactive-and-active-counts.patch
drop-free_pages.patch
optional-zone_dma-in-the-vm.patch
optional-zone_dma-in-the-vm-tidy.patch
swsusp-change-code-ordering-in-userc-sanity.patch
deprecate-smbfs-in-favour-of-cifs.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
drivers-add-lcd-support-workqueue-fixups.patch
count_vm_events-warning-fix.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
consolidate-line-discipline-number-definitions-v2-sparc-fix.patch
consolidate-line-discipline-number-definitions-v2-fix-2.patch
add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix-2.patch
remove-invalidate_inode_pages.patch
add-an-rcu-version-of-list-splicing-fix.patch
block_write_full_page-handle-enospc.patch
sysctl-warning-fix.patch
proc_misc-warning-fix.patch
rtc-framework-driver-for-cmos-rtcs-fix.patch
rtc-framework-driver-for-cmos-rtcs-fix-2.patch
return-enoent-from-ext3_link-when-racing-with-unlink-fix.patch
filesystem-disk-errors-at-boot-time-caused-by-probe-tidy.patch
filesystem-disk-errors-at-boot-time-caused-by-probe-tidy-fixes.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
register_chrdev_region-dont-hand-out-the-local-experimental-majors.patch
register_blkdev-dont-hand-out-the-local-experimental-majors.patch
factor-outstanding-i-o-error-handling-tidy.patch
sync_sb_inodes-propagate-errors.patch
spi-controller-driver-for-omap-microwire-tidy.patch
spi-controller-driver-for-omap-microwire-update-fix.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
vmi-versus-hrtimers.patch
add-a-functions-to-handle-interrupt-affinity-setting-alpha-fix.patch
i386-use-gtod-persistent-clock-support.patch
hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
hrtimers-cleanup-locking.patch
hrtimers-add-state-tracking.patch
clockevents-i383-drivers.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
revert-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
schedule_on_each_cpu-use-preempt_disable.patch
implement-flush_work-sanity.patch
implement-flush_work_keventd.patch
flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-2.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release-fix.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc-fix.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
omap-gpio-wrappers-tidy.patch
at91-gpio-wrappers-tidy.patch
ecryptfs-public-key-packet-management-slab-fix.patch
ecryptfs-generalize-metadata-read-write-fix.patch
fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine-gfs2-fix.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix.patch
aio-is-unlikely.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
dynamic-kernel-command-line-ia64-fix.patch
kvm-add-a-global-list-of-all-virtual-machines-tidy.patch
readahead-kconfig-options-fix.patch
readahead-minmax_ra_pages.patch
readahead-sysctl-parameters.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
readahead-context-based-method-locking-fix.patch
readahead-context-based-method-locking-fix-2.patch
readahead-call-scheme-ifdef-fix.patch
readahead-call-scheme-build-fix.patch
readahead-nfsd-case-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
resier4-add-include-linux-freezerh-and-move-definitions-from.patch
make-kmem_cache_destroy-return-void-reiser4.patch
reiser4-hardirq-include-fix.patch
reiser4-run-truncate_inode_pages-in-reiser4_delete_inode.patch
reiser4-get_sb_dev-fix.patch
reiser4-vs-zoned-allocator.patch
reiser4-temp-fix.patch
reiser4-kmem_cache_t-removal.patch
reiser4-test_clear_page_dirty.patch
reiser4-vs-git-block.patch
reiser4-vs-git-block-2.patch
cyber2010-framebuffer-on-arm-netwinder-fix-tidy.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
slim-main-include-fix.patch
mark-struct-file_operations-const-2-fix.patch
mark-struct-file_operations-const-4-fix.patch
scheduled-removal-of-sa_xxx-interrupt-flags-ata-fix.patch
sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support-fix.patch
sysctl-move-utsname-sysctls-to-their-own-file-fix-2.patch
sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry-warning-fix.patch
sysctl-factor-out-sysctl_head_next-from-do_sysctl-warning-fix.patch
sysctl-reimplement-the-sysctl-proc-support-warning-fix.patch
sysctl-reimplement-the-sysctl-proc-support-fix-2.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-ntfs-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
ia64-enable-config_debug_spinlock_sleep.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch
