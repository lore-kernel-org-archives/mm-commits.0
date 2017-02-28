From: akpm@linux-foundation.org
Subject: [merged] fs-affs-add-prefix-to-some-functions.patch removed from
 -mm tree
Date: Tue, 28 Feb 2017 12:50:25 -0800
Message-ID: <58b5e291.cIPbp7Sw0k9Gzu0R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52602 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751796AbdB1Uvd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 15:51:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs: add prefix to some functions
has been removed from the -mm tree.  Its filename was
     fs-affs-add-prefix-to-some-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs: add prefix to some functions

secs_to_datestamp(time64_t secs, struct affs_date *ds);
prot_to_mode(u32 prot);
mode_to_prot(struct inode *inode);

were declared without affs_ prefix

Link: http://lkml.kernel.org/r/20170109191208.6085-6-fabf@skynet.be
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/affs.h     |    6 +++---
 fs/affs/amigaffs.c |    6 +++---
 fs/affs/inode.c    |    9 +++++----
 fs/affs/namei.c    |    6 +++---
 fs/affs/super.c    |    2 +-
 5 files changed, 15 insertions(+), 14 deletions(-)

diff -puN fs/affs/affs.h~fs-affs-add-prefix-to-some-functions fs/affs/affs.h
--- a/fs/affs/affs.h~fs-affs-add-prefix-to-some-functions
+++ a/fs/affs/affs.h
@@ -138,9 +138,9 @@ extern int	affs_remove_hash(struct inode
 extern int	affs_remove_header(struct dentry *dentry);
 extern u32	affs_checksum_block(struct super_block *sb, struct buffer_head *bh);
 extern void	affs_fix_checksum(struct super_block *sb, struct buffer_head *bh);
-extern void	secs_to_datestamp(time64_t secs, struct affs_date *ds);
-extern umode_t	prot_to_mode(u32 prot);
-extern void	mode_to_prot(struct inode *inode);
+extern void	affs_secs_to_datestamp(time64_t secs, struct affs_date *ds);
+extern umode_t	affs_prot_to_mode(u32 prot);
+extern void	affs_mode_to_prot(struct inode *inode);
 __printf(3, 4)
 extern void	affs_error(struct super_block *sb, const char *function,
 			   const char *fmt, ...);
diff -puN fs/affs/amigaffs.c~fs-affs-add-prefix-to-some-functions fs/affs/amigaffs.c
--- a/fs/affs/amigaffs.c~fs-affs-add-prefix-to-some-functions
+++ a/fs/affs/amigaffs.c
@@ -367,7 +367,7 @@ affs_fix_checksum(struct super_block *sb
 }
 
 void
-secs_to_datestamp(time64_t secs, struct affs_date *ds)
+affs_secs_to_datestamp(time64_t secs, struct affs_date *ds)
 {
 	u32	 days;
 	u32	 minute;
@@ -386,7 +386,7 @@ secs_to_datestamp(time64_t secs, struct
 }
 
 umode_t
-prot_to_mode(u32 prot)
+affs_prot_to_mode(u32 prot)
 {
 	umode_t mode = 0;
 
@@ -413,7 +413,7 @@ prot_to_mode(u32 prot)
 }
 
 void
-mode_to_prot(struct inode *inode)
+affs_mode_to_prot(struct inode *inode)
 {
 	u32 prot = AFFS_I(inode)->i_protect;
 	umode_t mode = inode->i_mode;
diff -puN fs/affs/inode.c~fs-affs-add-prefix-to-some-functions fs/affs/inode.c
--- a/fs/affs/inode.c~fs-affs-add-prefix-to-some-functions
+++ a/fs/affs/inode.c
@@ -69,7 +69,7 @@ struct inode *affs_iget(struct super_blo
 	if (affs_test_opt(sbi->s_flags, SF_SETMODE))
 		inode->i_mode = sbi->s_mode;
 	else
-		inode->i_mode = prot_to_mode(prot);
+		inode->i_mode = affs_prot_to_mode(prot);
 
 	id = be16_to_cpu(tail->uid);
 	if (id == 0 || affs_test_opt(sbi->s_flags, SF_SETUID))
@@ -184,11 +184,12 @@ affs_write_inode(struct inode *inode, st
 	}
 	tail = AFFS_TAIL(sb, bh);
 	if (tail->stype == cpu_to_be32(ST_ROOT)) {
-		secs_to_datestamp(inode->i_mtime.tv_sec,&AFFS_ROOT_TAIL(sb, bh)->root_change);
+		affs_secs_to_datestamp(inode->i_mtime.tv_sec,
+				       &AFFS_ROOT_TAIL(sb, bh)->root_change);
 	} else {
 		tail->protect = cpu_to_be32(AFFS_I(inode)->i_protect);
 		tail->size = cpu_to_be32(inode->i_size);
-		secs_to_datestamp(inode->i_mtime.tv_sec,&tail->change);
+		affs_secs_to_datestamp(inode->i_mtime.tv_sec, &tail->change);
 		if (!(inode->i_ino == AFFS_SB(sb)->s_root_block)) {
 			uid = i_uid_read(inode);
 			gid = i_gid_read(inode);
@@ -249,7 +250,7 @@ affs_notify_change(struct dentry *dentry
 	mark_inode_dirty(inode);
 
 	if (attr->ia_valid & ATTR_MODE)
-		mode_to_prot(inode);
+		affs_mode_to_prot(inode);
 out:
 	return error;
 }
diff -puN fs/affs/namei.c~fs-affs-add-prefix-to-some-functions fs/affs/namei.c
--- a/fs/affs/namei.c~fs-affs-add-prefix-to-some-functions
+++ a/fs/affs/namei.c
@@ -272,7 +272,7 @@ affs_create(struct inode *dir, struct de
 		return -ENOSPC;
 
 	inode->i_mode = mode;
-	mode_to_prot(inode);
+	affs_mode_to_prot(inode);
 	mark_inode_dirty(inode);
 
 	inode->i_op = &affs_file_inode_operations;
@@ -302,7 +302,7 @@ affs_mkdir(struct inode *dir, struct den
 		return -ENOSPC;
 
 	inode->i_mode = S_IFDIR | mode;
-	mode_to_prot(inode);
+	affs_mode_to_prot(inode);
 
 	inode->i_op = &affs_dir_inode_operations;
 	inode->i_fop = &affs_dir_operations;
@@ -348,7 +348,7 @@ affs_symlink(struct inode *dir, struct d
 	inode_nohighmem(inode);
 	inode->i_data.a_ops = &affs_symlink_aops;
 	inode->i_mode = S_IFLNK | 0777;
-	mode_to_prot(inode);
+	affs_mode_to_prot(inode);
 
 	error = -EIO;
 	bh = affs_bread(sb, inode->i_ino);
diff -puN fs/affs/super.c~fs-affs-add-prefix-to-some-functions fs/affs/super.c
--- a/fs/affs/super.c~fs-affs-add-prefix-to-some-functions
+++ a/fs/affs/super.c
@@ -32,7 +32,7 @@ affs_commit_super(struct super_block *sb
 	struct affs_root_tail *tail = AFFS_ROOT_TAIL(sb, bh);
 
 	lock_buffer(bh);
-	secs_to_datestamp(ktime_get_real_seconds(), &tail->disk_change);
+	affs_secs_to_datestamp(ktime_get_real_seconds(), &tail->disk_change);
 	affs_fix_checksum(sb, bh);
 	unlock_buffer(bh);
 
_

Patches currently in -mm which might be from fabf@skynet.be are


