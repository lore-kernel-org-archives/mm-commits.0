From: akpm@linux-foundation.org
Subject: - fuse-clean-up-setting-i_size-in-write.patch removed from -mm tree
Date: Thu, 01 May 2008 02:32:04 -0700
Message-ID: <200805010932.m419W4Gc030933@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59784 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757671AbYEAJcI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:32:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     fuse: clean up setting i_size in write
has been removed from the -mm tree.  Its filename was
     fuse-clean-up-setting-i_size-in-write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fuse: clean up setting i_size in write
From: Miklos Szeredi <mszeredi@suse.cz>

Extract common code for setting i_size in write functions into a common
helper.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/file.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff -puN fs/fuse/file.c~fuse-clean-up-setting-i_size-in-write fs/fuse/file.c
--- a/fs/fuse/file.c~fuse-clean-up-setting-i_size-in-write
+++ a/fs/fuse/file.c
@@ -610,13 +610,24 @@ static int fuse_write_begin(struct file 
 	return 0;
 }
 
+static void fuse_write_update_size(struct inode *inode, loff_t pos)
+{
+	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_inode *fi = get_fuse_inode(inode);
+
+	spin_lock(&fc->lock);
+	fi->attr_version = ++fc->attr_version;
+	if (pos > inode->i_size)
+		i_size_write(inode, pos);
+	spin_unlock(&fc->lock);
+}
+
 static int fuse_buffered_write(struct file *file, struct inode *inode,
 			       loff_t pos, unsigned count, struct page *page)
 {
 	int err;
 	size_t nres;
 	struct fuse_conn *fc = get_fuse_conn(inode);
-	struct fuse_inode *fi = get_fuse_inode(inode);
 	unsigned offset = pos & (PAGE_CACHE_SIZE - 1);
 	struct fuse_req *req;
 
@@ -643,12 +654,7 @@ static int fuse_buffered_write(struct fi
 		err = -EIO;
 	if (!err) {
 		pos += nres;
-		spin_lock(&fc->lock);
-		fi->attr_version = ++fc->attr_version;
-		if (pos > inode->i_size)
-			i_size_write(inode, pos);
-		spin_unlock(&fc->lock);
-
+		fuse_write_update_size(inode, pos);
 		if (count == PAGE_CACHE_SIZE)
 			SetPageUptodate(page);
 	}
@@ -766,12 +772,8 @@ static ssize_t fuse_direct_io(struct fil
 	}
 	fuse_put_request(fc, req);
 	if (res > 0) {
-		if (write) {
-			spin_lock(&fc->lock);
-			if (pos > inode->i_size)
-				i_size_write(inode, pos);
-			spin_unlock(&fc->lock);
-		}
+		if (write)
+			fuse_write_update_size(inode, pos);
 		*ppos = pos;
 	}
 	fuse_invalidate_attr(inode);
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
vfs-fix-permission-checking-in-sys_utimensat.patch

