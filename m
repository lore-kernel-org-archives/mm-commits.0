From: akpm@linux-foundation.org
Subject: - knfsd-exportfs-add-find_disconnected_root-helper.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:04:17 -0700
Message-ID: <200707172304.l6HN4H3O011790@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38153 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936742AbXGQXQi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@infradead.org, hch@lst.de, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: exportfs: add find_disconnected_root helper
has been removed from the -mm tree.  Its filename was
     knfsd-exportfs-add-find_disconnected_root-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: exportfs: add find_disconnected_root helper
From: Christoph Hellwig <hch@infradead.org>

Break the loop that finds the root of a disconnected subtree into a helper of
its own to make reading easier and document the intent.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exportfs/expfs.c |   39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff -puN fs/exportfs/expfs.c~knfsd-exportfs-add-find_disconnected_root-helper fs/exportfs/expfs.c
--- a/fs/exportfs/expfs.c~knfsd-exportfs-add-find_disconnected_root-helper
+++ a/fs/exportfs/expfs.c
@@ -70,6 +70,27 @@ find_acceptable_alias(struct dentry *res
 	return NULL;
 }
 
+/*
+ * Find root of a disconnected subtree and return a reference to it.
+ */
+static struct dentry *
+find_disconnected_root(struct dentry *dentry)
+{
+	dget(dentry);
+	spin_lock(&dentry->d_lock);
+	while (!IS_ROOT(dentry) &&
+	       (dentry->d_parent->d_flags & DCACHE_DISCONNECTED)) {
+		struct dentry *parent = dentry->d_parent;
+		dget(parent);
+		spin_unlock(&dentry->d_lock);
+		dput(dentry);
+		dentry = parent;
+		spin_lock(&dentry->d_lock);
+	}
+	spin_unlock(&dentry->d_lock);
+	return dentry;
+}
+
 /**
  * find_exported_dentry - helper routine to implement export_operations->decode_fh
  * @sb:		The &super_block identifying the filesystem
@@ -164,23 +185,9 @@ find_exported_dentry(struct super_block 
 	 * the noprogress counter.  If we go through the loop 10 times (2 is
 	 * probably enough) without getting anywhere, we just give up
 	 */
-	noprogress= 0;
+	noprogress = 0;
 	while (target_dir->d_flags & DCACHE_DISCONNECTED && noprogress++ < 10) {
-		struct dentry *pd = target_dir;
-
-		dget(pd);
-		spin_lock(&pd->d_lock);
-		while (!IS_ROOT(pd) &&
-				(pd->d_parent->d_flags&DCACHE_DISCONNECTED)) {
-			struct dentry *parent = pd->d_parent;
-
-			dget(parent);
-			spin_unlock(&pd->d_lock);
-			dput(pd);
-			pd = parent;
-			spin_lock(&pd->d_lock);
-		}
-		spin_unlock(&pd->d_lock);
+		struct dentry *pd = find_disconnected_root(target_dir);
 
 		if (!IS_ROOT(pd)) {
 			/* must have found a connected parent - great */
_

Patches currently in -mm which might be from hch@infradead.org are

origin.patch
dvb_en_50221-convert-to-kthread-api.patch
git-vfs-lease-api.patch
git-xfs.patch
introduce-i_sync.patch
