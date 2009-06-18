From: akpm@linux-foundation.org
Subject: [merged] isofs-fix-setting-of-uid-and-gid-to-0.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:45:00 -0700
Message-ID: <200906182245.n5IMj00e004108@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46140 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758465AbZFRWpp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:45:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, Hans-Joachim.Baader@cjt.de, mm-commits@vger.kernel.org


The patch titled
     isofs: fix setting of uid and gid to 0
has been removed from the -mm tree.  Its filename was
     isofs-fix-setting-of-uid-and-gid-to-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isofs: fix setting of uid and gid to 0
From: Jan Kara <jack@suse.cz>

isofs allows setting of default uid and gid of files but value 0 was used
to indicate that user did not specify any uid/gid mount option.  Since
this option also overrides uid/gid set in Rock Ridge extension, it makes
sense to allow forcing uid/gid 0.  Fix option processing to allow this.

Cc: <Hans-Joachim.Baader@cjt.de>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/isofs/inode.c |   26 ++++++++++++--------------
 fs/isofs/isofs.h |    2 ++
 2 files changed, 14 insertions(+), 14 deletions(-)

diff -puN fs/isofs/inode.c~isofs-fix-setting-of-uid-and-gid-to-0 fs/isofs/inode.c
--- a/fs/isofs/inode.c~isofs-fix-setting-of-uid-and-gid-to-0
+++ a/fs/isofs/inode.c
@@ -153,6 +153,8 @@ struct iso9660_options{
 	unsigned int blocksize;
 	mode_t fmode;
 	mode_t dmode;
+	char uid_set;
+	char gid_set;
 	gid_t gid;
 	uid_t uid;
 	char *iocharset;
@@ -370,6 +372,8 @@ static int parse_options(char *options, 
 	popt->nocompress = 0;
 	popt->blocksize = 1024;
 	popt->fmode = popt->dmode = ISOFS_INVALID_MODE;
+	popt->uid_set = 0;
+	popt->gid_set = 0;
 	popt->gid = 0;
 	popt->uid = 0;
 	popt->iocharset = NULL;
@@ -448,11 +452,13 @@ static int parse_options(char *options, 
 			if (match_int(&args[0], &option))
 				return 0;
 			popt->uid = option;
+			popt->uid_set = 1;
 			break;
 		case Opt_gid:
 			if (match_int(&args[0], &option))
 				return 0;
 			popt->gid = option;
+			popt->gid_set = 1;
 			break;
 		case Opt_mode:
 			if (match_int(&args[0], &option))
@@ -810,6 +816,8 @@ root_found:
 	sbi->s_showassoc = opt.showassoc;
 	sbi->s_uid = opt.uid;
 	sbi->s_gid = opt.gid;
+	sbi->s_uid_set = opt.uid_set;
+	sbi->s_gid_set = opt.gid_set;
 	sbi->s_utf8 = opt.utf8;
 	sbi->s_nocompress = opt.nocompress;
 	sbi->s_overriderockperm = opt.overriderockperm;
@@ -1103,18 +1111,6 @@ static const struct address_space_operat
 	.bmap = _isofs_bmap
 };
 
-static inline void test_and_set_uid(uid_t *p, uid_t value)
-{
-	if (value)
-		*p = value;
-}
-
-static inline void test_and_set_gid(gid_t *p, gid_t value)
-{
-        if (value)
-                *p = value;
-}
-
 static int isofs_read_level3_size(struct inode *inode)
 {
 	unsigned long bufsize = ISOFS_BUFFER_SIZE(inode);
@@ -1365,8 +1361,10 @@ static int isofs_read_inode(struct inode
 	if (!high_sierra) {
 		parse_rock_ridge_inode(de, inode);
 		/* if we want uid/gid set, override the rock ridge setting */
-		test_and_set_uid(&inode->i_uid, sbi->s_uid);
-		test_and_set_gid(&inode->i_gid, sbi->s_gid);
+		if (sbi->s_uid_set)
+			inode->i_uid = sbi->s_uid;
+		if (sbi->s_gid_set)
+			inode->i_gid = sbi->s_gid;
 	}
 	/* Now set final access rights if overriding rock ridge setting */
 	if (S_ISDIR(inode->i_mode) && sbi->s_overriderockperm &&
diff -puN fs/isofs/isofs.h~isofs-fix-setting-of-uid-and-gid-to-0 fs/isofs/isofs.h
--- a/fs/isofs/isofs.h~isofs-fix-setting-of-uid-and-gid-to-0
+++ a/fs/isofs/isofs.h
@@ -51,6 +51,8 @@ struct isofs_sb_info {
 	unsigned char s_hide;
 	unsigned char s_showassoc;
 	unsigned char s_overriderockperm;
+	unsigned char s_uid_set;
+	unsigned char s_gid_set;
 
 	mode_t s_fmode;
 	mode_t s_dmode;
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
vfs-split-generic_forget_inode-so-that-hugetlbfs-does-not-have-to-copy-it.patch
reiser4-update-names-of-quota-methods.patch

