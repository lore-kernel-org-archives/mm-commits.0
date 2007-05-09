From: akpm@linux-foundation.org
Subject: - remove-do_sync_file_range.patch removed from -mm tree
Date: Tue, 08 May 2007 19:47:31 -0700
Message-ID: <200705090247.l492lV3F008983@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40527 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755301AbXEICrn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:47:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mark.fasheh@oracle.com, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     Remove do_sync_file_range()
has been removed from the -mm tree.  Its filename was
     remove-do_sync_file_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove do_sync_file_range()
From: Mark Fasheh <mark.fasheh@oracle.com>

Remove do_sync_file_range() and convert callers to just use
do_sync_mapping_range().

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/bitmap.c |    8 ++++----
 fs/sync.c           |    2 +-
 include/linux/fs.h  |    5 -----
 mm/filemap.c        |    8 ++++----
 4 files changed, 9 insertions(+), 14 deletions(-)

diff -puN drivers/md/bitmap.c~remove-do_sync_file_range drivers/md/bitmap.c
--- a/drivers/md/bitmap.c~remove-do_sync_file_range
+++ a/drivers/md/bitmap.c
@@ -1456,10 +1456,10 @@ int bitmap_create(mddev_t *mddev)
 	bitmap->offset = mddev->bitmap_offset;
 	if (file) {
 		get_file(file);
-		do_sync_file_range(file, 0, LLONG_MAX,
-				   SYNC_FILE_RANGE_WAIT_BEFORE |
-				   SYNC_FILE_RANGE_WRITE |
-				   SYNC_FILE_RANGE_WAIT_AFTER);
+		do_sync_mapping_range(file->f_mapping, 0, LLONG_MAX,
+				      SYNC_FILE_RANGE_WAIT_BEFORE |
+				      SYNC_FILE_RANGE_WRITE |
+				      SYNC_FILE_RANGE_WAIT_AFTER);
 	}
 	/* read superblock from bitmap file (this sets bitmap->chunksize) */
 	err = bitmap_read_sb(bitmap);
diff -puN fs/sync.c~remove-do_sync_file_range fs/sync.c
--- a/fs/sync.c~remove-do_sync_file_range
+++ a/fs/sync.c
@@ -229,7 +229,7 @@ asmlinkage long sys_sync_file_range(int 
 			!S_ISLNK(i_mode))
 		goto out_put;
 
-	ret = do_sync_file_range(file, offset, endbyte, flags);
+	ret = do_sync_mapping_range(file->f_mapping, offset, endbyte, flags);
 out_put:
 	fput_light(file, fput_needed);
 out:
diff -puN include/linux/fs.h~remove-do_sync_file_range include/linux/fs.h
--- a/include/linux/fs.h~remove-do_sync_file_range
+++ a/include/linux/fs.h
@@ -849,11 +849,6 @@ extern int fcntl_getlease(struct file *f
 /* fs/sync.c */
 extern int do_sync_mapping_range(struct address_space *mapping, loff_t offset,
 			loff_t endbyte, unsigned int flags);
-static inline int do_sync_file_range(struct file *file, loff_t offset,
-			loff_t endbyte, unsigned int flags)
-{
-	return do_sync_mapping_range(file->f_mapping, offset, endbyte, flags);
-}
 
 /* fs/locks.c */
 extern void locks_init_lock(struct file_lock *);
diff -puN mm/filemap.c~remove-do_sync_file_range mm/filemap.c
--- a/mm/filemap.c~remove-do_sync_file_range
+++ a/mm/filemap.c
@@ -2309,10 +2309,10 @@ __generic_file_aio_write_nolock(struct k
 		 * semantics.
 		 */
 		endbyte = pos + written_buffered - written - 1;
-		err = do_sync_file_range(file, pos, endbyte,
-					 SYNC_FILE_RANGE_WAIT_BEFORE|
-					 SYNC_FILE_RANGE_WRITE|
-					 SYNC_FILE_RANGE_WAIT_AFTER);
+		err = do_sync_mapping_range(file->f_mapping, pos, endbyte,
+					    SYNC_FILE_RANGE_WAIT_BEFORE|
+					    SYNC_FILE_RANGE_WRITE|
+					    SYNC_FILE_RANGE_WAIT_AFTER);
 		if (err == 0) {
 			written = written_buffered;
 			invalidate_mapping_pages(mapping,
_

Patches currently in -mm which might be from mark.fasheh@oracle.com are

origin.patch
