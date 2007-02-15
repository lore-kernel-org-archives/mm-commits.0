From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-ext3-remove-extra-is_rdonly-check.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:32:57 -0800
Message-ID: <200702150832.l1F8Wv1w024588@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39375 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965263AbXBOIdF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:33:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hansendc@us.ibm.com, haveblue@us.ibm.com, hch@lst.de, miklos@szeredi.hu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: ext3: remove extra IS_RDONLY() check
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-ext3-remove-extra-is_rdonly-check.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: r/o bind mounts: ext3: remove extra IS_RDONLY() check
From: Dave Hansen <hansendc@us.ibm.com>

ext3_change_inode_journal_flag() is only called from one location:
ext3_ioctl(EXT3_IOC_SETFLAGS).  That ioctl case already has a IS_RDONLY() call
in it so this one is superfluous.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ext3/inode.c~r-o-bind-mounts-ext3-remove-extra-is_rdonly-check fs/ext3/inode.c
--- a/fs/ext3/inode.c~r-o-bind-mounts-ext3-remove-extra-is_rdonly-check
+++ a/fs/ext3/inode.c
@@ -3244,7 +3244,7 @@ int ext3_change_inode_journal_flag(struc
 	 */
 
 	journal = EXT3_JOURNAL(inode);
-	if (is_journal_aborted(journal) || IS_RDONLY(inode))
+	if (is_journal_aborted(journal))
 		return -EROFS;
 
 	journal_lock_updates(journal);
_

Patches currently in -mm which might be from hansendc@us.ibm.com are

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
