From: akpm@linux-foundation.org
Subject: + ecryptfs-fix-possible-null-ptr-deref-in-ecryptfs_d_release.patch added to -mm tree
Date: Thu, 15 Mar 2007 11:48:15 -0800
Message-ID: <200703151848.l2FImHDb023234@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35259 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbXCOSsU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 14:48:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com


The patch titled
     eCryptfs: fix possible NULL ptr deref in ecryptfs_d_release()
has been added to the -mm tree.  Its filename is
     ecryptfs-fix-possible-null-ptr-deref-in-ecryptfs_d_release.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

ecryptfs-fix-possible-null-ptr-deref-in-ecryptfs_d_release.patch
ecryptfs-nested-locking-annotation.patch
git-unionfs.patch
