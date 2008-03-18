From: akpm@linux-foundation.org
Subject: + fuse-update-file-size-on-short-read.patch added to -mm tree
Date: Mon, 17 Mar 2008 22:09:03 -0700
Message-ID: <200803180509.m2I5937i015500@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54152 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753803AbYCRFJj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Mar 2008 01:09:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     fuse: update file size on short read
has been added to the -mm tree.  Its filename is
     fuse-update-file-size-on-short-read.patch

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
Subject: fuse: update file size on short read
From: Miklos Szeredi <mszeredi@suse.cz>

If the READ request returned a short count, then either

  - cached size is incorrect
  - filesystem is buggy, as short reads are only allowed on EOF

So assume that the size is wrong and refresh it, so that cached read() doesn't
zero fill the missing chunk.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/file.c |   42 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 38 insertions(+), 4 deletions(-)

diff -puN fs/fuse/file.c~fuse-update-file-size-on-short-read fs/fuse/file.c
--- a/fs/fuse/file.c~fuse-update-file-size-on-short-read
+++ a/fs/fuse/file.c
@@ -398,11 +398,26 @@ static size_t fuse_send_read(struct fuse
 	return req->out.args[0].size;
 }
 
+static void fuse_read_update_size(struct inode *inode, loff_t size)
+{
+	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_inode *fi = get_fuse_inode(inode);
+
+	spin_lock(&fc->lock);
+	fi->attr_version = ++fc->attr_version;
+	if (size < inode->i_size)
+		i_size_write(inode, size);
+	spin_unlock(&fc->lock);
+}
+
 static int fuse_readpage(struct file *file, struct page *page)
 {
 	struct inode *inode = page->mapping->host;
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_req *req;
+	size_t num_read;
+	loff_t pos = page_offset(page);
+	size_t count = PAGE_CACHE_SIZE;
 	int err;
 
 	err = -EIO;
@@ -424,12 +439,20 @@ static int fuse_readpage(struct file *fi
 	req->out.page_zeroing = 1;
 	req->num_pages = 1;
 	req->pages[0] = page;
-	fuse_send_read(req, file, inode, page_offset(page), PAGE_CACHE_SIZE,
-		       NULL);
+	num_read = fuse_send_read(req, file, inode, pos, count, NULL);
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
-	if (!err)
+
+	if (!err) {
+		/*
+		 * Short read means EOF.  If file size is larger, truncate it
+		 */
+		if (num_read < count)
+			fuse_read_update_size(inode, pos + num_read);
+
 		SetPageUptodate(page);
+	}
+
 	fuse_invalidate_attr(inode); /* atime changed */
  out:
 	unlock_page(page);
@@ -439,8 +462,19 @@ static int fuse_readpage(struct file *fi
 static void fuse_readpages_end(struct fuse_conn *fc, struct fuse_req *req)
 {
 	int i;
+	size_t count = req->misc.read_in.size;
+	size_t num_read = req->out.args[0].size;
+	struct inode *inode = req->pages[0]->mapping->host;
 
-	fuse_invalidate_attr(req->pages[0]->mapping->host); /* atime changed */
+	/*
+	 * Short read means EOF.  If file size is larger, truncate it
+	 */
+	if (!req->out.h.error && num_read < count) {
+		loff_t pos = page_offset(req->pages[0]) + num_read;
+		fuse_read_update_size(inode, pos);
+	}
+
+	fuse_invalidate_attr(inode); /* atime changed */
 
 	for (i = 0; i < req->num_pages; i++) {
 		struct page *page = req->pages[i];
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

