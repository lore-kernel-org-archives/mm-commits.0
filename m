From: akpm@linux-foundation.org
Subject: + hpsa-use-msleep-instead-of-schedule_timeout-fix.patch added to -mm tree
Date: Tue, 08 Dec 2009 14:04:10 -0800
Message-ID: <200912082204.nB8M4Acv027408@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36745 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966334AbZLHWEg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2009 17:04:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com, achiang@hp.com, jens.axboe@oracle.com, mikem@beardog.cce.hp.com, scameron@beardog.cce.hp.com


The patch titled
     hpsa-use-msleep-instead-of-schedule_timeout-fix
has been added to the -mm tree.  Its filename is
     hpsa-use-msleep-instead-of-schedule_timeout-fix.patch

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
Subject: hpsa-use-msleep-instead-of-schedule_timeout-fix
From: Andrew Morton <akpm@linux-foundation.org>

msleep() does set_current_state() itself.

Cc: Alex Chiang <achiang@hp.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Mike Miller <mikem@beardog.cce.hp.com>
Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hpsa.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN drivers/scsi/hpsa.c~hpsa-use-msleep-instead-of-schedule_timeout-fix drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~hpsa-use-msleep-instead-of-schedule_timeout-fix
+++ a/drivers/scsi/hpsa.c
@@ -1949,7 +1949,6 @@ static int wait_for_device_to_become_rea
 		/* Wait for a bit.  do this first, because if we send
 		 * the TUR right away, the reset will just abort it.
 		 */
-		set_current_state(TASK_UNINTERRUPTIBLE);
 		msleep(1000 * waittime);
 		count++;
 
@@ -2838,7 +2837,6 @@ static __devinit int hpsa_message(struct
 		tag = readl(vaddr + SA5_REPLY_PORT_OFFSET);
 		if (HPSA_TAG_DISCARD_ERROR_BITS(tag) == paddr32)
 			break;
-		set_current_state(TASK_UNINTERRUPTIBLE);
 		msleep(HPSA_MSG_SEND_RETRY_INTERVAL_MSECS);
 	}
 
@@ -2952,7 +2950,6 @@ static __devinit int hpsa_hard_reset_con
 	pmcsr |= PCI_D3hot;
 	pci_write_config_word(pdev, pos + PCI_PM_CTRL, pmcsr);
 
-	set_current_state(TASK_UNINTERRUPTIBLE);
 	msleep(500);
 
 	/* enter the D0 power management state */
@@ -2960,7 +2957,6 @@ static __devinit int hpsa_hard_reset_con
 	pmcsr |= PCI_D0;
 	pci_write_config_word(pdev, pos + PCI_PM_CTRL, pmcsr);
 
-	set_current_state(TASK_UNINTERRUPTIBLE);
 	msleep(500);
 
 	/* Restore the PCI configuration space.  The Open CISS
@@ -3187,7 +3183,6 @@ static int hpsa_pci_init(struct ctlr_inf
 		scratchpad = readl(h->vaddr + SA5_SCRATCHPAD_OFFSET);
 		if (scratchpad == HPSA_FIRMWARE_READY)
 			break;
-		set_current_state(TASK_UNINTERRUPTIBLE);
 		msleep(HPSA_BOARD_READY_POLL_INTERVAL_MSECS);
 	}
 	if (scratchpad != HPSA_FIRMWARE_READY) {
@@ -3262,7 +3257,6 @@ static int hpsa_pci_init(struct ctlr_inf
 		if (!(readl(h->vaddr + SA5_DOORBELL) & CFGTBL_ChangeReq))
 			break;
 		/* delay and try again */
-		set_current_state(TASK_UNINTERRUPTIBLE);
 		msleep(10);
 	}
 
@@ -3302,7 +3296,6 @@ static int __devinit hpsa_init_one(struc
 
 		/* Some devices (notably the HP Smart Array 5i Controller)
 		   need a little pause here */
-		set_current_state(TASK_UNINTERRUPTIBLE);
 		msleep(HPSA_POST_RESET_PAUSE_MSECS);
 
 		/* Now try to get the controller to respond to a no-op */
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
proc_fops-convert-drivers-isdn-to-seq_file-fix2.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
atmel_serial-add-poll_get_char-and-poll_put_char-uart_ops.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch
hpsa-use-msleep-instead-of-schedule_timeout-fix.patch
aoe-switch-to-the-new-bio_flush_dcache_pages-interface.patch
drivers-staging-wlags49_h2-remove-cvs-metadata.patch
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
drivers-scsi-sym53c8xx_2-sym_gluec-rename-skip_spaces-to-sym_skip_spaces.patch
lib-introduce-strim-checkpatch-fixes.patch
msm_sdccc-add-missing-include-fix-compilation-checkpatch-fixes.patch
blackfin-sd-host-controller-driver-fix.patch
blackfin-sd-host-controller-driver-fix-fix.patch
blackfin-sd-host-controller-driver-fix-fix-fix.patch
crc32-minor-optimizations-and-cleanup-checkpatch-fixes.patch
hwmon-w83627ehf-updates-checkpatch-fixes.patch
lis3-update-documentation-to-match-latest-changes-fix.patch
spi-controller-driver-for-designware-spi-core-fix.patch
spidev-use-declare_bitmap-instead-of-declaring-the-array-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2-fix-3.patch
ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock-checkpatch-fixes.patch
memcg-coalesce-charging-via-percpu-storage-fix.patch
memcg-code-cleanrm-unused-variable-in-mem_cgroup_resize_limit-cleanup.patch
ipc-remove-unreachable-code-in-semc-fix.patch
char-cyclades-fix-compiler-warning.patch
ip2-remove-ifdef-module-from-ip2mainc-fix-2.patch
drivers-edac-amd64_edacc-fix-use-uninitialised-bug.patch
fs-cache-avoid-maybe-used-uninitialised-warning-on-variable.patch
aio-dont-zero-out-the-pages-array-inside-struct-dio-fix.patch
direct-io-cleanup-blockdev_direct_io-locking-checkpatch-fixes.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
drivers-media-video-cx23885-needs-kfifo-updates.patch
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

