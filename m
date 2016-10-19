From: akpm@linux-foundation.org
Subject: + vfs-change-d_manage-to-take-a-struct-path.patch added to -mm
 tree
Date: Wed, 19 Oct 2016 12:40:41 -0700
Message-ID: <5807cc39.JzUeqjh2L8img1r3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60693 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S943755AbcJSTkm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Oct 2016 15:40:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ikent@redhat.com, ebiederm@xmission.com, osandov@osandov.com, raven@themaw.net, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: vfs: change d_manage() to take a struct path
has been added to the -mm tree.  Its filename is
     vfs-change-d_manage-to-take-a-struct-path.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vfs-change-d_manage-to-take-a-struct-path.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vfs-change-d_manage-to-take-a-struct-path.patch

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
Subject: vfs: change d_manage() to take a struct path

For the autofs module to be able to reliably check if a dentry is a
mountpoint in a multiple namespace environment the ->d_manage() dentry
operation will need to take a path argument instead of a dentry.

Link: http://lkml.kernel.org/r/20161011053352.27645.83962.stgit@pluto.themaw.net
Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/Locking |    2 +-
 Documentation/filesystems/vfs.txt |    2 +-
 fs/autofs4/root.c                 |    5 +++--
 fs/namei.c                        |   13 ++++++-------
 include/linux/dcache.h            |    2 +-
 5 files changed, 12 insertions(+), 12 deletions(-)

diff -puN Documentation/filesystems/Locking~vfs-change-d_manage-to-take-a-struct-path Documentation/filesystems/Locking
--- a/Documentation/filesystems/Locking~vfs-change-d_manage-to-take-a-struct-path
+++ a/Documentation/filesystems/Locking
@@ -20,7 +20,7 @@ prototypes:
 	void (*d_iput)(struct dentry *, struct inode *);
 	char *(*d_dname)((struct dentry *dentry, char *buffer, int buflen);
 	struct vfsmount *(*d_automount)(struct path *path);
-	int (*d_manage)(struct dentry *, bool);
+	int (*d_manage)(struct path *, bool);
 	struct dentry *(*d_real)(struct dentry *, const struct inode *,
 				 unsigned int);
 
diff -puN Documentation/filesystems/vfs.txt~vfs-change-d_manage-to-take-a-struct-path Documentation/filesystems/vfs.txt
--- a/Documentation/filesystems/vfs.txt~vfs-change-d_manage-to-take-a-struct-path
+++ a/Documentation/filesystems/vfs.txt
@@ -949,7 +949,7 @@ struct dentry_operations {
 	void (*d_iput)(struct dentry *, struct inode *);
 	char *(*d_dname)(struct dentry *, char *, int);
 	struct vfsmount *(*d_automount)(struct path *);
-	int (*d_manage)(struct dentry *, bool);
+	int (*d_manage)(struct path *, bool);
 	struct dentry *(*d_real)(struct dentry *, const struct inode *,
 				 unsigned int);
 };
diff -puN fs/autofs4/root.c~vfs-change-d_manage-to-take-a-struct-path fs/autofs4/root.c
--- a/fs/autofs4/root.c~vfs-change-d_manage-to-take-a-struct-path
+++ a/fs/autofs4/root.c
@@ -32,7 +32,7 @@ static int autofs4_dir_open(struct inode
 static struct dentry *autofs4_lookup(struct inode *,
 				     struct dentry *, unsigned int);
 static struct vfsmount *autofs4_d_automount(struct path *);
-static int autofs4_d_manage(struct dentry *, bool);
+static int autofs4_d_manage(struct path *, bool);
 static void autofs4_dentry_release(struct dentry *);
 
 const struct file_operations autofs4_root_operations = {
@@ -421,8 +421,9 @@ done:
 	return NULL;
 }
 
-static int autofs4_d_manage(struct dentry *dentry, bool rcu_walk)
+static int autofs4_d_manage(struct path *path, bool rcu_walk)
 {
+	struct dentry *dentry = path->dentry;
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
 	int status;
diff -puN fs/namei.c~vfs-change-d_manage-to-take-a-struct-path fs/namei.c
--- a/fs/namei.c~vfs-change-d_manage-to-take-a-struct-path
+++ a/fs/namei.c
@@ -1200,7 +1200,7 @@ static int follow_managed(struct path *p
 		if (managed & DCACHE_MANAGE_TRANSIT) {
 			BUG_ON(!path->dentry->d_op);
 			BUG_ON(!path->dentry->d_op->d_manage);
-			ret = path->dentry->d_op->d_manage(path->dentry, false);
+			ret = path->dentry->d_op->d_manage(path, false);
 			if (ret < 0)
 				break;
 		}
@@ -1263,10 +1263,10 @@ int follow_down_one(struct path *path)
 }
 EXPORT_SYMBOL(follow_down_one);
 
-static inline int managed_dentry_rcu(struct dentry *dentry)
+static inline int managed_dentry_rcu(struct path *path)
 {
-	return (dentry->d_flags & DCACHE_MANAGE_TRANSIT) ?
-		dentry->d_op->d_manage(dentry, true) : 0;
+	return (path->dentry->d_flags & DCACHE_MANAGE_TRANSIT) ?
+		path->dentry->d_op->d_manage(path, true) : 0;
 }
 
 /*
@@ -1282,7 +1282,7 @@ static bool __follow_mount_rcu(struct na
 		 * Don't forget we might have a non-mountpoint managed dentry
 		 * that wants to block transit.
 		 */
-		switch (managed_dentry_rcu(path->dentry)) {
+		switch (managed_dentry_rcu(path)) {
 		case -ECHILD:
 		default:
 			return false;
@@ -1392,8 +1392,7 @@ int follow_down(struct path *path)
 		if (managed & DCACHE_MANAGE_TRANSIT) {
 			BUG_ON(!path->dentry->d_op);
 			BUG_ON(!path->dentry->d_op->d_manage);
-			ret = path->dentry->d_op->d_manage(
-				path->dentry, false);
+			ret = path->dentry->d_op->d_manage(path, false);
 			if (ret < 0)
 				return ret == -EISDIR ? 0 : ret;
 		}
diff -puN include/linux/dcache.h~vfs-change-d_manage-to-take-a-struct-path include/linux/dcache.h
--- a/include/linux/dcache.h~vfs-change-d_manage-to-take-a-struct-path
+++ a/include/linux/dcache.h
@@ -139,7 +139,7 @@ struct dentry_operations {
 	void (*d_iput)(struct dentry *, struct inode *);
 	char *(*d_dname)(struct dentry *, char *, int);
 	struct vfsmount *(*d_automount)(struct path *);
-	int (*d_manage)(struct dentry *, bool);
+	int (*d_manage)(struct path *, bool);
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

