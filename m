From: akpm@linux-foundation.org
Subject: + isofs-implement-dmode-option.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:18:21 -0800
Message-ID: <200801270518.m0R5IIba031196@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55741 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751244AbYA0FSt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:18:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, gin@mo.msk.ru


The patch titled
     isofs: implement dmode option
has been added to the -mm tree.  Its filename is
     isofs-implement-dmode-option.patch

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
Subject: isofs: implement dmode option
From: Jan Kara <jack@suse.cz>

Implement dmode option for iso9660 filesystem to allow setting of access
rights for directories on the filesystem.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: "Ilya N. Golubev" <gin@mo.msk.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/isofs/inode.c |   23 +++++++++++++++--------
 fs/isofs/isofs.h |    3 ++-
 2 files changed, 17 insertions(+), 9 deletions(-)

diff -puN fs/isofs/inode.c~isofs-implement-dmode-option fs/isofs/inode.c
--- a/fs/isofs/inode.c~isofs-implement-dmode-option
+++ a/fs/isofs/inode.c
@@ -144,7 +144,8 @@ struct iso9660_options{
 	char nocompress;
 	unsigned char check;
 	unsigned int blocksize;
-	mode_t mode;
+	mode_t fmode;
+	mode_t dmode;
 	gid_t gid;
 	uid_t uid;
 	char *iocharset;
@@ -305,7 +306,7 @@ enum {
 	Opt_block, Opt_check_r, Opt_check_s, Opt_cruft, Opt_gid, Opt_ignore,
 	Opt_iocharset, Opt_map_a, Opt_map_n, Opt_map_o, Opt_mode, Opt_nojoliet,
 	Opt_norock, Opt_sb, Opt_session, Opt_uid, Opt_unhide, Opt_utf8, Opt_err,
-	Opt_nocompress, Opt_hide, Opt_showassoc,
+	Opt_nocompress, Opt_hide, Opt_showassoc, Opt_dmode,
 };
 
 static match_table_t tokens = {
@@ -332,6 +333,7 @@ static match_table_t tokens = {
 	{Opt_uid, "uid=%u"},
 	{Opt_gid, "gid=%u"},
 	{Opt_mode, "mode=%u"},
+	{Opt_dmode, "dmode=%u"},
 	{Opt_block, "block=%u"},
 	{Opt_ignore, "conv=binary"},
 	{Opt_ignore, "conv=b"},
@@ -359,7 +361,7 @@ static int parse_options(char *options, 
 	popt->check = 'u';		/* unset */
 	popt->nocompress = 0;
 	popt->blocksize = 1024;
-	popt->mode = S_IRUGO | S_IXUGO; /*
+	popt->fmode = popt->dmode = S_IRUGO | S_IXUGO; /*
 					 * r-x for all.  The disc could
 					 * be shared with DOS machines so
 					 * virtually anything could be
@@ -451,7 +453,12 @@ static int parse_options(char *options, 
 		case Opt_mode:
 			if (match_int(&args[0], &option))
 				return 0;
-			popt->mode = option;
+			popt->fmode = option;
+			break;
+		case Opt_dmode:
+			if (match_int(&args[0], &option))
+				return 0;
+			popt->dmode = option;
 			break;
 		case Opt_block:
 			if (match_int(&args[0], &option))
@@ -801,7 +808,8 @@ root_found:
 	 * on the disk as suid, so we merely allow them to set the default
 	 * permissions.
 	 */
-	sbi->s_mode = opt.mode & 0777;
+	sbi->s_fmode = opt.fmode & 0777;
+	sbi->s_dmode = opt.dmode & 0777;
 
 	/*
 	 * Read the root inode, which _may_ result in changing
@@ -1244,7 +1252,7 @@ static int isofs_read_inode(struct inode
 	ei->i_file_format = isofs_file_normal;
 
 	if (de->flags[-high_sierra] & 2) {
-		inode->i_mode = S_IRUGO | S_IXUGO | S_IFDIR;
+		inode->i_mode = sbi->s_dmode | S_IFDIR;
 		inode->i_nlink = 1;	/*
 					 * Set to 1.  We know there are 2, but
 					 * the find utility tries to optimize
@@ -1254,9 +1262,8 @@ static int isofs_read_inode(struct inode
 					 */
 	} else {
 		/* Everybody gets to read the file. */
-		inode->i_mode = sbi->s_mode;
+		inode->i_mode = sbi->s_fmode | S_IFREG;
 		inode->i_nlink = 1;
-		inode->i_mode |= S_IFREG;
 	}
 	inode->i_uid = sbi->s_uid;
 	inode->i_gid = sbi->s_gid;
diff -puN fs/isofs/isofs.h~isofs-implement-dmode-option fs/isofs/isofs.h
--- a/fs/isofs/isofs.h~isofs-implement-dmode-option
+++ a/fs/isofs/isofs.h
@@ -51,7 +51,8 @@ struct isofs_sb_info {
 	unsigned char s_hide;
 	unsigned char s_showassoc;
 
-	mode_t s_mode;
+	mode_t s_fmode;
+	mode_t s_dmode;
 	gid_t s_gid;
 	uid_t s_uid;
 	struct nls_table *s_nls_iocharset; /* Native language support table */
_

Patches currently in -mm which might be from jack@suse.cz are

git-ocfs2.patch
inotify-send-in_attrib-events-when-link-count-changes.patch
inotify-send-in_attrib-events-when-link-count-changes-fix.patch
quota-improve-inode-list-scanning-in-add_dquot_ref.patch
quota-improve-inode-list-scanning-in-add_dquot_ref-fix.patch
jbd-fix-commit-block-write.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext4-from-using-iget-and-read_inode-try.patch
use-pgoff_t-instead-of-unsigned-long.patch
write_inode_now-avoid-unnecessary-synchronous-write.patch
udf-fix-coding-style-of-superc.patch
udf-remove-some-ugly-macros.patch
udf-convert-udf_sb_alloc_partmaps-macro-to-udf_sb_alloc_partition_maps-function.patch
udf-check-if-udf_load_logicalvol-failed.patch
udf-convert-macros-related-to-bitmaps-to-functions.patch
udf-move-calculating-of-nr_groups-into-helper-function.patch
udf-fix-sparse-warnings-shadowing-mismatch-between-declaration-and-definition.patch
udf-fix-coding-style.patch
udf-create-common-function-for-tag-checksumming.patch
udf-create-common-function-for-changing-free-space-counter.patch
udf-replace-loops-coded-with-goto-to-real-loops.patch
udf-convert-byte-order-of-constant-instead-of-variable.patch
udf-remove-udf_i_-macros-and-open-code-them.patch
udf-cache-struct-udf_inode_info.patch
udf-fix-udf_debug-macro.patch
udf-improve-readability-of-udf_load_partition.patch
udf-remove-wrong-prototype-of-udf_readdir.patch
udf-fix-3-signedness-1-unitialized-variable-warnings.patch
udf-fix-signedness-issue.patch
udf-avoid-unnecessary-synchronous-writes.patch
isofs-implement-dmode-option.patch
