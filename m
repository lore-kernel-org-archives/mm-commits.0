From: akpm@linux-foundation.org
Subject: + fuse-update-file-size-on-short-read-fix.patch added to -mm tree
Date: Sun, 27 Apr 2008 19:26:28 -0700
Message-ID: <200804280226.m3S2QSJP003419@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37231 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763335AbYD1C1F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 22:27:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     fuse: fix truncation on short read
has been added to the -mm tree.  Its filename is
     fuse-update-file-size-on-short-read-fix.patch

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
Subject: fuse: fix truncation on short read
From: Miklos Szeredi <mszeredi@suse.cz>

fuse-update-file-size-on-short-read.patch introduced a bug, where a
read could truncate off the part recently extended by a parallel
write.

Fix by using the attribute versioning already used by getattr().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dir.c    |    2 +-
 fs/fuse/file.c   |   22 ++++++++++++++--------
 fs/fuse/fuse_i.h |    7 ++++++-
 3 files changed, 21 insertions(+), 10 deletions(-)

diff -puN fs/fuse/dir.c~fuse-update-file-size-on-short-read-fix fs/fuse/dir.c
--- a/fs/fuse/dir.c~fuse-update-file-size-on-short-read-fix
+++ a/fs/fuse/dir.c
@@ -132,7 +132,7 @@ static void fuse_lookup_init(struct fuse
 	req->out.args[0].value = outarg;
 }
 
-static u64 fuse_get_attr_version(struct fuse_conn *fc)
+u64 fuse_get_attr_version(struct fuse_conn *fc)
 {
 	u64 curr_version;
 
diff -puN fs/fuse/file.c~fuse-update-file-size-on-short-read-fix fs/fuse/file.c
--- a/fs/fuse/file.c~fuse-update-file-size-on-short-read-fix
+++ a/fs/fuse/file.c
@@ -363,7 +363,7 @@ static int fuse_fsync(struct file *file,
 void fuse_read_fill(struct fuse_req *req, struct file *file,
 		    struct inode *inode, loff_t pos, size_t count, int opcode)
 {
-	struct fuse_read_in *inarg = &req->misc.read_in;
+	struct fuse_read_in *inarg = &req->misc.read.in;
 	struct fuse_file *ff = file->private_data;
 
 	inarg->fh = ff->fh;
@@ -389,7 +389,7 @@ static size_t fuse_send_read(struct fuse
 
 	fuse_read_fill(req, file, inode, pos, count, FUSE_READ);
 	if (owner != NULL) {
-		struct fuse_read_in *inarg = &req->misc.read_in;
+		struct fuse_read_in *inarg = &req->misc.read.in;
 
 		inarg->read_flags |= FUSE_READ_LOCKOWNER;
 		inarg->lock_owner = fuse_lock_owner_id(fc, owner);
@@ -398,15 +398,17 @@ static size_t fuse_send_read(struct fuse
 	return req->out.args[0].size;
 }
 
-static void fuse_read_update_size(struct inode *inode, loff_t size)
+static void fuse_read_update_size(struct inode *inode, loff_t size,
+				  u64 attr_ver)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_inode *fi = get_fuse_inode(inode);
 
 	spin_lock(&fc->lock);
-	fi->attr_version = ++fc->attr_version;
-	if (size < inode->i_size)
+	if (attr_ver == fi->attr_version && size < inode->i_size) {
+		fi->attr_version = ++fc->attr_version;
 		i_size_write(inode, size);
+	}
 	spin_unlock(&fc->lock);
 }
 
@@ -418,6 +420,7 @@ static int fuse_readpage(struct file *fi
 	size_t num_read;
 	loff_t pos = page_offset(page);
 	size_t count = PAGE_CACHE_SIZE;
+	u64 attr_ver;
 	int err;
 
 	err = -EIO;
@@ -436,6 +439,8 @@ static int fuse_readpage(struct file *fi
 	if (IS_ERR(req))
 		goto out;
 
+	attr_ver = fuse_get_attr_version(fc);
+
 	req->out.page_zeroing = 1;
 	req->num_pages = 1;
 	req->pages[0] = page;
@@ -448,7 +453,7 @@ static int fuse_readpage(struct file *fi
 		 * Short read means EOF.  If file size is larger, truncate it
 		 */
 		if (num_read < count)
-			fuse_read_update_size(inode, pos + num_read);
+			fuse_read_update_size(inode, pos + num_read, attr_ver);
 
 		SetPageUptodate(page);
 	}
@@ -462,7 +467,7 @@ static int fuse_readpage(struct file *fi
 static void fuse_readpages_end(struct fuse_conn *fc, struct fuse_req *req)
 {
 	int i;
-	size_t count = req->misc.read_in.size;
+	size_t count = req->misc.read.in.size;
 	size_t num_read = req->out.args[0].size;
 	struct inode *inode = req->pages[0]->mapping->host;
 
@@ -471,7 +476,7 @@ static void fuse_readpages_end(struct fu
 	 */
 	if (!req->out.h.error && num_read < count) {
 		loff_t pos = page_offset(req->pages[0]) + num_read;
-		fuse_read_update_size(inode, pos);
+		fuse_read_update_size(inode, pos, req->misc.read.attr_ver);
 	}
 
 	fuse_invalidate_attr(inode); /* atime changed */
@@ -497,6 +502,7 @@ static void fuse_send_readpages(struct f
 	size_t count = req->num_pages << PAGE_CACHE_SHIFT;
 	req->out.page_zeroing = 1;
 	fuse_read_fill(req, file, inode, pos, count, FUSE_READ);
+	req->misc.read.attr_ver = fuse_get_attr_version(fc);
 	if (fc->async_read) {
 		struct fuse_file *ff = file->private_data;
 		req->ff = fuse_file_get(ff);
diff -puN fs/fuse/fuse_i.h~fuse-update-file-size-on-short-read-fix fs/fuse/fuse_i.h
--- a/fs/fuse/fuse_i.h~fuse-update-file-size-on-short-read-fix
+++ a/fs/fuse/fuse_i.h
@@ -239,7 +239,10 @@ struct fuse_req {
 		} release;
 		struct fuse_init_in init_in;
 		struct fuse_init_out init_out;
-		struct fuse_read_in read_in;
+		struct {
+			struct fuse_read_in in;
+			u64 attr_ver;
+		} read;
 		struct {
 			struct fuse_write_in in;
 			struct fuse_write_out out;
@@ -637,3 +640,5 @@ void fuse_flush_writepages(struct inode 
 
 void fuse_set_nowrite(struct inode *inode);
 void fuse_release_nowrite(struct inode *inode);
+
+u64 fuse_get_attr_version(struct fuse_conn *fc);
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
git-nfsd.patch
mm-rotate_reclaimable_page-cleanup.patch
vfs-remove-lives_below_in_same_fs.patch
ecryptfs-add-missing-lock-around-notify_change.patch
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
mm-bdi-add-separate-writeback-accounting-capability.patch
mm-bdi-export-bdi_writeout_inc.patch
mm-bdi-export-bdi_writeout_inc-fix.patch
mm-add-nr_writeback_temp-counter.patch
mm-add-nr_writeback_temp-counter-fix.patch
mm-document-missing-fields-for-proc-meminfo.patch
fuse-support-writable-mmap.patch
fuse-support-writable-mmap-fix.patch
fuse-clean-up-setting-i_size-in-write.patch
fuse-implement-perform_write.patch
fuse-update-file-size-on-short-read.patch
fuse-update-file-size-on-short-read-fix.patch
fuse-fix-max-i-o-size-calculation.patch
fuse-fix-node-id-type.patch
fuse-fix-race-in-llseek.patch
fuse-fix-race-in-llseek-fix.patch
fuse-fix-sparse-warnings.patch

