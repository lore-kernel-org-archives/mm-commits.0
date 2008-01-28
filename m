From: akpm@linux-foundation.org
Subject: + kill-do_generic_mapping_read.patch added to -mm tree
Date: Sun, 27 Jan 2008 21:29:07 -0800
Message-ID: <200801280530.m0S5U20C014023@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47924 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750961AbYA1Faa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 00:30:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de


The patch titled
     kill do_generic_mapping_read
has been added to the -mm tree.  Its filename is
     kill-do_generic_mapping_read.patch

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
@@ -1810,9 +1810,6 @@ extern ssize_t generic_file_buffered_wri
 		unsigned long, loff_t, loff_t *, size_t, ssize_t);
 extern ssize_t do_sync_read(struct file *filp, char __user *buf, size_t len, loff_t *ppos);
 extern ssize_t do_sync_write(struct file *filp, const char __user *buf, size_t len, loff_t *ppos);
-extern void do_generic_mapping_read(struct address_space *mapping,
-				    struct file_ra_state *, struct file *,
-				    loff_t *, read_descriptor_t *, read_actor_t);
 extern int generic_segment_checks(const struct iovec *iov,
 		unsigned long *nr_segs, size_t *count, int access_flags);
 
@@ -1850,18 +1847,6 @@ static inline int xip_truncate_page(stru
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

git-powerpc.patch
git-mips.patch
git-net.patch
pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int.patch
pcmcia-replace-kio_addr_t-with-unsigned-int-everywhere.patch
git-scsi-misc.patch
git-unionfs.patch
vfs-apply-coding-standards-to-fs-ioctlc.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
vfs-factor-out-three-helpers-for-fibmap-fionbio-fioasync-file-ioctls.patch
git-xfs.patch
clean-up-vmtruncate.patch
vfs-security-rework-inode_getsecurity-and-callers-to.patch
vfs-reorder-vfs_getxattr-to-avoid-unnecessary-calls-to-the-lsm.patch
kernel-add-mutex_lock_killable.patch
vfs-use-mutex_lock_killable-in-vfs_readdir.patch
reiserfs-eliminate-private-use-of-struct-file-in-xattr.patch
rename-open_namei-to-open_pathname-fix.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
r-o-bind-mounts-elevate-write-count-opened-files-oops-fix.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
iget-introduce-a-function-to-register-iget-failure.patch
iget-use-iget_failed-in-afs.patch
iget-use-iget_failed-in-gfs2.patch
iget-stop-affs-from-using-iget-and-read_inode-try.patch
iget-stop-autofs-from-using-iget-and-read_inode.patch
iget-stop-befs-from-using-iget-and-read_inode-try.patch
iget-stop-bfs-from-using-iget-and-read_inode-try.patch
iget-stop-cifs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try.patch
iget-stop-ext2-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext4-from-using-iget-and-read_inode-try.patch
iget-stop-fat-from-using-iget-and-read_inode-try.patch
iget-stop-freevxfs-from-using-iget-and-read_inode.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-fix.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-fuse-from-using-iget-and-read_inode-try.patch
iget-stop-hfsplus-from-using-iget-and-read_inode.patch
iget-stop-isofs-from-using-read_inode.patch
iget-stop-isofs-from-using-read_inode-fix-2.patch
iget-stop-jffs2-from-using-iget-and-read_inode.patch
iget-stop-jfs-from-using-iget-and-read_inode-try.patch
iget-stop-the-minix-filesystem-from-using-iget-and.patch
iget-stop-procfs-from-using-iget-and-read_inode.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try.patch
iget-stop-romfs-from-using-iget-and-read_inode.patch
iget-stop-the-sysv-filesystem-from-using-iget-and.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try.patch
iget-stop-openpromfs-from-using-iget-and.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hppfs-from-using-iget-and-read_inode.patch
iget-remove-iget-and-the-read_inode-super-op-as.patch
dont-touch-fs_struct-in-drivers.patch
dont-touch-fs_struct-in-usermodehelper.patch
remove-path_release_on_umount.patch
move-struct-path-into-its-own-header.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
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
kill-pt_attached.patch
kill-my_ptrace_child.patch
ptrace_check_attach-remove-unneeded-signal-=-null-check.patch
ext2-remove-unused-ext2_put_inode-prototype.patch
libfs-allow-error-return-from-simple-attributes.patch
libfs-allow-error-return-from-simple-attributes-fix.patch
libfs-make-simple-attributes-interruptible.patch
libfs-rename-simple_attr_close-to-simple_attr_release.patch
udf-fix-coding-style-of-superc.patch
udf-fix-coding-style.patch
udf-convert-byte-order-of-constant-instead-of-variable.patch
udf-remove-udf_i_-macros-and-open-code-them.patch
udf-cache-struct-udf_inode_info.patch
udf-fix-udf_debug-macro.patch
fix-procfs-task-exe-symlink.patch
kill-do_generic_mapping_read.patch
