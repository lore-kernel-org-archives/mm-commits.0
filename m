From: akpm@linux-foundation.org
Subject: + vfs-clean-up-real_lookup.patch added to -mm tree
Date: Wed, 30 Sep 2009 13:40:39 -0700
Message-ID: <200909302040.n8UKeeja013159@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51220 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752989AbZI3UlW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Sep 2009 16:41:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sage@newdream.net, adilger@sun.com, hch@infradead.org, raven@themaw.net, viro@zeniv.linux.org.uk, yehuda@newdream.net


The patch titled
     vfs: clean up real_lookup()
has been added to the -mm tree.  Its filename is
     vfs-clean-up-real_lookup.patch

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
Subject: vfs: clean up real_lookup()
From: Sage Weil <sage@newdream.net>

Get rid of the goto by flipping the if (!result) over.  Make the comments
a bit more descriptive.  Fix a few kernel style problems.  No functional
changes.

Cc: Ian Kent <raven@themaw.net>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Dilger <adilger@sun.com>
Signed-off-by: Yehuda Sadeh <yehuda@newdream.net>
Signed-off-by: Sage Weil <sage@newdream.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |   65 ++++++++++++++++++++++++++-------------------------
 1 file changed, 34 insertions(+), 31 deletions(-)

diff -puN fs/namei.c~vfs-clean-up-real_lookup fs/namei.c
--- a/fs/namei.c~vfs-clean-up-real_lookup
+++ a/fs/namei.c
@@ -469,19 +469,20 @@ ok:
  * This is called when everything else fails, and we actually have
  * to go to the low-level filesystem to find out what we should do..
  *
- * We get the directory semaphore, and after getting that we also
+ * We get the directory mutex, and after getting that we also
  * make sure that nobody added the entry to the dcache in the meantime..
  * SMP-safe
  */
-static struct dentry * real_lookup(struct dentry * parent, struct qstr * name, struct nameidata *nd)
+static struct dentry *real_lookup(struct dentry *parent, struct qstr *name,
+				  struct nameidata *nd)
 {
-	struct dentry * result;
+	struct dentry *result, *dentry;
 	struct inode *dir = parent->d_inode;
 
 	mutex_lock(&dir->i_mutex);
 	/*
 	 * First re-do the cached lookup just in case it was created
-	 * while we waited for the directory semaphore..
+	 * while we waited for the directory mutex.
 	 *
 	 * FIXME! This could use version numbering or similar to
 	 * avoid unnecessary cache lookups.
@@ -494,38 +495,40 @@ static struct dentry * real_lookup(struc
 	 * so doing d_lookup() (with seqlock), instead of lockfree __d_lookup
 	 */
 	result = d_lookup(parent, name);
-	if (!result) {
-		struct dentry *dentry;
-
-do_the_lookup:
-		/* Don't create child dentry for a dead directory. */
-		result = ERR_PTR(-ENOENT);
-		if (IS_DEADDIR(dir))
-			goto out_unlock;
-
-		dentry = d_alloc(parent, name);
-		result = ERR_PTR(-ENOMEM);
-		if (dentry) {
-			result = dir->i_op->lookup(dir, dentry, nd);
+	if (result) {
+		/*
+		 * The cache was re-populated while we waited on the
+		 * mutex.  We need to revalidate, this time while
+		 * holding i_mutex (to avoid another race).
+		 */
+		if (result->d_op && result->d_op->d_revalidate) {
+			result = do_revalidate(result, nd);
 			if (result)
-				dput(dentry);
-			else
-				result = dentry;
+				goto out_unlock;
+			/*
+			 * The dentry was left behind invalid.  Just
+			 * do the lookup.
+			 */
+		} else {
+			goto out_unlock;
 		}
-out_unlock:
-		mutex_unlock(&dir->i_mutex);
-		return result;
 	}
 
-	/*
-	 * Uhhuh! Nasty case: the cache was re-populated while
-	 * we waited on the semaphore. Need to revalidate.
-	 */
-	if (result->d_op && result->d_op->d_revalidate) {
-		result = do_revalidate(result, nd);
-		if (!result)
-			goto do_the_lookup;
+	/* Don't create child dentry for a dead directory. */
+	result = ERR_PTR(-ENOENT);
+	if (IS_DEADDIR(dir))
+		goto out_unlock;
+
+	dentry = d_alloc(parent, name);
+	result = ERR_PTR(-ENOMEM);
+	if (dentry) {
+		result = dir->i_op->lookup(dir, dentry, nd);
+		if (result)
+			dput(dentry);
+		else
+			result = dentry;
 	}
+out_unlock:
 	mutex_unlock(&dir->i_mutex);
 	return result;
 }
_

Patches currently in -mm which might be from sage@newdream.net are

vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
vfs-make-real_lookup-do-dentry-revalidation-with-i_mutex-held.patch
vfs-clean-up-real_lookup.patch

