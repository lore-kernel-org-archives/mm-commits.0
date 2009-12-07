From: akpm@linux-foundation.org
Subject: + ecryptfs-dont-ignore-return-value-from-lock_rename.patch added to -mm tree
Date: Mon, 07 Dec 2009 13:34:16 -0800
Message-ID: <200912072134.nB7LYGsT006172@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59820 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965006AbZLGVjN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Dec 2009 16:39:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ezk@cs.sunysb.edu, kirkland@canonical.com, tyhicks@linux.vnet.ibm.com


The patch titled
     ecryptfs: don't ignore return value from lock_rename()
has been added to the -mm tree.  Its filename is
     ecryptfs-dont-ignore-return-value-from-lock_rename.patch

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
Subject: ecryptfs: don't ignore return value from lock_rename()
From: Erez Zadok <ezk@cs.sunysb.edu>

Use return value from lock_rename() in ecryptfs_rename, and properly check
that return value.  I've tested it briefly with ecryptfs: moved some
files/directories at both the same level, as well as into subdirectories
which may share a common ancestor.  Things seem to work, but perhaps more
testing is needed.

Identical code to this has been running in Unionfs for a couple of years,
so I'm reasonably confident that this patch is correct.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Cc: Dustin Kirkland <kirkland@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/inode.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN fs/ecryptfs/inode.c~ecryptfs-dont-ignore-return-value-from-lock_rename fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~ecryptfs-dont-ignore-return-value-from-lock_rename
+++ a/fs/ecryptfs/inode.c
@@ -614,6 +614,7 @@ ecryptfs_rename(struct inode *old_dir, s
 	struct dentry *lower_new_dentry;
 	struct dentry *lower_old_dir_dentry;
 	struct dentry *lower_new_dir_dentry;
+	struct dentry *trap = NULL;
 
 	lower_old_dentry = ecryptfs_dentry_to_lower(old_dentry);
 	lower_new_dentry = ecryptfs_dentry_to_lower(new_dentry);
@@ -621,7 +622,17 @@ ecryptfs_rename(struct inode *old_dir, s
 	dget(lower_new_dentry);
 	lower_old_dir_dentry = dget_parent(lower_old_dentry);
 	lower_new_dir_dentry = dget_parent(lower_new_dentry);
-	lock_rename(lower_old_dir_dentry, lower_new_dir_dentry);
+	trap = lock_rename(lower_old_dir_dentry, lower_new_dir_dentry);
+	/* source should not be ancestor of target */
+	if (trap == lower_old_dentry) {
+		rc = -EINVAL;
+		goto out_lock;
+	}
+	/* target should not be ancestor of source */
+	if (trap == lower_new_dentry) {
+		rc = -ENOTEMPTY;
+		goto out_lock;
+	}
 	rc = vfs_rename(lower_old_dir_dentry->d_inode, lower_old_dentry,
 			lower_new_dir_dentry->d_inode, lower_new_dentry);
 	if (rc)
_

Patches currently in -mm which might be from ezk@cs.sunysb.edu are

linux-next.patch
ecryptfs-dont-ignore-return-value-from-lock_rename.patch
fsstack-ecryptfs-remove-unused-get_nlinks-param-to-fsstack_copy_attr_all.patch
vfs-fsstack-handle-32-bit-smp-preempt-large-files-in-fsstack_copy_inode_size.patch

