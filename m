From: akpm@linux-foundation.org
Subject: [merged] ufs-sb-mutex-merge-mutex_destroy.patch removed from -mm
 tree
Date: Mon, 09 Jun 2014 12:42:01 -0700
Message-ID: <53960e09.u4Rl4SJgdUYkZR6B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54425 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaFITmC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:42:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jet.chen@intel.com, fengguang.wu@intel.com, dushistov@mail.ru, fabf@skynet.be

Subject: [merged] ufs-sb-mutex-merge-mutex_destroy.patch removed from -mm tree
To: fabf@skynet.be,dushistov@mail.ru,fengguang.wu@intel.com,jet.chen@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:42:01 -0700


The patch titled
     Subject: ufs: sb mutex merge + mutex_destroy
has been removed from the -mm tree.  Its filename was
     ufs-sb-mutex-merge-mutex_destroy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: ufs: sb mutex merge + mutex_destroy

788257d6101d9 ("ufs: remove the BKL") replaced BKL with mutex protection
using functions lock_ufs, unlock_ufs and struct mutex 'mutex' in sb_info.

b6963327e052 ("ufs: drop lock/unlock super") removed lock/unlock super and
added struct mutex 's_lock' in sb_info.

Those 2 mutexes are generally locked/unlocked at the same time except in
allocation (balloc, ialloc).

This patch merges the 2 mutexes and propagates first commit solution.  It
also adds mutex destruction before kfree during ufs_fill_super failure and
ufs_put_super.

[akpm@linux-foundation.org: avoid ifdefs, return -EROFS not -EINVAL]
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: "Chen, Jet" <jet.chen@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/balloc.c |   30 +++++++++++++++---------------
 fs/ufs/ialloc.c |   17 ++++++++---------
 fs/ufs/super.c  |   28 ++++++++++------------------
 fs/ufs/ufs.h    |    1 -
 4 files changed, 33 insertions(+), 43 deletions(-)

diff -puN fs/ufs/balloc.c~ufs-sb-mutex-merge-mutex_destroy fs/ufs/balloc.c
--- a/fs/ufs/balloc.c~ufs-sb-mutex-merge-mutex_destroy
+++ a/fs/ufs/balloc.c
@@ -52,7 +52,7 @@ void ufs_free_fragments(struct inode *in
 	if (ufs_fragnum(fragment) + count > uspi->s_fpg)
 		ufs_error (sb, "ufs_free_fragments", "internal error");
 	
-	mutex_lock(&UFS_SB(sb)->s_lock);
+	lock_ufs(sb);
 	
 	cgno = ufs_dtog(uspi, fragment);
 	bit = ufs_dtogd(uspi, fragment);
@@ -116,12 +116,12 @@ void ufs_free_fragments(struct inode *in
 		ubh_sync_block(UCPI_UBH(ucpi));
 	ufs_mark_sb_dirty(sb);
 	
-	mutex_unlock(&UFS_SB(sb)->s_lock);
+	unlock_ufs(sb);
 	UFSD("EXIT\n");
 	return;
 
 failed:
-	mutex_unlock(&UFS_SB(sb)->s_lock);
+	unlock_ufs(sb);
 	UFSD("EXIT (FAILED)\n");
 	return;
 }
@@ -151,7 +151,7 @@ void ufs_free_blocks(struct inode *inode
 		goto failed;
 	}
 
-	mutex_lock(&UFS_SB(sb)->s_lock);
+	lock_ufs(sb);
 	
 do_more:
 	overflow = 0;
@@ -211,12 +211,12 @@ do_more:
 	}
 
 	ufs_mark_sb_dirty(sb);
-	mutex_unlock(&UFS_SB(sb)->s_lock);
+	unlock_ufs(sb);
 	UFSD("EXIT\n");
 	return;
 
 failed_unlock:
-	mutex_unlock(&UFS_SB(sb)->s_lock);
+	unlock_ufs(sb);
 failed:
 	UFSD("EXIT (FAILED)\n");
 	return;
@@ -357,7 +357,7 @@ u64 ufs_new_fragments(struct inode *inod
 	usb1 = ubh_get_usb_first(uspi);
 	*err = -ENOSPC;
 
-	mutex_lock(&UFS_SB(sb)->s_lock);
+	lock_ufs(sb);
 	tmp = ufs_data_ptr_to_cpu(sb, p);
 
 	if (count + ufs_fragnum(fragment) > uspi->s_fpb) {
@@ -378,19 +378,19 @@ u64 ufs_new_fragments(struct inode *inod
 				  "fragment %llu, tmp %llu\n",
 				  (unsigned long long)fragment,
 				  (unsigned long long)tmp);
-			mutex_unlock(&UFS_SB(sb)->s_lock);
+			unlock_ufs(sb);
 			return INVBLOCK;
 		}
 		if (fragment < UFS_I(inode)->i_lastfrag) {
 			UFSD("EXIT (ALREADY ALLOCATED)\n");
-			mutex_unlock(&UFS_SB(sb)->s_lock);
+			unlock_ufs(sb);
 			return 0;
 		}
 	}
 	else {
 		if (tmp) {
 			UFSD("EXIT (ALREADY ALLOCATED)\n");
-			mutex_unlock(&UFS_SB(sb)->s_lock);
+			unlock_ufs(sb);
 			return 0;
 		}
 	}
@@ -399,7 +399,7 @@ u64 ufs_new_fragments(struct inode *inod
 	 * There is not enough space for user on the device
 	 */
 	if (!capable(CAP_SYS_RESOURCE) && ufs_freespace(uspi, UFS_MINFREE) <= 0) {
-		mutex_unlock(&UFS_SB(sb)->s_lock);
+		unlock_ufs(sb);
 		UFSD("EXIT (FAILED)\n");
 		return 0;
 	}
@@ -424,7 +424,7 @@ u64 ufs_new_fragments(struct inode *inod
 			ufs_clear_frags(inode, result + oldcount,
 					newcount - oldcount, locked_page != NULL);
 		}
-		mutex_unlock(&UFS_SB(sb)->s_lock);
+		unlock_ufs(sb);
 		UFSD("EXIT, result %llu\n", (unsigned long long)result);
 		return result;
 	}
@@ -439,7 +439,7 @@ u64 ufs_new_fragments(struct inode *inod
 						fragment + count);
 		ufs_clear_frags(inode, result + oldcount, newcount - oldcount,
 				locked_page != NULL);
-		mutex_unlock(&UFS_SB(sb)->s_lock);
+		unlock_ufs(sb);
 		UFSD("EXIT, result %llu\n", (unsigned long long)result);
 		return result;
 	}
@@ -477,7 +477,7 @@ u64 ufs_new_fragments(struct inode *inod
 		*err = 0;
 		UFS_I(inode)->i_lastfrag = max(UFS_I(inode)->i_lastfrag,
 						fragment + count);
-		mutex_unlock(&UFS_SB(sb)->s_lock);
+		unlock_ufs(sb);
 		if (newcount < request)
 			ufs_free_fragments (inode, result + newcount, request - newcount);
 		ufs_free_fragments (inode, tmp, oldcount);
@@ -485,7 +485,7 @@ u64 ufs_new_fragments(struct inode *inod
 		return result;
 	}
 
-	mutex_unlock(&UFS_SB(sb)->s_lock);
+	unlock_ufs(sb);
 	UFSD("EXIT (FAILED)\n");
 	return 0;
 }		
diff -puN fs/ufs/ialloc.c~ufs-sb-mutex-merge-mutex_destroy fs/ufs/ialloc.c
--- a/fs/ufs/ialloc.c~ufs-sb-mutex-merge-mutex_destroy
+++ a/fs/ufs/ialloc.c
@@ -69,11 +69,11 @@ void ufs_free_inode (struct inode * inod
 	
 	ino = inode->i_ino;
 
-	mutex_lock(&UFS_SB(sb)->s_lock);
+	lock_ufs(sb);
 
 	if (!((ino > 1) && (ino < (uspi->s_ncg * uspi->s_ipg )))) {
 		ufs_warning(sb, "ufs_free_inode", "reserved inode or nonexistent inode %u\n", ino);
-		mutex_unlock(&UFS_SB(sb)->s_lock);
+		unlock_ufs(sb);
 		return;
 	}
 	
@@ -81,7 +81,7 @@ void ufs_free_inode (struct inode * inod
 	bit = ufs_inotocgoff (ino);
 	ucpi = ufs_load_cylinder (sb, cg);
 	if (!ucpi) {
-		mutex_unlock(&UFS_SB(sb)->s_lock);
+		unlock_ufs(sb);
 		return;
 	}
 	ucg = ubh_get_ucg(UCPI_UBH(ucpi));
@@ -115,7 +115,7 @@ void ufs_free_inode (struct inode * inod
 		ubh_sync_block(UCPI_UBH(ucpi));
 	
 	ufs_mark_sb_dirty(sb);
-	mutex_unlock(&UFS_SB(sb)->s_lock);
+	unlock_ufs(sb);
 	UFSD("EXIT\n");
 }
 
@@ -193,7 +193,7 @@ struct inode *ufs_new_inode(struct inode
 	sbi = UFS_SB(sb);
 	uspi = sbi->s_uspi;
 
-	mutex_lock(&sbi->s_lock);
+	lock_ufs(sb);
 
 	/*
 	 * Try to place the inode in its parent directory
@@ -328,21 +328,20 @@ cg_found:
 			sync_dirty_buffer(bh);
 		brelse(bh);
 	}
-
-	mutex_unlock(&sbi->s_lock);
+	unlock_ufs(sb);
 
 	UFSD("allocating inode %lu\n", inode->i_ino);
 	UFSD("EXIT\n");
 	return inode;
 
 fail_remove_inode:
-	mutex_unlock(&sbi->s_lock);
+	unlock_ufs(sb);
 	clear_nlink(inode);
 	iput(inode);
 	UFSD("EXIT (FAILED): err %d\n", err);
 	return ERR_PTR(err);
 failed:
-	mutex_unlock(&sbi->s_lock);
+	unlock_ufs(sb);
 	make_bad_inode(inode);
 	iput (inode);
 	UFSD("EXIT (FAILED): err %d\n", err);
diff -puN fs/ufs/super.c~ufs-sb-mutex-merge-mutex_destroy fs/ufs/super.c
--- a/fs/ufs/super.c~ufs-sb-mutex-merge-mutex_destroy
+++ a/fs/ufs/super.c
@@ -697,7 +697,6 @@ static int ufs_sync_fs(struct super_bloc
 	unsigned flags;
 
 	lock_ufs(sb);
-	mutex_lock(&UFS_SB(sb)->s_lock);
 
 	UFSD("ENTER\n");
 
@@ -715,7 +714,6 @@ static int ufs_sync_fs(struct super_bloc
 	ufs_put_cstotal(sb);
 
 	UFSD("EXIT\n");
-	mutex_unlock(&UFS_SB(sb)->s_lock);
 	unlock_ufs(sb);
 
 	return 0;
@@ -760,6 +758,7 @@ static void ufs_put_super(struct super_b
 
 	ubh_brelse_uspi (sbi->s_uspi);
 	kfree (sbi->s_uspi);
+	mutex_destroy(&sbi->mutex);
 	kfree (sbi);
 	sb->s_fs_info = NULL;
 	UFSD("EXIT\n");
@@ -786,6 +785,14 @@ static int ufs_fill_super(struct super_b
 	flags = 0;
 	
 	UFSD("ENTER\n");
+
+#ifndef CONFIG_UFS_FS_WRITE
+	if (!(sb->s_flags & MS_RDONLY)) {
+		printk("ufs was compiled with read-only support, "
+		       "can't be mounted as read-write\n");
+		return -EROFS;
+	}
+#endif
 		
 	sbi = kzalloc(sizeof(struct ufs_sb_info), GFP_KERNEL);
 	if (!sbi)
@@ -795,15 +802,7 @@ static int ufs_fill_super(struct super_b
 
 	UFSD("flag %u\n", (int)(sb->s_flags & MS_RDONLY));
 	
-#ifndef CONFIG_UFS_FS_WRITE
-	if (!(sb->s_flags & MS_RDONLY)) {
-		printk("ufs was compiled with read-only support, "
-		"can't be mounted as read-write\n");
-		goto failed;
-	}
-#endif
 	mutex_init(&sbi->mutex);
-	mutex_init(&sbi->s_lock);
 	spin_lock_init(&sbi->work_lock);
 	INIT_DELAYED_WORK(&sbi->sync_work, delayed_sync_fs);
 	/*
@@ -1257,6 +1256,7 @@ magic_found:
 	return 0;
 
 failed:
+	mutex_destroy(&sbi->mutex);
 	if (ubh)
 		ubh_brelse_uspi (uspi);
 	kfree (uspi);
@@ -1280,7 +1280,6 @@ static int ufs_remount (struct super_blo
 
 	sync_filesystem(sb);
 	lock_ufs(sb);
-	mutex_lock(&UFS_SB(sb)->s_lock);
 	uspi = UFS_SB(sb)->s_uspi;
 	flags = UFS_SB(sb)->s_flags;
 	usb1 = ubh_get_usb_first(uspi);
@@ -1294,7 +1293,6 @@ static int ufs_remount (struct super_blo
 	new_mount_opt = 0;
 	ufs_set_opt (new_mount_opt, ONERROR_LOCK);
 	if (!ufs_parse_options (data, &new_mount_opt)) {
-		mutex_unlock(&UFS_SB(sb)->s_lock);
 		unlock_ufs(sb);
 		return -EINVAL;
 	}
@@ -1302,14 +1300,12 @@ static int ufs_remount (struct super_blo
 		new_mount_opt |= ufstype;
 	} else if ((new_mount_opt & UFS_MOUNT_UFSTYPE) != ufstype) {
 		printk("ufstype can't be changed during remount\n");
-		mutex_unlock(&UFS_SB(sb)->s_lock);
 		unlock_ufs(sb);
 		return -EINVAL;
 	}
 
 	if ((*mount_flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY)) {
 		UFS_SB(sb)->s_mount_opt = new_mount_opt;
-		mutex_unlock(&UFS_SB(sb)->s_lock);
 		unlock_ufs(sb);
 		return 0;
 	}
@@ -1334,7 +1330,6 @@ static int ufs_remount (struct super_blo
 #ifndef CONFIG_UFS_FS_WRITE
 		printk("ufs was compiled with read-only support, "
 		"can't be mounted as read-write\n");
-		mutex_unlock(&UFS_SB(sb)->s_lock);
 		unlock_ufs(sb);
 		return -EINVAL;
 #else
@@ -1344,13 +1339,11 @@ static int ufs_remount (struct super_blo
 		    ufstype != UFS_MOUNT_UFSTYPE_SUNx86 &&
 		    ufstype != UFS_MOUNT_UFSTYPE_UFS2) {
 			printk("this ufstype is read-only supported\n");
-			mutex_unlock(&UFS_SB(sb)->s_lock);
 			unlock_ufs(sb);
 			return -EINVAL;
 		}
 		if (!ufs_read_cylinder_structures(sb)) {
 			printk("failed during remounting\n");
-			mutex_unlock(&UFS_SB(sb)->s_lock);
 			unlock_ufs(sb);
 			return -EPERM;
 		}
@@ -1358,7 +1351,6 @@ static int ufs_remount (struct super_blo
 #endif
 	}
 	UFS_SB(sb)->s_mount_opt = new_mount_opt;
-	mutex_unlock(&UFS_SB(sb)->s_lock);
 	unlock_ufs(sb);
 	return 0;
 }
diff -puN fs/ufs/ufs.h~ufs-sb-mutex-merge-mutex_destroy fs/ufs/ufs.h
--- a/fs/ufs/ufs.h~ufs-sb-mutex-merge-mutex_destroy
+++ a/fs/ufs/ufs.h
@@ -24,7 +24,6 @@ struct ufs_sb_info {
 	int work_queued; /* non-zero if the delayed work is queued */
 	struct delayed_work sync_work; /* FS sync delayed work */
 	spinlock_t work_lock; /* protects sync_work and work_queued */
-	struct mutex s_lock;
 };
 
 struct ufs_inode_info {
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

