From: akpm@linux-foundation.org
Subject: + ecryptfs-initialize-private-persistent-file-before-dereferencing-pointer.patch added to -mm tree
Date: Thu, 03 Dec 2009 15:01:27 -0800
Message-ID: <200912032301.nB3N1RDV012949@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751970AbZLCXCM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Dec 2009 18:02:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ezk@cs.sunysb.edu, fromdj2k@gmail.com, kirkland@canonical.com, tyhicks@linux.vnet.ibm.com


The patch titled
     ecryptfs: initialize private persistent file before dereferencing pointer
has been added to the -mm tree.  Its filename is
     ecryptfs-initialize-private-persistent-file-before-dereferencing-pointer.patch

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
Subject: ecryptfs: initialize private persistent file before dereferencing pointer
From: Erez Zadok <ezk@cs.sunysb.edu>

Ecryptfs_open dereferences a pointer to the private lower file (the one
stored in the ecryptfs inode), without checking if the pointer is NULL. 
Right afterward, it initializes that pointer if it is NULL.  Swap order of
statements to first initialize.  Bug discovered by Duckjin Kang.

Signed-off-by: Duckjin Kang <fromdj2k@gmail.com>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Cc: Dustin Kirkland <kirkland@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/file.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/ecryptfs/file.c~ecryptfs-initialize-private-persistent-file-before-dereferencing-pointer fs/ecryptfs/file.c
--- a/fs/ecryptfs/file.c~ecryptfs-initialize-private-persistent-file-before-dereferencing-pointer
+++ a/fs/ecryptfs/file.c
@@ -191,13 +191,6 @@ static int ecryptfs_open(struct inode *i
 				      | ECRYPTFS_ENCRYPTED);
 	}
 	mutex_unlock(&crypt_stat->cs_mutex);
-	if ((ecryptfs_inode_to_private(inode)->lower_file->f_flags & O_RDONLY)
-	    && !(file->f_flags & O_RDONLY)) {
-		rc = -EPERM;
-		printk(KERN_WARNING "%s: Lower persistent file is RO; eCryptfs "
-		       "file must hence be opened RO\n", __func__);
-		goto out;
-	}
 	if (!ecryptfs_inode_to_private(inode)->lower_file) {
 		rc = ecryptfs_init_persistent_file(ecryptfs_dentry);
 		if (rc) {
@@ -208,6 +201,13 @@ static int ecryptfs_open(struct inode *i
 			goto out;
 		}
 	}
+	if ((ecryptfs_inode_to_private(inode)->lower_file->f_flags & O_RDONLY)
+	    && !(file->f_flags & O_RDONLY)) {
+		rc = -EPERM;
+		printk(KERN_WARNING "%s: Lower persistent file is RO; eCryptfs "
+		       "file must hence be opened RO\n", __func__);
+		goto out;
+	}
 	ecryptfs_set_file_lower(
 		file, ecryptfs_inode_to_private(inode)->lower_file);
 	if (S_ISDIR(ecryptfs_dentry->d_inode->i_mode)) {
_

Patches currently in -mm which might be from ezk@cs.sunysb.edu are

ecryptfs-initialize-private-persistent-file-before-dereferencing-pointer.patch
fsstack-ecryptfs-remove-unused-get_nlinks-param-to-fsstack_copy_attr_all.patch

