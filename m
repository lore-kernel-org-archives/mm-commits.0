From: akpm@linux-foundation.org
Subject: + configfs-consolidate-locking-around-configfs_detach_prep-in-configfs_rmdir.patch added to -mm tree
Date: Thu, 14 Aug 2008 01:58:10 -0700
Message-ID: <200808140858.m7E8wAGQ000341@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58724 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751780AbYHNI6a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Aug 2008 04:58:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: louis.rilling@kerlabs.com, Joel.Becker@oracle.com


The patch titled
     configfs: consolidate locking around configfs_detach_prep() in configfs_rmdir()
has been added to the -mm tree.  Its filename is
     configfs-consolidate-locking-around-configfs_detach_prep-in-configfs_rmdir.patch

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
Subject: configfs: consolidate locking around configfs_detach_prep() in configfs_rmdir()
From: Louis Rilling <louis.rilling@kerlabs.com>

It appears that configfs_rmdir() can protect configfs_detach_prep()
retries with less calls to {spin,mutex}_{lock,unlock}, and cleaner code.

This patch does not change any behavior, except that it removes two
useless lock/unlock pairs having nothing inside to protect and providing a
useless barrier.

Signed-off-by: Louis Rilling <louis.rilling@kerlabs.com>
Cc: Joel Becker <Joel.Becker@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/configfs/dir.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff -puN fs/configfs/dir.c~configfs-consolidate-locking-around-configfs_detach_prep-in-configfs_rmdir fs/configfs/dir.c
--- a/fs/configfs/dir.c~configfs-consolidate-locking-around-configfs_detach_prep-in-configfs_rmdir
+++ a/fs/configfs/dir.c
@@ -1311,16 +1311,18 @@ static int configfs_rmdir(struct inode *
 	 * Ensure that no racing symlink() will make detach_prep() fail while
 	 * the new link is temporarily attached
 	 */
-	mutex_lock(&configfs_symlink_mutex);
-	spin_lock(&configfs_dirent_lock);
 	do {
 		struct mutex *wait_mutex;
 
+		mutex_lock(&configfs_symlink_mutex);
+		spin_lock(&configfs_dirent_lock);
 		ret = configfs_detach_prep(dentry, &wait_mutex);
-		if (ret) {
+		if (ret)
 			configfs_detach_rollback(dentry);
-			spin_unlock(&configfs_dirent_lock);
-			mutex_unlock(&configfs_symlink_mutex);
+		spin_unlock(&configfs_dirent_lock);
+		mutex_unlock(&configfs_symlink_mutex);
+
+		if (ret) {
 			if (ret != -EAGAIN) {
 				config_item_put(parent_item);
 				return ret;
@@ -1329,13 +1331,8 @@ static int configfs_rmdir(struct inode *
 			/* Wait until the racing operation terminates */
 			mutex_lock(wait_mutex);
 			mutex_unlock(wait_mutex);
