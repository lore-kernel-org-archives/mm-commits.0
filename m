From: akpm@linux-foundation.org
Subject: - md-kill-file_path-wrapper.patch removed from -mm tree
Date: Tue, 27 May 2008 00:27:10 -0700
Message-ID: <200805270727.m4R7RAUD014741@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32906 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755858AbYE0H1v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 03:27:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: kill file_path wrapper
has been removed from the -mm tree.  Its filename was
     md-kill-file_path-wrapper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: kill file_path wrapper
From: Christoph Hellwig <hch@lst.de>

Kill the trivial and rather pointless file_path wrapper around d_path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/bitmap.c         |   17 ++++-------------
 drivers/md/md.c             |    4 ++--
 include/linux/raid/bitmap.h |    1 -
 3 files changed, 6 insertions(+), 16 deletions(-)

diff -puN drivers/md/bitmap.c~md-kill-file_path-wrapper drivers/md/bitmap.c
--- a/drivers/md/bitmap.c~md-kill-file_path-wrapper
+++ a/drivers/md/bitmap.c
@@ -203,17 +203,6 @@ static void bitmap_checkfree(struct bitm
  * bitmap file handling - read and write the bitmap file and its superblock
  */
 
-/* copy the pathname of a file to a buffer */
-char *file_path(struct file *file, char *buf, int count)
-{
-	if (!buf)
-		return NULL;
-
-	buf = d_path(&file->f_path, buf, count);
-
-	return IS_ERR(buf) ? NULL : buf;
-}
-
 /*
  * basic page I/O operations
  */
@@ -721,11 +710,13 @@ static void bitmap_file_kick(struct bitm
 		if (bitmap->file) {
 			path = kmalloc(PAGE_SIZE, GFP_KERNEL);
 			if (path)
-				ptr = file_path(bitmap->file, path, PAGE_SIZE);
+				ptr = d_path(&bitmap->file->f_path, path,
+					     PAGE_SIZE);
+
 
 			printk(KERN_ALERT
 			      "%s: kicking failed bitmap file %s from array!\n",
-			      bmname(bitmap), ptr ? ptr : "");
+			      bmname(bitmap), IS_ERR(ptr) ? "" : ptr);
 
 			kfree(path);
 		} else
diff -puN drivers/md/md.c~md-kill-file_path-wrapper drivers/md/md.c
--- a/drivers/md/md.c~md-kill-file_path-wrapper
+++ a/drivers/md/md.c
@@ -3987,8 +3987,8 @@ static int get_bitmap_file(mddev_t * mdd
 	if (!buf)
 		goto out;
 
-	ptr = file_path(mddev->bitmap->file, buf, sizeof(file->pathname));
-	if (!ptr)
+	ptr = d_path(&mddev->bitmap->file->f_path, buf, sizeof(file->pathname));
+	if (IS_ERR(ptr))
 		goto out;
 
 	strcpy(file->pathname, ptr);
diff -puN include/linux/raid/bitmap.h~md-kill-file_path-wrapper include/linux/raid/bitmap.h
--- a/include/linux/raid/bitmap.h~md-kill-file_path-wrapper
+++ a/include/linux/raid/bitmap.h
@@ -262,7 +262,6 @@ int  bitmap_create(mddev_t *mddev);
 void bitmap_flush(mddev_t *mddev);
 void bitmap_destroy(mddev_t *mddev);
 
-char *file_path(struct file *file, char *buf, int count);
 void bitmap_print_sb(struct bitmap *bitmap);
 void bitmap_update_sb(struct bitmap *bitmap);
 
_

Patches currently in -mm which might be from hch@lst.de are

linux-next.patch
git-unionfs.patch
vfs-fix-err_ptr-abuse-in-generic_readlink.patch
kill-generic_file_direct_io.patch
kill-generic_file_direct_io-checkpatch-fixes.patch
lockd-dont-return-eagain-for-a-permanent-error.patch
locks-add-special-return-value-for-asynchronous-locks.patch
locks-cleanup-code-duplication.patch
locks-allow-lock-to-return-file_lock_deferred.patch
fuse-prepare-lookup-for-nfs-export.patch
fuse-add-export-operations.patch
fuse-add-fuse_lookup_name-helper.patch
fuse-nfs-export-special-lookups.patch
fuse-lockd-support.patch

