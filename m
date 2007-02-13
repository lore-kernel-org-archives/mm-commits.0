From: akpm@linux-foundation.org
Subject: + r-o-bind-mounts-gfs-check-nlink-count.patch added to -mm tree
Date: Mon, 12 Feb 2007 21:13:24 -0800
Message-ID: <200702130513.l1D5DOxv022334@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54703 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161052AbXBMFNc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 00:13:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hansendc@us.ibm.com, hch@lst.de, linuxram@us.ibm.com, miklos@szeredi.hu, viro@zeniv.linux.org.uk


The patch titled
     r/o bind mounts: [PATCH] gfs: check nlink count
has been added to the -mm tree.  Its filename is
     r-o-bind-mounts-gfs-check-nlink-count.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: r/o bind mounts: [PATCH] gfs: check nlink count
From: Dave Hansen <hansendc@us.ibm.com>

Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/inode.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/gfs2/inode.c~r-o-bind-mounts-gfs-check-nlink-count fs/gfs2/inode.c
--- a/fs/gfs2/inode.c~r-o-bind-mounts-gfs-check-nlink-count
+++ a/fs/gfs2/inode.c
@@ -169,6 +169,7 @@ static int gfs2_dinode_in(struct gfs2_in
 	 * to do that.
 	 */
 	ip->i_inode.i_nlink = be32_to_cpu(str->di_nlink);
+	check_nlink(&ip->i_inode);
 	di->di_size = be64_to_cpu(str->di_size);
 	i_size_write(&ip->i_inode, di->di_size);
 	di->di_blocks = be64_to_cpu(str->di_blocks);
_

Patches currently in -mm which might be from hansendc@us.ibm.com are

r-o-bind-mounts-filesystem-helpers-for-custom-struct-files.patch
r-o-bind-mounts-add-vfsmount-writer-counts.patch
r-o-bind-mounts-record-when-sb_writer_count-elevated-for-inode.patch
r-o-bind-mounts-elevate-writer-count-for-chown-and-friends.patch
r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-for-link-and-symlink-calls.patch
r-o-bind-mounts-elevate-mount-count-for-extended-attributes.patch
r-o-bind-mounts-mount_is_safe-add-comment.patch
r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime.patch
r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch
r-o-bind-mounts-elevate-write-count-files-are-opened.patch
r-o-bind-mounts-elevate-writer-count-for-do_sys_truncate.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch
r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers.patch
r-o-bind-mounts-do_rmdir-elevate-write-count.patch
r-o-bind-mounts-elevate-writer-count-for-custom-struct_file.patch
r-o-bind-mounts-gfs-check-nlink-count.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
r-o-bind-mounts-kill-open-files-traverse-on-remount-ro.patch
