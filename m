From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects-git-rejects.patch added to -mm tree
Date: Tue, 01 Dec 2009 12:13:00 -0800
Message-ID: <200912012013.nB1KD0Tk007617@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54659 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752340AbZLAUNX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2009 15:13:23 -0500
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id nB1KD0gl008306
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 1 Dec 2009 12:13:01 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     linux-next-git-rejects-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects-git-rejects.patch

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
Subject: linux-next-git-rejects-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/musb/musb_gadget.c |   27 ---------------------------
 fs/9p/cache.c                  |    4 ----
 kernel/Makefile                |    4 ----
 kernel/slow-work.c             |    8 --------
 4 files changed, 43 deletions(-)

diff -puN drivers/usb/musb/musb_gadget.c~linux-next-git-rejects-git-rejects drivers/usb/musb/musb_gadget.c
--- a/drivers/usb/musb/musb_gadget.c~linux-next-git-rejects-git-rejects
+++ a/drivers/usb/musb/musb_gadget.c
@@ -429,18 +429,6 @@ void musb_g_tx(struct musb *musb, u8 epn
 	DBG(4, "<== %s, txcsr %04x\n", musb_ep->end_point.name, csr);
 
 	dma = is_dma_capable() ? musb_ep->dma : NULL;
-<<<<<<< HEAD:drivers/usb/musb/musb_gadget.c
-	do {
-		/* REVISIT for high bandwidth, MUSB_TXCSR_P_INCOMPTX
-		 * probably rates reporting as a host error
-		 */
-		if (csr & MUSB_TXCSR_P_SENTSTALL) {
-			csr |= MUSB_TXCSR_P_WZC_BITS;
-			csr &= ~MUSB_TXCSR_P_SENTSTALL;
-			musb_writew(epio, MUSB_TXCSR, csr);
-			break;
-		}
-=======
 
 	/*
 	 * REVISIT: for high bandwidth, MUSB_TXCSR_P_INCOMPTX
@@ -469,7 +457,6 @@ void musb_g_tx(struct musb *musb, u8 epn
 		DBG(5, "%s dma still busy?\n", musb_ep->end_point.name);
 		return;
 	}
->>>>>>> FETCH_HEAD:drivers/usb/musb/musb_gadget.c
 
 	if (request) {
 		u8	is_dma = 0;
@@ -1256,19 +1243,6 @@ int musb_gadget_set_halt(struct usb_ep *
 			    ep->name);
 			status = -EAGAIN;
 			goto done;
-<<<<<<< HEAD:drivers/usb/musb/musb_gadget.c
-		}
-		/* Cannot portably stall with non-empty FIFO */
-		if (musb_ep->is_in) {
-			csr = musb_readw(epio, MUSB_TXCSR);
-			if (csr & MUSB_TXCSR_FIFONOTEMPTY) {
-				DBG(3, "FIFO busy, cannot halt %s\n", ep->name);
-				status = -EAGAIN;
-				goto done;
-			}
-		}
-	}
-=======
 		}
 		/* Cannot portably stall with non-empty FIFO */
 		if (musb_ep->is_in) {
@@ -1281,7 +1255,6 @@ int musb_gadget_set_halt(struct usb_ep *
 		}
 	} else
 		musb_ep->wedged = 0;
->>>>>>> FETCH_HEAD:drivers/usb/musb/musb_gadget.c
 
 	/* set/clear the stall and toggle bits */
 	DBG(2, "%s: %s stall\n", ep->name, value ? "set" : "clear");
diff -puN fs/9p/cache.c~linux-next-git-rejects-git-rejects fs/9p/cache.c
--- a/fs/9p/cache.c~linux-next-git-rejects-git-rejects
+++ a/fs/9p/cache.c
@@ -343,9 +343,6 @@ int __v9fs_fscache_release_page(struct p
 
 	BUG_ON(!vcookie->fscache);
 
-<<<<<<< HEAD:fs/9p/cache.c
-	return fscache_maybe_release_page(vcookie->fscache, page, gfp);
-=======
 	if (PageFsCache(page)) {
 		if (fscache_check_page_write(vcookie->fscache, page)) {
 			if (!(gfp & __GFP_WAIT))
@@ -358,7 +355,6 @@ int __v9fs_fscache_release_page(struct p
 	}
 
 	return 1;
->>>>>>> FETCH_HEAD:fs/9p/cache.c
 }
 
 void __v9fs_fscache_invalidate_page(struct page *page)
diff -puN kernel/Makefile~linux-next-git-rejects-git-rejects kernel/Makefile
--- a/kernel/Makefile~linux-next-git-rejects-git-rejects
+++ a/kernel/Makefile
@@ -96,13 +96,9 @@ obj-$(CONFIG_TRACING) += trace/
 obj-$(CONFIG_X86_DS) += trace/
 obj-$(CONFIG_RING_BUFFER) += trace/
 obj-$(CONFIG_SMP) += sched_cpupri.o
-obj-$(CONFIG_SLOW_WORK) += slow-work.o
-<<<<<<< HEAD:kernel/Makefile
 obj-$(CONFIG_SLOW_WORK_DEBUG) += slow-work-debugfs.o
-=======
 obj-$(CONFIG_SLOW_WORK_PROC) += slow-work-proc.o
 obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
->>>>>>> FETCH_HEAD:kernel/Makefile
 obj-$(CONFIG_PERF_EVENTS) += perf_event.o
 obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 
diff -puN kernel/slow-work.c~linux-next-git-rejects-git-rejects kernel/slow-work.c
--- a/kernel/slow-work.c~linux-next-git-rejects-git-rejects
+++ a/kernel/slow-work.c
@@ -317,13 +317,9 @@ auto_requeue:
 	else
 		list_add_tail(&work->link, &slow_work_queue);
 	spin_unlock_irq(&slow_work_queue_lock);
-<<<<<<< HEAD:kernel/slow-work.c
-	slow_work_clear_thread_processing(id);
-=======
 #ifdef CONFIG_MODULES
 	slow_work_thread_processing[id] = NULL;
 #endif
->>>>>>> FETCH_HEAD:kernel/slow-work.c
 	return true;
 }
 
@@ -1003,11 +999,7 @@ static void slow_work_wait_for_items(str
 
 	remove_wait_queue(&slow_work_unreg_wq, &myself);
 	mutex_unlock(&slow_work_unreg_sync_lock);
-<<<<<<< HEAD:kernel/slow-work.c
-#endif /* CONFIG_MODULES */
-=======
 #endif
->>>>>>> FETCH_HEAD:kernel/slow-work.c
 }
 
 /**
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-media-dvb-dvb-core-dvb_frontendc-needs-semaphoreh.patch
linux-next.patch
linux-next-git-rejects-git-rejects.patch
__builtin_object_size-unavailable-on-gcc-402.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-compiler-gcc4h-gcc-402-doesnt-understand-__builtin_object_size.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
acpi-remove-nid_inval.patch
drivers-acpi-acpi_padc-squish-warning.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-checkpatch-fixes.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
kbuild-generate-modulesbuiltin-fix-2-checkpatch-fixes.patch
drivers-leds-leds-ss4200c-fix-return-statement.patch
mtd-nand-fix-multi-chip-suspend-problem-fix.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
atmel_serial-add-poll_get_char-and-poll_put_char-uart_ops.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch
aoe-switch-to-the-new-bio_flush_dcache_pages-interface.patch
wusb-use-sizeof-struct-rather-than-pointer.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
readahead-add-blk_run_backing_dev.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process-fix.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42-checkpatch-fixes.patch
mm-mlocking-in-try_to_unmap_one-fix-fix.patch
mm-memory_hotplug-make-offline_pages-static.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm-cleanup.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch
rwsem-fix-rwsem_is_locked-bugs-fix.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-checkpatch-fixes.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-rename.patch
errh-add-helper-function-to-simplify-pointer-error-checking-fix.patch
msm_sdccc-add-missing-include-fix-compilation-checkpatch-fixes.patch
blackfin-sd-host-controller-driver-fix.patch
blackfin-sd-host-controller-driver-fix-fix.patch
crc32-minor-optimizations-and-cleanup-checkpatch-fixes.patch
hwmon-w83627ehf-updates-checkpatch-fixes.patch
spi-controller-driver-for-designware-spi-core-fix.patch
spidev-use-declare_bitmap-instead-of-declaring-the-array-checkpatch-fixes.patch
drivers-gpio-pca953xc-add-interrupt-handling-capability-fix.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2-fix-3.patch
ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock-checkpatch-fixes.patch
memcg-coalesce-charging-via-percpu-storage-fix.patch
char-cyclades-fix-compiler-warning.patch
aio-dont-zero-out-the-pages-array-inside-struct-dio-fix.patch
direct-io-cleanup-blockdev_direct_io-locking-checkpatch-fixes.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
drivers-media-video-cx23885-needs-kfifo-updates.patch
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

