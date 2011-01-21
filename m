From: akpm@linux-foundation.org
Subject: + adfs-remove-the-big-kernel-lock.patch added to -mm tree
Date: Fri, 21 Jan 2011 14:55:25 -0800
Message-ID: <201101212255.p0LMtPT3005901@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56339 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752903Ab1AUW4Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Jan 2011 17:56:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arnd@arndb.de, rmk@arm.linux.org.uk, stuart.swales.croftnuisk@gmail.com


The patch titled
     adfs: remove the big kernel lock
has been added to the -mm tree.  Its filename is
     adfs-remove-the-big-kernel-lock.patch

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
Subject: adfs: remove the big kernel lock
From: Arnd Bergmann <arnd@arndb.de>

According to Russell King, adfs was written to not require the big kernel
lock, and all inode updates are done under adfs_dir_lock.

All other metadata in adfs is read-only and does not require locking.  The
use of the BKL is the result of various pushdowns from the VFS operations.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Stuart Swales <stuart.swales.croftnuisk@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/adfs/dir.c   |    6 ------
 fs/adfs/inode.c |    6 ------
 fs/adfs/super.c |   13 +------------
 3 files changed, 1 insertion(+), 24 deletions(-)

diff -puN fs/adfs/dir.c~adfs-remove-the-big-kernel-lock fs/adfs/dir.c
--- a/fs/adfs/dir.c~adfs-remove-the-big-kernel-lock
+++ a/fs/adfs/dir.c
@@ -9,7 +9,6 @@
  *
  *  Common directory handling for ADFS
  */
-#include <linux/smp_lock.h>
 #include "adfs.h"
 
 /*
@@ -27,8 +26,6 @@ adfs_readdir(struct file *filp, void *di
 	struct adfs_dir dir;
 	int ret = 0;
 
-	lock_kernel();	
-
 	if (filp->f_pos >> 32)
 		goto out;
 
@@ -70,7 +67,6 @@ free_out:
 	ops->free(&dir);
 
 out:
-	unlock_kernel();
 	return ret;
 }
 
@@ -276,7 +272,6 @@ adfs_lookup(struct inode *dir, struct de
 	struct object_info obj;
 	int error;
 
-	lock_kernel();
 	error = adfs_dir_lookup_byname(dir, &dentry->d_name, &obj);
 	if (error == 0) {
 		error = -EACCES;
@@ -288,7 +283,6 @@ adfs_lookup(struct inode *dir, struct de
 		if (inode)
 			error = 0;
 	}
-	unlock_kernel();
 	d_add(dentry, inode);
 	return ERR_PTR(error);
 }
diff -puN fs/adfs/inode.c~adfs-remove-the-big-kernel-lock fs/adfs/inode.c
--- a/fs/adfs/inode.c~adfs-remove-the-big-kernel-lock
+++ a/fs/adfs/inode.c
@@ -7,7 +7,6 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-#include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
 #include <linux/writeback.h>
 #include "adfs.h"
@@ -300,8 +299,6 @@ adfs_notify_change(struct dentry *dentry
 	unsigned int ia_valid = attr->ia_valid;
 	int error;
 	
-	lock_kernel();
-
 	error = inode_change_ok(inode, attr);
 
 	/*
@@ -343,7 +340,6 @@ adfs_notify_change(struct dentry *dentry
 	if (ia_valid & (ATTR_SIZE | ATTR_MTIME | ATTR_MODE))
 		mark_inode_dirty(inode);
 out:
-	unlock_kernel();
 	return error;
 }
 
@@ -358,7 +354,6 @@ int adfs_write_inode(struct inode *inode
 	struct object_info obj;
 	int ret;
 
-	lock_kernel();
 	obj.file_id	= inode->i_ino;
 	obj.name_len	= 0;
 	obj.parent_id	= ADFS_I(inode)->parent_id;
@@ -368,6 +363,5 @@ int adfs_write_inode(struct inode *inode
 	obj.size	= inode->i_size;
 
 	ret = adfs_dir_update(sb, &obj, wbc->sync_mode == WB_SYNC_ALL);
-	unlock_kernel();
 	return ret;
 }
diff -puN fs/adfs/super.c~adfs-remove-the-big-kernel-lock fs/adfs/super.c
--- a/fs/adfs/super.c~adfs-remove-the-big-kernel-lock
+++ a/fs/adfs/super.c
@@ -14,7 +14,6 @@
 #include <linux/mount.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/statfs.h>
 #include "adfs.h"
 #include "dir_f.h"
@@ -120,15 +119,11 @@ static void adfs_put_super(struct super_
 	int i;
 	struct adfs_sb_info *asb = ADFS_SB(sb);
 
-	lock_kernel();
-
 	for (i = 0; i < asb->s_map_size; i++)
 		brelse(asb->s_map[i].dm_bh);
 	kfree(asb->s_map);
 	kfree(asb);
 	sb->s_fs_info = NULL;
-
-	unlock_kernel();
 }
 
 static int adfs_show_options(struct seq_file *seq, struct vfsmount *mnt)
@@ -367,15 +362,11 @@ static int adfs_fill_super(struct super_
 	struct adfs_sb_info *asb;
 	struct inode *root;
 
-	lock_kernel();
-
 	sb->s_flags |= MS_NODIRATIME;
 
 	asb = kzalloc(sizeof(*asb), GFP_KERNEL);
-	if (!asb) {
-		unlock_kernel();
+	if (!asb)
 		return -ENOMEM;
-	}
 	sb->s_fs_info = asb;
 
 	/* set default options */
@@ -502,7 +493,6 @@ static int adfs_fill_super(struct super_
 		adfs_error(sb, "get root inode failed\n");
 		goto error;
 	}
-	unlock_kernel();
 	return 0;
 
 error_free_bh:
@@ -510,7 +500,6 @@ error_free_bh:
 error:
 	sb->s_fs_info = NULL;
 	kfree(asb);
-	unlock_kernel();
 	return -EINVAL;
 }
 
_

Patches currently in -mm which might be from arnd@arndb.de are

origin.patch
linux-next.patch
spufs-use-simple_write_to_buffer.patch
n_hdlc-fix-read-and-write-locking.patch
hpet-factor-timer-allocate-from-open.patch
add-the-common-dma_addr_t-typedef-to-include-linux-typesh.patch
smp-move-smp-setup-functions-to-kernel-smpc.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
adfs-remove-the-big-kernel-lock.patch

