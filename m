From: akpm@linux-foundation.org
Subject: [merged] mm-memory_hotplug-make-offline_pages-static.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:53:59 -0800
Message-ID: <200912152153.nBFLrxiM015322@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761266AbZLOVyl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:54:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andi@firstfloor.org, gerald.schaefer@de.ibm.com, kosaki.motohiro@jp.fujitsu.com, rjw@sisk.pl, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm: memory_hotplug: make offline_pages() static
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-make-offline_pages-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: memory_hotplug: make offline_pages() static
From: Andrew Morton <akpm@linux-foundation.org>

It has no references outside memory_hotplug.c.

Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    1 -
 mm/memory_hotplug.c            |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff -puN include/linux/memory_hotplug.h~mm-memory_hotplug-make-offline_pages-static include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-make-offline_pages-static
+++ a/include/linux/memory_hotplug.h
@@ -69,7 +69,6 @@ extern void online_page(struct page *pag
 /* VM interface that may be used by firmware interface */
 extern int online_pages(unsigned long, unsigned long);
 extern void __offline_isolated_pages(unsigned long, unsigned long);
-extern int offline_pages(unsigned long, unsigned long, unsigned long);
 
 /* reasonably generic interface to expand the physical pages in a zone  */
 extern int __add_pages(int nid, struct zone *zone, unsigned long start_pfn,
diff -puN mm/memory_hotplug.c~mm-memory_hotplug-make-offline_pages-static mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-make-offline_pages-static
+++ a/mm/memory_hotplug.c
@@ -751,7 +751,7 @@ check_pages_isolated(unsigned long start
 	return offlined;
 }
 
-int offline_pages(unsigned long start_pfn,
+static int offline_pages(unsigned long start_pfn,
 		  unsigned long end_pfn, unsigned long timeout)
 {
 	unsigned long pfn, nr_pages, expire;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
acpi-remove-nid_inval.patch
drivers-acpi-acpi_padc-squish-warning.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-checkpatch-fixes.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
drivers-leds-leds-ss4200c-fix-return-statement.patch
net-sctp-socketc-fix-warning.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix2.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
fs-ext4-superc-fix-printk-warning.patch
atmel_serial-add-poll_get_char-and-poll_put_char-uart_ops.patch
scsi-aacraid-fix-memory-leak-checkpatch-fixes.patch
aoe-switch-to-the-new-bio_flush_dcache_pages-interface.patch
fs-improve-remountro-vs-buffercache-coherency.patch
drivers-net-wireless-iwlwifi-iwl-txc-fix-gcc-345-warning.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
readahead-add-blk_run_backing_dev.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
ksm-memory-hotremove-migration-only-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
spi-controller-driver-for-designware-spi-core.patch
spidev-use-declare_bitmap-instead-of-declaring-the-array.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2-fix-3.patch
ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock-checkpatch-fixes.patch
memcg-coalesce-charging-via-percpu-storage-fix.patch
memcg-code-cleanrm-unused-variable-in-mem_cgroup_resize_limit-cleanup.patch
ipc-remove-unreachable-code-in-semc-fix.patch
char-cyclades-fix-compiler-warning.patch
fs-cache-avoid-maybe-used-uninitialised-warning-on-variable.patch
aio-dont-zero-out-the-pages-array-inside-struct-dio-fix.patch
direct-io-cleanup-blockdev_direct_io-locking-checkpatch-fixes.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
drivers-media-video-cx23885-needs-kfifo-updates.patch
revert-tty-sdio_uart-use-kfifo-instead-of-the-messy-circ-stuff.patch
kfifo-move-struct-kfifo-in-place-fix.patch
zlib-optimize-inffast-when-copying-direct-from-output-checkpatch-fixes.patch
lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes.patch
lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes-cleanup.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

