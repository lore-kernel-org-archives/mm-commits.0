From: akpm@linux-foundation.org
Subject: - fat-fix-attr_ro-for-directory.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:33:37 -0800
Message-ID: <200811102033.mAAKXbB4024587@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47727 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752968AbYKJUeJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:34:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     fat: Fix ATTR_RO for directory
has been removed from the -mm tree.  Its filename was
     fat-fix-attr_ro-for-directory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fat: Fix ATTR_RO for directory
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

FAT has the ATTR_RO (read-only) attribute. But on Windows, the ATTR_RO
of the directory will be just ignored actually, and is used by only
applications as flag. E.g. it's setted for the customized folder by
Explorer.

http://msdn2.microsoft.com/en-us/library/aa969337.aspx

This adds "rodir" option. If user specified it, ATTR_RO is used as
read-only flag even if it's the directory. Otherwise, inode->i_mode
is not used to hold ATTR_RO (i.e. fat_mode_can_save_ro() returns 0).

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/vfat.txt |    8 ++++++++
 fs/fat/fat.h                       |   14 ++++++++++----
 fs/fat/file.c                      |   16 ++++++++++++----
 fs/fat/inode.c                     |   17 +++++++++++++----
 4 files changed, 43 insertions(+), 12 deletions(-)

diff -puN Documentation/filesystems/vfat.txt~fat-fix-attr_ro-for-directory Documentation/filesystems/vfat.txt
--- a/Documentation/filesystems/vfat.txt~fat-fix-attr_ro-for-directory
+++ a/Documentation/filesystems/vfat.txt
@@ -124,6 +124,14 @@ sys_immutable -- If set, ATTR_SYS attrib
 flush         -- If set, the filesystem will try to flush to disk more
 		 early than normal. Not set by default.
 
+rodir	      -- FAT has the ATTR_RO (read-only) attribute. But on Windows,
+		 the ATTR_RO of the directory will be just ignored actually,
+		 and is used by only applications as flag. E.g. it's setted
+		 for the customized folder.
+
+		 If you want to use ATTR_RO as read-only flag even for
+		 the directory, set this option.
+
 <bool>: 0,1,yes,no,true,false
 
 TODO
diff -puN fs/fat/fat.h~fat-fix-attr_ro-for-directory fs/fat/fat.h
--- a/fs/fat/fat.h~fat-fix-attr_ro-for-directory
+++ a/fs/fat/fat.h
@@ -38,7 +38,8 @@ struct fat_mount_options {
 		 flush:1,	  /* write things quickly */
 		 nocase:1,	  /* Does this need case conversion? 0=need case conversion*/
 		 usefree:1,	  /* Use free_clusters for FAT32 */
-		 tz_utc:1;	  /* Filesystem timestamps are in UTC */
+		 tz_utc:1,	  /* Filesystem timestamps are in UTC */
+		 rodir:1;	  /* allow ATTR_RO for directory */
 };
 
 #define FAT_HASH_BITS	8
@@ -120,15 +121,20 @@ static inline struct msdos_inode_info *M
 /*
  * If ->i_mode can't hold S_IWUGO (i.e. ATTR_RO), we use ->i_attrs to
  * save ATTR_RO instead of ->i_mode.
+ *
+ * If it's directory and !sbi->options.rodir, ATTR_RO isn't read-only
+ * bit, it's just used as flag for app.
  */
 static inline int fat_mode_can_hold_ro(struct inode *inode)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
 	mode_t mask;
 
-	if (S_ISDIR(inode->i_mode))
+	if (S_ISDIR(inode->i_mode)) {
+		if (!sbi->options.rodir)
+			return 0;
 		mask = ~sbi->options.fs_dmask;
-	else
+	} else
 		mask = ~sbi->options.fs_fmask;
 
 	if (!(mask & S_IWUGO))
@@ -140,7 +146,7 @@ static inline int fat_mode_can_hold_ro(s
 static inline mode_t fat_make_mode(struct msdos_sb_info *sbi,
 				   u8 attrs, mode_t mode)
 {
-	if (attrs & ATTR_RO)
+	if (attrs & ATTR_RO && !((attrs & ATTR_DIR) && !sbi->options.rodir))
 		mode &= ~S_IWUGO;
 
 	if (attrs & ATTR_DIR)
diff -puN fs/fat/file.c~fat-fix-attr_ro-for-directory fs/fat/file.c
--- a/fs/fat/file.c~fat-fix-attr_ro-for-directory
+++ a/fs/fat/file.c
@@ -282,11 +282,18 @@ static int fat_sanitize_mode(const struc
 	/*
 	 * Of the r and x bits, all (subject to umask) must be present. Of the
 	 * w bits, either all (subject to umask) or none must be present.
+	 *
+	 * If fat_mode_can_hold_ro(inode) is false, can't change w bits.
 	 */
 	if ((perm & (S_IRUGO | S_IXUGO)) != (inode->i_mode & (S_IRUGO|S_IXUGO)))
 		return -EPERM;
-	if ((perm & S_IWUGO) && ((perm & S_IWUGO) != (S_IWUGO & ~mask)))
-		return -EPERM;
+	if (fat_mode_can_hold_ro(inode)) {
+		if ((perm & S_IWUGO) && ((perm & S_IWUGO) != (S_IWUGO & ~mask)))
+			return -EPERM;
+	} else {
+		if ((perm & S_IWUGO) != (S_IWUGO & ~mask))
+			return -EPERM;
+	}
 
 	*mode_ptr &= S_IFMT | perm;
 
@@ -316,8 +323,8 @@ int fat_setattr(struct dentry *dentry, s
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(dentry->d_sb);
 	struct inode *inode = dentry->d_inode;
-	int error = 0;
 	unsigned int ia_valid;
+	int error;
 
 	/*
 	 * Expand the file. Since inode_setattr() updates ->i_size
@@ -371,7 +378,8 @@ int fat_setattr(struct dentry *dentry, s
 			attr->ia_valid &= ~ATTR_MODE;
 	}
 
-	error = inode_setattr(inode, attr);
+	if (attr->ia_valid)
+		error = inode_setattr(inode, attr);
 out:
 	return error;
 }
diff -puN fs/fat/inode.c~fat-fix-attr_ro-for-directory fs/fat/inode.c
--- a/fs/fat/inode.c~fat-fix-attr_ro-for-directory
+++ a/fs/fat/inode.c
@@ -797,8 +797,10 @@ static int fat_show_options(struct seq_f
 			seq_puts(m, ",uni_xlate");
 		if (!opts->numtail)
 			seq_puts(m, ",nonumtail");
+		if (opts->rodir)
+			seq_puts(m, ",rodir");
 	}
-	if (sbi->options.flush)
+	if (opts->flush)
 		seq_puts(m, ",flush");
 	if (opts->tz_utc)
 		seq_puts(m, ",tz=UTC");
@@ -814,7 +816,7 @@ enum {
 	Opt_charset, Opt_shortname_lower, Opt_shortname_win95,
 	Opt_shortname_winnt, Opt_shortname_mixed, Opt_utf8_no, Opt_utf8_yes,
 	Opt_uni_xl_no, Opt_uni_xl_yes, Opt_nonumtail_no, Opt_nonumtail_yes,
-	Opt_obsolate, Opt_flush, Opt_tz_utc, Opt_err,
+	Opt_obsolate, Opt_flush, Opt_tz_utc, Opt_rodir, Opt_err,
 };
 
 static const match_table_t fat_tokens = {
@@ -886,6 +888,7 @@ static const match_table_t vfat_tokens =
 	{Opt_nonumtail_yes, "nonumtail=yes"},
 	{Opt_nonumtail_yes, "nonumtail=true"},
 	{Opt_nonumtail_yes, "nonumtail"},
+	{Opt_rodir, "rodir"},
 	{Opt_err, NULL}
 };
 
@@ -905,10 +908,13 @@ static int parse_options(char *options, 
 	opts->allow_utime = -1;
 	opts->codepage = fat_default_codepage;
 	opts->iocharset = fat_default_iocharset;
-	if (is_vfat)
+	if (is_vfat) {
 		opts->shortname = VFAT_SFN_DISPLAY_LOWER|VFAT_SFN_CREATE_WIN95;
-	else
+		opts->rodir = 0;
+	} else {
 		opts->shortname = 0;
+		opts->rodir = 1;
+	}
 	opts->name_check = 'n';
 	opts->quiet = opts->showexec = opts->sys_immutable = opts->dotsOK =  0;
 	opts->utf8 = opts->unicode_xlate = 0;
@@ -1059,6 +1065,9 @@ static int parse_options(char *options, 
 		case Opt_nonumtail_yes:		/* empty or 1 or yes or true */
 			opts->numtail = 0;	/* negated option */
 			break;
+		case Opt_rodir:
+			opts->rodir = 1;
+			break;
 
 		/* obsolete mount options */
 		case Opt_obsolate:
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

linux-next.patch

