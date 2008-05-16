From: akpm@linux-foundation.org
Subject: + fuse-prepare-lookup-for-nfs-export.patch added to -mm tree
Date: Thu, 15 May 2008 17:16:11 -0700
Message-ID: <200805160016.m4G0GBv3017767@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43478 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752685AbYEPAQY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 20:16:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, hch@lst.de


The patch titled
     fuse: prepare lookup for nfs export
has been added to the -mm tree.  Its filename is
     fuse-prepare-lookup-for-nfs-export.patch

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
Subject: fuse: prepare lookup for nfs export
From: Miklos Szeredi <mszeredi@suse.cz>

Use d_splice_alias() instead of d_add() in fuse lookup code, to allow NFS
exporting.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dir.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff -puN fs/fuse/dir.c~fuse-prepare-lookup-for-nfs-export fs/fuse/dir.c
--- a/fs/fuse/dir.c~fuse-prepare-lookup-for-nfs-export
+++ a/fs/fuse/dir.c
@@ -239,18 +239,20 @@ int fuse_valid_type(int m)
  * Add a directory inode to a dentry, ensuring that no other dentry
  * refers to this inode.  Called with fc->inst_mutex.
  */
-static int fuse_d_add_directory(struct dentry *entry, struct inode *inode)
+static struct dentry *fuse_d_add_directory(struct dentry *entry,
+					   struct inode *inode)
 {
 	struct dentry *alias = d_find_alias(inode);
-	if (alias) {
+	if (alias && !(alias->d_flags & DCACHE_DISCONNECTED)) {
 		/* This tries to shrink the subtree below alias */
 		fuse_invalidate_entry(alias);
 		dput(alias);
 		if (!list_empty(&inode->i_dentry))
-			return -EBUSY;
+			return ERR_PTR(-EBUSY);
+	} else {
+		dput(alias);
 	}
-	d_add(entry, inode);
-	return 0;
+	return d_splice_alias(inode, entry);
 }
 
 static struct dentry *fuse_lookup(struct inode *dir, struct dentry *entry,
@@ -259,6 +261,7 @@ static struct dentry *fuse_lookup(struct
 	int err;
 	struct fuse_entry_out outarg;
 	struct inode *inode = NULL;
+	struct dentry *newent;
 	struct fuse_conn *fc = get_fuse_conn(dir);
 	struct fuse_req *req;
 	struct fuse_req *forget_req;
@@ -303,21 +306,22 @@ static struct dentry *fuse_lookup(struct
 
 	if (inode && S_ISDIR(inode->i_mode)) {
 		mutex_lock(&fc->inst_mutex);
-		err = fuse_d_add_directory(entry, inode);
+		newent = fuse_d_add_directory(entry, inode);
 		mutex_unlock(&fc->inst_mutex);
-		if (err) {
+		if (IS_ERR(newent)) {
 			iput(inode);
-			return ERR_PTR(err);
+			return newent;
 		}
 	} else
-		d_add(entry, inode);
+		newent = d_splice_alias(inode, entry);
 
+	entry = newent ? newent : entry;
 	entry->d_op = &fuse_dentry_operations;
 	if (!err)
 		fuse_change_entry_timeout(entry, &outarg);
 	else
 		fuse_invalidate_entry_cache(entry);
-	return NULL;
+	return newent;
 }
 
 /*
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
mm-fix-infinite-loop-in-filemap_fault.patch
git-vfs-cleanups.patch
lockd-dont-return-eagain-for-a-permanent-error.patch
locks-add-special-return-value-for-asynchronous-locks.patch
locks-cleanup-code-duplication.patch
locks-allow-lock-to-return-file_lock_deferred.patch
fuse-prepare-lookup-for-nfs-export.patch
fuse-add-export-operations.patch
fuse-add-fuse_lookup_name-helper.patch
fuse-nfs-export-special-lookups.patch
fuse-lockd-support.patch

