From: akpm@linux-foundation.org
Subject: [to-be-updated] munmap-dont-check-sysctl_max_mapcount-fix.patch removed from -mm tree
Date: Mon, 12 Oct 2009 15:36:04 -0700
Message-ID: <200910122236.n9CMa4q3023868@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933512AbZJLWhb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Oct 2009 18:37:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hugh.dickins@tiscali.co.uk, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     munmap-dont-check-sysctl_max_mapcount-fix
has been removed from the -mm tree.  Its filename was
     munmap-dont-check-sysctl_max_mapcount-fix.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: munmap-dont-check-sysctl_max_mapcount-fix
From: Andrew Morton <akpm@linux-foundation.org>

comment the code.

Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/mmap.c~munmap-dont-check-sysctl_max_mapcount-fix mm/mmap.c
--- a/mm/mmap.c~munmap-dont-check-sysctl_max_mapcount-fix
+++ a/mm/mmap.c
@@ -1829,8 +1829,8 @@ detach_vmas_to_be_unmapped(struct mm_str
 }
 
 /*
- * Split a vma into two pieces at address 'addr', a new vma is allocated
- * either for the first part or the tail.
+ * __split_vma() bypasses sysctl_max_map_count checking.  We use this on the
+ * munmap path where it doesn't make sense to fail.
  */
 static int __split_vma(struct mm_struct * mm, struct vm_area_struct * vma,
 	      unsigned long addr, int new_below)
@@ -1881,6 +1881,10 @@ static int __split_vma(struct mm_struct 
 	return 0;
 }
 
+/*
+ * Split a vma into two pieces at address 'addr', a new vma is allocated
+ * either for the first part or the tail.
+ */
 int split_vma(struct mm_struct * mm, struct vm_area_struct * vma,
 	      unsigned long addr, int new_below)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-compiler-gcc4h-gcc-402-doesnt-understand-__builtin_object_size.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-fix.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
include-trace-events-lockdeph-fix-do_div-warning.patch
st-fix-test-of-value-range-in-st_set_options.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
hfsplus-refuse-to-mount-volumes-larger-than-2tb-fix.patch
revert-mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
vfs-implement-posix-o_sync-and-o_dsync-semantics-checkpatch-fixes.patch
munmap-dont-check-sysctl_max_mapcount-fix.patch
readahead-add-blk_run_backing_dev.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
errh-add-helper-function-to-simplify-pointer-error-checking-fix.patch
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

