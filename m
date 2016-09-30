From: akpm@linux-foundation.org
Subject: [to-be-updated]
 fs-make-is_local_mountpoint-usable-by-others.patch removed from -mm tree
Date: Fri, 30 Sep 2016 11:38:43 -0700
Message-ID: <57eeb133.HaeC5gJL2wNvtpNM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41113 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932348AbcI3Sio (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 30 Sep 2016 14:38:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, ebiederm@xmission.com, osandov@osandov.com, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: vfs: make is_local_mountpoint() usable by others
has been removed from the -mm tree.  Its filename was
     fs-make-is_local_mountpoint-usable-by-others.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Ian Kent <raven@themaw.net>
Subject: vfs: make is_local_mountpoint() usable by others

Patch series "fs - make is_local_mountpoint() usable by others":

For quite a while now, and not that frequently but consistently, I've been
getting reports of people using autofs getting ELOOP errors and not being
able to mount automounts.

This has been due to the cloning of autofs file systems (that have active
automounts at the time of the clone) by other systems.

An unshare, as one example, can easily result in the cloning of an autofs
file system that has active mounts which shows this problem.

Once an active mount that has been cloned is expired in the namespace that
performed the unshare it can't be (auto)mounted again in the the
originating namespace because the mounted check in the autofs module will
think it is already mounted.

Omar said:

: Yup, at Facebook we've been hitting this issue for years.  Our container
: setup doesn't clean up the base system's mounts after the
: unshare(CLONE_NEWNS) and before the chroot(), so we very frequently see
: the base system's autofs mounts get broken with ELOOP.  The solution there
: might be to fix our container setup, but I think it's still a kernel bug,
: as it breaks the isolation between namespaces.


This patch (of 4):

is_local_mountpoint() will be needed for autofs to check if a dentry is a
mountpoint in the current namespace.

Link: http://lkml.kernel.org/r/20160914061434.24714.490.stgit@pluto.themaw.net
Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mount.h            |    9 ---------
 fs/namespace.c        |    1 +
 include/linux/mount.h |    9 +++++++++
 3 files changed, 10 insertions(+), 9 deletions(-)

diff -puN fs/mount.h~fs-make-is_local_mountpoint-usable-by-others fs/mount.h
--- a/fs/mount.h~fs-make-is_local_mountpoint-usable-by-others
+++ a/fs/mount.h
@@ -127,12 +127,3 @@ struct proc_mounts {
 };
 
 extern const struct seq_operations mounts_op;
-
-extern bool __is_local_mountpoint(struct dentry *dentry);
-static inline bool is_local_mountpoint(struct dentry *dentry)
-{
-	if (!d_mountpoint(dentry))
-		return false;
-
-	return __is_local_mountpoint(dentry);
-}
diff -puN fs/namespace.c~fs-make-is_local_mountpoint-usable-by-others fs/namespace.c
--- a/fs/namespace.c~fs-make-is_local_mountpoint-usable-by-others
+++ a/fs/namespace.c
@@ -725,6 +725,7 @@ bool __is_local_mountpoint(struct dentry
 out:
 	return is_covered;
 }
+EXPORT_SYMBOL(__is_local_mountpoint);
 
 static struct mountpoint *lookup_mountpoint(struct dentry *dentry)
 {
diff -puN include/linux/mount.h~fs-make-is_local_mountpoint-usable-by-others include/linux/mount.h
--- a/include/linux/mount.h~fs-make-is_local_mountpoint-usable-by-others
+++ a/include/linux/mount.h
@@ -15,6 +15,7 @@
 #include <linux/spinlock.h>
 #include <linux/seqlock.h>
 #include <linux/atomic.h>
+#include <linux/dcache.h>
 
 struct super_block;
 struct vfsmount;
@@ -96,4 +97,12 @@ extern void mark_mounts_for_expiry(struc
 
 extern dev_t name_to_dev_t(const char *name);
 
+extern bool __is_local_mountpoint(struct dentry *dentry);
+static inline bool is_local_mountpoint(struct dentry *dentry)
+{
+	if (!d_mountpoint(dentry))
+		return false;
+
+	return __is_local_mountpoint(dentry);
+}
 #endif /* _LINUX_MOUNT_H */
_

Patches currently in -mm which might be from raven@themaw.net are

autofs-fix-autofs4_fill_super-error-exit-handling.patch
autofs-remove-ino-free-in-autofs4_dir_symlink.patch
autofs-fix-dev-ioctl-number-range-check.patch
autofs-add-autofs_dev_ioctl_version-for-autofs_dev_ioctl_version_cmd.patch
autofs4-move-linux-auto_dev-ioctlh-to-uapi-linux.patch
fs-add-have_local_submounts.patch
autofs-make-mountpoint-checks-namespace-aware.patch
fs-remove-unused-have_submounts-function.patch

