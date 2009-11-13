From: akpm@linux-foundation.org
Subject: + mm-memory_hotplug-make-offline_pages-static.patch added to -mm tree
Date: Fri, 13 Nov 2009 15:53:53 -0800
Message-ID: <200911132353.nADNrr5K011070@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38223 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932536AbZKMXyC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 18:54:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, andi@firstfloor.org, gerald.schaefer@de.ibm.com, kosaki.motohiro@jp.fujitsu.com, rjw@sisk.pl, y-goto@jp.fujitsu.com


The patch titled
     mm: memory_hotplug: make offline_pages() static
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-make-offline_pages-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-compiler-gcc4h-gcc-402-doesnt-understand-__builtin_object_size.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-fix.patch
acpi-remove-nid_inval-checkpatch-fixes.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
atmel_serial-add-poll_get_char-and-poll_put_char-uart_ops-fix.patch
include-trace-events-lockdeph-fix-do_div-warning.patch
st-fix-test-of-value-range-in-st_set_options.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
readahead-add-blk_run_backing_dev.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process-fix.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42-checkpatch-fixes.patch
mm-memory_hotplug-make-offline_pages-static.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch
rwsem-fix-rwsem_is_locked-bugs-fix.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-checkpatch-fixes.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-rename.patch
errh-add-helper-function-to-simplify-pointer-error-checking-fix.patch
msm_sdccc-add-missing-include-fix-compilation-checkpatch-fixes.patch
crc32-minor-optimizations-and-cleanup-checkpatch-fixes.patch
hwmon-w83627ehf-updates-checkpatch-fixes.patch
spi-controller-driver-for-designware-spi-core-fix.patch
spidev-use-declare_bitmap-instead-of-declaring-the-array-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2.patch
ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock-checkpatch-fixes.patch
memcg-coalesce-charging-via-percpu-storage-fix.patch
aio-dont-zero-out-the-pages-array-inside-struct-dio-fix.patch
direct-io-cleanup-blockdev_direct_io-locking-checkpatch-fixes.patch
zlib-optimize-inffast-when-copying-direct-from-output-checkpatch-fixes.patch
lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes.patch
lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes-cleanup.patch
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

