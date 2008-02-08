From: akpm@linux-foundation.org
Subject: - kill-do_generic_mapping_read.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:19:14 -0800
Message-ID: <200802082018.m18KIthO010986@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52420 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750908AbYBHUnT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:43:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     kill do_generic_mapping_read
has been removed from the -mm tree.  Its filename was
     kill-do_generic_mapping_read.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kill do_generic_mapping_read
From: Christoph Hellwig <hch@lst.de>

do_generic_mapping_read was used by gfs2 for internals reads, but this use
of the interface was rather suboptimal (as was the whole interface) and has
been replaced by an internal helper now.  This patch kills
do_generic_mapping_read and surrounding damage in preparation of additional
cleanups for the buffered read path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |   15 ---------------
 mm/filemap.c       |   18 +++++-------------
 2 files changed, 5 insertions(+), 28 deletions(-)

diff -puN include/linux/fs.h~kill-do_generic_mapping_read include/linux/fs.h
--- a/include/linux/fs.h~kill-do_generic_mapping_read
+++ a/include/linux/fs.h
@@ -1807,9 +1807,6 @@ extern ssize_t generic_file_buffered_wri
 		unsigned long, loff_t, loff_t *, size_t, ssize_t);
 extern ssize_t do_sync_read(struct file *filp, char __user *buf, size_t len, loff_t *ppos);
 extern ssize_t do_sync_write(struct file *filp, const char __user *buf, size_t len, loff_t *ppos);
-extern void do_generic_mapping_read(struct address_space *mapping,
-				    struct file_ra_state *, struct file *,
-				    loff_t *, read_descriptor_t *, read_actor_t);
 extern int generic_segment_checks(const struct iovec *iov,
 		unsigned long *nr_segs, size_t *count, int access_flags);
 
@@ -1847,18 +1844,6 @@ static inline int xip_truncate_page(stru
 }
 #endif
 
-static inline void do_generic_file_read(struct file * filp, loff_t *ppos,
-					read_descriptor_t * desc,
-					read_actor_t actor)
-{
-	do_generic_mapping_read(filp->f_mapping,
-				&filp->f_ra,
-				filp,
-				ppos,
-				desc,
-				actor);
-}
-
 #ifdef CONFIG_BLOCK
 ssize_t __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	struct block_device *bdev, const struct iovec *iov, loff_t offset,
diff -puN mm/filemap.c~kill-do_generic_mapping_read mm/filemap.c
--- a/mm/filemap.c~kill-do_generic_mapping_read
+++ a/mm/filemap.c
@@ -875,9 +875,7 @@ static void shrink_readahead_size_eio(st
 }
 
 /**
- * do_generic_mapping_read - generic file read routine
- * @mapping:	address_space to be read
- * @ra:		file's readahead state
+ * do_generic_file_read - generic file read routine
  * @filp:	the file to read
  * @ppos:	current file position
  * @desc:	read_descriptor
@@ -888,18 +886,13 @@ static void shrink_readahead_size_eio(st
  *
  * This is really ugly. But the goto's actually try to clarify some
  * of the logic when it comes to error handling etc.
- *
- * Note the struct file* is only passed for the use of readpage.
- * It may be NULL.
  */
-void do_generic_mapping_read(struct address_space *mapping,
-			     struct file_ra_state *ra,
-			     struct file *filp,
-			     loff_t *ppos,
-			     read_descriptor_t *desc,
-			     read_actor_t actor)
+static void do_generic_file_read(struct file *filp, loff_t *ppos,
+		read_descriptor_t *desc, read_actor_t actor)
 {
+	struct address_space *mapping = filp->f_mapping;
 	struct inode *inode = mapping->host;
+	struct file_ra_state *ra = &filp->f_ra;
 	pgoff_t index;
 	pgoff_t last_index;
 	pgoff_t prev_index;
@@ -1091,7 +1084,6 @@ out:
 	if (filp)
 		file_accessed(filp);
 }
-EXPORT_SYMBOL(do_generic_mapping_read);
 
 int file_read_actor(read_descriptor_t *desc, struct page *page,
 			unsigned long offset, unsigned long size)
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
git-unionfs.patch
git-xfs.patch
uml-update-defconfig.patch
reiserfs-eliminate-private-use-of-struct-file-in-xattr.patch
rename-open_namei-to-open_pathname.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-opened-files.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
dont-touch-fs_struct-in-drivers.patch
dont-touch-fs_struct-in-usermodehelper.patch
remove-path_release_on_umount.patch
move-struct-path-into-its-own-header.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-cifs-fix.patch
introduce-path_put.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
introduce-path_get.patch
use-struct-path-in-fs_struct.patch
make-set_fs_rootpwd-take-a-struct-path.patch
introduce-path_get-unionfs.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs.patch
introduce-path_put-unionfs.patch
use-struct-path-in-struct-svc_expkey.patch
d_path-make-seq_path-use-a-struct-path-argument.patch
vfs-create-proc-pid-mountinfo.patch
reiserfs-use-open_bdev_excl.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
