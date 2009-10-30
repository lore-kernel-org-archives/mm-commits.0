From: akpm@linux-foundation.org
Subject: [merged] revert-mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch removed from -mm tree
Date: Fri, 30 Oct 2009 13:50:12 -0700
Message-ID: <200910302050.n9UKoC9R010010@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37223 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757515AbZJ3UvB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Oct 2009 16:51:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adobriyan@gmail.com, fengguang.wu@intel.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, rientjes@google.com, torvalds@linux-foundation.org, mm-commits


The patch titled
     revert "mm: oom analysis: add buffer cache information to show_free_areas()"
has been removed from the -mm tree.  Its filename was
     revert-mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert "mm: oom analysis: add buffer cache information to show_free_areas()"
From: Andrew Morton <akpm@linux-foundation.org>

Revert

    commit 71de1ccbe1fb40203edd3beb473f8580d917d2ca
    Author:     KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
    AuthorDate: Mon Sep 21 17:01:31 2009 -0700
    Commit:     Linus Torvalds <torvalds@linux-foundation.org>
    CommitDate: Tue Sep 22 07:17:27 2009 -0700

        mm: oom analysis: add buffer cache information to show_free_areas()
    

show_free_areas() is called during page allocation failures, and page
allocation failures can occur in any calling context.

But nr_blockdev_pages() takes VFS locks which should not be taken from
hard IRQ context (at least).  The result is lockdep warnings (and
deadlockability) during page allocation failures.

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/page_alloc.c~revert-mm-oom-analysis-add-buffer-cache-information-to-show_free_areas mm/page_alloc.c
--- a/mm/page_alloc.c~revert-mm-oom-analysis-add-buffer-cache-information-to-show_free_areas
+++ a/mm/page_alloc.c
@@ -2183,7 +2183,7 @@ void show_free_areas(void)
 	printk("active_anon:%lu inactive_anon:%lu isolated_anon:%lu\n"
 		" active_file:%lu inactive_file:%lu isolated_file:%lu\n"
 		" unevictable:%lu"
-		" dirty:%lu writeback:%lu unstable:%lu buffer:%lu\n"
+		" dirty:%lu writeback:%lu unstable:%lu\n"
 		" free:%lu slab_reclaimable:%lu slab_unreclaimable:%lu\n"
 		" mapped:%lu shmem:%lu pagetables:%lu bounce:%lu\n",
 		global_page_state(NR_ACTIVE_ANON),
@@ -2196,7 +2196,6 @@ void show_free_areas(void)
 		global_page_state(NR_FILE_DIRTY),
 		global_page_state(NR_WRITEBACK),
 		global_page_state(NR_UNSTABLE_NFS),
-		nr_blockdev_pages(),
 		global_page_state(NR_FREE_PAGES),
 		global_page_state(NR_SLAB_RECLAIMABLE),
 		global_page_state(NR_SLAB_UNRECLAIMABLE),
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-compiler-gcc4h-gcc-402-doesnt-understand-__builtin_object_size.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-fix.patch
acpi-remove-nid_inval-checkpatch-fixes.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
include-trace-events-lockdeph-fix-do_div-warning.patch
st-fix-test-of-value-range-in-st_set_options.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
readahead-add-blk_run_backing_dev.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch
rwsem-fix-rwsem_is_locked-bugs-fix.patch
errh-add-helper-function-to-simplify-pointer-error-checking-fix.patch
hwmon-w83627ehf-updates-checkpatch-fixes.patch
spi-controller-driver-for-designware-spi-core-fix.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
memcg-coalesce-charging-via-percpu-storage-fix.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
reiser4-disable.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

