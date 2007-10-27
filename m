From: akpm@linux-foundation.org
Subject: + iget-stop-freevxfs-from-using-iget-and-read_inode.patch added to -mm tree
Date: Sat, 27 Oct 2007 00:46:09 -0700
Message-ID: <200710270746.l9R7k9Ko003364@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58943 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751926AbXJ0Hqd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Oct 2007 03:46:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, hch@lst.de


The patch titled
     iget: stop FreeVXFS from using iget() and read_inode()
has been added to the -mm tree.  Its filename is
     iget-stop-freevxfs-from-using-iget-and-read_inode.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: iget: stop FreeVXFS from using iget() and read_inode()
From: David Howells <dhowells@redhat.com>

Stop the FreeVXFS filesystem from using iget() and read_inode().  Replace
vxfs_read_inode() with vxfs_iget(), and call that instead of iget(). 
vxfs_iget() then uses iget_locked() directly and returns a proper error code
instead of an inode in the event of an error.

vxfs_fill_super() returns any error incurred when getting the root inode
instead of EINVAL.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/freevxfs/vxfs_extern.h |    2 -
 fs/freevxfs/vxfs_inode.c  |   43 +++++++++++++++++++++++-------------
 fs/freevxfs/vxfs_lookup.c |    6 ++---
 fs/freevxfs/vxfs_super.c  |   10 +++++---
 4 files changed, 39 insertions(+), 22 deletions(-)

diff -puN fs/freevxfs/vxfs_extern.h~iget-stop-freevxfs-from-using-iget-and-read_inode fs/freevxfs/vxfs_extern.h
--- a/fs/freevxfs/vxfs_extern.h~iget-stop-freevxfs-from-using-iget-and-read_inode
+++ a/fs/freevxfs/vxfs_extern.h
@@ -58,7 +58,7 @@ extern struct inode *		vxfs_get_fake_ino
 extern void			vxfs_put_fake_inode(struct inode *);
 extern struct vxfs_inode_info *	vxfs_blkiget(struct super_block *, u_long, ino_t);
 extern struct vxfs_inode_info *	vxfs_stiget(struct super_block *, ino_t);
-extern void			vxfs_read_inode(struct inode *);
+extern struct inode *		vxfs_iget(struct super_block *, unsigned long);
 extern void			vxfs_clear_inode(struct inode *);
 
 /* vxfs_lookup.c */
diff -puN fs/freevxfs/vxfs_inode.c~iget-stop-freevxfs-from-using-iget-and-read_inode fs/freevxfs/vxfs_inode.c
--- a/fs/freevxfs/vxfs_inode.c~iget-stop-freevxfs-from-using-iget-and-read_inode
+++ a/fs/freevxfs/vxfs_inode.c
@@ -129,7 +129,7 @@ fail:
  * Description:
  *  Search the for inode number @ino in the filesystem
  *  described by @sbp.  Use the specified inode table (@ilistp).
- *  Returns the matching VxFS inode on success, else a NULL pointer.
+ *  Returns the matching VxFS inode on success, else an error code.
  */
 static struct vxfs_inode_info *
 __vxfs_iget(ino_t ino, struct inode *ilistp)
@@ -157,12 +157,12 @@ __vxfs_iget(ino_t ino, struct inode *ili
 	}
 
 	printk(KERN_WARNING "vxfs: error on page %p\n", pp);
-	return NULL;
+	return ERR_CAST(pp);
 
 fail:
 	printk(KERN_WARNING "vxfs: unable to read inode %ld\n", (unsigned long)ino);
 	vxfs_put_page(pp);
-	return NULL;
+	return ERR_PTR(-ENOMEM);
 }
 
 /**
@@ -178,7 +178,10 @@ fail:
 struct vxfs_inode_info *
 vxfs_stiget(struct super_block *sbp, ino_t ino)
 {
-        return __vxfs_iget(ino, VXFS_SBI(sbp)->vsi_stilist);
+	struct vxfs_inode_info *vip;
+
+        vip = __vxfs_iget(ino, VXFS_SBI(sbp)->vsi_stilist);
+	return IS_ERR(vip) ? NULL : vip;
 }
 
 /**
@@ -282,23 +285,32 @@ vxfs_put_fake_inode(struct inode *ip)
 }
 
 /**
- * vxfs_read_inode - fill in inode information
- * @ip:		inode pointer to fill
+ * vxfs_iget - get an inode
+ * @sbp:	the superblock to get the inode for
+ * @ino:	the number of the inode to get
  *
  * Description:
- *  vxfs_read_inode reads the disk inode for @ip and fills
- *  in all relevant fields in @ip.
+ *  vxfs_read_inode creates an inode, reads the disk inode for @ino and fills
+ *  in all relevant fields in the new inode.
  */
-void
-vxfs_read_inode(struct inode *ip)
+struct inode *
+vxfs_iget(struct super_block *sbp, ino_t ino)
 {
-	struct super_block		*sbp = ip->i_sb;
 	struct vxfs_inode_info		*vip;
 	const struct address_space_operations	*aops;
-	ino_t				ino = ip->i_ino;
+	struct inode *ip;
 
-	if (!(vip = __vxfs_iget(ino, VXFS_SBI(sbp)->vsi_ilist)))
-		return;
+	ip = iget_locked(sbp, ino);
+	if (!ip)
+		return ERR_PTR(-ENOMEM);
+	if (!(ip->i_state & I_NEW))
+		return ip;
+
+	vip = __vxfs_iget(ino, VXFS_SBI(sbp)->vsi_ilist);
+	if (IS_ERR(vip)) {
+		iget_failed(ip);
+		return ERR_CAST(vip);
+	}
 
 	vxfs_iinit(ip, vip);
 
@@ -323,7 +335,8 @@ vxfs_read_inode(struct inode *ip)
 	} else
 		init_special_inode(ip, ip->i_mode, old_decode_dev(vip->vii_rdev));
 
-	return;
+	unlock_new_inode(ip);
+	return ip;
 }
 
 /**
diff -puN fs/freevxfs/vxfs_lookup.c~iget-stop-freevxfs-from-using-iget-and-read_inode fs/freevxfs/vxfs_lookup.c
--- a/fs/freevxfs/vxfs_lookup.c~iget-stop-freevxfs-from-using-iget-and-read_inode
+++ a/fs/freevxfs/vxfs_lookup.c
@@ -213,10 +213,10 @@ vxfs_lookup(struct inode *dip, struct de
 	lock_kernel();
 	ino = vxfs_inode_by_name(dip, dp);
 	if (ino) {
-		ip = iget(dip->i_sb, ino);
-		if (!ip) {
+		ip = vxfs_iget(dip->i_sb, ino);
+		if (IS_ERR(ip)) {
 			unlock_kernel();
-			return ERR_PTR(-EACCES);
+			return ERR_CAST(ip);
 		}
 	}
 	unlock_kernel();
diff -puN fs/freevxfs/vxfs_super.c~iget-stop-freevxfs-from-using-iget-and-read_inode fs/freevxfs/vxfs_super.c
--- a/fs/freevxfs/vxfs_super.c~iget-stop-freevxfs-from-using-iget-and-read_inode
+++ a/fs/freevxfs/vxfs_super.c
@@ -60,7 +60,6 @@ static int		vxfs_statfs(struct dentry *,
 static int		vxfs_remount(struct super_block *, int *, char *);
 
 static const struct super_operations vxfs_super_ops = {
-	.read_inode =		vxfs_read_inode,
 	.clear_inode =		vxfs_clear_inode,
 	.put_super =		vxfs_put_super,
 	.statfs =		vxfs_statfs,
@@ -153,6 +152,7 @@ static int vxfs_fill_super(struct super_
 	struct buffer_head	*bp = NULL;
 	u_long			bsize;
 	struct inode *root;
+	int ret = -EINVAL;
 
 	sbp->s_flags |= MS_RDONLY;
 
@@ -219,7 +219,11 @@ static int vxfs_fill_super(struct super_
 	}
 
 	sbp->s_op = &vxfs_super_ops;
-	root = iget(sbp, VXFS_ROOT_INO);
+	root = vxfs_iget(sbp, VXFS_ROOT_INO);
+	if (IS_ERR(root)) {
+		ret = PTR_ERR(root);
+		goto out;
+	}
 	sbp->s_root = d_alloc_root(root);
 	if (!sbp->s_root) {
 		iput(root);
@@ -236,7 +240,7 @@ out_free_ilist:
 out:
 	brelse(bp);
 	kfree(infp);
-	return -EINVAL;
+	return ret;
 }
 
 /*
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
64-bit-i_version-afs-fixes.patch
add-an-err_cast-function-to-complement-err_ptr-and-co.patch
convert-err_ptrptr_errp-instances-to-err_castp.patch
iget-introduce-a-function-to-register-iget-failure.patch
iget-use-iget_failed-in-afs.patch
iget-use-iget_failed-in-gfs2.patch
iget-stop-affs-from-using-iget-and-read_inode-try.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-autofs-from-using-iget-and-read_inode.patch
iget-stop-befs-from-using-iget-and-read_inode-try.patch
iget-stop-bfs-from-using-iget-and-read_inode-try.patch
iget-stop-cifs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext4-from-using-iget-and-read_inode-try.patch
iget-stop-fat-from-using-iget-and-read_inode-try.patch
iget-stop-freevxfs-from-using-iget-and-read_inode.patch
iget-stop-fuse-from-using-iget-and-read_inode-try.patch
iget-stop-hfsplus-from-using-iget-and-read_inode.patch
iget-stop-isofs-from-using-read_inode.patch
iget-stop-jffs2-from-using-iget-and-read_inode.patch
iget-stop-jfs-from-using-iget-and-read_inode-try.patch
iget-stop-the-minix-filesystem-from-using-iget-and.patch
iget-stop-procfs-from-using-iget-and-read_inode.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try.patch
iget-stop-romfs-from-using-iget-and-read_inode.patch
iget-stop-the-sysv-filesystem-from-using-iget-and.patch
iget-stop-ufs-from-using-iget-and-read_inode-try.patch
iget-stop-openpromfs-from-using-iget-and.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hppfs-from-using-iget-and-read_inode.patch
iget-remove-iget-and-the-read_inode-super-op-as.patch
mutex-subsystem-synchro-test-module.patch
