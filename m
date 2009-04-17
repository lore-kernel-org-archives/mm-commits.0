From: akpm@linux-foundation.org
Subject: + isofs-cleanup-mount-option-processing.patch added to -mm tree
Date: Thu, 16 Apr 2009 17:03:50 -0700
Message-ID: <200904170003.n3H03oKp006164@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757325AbZDQAFc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Apr 2009 20:05:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz


The patch titled
     isofs: cleanup mount option processing
has been added to the -mm tree.  Its filename is
     isofs-cleanup-mount-option-processing.patch

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
Subject: isofs: cleanup mount option processing
From: Jan Kara <jack@suse.cz>

Remove unused variables from isofs_sb_info (used to be some mount
options), unify variables for option to use 0/1 (some options used
'y'/'n'), use bit fields for option flags in superblock.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/isofs/dir.c   |    5 +---
 fs/isofs/inode.c |   48 ++++++++++++++++++++++-----------------------
 fs/isofs/isofs.h |   28 +++++++++++---------------
 fs/isofs/namei.c |    4 +--
 4 files changed, 40 insertions(+), 45 deletions(-)

diff -puN fs/isofs/dir.c~isofs-cleanup-mount-option-processing fs/isofs/dir.c
--- a/fs/isofs/dir.c~isofs-cleanup-mount-option-processing
+++ a/fs/isofs/dir.c
@@ -195,9 +195,8 @@ static int do_isofs_readdir(struct inode
 		 * Do not report hidden files if so instructed, or associated
 		 * files unless instructed to do so
 		 */
-		if ((sbi->s_hide == 'y' &&
-				(de->flags[-sbi->s_high_sierra] & 1)) ||
-				(sbi->s_showassoc =='n' &&
+		if ((sbi->s_hide && (de->flags[-sbi->s_high_sierra] & 1)) ||
+		    (!sbi->s_showassoc &&
 				(de->flags[-sbi->s_high_sierra] & 4))) {
 			filp->f_pos += de_len;
 			continue;
diff -puN fs/isofs/inode.c~isofs-cleanup-mount-option-processing fs/isofs/inode.c
--- a/fs/isofs/inode.c~isofs-cleanup-mount-option-processing
+++ a/fs/isofs/inode.c
@@ -136,24 +136,24 @@ static const struct dentry_operations is
 };
 
 struct iso9660_options{
-	char map;
-	char rock;
+	unsigned int rock:1;
+	unsigned int cruft:1;
+	unsigned int hide:1;
+	unsigned int showassoc:1;
+	unsigned int nocompress:1;
+	unsigned int overriderockperm:1;
+	unsigned int uid_set:1;
+	unsigned int gid_set:1;
+	unsigned int utf8:1;
+	unsigned char map;
 	char joliet;
-	char cruft;
-	char hide;
-	char showassoc;
-	char nocompress;
-	char overriderockperm;
 	unsigned char check;
 	unsigned int blocksize;
 	mode_t fmode;
 	mode_t dmode;
-	char uid_set;
-	char gid_set;
 	gid_t gid;
 	uid_t uid;
 	char *iocharset;
-	unsigned char utf8;
 	/* LVE */
 	s32 session;
 	s32 sbsector;
@@ -358,11 +358,11 @@ static int parse_options(char *options, 
 	int option;
 
 	popt->map = 'n';
-	popt->rock = 'y';
-	popt->joliet = 'y';
-	popt->cruft = 'n';
-	popt->hide = 'n';
-	popt->showassoc = 'n';
+	popt->rock = 1;
+	popt->joliet = 1;
+	popt->cruft = 0;
+	popt->hide = 0;
+	popt->showassoc = 0;
 	popt->check = 'u';		/* unset */
 	popt->nocompress = 0;
 	popt->blocksize = 1024;
@@ -390,20 +390,20 @@ static int parse_options(char *options, 
 		token = match_token(p, tokens, args);
 		switch (token) {
 		case Opt_norock:
-			popt->rock = 'n';
+			popt->rock = 0;
 			break;
 		case Opt_nojoliet:
-			popt->joliet = 'n';
+			popt->joliet = 0;
 			break;
 		case Opt_hide:
-			popt->hide = 'y';
+			popt->hide = 1;
 			break;
 		case Opt_unhide:
 		case Opt_showassoc:
-			popt->showassoc = 'y';
+			popt->showassoc = 1;
 			break;
 		case Opt_cruft:
-			popt->cruft = 'y';
+			popt->cruft = 1;
 			break;
 		case Opt_utf8:
 			popt->utf8 = 1;
@@ -652,7 +652,7 @@ static int isofs_fill_super(struct super
 					goto out_freebh;
 
 				sbi->s_high_sierra = 1;
-				opt.rock = 'n';
+				opt.rock = 0;
 				h_pri = (struct hs_primary_descriptor *)vdp;
 				goto root_found;
 			}
@@ -675,7 +675,7 @@ static int isofs_fill_super(struct super
 
 root_found:
 
-	if (joliet_level && (pri == NULL || opt.rock == 'n')) {
+	if (joliet_level && (pri == NULL || !opt.rock)) {
 		/* This is the case of Joliet with the norock mount flag.
 		 * A disc with both Joliet and Rock Ridge is handled later
 		 */
@@ -804,7 +804,7 @@ root_found:
 	s->s_op = &isofs_sops;
 	s->s_export_op = &isofs_export_ops;
 	sbi->s_mapping = opt.map;
-	sbi->s_rock = (opt.rock == 'y' ? 2 : 0);
+	sbi->s_rock = (opt.rock ? 2 : 0);
 	sbi->s_rock_offset = -1; /* initial offset, will guess until SP is found*/
 	sbi->s_cruft = opt.cruft;
 	sbi->s_hide = opt.hide;
@@ -1310,7 +1310,7 @@ static int isofs_read_inode(struct inode
 	 * this CDROM was mounted with the cruft option.
 	 */
 
-	if (sbi->s_cruft == 'y')
+	if (sbi->s_cruft)
 		inode->i_size &= 0x00ffffff;
 
 	if (de->interleave[0]) {
diff -puN fs/isofs/isofs.h~isofs-cleanup-mount-option-processing fs/isofs/isofs.h
--- a/fs/isofs/isofs.h~isofs-cleanup-mount-option-processing
+++ a/fs/isofs/isofs.h
@@ -35,24 +35,20 @@ struct isofs_sb_info {
 	unsigned long s_log_zone_size;
 	unsigned long s_max_size;
 	
-	unsigned char s_high_sierra; /* A simple flag */
-	unsigned char s_mapping;
 	int           s_rock_offset; /* offset of SUSP fields within SU area */
-	unsigned char s_rock;
 	unsigned char s_joliet_level;
-	unsigned char s_utf8;
-	unsigned char s_cruft; /* Broken disks with high
-				  byte of length containing
-				  junk */
-	unsigned char s_unhide;
-	unsigned char s_nosuid;
-	unsigned char s_nodev;
-	unsigned char s_nocompress;
-	unsigned char s_hide;
-	unsigned char s_showassoc;
-	unsigned char s_overriderockperm;
-	unsigned char s_uid_set;
-	unsigned char s_gid_set;
+	unsigned char s_mapping;
+	unsigned int  s_high_sierra:1;
+	unsigned int  s_rock:2;
+	unsigned int  s_utf8:1;
+	unsigned int  s_cruft:1; /* Broken disks with high byte of length
+				  * containing junk */
+	unsigned int  s_nocompress:1;
+	unsigned int  s_hide:1;
+	unsigned int  s_showassoc:1;
+	unsigned int  s_overriderockperm:1;
+	unsigned int  s_uid_set:1;
+	unsigned int  s_gid_set:1;
 
 	mode_t s_fmode;
 	mode_t s_dmode;
diff -puN fs/isofs/namei.c~isofs-cleanup-mount-option-processing fs/isofs/namei.c
--- a/fs/isofs/namei.c~isofs-cleanup-mount-option-processing
+++ a/fs/isofs/namei.c
@@ -142,9 +142,9 @@ isofs_find_entry(struct inode *dir, stru
 		 */
 		match = 0;
 		if (dlen > 0 &&
-			(sbi->s_hide =='n' ||
+			(!sbi->s_hide ||
 				(!(de->flags[-sbi->s_high_sierra] & 1))) &&
-			(sbi->s_showassoc =='y' ||
+			(sbi->s_showassoc ||
 				(!(de->flags[-sbi->s_high_sierra] & 4)))) {
 			match = (isofs_cmp(dentry, dpnt, dlen) == 0);
 		}
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

