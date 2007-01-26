From: akpm@osdl.org
Subject: + optional-zone_dma-in-the-vm-tidy.patch added to -mm tree
Date: Fri, 26 Jan 2007 11:36:48 -0800
Message-ID: <200701261936.l0QJamZx024159@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51666 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128AbXAZTgz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 14:36:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@osdl.org, clameter@engr.sgi.com


The patch titled
     optional-zone_dma-in-the-vm-tidy
has been added to the -mm tree.  Its filename is
     optional-zone_dma-in-the-vm-tidy.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

use-correct-macros-in-raid-code-not-raw-asm-include.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-acpi.patch
exit-acpi-processor-module-gracefully-if-acpi-is-disabled-tidy.patch
sony_apci-resume.patch
sony_apci-resume-fix.patch
video-sysfs-support-take-2-add-dev-argument-for-backlight_device_register-sony_acpi-fix.patch
git-alsa.patch
agpgart-allow-drm-populated-agp-memory-types-tidy.patch
rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix-2.patch
via-agp-and-drm-adding-support-for-cx700m2-p4m890-and-vt3336-chipsets-fix.patch
git-dvb.patch
git-gfs2-nmw.patch
ia64-enable-config_debug_spinlock_sleep.patch
git-ieee1394.patch
git-infiniband-fixup.patch
git-infiniband-fixup-2.patch
git-input.patch
git-libata-all.patch
sata_nv-cleanup-adma-error-handling-v2-cleanup.patch
git-lxdialog-fixup.patch
git-mmc.patch
git-mmc-fixup.patch
git-ubi.patch
git-netdev-all.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
bonding-replace-kmalloc-memset-pairs-with-the-appropriate-kzalloc-calls-fix.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
nfs-fix-congestion-control-v4-tweaks.patch
r8169-warning-fixes.patch
make-cardbus_mem_size-and-cardbus_io_size-boot-options-fix.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-block-fixup.patch
git-block-atomicity-fix.patch
nokia-e70-is-an-unusual-device.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation-fix.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation-fix-fix.patch
touchkit-ps-2-touchscreen-driver.patch
lumpy-reclaim-v2-page_to_pfn-fix.patch
lumpy-reclaim-v2-tidy.patch
avoid-excessive-sorting-of-early_node_map-tidy.patch
proc-zoneinfo-fix-vm-stats-display.patch
get_dirty_limits-accurately-calculate-the-available-memory-that-can-be-dirtied-fix.patch
optional-zone_dma-in-the-vm-tidy.patch
swsusp-change-code-ordering-in-userc-sanity.patch
deprecate-smbfs-in-favour-of-cifs.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
drivers-add-lcd-support-workqueue-fixups.patch
add-retain_initrd-boot-option-tweak.patch
count_vm_events-warning-fix.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
consolidate-line-discipline-number-definitions-v2-sparc-fix.patch
consolidate-line-discipline-number-definitions-v2-fix-2.patch
add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix-2.patch
remove-invalidate_inode_pages.patch
add-an-rcu-version-of-list-splicing-fix.patch
factor-outstanding-i-o-error-handling-tidy.patch
sync_sb_inodes-propagate-errors.patch
block_write_full_page-handle-enospc.patch
sysctl-warning-fix.patch
proc_misc-warning-fix.patch
return-enoent-from-ext3_link-when-racing-with-unlink-fix.patch
spi-controller-driver-for-omap-microwire-tidy.patch
spi-controller-driver-for-omap-microwire-update-fix.patch
vmi-versus-hrtimers.patch
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
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix.patch
aio-is-unlikely.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
introduce-and-use-get_task_mnt_ns-tweaks.patch
user-ns-implement-user-ns-unshare-tidy.patch
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
squash-ipc-warnings.patch
squash-udf-warnings.patch
