From: akpm@linux-foundation.org
Subject: + vfs-optimize-touch_time-too.patch added to -mm tree
Date: Mon, 20 Jul 2009 23:25:11 -0700
Message-ID: <200907210625.n6L6PBB1002083@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45968 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754756AbZGUGZo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jul 2009 02:25:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com, haveblue@us.ibm.com, hch@infradead.org, vaurora@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     vfs: optimize touch_time() too
has been added to the -mm tree.  Its filename is
     vfs-optimize-touch_time-too.patch

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
Subject: vfs: optimize touch_time() too
From: Andi Kleen <andi@firstfloor.org>

Do a similar optimization as earlier for touch_atime.  Getting the lock in
mnt_get_write is relatively costly, so try all avenues to avoid it first.

This patch is careful to still only update inode fields inside the lock
region.

This didn't show up in benchmarks, but it's easy enough to do.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Valerie Aurora <vaurora@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |   43 +++++++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 20 deletions(-)

diff -puN fs/inode.c~vfs-optimize-touch_time-too fs/inode.c
--- a/fs/inode.c~vfs-optimize-touch_time-too
+++ a/fs/inode.c
@@ -1448,34 +1448,37 @@ void file_update_time(struct file *file)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct timespec now;
-	int sync_it = 0;
-	int err;
+	enum { S_MTIME = 1, S_CTIME = 2, S_VERSION = 4 } sync_it = 0;
 
+	/* First try to exhause all avenues to not sync */
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
+	if (!mnt_want_write_file(file))
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

linux-next.patch
x86-fix-x86-fix-pageattr-handling-for-lpage-percpu-allocator-and-re-enable-it.patch
vfs-optimization-for-touch_atime.patch
vfs-optimize-touch_time-too.patch
vfs-optimize-touch_time-too-fix.patch
hugetlb-restore-interleaving-of-bootmem-huge-pages.patch
documentation-memorytxt-remove-some-very-outdated-recommendations.patch

