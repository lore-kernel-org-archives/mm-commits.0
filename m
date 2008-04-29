From: akpm@linux-foundation.org
Subject: + affs-fix-reservation-discarding.patch added to -mm tree
Date: Tue, 29 Apr 2008 11:33:32 -0700
Message-ID: <200804291833.m3TIXWdf003209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53352 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753990AbYD2SeM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 14:34:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, zippel@linux-m68k.org


The patch titled
     affs: fix reservation discarding
has been added to the -mm tree.  Its filename is
     affs-fix-reservation-discarding.patch

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
Subject: affs: fix reservation discarding
From: Christoph Hellwig <hch@lst.de>

-ENOSIGNEDOFFBY
-ENOCHANGELOG
-ENOACK

Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/affs.h  |    4 +---
 fs/affs/file.c  |   25 +++++++++++++++++--------
 fs/affs/inode.c |   34 ++++++++--------------------------
 fs/affs/namei.c |    6 ++++--
 fs/affs/super.c |   18 +++++++++++-------
 5 files changed, 41 insertions(+), 46 deletions(-)

diff -puN fs/affs/affs.h~affs-fix-reservation-discarding fs/affs/affs.h
--- a/fs/affs/affs.h~affs-fix-reservation-discarding
+++ a/fs/affs/affs.h
@@ -48,7 +48,7 @@ struct affs_ext_key {
  * affs fs inode data in memory
  */
 struct affs_inode_info {
-	u32	 i_opencnt;
+	atomic_t i_opencnt;
 	struct semaphore i_link_lock;		/* Protects internal inode access. */
 	struct semaphore i_ext_lock;		/* Protects internal inode access. */
 #define i_hash_lock i_ext_lock
@@ -170,8 +170,6 @@ extern int	affs_rename(struct inode *old
 extern unsigned long		 affs_parent_ino(struct inode *dir);
 extern struct inode		*affs_new_inode(struct inode *dir);
 extern int			 affs_notify_change(struct dentry *dentry, struct iattr *attr);
-extern void			 affs_put_inode(struct inode *inode);
-extern void			 affs_drop_inode(struct inode *inode);
 extern void			 affs_delete_inode(struct inode *inode);
 extern void			 affs_clear_inode(struct inode *inode);
 extern struct inode		*affs_iget(struct super_block *sb,
diff -puN fs/affs/file.c~affs-fix-reservation-discarding fs/affs/file.c
--- a/fs/affs/file.c~affs-fix-reservation-discarding
+++ a/fs/affs/file.c
@@ -48,8 +48,9 @@ affs_file_open(struct inode *inode, stru
 {
 	if (atomic_read(&filp->f_count) != 1)
 		return 0;
-	pr_debug("AFFS: open(%d)\n", AFFS_I(inode)->i_opencnt);
-	AFFS_I(inode)->i_opencnt++;
+	pr_debug("AFFS: open(%lu,%d)\n",
+		 inode->i_ino, atomic_read(&AFFS_I(inode)->i_opencnt));
+	atomic_inc(&AFFS_I(inode)->i_opencnt);
 	return 0;
 }
 
@@ -58,10 +59,16 @@ affs_file_release(struct inode *inode, s
 {
 	if (atomic_read(&filp->f_count) != 0)
 		return 0;
-	pr_debug("AFFS: release(%d)\n", AFFS_I(inode)->i_opencnt);
-	AFFS_I(inode)->i_opencnt--;
-	if (!AFFS_I(inode)->i_opencnt)
+	pr_debug("AFFS: release(%lu, %d)\n",
+		 inode->i_ino, atomic_read(&AFFS_I(inode)->i_opencnt));
+
+	if (atomic_dec_and_test(&AFFS_I(inode)->i_opencnt)) {
+		mutex_lock(&inode->i_mutex);
+		if (inode->i_size != AFFS_I(inode)->mmu_private)
+			affs_truncate(inode);
 		affs_free_prealloc(inode);
+		mutex_unlock(&inode->i_mutex);
+	}
 
 	return 0;
 }
@@ -180,7 +187,7 @@ affs_get_extblock(struct inode *inode, u
 	/* inline the simplest case: same extended block as last time */
 	struct buffer_head *bh = AFFS_I(inode)->i_ext_bh;
 	if (ext == AFFS_I(inode)->i_ext_last)
-		atomic_inc(&bh->b_count);
+		get_bh(bh);
 	else
 		/* we have to do more (not inlined) */
 		bh = affs_get_extblock_slow(inode, ext);
@@ -306,7 +313,7 @@ store_ext:
 	affs_brelse(AFFS_I(inode)->i_ext_bh);
 	AFFS_I(inode)->i_ext_last = ext;
 	AFFS_I(inode)->i_ext_bh = bh;
-	atomic_inc(&bh->b_count);
+	get_bh(bh);
 
 	return bh;
 
@@ -324,7 +331,6 @@ affs_get_block(struct inode *inode, sect
 
 	pr_debug("AFFS: get_block(%u, %lu)\n", (u32)inode->i_ino, (unsigned long)block);
 
-
 	BUG_ON(block > (sector_t)0x7fffffffUL);
 
 	if (block >= AFFS_I(inode)->i_blkcnt) {
@@ -827,6 +833,8 @@ affs_truncate(struct inode *inode)
 		res = mapping->a_ops->write_begin(NULL, mapping, size, 0, 0, &page, &fsdata);
 		if (!res)
 			res = mapping->a_ops->write_end(NULL, mapping, size, 0, 0, page, fsdata);
+		else
+			inode->i_size = AFFS_I(inode)->mmu_private;
 		mark_inode_dirty(inode);
 		return;
 	} else if (inode->i_size == AFFS_I(inode)->mmu_private)
@@ -862,6 +870,7 @@ affs_truncate(struct inode *inode)
 		blk++;
 	} else
 		AFFS_HEAD(ext_bh)->first_data = 0;
+	AFFS_HEAD(ext_bh)->block_count = cpu_to_be32(i);
 	size = AFFS_SB(sb)->s_hashsize;
 	if (size > blkcnt - blk + i)
 		size = blkcnt - blk + i;
diff -puN fs/affs/inode.c~affs-fix-reservation-discarding fs/affs/inode.c
--- a/fs/affs/inode.c~affs-fix-reservation-discarding
+++ a/fs/affs/inode.c
@@ -58,7 +58,7 @@ struct inode *affs_iget(struct super_blo
 	AFFS_I(inode)->i_extcnt = 1;
 	AFFS_I(inode)->i_ext_last = ~1;
 	AFFS_I(inode)->i_protect = prot;
-	AFFS_I(inode)->i_opencnt = 0;
+	atomic_set(&AFFS_I(inode)->i_opencnt, 0);
 	AFFS_I(inode)->i_blkcnt = 0;
 	AFFS_I(inode)->i_lc = NULL;
 	AFFS_I(inode)->i_lc_size = 0;
@@ -108,8 +108,6 @@ struct inode *affs_iget(struct super_blo
 			inode->i_mode |= S_IFDIR;
 		} else
 			inode->i_mode = S_IRUGO | S_IXUGO | S_IWUSR | S_IFDIR;
-		if (tail->link_chain)
-			inode->i_nlink = 2;
 		/* Maybe it should be controlled by mount parameter? */
 		//inode->i_mode |= S_ISVTX;
 		inode->i_op = &affs_dir_inode_operations;
@@ -245,31 +243,12 @@ out:
 }
 
 void
-affs_put_inode(struct inode *inode)
-{
-	pr_debug("AFFS: put_inode(ino=%lu, nlink=%u)\n", inode->i_ino, inode->i_nlink);
-	affs_free_prealloc(inode);
-}
-
-void
-affs_drop_inode(struct inode *inode)
-{
-	mutex_lock(&inode->i_mutex);
-	if (inode->i_size != AFFS_I(inode)->mmu_private)
-		affs_truncate(inode);
-	mutex_unlock(&inode->i_mutex);
-
-	generic_drop_inode(inode);
-}
-
-void
 affs_delete_inode(struct inode *inode)
 {
 	pr_debug("AFFS: delete_inode(ino=%lu, nlink=%u)\n", inode->i_ino, inode->i_nlink);
 	truncate_inode_pages(&inode->i_data, 0);
 	inode->i_size = 0;
-	if (S_ISREG(inode->i_mode))
-		affs_truncate(inode);
+	affs_truncate(inode);
 	clear_inode(inode);
 	affs_free_block(inode->i_sb, inode->i_ino);
 }
@@ -277,9 +256,12 @@ affs_delete_inode(struct inode *inode)
 void
 affs_clear_inode(struct inode *inode)
 {
-	unsigned long cache_page = (unsigned long) AFFS_I(inode)->i_lc;
+	unsigned long cache_page;
 
 	pr_debug("AFFS: clear_inode(ino=%lu, nlink=%u)\n", inode->i_ino, inode->i_nlink);
+
+	affs_free_prealloc(inode);
+	cache_page = (unsigned long)AFFS_I(inode)->i_lc;
 	if (cache_page) {
 		pr_debug("AFFS: freeing ext cache\n");
 		AFFS_I(inode)->i_lc = NULL;
@@ -316,7 +298,7 @@ affs_new_inode(struct inode *dir)
 	inode->i_ino     = block;
 	inode->i_nlink   = 1;
 	inode->i_mtime   = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
-	AFFS_I(inode)->i_opencnt = 0;
+	atomic_set(&AFFS_I(inode)->i_opencnt, 0);
 	AFFS_I(inode)->i_blkcnt = 0;
 	AFFS_I(inode)->i_lc = NULL;
 	AFFS_I(inode)->i_lc_size = 0;
@@ -369,12 +351,12 @@ affs_add_entry(struct inode *dir, struct
 	switch (type) {
 	case ST_LINKFILE:
 	case ST_LINKDIR:
-		inode_bh = bh;
 		retval = -ENOSPC;
 		block = affs_alloc_block(dir, dir->i_ino);
 		if (!block)
 			goto err;
 		retval = -EIO;
+		inode_bh = bh;
 		bh = affs_getzeroblk(sb, block);
 		if (!bh)
 			goto err;
diff -puN fs/affs/namei.c~affs-fix-reservation-discarding fs/affs/namei.c
--- a/fs/affs/namei.c~affs-fix-reservation-discarding
+++ a/fs/affs/namei.c
@@ -234,7 +234,8 @@ affs_lookup(struct inode *dir, struct de
 int
 affs_unlink(struct inode *dir, struct dentry *dentry)
 {
-	pr_debug("AFFS: unlink(dir=%d, \"%.*s\")\n", (u32)dir->i_ino,
+	pr_debug("AFFS: unlink(dir=%d, %lu \"%.*s\")\n", (u32)dir->i_ino,
+		 dentry->d_inode->i_ino,
 		 (int)dentry->d_name.len, dentry->d_name.name);
 
 	return affs_remove_header(dentry);
@@ -302,7 +303,8 @@ affs_mkdir(struct inode *dir, struct den
 int
 affs_rmdir(struct inode *dir, struct dentry *dentry)
 {
-	pr_debug("AFFS: rmdir(dir=%u, \"%.*s\")\n", (u32)dir->i_ino,
+	pr_debug("AFFS: rmdir(dir=%u, %lu \"%.*s\")\n", (u32)dir->i_ino,
+		 dentry->d_inode->i_ino,
 		 (int)dentry->d_name.len, dentry->d_name.name);
 
 	return affs_remove_header(dentry);
diff -puN fs/affs/super.c~affs-fix-reservation-discarding fs/affs/super.c
--- a/fs/affs/super.c~affs-fix-reservation-discarding
+++ a/fs/affs/super.c
@@ -71,12 +71,18 @@ static struct kmem_cache * affs_inode_ca
 
 static struct inode *affs_alloc_inode(struct super_block *sb)
 {
-	struct affs_inode_info *ei;
-	ei = (struct affs_inode_info *)kmem_cache_alloc(affs_inode_cachep, GFP_KERNEL);
-	if (!ei)
+	struct affs_inode_info *i;
+
+	i = kmem_cache_alloc(affs_inode_cachep, GFP_KERNEL);
+	if (!i)
 		return NULL;
-	ei->vfs_inode.i_version = 1;
-	return &ei->vfs_inode;
+
+	i->vfs_inode.i_version = 1;
+	i->i_lc = NULL;
+	i->i_ext_bh = NULL;
+	i->i_pa_cnt = 0;
+
+	return &i->vfs_inode;
 }
 
 static void affs_destroy_inode(struct inode *inode)
@@ -114,8 +120,6 @@ static const struct super_operations aff
 	.alloc_inode	= affs_alloc_inode,
 	.destroy_inode	= affs_destroy_inode,
 	.write_inode	= affs_write_inode,
-	.put_inode	= affs_put_inode,
-	.drop_inode	= affs_drop_inode,
 	.delete_inode	= affs_delete_inode,
 	.clear_inode	= affs_clear_inode,
 	.put_super	= affs_put_super,
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
vfs-remove-lives_below_in_same_fs.patch
vfs-fix-unconditional-write_super-call-in-file_fsync.patch
procfs-task-exe-symlink.patch
sysv-fs-remove-superfluous-check-for-__gnuc__-compiler.patch
git-cifs.patch
git-unionfs.patch
git-xfs.patch
signals-do_tkill-dont-use-tasklist_lock-comment.patch
mxser-convert-large-macros-to-functions.patch
reiserfs-use-open_bdev_excl.patch
affs-fix-reservation-discarding.patch

