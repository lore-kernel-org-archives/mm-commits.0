From: akpm@linux-foundation.org
Subject: [merged] vfs-optimization-for-touch_atime.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:38:07 -0700
Message-ID: <200909241938.n8OJc7L2005985@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51848 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754525AbZIXTid (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:38:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, ak@linux.intel.com, haveblue@us.ibm.com, hch@infradead.org, vaurora@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: optimization for touch_atime()
has been removed from the -mm tree.  Its filename was
     vfs-optimization-for-touch_atime.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: optimization for touch_atime()
From: Andi Kleen <andi@firstfloor.org>

Some benchmark testing shows touch_atime to be high up in profile logs for
IO intensive workloads.  Most likely that's due to the lock in
mnt_want_write().  Unfortunately touch_atime first takes the lock, and
then does all the other tests that could avoid atime updates (like noatime
or relatime).

Do it the other way round -- first try to avoid the update and only then
if that didn't succeed take the lock.  That works because none of the
atime avoidance tests rely on locking.

This also eliminates a goto.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Valerie Aurora <vaurora@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN fs/inode.c~vfs-optimization-for-touch_atime fs/inode.c
--- a/fs/inode.c~vfs-optimization-for-touch_atime
+++ a/fs/inode.c
@@ -1411,31 +1411,31 @@ void touch_atime(struct vfsmount *mnt, s
 	struct inode *inode = dentry->d_inode;
 	struct timespec now;
 
-	if (mnt_want_write(mnt))
-		return;
 	if (inode->i_flags & S_NOATIME)
-		goto out;
+		return;
 	if (IS_NOATIME(inode))
-		goto out;
+		return;
 	if ((inode->i_sb->s_flags & MS_NODIRATIME) && S_ISDIR(inode->i_mode))
-		goto out;
+		return;
 
 	if (mnt->mnt_flags & MNT_NOATIME)
-		goto out;
+		return;
 	if ((mnt->mnt_flags & MNT_NODIRATIME) && S_ISDIR(inode->i_mode))
-		goto out;
+		return;
 
 	now = current_fs_time(inode->i_sb);
 
 	if (!relatime_need_update(mnt, inode, now))
-		goto out;
+		return;
 
 	if (timespec_equal(&inode->i_atime, &now))
-		goto out;
+		return;
+
+	if (mnt_want_write(mnt))
+		return;
 
 	inode->i_atime = now;
 	mark_inode_dirty_sync(inode);
-out:
 	mnt_drop_write(mnt);
 }
 EXPORT_SYMBOL(touch_atime);
_

Patches currently in -mm which might be from andi@firstfloor.org are

origin.patch
fatfs-use-common-time_to_tm-in-fat_time_unix2fat.patch

