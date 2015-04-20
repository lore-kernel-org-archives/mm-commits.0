From: akpm@linux-foundation.org
Subject: [merged] fs-affs-use-affs_mount-prefix-for-mount-options.patch
 removed from -mm tree
Date: Mon, 20 Apr 2015 12:20:06 -0700
Message-ID: <55355166.Sl9c7DAO5K4jRp8G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40426 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978AbbDTTNp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:13:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs: use AFFS_MOUNT prefix for mount options
has been removed from the -mm tree.  Its filename was
     fs-affs-use-affs_mount-prefix-for-mount-options.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs: use AFFS_MOUNT prefix for mount options

Currently, affs still uses direct access on mount_options.  This patch
prepares to use affs_clear/set/test_opt() like other filesystems.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/affs.h     |   24 ++++++++++++------------
 fs/affs/amigaffs.c |    2 +-
 fs/affs/file.c     |    2 +-
 fs/affs/inode.c    |   32 ++++++++++++++++++--------------
 fs/affs/namei.c    |    6 ++++--
 fs/affs/super.c    |   36 ++++++++++++++++++------------------
 6 files changed, 54 insertions(+), 48 deletions(-)

diff -puN fs/affs/affs.h~fs-affs-use-affs_mount-prefix-for-mount-options fs/affs/affs.h
--- a/fs/affs/affs.h~fs-affs-use-affs_mount-prefix-for-mount-options
+++ a/fs/affs/affs.h
@@ -106,18 +106,18 @@ struct affs_sb_info {
 	spinlock_t work_lock;		/* protects sb_work and work_queued */
 };
 
-#define SF_INTL		0x0001		/* International filesystem. */
-#define SF_BM_VALID	0x0002		/* Bitmap is valid. */
-#define SF_IMMUTABLE	0x0004		/* Protection bits cannot be changed */
-#define SF_QUIET	0x0008		/* chmod errors will be not reported */
-#define SF_SETUID	0x0010		/* Ignore Amiga uid */
-#define SF_SETGID	0x0020		/* Ignore Amiga gid */
-#define SF_SETMODE	0x0040		/* Ignore Amiga protection bits */
-#define SF_MUFS		0x0100		/* Use MUFS uid/gid mapping */
-#define SF_OFS		0x0200		/* Old filesystem */
-#define SF_PREFIX	0x0400		/* Buffer for prefix is allocated */
-#define SF_VERBOSE	0x0800		/* Talk about fs when mounting */
-#define SF_NO_TRUNCATE	0x1000		/* Don't truncate filenames */
+#define AFFS_MOUNT_SF_INTL		0x0001 /* International filesystem. */
+#define AFFS_MOUNT_SF_BM_VALID		0x0002 /* Bitmap is valid. */
+#define AFFS_MOUNT_SF_IMMUTABLE		0x0004 /* Protection bits cannot be changed */
+#define AFFS_MOUNT_SF_QUIET		0x0008 /* chmod errors will be not reported */
+#define AFFS_MOUNT_SF_SETUID		0x0010 /* Ignore Amiga uid */
+#define AFFS_MOUNT_SF_SETGID		0x0020 /* Ignore Amiga gid */
+#define AFFS_MOUNT_SF_SETMODE		0x0040 /* Ignore Amiga protection bits */
+#define AFFS_MOUNT_SF_MUFS		0x0100 /* Use MUFS uid/gid mapping */
+#define AFFS_MOUNT_SF_OFS		0x0200 /* Old filesystem */
+#define AFFS_MOUNT_SF_PREFIX		0x0400 /* Buffer for prefix is allocated */
+#define AFFS_MOUNT_SF_VERBOSE		0x0800 /* Talk about fs when mounting */
+#define AFFS_MOUNT_SF_NO_TRUNCATE	0x1000 /* Don't truncate filenames */
 
 /* short cut to get to the affs specific sb data */
 static inline struct affs_sb_info *AFFS_SB(struct super_block *sb)
diff -puN fs/affs/amigaffs.c~fs-affs-use-affs_mount-prefix-for-mount-options fs/affs/amigaffs.c
--- a/fs/affs/amigaffs.c~fs-affs-use-affs_mount-prefix-for-mount-options
+++ a/fs/affs/amigaffs.c
@@ -472,7 +472,7 @@ bool
 affs_nofilenametruncate(const struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
-	return AFFS_SB(inode->i_sb)->s_flags & SF_NO_TRUNCATE;
+	return AFFS_SB(inode->i_sb)->s_flags & AFFS_MOUNT_SF_NO_TRUNCATE;
 
 }
 
diff -puN fs/affs/file.c~fs-affs-use-affs_mount-prefix-for-mount-options fs/affs/file.c
--- a/fs/affs/file.c~fs-affs-use-affs_mount-prefix-for-mount-options
+++ a/fs/affs/file.c
@@ -915,7 +915,7 @@ affs_truncate(struct inode *inode)
 	if (inode->i_size) {
 		AFFS_I(inode)->i_blkcnt = last_blk + 1;
 		AFFS_I(inode)->i_extcnt = ext + 1;
-		if (AFFS_SB(sb)->s_flags & SF_OFS) {
+		if (AFFS_SB(sb)->s_flags & AFFS_MOUNT_SF_OFS) {
 			struct buffer_head *bh = affs_bread_ino(inode, last_blk, 0);
 			u32 tmp;
 			if (IS_ERR(bh)) {
diff -puN fs/affs/inode.c~fs-affs-use-affs_mount-prefix-for-mount-options fs/affs/inode.c
--- a/fs/affs/inode.c~fs-affs-use-affs_mount-prefix-for-mount-options
+++ a/fs/affs/inode.c
@@ -66,23 +66,23 @@ struct inode *affs_iget(struct super_blo
 	AFFS_I(inode)->i_lastalloc = 0;
 	AFFS_I(inode)->i_pa_cnt = 0;
 
-	if (sbi->s_flags & SF_SETMODE)
+	if (sbi->s_flags & AFFS_MOUNT_SF_SETMODE)
 		inode->i_mode = sbi->s_mode;
 	else
 		inode->i_mode = prot_to_mode(prot);
 
 	id = be16_to_cpu(tail->uid);
-	if (id == 0 || sbi->s_flags & SF_SETUID)
+	if (id == 0 || sbi->s_flags & AFFS_MOUNT_SF_SETUID)
 		inode->i_uid = sbi->s_uid;
-	else if (id == 0xFFFF && sbi->s_flags & SF_MUFS)
+	else if (id == 0xFFFF && sbi->s_flags & AFFS_MOUNT_SF_MUFS)
 		i_uid_write(inode, 0);
 	else
 		i_uid_write(inode, id);
 
 	id = be16_to_cpu(tail->gid);
-	if (id == 0 || sbi->s_flags & SF_SETGID)
+	if (id == 0 || sbi->s_flags & AFFS_MOUNT_SF_SETGID)
 		inode->i_gid = sbi->s_gid;
-	else if (id == 0xFFFF && sbi->s_flags & SF_MUFS)
+	else if (id == 0xFFFF && sbi->s_flags & AFFS_MOUNT_SF_MUFS)
 		i_gid_write(inode, 0);
 	else
 		i_gid_write(inode, id);
@@ -94,7 +94,7 @@ struct inode *affs_iget(struct super_blo
 		/* fall through */
 	case ST_USERDIR:
 		if (be32_to_cpu(tail->stype) == ST_USERDIR ||
-		    sbi->s_flags & SF_SETMODE) {
+		    sbi->s_flags & AFFS_MOUNT_SF_SETMODE) {
 			if (inode->i_mode & S_IRUSR)
 				inode->i_mode |= S_IXUSR;
 			if (inode->i_mode & S_IRGRP)
@@ -133,7 +133,8 @@ struct inode *affs_iget(struct super_blo
 		}
 		if (tail->link_chain)
 			set_nlink(inode, 2);
-		inode->i_mapping->a_ops = (sbi->s_flags & SF_OFS) ? &affs_aops_ofs : &affs_aops;
+		inode->i_mapping->a_ops = (sbi->s_flags & AFFS_MOUNT_SF_OFS) ?
+					  &affs_aops_ofs : &affs_aops;
 		inode->i_op = &affs_file_inode_operations;
 		inode->i_fop = &affs_file_operations;
 		break;
@@ -190,15 +191,15 @@ affs_write_inode(struct inode *inode, st
 		if (!(inode->i_ino == AFFS_SB(sb)->s_root_block)) {
 			uid = i_uid_read(inode);
 			gid = i_gid_read(inode);
-			if (AFFS_SB(sb)->s_flags & SF_MUFS) {
+			if (AFFS_SB(sb)->s_flags & AFFS_MOUNT_SF_MUFS) {
 				if (uid == 0 || uid == 0xFFFF)
 					uid = uid ^ ~0;
 				if (gid == 0 || gid == 0xFFFF)
 					gid = gid ^ ~0;
 			}
-			if (!(AFFS_SB(sb)->s_flags & SF_SETUID))
+			if (!(AFFS_SB(sb)->s_flags & AFFS_MOUNT_SF_SETUID))
 				tail->uid = cpu_to_be16(uid);
-			if (!(AFFS_SB(sb)->s_flags & SF_SETGID))
+			if (!(AFFS_SB(sb)->s_flags & AFFS_MOUNT_SF_SETGID))
 				tail->gid = cpu_to_be16(gid);
 		}
 	}
@@ -221,11 +222,14 @@ affs_notify_change(struct dentry *dentry
 	if (error)
 		goto out;
 
-	if (((attr->ia_valid & ATTR_UID) && (AFFS_SB(inode->i_sb)->s_flags & SF_SETUID)) ||
-	    ((attr->ia_valid & ATTR_GID) && (AFFS_SB(inode->i_sb)->s_flags & SF_SETGID)) ||
+	if (((attr->ia_valid & ATTR_UID) &&
+	     (AFFS_SB(inode->i_sb)->s_flags & AFFS_MOUNT_SF_SETUID)) ||
+	    ((attr->ia_valid & ATTR_GID) &&
+	     (AFFS_SB(inode->i_sb)->s_flags & AFFS_MOUNT_SF_SETGID)) ||
 	    ((attr->ia_valid & ATTR_MODE) &&
-	     (AFFS_SB(inode->i_sb)->s_flags & (SF_SETMODE | SF_IMMUTABLE)))) {
-		if (!(AFFS_SB(inode->i_sb)->s_flags & SF_QUIET))
+	     (AFFS_SB(inode->i_sb)->s_flags &
+	      (AFFS_MOUNT_SF_SETMODE | AFFS_MOUNT_SF_IMMUTABLE)))) {
+		if (!(AFFS_SB(inode->i_sb)->s_flags & AFFS_MOUNT_SF_QUIET))
 			error = -EPERM;
 		goto out;
 	}
diff -puN fs/affs/namei.c~fs-affs-use-affs_mount-prefix-for-mount-options fs/affs/namei.c
--- a/fs/affs/namei.c~fs-affs-use-affs_mount-prefix-for-mount-options
+++ a/fs/affs/namei.c
@@ -53,7 +53,8 @@ affs_intl_toupper(int ch)
 static inline toupper_t
 affs_get_toupper(struct super_block *sb)
 {
-	return AFFS_SB(sb)->s_flags & SF_INTL ? affs_intl_toupper : affs_toupper;
+	return AFFS_SB(sb)->s_flags & AFFS_MOUNT_SF_INTL ?
+				      affs_intl_toupper : affs_toupper;
 }
 
 /*
@@ -275,7 +276,8 @@ affs_create(struct inode *dir, struct de
 
 	inode->i_op = &affs_file_inode_operations;
 	inode->i_fop = &affs_file_operations;
-	inode->i_mapping->a_ops = (AFFS_SB(sb)->s_flags & SF_OFS) ? &affs_aops_ofs : &affs_aops;
+	inode->i_mapping->a_ops = (AFFS_SB(sb)->s_flags & AFFS_MOUNT_SF_OFS) ?
+				  &affs_aops_ofs : &affs_aops;
 	error = affs_add_entry(dir, inode, dentry, ST_FILE);
 	if (error) {
 		clear_nlink(inode);
diff -puN fs/affs/super.c~fs-affs-use-affs_mount-prefix-for-mount-options fs/affs/super.c
--- a/fs/affs/super.c~fs-affs-use-affs_mount-prefix-for-mount-options
+++ a/fs/affs/super.c
@@ -227,22 +227,22 @@ parse_options(char *options, kuid_t *uid
 			if (match_octal(&args[0], &option))
 				return 0;
 			*mode = option & 0777;
-			*mount_opts |= SF_SETMODE;
+			*mount_opts |= AFFS_MOUNT_SF_SETMODE;
 			break;
 		case Opt_mufs:
-			*mount_opts |= SF_MUFS;
+			*mount_opts |= AFFS_MOUNT_SF_MUFS;
 			break;
 		case Opt_notruncate:
-			*mount_opts |= SF_NO_TRUNCATE;
+			*mount_opts |= AFFS_MOUNT_SF_NO_TRUNCATE;
 			break;
 		case Opt_prefix:
 			*prefix = match_strdup(&args[0]);
 			if (!*prefix)
 				return 0;
-			*mount_opts |= SF_PREFIX;
+			*mount_opts |= AFFS_MOUNT_SF_PREFIX;
 			break;
 		case Opt_protect:
-			*mount_opts |= SF_IMMUTABLE;
+			*mount_opts |= AFFS_MOUNT_SF_IMMUTABLE;
 			break;
 		case Opt_reserved:
 			if (match_int(&args[0], reserved))
@@ -258,7 +258,7 @@ parse_options(char *options, kuid_t *uid
 			*gid = make_kgid(current_user_ns(), option);
 			if (!gid_valid(*gid))
 				return 0;
-			*mount_opts |= SF_SETGID;
+			*mount_opts |= AFFS_MOUNT_SF_SETGID;
 			break;
 		case Opt_setuid:
 			if (match_int(&args[0], &option))
@@ -266,10 +266,10 @@ parse_options(char *options, kuid_t *uid
 			*uid = make_kuid(current_user_ns(), option);
 			if (!uid_valid(*uid))
 				return 0;
-			*mount_opts |= SF_SETUID;
+			*mount_opts |= AFFS_MOUNT_SF_SETUID;
 			break;
 		case Opt_verbose:
-			*mount_opts |= SF_VERBOSE;
+			*mount_opts |= AFFS_MOUNT_SF_VERBOSE;
 			break;
 		case Opt_volume: {
 			char *vol = match_strdup(&args[0]);
@@ -435,30 +435,30 @@ got_root:
 	case MUFS_FS:
 	case MUFS_INTLFFS:
 	case MUFS_DCFFS:
-		sbi->s_flags |= SF_MUFS;
+		sbi->s_flags |= AFFS_MOUNT_SF_MUFS;
 		/* fall thru */
 	case FS_INTLFFS:
 	case FS_DCFFS:
-		sbi->s_flags |= SF_INTL;
+		sbi->s_flags |= AFFS_MOUNT_SF_INTL;
 		break;
 	case MUFS_FFS:
-		sbi->s_flags |= SF_MUFS;
+		sbi->s_flags |= AFFS_MOUNT_SF_MUFS;
 		break;
 	case FS_FFS:
 		break;
 	case MUFS_OFS:
-		sbi->s_flags |= SF_MUFS;
+		sbi->s_flags |= AFFS_MOUNT_SF_MUFS;
 		/* fall thru */
 	case FS_OFS:
-		sbi->s_flags |= SF_OFS;
+		sbi->s_flags |= AFFS_MOUNT_SF_OFS;
 		sb->s_flags |= MS_NOEXEC;
 		break;
 	case MUFS_DCOFS:
 	case MUFS_INTLOFS:
-		sbi->s_flags |= SF_MUFS;
+		sbi->s_flags |= AFFS_MOUNT_SF_MUFS;
 	case FS_DCOFS:
 	case FS_INTLOFS:
-		sbi->s_flags |= SF_INTL | SF_OFS;
+		sbi->s_flags |= AFFS_MOUNT_SF_INTL | AFFS_MOUNT_SF_OFS;
 		sb->s_flags |= MS_NOEXEC;
 		break;
 	default:
@@ -467,7 +467,7 @@ got_root:
 		return -EINVAL;
 	}
 
-	if (mount_flags & SF_VERBOSE) {
+	if (mount_flags & AFFS_MOUNT_SF_VERBOSE) {
 		u8 len = AFFS_ROOT_TAIL(sb, root_bh)->disk_name[0];
 		pr_notice("Mounting volume \"%.*s\": Type=%.3s\\%c, Blocksize=%d\n",
 			len > 31 ? 31 : len,
@@ -478,7 +478,7 @@ got_root:
 	sb->s_flags |= MS_NODEV | MS_NOSUID;
 
 	sbi->s_data_blksize = sb->s_blocksize;
-	if (sbi->s_flags & SF_OFS)
+	if (sbi->s_flags & AFFS_MOUNT_SF_OFS)
 		sbi->s_data_blksize -= 24;
 
 	tmp_flags = sb->s_flags;
@@ -493,7 +493,7 @@ got_root:
 	if (IS_ERR(root_inode))
 		return PTR_ERR(root_inode);
 
-	if (AFFS_SB(sb)->s_flags & SF_INTL)
+	if (AFFS_SB(sb)->s_flags & AFFS_MOUNT_SF_INTL)
 		sb->s_d_op = &affs_intl_dentry_operations;
 	else
 		sb->s_d_op = &affs_dentry_operations;
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
linux-next.patch

