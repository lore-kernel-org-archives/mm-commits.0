From: akpm@linux-foundation.org
Subject: + vfs-merge-path_is_mountpoint-and-path_is_mountpoint_rcu.patch
 added to -mm tree
Date: Wed, 30 Nov 2016 14:25:32 -0800
Message-ID: <583f51dc.Borizh48ig9fhdhZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35762 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751301AbcK3W0m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2016 17:26:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ikent@redhat.com, ebiederm@xmission.com, osandov@osandov.com, raven@themaw.net, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: vfs: merge path_is_mountpoint() and path_is_mountpoint_rcu()
has been added to the -mm tree.  Its filename is
     vfs-merge-path_is_mountpoint-and-path_is_mountpoint_rcu.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vfs-merge-path_is_mountpoint-and-path_is_mountpoint_rcu.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vfs-merge-path_is_mountpoint-and-path_is_mountpoint_rcu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ian Kent <ikent@redhat.com>
Subject: vfs: merge path_is_mountpoint() and path_is_mountpoint_rcu()

Forgetting that the rcu lock allows nesting I added a superfluous rcu
version of path_is_mountpoint().

Merge it and the rcu version, make the common case (d_mountpoint()
returning true) inline and change the path parameter to a const.

Also move the function definition to include/linux/mount.h as it seems a
more sensible place for it.

Link: http://lkml.kernel.org/r/148029910861.27779.4517883721395202453.stgit@pluto.themaw.net
Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c     |   11 ++--------
 fs/namespace.c        |   41 +++++++++++++---------------------------
 include/linux/fs.h    |    2 -
 include/linux/mount.h |   11 ++++++++++
 4 files changed, 28 insertions(+), 37 deletions(-)

diff -puN fs/autofs4/root.c~vfs-merge-path_is_mountpoint-and-path_is_mountpoint_rcu fs/autofs4/root.c
--- a/fs/autofs4/root.c~vfs-merge-path_is_mountpoint-and-path_is_mountpoint_rcu
+++ a/fs/autofs4/root.c
@@ -437,13 +437,8 @@ static int autofs4_d_manage(struct path
 
 	/* The daemon never waits. */
 	if (autofs4_oz_mode(sbi)) {
-		if (rcu_walk) {
-			if (!path_is_mountpoint_rcu(path))
-				return -EISDIR;
-		} else {
-			if (!path_is_mountpoint(path))
-				return -EISDIR;
-		}
+		if (!path_is_mountpoint(path))
+			return -EISDIR;
 		return 0;
 	}
 
@@ -471,7 +466,7 @@ static int autofs4_d_manage(struct path
 
 		if (ino->flags & AUTOFS_INF_WANT_EXPIRE)
 			return 0;
-		if (path_is_mountpoint_rcu(path))
+		if (path_is_mountpoint(path))
 			return 0;
 		inode = d_inode_rcu(dentry);
 		if (inode && S_ISLNK(inode->i_mode))
diff -puN fs/namespace.c~vfs-merge-path_is_mountpoint-and-path_is_mountpoint_rcu fs/namespace.c
--- a/fs/namespace.c~vfs-merge-path_is_mountpoint-and-path_is_mountpoint_rcu
+++ a/fs/namespace.c
@@ -1159,12 +1159,23 @@ struct vfsmount *mntget(struct vfsmount
 }
 EXPORT_SYMBOL(mntget);
 
-static bool __path_is_mountpoint(struct path *path)
+/* __path_is_mountpoint() - Check if path is a mount in the current
+ *                          namespace.
+ *
+ *  d_mountpoint() can only be used reliably to establish if a dentry is
+ *  not mounted in any namespace and that common case is handled inline.
+ *  d_mountpoint() isn't aware of the possibility there may be multiple
+ *  mounts using a given dentry in a different namespace. This function
+ *  checks if the passed in path is a mountpoint rather than the dentry
+ *  alone.
+ */
+bool __path_is_mountpoint(const struct path *path)
 {
 	struct mount *mount;
 	struct vfsmount *mnt;
 	unsigned seq;
 
+	rcu_read_lock();
 	do {
 		seq = read_seqbegin(&mount_lock);
 		mount = __lookup_mnt(path->mnt, path->dentry);
@@ -1172,35 +1183,11 @@ static bool __path_is_mountpoint(struct
 	} while (mnt &&
 		 !(mnt->mnt_flags & MNT_SYNC_UMOUNT) &&
 		 read_seqretry(&mount_lock, seq));
-
-	return mnt != NULL;
-}
-
-/* Check if path is a mount in current namespace */
-bool path_is_mountpoint(struct path *path)
-{
-	bool res;
-
-	if (!d_mountpoint(path->dentry))
-		return false;
-
-	rcu_read_lock();
-	res = __path_is_mountpoint(path);
 	rcu_read_unlock();
 
-	return res;
-}
-EXPORT_SYMBOL(path_is_mountpoint);
-
-/* Check if path is a mount in current namespace */
-bool path_is_mountpoint_rcu(struct path *path)
-{
-	if (!d_mountpoint(path->dentry))
-		return false;
-
-	return __path_is_mountpoint(path);
+	return mnt != NULL;
 }
-EXPORT_SYMBOL(path_is_mountpoint_rcu);
+EXPORT_SYMBOL(__path_is_mountpoint);
 
 struct vfsmount *mnt_clone_internal(struct path *path)
 {
diff -puN include/linux/fs.h~vfs-merge-path_is_mountpoint-and-path_is_mountpoint_rcu include/linux/fs.h
--- a/include/linux/fs.h~vfs-merge-path_is_mountpoint-and-path_is_mountpoint_rcu
+++ a/include/linux/fs.h
@@ -2134,8 +2134,6 @@ extern int vfs_ustat(dev_t, struct kstat
 extern int freeze_super(struct super_block *super);
 extern int thaw_super(struct super_block *super);
 extern bool our_mnt(struct vfsmount *mnt);
-extern bool path_is_mountpoint(struct path *);
-extern bool path_is_mountpoint_rcu(struct path *);
 
 extern int current_umask(void);
 
diff -puN include/linux/mount.h~vfs-merge-path_is_mountpoint-and-path_is_mountpoint_rcu include/linux/mount.h
--- a/include/linux/mount.h~vfs-merge-path_is_mountpoint-and-path_is_mountpoint_rcu
+++ a/include/linux/mount.h
@@ -15,6 +15,8 @@
 #include <linux/spinlock.h>
 #include <linux/seqlock.h>
 #include <linux/atomic.h>
+#include <linux/path.h>
+#include <linux/dcache.h>
 
 struct super_block;
 struct vfsmount;
@@ -98,4 +100,13 @@ extern dev_t name_to_dev_t(const char *n
 
 extern unsigned int sysctl_mount_max;
 
+extern bool __path_is_mountpoint(const struct path *path);
+static inline bool path_is_mountpoint(const struct path *path)
+{
+	if (!d_mountpoint(path->dentry))
+		return 0;
+
+	return __path_is_mountpoint(path);
+}
+
 #endif /* _LINUX_MOUNT_H */
_

Patches currently in -mm which might be from ikent@redhat.com are

vfs-change-d_manage-to-take-a-struct-path.patch
vfs-add-path_is_mountpoint-helper.patch
vfs-add-path_has_submounts.patch
autofs-change-autofs4_expire_wait-to-take-struct-path.patch
autofs-change-autofs4_wait-to-take-struct-path.patch
autofs-use-path_is_mountpoint-to-fix-unreliable-d_mountpoint-checks.patch
autofs-use-path_has_submounts-to-fix-unreliable-have_submount-checks.patch
vfs-remove-unused-have_submounts-function.patch
vfs-merge-path_is_mountpoint-and-path_is_mountpoint_rcu.patch
autofs-make-struct-path-const-in-autofs4_dir_open.patch
autofs-change-struct-path-to-const-in-autofs4_expire_wait-and-autofs4_wait.patch
vfs-change-struct-path-to-const-in-d_manage.patch
vfs-constify-path-parameter-of-path_has_submounts.patch
autofs-dont-hold-spin-lock-over-direct-mount-expire.patch
vfs-make-may_umount_tree-mount-propogation-aware.patch

