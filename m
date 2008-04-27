From: akpm@linux-foundation.org
Subject: + fat-add-allow_utime-option.patch added to -mm tree
Date: Sun, 27 Apr 2008 12:07:46 -0700
Message-ID: <200804271907.m3RJ7kI6020429@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38989 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762991AbYD0THt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 15:07:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp


The patch titled
     fat: Add allow_utime option
has been added to the -mm tree.  Its filename is
     fat-add-allow_utime-option.patch

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
Subject: fat: Add allow_utime option
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Normally utime(2) checks current process is owner of the file, or it
has CAP_FOWNER capability.  But FAT filesystem doesn't have uid/gid as
on disk info, so normal check is too unflexible.

With this option you can relax it.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/vfat.txt |   15 +++++++++++++++
 fs/fat/file.c                      |   24 ++++++++++++++++++++++++
 fs/fat/inode.c                     |   18 +++++++++++++++---
 include/linux/msdos_fs.h           |    1 +
 4 files changed, 55 insertions(+), 3 deletions(-)

diff -puN Documentation/filesystems/vfat.txt~fat-add-allow_utime-option Documentation/filesystems/vfat.txt
--- a/Documentation/filesystems/vfat.txt~fat-add-allow_utime-option
+++ a/Documentation/filesystems/vfat.txt
@@ -17,6 +17,21 @@ dmask=###     -- The permission mask for
 fmask=###     -- The permission mask for files.
                  The default is the umask of current process.
 
+allow_utime=### -- This option controls the permission check of mtime/atime.
+
+                  20 - If current process is in group of file's group ID,
+                       you can change timestamp.
+                   2 - Other users can change timestamp.
+
+                 The default is set from `dmask' option. (If the directory is
+                 writable, utime(2) is also allowed. I.e. ~dmask & 022)
+
+                 Normally utime(2) checks current process is owner of
+                 the file, or it has CAP_FOWNER capability.  But FAT
+                 filesystem doesn't have uid/gid on disk, so normal
+                 check is too unflexible. With this option you can
+                 relax it.
+
 codepage=###  -- Sets the codepage number for converting to shortname
 		 characters on FAT filesystem.
 		 By default, FAT_DEFAULT_CODEPAGE setting is used.
diff -puN fs/fat/file.c~fat-add-allow_utime-option fs/fat/file.c
--- a/fs/fat/file.c~fat-add-allow_utime-option
+++ a/fs/fat/file.c
@@ -280,11 +280,27 @@ static int fat_check_mode(const struct m
 	return 0;
 }
 
+static int fat_allow_set_time(struct msdos_sb_info *sbi, struct inode *inode)
+{
+	mode_t allow_utime = sbi->options.allow_utime;
+
+	if (current->fsuid != inode->i_uid) {
+		if (in_group_p(inode->i_gid))
+			allow_utime >>= 3;
+		if (allow_utime & MAY_WRITE)
+			return 1;
+	}
+
+	/* use a default check */
+	return 0;
+}
+
 int fat_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(dentry->d_sb);
 	struct inode *inode = dentry->d_inode;
 	int mask, error = 0;
+	unsigned int ia_valid;
 
 	lock_kernel();
 
@@ -302,7 +318,15 @@ int fat_setattr(struct dentry *dentry, s
 		}
 	}
 
+	/* Check for setting the inode time. */
+	ia_valid = attr->ia_valid;
+	if (ia_valid & (ATTR_MTIME_SET | ATTR_ATIME_SET)) {
+		if (fat_allow_set_time(sbi, inode))
+			attr->ia_valid &= ~(ATTR_MTIME_SET | ATTR_ATIME_SET);
+	}
+
 	error = inode_change_ok(inode, attr);
+	attr->ia_valid = ia_valid;
 	if (error) {
 		if (sbi->options.quiet)
 			error = 0;
diff -puN fs/fat/inode.c~fat-add-allow_utime-option fs/fat/inode.c
--- a/fs/fat/inode.c~fat-add-allow_utime-option
+++ a/fs/fat/inode.c
@@ -785,6 +785,8 @@ static int fat_show_options(struct seq_f
 		seq_printf(m, ",gid=%u", opts->fs_gid);
 	seq_printf(m, ",fmask=%04o", opts->fs_fmask);
 	seq_printf(m, ",dmask=%04o", opts->fs_dmask);
+	if (opts->allow_utime)
+		seq_printf(m, ",allow_utime=%04o", opts->allow_utime);
 	if (sbi->nls_disk)
 		seq_printf(m, ",codepage=%s", sbi->nls_disk->charset);
 	if (isvfat) {
@@ -840,9 +842,9 @@ static int fat_show_options(struct seq_f
 
 enum {
 	Opt_check_n, Opt_check_r, Opt_check_s, Opt_uid, Opt_gid,
-	Opt_umask, Opt_dmask, Opt_fmask, Opt_codepage, Opt_usefree, Opt_nocase,
-	Opt_quiet, Opt_showexec, Opt_debug, Opt_immutable,
-	Opt_dots, Opt_nodots,
+	Opt_umask, Opt_dmask, Opt_fmask, Opt_allow_utime, Opt_codepage,
+	Opt_usefree, Opt_nocase, Opt_quiet, Opt_showexec, Opt_debug,
+	Opt_immutable, Opt_dots, Opt_nodots,
 	Opt_charset, Opt_shortname_lower, Opt_shortname_win95,
 	Opt_shortname_winnt, Opt_shortname_mixed, Opt_utf8_no, Opt_utf8_yes,
 	Opt_uni_xl_no, Opt_uni_xl_yes, Opt_nonumtail_no, Opt_nonumtail_yes,
@@ -861,6 +863,7 @@ static match_table_t fat_tokens = {
 	{Opt_umask, "umask=%o"},
 	{Opt_dmask, "dmask=%o"},
 	{Opt_fmask, "fmask=%o"},
+	{Opt_allow_utime, "allow_utime=%o"},
 	{Opt_codepage, "codepage=%u"},
 	{Opt_usefree, "usefree"},
 	{Opt_nocase, "nocase"},
@@ -932,6 +935,7 @@ static int parse_options(char *options, 
 	opts->fs_uid = current->uid;
 	opts->fs_gid = current->gid;
 	opts->fs_fmask = opts->fs_dmask = current->fs->umask;
+	opts->allow_utime = -1;
 	opts->codepage = fat_default_codepage;
 	opts->iocharset = fat_default_iocharset;
 	if (is_vfat)
@@ -1019,6 +1023,11 @@ static int parse_options(char *options, 
 				return 0;
 			opts->fs_fmask = option;
 			break;
+		case Opt_allow_utime:
+			if (match_octal(&args[0], &option))
+				return 0;
+			opts->allow_utime = option & (S_IWGRP | S_IWOTH);
+			break;
 		case Opt_codepage:
 			if (match_int(&args[0], &option))
 				return 0;
@@ -1101,6 +1110,9 @@ static int parse_options(char *options, 
 		       " for FAT filesystems, filesystem will be case sensitive!\n");
 	}
 
+	/* If user doesn't specify allow_utime, it's initialized from dmask. */
+	if (opts->allow_utime == (unsigned short)-1)
+		opts->allow_utime = ~opts->fs_dmask & (S_IWGRP | S_IWOTH);
 	if (opts->unicode_xlate)
 		opts->utf8 = 0;
 
diff -puN include/linux/msdos_fs.h~fat-add-allow_utime-option include/linux/msdos_fs.h
--- a/include/linux/msdos_fs.h~fat-add-allow_utime-option
+++ a/include/linux/msdos_fs.h
@@ -195,6 +195,7 @@ struct fat_mount_options {
 	char *iocharset;          /* Charset used for filename input/display */
 	unsigned short shortname; /* flags for shortname display/create rule */
 	unsigned char name_check; /* r = relaxed, n = normal, s = strict */
+	unsigned short allow_utime;/* permission for setting the [am]time */
 	unsigned quiet:1,         /* set = fake successful chmods and chowns */
 		 showexec:1,      /* set = only set x bit for com/exe/bat */
 		 sys_immutable:1, /* set = system files are immutable */
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

fat-kill-is_bad_inode-check.patch
fat-fat_notify_change-and-check_mode-cleanup.patch
fat-fat_setattr-fix.patch
fat-add-allow_utime-option.patch
fat-update-free_clusters-even-if-it-is-untrusted.patch
fat-remove-fat_clusters_flush.patch
add-balance_dirty_pages_ratelimited-to-cont_expand_zero.patch
vfat-bug-fix-for-vfat-cannot-handle-filename-with-255.patch
fat-use-__getname.patch
fat_valid_media-remove-pointless-test.patch
fat-detect-media-without-partition-table-correctly.patch
fatfs-fix-build-warning-with-64k-page_size.patch
fat-use-get-put_unaligned_-helpers.patch

