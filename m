From: akpm@linux-foundation.org
Subject: - ecryptfs-swap-dput-and-mntput.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:29:43 -0700
Message-ID: <200803212029.m2LKThMk008895@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37005 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759010AbYCUUaT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:30:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, rajouri.jammu@gmail.com, sandeen@redhat.com, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: Swap dput() and mntput()
has been removed from the -mm tree.  Its filename was
     ecryptfs-swap-dput-and-mntput.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eCryptfs: Swap dput() and mntput()
From: Michael Halcrow <mhalcrow@us.ibm.com>

ecryptfs_d_release() is doing a mntput before doing the dput.  This patch
moves the dput before the mntput.

Thanks to Rajouri Jammu for reporting this.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Rajouri Jammu <rajouri.jammu@gmail.com>
Cc: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/dentry.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ecryptfs/dentry.c~ecryptfs-swap-dput-and-mntput fs/ecryptfs/dentry.c
--- a/fs/ecryptfs/dentry.c~ecryptfs-swap-dput-and-mntput
+++ a/fs/ecryptfs/dentry.c
@@ -80,8 +80,8 @@ static void ecryptfs_d_release(struct de
 {
 	if (ecryptfs_dentry_to_private(dentry)) {
 		if (ecryptfs_dentry_to_lower(dentry)) {
-			mntput(ecryptfs_dentry_to_lower_mnt(dentry));
 			dput(ecryptfs_dentry_to_lower(dentry));
+			mntput(ecryptfs_dentry_to_lower_mnt(dentry));
 		}
 		kmem_cache_free(ecryptfs_dentry_info_cache,
 				ecryptfs_dentry_to_private(dentry));
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
git-unionfs.patch
remove-ecryptfs_header_cache_0.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
remove-duplicated-unlikely-in-is_err.patch

