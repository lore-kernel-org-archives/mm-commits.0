From: akpm@linux-foundation.org
Subject: - sysfs-dont-call-notify_change.patch removed from -mm tree
Date: Sat, 31 May 2008 00:42:28 -0700
Message-ID: <200805310742.m4V7gSwq000913@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45051 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751220AbYEaHnP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 31 May 2008 03:43:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, gregkh@suse.de, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     sysfs: dont call notify_change
has been removed from the -mm tree.  Its filename was
     sysfs-dont-call-notify_change.patch

This patch was dropped because it's more controversial than was first thought, and it was sent off-list

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysfs: dont call notify_change
From: Miklos Szeredi <mszeredi@suse.cz>

sysfs_chmod_file() calls notify_change() to change the permission bits
on a sysfs file.  Replace with explicit call to sysfs_setattr() and
fsnotify_change().

This is equivalent, except that security_inode_setattr() is not
called.  This function is called by drivers, so the security checks do
not make any sense.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/file.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/sysfs/file.c~sysfs-dont-call-notify_change fs/sysfs/file.c
--- a/fs/sysfs/file.c~sysfs-dont-call-notify_change
+++ a/fs/sysfs/file.c
@@ -14,6 +14,7 @@
 #include <linux/kobject.h>
 #include <linux/kallsyms.h>
 #include <linux/slab.h>
+#include <linux/fsnotify.h>
 #include <linux/namei.h>
 #include <linux/poll.h>
 #include <linux/list.h>
@@ -598,9 +599,11 @@ int sysfs_chmod_file(struct kobject *kob
 
 	newattrs.ia_mode = (mode & S_IALLUGO) | (inode->i_mode & ~S_IALLUGO);
 	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
-	rc = notify_change(victim, &newattrs);
+	newattrs.ia_ctime = current_fs_time(inode->i_sb);
+	rc = sysfs_setattr(victim, &newattrs);
 
 	if (rc == 0) {
+		fsnotify_change(victim, newattrs.ia_valid);
 		mutex_lock(&sysfs_mutex);
 		victim_sd->s_mode = newattrs.ia_mode;
 		mutex_unlock(&sysfs_mutex);
_

Patches currently in -mm which might be from mszeredi@suse.cz are

sysfs-dont-call-notify_change.patch
gfs2-dont-call-permission.patch
vfs-immutable-inode-checking-cleanup.patch
vfs-truncate-dont-check-immutable-twice.patch
vfs-create-file_truncate-helper.patch
vfs-utimes-immutable-fix.patch
vfs-utimes-cleanup.patch
vfs-dcache-cleanups.patch
vfs-fix-sys_getcwd-for-detached-mounts.patch
git-unprivileged-mounts.patch
hpfs-dont-call-notify_change.patch
hpfs-dont-call-permission.patch
hppfs-remove-hppfs_permission.patch
fat-dont-call-notify_change.patch
lockd-dont-return-eagain-for-a-permanent-error.patch
locks-add-special-return-value-for-asynchronous-locks.patch
locks-cleanup-code-duplication.patch
locks-allow-lock-to-return-file_lock_deferred.patch
fuse-prepare-lookup-for-nfs-export.patch
fuse-add-export-operations.patch
fuse-add-fuse_lookup_name-helper.patch
fuse-nfs-export-special-lookups.patch
fuse-lockd-support.patch

