From: akpm@linux-foundation.org
Subject: - knfsd-exportfs-untangle-isdir-logic-in-find_exported_dentry.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:04:13 -0700
Message-ID: <200707172304.l6HN4DGa011784@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51777 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936738AbXGQXQe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@infradead.org, hch@lst.de, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: exportfs: untangle ISDIR logic in find_exported_dentry
has been removed from the -mm tree.  Its filename was
     knfsd-exportfs-untangle-isdir-logic-in-find_exported_dentry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: exportfs: untangle ISDIR logic in find_exported_dentry
From: Christoph Hellwig <hch@infradead.org>

Rework some logic in find_exported_dentry so that we only have a single
S_ISDIR check and logic that makes clear to the reader what we're really doing
here.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exportfs/expfs.c |   26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff -puN fs/exportfs/expfs.c~knfsd-exportfs-untangle-isdir-logic-in-find_exported_dentry fs/exportfs/expfs.c
--- a/fs/exportfs/expfs.c~knfsd-exportfs-untangle-isdir-logic-in-find_exported_dentry
+++ a/fs/exportfs/expfs.c
@@ -116,30 +116,23 @@ find_exported_dentry(struct super_block 
 	if (IS_ERR(result))
 		return result;
 
-	if (S_ISDIR(result->d_inode->i_mode) &&
-	    (result->d_flags & DCACHE_DISCONNECTED)) {
-		/* it is an unconnected directory, we must connect it */
-		;
-	} else {
-		if (acceptable(context, result))
-			return result;
-		if (S_ISDIR(result->d_inode->i_mode)) {
+	if (S_ISDIR(result->d_inode->i_mode)) {
+		if (!(result->d_flags & DCACHE_DISCONNECTED)) {
+			if (acceptable(context, result))
+				return result;
 			err = -EACCES;
 			goto err_result;
 		}
 
+		target_dir = dget(result);
+	} else {
+		if (acceptable(context, result))
+			return result;
+
 		alias = find_acceptable_alias(result, acceptable, context);
 		if (alias)
 			return alias;
-	}			
 
-	/* It's a directory, or we are required to confirm the file's
-	 * location in the tree based on the parent information
- 	 */
-	dprintk("find_exported_dentry: need to look harder for %s/%d\n",sb->s_id,*(int*)obj);
-	if (S_ISDIR(result->d_inode->i_mode))
-		target_dir = dget(result);
-	else {
 		if (parent == NULL)
 			goto err_result;
 
@@ -149,6 +142,7 @@ find_exported_dentry(struct super_block 
 			goto err_result;
 		}
 	}
+
 	/*
 	 * Now we need to make sure that target_dir is properly connected.
 	 * It may already be, as the flag isn't always updated when connection
_

Patches currently in -mm which might be from hch@infradead.org are

origin.patch
dvb_en_50221-convert-to-kthread-api.patch
git-vfs-lease-api.patch
git-xfs.patch
introduce-i_sync.patch
