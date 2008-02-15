From: akpm@linux-foundation.org
Subject: + check-for-null-vfsmount-in-dentry_open.patch added to -mm tree
Date: Fri, 15 Feb 2008 14:48:37 -0800
Message-ID: <200802152248.m1FMmc6a028118@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45195 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765677AbYBOWs6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 17:48:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haveblue@us.ibm.com, hch@lst.de, viro@ZenIV.linux.org.uk


The patch titled
     check for null vfsmount in dentry_open()
has been added to the -mm tree.  Its filename is
     check-for-null-vfsmount-in-dentry_open.patch

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
Subject: check for null vfsmount in dentry_open()
From: Dave Hansen <haveblue@us.ibm.com>

Make sure no-one calls dentry_open with a NULL vfsmount argument and crap out
with a stacktrace otherwise.  A NULL file->f_vfsmnt has always been
problematic, but with the per-mount r/o tracking we can't accept anymore at
all.

Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/open.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN fs/open.c~check-for-null-vfsmount-in-dentry_open fs/open.c
--- a/fs/open.c~check-for-null-vfsmount-in-dentry_open
+++ a/fs/open.c
@@ -903,6 +903,18 @@ struct file *dentry_open(struct dentry *
 	int error;
 	struct file *f;
 
+	/*
+	 * We must always pass in a valid mount pointer.   Historically
+	 * callers got away with not passing it, but we must enforce this at
+	 * the earliest possible point now to avoid strange problems deep in the
+	 * filesystem stack.
+	 */
+	if (!mnt) {
+		printk(KERN_WARNING "%s called with NULL vfsmount\n", __func__);
+		dump_stack();
+		return ERR_PTR(-EINVAL);
+	}
+
 	error = -ENFILE;
 	f = get_empty_filp();
 	if (f == NULL) {
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
