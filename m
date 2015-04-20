From: akpm@linux-foundation.org
Subject: [merged] fs-affs-use-affs_test_opt.patch removed from -mm tree
Date: Mon, 20 Apr 2015 12:20:12 -0700
Message-ID: <5535516c.LG3TBKHSDqYWQdX5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40432 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbbDTTNv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:13:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs: use affs_test_opt()
has been removed from the -mm tree.  Its filename was
     fs-affs-use-affs_test_opt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs: use affs_test_opt()

Replace mount option test by affs_test_opt().

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/amigaffs.c |    3 ++-
 fs/affs/file.c     |    2 +-
 fs/affs/inode.c    |   26 +++++++++++++-------------
 fs/affs/namei.c    |    6 +++---
 fs/affs/super.c    |    6 +++---
 5 files changed, 22 insertions(+), 21 deletions(-)

diff -puN fs/affs/amigaffs.c~fs-affs-use-affs_test_opt fs/affs/amigaffs.c
--- a/fs/affs/amigaffs.c~fs-affs-use-affs_test_opt
+++ a/fs/affs/amigaffs.c
@@ -472,7 +472,8 @@ bool
 affs_nofilenametruncate(const struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
-	return AFFS_SB(inode->i_sb)->s_flags & AFFS_MOUNT_SF_NO_TRUNCATE;
+
+	return affs_test_opt(AFFS_SB(inode->i_sb)->s_flags, SF_NO_TRUNCATE);
 
 }
 
diff -puN fs/affs/file.c~fs-affs-use-affs_test_opt fs/affs/file.c
--- a/fs/affs/file.c~fs-affs-use-affs_test_opt
+++ a/fs/affs/file.c
@@ -915,7 +915,7 @@ affs_truncate(struct inode *inode)
 	if (inode->i_size) {
 		AFFS_I(inode)->i_blkcnt = last_blk + 1;
 		AFFS_I(inode)->i_extcnt = ext + 1;
-		if (AFFS_SB(sb)->s_flags & AFFS_MOUNT_SF_OFS) {
+		if (affs_test_opt(AFFS_SB(sb)->s_flags, SF_OFS)) {
 			struct buffer_head *bh = affs_bread_ino(inode, last_blk, 0);
 			u32 tmp;
 			if (IS_ERR(bh)) {
diff -puN fs/affs/inode.c~fs-affs-use-affs_test_opt fs/affs/inode.c
--- a/fs/affs/inode.c~fs-affs-use-affs_test_opt
+++ a/fs/affs/inode.c
@@ -66,23 +66,23 @@ struct inode *affs_iget(struct super_blo
 	AFFS_I(inode)->i_lastalloc = 0;
 	AFFS_I(inode)->i_pa_cnt = 0;
 
-	if (sbi->s_flags & AFFS_MOUNT_SF_SETMODE)
+	if (affs_test_opt(sbi->s_flags, SF_SETMODE))
 		inode->i_mode = sbi->s_mode;
 	else
 		inode->i_mode = prot_to_mode(prot);
 
 	id = be16_to_cpu(tail->uid);
-	if (id == 0 || sbi->s_flags & AFFS_MOUNT_SF_SETUID)
+	if (id == 0 || affs_test_opt(sbi->s_flags, SF_SETUID))
 		inode->i_uid = sbi->s_uid;
-	else if (id == 0xFFFF && sbi->s_flags & AFFS_MOUNT_SF_MUFS)
+	else if (id == 0xFFFF && affs_test_opt(sbi->s_flags, SF_MUFS))
 		i_uid_write(inode, 0);
 	else
 		i_uid_write(inode, id);
 
 	id = be16_to_cpu(tail->gid);
-	if (id == 0 || sbi->s_flags & AFFS_MOUNT_SF_SETGID)
+	if (id == 0 || affs_test_opt(sbi->s_flags, SF_SETGID))
 		inode->i_gid = sbi->s_gid;
-	else if (id == 0xFFFF && sbi->s_flags & AFFS_MOUNT_SF_MUFS)
+	else if (id == 0xFFFF && affs_test_opt(sbi->s_flags, SF_MUFS))
 		i_gid_write(inode, 0);
 	else
 		i_gid_write(inode, id);
@@ -94,7 +94,7 @@ struct inode *affs_iget(struct super_blo
 		/* fall through */
 	case ST_USERDIR:
 		if (be32_to_cpu(tail->stype) == ST_USERDIR ||
-		    sbi->s_flags & AFFS_MOUNT_SF_SETMODE) {
+		    affs_test_opt(sbi->s_flags, SF_SETMODE)) {
 			if (inode->i_mode & S_IRUSR)
 				inode->i_mode |= S_IXUSR;
 			if (inode->i_mode & S_IRGRP)
@@ -133,7 +133,7 @@ struct inode *affs_iget(struct super_blo
 		}
 		if (tail->link_chain)
 			set_nlink(inode, 2);
-		inode->i_mapping->a_ops = (sbi->s_flags & AFFS_MOUNT_SF_OFS) ?
+		inode->i_mapping->a_ops = affs_test_opt(sbi->s_flags, SF_OFS) ?
 					  &affs_aops_ofs : &affs_aops;
 		inode->i_op = &affs_file_inode_operations;
 		inode->i_fop = &affs_file_operations;
@@ -191,15 +191,15 @@ affs_write_inode(struct inode *inode, st
 		if (!(inode->i_ino == AFFS_SB(sb)->s_root_block)) {
 			uid = i_uid_read(inode);
 			gid = i_gid_read(inode);
-			if (AFFS_SB(sb)->s_flags & AFFS_MOUNT_SF_MUFS) {
+			if (affs_test_opt(AFFS_SB(sb)->s_flags, SF_MUFS)) {
 				if (uid == 0 || uid == 0xFFFF)
 					uid = uid ^ ~0;
 				if (gid == 0 || gid == 0xFFFF)
 					gid = gid ^ ~0;
 			}
-			if (!(AFFS_SB(sb)->s_flags & AFFS_MOUNT_SF_SETUID))
+			if (!affs_test_opt(AFFS_SB(sb)->s_flags, SF_SETUID))
 				tail->uid = cpu_to_be16(uid);
-			if (!(AFFS_SB(sb)->s_flags & AFFS_MOUNT_SF_SETGID))
+			if (!affs_test_opt(AFFS_SB(sb)->s_flags, SF_SETGID))
 				tail->gid = cpu_to_be16(gid);
 		}
 	}
@@ -223,13 +223,13 @@ affs_notify_change(struct dentry *dentry
 		goto out;
 
 	if (((attr->ia_valid & ATTR_UID) &&
-	     (AFFS_SB(inode->i_sb)->s_flags & AFFS_MOUNT_SF_SETUID)) ||
+	      affs_test_opt(AFFS_SB(inode->i_sb)->s_flags, SF_SETUID)) ||
 	    ((attr->ia_valid & ATTR_GID) &&
-	     (AFFS_SB(inode->i_sb)->s_flags & AFFS_MOUNT_SF_SETGID)) ||
+	      affs_test_opt(AFFS_SB(inode->i_sb)->s_flags, SF_SETGID)) ||
 	    ((attr->ia_valid & ATTR_MODE) &&
 	     (AFFS_SB(inode->i_sb)->s_flags &
 	      (AFFS_MOUNT_SF_SETMODE | AFFS_MOUNT_SF_IMMUTABLE)))) {
-		if (!(AFFS_SB(inode->i_sb)->s_flags & AFFS_MOUNT_SF_QUIET))
+		if (!affs_test_opt(AFFS_SB(inode->i_sb)->s_flags, SF_QUIET))
 			error = -EPERM;
 		goto out;
 	}
diff -puN fs/affs/namei.c~fs-affs-use-affs_test_opt fs/affs/namei.c
--- a/fs/affs/namei.c~fs-affs-use-affs_test_opt
+++ a/fs/affs/namei.c
@@ -53,8 +53,8 @@ affs_intl_toupper(int ch)
 static inline toupper_t
 affs_get_toupper(struct super_block *sb)
 {
-	return AFFS_SB(sb)->s_flags & AFFS_MOUNT_SF_INTL ?
-				      affs_intl_toupper : affs_toupper;
+	return affs_test_opt(AFFS_SB(sb)->s_flags, SF_INTL) ?
+	       affs_intl_toupper : affs_toupper;
 }
 
 /*
@@ -276,7 +276,7 @@ affs_create(struct inode *dir, struct de
 
 	inode->i_op = &affs_file_inode_operations;
 	inode->i_fop = &affs_file_operations;
-	inode->i_mapping->a_ops = (AFFS_SB(sb)->s_flags & AFFS_MOUNT_SF_OFS) ?
+	inode->i_mapping->a_ops = affs_test_opt(AFFS_SB(sb)->s_flags, SF_OFS) ?
 				  &affs_aops_ofs : &affs_aops;
 	error = affs_add_entry(dir, inode, dentry, ST_FILE);
 	if (error) {
diff -puN fs/affs/super.c~fs-affs-use-affs_test_opt fs/affs/super.c
--- a/fs/affs/super.c~fs-affs-use-affs_test_opt
+++ a/fs/affs/super.c
@@ -468,7 +468,7 @@ got_root:
 		return -EINVAL;
 	}
 
-	if (mount_flags & AFFS_MOUNT_SF_VERBOSE) {
+	if (affs_test_opt(mount_flags, SF_VERBOSE)) {
 		u8 len = AFFS_ROOT_TAIL(sb, root_bh)->disk_name[0];
 		pr_notice("Mounting volume \"%.*s\": Type=%.3s\\%c, Blocksize=%d\n",
 			len > 31 ? 31 : len,
@@ -479,7 +479,7 @@ got_root:
 	sb->s_flags |= MS_NODEV | MS_NOSUID;
 
 	sbi->s_data_blksize = sb->s_blocksize;
-	if (sbi->s_flags & AFFS_MOUNT_SF_OFS)
+	if (affs_test_opt(sbi->s_flags, SF_OFS))
 		sbi->s_data_blksize -= 24;
 
 	tmp_flags = sb->s_flags;
@@ -494,7 +494,7 @@ got_root:
 	if (IS_ERR(root_inode))
 		return PTR_ERR(root_inode);
 
-	if (AFFS_SB(sb)->s_flags & AFFS_MOUNT_SF_INTL)
+	if (affs_test_opt(AFFS_SB(sb)->s_flags, SF_INTL))
 		sb->s_d_op = &affs_intl_dentry_operations;
 	else
 		sb->s_d_op = &affs_dentry_operations;
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
linux-next.patch

