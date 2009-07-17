From: akpm@linux-foundation.org
Subject: + v3-minixfs-add-missing-directory-type-checking.patch added to -mm tree
Date: Fri, 17 Jul 2009 15:58:09 -0700
Message-ID: <200907172258.n6HMw978023869@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43653 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757957AbZGQW6O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Jul 2009 18:58:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dgraham@nortel.com


The patch titled
     V3 minixfs: add missing directory type checking
has been added to the -mm tree.  Its filename is
     v3-minixfs-add-missing-directory-type-checking.patch

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
Subject: V3 minixfs: add missing directory type checking
From: "Doug Graham" <dgraham@nortel.com>

There are a few places in the Minix FS code where the "inode" field of a
minix_dir_entry is used without checking first to see if the dirent is
really a minix3_dir_entry.  The inode number in a V1/V2 dirent is 16 bits,
whereas that in a V3 dirent is 32 bits.

Accessing it as a 16 bit field when it really should be accessed as a 32
bit field probably kinda sorta works on a little-endian machine, but leads
to some rather odd behaviour on big-endian machines.

Signed-off-by: Doug Graham <dgraham@nortel.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/minix/dir.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff -puN fs/minix/dir.c~v3-minixfs-add-missing-directory-type-checking fs/minix/dir.c
--- a/fs/minix/dir.c~v3-minixfs-add-missing-directory-type-checking
+++ a/fs/minix/dir.c
@@ -308,14 +308,18 @@ int minix_delete_entry(struct minix_dir_
 	struct inode *inode = (struct inode*)mapping->host;
 	char *kaddr = page_address(page);
 	loff_t pos = page_offset(page) + (char*)de - kaddr;
-	unsigned len = minix_sb(inode->i_sb)->s_dirsize;
+	struct minix_sb_info *sbi = minix_sb(inode->i_sb);
+	unsigned len = sbi->s_dirsize;
 	int err;
 
 	lock_page(page);
 	err = __minix_write_begin(NULL, mapping, pos, len,
 					AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
 	if (err == 0) {
-		de->inode = 0;
+		if (sbi->s_version == MINIX_V3)
+			((minix3_dirent *) de)->inode = 0;
+		else
+			de->inode = 0;
 		err = dir_commit_chunk(page, pos, len);
 	} else {
 		unlock_page(page);
@@ -440,7 +444,10 @@ void minix_set_link(struct minix_dir_ent
 	err = __minix_write_begin(NULL, mapping, pos, sbi->s_dirsize,
 					AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
 	if (err == 0) {
-		de->inode = inode->i_ino;
+		if (sbi->s_version == MINIX_V3)
+			((minix3_dirent *) de)->inode = inode->i_ino;
+		else
+			de->inode = inode->i_ino;
 		err = dir_commit_chunk(page, pos, sbi->s_dirsize);
 	} else {
 		unlock_page(page);
@@ -470,7 +477,14 @@ ino_t minix_inode_by_name(struct dentry 
 	ino_t res = 0;
 
 	if (de) {
-		res = de->inode;
+		struct address_space *mapping = page->mapping;
+		struct inode *inode = (struct inode*)mapping->host;
+		struct minix_sb_info *sbi = minix_sb(inode->i_sb);
+
+		if (sbi->s_version == MINIX_V3)
+			res = ((minix3_dirent *) de)->inode;
+		else
+			res = de->inode;
 		dir_put_page(page);
 	}
 	return res;
_

Patches currently in -mm which might be from dgraham@nortel.com are

v3-minixfs-add-missing-directory-type-checking.patch

