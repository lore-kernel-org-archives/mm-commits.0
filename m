From: akpm@linux-foundation.org
Subject: - isofs-implement-dmode-option.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:18:51 -0800
Message-ID: <200802082018.m18KIWCB010940@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37618 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753098AbYBHU6R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:58:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, gin@mo.msk.ru, mm-commits@vger.kernel.org


The patch titled
     isofs: implement dmode option
has been removed from the -mm tree.  Its filename was
     isofs-implement-dmode-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 Documentation/filesystems/isofs.txt |    1 +
 fs/isofs/inode.c                    |   23 +++++++++++++++--------
 fs/isofs/isofs.h                    |    3 ++-
 3 files changed, 18 insertions(+), 9 deletions(-)

diff -puN Documentation/filesystems/isofs.txt~isofs-implement-dmode-option Documentation/filesystems/isofs.txt
--- a/Documentation/filesystems/isofs.txt~isofs-implement-dmode-option
+++ a/Documentation/filesystems/isofs.txt
@@ -24,6 +24,7 @@ Mount options unique to the isofs filesy
   map=normal    Map non-Rock Ridge filenames to lower case
   map=acorn     As map=normal but also apply Acorn extensions if present
   mode=xxx      Sets the permissions on files to xxx
+  dmode=xxx     Sets the permissions on directories to xxx
   nojoliet      Ignore Joliet extensions if they are present.
   norock        Ignore Rock Ridge extensions if they are present.
   hide		Completely strip hidden files from the file system.
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
@@ -1248,7 +1256,7 @@ static int isofs_read_inode(struct inode
 	ei->i_file_format = isofs_file_normal;
 
 	if (de->flags[-high_sierra] & 2) {
-		inode->i_mode = S_IRUGO | S_IXUGO | S_IFDIR;
+		inode->i_mode = sbi->s_dmode | S_IFDIR;
 		inode->i_nlink = 1;	/*
 					 * Set to 1.  We know there are 2, but
 					 * the find utility tries to optimize
@@ -1258,9 +1266,8 @@ static int isofs_read_inode(struct inode
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

origin.patch
