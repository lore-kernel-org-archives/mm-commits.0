From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-document-nlink-function.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:32:40 -0800
Message-ID: <200702150832.l1F8WeJV024567@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39349 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965254AbXBOIcu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:32:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hansendc@us.ibm.com, haveblue@us.ibm.com, hch@lst.de, miklos@szeredi.hu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: document nlink function
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-document-nlink-function.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: r/o bind mounts: document nlink function
From: Dave Hansen <hansendc@us.ibm.com>

The following series implements about 95% of the work needed for read-only
bind mounts.  

It eliminates most of the users of IS_RDONLY() except for unionfs.  Unionfs is
difficult because it does its detection of r/o branches soley with inodes and
dentries, without the mount being around.  I'm leaving it out for know in the
hope that the authors have some better ideas on how to fix it properly.

Note that there are a few stragglers left using IS_RDONLY() in reiser4 and in
some other low-level filesystem code.  The reiser4 asserts should be just fine
left the way they are.  The ntfs usage appears to be internal, and not related
to user activity.

I believe the remaining XFS user is covered by the vfs's permission(), but I'm
not fully sure.  I'd appreciate any look from any XFS experts.


Why do we need r/o bind mounts?

This feature allows a read-only view into a read-write filesystem.  In the
process of doing that, it also provides infrastructure for keeping track of
the number of writers to any given mount.

This has a number of uses.  It allows chroots to have parts of filesystems
writable.  It will be useful for containers in the future because users may
have root inside a container, but should not be allowed to write to
somefilesystems.  This also replaces patches that vserver has had out of the
tree for several years.

It allows security enhancement by making sure that parts of your filesystem
read-only (such as when you don't trust your FTP server), when you don't want
to have entire new filesystems mounted, or when you want atime selectively
updated.  I've been using the following script to test that the feature is
working as desired.  It takes a directory and makes a regular bind and a r/o
bind mount of it.  It then performs some normal filesystem operations on the
three directories, including ones that are expected to fail, like creating a
file on the r/o mount.



This patch:

These should have been documented from the beginning.  Fix it.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff -puN include/linux/fs.h~r-o-bind-mounts-document-nlink-function include/linux/fs.h
--- a/include/linux/fs.h~r-o-bind-mounts-document-nlink-function
+++ a/include/linux/fs.h
@@ -1198,6 +1198,14 @@ static inline void mark_inode_dirty_sync
 	__mark_inode_dirty(inode, I_DIRTY_SYNC);
 }
 
+/**
+ * inc_nlink - directly increment an inode's link count
+ * @inode: inode
+ *
+ * This is a low-level filesystem helper to replace any
+ * direct filesystem manipulation of i_nlink.  Currently,
+ * it is only here for parity with dec_nlink().
+ */
 static inline void inc_nlink(struct inode *inode)
 {
 	inode->i_nlink++;
@@ -1209,11 +1217,30 @@ static inline void inode_inc_link_count(
 	mark_inode_dirty(inode);
 }
 
+/**
+ * drop_nlink - directly drop an inode's link count
+ * @inode: inode
+ *
+ * This is a low-level filesystem helper to replace any
+ * direct filesystem manipulation of i_nlink.  In cases
+ * where we are attempting to track writes to the
+ * filesystem, a decrement to zero means an imminent
+ * write when the file is truncated and actually unlinked
+ * on the filesystem.
+ */
 static inline void drop_nlink(struct inode *inode)
 {
 	inode->i_nlink--;
 }
 
+/**
+ * clear_nlink - directly zero an inode's link count
+ * @inode: inode
+ *
+ * This is a low-level filesystem helper to replace any
+ * direct filesystem manipulation of i_nlink.  See
+ * drop_nlink() for why we care about i_nlink hitting zero.
+ */
 static inline void clear_nlink(struct inode *inode)
 {
 	inode->i_nlink = 0;
_

Patches currently in -mm which might be from hansendc@us.ibm.com are

r-o-bind-mounts-document-nlink-function.patch
r-o-bind-mounts-filesystem-helpers-for-custom-struct-files.patch
r-o-bind-mounts-fix-mounth-vs-fsh-include-quagmire.patch
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
