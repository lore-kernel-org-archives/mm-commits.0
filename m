From: akpm@linux-foundation.org
Subject: + r-o-bind-mounts-make-access-use-new-r-o-helper.patch added to -mm tree
Date: Fri, 15 Feb 2008 14:49:21 -0800
Message-ID: <200802152249.m1FMnLp4028195@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58648 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935090AbYBOW6R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 17:58:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haveblue@us.ibm.com, akpm@linux-foundation.org, hch@infradead.org, viro@ZenIV.linux.org.uk


The patch titled
     r/o bind mounts: make access() use new r/o helper
has been added to the -mm tree.  Its filename is
     r-o-bind-mounts-make-access-use-new-r-o-helper.patch

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
Subject: r/o bind mounts: make access() use new r/o helper
From: Dave Hansen <haveblue@us.ibm.com>

It is OK to let access() go without using a mnt_want/drop_write() pair because
it doesn't actually do writes to the filesystem, and it is inherently racy
anyway.  This is a rare case when it is OK to use __mnt_is_readonly()
directly.

Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/open.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN fs/open.c~r-o-bind-mounts-make-access-use-new-r-o-helper fs/open.c
--- a/fs/open.c~r-o-bind-mounts-make-access-use-new-r-o-helper
+++ a/fs/open.c
@@ -459,8 +459,17 @@ asmlinkage long sys_faccessat(int dfd, c
 	if(res || !(mode & S_IWOTH) ||
 	   special_file(nd.path.dentry->d_inode->i_mode))
 		goto out_path_release;
-
-	if(IS_RDONLY(nd.path.dentry->d_inode))
+	/*
+	 * This is a rare case where using __mnt_is_readonly()
+	 * is OK without a mnt_want/drop_write() pair.  Since
+	 * no actual write to the fs is performed here, we do
+	 * not need to telegraph to that to anyone.
+	 *
+	 * By doing this, we accept that this access is
+	 * inherently racy and know that the fs may change
+	 * state before we even see this result.
+	 */
+	if (__mnt_is_readonly(nd.path.mnt))
 		res = -EROFS;
 
 out_path_release:
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

enable-hotplug-memory-remove-for-ppc64.patch
reiserfs-eliminate-private-use-of-struct-file-in-xattr.patch
hppfs-pass-vfsmount-to-dentry_open.patch
check-for-null-vfsmount-in-dentry_open.patch
fix-up-new-filp-allocators.patch
do-namei_flags-calculation-inside-open_namei.patch
merge-open_namei-and-do_filp_open.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-create-helper-to-drop-file-write-access.patch
r-o-bind-mounts-drop-write-during-emergency-remount.patch
r-o-bind-mounts-elevate-write-count-for-vfs_rmdir.patch
r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir.patch
r-o-bind-mounts-elevate-mnt_writers-for-unlink-callers.patch
r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers.patch
r-o-bind-mounts-elevate-write-count-for-ncp_ioctl.patch
r-o-bind-mounts-write-counts-for-time-functions.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-write-count-for-file_update_time.patch
r-o-bind-mounts-write-counts-for-link-symlink.patch
r-o-bind-mounts-elevate-write-count-for-ioctls.patch
r-o-bind-mounts-elevate-write-count-for-opens.patch
r-o-bind-mounts-get-write-access-for-vfs_rename-callers.patch
r-o-bind-mounts-elevate-write-count-for-chmod-chown-callers.patch
r-o-bind-mounts-write-counts-for-truncate.patch
r-o-bind-mounts-elevate-count-for-xfs-timestamp-updates.patch
r-o-bind-mounts-make-access-use-new-r-o-helper.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly.patch
r-o-bind-mounts-get-callers-of-vfs_mknod-create.patch
r-o-bind-mounts-track-numbers-of-writers-to-mounts.patch
r-o-bind-mounts-honor-mount-writer-counts-at-remount.patch
r-o-bind-mounts-debugging-for-missed-calls.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
