From: akpm@linux-foundation.org
Subject: [merged] vfs-optimize-touch_time-too.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:38:10 -0700
Message-ID: <200909241938.n8OJcAnr006102@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40202 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754532AbZIXTiv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:38:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, ak@linux.intel.com, haveblue@us.ibm.com, hch@infradead.org, hugh.dickins@tiscali.co.uk, vaurora@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: optimize touch_time() too
has been removed from the -mm tree.  Its filename was
     vfs-optimize-touch_time-too.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: optimize touch_time() too
From: Andi Kleen <andi@firstfloor.org>

Do a similar optimization as earlier for touch_atime.  Getting the lock in
mnt_get_write is relatively costly, so try all avenues to avoid it first.

This patch is careful to still only update inode fields inside the lock
region.

This didn't show up in benchmarks, but it's easy enough to do.

[akpm@linux-foundation.org: fix typo in comment]
[hugh.dickins@tiscali.co.uk: fix inverted test of mnt_want_write_file()]
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Valerie Aurora <vaurora@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |   43 +++++++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 20 deletions(-)

diff -puN fs/inode.c~vfs-optimize-touch_time-too fs/inode.c
--- a/fs/inode.c~vfs-optimize-touch_time-too
+++ a/fs/inode.c
@@ -1456,34 +1456,37 @@ void file_update_time(struct file *file)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct timespec now;
-	int sync_it = 0;
-	int err;
+	enum { S_MTIME = 1, S_CTIME = 2, S_VERSION = 4 } sync_it = 0;
 
+	/* First try to exhaust all avenues to not sync */
 	if (IS_NOCMTIME(inode))
 		return;
 
-	err = mnt_want_write_file(file);
-	if (err)
-		return;
-
 	now = current_fs_time(inode->i_sb);
-	if (!timespec_equal(&inode->i_mtime, &now)) {
-		inode->i_mtime = now;
-		sync_it = 1;
-	}
+	if (!timespec_equal(&inode->i_mtime, &now))
+		sync_it = S_MTIME;
 
-	if (!timespec_equal(&inode->i_ctime, &now)) {
-		inode->i_ctime = now;
-		sync_it = 1;
-	}
+	if (!timespec_equal(&inode->i_ctime, &now))
+		sync_it |= S_CTIME;
 
-	if (IS_I_VERSION(inode)) {
-		inode_inc_iversion(inode);
-		sync_it = 1;
-	}
+	if (IS_I_VERSION(inode))
+		sync_it |= S_VERSION;
+
+	if (!sync_it)
+		return;
+
+	/* Finally allowed to write? Takes lock. */
+	if (mnt_want_write_file(file))
+		return;
 
-	if (sync_it)
-		mark_inode_dirty_sync(inode);
+	/* Only change inode inside the lock region */
+	if (sync_it & S_VERSION)
+		inode_inc_iversion(inode);
+	if (sync_it & S_CTIME)
+		inode->i_ctime = now;
+	if (sync_it & S_MTIME)
+		inode->i_mtime = now;
+	mark_inode_dirty_sync(inode);
 	mnt_drop_write(file->f_path.mnt);
 }
 EXPORT_SYMBOL(file_update_time);
_

Patches currently in -mm which might be from andi@firstfloor.org are

origin.patch
fatfs-use-common-time_to_tm-in-fat_time_unix2fat.patch

