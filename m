From: akpm@linux-foundation.org
Subject: [patch 088/114] fs: semove set but not checked
 AOP_FLAG_UNINTERRUPTIBLE flag
Date: Mon, 08 May 2017 15:58:59 -0700
Message-ID: <20170508225859.p3E_7GhxF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47346 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752921AbdEHW7A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:59:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hch@lst.de, jlayton@redhat.com, mm-commits@vger.kernel.org, npiggin@gmail.com, penguin-kernel@I-love.SAKURA.ne.jp, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: fs: semove set but not checked AOP_FLAG_UNINTERRUPTIBLE flag

afddba49d18f346e ("fs: introduce write_begin, write_end, and perform_write
aops") introduced AOP_FLAG_UNINTERRUPTIBLE flag which was checked in
pagecache_write_begin(), but that check was removed by 4e02ed4b4a2fae34
("fs: remove prepare_write/commit_write").

Between these two commits, d9414774dc0c7b39 ("cifs: Convert cifs to new
aops.") added a check in cifs_write_begin(), but that check was soon
removed by a98ee8c1c707fe32 ("[CIFS] fix regression in
cifs_write_begin/cifs_write_end").

Therefore, AOP_FLAG_UNINTERRUPTIBLE flag is checked nowhere.  Let's remove
this flag.  This patch has no functionality changes.

Link: http://lkml.kernel.org/r/1489294781-53494-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Nick Piggin <npiggin@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/vfs.txt |    3 +--
 fs/buffer.c                       |   13 +++++--------
 fs/exofs/dir.c                    |    3 +--
 fs/hfs/extent.c                   |    4 ++--
 fs/hfsplus/extents.c              |    5 ++---
 fs/iomap.c                        |   13 +++----------
 fs/namei.c                        |    2 +-
 include/linux/fs.h                |    5 ++---
 mm/filemap.c                      |    6 ------
 9 files changed, 17 insertions(+), 37 deletions(-)

diff -puN Documentation/filesystems/vfs.txt~fs-remove-set-but-not-checked-aop_flag_uninterruptible-flag Documentation/filesystems/vfs.txt
--- a/Documentation/filesystems/vfs.txt~fs-remove-set-but-not-checked-aop_flag_uninterruptible-flag
+++ a/Documentation/filesystems/vfs.txt
@@ -694,8 +694,7 @@ struct address_space_operations {
 
   write_end: After a successful write_begin, and data copy, write_end must
         be called. len is the original len passed to write_begin, and copied
-        is the amount that was able to be copied (copied == len is always true
-	if write_begin was called with the AOP_FLAG_UNINTERRUPTIBLE flag).
+        is the amount that was able to be copied.
 
         The filesystem must take care of unlocking the page and releasing it
         refcount, and updating i_size.
diff -puN fs/buffer.c~fs-remove-set-but-not-checked-aop_flag_uninterruptible-flag fs/buffer.c
--- a/fs/buffer.c~fs-remove-set-but-not-checked-aop_flag_uninterruptible-flag
+++ a/fs/buffer.c
@@ -2379,8 +2379,7 @@ int generic_cont_expand_simple(struct in
 		goto out;
 
 	err = pagecache_write_begin(NULL, mapping, size, 0,
-				AOP_FLAG_UNINTERRUPTIBLE|AOP_FLAG_CONT_EXPAND,
-				&page, &fsdata);
+				    AOP_FLAG_CONT_EXPAND, &page, &fsdata);
 	if (err)
 		goto out;
 
@@ -2415,9 +2414,8 @@ static int cont_expand_zero(struct file
 		}
 		len = PAGE_SIZE - zerofrom;
 
-		err = pagecache_write_begin(file, mapping, curpos, len,
-						AOP_FLAG_UNINTERRUPTIBLE,
-						&page, &fsdata);
+		err = pagecache_write_begin(file, mapping, curpos, len, 0,
+					    &page, &fsdata);
 		if (err)
 			goto out;
 		zero_user(page, zerofrom, len);
@@ -2449,9 +2447,8 @@ static int cont_expand_zero(struct file
 		}
 		len = offset - zerofrom;
 
-		err = pagecache_write_begin(file, mapping, curpos, len,
-						AOP_FLAG_UNINTERRUPTIBLE,
-						&page, &fsdata);
+		err = pagecache_write_begin(file, mapping, curpos, len, 0,
+					    &page, &fsdata);
 		if (err)
 			goto out;
 		zero_user(page, zerofrom, len);
diff -puN fs/exofs/dir.c~fs-remove-set-but-not-checked-aop_flag_uninterruptible-flag fs/exofs/dir.c
--- a/fs/exofs/dir.c~fs-remove-set-but-not-checked-aop_flag_uninterruptible-flag
+++ a/fs/exofs/dir.c
@@ -405,8 +405,7 @@ int exofs_set_link(struct inode *dir, st
 	int err;
 
 	lock_page(page);
-	err = exofs_write_begin(NULL, page->mapping, pos, len,
-				AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
+	err = exofs_write_begin(NULL, page->mapping, pos, len, 0, &page, NULL);
 	if (err)
 		EXOFS_ERR("exofs_set_link: exofs_write_begin FAILED => %d\n",
 			  err);
diff -puN fs/hfs/extent.c~fs-remove-set-but-not-checked-aop_flag_uninterruptible-flag fs/hfs/extent.c
--- a/fs/hfs/extent.c~fs-remove-set-but-not-checked-aop_flag_uninterruptible-flag
+++ a/fs/hfs/extent.c
@@ -485,8 +485,8 @@ void hfs_file_truncate(struct inode *ino
 
 		/* XXX: Can use generic_cont_expand? */
 		size = inode->i_size - 1;
-		res = pagecache_write_begin(NULL, mapping, size+1, 0,
-				AOP_FLAG_UNINTERRUPTIBLE, &page, &fsdata);
+		res = pagecache_write_begin(NULL, mapping, size+1, 0, 0,
+					    &page, &fsdata);
 		if (!res) {
 			res = pagecache_write_end(NULL, mapping, size+1, 0, 0,
 					page, fsdata);
diff -puN fs/hfsplus/extents.c~fs-remove-set-but-not-checked-aop_flag_uninterruptible-flag fs/hfsplus/extents.c
--- a/fs/hfsplus/extents.c~fs-remove-set-but-not-checked-aop_flag_uninterruptible-flag
+++ a/fs/hfsplus/extents.c
@@ -545,9 +545,8 @@ void hfsplus_file_truncate(struct inode
 		void *fsdata;
 		loff_t size = inode->i_size;
 
-		res = pagecache_write_begin(NULL, mapping, size, 0,
-						AOP_FLAG_UNINTERRUPTIBLE,
-						&page, &fsdata);
+		res = pagecache_write_begin(NULL, mapping, size, 0, 0,
+					    &page, &fsdata);
 		if (res)
 			return;
 		res = pagecache_write_end(NULL, mapping, size,
diff -puN fs/iomap.c~fs-remove-set-but-not-checked-aop_flag_uninterruptible-flag fs/iomap.c
--- a/fs/iomap.c~fs-remove-set-but-not-checked-aop_flag_uninterruptible-flag
+++ a/fs/iomap.c
@@ -158,12 +158,6 @@ iomap_write_actor(struct inode *inode, l
 	ssize_t written = 0;
 	unsigned int flags = AOP_FLAG_NOFS;
 
-	/*
-	 * Copies from kernel address space cannot fail (NFSD is a big user).
-	 */
-	if (!iter_is_iovec(i))
-		flags |= AOP_FLAG_UNINTERRUPTIBLE;
-
 	do {
 		struct page *page;
 		unsigned long offset;	/* Offset into pagecache page */
@@ -291,8 +285,7 @@ iomap_dirty_actor(struct inode *inode, l
 			return PTR_ERR(rpage);
 
 		status = iomap_write_begin(inode, pos, bytes,
-				AOP_FLAG_NOFS | AOP_FLAG_UNINTERRUPTIBLE,
-				&page, iomap);
+					   AOP_FLAG_NOFS, &page, iomap);
 		put_page(rpage);
 		if (unlikely(status))
 			return status;
@@ -343,8 +336,8 @@ static int iomap_zero(struct inode *inod
 	struct page *page;
 	int status;
 
-	status = iomap_write_begin(inode, pos, bytes,
-			AOP_FLAG_UNINTERRUPTIBLE | AOP_FLAG_NOFS, &page, iomap);
+	status = iomap_write_begin(inode, pos, bytes, AOP_FLAG_NOFS, &page,
+				   iomap);
 	if (status)
 		return status;
 
diff -puN fs/namei.c~fs-remove-set-but-not-checked-aop_flag_uninterruptible-flag fs/namei.c
--- a/fs/namei.c~fs-remove-set-but-not-checked-aop_flag_uninterruptible-flag
+++ a/fs/namei.c
@@ -4766,7 +4766,7 @@ int __page_symlink(struct inode *inode,
 	struct page *page;
 	void *fsdata;
 	int err;
-	unsigned int flags = AOP_FLAG_UNINTERRUPTIBLE;
+	unsigned int flags = 0;
 	if (nofs)
 		flags |= AOP_FLAG_NOFS;
 
diff -puN include/linux/fs.h~fs-remove-set-but-not-checked-aop_flag_uninterruptible-flag include/linux/fs.h
--- a/include/linux/fs.h~fs-remove-set-but-not-checked-aop_flag_uninterruptible-flag
+++ a/include/linux/fs.h
@@ -250,9 +250,8 @@ enum positive_aop_returns {
 	AOP_TRUNCATED_PAGE	= 0x80001,
 };
 
-#define AOP_FLAG_UNINTERRUPTIBLE	0x0001 /* will not do a short write */
-#define AOP_FLAG_CONT_EXPAND		0x0002 /* called from cont_expand */
-#define AOP_FLAG_NOFS			0x0004 /* used by filesystem to direct
+#define AOP_FLAG_CONT_EXPAND		0x0001 /* called from cont_expand */
+#define AOP_FLAG_NOFS			0x0002 /* used by filesystem to direct
 						* helper code (eg buffer layer)
 						* to clear GFP_FS from alloc */
 
diff -puN mm/filemap.c~fs-remove-set-but-not-checked-aop_flag_uninterruptible-flag mm/filemap.c
--- a/mm/filemap.c~fs-remove-set-but-not-checked-aop_flag_uninterruptible-flag
+++ a/mm/filemap.c
@@ -2791,12 +2791,6 @@ ssize_t generic_perform_write(struct fil
 	ssize_t written = 0;
 	unsigned int flags = 0;
 
-	/*
-	 * Copies from kernel address space cannot fail (NFSD is a big user).
-	 */
-	if (!iter_is_iovec(i))
-		flags |= AOP_FLAG_UNINTERRUPTIBLE;
