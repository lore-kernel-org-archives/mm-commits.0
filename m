From: akpm@linux-foundation.org
Subject: + vfs-change-struct-path-to-const-in-d_manage.patch added to -mm
 tree
Date: Wed, 30 Nov 2016 14:25:39 -0800
Message-ID: <583f51e3.tOeRPixRCWwimSmw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35918 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754676AbcK3W0m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2016 17:26:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ikent@redhat.com, ebiederm@xmission.com, osandov@osandov.com, raven@themaw.net, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: vfs: change struct path to const in d_manage()
has been added to the -mm tree.  Its filename is
     vfs-change-struct-path-to-const-in-d_manage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vfs-change-struct-path-to-const-in-d_manage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vfs-change-struct-path-to-const-in-d_manage.patch

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
Subject: vfs: change struct path to const in d_manage()

The ->d_manage() function is meant to be used to check if an
automount is in progress and to block if needed before the
mount is followed.

It shouldn't need to modify the passed struct path.

Make that usage explicit by changing ->d_manage() path parameter
to a const.

Link: http://lkml.kernel.org/r/148029912424.27779.1122354411609730492.stgit@pluto.themaw.net
Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/Locking |    2 +-
 Documentation/filesystems/vfs.txt |    2 +-
 fs/autofs4/root.c                 |    4 ++--
 fs/namei.c                        |    2 +-
 include/linux/dcache.h            |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff -puN Documentation/filesystems/Locking~vfs-change-struct-path-to-const-in-d_manage Documentation/filesystems/Locking
--- a/Documentation/filesystems/Locking~vfs-change-struct-path-to-const-in-d_manage
+++ a/Documentation/filesystems/Locking
@@ -20,7 +20,7 @@ prototypes:
 	void (*d_iput)(struct dentry *, struct inode *);
 	char *(*d_dname)((struct dentry *dentry, char *buffer, int buflen);
 	struct vfsmount *(*d_automount)(struct path *path);
-	int (*d_manage)(struct path *, bool);
+	int (*d_manage)(const struct path *, bool);
 	struct dentry *(*d_real)(struct dentry *, const struct inode *,
 				 unsigned int);
 
diff -puN Documentation/filesystems/vfs.txt~vfs-change-struct-path-to-const-in-d_manage Documentation/filesystems/vfs.txt
--- a/Documentation/filesystems/vfs.txt~vfs-change-struct-path-to-const-in-d_manage
+++ a/Documentation/filesystems/vfs.txt
@@ -948,7 +948,7 @@ struct dentry_operations {
 	void (*d_iput)(struct dentry *, struct inode *);
 	char *(*d_dname)(struct dentry *, char *, int);
 	struct vfsmount *(*d_automount)(struct path *);
-	int (*d_manage)(struct path *, bool);
+	int (*d_manage)(const struct path *, bool);
 	struct dentry *(*d_real)(struct dentry *, const struct inode *,
 				 unsigned int);
 };
diff -puN fs/autofs4/root.c~vfs-change-struct-path-to-const-in-d_manage fs/autofs4/root.c
--- a/fs/autofs4/root.c~vfs-change-struct-path-to-const-in-d_manage
+++ a/fs/autofs4/root.c
@@ -32,7 +32,7 @@ static int autofs4_dir_open(struct inode
 static struct dentry *autofs4_lookup(struct inode *,
 				     struct dentry *, unsigned int);
 static struct vfsmount *autofs4_d_automount(struct path *);
-static int autofs4_d_manage(struct path *, bool);
+static int autofs4_d_manage(const struct path *, bool);
 static void autofs4_dentry_release(struct dentry *);
 
 const struct file_operations autofs4_root_operations = {
@@ -426,7 +426,7 @@ done:
 	return NULL;
 }
 
-static int autofs4_d_manage(struct path *path, bool rcu_walk)
+static int autofs4_d_manage(const struct path *path, bool rcu_walk)
 {
 	struct dentry *dentry = path->dentry;
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
diff -puN fs/namei.c~vfs-change-struct-path-to-const-in-d_manage fs/namei.c
--- a/fs/namei.c~vfs-change-struct-path-to-const-in-d_manage
+++ a/fs/namei.c
@@ -1263,7 +1263,7 @@ int follow_down_one(struct path *path)
 }
 EXPORT_SYMBOL(follow_down_one);
 
-static inline int managed_dentry_rcu(struct path *path)
+static inline int managed_dentry_rcu(const struct path *path)
 {
 	return (path->dentry->d_flags & DCACHE_MANAGE_TRANSIT) ?
 		path->dentry->d_op->d_manage(path, true) : 0;
diff -puN include/linux/dcache.h~vfs-change-struct-path-to-const-in-d_manage include/linux/dcache.h
--- a/include/linux/dcache.h~vfs-change-struct-path-to-const-in-d_manage
+++ a/include/linux/dcache.h
@@ -139,7 +139,7 @@ struct dentry_operations {
 	void (*d_iput)(struct dentry *, struct inode *);
 	char *(*d_dname)(struct dentry *, char *, int);
 	struct vfsmount *(*d_automount)(struct path *);
-	int (*d_manage)(struct path *, bool);
+	int (*d_manage)(const struct path *, bool);
 	struct dentry *(*d_real)(struct dentry *, const struct inode *,
 				 unsigned int);
 } ____cacheline_aligned;
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

