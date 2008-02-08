From: akpm@linux-foundation.org
Subject: - libfs-make-simple-attributes-interruptible.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:16:54 -0800
Message-ID: <200802082016.m18KGZtL010744@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58173 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758198AbYBHVD1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:03:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, arnd@arndb.de, greg@kroah.com, stefano.brivio@polimi.it, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     libfs: make simple attributes interruptible
has been removed from the -mm tree.  Its filename was
     libfs-make-simple-attributes-interruptible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: libfs: make simple attributes interruptible
From: Christoph Hellwig <hch@lst.de>

Use mutex_lock_interruptible in simple_attr_read/write.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: <stefano.brivio@polimi.it>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <greg@kroah.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/libfs.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN fs/libfs.c~libfs-make-simple-attributes-interruptible fs/libfs.c
--- a/fs/libfs.c~libfs-make-simple-attributes-interruptible
+++ a/fs/libfs.c
@@ -634,7 +634,10 @@ ssize_t simple_attr_read(struct file *fi
 	if (!attr->get)
 		return -EACCES;
 
-	mutex_lock(&attr->mutex);
+	ret = mutex_lock_interruptible(&attr->mutex);
+	if (ret)
+		return ret;
+
 	if (*ppos) {		/* continued read */
 		size = strlen(attr->get_buf);
 	} else {		/* first read */
@@ -666,7 +669,10 @@ ssize_t simple_attr_write(struct file *f
 	if (!attr->set)
 		return -EACCES;
 
-	mutex_lock(&attr->mutex);
+	ret = mutex_lock_interruptible(&attr->mutex);
+	if (ret)
+		return ret;
+
 	ret = -EFAULT;
 	size = min(sizeof(attr->set_buf) - 1, len);
 	if (copy_from_user(attr->set_buf, buf, size))
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
git-unionfs.patch
git-xfs.patch
uml-update-defconfig.patch
reiserfs-eliminate-private-use-of-struct-file-in-xattr.patch
rename-open_namei-to-open_pathname.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-opened-files.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
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
vfs-create-proc-pid-mountinfo.patch
reiserfs-use-open_bdev_excl.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
