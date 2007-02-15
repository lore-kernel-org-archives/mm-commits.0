From: akpm@linux-foundation.org
Subject: + r-o-bind-mounts-remove-is_rdonly-from-permission.patch added to -mm tree
Date: Wed, 14 Feb 2007 21:03:04 -0800
Message-ID: <200702150503.l1F534lu020397@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34933 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbXBOFGZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 00:06:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hansendc@us.ibm.com, haveblue@us.ibm.com, hch@lst.de, miklos@szeredi.hu, viro@zeniv.linux.org.uk


The patch titled
     r/o bind mounts: remove IS_RDONLY() from permission()
has been added to the -mm tree.  Its filename is
     r-o-bind-mounts-remove-is_rdonly-from-permission.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: r/o bind mounts: remove IS_RDONLY() from permission()
From: Dave Hansen <hansendc@us.ibm.com>

All callers of permission() should be updated now to use the
mnt_want/drop_write() functions.  It is now safe to remove this check.

We'll put a BUG_ON() in here for now just in case some user manages to get in
here by code that gets added in the future but forgets its
mnt_want/drop_write() pair.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN fs/namei.c~r-o-bind-mounts-remove-is_rdonly-from-permission fs/namei.c
--- a/fs/namei.c~r-o-bind-mounts-remove-is_rdonly-from-permission
+++ a/fs/namei.c
@@ -231,13 +231,12 @@ int permission(struct inode *inode, int 
 	int retval, submask;
 
 	if (mask & MAY_WRITE) {
-
 		/*
-		 * Nobody gets write access to a read-only fs.
+		 * Nobody should have been able to get here with
+		 * a r/o filesystem.
 		 */
-		if (IS_RDONLY(inode) &&
-		    (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode)))
-			return -EROFS;
+		BUG_ON(IS_RDONLY(inode) &&
+                       (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode)));
 
 		/*
 		 * Nobody gets write access to an immutable file.
_

Patches currently in -mm which might be from hansendc@us.ibm.com are

r-o-bind-mounts-document-nlink-function.patch
r-o-bind-mounts-filesystem-helpers-for-custom-struct-files.patch
r-o-bind-mounts-r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-ext3-remove-extra-is_rdonly-check.patch
r-o-bind-mounts-ext4-remove-extra-is_rdonly-check.patch
r-o-bind-mounts-r-o-bind-mounts-elevate-write-count-for-some-ioctls.patch
r-o-bind-mounts-elevate-writer-count-for-chown-and-friends.patch
r-o-bind-mounts-make-access-use-mnt-check.patch
r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-for-link-and-symlink-calls.patch
r-o-bind-mounts-elevate-mount-count-for-extended-attributes.patch
r-o-bind-mounts-elevate-write-count-for-file_update_time.patch
r-o-bind-mounts-mount_is_safe-add-comment.patch
r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime.patch
r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch
r-o-bind-mounts-elevate-write-count-files-are-opened.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-sb.patch
r-o-bind-mounts-elevate-writer-count-for-do_sys_truncate.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch
r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers.patch
r-o-bind-mounts-do_rmdir-elevate-write-count.patch
r-o-bind-mounts-elevate-writer-count-for-custom-struct_file.patch
r-o-bind-mounts-remove-is_rdonly-from-permission.patch
r-o-bind-mounts-reiser4-remove-is_rdonly-checks.patch
