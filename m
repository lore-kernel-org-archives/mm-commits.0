From: akpm@linux-foundation.org
Subject: + fuse-clean-up-setting-i_size-in-write.patch added to -mm tree
Date: Mon, 17 Mar 2008 22:08:58 -0700
Message-ID: <200803180508.m2I58wVA015479@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753291AbYCRFJd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Mar 2008 01:09:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     fuse: clean up setting i_size in write
has been added to the -mm tree.  Its filename is
     fuse-clean-up-setting-i_size-in-write.patch

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

mm-rotate_reclaimable_page-cleanup.patch
vfs-create-proc-pid-mountinfo.patch
vfs-mountinfo-mm-fix.patch
vfs-pnode-cleanup.patch
vfs-mountinfo-stable-peer-group-id.patch
vfs-mountinfo-show-dominating-group-id.patch
vfs-optimization-to-proc-pid-mountinfo-patch.patch
vfs-mountinfo-only-show-mounts-under-tasks-root.patch
vfs-remove-lives_below_in_same_fs.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-2.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-3.patch
mm-bdi-export-bdi-attributes-in-sysfs-fix-4.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-nfs-fix.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse.patch
mm-bdi-expose-the-bdi-object-in-sysfs-for-fuse-fix.patch
mm-bdi-allow-setting-a-minimum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit.patch
mm-bdi-allow-setting-a-maximum-for-the-bdi-dirty-limit-fix.patch
mm-bdi-move-statistics-to-debugfs.patch
mm-bdi-export-bdi_writeout_inc.patch
mm-add-nr_writeback_temp-counter.patch
mm-allow-not-updating-bdi-stats-in-end_page_writeback.patch
fuse-support-writable-mmap.patch
fuse-clean-up-setting-i_size-in-write.patch
fuse-implement-perform_write.patch
fuse-update-file-size-on-short-read.patch

