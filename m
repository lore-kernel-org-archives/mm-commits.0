From: akpm@linux-foundation.org
Subject: [merged] drivers-dma-ioat-dma_v2c-fix-warnings.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:04:08 -0700
Message-ID: <200909232004.n8NK48sQ020673@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752371AbZIWUEf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:04:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dan.j.williams@intel.com, maciej.sosnowski@intel.com, mm-commits@vger.kernel.org


The patch titled
     drivers/dma/ioat/dma_v2.c: fix warnings
has been removed from the -mm tree.  Its filename was
     drivers-dma-ioat-dma_v2c-fix-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/dma/ioat/dma_v2.c: fix warnings
From: Andrew Morton <akpm@linux-foundation.org>

drivers/dma/ioat/dma_v2.c: In function 'ioat2_dma_prep_memcpy_lock':
drivers/dma/ioat/dma_v2.c:680: warning: 'hw' may be used uninitialized in this function
drivers/dma/ioat/dma_v2.c:681: warning: 'desc' may be used uninitialized in this function

Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/ioat/dma_v2.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/dma/ioat/dma_v2.c~drivers-dma-ioat-dma_v2c-fix-warnings drivers/dma/ioat/dma_v2.c
--- a/drivers/dma/ioat/dma_v2.c~drivers-dma-ioat-dma_v2c-fix-warnings
+++ a/drivers/dma/ioat/dma_v2.c
@@ -692,7 +692,8 @@ ioat2_dma_prep_memcpy_lock(struct dma_ch
 		/* pass */;
 	else
 		return NULL;
-	for (i = 0; i < num_descs; i++) {
+	i = 0;
+	do {
 		size_t copy = min_t(size_t, len, 1 << ioat->xfercap_log);
 
 		desc = ioat2_get_ring_ent(ioat, idx + i);
@@ -707,7 +708,7 @@ ioat2_dma_prep_memcpy_lock(struct dma_ch
 		dst += copy;
 		src += copy;
 		dump_desc_dbg(ioat, desc);
-	}
+	} while (++i < num_descs);
 
 	desc->txd.flags = flags;
 	desc->len = total_len;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
drivers-md-dm-log-userspace-basec-fix-warning.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
include-linux-credh-fix-build.patch
serial167-fix-read-buffer-overflow.patch
st-fix-test-of-value-range-in-st_set_options.patch
drivers-usb-serial-sierrac-fix-config_pm=n-build.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
vfs-optimize-touch_time-too.patch
fs-improve-remountro-vs-buffercache-coherency.patch
fs-fix-overflow-in-sys_mount-for-in-kernel-calls.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
drivers-net-wireless-ath-ar9170-phyc-fix-uninitialised-variable.patch
hugetlb_file_setup-use-c-not-cpp.patch
readahead-add-blk_run_backing_dev.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
frv-arch-frv-kernel-debug-stubc-needs-start_kernelh.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
kernel-smpc-relocate-some-code.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
page-types-add-feature-for-walking-process-address-space-checkpatch-fixes.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memcg-improve-resource-counter-scalability-checkpatch-fixes.patch
exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch-fixes.patch
exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9-checkpatch-fixes.patch
elf-clean-up-fill_note_info-fix.patch
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

