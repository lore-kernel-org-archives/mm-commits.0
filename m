From: akpm@linux-foundation.org
Subject: [obsolete] vfs-make-may_umount_tree-mount-propogation-aware.patch removed from -mm tree
Date: Mon, 12 Dec 2016 13:41:54 -0800
Message-ID: <584f19a2.n0VuhXaCGt2uULJs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48888 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751028AbcLLVlz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 16:41:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ikent@redhat.com, ebiederm@xmission.com, osandov@osandov.com, raven@themaw.net, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: vfs: make may_umount_tree() mount propagation aware
has been removed from the -mm tree.  Its filename was
     vfs-make-may_umount_tree-mount-propogation-aware.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Ian Kent <ikent@redhat.com>
Subject: vfs: make may_umount_tree() mount propagation aware

Now that autofs has namespace aware mounted checks the expire needs
changes to make it aware of mount propagation.

When checking for expiration may_umount_tree() checks only if the
given mount is in use. This leads to a callback to the automount
daemon to umount the mount which will fail if any propagated mounts
are in use.

To avoid this unnecessary call back may_umount_tree() needs to check
propagated mount trees also.

Link: http://lkml.kernel.org/r/148029913966.27779.10094416563067823851.stgit@pluto.themaw.net
Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/expire.c |    4 +-
 fs/namespace.c      |   71 ++++++++++++++++++++++++++++++++++++------
 fs/pnode.c          |    3 -
 fs/pnode.h          |    1 
 4 files changed, 66 insertions(+), 13 deletions(-)

diff -puN fs/autofs4/expire.c~vfs-make-may_umount_tree-mount-propogation-aware fs/autofs4/expire.c
--- a/fs/autofs4/expire.c~vfs-make-may_umount_tree-mount-propogation-aware
+++ a/fs/autofs4/expire.c
@@ -52,7 +52,7 @@ static int autofs4_mount_busy(struct vfs
 			goto done;
 	}
 
-	/* Update the expiry counter if fs is busy */
+	/* Update the expiry counter if fs is busy in any namespace */
 	if (!may_umount_tree(path.mnt)) {
 		struct autofs_info *ino;
 
@@ -191,7 +191,7 @@ static int autofs4_direct_busy(struct vf
 {
 	pr_debug("top %p %pd\n", top, top);
 
-	/* If it's busy update the expiry counters */
+	/* If it's busy in any namespace update the expiry counters */
 	if (!may_umount_tree(mnt)) {
 		struct autofs_info *ino;
 
diff -puN fs/namespace.c~vfs-make-may_umount_tree-mount-propogation-aware fs/namespace.c
--- a/fs/namespace.c~vfs-make-may_umount_tree-mount-propogation-aware
+++ a/fs/namespace.c
@@ -1311,6 +1311,33 @@ const struct seq_operations mounts_op =
 };
 #endif  /* CONFIG_PROC_FS */
 
+struct mnt_tree_refs {
+	struct mount *root;
+	unsigned int refs;
+	unsigned int min_refs;
+};
+
+static void mnt_get_tree_refs(struct mnt_tree_refs *mtr)
+{
+	struct mount *mnt = mtr->root;
+	struct mount *p;
+
+	/*
+	 * Each propagated tree contribues 2 * #mounts - 1 to
+	 * the minimal reference count. But when a mount is
+	 * umounted and connected the mount doesn't hold a
+	 * reference to its parent so it contributes a single
+	 * reference.
+	 */
+	for (p = mnt; p; p = next_mnt(p, mnt)) {
+		mtr->refs += mnt_get_count(p);
+		if (p == mnt || p->mnt.mnt_flags & MNT_UMOUNT)
+			mtr->min_refs++;
+		else
+			mtr->min_refs += 2;
+	}
+}
+
 /**
  * may_umount_tree - check if a mount tree is busy
  * @mnt: root of mount tree
@@ -1322,25 +1349,51 @@ const struct seq_operations mounts_op =
 int may_umount_tree(struct vfsmount *m)
 {
 	struct mount *mnt = real_mount(m);
-	int actual_refs = 0;
-	int minimum_refs = 0;
-	struct mount *p;
+	struct mount *parent = mnt->mnt_parent;
+	struct mnt_tree_refs mtr;
+	struct mount *p, *child;
+
 	BUG_ON(!m);
 
-	/* write lock needed for mnt_get_count */
+	down_read(&namespace_sem);
 	lock_mount_hash();
-	for (p = mnt; p; p = next_mnt(p, mnt)) {
-		actual_refs += mnt_get_count(p);
-		minimum_refs += 2;
+
+	mtr.root = mnt;
+	mtr.refs = 0;
+	mtr.min_refs = 0;
+
+	mnt_get_tree_refs(&mtr);
+	/*
+	 * Caller holds a mount reference so minimum references
+	 * to the tree at mnt is one greater than the minumum
+	 * references.
+	 */
+	mtr.min_refs++;
+
+	/* The pnode.c propagation_next() function (as used below)
+	 * returns each mount propogated from a given mount. Using
+	 * the parent of mnt and matching the mnt->mnt_mountpoint
+	 * gets the list of mounts propogated from mnt. To work
+	 * out if the tree is in use (eg. open file or pwd) the
+	 * reference counts of each of these mounts needs to be
+	 * checked as well as mnt itself.
+	 */
+	for (p = propagation_next(parent, parent); p;
+			p = propagation_next(p, parent)) {
+		child = __lookup_mnt_last(&p->mnt, mnt->mnt_mountpoint);
+		if (child) {
+			mtr.root = child;
+			mnt_get_tree_refs(&mtr);
+		}
 	}
 	unlock_mount_hash();
+	up_read(&namespace_sem);
 
-	if (actual_refs > minimum_refs)
+	if (mtr.refs > mtr.min_refs)
 		return 0;
 
 	return 1;
 }
-
 EXPORT_SYMBOL(may_umount_tree);
 
 /**
diff -puN fs/pnode.c~vfs-make-may_umount_tree-mount-propogation-aware fs/pnode.c
--- a/fs/pnode.c~vfs-make-may_umount_tree-mount-propogation-aware
+++ a/fs/pnode.c
@@ -143,8 +143,7 @@ void change_mnt_propagation(struct mount
  * vfsmount found while iterating with propagation_next() is
  * a peer of one we'd found earlier.
  */
-static struct mount *propagation_next(struct mount *m,
-					 struct mount *origin)
+struct mount *propagation_next(struct mount *m, struct mount *origin)
 {
 	/* are there any slaves of this mount? */
 	if (!IS_MNT_NEW(m) && !list_empty(&m->mnt_slave_list))
diff -puN fs/pnode.h~vfs-make-may_umount_tree-mount-propogation-aware fs/pnode.h
--- a/fs/pnode.h~vfs-make-may_umount_tree-mount-propogation-aware
+++ a/fs/pnode.h
@@ -38,6 +38,7 @@ static inline void set_mnt_shared(struct
 	mnt->mnt.mnt_flags |= MNT_SHARED;
 }
 
+struct mount *propagation_next(struct mount *, struct mount *);
 void change_mnt_propagation(struct mount *, int);
 int propagate_mnt(struct mount *, struct mountpoint *, struct mount *,
 		struct hlist_head *);
_

Patches currently in -mm which might be from ikent@redhat.com are


