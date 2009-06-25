From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Thu, 25 Jun 2009 10:24:34 -0700
Message-ID: <200906251724.n5PHOYoi018231@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752600AbZFYRYv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jun 2009 13:24:51 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n5PHOZrj015222
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2009 10:24:36 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/eeepc-laptop.c |   19 --------------
 fs/fs-writeback.c                   |   35 --------------------------
 2 files changed, 54 deletions(-)

diff -puN drivers/platform/x86/eeepc-laptop.c~linux-next-git-rejects drivers/platform/x86/eeepc-laptop.c
--- a/drivers/platform/x86/eeepc-laptop.c~linux-next-git-rejects
+++ a/drivers/platform/x86/eeepc-laptop.c
@@ -191,13 +191,8 @@ static struct key_entry eeepc_keymap[] =
  */
 static int eeepc_hotk_add(struct acpi_device *device);
 static int eeepc_hotk_remove(struct acpi_device *device, int type);
-<<<<<<< HEAD:drivers/platform/x86/eeepc-laptop.c
-static int eeepc_hotk_resume(struct acpi_device *device);
-static void eeepc_hotk_notify(struct acpi_device *device, u32 event);
-=======
 static void eeepc_hotk_notify(struct acpi_device *device, u32 event);
 static int eeepc_hotk_resume(struct acpi_device *device);
->>>>>>> FETCH_HEAD:drivers/platform/x86/eeepc-laptop.c
 
 static const struct acpi_device_id eeepc_device_ids[] = {
 	{EEEPC_HOTK_HID, 0},
@@ -213,13 +208,8 @@ static struct acpi_driver eeepc_hotk_dri
 	.ops = {
 		.add = eeepc_hotk_add,
 		.remove = eeepc_hotk_remove,
-<<<<<<< HEAD:drivers/platform/x86/eeepc-laptop.c
-		.resume = eeepc_hotk_resume,
-		.notify = eeepc_hotk_notify,
-=======
 		.notify = eeepc_hotk_notify,
 		.resume = eeepc_hotk_resume,
->>>>>>> FETCH_HEAD:drivers/platform/x86/eeepc-laptop.c
 	},
 };
 
@@ -1197,15 +1187,6 @@ static int __init eeepc_laptop_init(void
 
 	eeepc_enable_camera();
 
-<<<<<<< HEAD:drivers/platform/x86/eeepc-laptop.c
-	result = eeepc_hwmon_init(dev);
-	if (result)
-		goto fail_hwmon;
-
-	eeepc_enable_camera();
-
-=======
->>>>>>> FETCH_HEAD:drivers/platform/x86/eeepc-laptop.c
 	/* Register platform stuff */
 	result = platform_driver_register(&platform_driver);
 	if (result)
diff -puN fs/fs-writeback.c~linux-next-git-rejects fs/fs-writeback.c
--- a/fs/fs-writeback.c~linux-next-git-rejects
+++ a/fs/fs-writeback.c
@@ -952,34 +952,6 @@ writeback_single_inode(struct inode *ino
 }
 
 /*
-<<<<<<< HEAD:fs/fs-writeback.c
- * Write out a superblock's list of dirty inodes.  A wait will be performed
- * upon no inodes, all inodes or the final one, depending upon sync_mode.
- *
- * If older_than_this is non-NULL, then only write out inodes which
- * had their first dirtying at a time earlier than *older_than_this.
- *
- * If we're a pdflush thread, then implement pdflush collision avoidance
- * against the entire list.
- *
- * If `bdi' is non-zero then we're being asked to writeback a specific queue.
- * This function assumes that the blockdev superblock's inodes are backed by
- * a variety of queues, so all inodes are searched.  For other superblocks,
- * assume that all inodes are backed by the same queue.
- *
- * FIXME: this linear search could get expensive with many fileystems.  But
- * how to fix?  We need to go from an address_space to all inodes which share
- * a queue with that address_space.  (Easy: have a global "dirty superblocks"
- * list).
- *
- * The inodes to be written are parked on sb->s_io.  They are moved back onto
- * sb->s_dirty as they are selected for writing.  This way, none can be missed
- * on the writer throttling path, and we get decent balancing between many
- * throttled threads: we don't want them all piling up on inode_sync_wait.
- */
-void generic_sync_sb_inodes(struct super_block *sb,
-				struct writeback_control *wbc)
-=======
  * Write out an inode's dirty pages.  Called under inode_lock.  Either the
  * caller has ref on the inode (either via __iget or via syscall against an fd)
  * or the inode has I_WILL_FREE set (via generic_forget_inode)
@@ -1026,7 +998,6 @@ __writeback_single_inode(struct inode *i
 static void generic_sync_wb_inodes(struct bdi_writeback *wb,
 				   struct super_block *sb,
 				   struct writeback_control *wbc)
->>>>>>> FETCH_HEAD:fs/fs-writeback.c
 {
 	const int is_blkdev_sb = sb_is_blkdev_sb(sb);
 	const unsigned long start = jiffies;	/* livelock avoidance */
@@ -1089,13 +1060,7 @@ static void generic_sync_wb_inodes(struc
 		BUG_ON(inode->i_state & (I_FREEING | I_CLEAR));
 		__iget(inode);
 		pages_skipped = wbc->pages_skipped;
-<<<<<<< HEAD:fs/fs-writeback.c
-		writeback_single_inode(inode, wbc);
-		if (current_is_pdflush())
-			writeback_release(bdi);
-=======
 		__writeback_single_inode(inode, wbc);
->>>>>>> FETCH_HEAD:fs/fs-writeback.c
 		if (wbc->pages_skipped != pages_skipped) {
 			/*
 			 * writeback is not making progress due to locked
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
3x59x-fix-pci-resource-management-checkpatch-fixes.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
arch-x86-oprofile-op_model_amdc-fix-op_amd_handle_ibs-return-type.patch
drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch
proc-connector-add-event-for-process-becoming-session-leader-checkpatch-fixes.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
n_hdlc-add-buffer-flushing-checkpatch-fixes.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

