From: akpm@linux-foundation.org
Subject: - ecryptfs-fix-possible-null-ptr-deref-in-ecryptfs_d_release.patch removed from -mm tree
Date: Sun, 18 Mar 2007 01:09:38 -0800
Message-ID: <200703180909.l2I99cMo020023@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60436 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbXCRJJp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 05:09:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: fix possible NULL ptr deref in ecryptfs_d_release()
has been removed from the -mm tree.  Its filename was
     ecryptfs-fix-possible-null-ptr-deref-in-ecryptfs_d_release.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: eCryptfs: fix possible NULL ptr deref in ecryptfs_d_release()
From: Michael Halcrow <mhalcrow@us.ibm.com>

ecryptfs_d_release() first dereferences a pointer (via
ecryptfs_dentry_to_lower()) and then afterwards checks to see if the
pointer it just dereferenced is NULL (via ecryptfs_dentry_to_private()). 
This patch moves all of the work done on the dereferenced pointer inside a
block governed by the condition that the pointer is non-NULL.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/dentry.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff -puN fs/ecryptfs/dentry.c~ecryptfs-fix-possible-null-ptr-deref-in-ecryptfs_d_release fs/ecryptfs/dentry.c
--- a/fs/ecryptfs/dentry.c~ecryptfs-fix-possible-null-ptr-deref-in-ecryptfs_d_release
+++ a/fs/ecryptfs/dentry.c
@@ -78,18 +78,13 @@ struct kmem_cache *ecryptfs_dentry_info_
  */
 static void ecryptfs_d_release(struct dentry *dentry)
 {
-	struct dentry *lower_dentry;
-
-	lower_dentry = ecryptfs_dentry_to_lower(dentry);
-	if (ecryptfs_dentry_to_private(dentry))
+	if (ecryptfs_dentry_to_private(dentry)) {
+		if (ecryptfs_dentry_to_lower(dentry)) {
+			mntput(ecryptfs_dentry_to_lower_mnt(dentry));
+			dput(ecryptfs_dentry_to_lower(dentry));
+		}
 		kmem_cache_free(ecryptfs_dentry_info_cache,
 				ecryptfs_dentry_to_private(dentry));
-	if (lower_dentry) {
-		struct vfsmount *lower_mnt =
-			ecryptfs_dentry_to_lower_mnt(dentry);
-
-		mntput(lower_mnt);
-		dput(lower_dentry);
 	}
 	return;
 }
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
git-unionfs.patch
