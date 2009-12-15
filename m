From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Tue, 15 Dec 2009 13:48:15 -0800
Message-ID: <200912152148.nBFLmFp2014839@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932817AbZLOVsq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:48:46 -0500
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id nBFLmFOS003007
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 15 Dec 2009 13:48:16 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/eeepc-laptop.c |   55 --------------------------
 kernel/sched_idletask.c             |    5 --
 mm/memcontrol.c                     |    5 --
 3 files changed, 65 deletions(-)

diff -puN drivers/platform/x86/eeepc-laptop.c~linux-next-git-rejects drivers/platform/x86/eeepc-laptop.c
--- a/drivers/platform/x86/eeepc-laptop.c~linux-next-git-rejects
+++ a/drivers/platform/x86/eeepc-laptop.c
@@ -120,61 +120,6 @@ static const char *cm_setv[] = {
 	NULL, NULL, "PBPS", "TPDS"
 };
 
-<<<<<<< HEAD:drivers/platform/x86/eeepc-laptop.c
-#define EEEPC_EC	"\\_SB.PCI0.SBRG.EC0."
-
-#define EEEPC_EC_FAN_PWM	EEEPC_EC "SC02" /* Fan PWM duty cycle (%) */
-#define EEEPC_EC_SC02		0x63
-#define EEEPC_EC_FAN_HRPM	EEEPC_EC "SC05" /* High byte, fan speed (RPM) */
-#define EEEPC_EC_FAN_LRPM	EEEPC_EC "SC06" /* Low byte, fan speed (RPM) */
-#define EEEPC_EC_FAN_CTRL	EEEPC_EC "SFB3" /* Byte containing SF25  */
-#define EEEPC_EC_SFB3		0xD3
-
-/*
- * This is the main structure, we can use it to store useful information
- * about the hotk device
- */
-struct eeepc_hotk {
-	struct acpi_device *device;	/* the device we are in */
-	acpi_handle handle;		/* the handle of the hotk device */
-	u32 cm_supported;		/* the control methods supported
-					   by this BIOS */
-	uint init_flag;			/* Init flags */
-	u16 event_count[128];		/* count for each event */
-	struct input_dev *inputdev;
-	u16 *keycode_map;
-	struct rfkill *wlan_rfkill;
-	struct rfkill *bluetooth_rfkill;
-	struct rfkill *wwan3g_rfkill;
-	struct rfkill *wimax_rfkill;
-	struct hotplug_slot *hotplug_slot;
-	struct mutex hotplug_lock;
-};
-
-/* The actual device the driver binds to */
-static struct eeepc_hotk *ehotk;
-
-/* Platform device/driver */
-static int eeepc_hotk_thaw(struct device *device);
-static int eeepc_hotk_restore(struct device *device);
-
-static const struct dev_pm_ops eeepc_pm_ops = {
-	.thaw = eeepc_hotk_thaw,
-	.restore = eeepc_hotk_restore,
-};
-
-static struct platform_driver platform_driver = {
-	.driver = {
-		.name = EEEPC_HOTK_FILE,
-		.owner = THIS_MODULE,
-		.pm = &eeepc_pm_ops,
-	}
-};
-
-static struct platform_device *platform_device;
-
-=======
->>>>>>> FETCH_HEAD:drivers/platform/x86/eeepc-laptop.c
 struct key_entry {
 	char type;
 	u8 code;
diff -puN kernel/sched_idletask.c~linux-next-git-rejects kernel/sched_idletask.c
--- a/kernel/sched_idletask.c~linux-next-git-rejects
+++ a/kernel/sched_idletask.c
@@ -34,13 +34,8 @@ static struct task_struct *pick_next_tas
 static void
 dequeue_task_idle(struct rq *rq, struct task_struct *p, int sleep)
 {
-<<<<<<< HEAD:kernel/sched_idletask.c
 	raw_spin_unlock_irq(&rq->lock);
 	printk(KERN_ERR "bad: scheduling from the idle thread!\n");
-=======
-	spin_unlock_irq(&rq->lock);
-	pr_err("bad: scheduling from the idle thread!\n");
->>>>>>> FETCH_HEAD:kernel/sched_idletask.c
 	dump_stack();
 	raw_spin_lock_irq(&rq->lock);
 }
diff -puN mm/memcontrol.c~linux-next-git-rejects mm/memcontrol.c
--- a/mm/memcontrol.c~linux-next-git-rejects
+++ a/mm/memcontrol.c
@@ -1744,13 +1744,8 @@ int mem_cgroup_try_charge_swapin(struct 
 	 * KSM case which does need to charge the page.
 	 */
 	if (!PageSwapCache(page))
-<<<<<<< HEAD:mm/memcontrol.c
 		goto charge_cur_mm;
-	mem = try_get_mem_cgroup_from_swapcache(page);
-=======
-		return 0;
 	mem = try_get_mem_cgroup_from_page(page);
->>>>>>> FETCH_HEAD:mm/memcontrol.c
 	if (!mem)
 		goto charge_cur_mm;
 	*ptr = mem;
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

