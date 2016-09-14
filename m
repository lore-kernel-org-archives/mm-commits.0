From: akpm@linux-foundation.org
Subject: + fs-make-is_local_mountpoint-usable-by-others.patch added to -mm tree
Date: Wed, 14 Sep 2016 15:38:37 -0700
Message-ID: <57d9d16d.G5LTmaUudGBiqNSz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43516 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756110AbcINWij (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Sep 2016 18:38:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, ebiederm@xmission.com, osandov@osandov.com, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: vfs: make is_local_mountpoint() usable by others
has been added to the -mm tree.  Its filename is
     fs-make-is_local_mountpoint-usable-by-others.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-make-is_local_mountpoint-usable-by-others.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-make-is_local_mountpoint-usable-by-others.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ian Kent <raven@themaw.net>
Subject: vfs: make is_local_mountpoint() usable by others

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

autofs-use-dentry-flags-to-block-walks-during-expire.patch
autofs-fix-autofs4_fill_super-error-exit-handling.patch
autofs-remove-ino-free-in-autofs4_dir_symlink.patch
autofs-fix-dev-ioctl-number-range-check.patch
autofs-add-autofs_dev_ioctl_version-for-autofs_dev_ioctl_version_cmd.patch
autofs4-move-linux-auto_dev-ioctlh-to-uapi-linux.patch
fs-make-is_local_mountpoint-usable-by-others.patch
fs-add-have_local_submounts.patch
autofs-make-mountpoint-checks-namespace-aware.patch
fs-remove-unused-have_submounts-function.patch

