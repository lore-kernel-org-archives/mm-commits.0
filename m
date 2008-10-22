From: akpm@linux-foundation.org
Subject: + nilfs2-super-block-operations-fix.patch added to -mm tree
Date: Wed, 22 Oct 2008 15:06:42 -0700
Message-ID: <200810222221.m9MMLPe7006643@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50946 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752029AbYJVWV7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Oct 2008 18:21:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, konishi.ryusuke@lab.ntt.co.jp


The patch titled
     nilfs2-super-block-operations-fix
has been added to the -mm tree.  Its filename is
     nilfs2-super-block-operations-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nilfs2-super-block-operations-fix
From: Andrew Morton <akpm@linux-foundation.org>

Update for linux-next changes.

Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/super.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/nilfs2/super.c~nilfs2-super-block-operations-fix fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~nilfs2-super-block-operations-fix
+++ a/fs/nilfs2/super.c
@@ -1125,7 +1125,7 @@ nilfs_get_sb(struct file_system_type *fs
 	struct the_nilfs *nilfs = NULL;
 	int err, need_to_close = 1;
 
-	sd.bdev = open_bdev_excl(dev_name, flags, fs_type);
+	sd.bdev = open_bdev_exclusive(dev_name, flags, fs_type);
 	if (IS_ERR(sd.bdev))
 		return PTR_ERR(sd.bdev);
 
@@ -1190,9 +1190,9 @@ nilfs_get_sb(struct file_system_type *fs
 			  nilfs_set_bdev_super, &sd);
 		deactivate_super(s);
 		/*
-		 * Although deactivate_super() invokes close_bdev_excl() at
+		 * Although deactivate_super() invokes close_bdev_exclusive() at
 		 * kill_block_super().  Here, s is an existent mount; we need
-		 * one more close_bdev_excl() call.
+		 * one more close_bdev_exclusive() call.
 		 */
 		s = s2;
 		if (IS_ERR(s))
@@ -1219,20 +1219,20 @@ nilfs_get_sb(struct file_system_type *fs
 	up(&sd.bdev->bd_mount_sem);
 	put_nilfs(nilfs);
 	if (need_to_close)
-		close_bdev_excl(sd.bdev);
+		close_bdev_exclusive(sd.bdev, flags);
 	return simple_set_mnt(mnt, s);
 
  error_s:
 	up(&sd.bdev->bd_mount_sem);
 	if (nilfs)
 		put_nilfs(nilfs);
-	close_bdev_excl(sd.bdev);
+	close_bdev_exclusive(sd.bdev, flags);
 	return PTR_ERR(s);
 
  failed_unlock:
 	up(&sd.bdev->bd_mount_sem);
  failed:
-	close_bdev_excl(sd.bdev);
+	close_bdev_exclusive(sd.bdev, flags);
 
 	return err;
 
@@ -1244,7 +1244,7 @@ nilfs_get_sb(struct file_system_type *fs
 	up_write(&s->s_umount);
 	deactivate_super(s);
 	/*
-	 * deactivate_super() invokes close_bdev_excl().
+	 * deactivate_super() invokes close_bdev_exclusive().
 	 * We must finish all post-cleaning before this call;
 	 * put_nilfs() and unlocking bd_mount_sem need the block device.
 	 */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
memcg-fix-page_cgroup-allocation.patch
epoll-avoid-double-inserts-in-case-of-efault-checkpatch-fixes.patch
freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix.patch
fs-remove-prepare_write-commit_write-fix.patch
mm-write_cache_pages-writepage-error-fix.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
linux-next-fix-vfs-for-about-to-be-merged-ext3-patches.patch
git-tests-git-rejects.patch
revert-i7300_idle-driver-v155.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module-checkpatch-fixes.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
leds-driver-for-hp-harddisk-protection-led-fix-fix-2.patch
drivers-rtc-rtc-ds1286c-is-borked.patch
drivers-rtc-rtc-m48t35c-is-borked-too.patch
drivers-net-sfc-falconc-fix-min-warnings.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
init-properly-placing-noinline-keyword.patch
spi_gpio-driver-cleanups.patch
add-new-framebuffer-driver-for-fujitsu-mb862xx-gdcs-fix.patch
ext3-add-support-for-non-native-signed-unsigned-htree-hash-algorithms-checkpatch-fixes.patch
devpts-fix-unused-function-warning.patch
w1-export-w1_read_8-function-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
reiser4-broke.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

