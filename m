From: akpm@linux-foundation.org
Subject: + clean-up-vmtruncate.patch added to -mm tree
Date: Tue, 23 Oct 2007 13:50:07 -0700
Message-ID: <200710232050.l9NKo7xO005761@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49288 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751564AbXJWUur (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Oct 2007 16:50:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de


The patch titled
     clean up vmtruncate
has been added to the -mm tree.  Its filename is
     clean-up-vmtruncate.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1906,50 +1906,49 @@ EXPORT_SYMBOL(unmap_mapping_range);
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
git-xfs.patch
clean-up-vmtruncate.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes-touch-command-causes-oops.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
dont-touch-fs_struct-in-drivers.patch
dont-touch-fs_struct-in-usermodehelper.patch
remove-path_release_on_umount.patch
move-struct-path-into-its-own-header.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
introduce-path_put.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
introduce-path_get.patch
use-struct-path-in-fs_struct.patch
make-set_fs_rootpwd-take-a-struct-path.patch
make-__d_path-to-take-a-struct-path-argument.patch
use-struct-path-argument-in-proc_get_link.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs.patch
introduce-path_put-unionfs.patch
introduce-path_get-unionfs.patch
