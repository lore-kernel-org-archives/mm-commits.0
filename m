From: akpm@linux-foundation.org
Subject: - clean-up-vmtruncate.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:30:50 -0800
Message-ID: <200802052230.m15MUVHF012079@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52450 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932229AbYBEWnD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:43:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     clean up vmtruncate
has been removed from the -mm tree.  Its filename was
     clean-up-vmtruncate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: clean up vmtruncate
From: Christoph Hellwig <hch@lst.de>

vmtruncate is a twisted maze of gotos, this patch cleans it up to have a
proper if else for the two major cases of extending and truncating truncate
and thus makes it a lot more readable while keeping exactly the same
functinality.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   67 ++++++++++++++++++++++++--------------------------
 1 file changed, 33 insertions(+), 34 deletions(-)

diff -puN mm/memory.c~clean-up-vmtruncate mm/memory.c
--- a/mm/memory.c~clean-up-vmtruncate
+++ a/mm/memory.c
@@ -1909,50 +1909,49 @@ EXPORT_SYMBOL(unmap_mapping_range);
  */
 int vmtruncate(struct inode * inode, loff_t offset)
 {
-	struct address_space *mapping = inode->i_mapping;
-	unsigned long limit;
+	if (inode->i_size < offset) {
+		unsigned long limit;
 
-	if (inode->i_size < offset)
-		goto do_expand;
-	/*
-	 * truncation of in-use swapfiles is disallowed - it would cause
-	 * subsequent swapout to scribble on the now-freed blocks.
-	 */
-	if (IS_SWAPFILE(inode))
-		goto out_busy;
-	i_size_write(inode, offset);
+		limit = current->signal->rlim[RLIMIT_FSIZE].rlim_cur;
+		if (limit != RLIM_INFINITY && offset > limit)
+			goto out_sig;
+		if (offset > inode->i_sb->s_maxbytes)
+			goto out_big;
+		i_size_write(inode, offset);
+	} else {
+		struct address_space *mapping = inode->i_mapping;
 
-	/*
-	 * unmap_mapping_range is called twice, first simply for efficiency
-	 * so that truncate_inode_pages does fewer single-page unmaps. However
-	 * after this first call, and before truncate_inode_pages finishes,
-	 * it is possible for private pages to be COWed, which remain after
-	 * truncate_inode_pages finishes, hence the second unmap_mapping_range
-	 * call must be made for correctness.
-	 */
-	unmap_mapping_range(mapping, offset + PAGE_SIZE - 1, 0, 1);
-	truncate_inode_pages(mapping, offset);
-	unmap_mapping_range(mapping, offset + PAGE_SIZE - 1, 0, 1);
-	goto out_truncate;
-
-do_expand:
-	limit = current->signal->rlim[RLIMIT_FSIZE].rlim_cur;
-	if (limit != RLIM_INFINITY && offset > limit)
-		goto out_sig;
-	if (offset > inode->i_sb->s_maxbytes)
-		goto out_big;
-	i_size_write(inode, offset);
+		/*
+		 * truncation of in-use swapfiles is disallowed - it would
+		 * cause subsequent swapout to scribble on the now-freed
+		 * blocks.
+		 */
+		if (IS_SWAPFILE(inode))
+			return -ETXTBSY;
+		i_size_write(inode, offset);
+
+		/*
+		 * unmap_mapping_range is called twice, first simply for
+		 * efficiency so that truncate_inode_pages does fewer
+		 * single-page unmaps.  However after this first call, and
+		 * before truncate_inode_pages finishes, it is possible for
+		 * private pages to be COWed, which remain after
+		 * truncate_inode_pages finishes, hence the second
+		 * unmap_mapping_range call must be made for correctness.
+		 */
+		unmap_mapping_range(mapping, offset + PAGE_SIZE - 1, 0, 1);
+		truncate_inode_pages(mapping, offset);
+		unmap_mapping_range(mapping, offset + PAGE_SIZE - 1, 0, 1);
+	}
 
-out_truncate:
 	if (inode->i_op && inode->i_op->truncate)
 		inode->i_op->truncate(inode);
 	return 0;
+
 out_sig:
 	send_sig(SIGXFSZ, current, 0);
 out_big:
 	return -EFBIG;
-out_busy:
-	return -ETXTBSY;
 }
 EXPORT_SYMBOL(vmtruncate);
 
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
git-unionfs.patch
vfs-apply-coding-standards-to-fs-ioctlc.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
vfs-factor-out-three-helpers-for-fibmap-fionbio-fioasync-file-ioctls.patch
git-xfs.patch
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
kill-do_generic_mapping_read.patch
drop-linux-ufs_fsh-from-userspace-export-and-relocate-it-to-fs-ufs-ufs_fsh.patch
vfs-create-proc-pid-mountinfo.patch
