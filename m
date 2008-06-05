From: akpm@linux-foundation.org
Subject: + bfs-kill-bkl.patch added to -mm tree
Date: Thu, 05 Jun 2008 11:40:30 -0700
Message-ID: <200806051840.m55IeUgK024026@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48876 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753846AbYFESkt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2008 14:40:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmitri.vorobiev@movial.fi, tigran_aivazian@symantec.com


The patch titled
     bfs: kill BKL
has been added to the -mm tree.  Its filename is
     bfs-kill-bkl.patch

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
Subject: bfs: kill BKL
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>

Replace the BKL-based locking scheme used in the bfs driver by a private
filesystem-wide mutex.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Cc: Tigran Aivazian <tigran_aivazian@symantec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bfs/bfs.h   |    1 +
 fs/bfs/dir.c   |   46 ++++++++++++++++++++++++++--------------------
 fs/bfs/file.c  |    4 ++--
 fs/bfs/inode.c |   24 +++++++++++++++---------
 4 files changed, 44 insertions(+), 31 deletions(-)

diff -puN fs/bfs/bfs.h~bfs-kill-bkl fs/bfs/bfs.h
--- a/fs/bfs/bfs.h~bfs-kill-bkl
+++ a/fs/bfs/bfs.h
@@ -18,6 +18,7 @@ struct bfs_sb_info {
 	unsigned long si_lasti;
 	unsigned long *si_imap;
 	struct buffer_head *si_sbh;		/* buffer header w/superblock */
+	struct mutex bfs_lock;
 };
 
 /*
diff -puN fs/bfs/dir.c~bfs-kill-bkl fs/bfs/dir.c
--- a/fs/bfs/dir.c~bfs-kill-bkl
+++ a/fs/bfs/dir.c
@@ -32,16 +32,17 @@ static int bfs_readdir(struct file *f, v
 	struct inode *dir = f->f_path.dentry->d_inode;
 	struct buffer_head *bh;
 	struct bfs_dirent *de;
+	struct bfs_sb_info *info = BFS_SB(dir->i_sb);
 	unsigned int offset;
 	int block;
 
-	lock_kernel();
+	mutex_lock(&info->bfs_lock);
 
 	if (f->f_pos & (BFS_DIRENT_SIZE - 1)) {
 		printf("Bad f_pos=%08lx for %s:%08lx\n",
 					(unsigned long)f->f_pos,
 					dir->i_sb->s_id, dir->i_ino);
-		unlock_kernel();
+		mutex_unlock(&info->bfs_lock);
 		return -EBADF;
 	}
 
@@ -61,7 +62,7 @@ static int bfs_readdir(struct file *f, v
 						le16_to_cpu(de->ino),
 						DT_UNKNOWN) < 0) {
 					brelse(bh);
-					unlock_kernel();
+					mutex_unlock(&info->bfs_lock);
 					return 0;
 				}
 			}
@@ -71,7 +72,7 @@ static int bfs_readdir(struct file *f, v
 		brelse(bh);
 	}
 
-	unlock_kernel();
+	mutex_unlock(&info->bfs_lock);
 	return 0;	
 }
 
@@ -95,10 +96,10 @@ static int bfs_create(struct inode *dir,
 	inode = new_inode(s);
 	if (!inode)
 		return -ENOSPC;
-	lock_kernel();
+	mutex_lock(&info->bfs_lock);
 	ino = find_first_zero_bit(info->si_imap, info->si_lasti);
 	if (ino > info->si_lasti) {
-		unlock_kernel();
+		mutex_unlock(&info->bfs_lock);
 		iput(inode);
 		return -ENOSPC;
 	}
@@ -125,10 +126,10 @@ static int bfs_create(struct inode *dir,
 	if (err) {
 		inode_dec_link_count(inode);
 		iput(inode);
-		unlock_kernel();
+		mutex_unlock(&info->bfs_lock);
 		return err;
 	}
-	unlock_kernel();
+	mutex_unlock(&info->bfs_lock);
 	d_instantiate(dentry, inode);
 	return 0;
 }
@@ -139,22 +140,23 @@ static struct dentry *bfs_lookup(struct 
 	struct inode *inode = NULL;
 	struct buffer_head *bh;
 	struct bfs_dirent *de;
+	struct bfs_sb_info *info = BFS_SB(dir->i_sb);
 
 	if (dentry->d_name.len > BFS_NAMELEN)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	lock_kernel();
+	mutex_lock(&info->bfs_lock);
 	bh = bfs_find_entry(dir, dentry->d_name.name, dentry->d_name.len, &de);
 	if (bh) {
 		unsigned long ino = (unsigned long)le16_to_cpu(de->ino);
 		brelse(bh);
 		inode = bfs_iget(dir->i_sb, ino);
 		if (IS_ERR(inode)) {
-			unlock_kernel();
+			mutex_unlock(&info->bfs_lock);
 			return ERR_CAST(inode);
 		}
 	}
-	unlock_kernel();
+	mutex_unlock(&info->bfs_lock);
 	d_add(dentry, inode);
 	return NULL;
 }
@@ -163,13 +165,14 @@ static int bfs_link(struct dentry *old, 
 						struct dentry *new)
 {
 	struct inode *inode = old->d_inode;
+	struct bfs_sb_info *info = BFS_SB(inode->i_sb);
 	int err;
 
-	lock_kernel();
+	mutex_lock(&info->bfs_lock);
 	err = bfs_add_entry(dir, new->d_name.name, new->d_name.len,
 							inode->i_ino);
 	if (err) {
-		unlock_kernel();
+		mutex_unlock(&info->bfs_lock);
 		return err;
 	}
 	inc_nlink(inode);
@@ -177,19 +180,19 @@ static int bfs_link(struct dentry *old, 
 	mark_inode_dirty(inode);
 	atomic_inc(&inode->i_count);
 	d_instantiate(new, inode);
-	unlock_kernel();
+	mutex_unlock(&info->bfs_lock);
 	return 0;
 }
 
 static int bfs_unlink(struct inode *dir, struct dentry *dentry)
 {
 	int error = -ENOENT;
-	struct inode *inode;
+	struct inode *inode = dentry->d_inode;
 	struct buffer_head *bh;
 	struct bfs_dirent *de;
+	struct bfs_sb_info *info = BFS_SB(inode->i_sb);
 
-	inode = dentry->d_inode;
-	lock_kernel();
+	mutex_lock(&info->bfs_lock);
 	bh = bfs_find_entry(dir, dentry->d_name.name, dentry->d_name.len, &de);
 	if (!bh || (le16_to_cpu(de->ino) != inode->i_ino))
 		goto out_brelse;
@@ -210,7 +213,7 @@ static int bfs_unlink(struct inode *dir,
 
 out_brelse:
 	brelse(bh);
-	unlock_kernel();
+	mutex_unlock(&info->bfs_lock);
 	return error;
 }
 
@@ -220,6 +223,7 @@ static int bfs_rename(struct inode *old_
 	struct inode *old_inode, *new_inode;
 	struct buffer_head *old_bh, *new_bh;
 	struct bfs_dirent *old_de, *new_de;
+	struct bfs_sb_info *info;
 	int error = -ENOENT;
 
 	old_bh = new_bh = NULL;
@@ -227,7 +231,9 @@ static int bfs_rename(struct inode *old_
 	if (S_ISDIR(old_inode->i_mode))
 		return -EINVAL;
 
-	lock_kernel();
+	info = BFS_SB(old_inode->i_sb);
+
+	mutex_lock(&info->bfs_lock);
 	old_bh = bfs_find_entry(old_dir, 
 				old_dentry->d_name.name, 
 				old_dentry->d_name.len, &old_de);
@@ -264,7 +270,7 @@ static int bfs_rename(struct inode *old_
 	error = 0;
 
 end_rename:
-	unlock_kernel();
+	mutex_unlock(&info->bfs_lock);
 	brelse(old_bh);
 	brelse(new_bh);
 	return error;
diff -puN fs/bfs/file.c~bfs-kill-bkl fs/bfs/file.c
--- a/fs/bfs/file.c~bfs-kill-bkl
+++ a/fs/bfs/file.c
@@ -99,7 +99,7 @@ static int bfs_get_block(struct inode *i
 		return -ENOSPC;
 
 	/* The rest has to be protected against itself. */
-	lock_kernel();
+	mutex_lock(&info->bfs_lock);
 
 	/*
 	 * If the last data block for this file is the last allocated
@@ -151,7 +151,7 @@ static int bfs_get_block(struct inode *i
 	mark_buffer_dirty(sbh);
 	map_bh(bh_result, sb, phys);
 out:
-	unlock_kernel();
+	mutex_unlock(&info->bfs_lock);
 	return err;
 }
 
diff -puN fs/bfs/inode.c~bfs-kill-bkl fs/bfs/inode.c
--- a/fs/bfs/inode.c~bfs-kill-bkl
+++ a/fs/bfs/inode.c
@@ -104,6 +104,7 @@ static int bfs_write_inode(struct inode 
 	struct bfs_inode *di;
 	struct buffer_head *bh;
 	int block, off;
+	struct bfs_sb_info *info = BFS_SB(inode->i_sb);
 
         dprintf("ino=%08x\n", ino);
 
@@ -112,13 +113,13 @@ static int bfs_write_inode(struct inode 
 		return -EIO;
 	}
 
-	lock_kernel();
+	mutex_lock(&info->bfs_lock);
 	block = (ino - BFS_ROOT_INO) / BFS_INODES_PER_BLOCK + 1;
 	bh = sb_bread(inode->i_sb, block);
 	if (!bh) {
 		printf("Unable to read inode %s:%08x\n",
 				inode->i_sb->s_id, ino);
-		unlock_kernel();
+		mutex_unlock(&info->bfs_lock);
 		return -EIO;
 	}
 
@@ -145,7 +146,7 @@ static int bfs_write_inode(struct inode 
 
 	mark_buffer_dirty(bh);
 	brelse(bh);
-	unlock_kernel();
+	mutex_unlock(&info->bfs_lock);
 	return 0;
 }
 
@@ -170,7 +171,7 @@ static void bfs_delete_inode(struct inod
 	
 	inode->i_size = 0;
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME_SEC;
-	lock_kernel();
+	mutex_lock(&info->bfs_lock);
 	mark_inode_dirty(inode);
 
 	block = (ino - BFS_ROOT_INO) / BFS_INODES_PER_BLOCK + 1;
@@ -178,7 +179,7 @@ static void bfs_delete_inode(struct inod
 	if (!bh) {
 		printf("Unable to read inode %s:%08lx\n",
 					inode->i_sb->s_id, ino);
-		unlock_kernel();
+		mutex_unlock(&info->bfs_lock);
 		return;
 	}
 	off = (ino - BFS_ROOT_INO) % BFS_INODES_PER_BLOCK;
@@ -204,14 +205,16 @@ static void bfs_delete_inode(struct inod
 		info->si_lf_eblk = bi->i_sblock - 1;
 		mark_buffer_dirty(info->si_sbh);
 	}
-	unlock_kernel();
+	mutex_unlock(&info->bfs_lock);
 	clear_inode(inode);
 }
 
 static void bfs_put_super(struct super_block *s)
 {
 	struct bfs_sb_info *info = BFS_SB(s);
+
 	brelse(info->si_sbh);
+	mutex_destroy(&info->bfs_lock);
 	kfree(info->si_imap);
 	kfree(info);
 	s->s_fs_info = NULL;
@@ -236,11 +239,13 @@ static int bfs_statfs(struct dentry *den
 
 static void bfs_write_super(struct super_block *s)
 {
-	lock_kernel();
+	struct bfs_sb_info *info = BFS_SB(s);
+
+	mutex_lock(&info->bfs_lock);
 	if (!(s->s_flags & MS_RDONLY))
-		mark_buffer_dirty(BFS_SB(s)->si_sbh);
+		mark_buffer_dirty(info->si_sbh);
 	s->s_dirt = 0;
-	unlock_kernel();
+	mutex_unlock(&info->bfs_lock);
 }
 
 static struct kmem_cache *bfs_inode_cachep;
@@ -409,6 +414,7 @@ static int bfs_fill_super(struct super_b
 		s->s_dirt = 1;
 	} 
 	dump_imap("read_super", s);
+	mutex_init(&info->bfs_lock);
 	return 0;
 
 out:
_

Patches currently in -mm which might be from dmitri.vorobiev@movial.fi are

bfs-assorted-cleanups.patch
bfs-kill-bkl.patch

