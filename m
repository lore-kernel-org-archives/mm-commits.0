From: akpm@linux-foundation.org
Subject: + vfs-add-path_is_mountpoint-helper.patch added to -mm tree
Date: Wed, 19 Oct 2016 12:40:44 -0700
Message-ID: <5807cc3c.nq5pvVSc6knm+3AP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60700 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S943755AbcJSTkp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Oct 2016 15:40:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ikent@redhat.com, ebiederm@xmission.com, osandov@osandov.com, raven@themaw.net, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: vfs: add path_is_mountpoint() helper
has been added to the -mm tree.  Its filename is
     vfs-add-path_is_mountpoint-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vfs-add-path_is_mountpoint-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vfs-add-path_is_mountpoint-helper.patch

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
Subject: vfs: add path_is_mountpoint() helper

d_mountpoint() can only be used reliably to establish if a dentry is
not mounted in any namespace. It isn't aware of the possibility there
may be multiple mounts using a given dentry that may be in a different
namespace.

Add helper functions, path_is_mountpoint() and an rcu version , that
checks if a struct path is a mountpoint for this case.

Link: http://lkml.kernel.org/r/20161011053358.27645.9729.stgit@pluto.themaw.net
Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c     |   43 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h |    2 ++
 2 files changed, 45 insertions(+)

diff -puN fs/namespace.c~vfs-add-path_is_mountpoint-helper fs/namespace.c
--- a/fs/namespace.c~vfs-add-path_is_mountpoint-helper
+++ a/fs/namespace.c
@@ -1159,6 +1159,49 @@ struct vfsmount *mntget(struct vfsmount
 }
 EXPORT_SYMBOL(mntget);
 
+static bool __path_is_mountpoint(struct path *path)
+{
+	struct mount *mount;
+	struct vfsmount *mnt;
+	unsigned seq;
+
+	do {
+		seq = read_seqbegin(&mount_lock);
+		mount = __lookup_mnt(path->mnt, path->dentry);
+		mnt = mount ? &mount->mnt : NULL;
+	} while (mnt &&
+		 !(mnt->mnt_flags & MNT_SYNC_UMOUNT) &&
+		 read_seqretry(&mount_lock, seq));
+
+	return mnt != NULL;
+}
+
+/* Check if path is a mount in current namespace */
+bool path_is_mountpoint(struct path *path)
+{
+	bool res;
+
+	if (!d_mountpoint(path->dentry))
+		return 0;
+
+	rcu_read_lock();
+	res = __path_is_mountpoint(path);
+	rcu_read_unlock();
+
+	return res;
+}
+EXPORT_SYMBOL(path_is_mountpoint);
+
+/* Check if path is a mount in current namespace */
+bool path_is_mountpoint_rcu(struct path *path)
+{
+	if (!d_mountpoint(path->dentry))
+		return 0;
+
+	return __path_is_mountpoint(path);
+}
+EXPORT_SYMBOL(path_is_mountpoint_rcu);
+
 struct vfsmount *mnt_clone_internal(struct path *path)
 {
 	struct mount *p;
diff -puN include/linux/fs.h~vfs-add-path_is_mountpoint-helper include/linux/fs.h
--- a/include/linux/fs.h~vfs-add-path_is_mountpoint-helper
+++ a/include/linux/fs.h
@@ -2134,6 +2134,8 @@ extern int vfs_ustat(dev_t, struct kstat
 extern int freeze_super(struct super_block *super);
 extern int thaw_super(struct super_block *super);
 extern bool our_mnt(struct vfsmount *mnt);
+extern bool path_is_mountpoint(struct path *);
+extern bool path_is_mountpoint_rcu(struct path *);
 
 extern int current_umask(void);
 
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

