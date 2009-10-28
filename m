From: akpm@linux-foundation.org
Subject: [merged] vfs-implement-posix-o_sync-and-o_dsync-semantics-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 28 Oct 2009 12:01:51 -0700
Message-ID: <200910281901.n9SJ1pNk004421@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55719 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752327AbZJ1TBs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Oct 2009 15:01:48 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n9SJ1pJA026961
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 28 Oct 2009 12:01:53 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     vfs-implement-posix-o_sync-and-o_dsync-semantics-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     vfs-implement-posix-o_sync-and-o_dsync-semantics-checkpatch-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs-implement-posix-o_sync-and-o_dsync-semantics-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: braces {} are not necessary for single statement blocks
#269: FILE: arch/x86/mm/pat.c:708:
+	if (file->f_flags & O_DSYNC) {
 		flags = _PAGE_CACHE_UC_MINUS;
 	}

WARNING: line over 80 characters
#281: FILE: drivers/char/mem.c:47:
+	 * On ia64, we ignore O_DSYNC because we cannot tolerate memory attribute aliases.

total: 0 errors, 2 warnings, 359 lines checked

./patches/vfs-implement-posix-o_sync-and-o_dsync-semantics.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pat.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/x86/mm/pat.c~vfs-implement-posix-o_sync-and-o_dsync-semantics-checkpatch-fixes arch/x86/mm/pat.c
--- a/arch/x86/mm/pat.c~vfs-implement-posix-o_sync-and-o_dsync-semantics-checkpatch-fixes
+++ a/arch/x86/mm/pat.c
@@ -705,9 +705,8 @@ int phys_mem_access_prot_allowed(struct 
 	if (!range_is_allowed(pfn, size))
 		return 0;
 
-	if (file->f_flags & O_DSYNC) {
+	if (file->f_flags & O_DSYNC)
 		flags = _PAGE_CACHE_UC_MINUS;
-	}
 
 #ifdef CONFIG_X86_32
 	/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
hfsplus-refuse-to-mount-volumes-larger-than-2tb.patch
revert-mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
8250_pci-add-ibm-saturn-serial-card.patch
checkpatch-fix-false-export_symbol-warning.patch
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

