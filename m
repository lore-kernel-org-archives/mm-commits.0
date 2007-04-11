From: akpm@linux-foundation.org
Subject: + reiser4-fix-for-drop-unused-semaphorespatch.patch added to -mm tree
Date: Tue, 10 Apr 2007 17:42:45 -0700
Message-ID: <200704110042.l3B0gjOH024402@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54082 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932359AbXDKAm4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 20:42:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: edward@namesys.com, jbriggs@esoft.com


The patch titled
     reiser4: fix for drop-unused-semaphores.patch
has been added to the -mm tree.  Its filename is
     reiser4-fix-for-drop-unused-semaphorespatch.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: reiser4: fix for drop-unused-semaphores.patch
From: Edward Shishkin <edward@namesys.com>

Wait for tail conversion completion when acquiring exclusive access by
. mmap_unix_file()
. setattr_unix_file()
. release_unix_file()
Update comments.

Signed-off-by: Edward Shishkin <edward@namesys.com>
Cc Jonathan Briggs <jbriggs@esoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/file/file.c            |   37 +++++++++++----------
 fs/reiser4/plugin/file/tail_conversion.c |   21 ++++++-----
 2 files changed, 32 insertions(+), 26 deletions(-)

diff -puN fs/reiser4/plugin/file/file.c~reiser4-fix-for-drop-unused-semaphorespatch fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~reiser4-fix-for-drop-unused-semaphorespatch
+++ a/fs/reiser4/plugin/file/file.c
@@ -28,6 +28,22 @@ static void drop_access(unix_file_info_t
 static int hint_validate(hint_t * hint, const reiser4_key * key, int check_key,
 			 znode_lock_mode lock_mode);
 
+/* Get exclusive access and make sure that file is not partially
+ * converted (It may happen that another process is doing tail
+ * conversion. If so, wait until it completes)
+ */
+static inline void get_exclusive_access_careful(unix_file_info_t * uf_info,
+						struct inode *inode)
+{
+        do {
+		get_exclusive_access(uf_info);
+		if (!reiser4_inode_get_flag(inode, REISER4_PART_IN_CONV))
+			break;
+		drop_exclusive_access(uf_info);
+		schedule();
+	} while (1);
+}
+
 /* get unix file plugin specific portion of inode */
 unix_file_info_t *unix_file_inode_data(const struct inode *inode)
 {
@@ -1933,7 +1949,7 @@ int mmap_unix_file(struct file *file, st
 
 	uf_info = unix_file_inode_data(inode);
 
-	get_exclusive_access(uf_info);
+	get_exclusive_access_careful(uf_info, inode);
 
 	if (!IS_RDONLY(inode) && (vma->vm_flags & (VM_MAYWRITE | VM_SHARED))) {
 		/*
@@ -2048,21 +2064,8 @@ int open_unix_file(struct inode *inode, 
 		return PTR_ERR(ctx);
 
 	uf_info = unix_file_inode_data(inode);
-	get_exclusive_access(uf_info);
 
-	/*
-	 * it may happen that another process is doing tail conversion. Wait
-	 * until it completes
-	 */
-	while (1) {
-		if (reiser4_inode_get_flag(inode, REISER4_PART_IN_CONV)) {
-			drop_exclusive_access(uf_info);
-			schedule();
-			get_exclusive_access(uf_info);
-			continue;
-		}
-		break;
-	}
+	get_exclusive_access_careful(uf_info, inode);
 
 	if (!reiser4_inode_get_flag(inode, REISER4_PART_MIXED)) {
 		/*
@@ -2365,7 +2368,7 @@ int release_unix_file(struct inode *inod
 	if (in_reiser4 == 0) {
 		uf_info = unix_file_inode_data(inode);
 
-		get_exclusive_access(uf_info);
+		get_exclusive_access_careful(uf_info, inode);
 		if (atomic_read(&file->f_dentry->d_count) == 1 &&
 		    uf_info->container == UF_CONTAINER_EXTENTS &&
 		    !should_have_notail(uf_info, inode->i_size) &&
@@ -2674,7 +2677,7 @@ int setattr_unix_file(struct dentry *den
 			return PTR_ERR(ctx);
 
 		uf_info = unix_file_inode_data(dentry->d_inode);
-		get_exclusive_access(uf_info);
+		get_exclusive_access_careful(uf_info, dentry->d_inode);
 		result = setattr_truncate(dentry->d_inode, attr);
 		drop_exclusive_access(uf_info);
 		context_set_commit_async(ctx);
diff -puN fs/reiser4/plugin/file/tail_conversion.c~reiser4-fix-for-drop-unused-semaphorespatch fs/reiser4/plugin/file/tail_conversion.c
--- a/fs/reiser4/plugin/file/tail_conversion.c~reiser4-fix-for-drop-unused-semaphorespatch
+++ a/fs/reiser4/plugin/file/tail_conversion.c
@@ -468,15 +468,18 @@ int tail2extent(unix_file_info_t *uf_inf
 			if (result)
 				goto error;
 			/*
-			 * we have to drop exclusive access to avoid deadlock
-			 * which may happen because called by
-			 * reiser4_writepages capture_unix_file requires to get
-			 * non-exclusive access to a file. It is safe to drop
-			 * EA in the middle of tail2extent conversion because
-			 * write_unix_file/unix_setattr(truncate)/release_unix_file(extent2tail)
-			 * are serialized by reiser4_inode->mutex_write semaphore and
-			 * because read_unix_file works (should at least) on
-			 * partially converted files
+			 * We have to drop exclusive access to avoid deadlock
+			 * which may happen because called by reiser4_writepages
+			 * capture_unix_file requires to get non-exclusive
+			 * access to a file. It is safe to drop EA in the middle
+			 * of tail2extent conversion because write_unix_file,
+			 * setattr_unix_file(truncate), mmap_unix_file,
+			 * release_unix_file(extent2tail) checks if conversion
+			 * is not in progress (see comments before
+			 * get_exclusive_access_careful().
+			 * Other processes that acquire non-exclusive access
+			 * (read_unix_file, reiser4_writepages, etc) should work
+			 * on partially converted files.
 			 */
 			drop_exclusive_access(uf_info);
 			/* throttle the conversion */
_

Patches currently in -mm which might be from edward@namesys.com are

reiser4.patch
reiser4-fix-for-drop-unused-semaphorespatch.patch
reiser4-use-simple_prepare_write-to-zero-page-data.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
