From: akpm@linux-foundation.org
Subject: + isofs-let-mode-and-dmode-mount-options-override-rock-ridge-mode-setting.patch added to -mm tree
Date: Thu, 16 Apr 2009 17:03:46 -0700
Message-ID: <200904170003.n3H03kBu006092@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758702AbZDQAGx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Apr 2009 20:06:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, Hans-Joachim.Baader@cjt.de


The patch titled
     isofs: let mode and dmode mount options override rock ridge mode setting
has been added to the -mm tree.  Its filename is
     isofs-let-mode-and-dmode-mount-options-override-rock-ridge-mode-setting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isofs: let mode and dmode mount options override rock ridge mode setting
From: Jan Kara <jack@suse.cz>

So far, permissions set via 'mode' and/or 'dmode' mount options were
effective only if the medium had no rock ridge extensions (or was mounted
without them).  Add 'overriderockmode' mount option to indicate that these
options should override permissions set in rock ridge extensions.  Maybe
this should be default but the current behavior is there since mount
options were created so I think we should not change how they behave.

Cc: <Hans-Joachim.Baader@cjt.de>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/isofs.txt |    9 +++-
 fs/isofs/inode.c                    |   50 +++++++++++++++++++-------
 fs/isofs/isofs.h                    |    3 +
 3 files changed, 48 insertions(+), 14 deletions(-)

diff -puN Documentation/filesystems/isofs.txt~isofs-let-mode-and-dmode-mount-options-override-rock-ridge-mode-setting Documentation/filesystems/isofs.txt
--- a/Documentation/filesystems/isofs.txt~isofs-let-mode-and-dmode-mount-options-override-rock-ridge-mode-setting
+++ a/Documentation/filesystems/isofs.txt
@@ -23,8 +23,13 @@ Mount options unique to the isofs filesy
   map=off       Do not map non-Rock Ridge filenames to lower case
   map=normal    Map non-Rock Ridge filenames to lower case
   map=acorn     As map=normal but also apply Acorn extensions if present
-  mode=xxx      Sets the permissions on files to xxx
-  dmode=xxx     Sets the permissions on directories to xxx
+  mode=xxx      Sets the permissions on files to xxx unless Rock Ridge
+		extensions set the permissions otherwise
+  dmode=xxx     Sets the permissions on directories to xxx unless Rock Ridge
+		extensions set the permissions otherwise
+  overriderockperm Set permissions on files and directories according to
+		'mode' and 'dmode' even though Rock Ridge extensions are
+		present.
   nojoliet      Ignore Joliet extensions if they are present.
   norock        Ignore Rock Ridge extensions if they are present.
   hide		Completely strip hidden files from the file system.
diff -puN fs/isofs/inode.c~isofs-let-mode-and-dmode-mount-options-override-rock-ridge-mode-setting fs/isofs/inode.c
--- a/fs/isofs/inode.c~isofs-let-mode-and-dmode-mount-options-override-rock-ridge-mode-setting
+++ a/fs/isofs/inode.c
@@ -143,6 +143,7 @@ struct iso9660_options{
 	char hide;
 	char showassoc;
 	char nocompress;
+	char overriderockperm;
 	unsigned char check;
 	unsigned int blocksize;
 	mode_t fmode;
@@ -307,7 +308,7 @@ enum {
 	Opt_block, Opt_check_r, Opt_check_s, Opt_cruft, Opt_gid, Opt_ignore,
 	Opt_iocharset, Opt_map_a, Opt_map_n, Opt_map_o, Opt_mode, Opt_nojoliet,
 	Opt_norock, Opt_sb, Opt_session, Opt_uid, Opt_unhide, Opt_utf8, Opt_err,
-	Opt_nocompress, Opt_hide, Opt_showassoc, Opt_dmode,
+	Opt_nocompress, Opt_hide, Opt_showassoc, Opt_dmode, Opt_overriderockperm,
 };
 
 static const match_table_t tokens = {
@@ -335,6 +336,7 @@ static const match_table_t tokens = {
 	{Opt_gid, "gid=%u"},
 	{Opt_mode, "mode=%u"},
 	{Opt_dmode, "dmode=%u"},
+	{Opt_overriderockperm, "overriderockperm"},
 	{Opt_block, "block=%u"},
 	{Opt_ignore, "conv=binary"},
 	{Opt_ignore, "conv=b"},
@@ -362,16 +364,12 @@ static int parse_options(char *options, 
 	popt->check = 'u';		/* unset */
 	popt->nocompress = 0;
 	popt->blocksize = 1024;
-	popt->fmode = popt->dmode = S_IRUGO | S_IXUGO; /*
-					 * r-x for all.  The disc could
-					 * be shared with DOS machines so
-					 * virtually anything could be
-					 * a valid executable.
-					 */
+	popt->fmode = popt->dmode = ISOFS_INVALID_MODE;
 	popt->gid = 0;
 	popt->uid = 0;
 	popt->iocharset = NULL;
 	popt->utf8 = 0;
+	popt->overriderockperm = 0;
 	popt->session=-1;
 	popt->sbsector=-1;
 	if (!options)
@@ -461,6 +459,9 @@ static int parse_options(char *options, 
 				return 0;
 			popt->dmode = option;
 			break;
+		case Opt_overriderockperm:
+			popt->overriderockperm = 1;
+			break;
 		case Opt_block:
 			if (match_int(&args[0], &option))
 				return 0;
@@ -806,13 +807,20 @@ root_found:
 	sbi->s_gid = opt.gid;
 	sbi->s_utf8 = opt.utf8;
 	sbi->s_nocompress = opt.nocompress;
+	sbi->s_overriderockperm = opt.overriderockperm;
 	/*
 	 * It would be incredibly stupid to allow people to mark every file
 	 * on the disk as suid, so we merely allow them to set the default
 	 * permissions.
 	 */
-	sbi->s_fmode = opt.fmode & 0777;
-	sbi->s_dmode = opt.dmode & 0777;
+	if (opt.fmode != ISOFS_INVALID_MODE)
+		sbi->s_fmode = opt.fmode & 0777;
+	else
+		sbi->s_fmode = ISOFS_INVALID_MODE;
+	if (opt.dmode != ISOFS_INVALID_MODE)
+		sbi->s_dmode = opt.dmode & 0777;
+	else
+		sbi->s_dmode = ISOFS_INVALID_MODE;
 
 	/*
 	 * Read the root inode, which _may_ result in changing
@@ -1256,7 +1264,10 @@ static int isofs_read_inode(struct inode
 	ei->i_file_format = isofs_file_normal;
 
 	if (de->flags[-high_sierra] & 2) {
-		inode->i_mode = sbi->s_dmode | S_IFDIR;
+		if (sbi->s_dmode != ISOFS_INVALID_MODE)
+			inode->i_mode = S_IFDIR | sbi->s_dmode;
+		else
+			inode->i_mode = S_IFDIR | S_IRUGO | S_IXUGO;
 		inode->i_nlink = 1;	/*
 					 * Set to 1.  We know there are 2, but
 					 * the find utility tries to optimize
@@ -1265,8 +1276,16 @@ static int isofs_read_inode(struct inode
 					 * do it the hard way.
 					 */
 	} else {
-		/* Everybody gets to read the file. */
-		inode->i_mode = sbi->s_fmode | S_IFREG;
+		if (sbi->s_fmode != ISOFS_INVALID_MODE) {
+			inode->i_mode = S_IFREG | sbi->s_fmode;
+		} else {
+			/*
+			 * Set default permissions: r-x for all.  The disc
+			 * could be shared with DOS machines so virtually
+			 * anything could be a valid executable.
+			 */
+			inode->i_mode = S_IFREG | S_IRUGO | S_IXUGO;
+		}
 		inode->i_nlink = 1;
 	}
 	inode->i_uid = sbi->s_uid;
@@ -1344,6 +1363,13 @@ static int isofs_read_inode(struct inode
 		test_and_set_uid(&inode->i_uid, sbi->s_uid);
 		test_and_set_gid(&inode->i_gid, sbi->s_gid);
 	}
+	/* Now set final access rights if overriding rock ridge setting */
+	if (S_ISDIR(inode->i_mode) && sbi->s_overriderockperm &&
+	    sbi->s_dmode != ISOFS_INVALID_MODE)
+		inode->i_mode = S_IFDIR | sbi->s_dmode;
+	if (S_ISREG(inode->i_mode) && sbi->s_overriderockperm &&
+	    sbi->s_fmode != ISOFS_INVALID_MODE)
+		inode->i_mode = S_IFREG | sbi->s_fmode;
 
 	/* Install the inode operations vector */
 	if (S_ISREG(inode->i_mode)) {
diff -puN fs/isofs/isofs.h~isofs-let-mode-and-dmode-mount-options-override-rock-ridge-mode-setting fs/isofs/isofs.h
--- a/fs/isofs/isofs.h~isofs-let-mode-and-dmode-mount-options-override-rock-ridge-mode-setting
+++ a/fs/isofs/isofs.h
@@ -50,6 +50,7 @@ struct isofs_sb_info {
 	unsigned char s_nocompress;
 	unsigned char s_hide;
 	unsigned char s_showassoc;
+	unsigned char s_overriderockperm;
 
 	mode_t s_fmode;
 	mode_t s_dmode;
@@ -58,6 +59,8 @@ struct isofs_sb_info {
 	struct nls_table *s_nls_iocharset; /* Native language support table */
 };
 
+#define ISOFS_INVALID_MODE ((mode_t) -1)
+
 static inline struct isofs_sb_info *ISOFS_SB(struct super_block *sb)
 {
 	return sb->s_fs_info;
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
linux-next.patch
ext2-add-blk_issue_flush-to-syncing-paths.patch
ext2-do-not-update-mtime-of-a-moved-directory.patch
ext3-fix-chain-verification-in-ext3_get_blocks.patch
isofs-let-mode-and-dmode-mount-options-override-rock-ridge-mode-setting.patch
isofs-fix-setting-of-uid-and-gid-to-0.patch
isofs-cleanup-mount-option-processing.patch
reiser4-update-names-of-quota-methods.patch

