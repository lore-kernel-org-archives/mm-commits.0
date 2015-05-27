From: akpm@linux-foundation.org
Subject: + ufs-restore-s_lock-mutex.patch added to -mm tree
Date: Wed, 27 May 2015 14:51:39 -0700
Message-ID: <55663c6b.GFKp3sJgMrMAVdJq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58036 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbbE0Vvk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 May 2015 17:51:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, Ian.Jackson@eu.citrix.com, dushistov@mail.ru, ian.campbell@citrix.com, jack@suse.cz, khoroshilov@ispras.ru, roger.pau@citrix.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ufs: restore s_lock mutex
has been added to the -mm tree.  Its filename is
     ufs-restore-s_lock-mutex.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ufs-restore-s_lock-mutex.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ufs-restore-s_lock-mutex.patch

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
Subject: fs/ufs: restore s_lock mutex

Commit 0244756edc4b98c ("ufs: sb mutex merge + mutex_destroy") generated
deadlocks in read/write mode on mkdir.

This patch partially reverts it keeping fixes by Andrew Morton and
mutex_destroy()

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Reported-by: Ian Campbell <ian.campbell@citrix.com>
Suggested-by: Jan Kara <jack@suse.cz>
Cc: Ian Campbell <ian.campbell@citrix.com>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Roger Pau Monne <roger.pau@citrix.com>
Cc: Ian Jackson <Ian.Jackson@eu.citrix.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/balloc.c |   34 +++++++++++++++++-----------------
 fs/ufs/ialloc.c |   16 ++++++++--------
 fs/ufs/super.c  |    9 +++++++++
 fs/ufs/ufs.h    |    1 +
 4 files changed, 35 insertions(+), 25 deletions(-)

diff -puN fs/ufs/balloc.c~ufs-restore-s_lock-mutex fs/ufs/balloc.c
--- a/fs/ufs/balloc.c~ufs-restore-s_lock-mutex
+++ a/fs/ufs/balloc.c
@@ -51,8 +51,8 @@ void ufs_free_fragments(struct inode *in
 	
 	if (ufs_fragnum(fragment) + count > uspi->s_fpg)
 		ufs_error (sb, "ufs_free_fragments", "internal error");
-	
-	lock_ufs(sb);
+
+	mutex_lock(&UFS_SB(sb)->s_lock);
 	
 	cgno = ufs_dtog(uspi, fragment);
 	bit = ufs_dtogd(uspi, fragment);
@@ -115,13 +115,13 @@ void ufs_free_fragments(struct inode *in
 	if (sb->s_flags & MS_SYNCHRONOUS)
 		ubh_sync_block(UCPI_UBH(ucpi));
 	ufs_mark_sb_dirty(sb);
-	
-	unlock_ufs(sb);
+
+	mutex_unlock(&UFS_SB(sb)->s_lock);
 	UFSD("EXIT\n");
 	return;
 
 failed:
-	unlock_ufs(sb);
+	mutex_unlock(&UFS_SB(sb)->s_lock);
 	UFSD("EXIT (FAILED)\n");
 	return;
 }
@@ -151,7 +151,7 @@ void ufs_free_blocks(struct inode *inode
 		goto failed;
 	}
 
-	lock_ufs(sb);
+	mutex_lock(&UFS_SB(sb)->s_lock);
 	
 do_more:
 	overflow = 0;
@@ -211,12 +211,12 @@ do_more:
 	}
 
 	ufs_mark_sb_dirty(sb);
-	unlock_ufs(sb);
+	mutex_unlock(&UFS_SB(sb)->s_lock);
 	UFSD("EXIT\n");
 	return;
 
 failed_unlock:
-	unlock_ufs(sb);
+	mutex_unlock(&UFS_SB(sb)->s_lock);
 failed:
 	UFSD("EXIT (FAILED)\n");
 	return;
@@ -357,7 +357,7 @@ u64 ufs_new_fragments(struct inode *inod
 	usb1 = ubh_get_usb_first(uspi);
 	*err = -ENOSPC;
 
-	lock_ufs(sb);
+	mutex_lock(&UFS_SB(sb)->s_lock);
 	tmp = ufs_data_ptr_to_cpu(sb, p);
 
 	if (count + ufs_fragnum(fragment) > uspi->s_fpb) {
@@ -378,19 +378,19 @@ u64 ufs_new_fragments(struct inode *inod
 				  "fragment %llu, tmp %llu\n",
 				  (unsigned long long)fragment,
 				  (unsigned long long)tmp);
-			unlock_ufs(sb);
+			mutex_unlock(&UFS_SB(sb)->s_lock);
 			return INVBLOCK;
 		}
 		if (fragment < UFS_I(inode)->i_lastfrag) {
 			UFSD("EXIT (ALREADY ALLOCATED)\n");
-			unlock_ufs(sb);
+			mutex_unlock(&UFS_SB(sb)->s_lock);
 			return 0;
 		}
 	}
 	else {
 		if (tmp) {
 			UFSD("EXIT (ALREADY ALLOCATED)\n");
-			unlock_ufs(sb);
+			mutex_unlock(&UFS_SB(sb)->s_lock);
 			return 0;
 		}
 	}
@@ -399,7 +399,7 @@ u64 ufs_new_fragments(struct inode *inod
 	 * There is not enough space for user on the device
 	 */
 	if (!capable(CAP_SYS_RESOURCE) && ufs_freespace(uspi, UFS_MINFREE) <= 0) {
-		unlock_ufs(sb);
+		mutex_unlock(&UFS_SB(sb)->s_lock);
 		UFSD("EXIT (FAILED)\n");
 		return 0;
 	}
@@ -424,7 +424,7 @@ u64 ufs_new_fragments(struct inode *inod
 			ufs_clear_frags(inode, result + oldcount,
 					newcount - oldcount, locked_page != NULL);
 		}
-		unlock_ufs(sb);
+		mutex_unlock(&UFS_SB(sb)->s_lock);
 		UFSD("EXIT, result %llu\n", (unsigned long long)result);
 		return result;
 	}
@@ -439,7 +439,7 @@ u64 ufs_new_fragments(struct inode *inod
 						fragment + count);
 		ufs_clear_frags(inode, result + oldcount, newcount - oldcount,
 				locked_page != NULL);
-		unlock_ufs(sb);
+		mutex_unlock(&UFS_SB(sb)->s_lock);
 		UFSD("EXIT, result %llu\n", (unsigned long long)result);
 		return result;
 	}
@@ -477,7 +477,7 @@ u64 ufs_new_fragments(struct inode *inod
 		*err = 0;
 		UFS_I(inode)->i_lastfrag = max(UFS_I(inode)->i_lastfrag,
 						fragment + count);
-		unlock_ufs(sb);
+		mutex_unlock(&UFS_SB(sb)->s_lock);
 		if (newcount < request)
 			ufs_free_fragments (inode, result + newcount, request - newcount);
 		ufs_free_fragments (inode, tmp, oldcount);
@@ -485,7 +485,7 @@ u64 ufs_new_fragments(struct inode *inod
 		return result;
 	}
 
-	unlock_ufs(sb);
+	mutex_unlock(&UFS_SB(sb)->s_lock);
 	UFSD("EXIT (FAILED)\n");
 	return 0;
 }		
diff -puN fs/ufs/ialloc.c~ufs-restore-s_lock-mutex fs/ufs/ialloc.c
--- a/fs/ufs/ialloc.c~ufs-restore-s_lock-mutex
+++ a/fs/ufs/ialloc.c
@@ -69,11 +69,11 @@ void ufs_free_inode (struct inode * inod
 	
 	ino = inode->i_ino;
 
-	lock_ufs(sb);
+	mutex_lock(&UFS_SB(sb)->s_lock);
 
 	if (!((ino > 1) && (ino < (uspi->s_ncg * uspi->s_ipg )))) {
 		ufs_warning(sb, "ufs_free_inode", "reserved inode or nonexistent inode %u\n", ino);
-		unlock_ufs(sb);
+		mutex_unlock(&UFS_SB(sb)->s_lock);
 		return;
 	}
 	
@@ -81,7 +81,7 @@ void ufs_free_inode (struct inode * inod
 	bit = ufs_inotocgoff (ino);
 	ucpi = ufs_load_cylinder (sb, cg);
 	if (!ucpi) {
-		unlock_ufs(sb);
+		mutex_unlock(&UFS_SB(sb)->s_lock);
 		return;
 	}
 	ucg = ubh_get_ucg(UCPI_UBH(ucpi));
@@ -115,7 +115,7 @@ void ufs_free_inode (struct inode * inod
 		ubh_sync_block(UCPI_UBH(ucpi));
 	
 	ufs_mark_sb_dirty(sb);
-	unlock_ufs(sb);
+	mutex_unlock(&UFS_SB(sb)->s_lock);
 	UFSD("EXIT\n");
 }
 
@@ -193,7 +193,7 @@ struct inode *ufs_new_inode(struct inode
 	sbi = UFS_SB(sb);
 	uspi = sbi->s_uspi;
 
-	lock_ufs(sb);
+	mutex_lock(&sbi->s_lock);
 
 	/*
 	 * Try to place the inode in its parent directory
@@ -331,21 +331,21 @@ cg_found:
 			sync_dirty_buffer(bh);
 		brelse(bh);
 	}
-	unlock_ufs(sb);
+	mutex_unlock(&sbi->s_lock);
 
 	UFSD("allocating inode %lu\n", inode->i_ino);
 	UFSD("EXIT\n");
 	return inode;
 
 fail_remove_inode:
-	unlock_ufs(sb);
+	mutex_unlock(&sbi->s_lock);
 	clear_nlink(inode);
 	unlock_new_inode(inode);
 	iput(inode);
 	UFSD("EXIT (FAILED): err %d\n", err);
 	return ERR_PTR(err);
 failed:
-	unlock_ufs(sb);
+	mutex_unlock(&sbi->s_lock);
 	make_bad_inode(inode);
 	iput (inode);
 	UFSD("EXIT (FAILED): err %d\n", err);
diff -puN fs/ufs/super.c~ufs-restore-s_lock-mutex fs/ufs/super.c
--- a/fs/ufs/super.c~ufs-restore-s_lock-mutex
+++ a/fs/ufs/super.c
@@ -694,6 +694,7 @@ static int ufs_sync_fs(struct super_bloc
 	unsigned flags;
 
 	lock_ufs(sb);
+	mutex_lock(&UFS_SB(sb)->s_lock);
 
 	UFSD("ENTER\n");
 
@@ -711,6 +712,7 @@ static int ufs_sync_fs(struct super_bloc
 	ufs_put_cstotal(sb);
 
 	UFSD("EXIT\n");
+	mutex_unlock(&UFS_SB(sb)->s_lock);
 	unlock_ufs(sb);
 
 	return 0;
@@ -1290,6 +1292,7 @@ static int ufs_remount (struct super_blo
 	new_mount_opt = 0;
 	ufs_set_opt (new_mount_opt, ONERROR_LOCK);
 	if (!ufs_parse_options (data, &new_mount_opt)) {
+		mutex_unlock(&UFS_SB(sb)->s_lock);
 		unlock_ufs(sb);
 		return -EINVAL;
 	}
@@ -1297,12 +1300,14 @@ static int ufs_remount (struct super_blo
 		new_mount_opt |= ufstype;
 	} else if ((new_mount_opt & UFS_MOUNT_UFSTYPE) != ufstype) {
 		pr_err("ufstype can't be changed during remount\n");
+		mutex_unlock(&UFS_SB(sb)->s_lock);
 		unlock_ufs(sb);
 		return -EINVAL;
 	}
 
 	if ((*mount_flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY)) {
 		UFS_SB(sb)->s_mount_opt = new_mount_opt;
+		mutex_unlock(&UFS_SB(sb)->s_lock);
 		unlock_ufs(sb);
 		return 0;
 	}
@@ -1326,6 +1331,7 @@ static int ufs_remount (struct super_blo
 	 */
 #ifndef CONFIG_UFS_FS_WRITE
 		pr_err("ufs was compiled with read-only support, can't be mounted as read-write\n");
+		mutex_unlock(&UFS_SB(sb)->s_lock);
 		unlock_ufs(sb);
 		return -EINVAL;
 #else
@@ -1335,11 +1341,13 @@ static int ufs_remount (struct super_blo
 		    ufstype != UFS_MOUNT_UFSTYPE_SUNx86 &&
 		    ufstype != UFS_MOUNT_UFSTYPE_UFS2) {
 			pr_err("this ufstype is read-only supported\n");
+			mutex_unlock(&UFS_SB(sb)->s_lock);
 			unlock_ufs(sb);
 			return -EINVAL;
 		}
 		if (!ufs_read_cylinder_structures(sb)) {
 			pr_err("failed during remounting\n");
+			mutex_unlock(&UFS_SB(sb)->s_lock);
 			unlock_ufs(sb);
 			return -EPERM;
 		}
@@ -1347,6 +1355,7 @@ static int ufs_remount (struct super_blo
 #endif
 	}
 	UFS_SB(sb)->s_mount_opt = new_mount_opt;
+	mutex_unlock(&UFS_SB(sb)->s_lock);
 	unlock_ufs(sb);
 	return 0;
 }
diff -puN fs/ufs/ufs.h~ufs-restore-s_lock-mutex fs/ufs/ufs.h
--- a/fs/ufs/ufs.h~ufs-restore-s_lock-mutex
+++ a/fs/ufs/ufs.h
@@ -30,6 +30,7 @@ struct ufs_sb_info {
 	int work_queued; /* non-zero if the delayed work is queued */
 	struct delayed_work sync_work; /* FS sync delayed work */
 	spinlock_t work_lock; /* protects sync_work and work_queued */
+	struct mutex s_lock;
 };
 
 struct ufs_inode_info {
_

Patches currently in -mm which might be from fabf@skynet.be are

configfs-unexport-make-static-config_item_init.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-befs-btreec-remove-unneeded-initializations.patch
revert-ufs-fix-deadlocks-introduced-by-sb-mutex-merge.patch
ufs-restore-s_lock-mutex.patch
fs-affs-inodec-remove-unneeded-initialization.patch
fs-affs-amigaffsc-remove-unneeded-initialization.patch
fs-affs-symlinkc-remove-unneeded-err-variable.patch
linux-next.patch

