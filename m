From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-mount_is_safe-add-comment.patch removed from -mm tree
Date: Wed, 14 Feb 2007 10:52:34 -0800
Message-ID: <200702141852.l1EIqYqO005728@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39251 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932462AbXBNSxJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 13:53:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hansendc@us.ibm.com, haveblue@us.ibm.com, hch@lst.de, linuxram@us.ibm.com, miklos@szeredi.hu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: mount_is_safe(): add comment
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-mount_is_safe-add-comment.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: r/o bind mounts: mount_is_safe(): add comment
From: Dave Hansen <hansendc@us.ibm.com>

This area of code is currently #ifdef'd out, so add a comment for the time
when it is actually used.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/namespace.c~r-o-bind-mounts-mount_is_safe-add-comment fs/namespace.c
--- a/fs/namespace.c~r-o-bind-mounts-mount_is_safe-add-comment
+++ a/fs/namespace.c
@@ -729,6 +729,10 @@ static int mount_is_safe(struct nameidat
 		if (current->uid != nd->dentry->d_inode->i_uid)
 			return -EPERM;
 	}
+	/*
+	 * We will eventually check for the mnt->writer_count here,
+	 * but since the code is not used now, skip it - Dave Hansen
+	 */
 	if (vfs_permission(nd, MAY_WRITE))
 		return -EPERM;
 	return 0;
_

Patches currently in -mm which might be from hansendc@us.ibm.com are

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
