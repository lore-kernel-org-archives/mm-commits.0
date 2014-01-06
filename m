From: akpm@linux-foundation.org
Subject: + ufs-sb-mutex-merge-mutex_destroy.patch added to -mm tree
Date: Mon, 06 Jan 2014 15:00:53 -0800
Message-ID: <52cb35a5.G0R1oDIaNme2ATvb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49032 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756783AbaAFXAy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jan 2014 18:00:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dushistov@mail.ru, fabf@skynet.be

Subject: + ufs-sb-mutex-merge-mutex_destroy.patch added to -mm tree
To: fabf@skynet.be,dushistov@mail.ru
From: akpm@linux-foundation.org
Date: Mon, 06 Jan 2014 15:00:53 -0800


The patch titled
     Subject: ufs: sb mutex merge + mutex_destroy
has been added to the -mm tree.  Its filename is
     ufs-sb-mutex-merge-mutex_destroy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ufs-sb-mutex-merge-mutex_destroy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ufs-sb-mutex-merge-mutex_destroy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/balloc.c |   30 +++++++++++++++---------------
 fs/ufs/ialloc.c |   17 ++++++++---------
 fs/ufs/super.c  |   13 ++-----------
 fs/ufs/ufs.h    |    1 -
 4 files changed, 25 insertions(+), 36 deletions(-)

diff -puN fs/ufs/balloc.c~ufs-sb-mutex-merge-mutex_destroy fs/ufs/balloc.c
--- a/fs/ufs/balloc.c~ufs-sb-mutex-merge-mutex_destroy
+++ a/fs/ufs/balloc.c
@@ -54,7 +54,7 @@ void ufs_free_fragments(struct inode *in
 	if (ufs_fragnum(fragment) + count > uspi->s_fpg)
 		ufs_error (sb, "ufs_free_fragments", "internal error");
 	
-	mutex_lock(&UFS_SB(sb)->s_lock);
+	lock_ufs(sb);
 	
 	cgno = ufs_dtog(uspi, fragment);
 	bit = ufs_dtogd(uspi, fragment);
@@ -118,12 +118,12 @@ void ufs_free_fragments(struct inode *in
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
@@ -155,7 +155,7 @@ void ufs_free_blocks(struct inode *inode
 		goto failed;
 	}
 
-	mutex_lock(&UFS_SB(sb)->s_lock);
+	lock_ufs(sb);
 	
 do_more:
 	overflow = 0;
@@ -215,12 +215,12 @@ do_more:
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
@@ -361,7 +361,7 @@ u64 ufs_new_fragments(struct inode *inod
 	usb1 = ubh_get_usb_first(uspi);
 	*err = -ENOSPC;
 
-	mutex_lock(&UFS_SB(sb)->s_lock);
+	lock_ufs(sb);
 	tmp = ufs_data_ptr_to_cpu(sb, p);
 
 	if (count + ufs_fragnum(fragment) > uspi->s_fpb) {
@@ -382,19 +382,19 @@ u64 ufs_new_fragments(struct inode *inod
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
@@ -403,7 +403,7 @@ u64 ufs_new_fragments(struct inode *inod
 	 * There is not enough space for user on the device
 	 */
 	if (!capable(CAP_SYS_RESOURCE) && ufs_freespace(uspi, UFS_MINFREE) <= 0) {
-		mutex_unlock(&UFS_SB(sb)->s_lock);
+		unlock_ufs(sb);
 		UFSD("EXIT (FAILED)\n");
 		return 0;
 	}
@@ -428,7 +428,7 @@ u64 ufs_new_fragments(struct inode *inod
 			ufs_clear_frags(inode, result + oldcount,
 					newcount - oldcount, locked_page != NULL);
 		}
-		mutex_unlock(&UFS_SB(sb)->s_lock);
+		unlock_ufs(sb);
 		UFSD("EXIT, result %llu\n", (unsigned long long)result);
 		return result;
 	}
@@ -443,7 +443,7 @@ u64 ufs_new_fragments(struct inode *inod
 						fragment + count);
 		ufs_clear_frags(inode, result + oldcount, newcount - oldcount,
 				locked_page != NULL);
-		mutex_unlock(&UFS_SB(sb)->s_lock);
+		unlock_ufs(sb);
 		UFSD("EXIT, result %llu\n", (unsigned long long)result);
 		return result;
 	}
@@ -481,7 +481,7 @@ u64 ufs_new_fragments(struct inode *inod
 		*err = 0;
 		UFS_I(inode)->i_lastfrag = max(UFS_I(inode)->i_lastfrag,
 						fragment + count);
-		mutex_unlock(&UFS_SB(sb)->s_lock);
+		unlock_ufs(sb);
 		if (newcount < request)
 			ufs_free_fragments (inode, result + newcount, request - newcount);
 		ufs_free_fragments (inode, tmp, oldcount);
@@ -489,7 +489,7 @@ u64 ufs_new_fragments(struct inode *inod
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
@@ -71,11 +71,11 @@ void ufs_free_inode (struct inode * inod
 	
 	ino = inode->i_ino;
 
-	mutex_lock(&UFS_SB(sb)->s_lock);
+	lock_ufs(sb);
 
 	if (!((ino > 1) && (ino < (uspi->s_ncg * uspi->s_ipg )))) {
 		ufs_warning(sb, "ufs_free_inode", "reserved inode or nonexistent inode %u\n", ino);
-		mutex_unlock(&UFS_SB(sb)->s_lock);
+		unlock_ufs(sb);
 		return;
 	}
 	
@@ -83,7 +83,7 @@ void ufs_free_inode (struct inode * inod
 	bit = ufs_inotocgoff (ino);
 	ucpi = ufs_load_cylinder (sb, cg);
 	if (!ucpi) {
-		mutex_unlock(&UFS_SB(sb)->s_lock);
+		unlock_ufs(sb);
 		return;
 	}
 	ucg = ubh_get_ucg(UCPI_UBH(ucpi));
@@ -117,7 +117,7 @@ void ufs_free_inode (struct inode * inod
 		ubh_sync_block(UCPI_UBH(ucpi));
 	
 	ufs_mark_sb_dirty(sb);
-	mutex_unlock(&UFS_SB(sb)->s_lock);
+	unlock_ufs(sb);
 	UFSD("EXIT\n");
 }
 
@@ -197,7 +197,7 @@ struct inode *ufs_new_inode(struct inode
 	uspi = sbi->s_uspi;
 	usb1 = ubh_get_usb_first(uspi);
 
-	mutex_lock(&sbi->s_lock);
+	lock_ufs(sb);
 
 	/*
 	 * Try to place the inode in its parent directory
@@ -332,21 +332,20 @@ cg_found:
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
@@ -699,7 +699,6 @@ static int ufs_sync_fs(struct super_bloc
 	unsigned flags;
 
 	lock_ufs(sb);
-	mutex_lock(&UFS_SB(sb)->s_lock);
 
 	UFSD("ENTER\n");
 
@@ -717,7 +716,6 @@ static int ufs_sync_fs(struct super_bloc
 	ufs_put_cstotal(sb);
 
 	UFSD("EXIT\n");
-	mutex_unlock(&UFS_SB(sb)->s_lock);
 	unlock_ufs(sb);
 
 	return 0;
@@ -762,6 +760,7 @@ static void ufs_put_super(struct super_b
 
 	ubh_brelse_uspi (sbi->s_uspi);
 	kfree (sbi->s_uspi);
+	mutex_destroy(&sbi->mutex);
 	kfree (sbi);
 	sb->s_fs_info = NULL;
 	UFSD("EXIT\n");
@@ -805,7 +804,6 @@ static int ufs_fill_super(struct super_b
 	}
 #endif
 	mutex_init(&sbi->mutex);
-	mutex_init(&sbi->s_lock);
 	spin_lock_init(&sbi->work_lock);
 	INIT_DELAYED_WORK(&sbi->sync_work, delayed_sync_fs);
 	/*
@@ -1262,6 +1260,7 @@ failed:
 	if (ubh)
 		ubh_brelse_uspi (uspi);
 	kfree (uspi);
+	mutex_destroy(&sbi->mutex);
 	kfree(sbi);
 	sb->s_fs_info = NULL;
 	UFSD("EXIT (FAILED)\n");
@@ -1281,7 +1280,6 @@ static int ufs_remount (struct super_blo
 	unsigned flags;
 
 	lock_ufs(sb);
-	mutex_lock(&UFS_SB(sb)->s_lock);
 	uspi = UFS_SB(sb)->s_uspi;
 	flags = UFS_SB(sb)->s_flags;
 	usb1 = ubh_get_usb_first(uspi);
@@ -1295,7 +1293,6 @@ static int ufs_remount (struct super_blo
 	new_mount_opt = 0;
 	ufs_set_opt (new_mount_opt, ONERROR_LOCK);
 	if (!ufs_parse_options (data, &new_mount_opt)) {
-		mutex_unlock(&UFS_SB(sb)->s_lock);
 		unlock_ufs(sb);
 		return -EINVAL;
 	}
@@ -1303,14 +1300,12 @@ static int ufs_remount (struct super_blo
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
@@ -1335,7 +1330,6 @@ static int ufs_remount (struct super_blo
 #ifndef CONFIG_UFS_FS_WRITE
 		printk("ufs was compiled with read-only support, "
 		"can't be mounted as read-write\n");
-		mutex_unlock(&UFS_SB(sb)->s_lock);
 		unlock_ufs(sb);
 		return -EINVAL;
 #else
@@ -1345,13 +1339,11 @@ static int ufs_remount (struct super_blo
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
@@ -1359,7 +1351,6 @@ static int ufs_remount (struct super_blo
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

drivers-block-kconfig-update-ram-block-device-module-name.patch
ufs-sb-mutex-merge-mutex_destroy.patch
documentation-blockdev-ramdisktxt-updates.patch
documentation-filesystems-00-index-updates.patch

