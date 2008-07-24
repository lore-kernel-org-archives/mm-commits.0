From: akpm@linux-foundation.org
Subject: - autofs4-use-look-aside-list-for-lookups.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:29:10 -0700
Message-ID: <200807242329.m6ONTATn011353@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756706AbYGXX3O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:29:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     autofs4: use look aside list for lookups
has been removed from the -mm tree.  Its filename was
     autofs4-use-look-aside-list-for-lookups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: autofs4: use look aside list for lookups
From: Ian Kent <raven@themaw.net>

A while ago a patch to resolve a deadlock during directory creation was
merged.  This delayed the hashing of lookup dentrys until the ->mkdir()
(or ->symlink()) operation completed to ensure we always went through
->lookup() instead of also having processes go through ->revalidate() so
our VFS locking remained consistent.

Now we are seeing a couple of side affects of that change in situations
with heavy mount activity.

Two cases have been identified:

1) When a mount request is triggered, due to the delayed hashing, the
   directory created by user space for the mount point doesn't have the
   DCACHE_AUTOFS_PENDING flag set.  In the case of an autofs multi-mount
   where a tree of mount point directories are created this can lead to
   the path walk continuing rather than the dentry being sent to the wait
   queue to wait for request completion.  This is because, if the pending
   flag isn't set, the criteria for deciding this is a mount in progress
   fails to hold, namely that the dentry is not a mount point and has no
   subdirectories.

2) A mount request dentry is initially created negative and unhashed. 
   It remains this way until the ->mkdir() callback completes.  Since it
   is unhashed a fresh dentry is used when the user space mount request
   creates the mount point directory.  This leaves the original dentry
   negative and unhashed.  But revalidate has no way to tell the VFS that
   the dentry has changed, other than to force another ->lookup() by
   returning false, which is at best wastefull and at worst not possible. 
   This results in an -ENOENT return from the original path walk when in
   fact the mount succeeded.

To resolve this we need to ensure that the same dentry is used in all
calls to ->lookup() during the course of a mount request.  This patch
achieves that by adding the initial dentry to a look aside list and
removes it at ->mkdir() or ->symlink() completion (or when the dentry is
released), since these are the only create operations autofs4 supports.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/autofs_i.h |    2 
 fs/autofs4/inode.c    |   25 +++--
 fs/autofs4/root.c     |  169 ++++++++++++++++++++++++++++++++--------
 3 files changed, 156 insertions(+), 40 deletions(-)

diff -puN fs/autofs4/autofs_i.h~autofs4-use-look-aside-list-for-lookups fs/autofs4/autofs_i.h
--- a/fs/autofs4/autofs_i.h~autofs4-use-look-aside-list-for-lookups
+++ a/fs/autofs4/autofs_i.h
@@ -52,6 +52,7 @@ struct autofs_info {
 
 	int		flags;
 
+	struct list_head active;
 	struct list_head expiring;
 
 	struct autofs_sb_info *sbi;
@@ -113,6 +114,7 @@ struct autofs_sb_info {
 	spinlock_t fs_lock;
 	struct autofs_wait_queue *queues; /* Wait queue pointer */
 	spinlock_t lookup_lock;
+	struct list_head active_list;
 	struct list_head expiring_list;
 };
 
diff -puN fs/autofs4/inode.c~autofs4-use-look-aside-list-for-lookups fs/autofs4/inode.c
--- a/fs/autofs4/inode.c~autofs4-use-look-aside-list-for-lookups
+++ a/fs/autofs4/inode.c
@@ -24,8 +24,10 @@
 
 static void ino_lnkfree(struct autofs_info *ino)
 {
-	kfree(ino->u.symlink);
-	ino->u.symlink = NULL;
+	if (ino->u.symlink) {
+		kfree(ino->u.symlink);
+		ino->u.symlink = NULL;
+	}
 }
 
 struct autofs_info *autofs4_init_ino(struct autofs_info *ino,
@@ -41,16 +43,18 @@ struct autofs_info *autofs4_init_ino(str
 	if (ino == NULL)
 		return NULL;
 
-	ino->flags = 0;
-	ino->mode = mode;
-	ino->inode = NULL;
-	ino->dentry = NULL;
-	ino->size = 0;
-
-	INIT_LIST_HEAD(&ino->expiring);
+	if (!reinit) {
+		ino->flags = 0;
+		ino->inode = NULL;
+		ino->dentry = NULL;
+		ino->size = 0;
+		INIT_LIST_HEAD(&ino->active);
+		INIT_LIST_HEAD(&ino->expiring);
+		atomic_set(&ino->count, 0);
+	}
 
+	ino->mode = mode;
 	ino->last_used = jiffies;
-	atomic_set(&ino->count, 0);
 
 	ino->sbi = sbi;
 
@@ -339,6 +343,7 @@ int autofs4_fill_super(struct super_bloc
 	spin_lock_init(&sbi->fs_lock);
 	sbi->queues = NULL;
 	spin_lock_init(&sbi->lookup_lock);
+	INIT_LIST_HEAD(&sbi->active_list);
 	INIT_LIST_HEAD(&sbi->expiring_list);
 	s->s_blocksize = 1024;
 	s->s_blocksize_bits = 10;
diff -puN fs/autofs4/root.c~autofs4-use-look-aside-list-for-lookups fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-use-look-aside-list-for-lookups
+++ a/fs/autofs4/root.c
@@ -473,6 +473,8 @@ void autofs4_dentry_release(struct dentr
 
 		if (sbi) {
 			spin_lock(&sbi->lookup_lock);
+			if (!list_empty(&inf->active))
+				list_del(&inf->active);
 			if (!list_empty(&inf->expiring))
 				list_del(&inf->expiring);
 			spin_unlock(&sbi->lookup_lock);
@@ -497,6 +499,58 @@ static struct dentry_operations autofs4_
 	.d_release	= autofs4_dentry_release,
 };
 
+static struct dentry *autofs4_lookup_active(struct autofs_sb_info *sbi, struct dentry *parent, struct qstr *name)
+{
+	unsigned int len = name->len;
+	unsigned int hash = name->hash;
+	const unsigned char *str = name->name;
+	struct list_head *p, *head;
+
+	spin_lock(&dcache_lock);
+	spin_lock(&sbi->lookup_lock);
+	head = &sbi->active_list;
+	list_for_each(p, head) {
+		struct autofs_info *ino;
+		struct dentry *dentry;
+		struct qstr *qstr;
+
+		ino = list_entry(p, struct autofs_info, active);
+		dentry = ino->dentry;
+
+		spin_lock(&dentry->d_lock);
+
+		/* Already gone? */
+		if (atomic_read(&dentry->d_count) == 0)
+			goto next;
+
+		qstr = &dentry->d_name;
+
+		if (dentry->d_name.hash != hash)
+			goto next;
+		if (dentry->d_parent != parent)
+			goto next;
+
+		if (qstr->len != len)
+			goto next;
+		if (memcmp(qstr->name, str, len))
+			goto next;
+
+		if (d_unhashed(dentry)) {
+			dget(dentry);
+			spin_unlock(&dentry->d_lock);
+			spin_unlock(&sbi->lookup_lock);
+			spin_unlock(&dcache_lock);
+			return dentry;
+		}
+next:
+		spin_unlock(&dentry->d_lock);
+	}
+	spin_unlock(&sbi->lookup_lock);
+	spin_unlock(&dcache_lock);
+
+	return NULL;
+}
+
 static struct dentry *autofs4_lookup_expiring(struct autofs_sb_info *sbi, struct dentry *parent, struct qstr *name)
 {
 	unsigned int len = name->len;
@@ -553,7 +607,8 @@ next:
 static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 {
 	struct autofs_sb_info *sbi;
-	struct dentry *expiring;
+	struct autofs_info *ino;
+	struct dentry *expiring, *unhashed;
 	int oz_mode;
 
 	DPRINTK("name = %.*s",
@@ -571,12 +626,12 @@ static struct dentry *autofs4_lookup(str
 
 	expiring = autofs4_lookup_expiring(sbi, dentry->d_parent, &dentry->d_name);
 	if (expiring) {
-		struct autofs_info *ino = autofs4_dentry_ino(expiring);
 		/*
 		 * If we are racing with expire the request might not
 		 * be quite complete but the directory has been removed
 		 * so it must have been successful, so just wait for it.
 		 */
+		ino = autofs4_dentry_ino(expiring);
 		while (ino && (ino->flags & AUTOFS_INF_EXPIRING)) {
 			DPRINTK("wait for incomplete expire %p name=%.*s",
 				expiring, expiring->d_name.len,
@@ -591,21 +646,41 @@ static struct dentry *autofs4_lookup(str
 		dput(expiring);
 	}
 
-	/*
-	 * Mark the dentry incomplete but don't hash it. We do this
-	 * to serialize our inode creation operations (symlink and
-	 * mkdir) which prevents deadlock during the callback to
-	 * the daemon. Subsequent user space lookups for the same
-	 * dentry are placed on the wait queue while the daemon
-	 * itself is allowed passage unresticted so the create
-	 * operation itself can then hash the dentry. Finally,
-	 * we check for the hashed dentry and return the newly
-	 * hashed dentry.
-	 */
-	dentry->d_op = &autofs4_root_dentry_operations;
+	unhashed = autofs4_lookup_active(sbi, dentry->d_parent, &dentry->d_name);
+	if (unhashed)
+		dentry = unhashed;
+	else {
+		/*
+		 * Mark the dentry incomplete but don't hash it. We do this
+		 * to serialize our inode creation operations (symlink and
+		 * mkdir) which prevents deadlock during the callback to
+		 * the daemon. Subsequent user space lookups for the same
+		 * dentry are placed on the wait queue while the daemon
+		 * itself is allowed passage unresticted so the create
+		 * operation itself can then hash the dentry. Finally,
+		 * we check for the hashed dentry and return the newly
+		 * hashed dentry.
+		 */
+		dentry->d_op = &autofs4_root_dentry_operations;
 
-	dentry->d_fsdata = NULL;
-	d_instantiate(dentry, NULL);
+		/*
+		 * And we need to ensure that the same dentry is used for
+		 * all following lookup calls until it is hashed so that
+		 * the dentry flags are persistent throughout the request.
+		 */
+		ino = autofs4_init_ino(NULL, sbi, 0555);
+		if (!ino)
+			return ERR_PTR(-ENOMEM);
+
+		dentry->d_fsdata = ino;
+		ino->dentry = dentry;
+
+		spin_lock(&sbi->lookup_lock);
+		list_add(&ino->active, &sbi->active_list);
+		spin_unlock(&sbi->lookup_lock);
+
+		d_instantiate(dentry, NULL);
+	}
 
 	if (!oz_mode) {
 		spin_lock(&dentry->d_lock);
@@ -630,12 +705,16 @@ static struct dentry *autofs4_lookup(str
 			if (sigismember (sigset, SIGKILL) ||
 			    sigismember (sigset, SIGQUIT) ||
 			    sigismember (sigset, SIGINT)) {
+			    if (unhashed)
+				dput(unhashed);
 			    return ERR_PTR(-ERESTARTNOINTR);
 			}
 		}
-		spin_lock(&dentry->d_lock);
-		dentry->d_flags &= ~DCACHE_AUTOFS_PENDING;
-		spin_unlock(&dentry->d_lock);
+		if (!oz_mode) {
+			spin_lock(&dentry->d_lock);
+			dentry->d_flags &= ~DCACHE_AUTOFS_PENDING;
+			spin_unlock(&dentry->d_lock);
+		}
 	}
 
 	/*
@@ -659,9 +738,15 @@ static struct dentry *autofs4_lookup(str
 		else
 			dentry = ERR_PTR(-ENOENT);
 
+		if (unhashed)
+			dput(unhashed);
+
 		return dentry;
 	}
 
+	if (unhashed)
+		return unhashed;
+
 	return NULL;
 }
 
@@ -682,20 +767,30 @@ static int autofs4_dir_symlink(struct in
 		return -EACCES;
 
 	ino = autofs4_init_ino(ino, sbi, S_IFLNK | 0555);
-	if (ino == NULL)
-		return -ENOSPC;
+	if (!ino)
+		return -ENOMEM;
 
-	ino->size = strlen(symname);
-	ino->u.symlink = cp = kmalloc(ino->size + 1, GFP_KERNEL);
+	spin_lock(&sbi->lookup_lock);
+	if (!list_empty(&ino->active))
+		list_del_init(&ino->active);
+	spin_unlock(&sbi->lookup_lock);
 
-	if (cp == NULL) {
-		kfree(ino);
-		return -ENOSPC;
+	cp = kmalloc(ino->size + 1, GFP_KERNEL);
+	if (!cp) {
+		if (!dentry->d_fsdata)
+			kfree(ino);
+		return -ENOMEM;
 	}
 
 	strcpy(cp, symname);
 
 	inode = autofs4_get_inode(dir->i_sb, ino);
+	if (!inode) {
+		kfree(cp);
+		if (!dentry->d_fsdata)
+			kfree(ino);
+		return -ENOMEM;
+	}
 	d_add(dentry, inode);
 
 	if (dir == dir->i_sb->s_root->d_inode)
@@ -711,6 +806,8 @@ static int autofs4_dir_symlink(struct in
 		atomic_inc(&p_ino->count);
 	ino->inode = inode;
 
+	ino->size = strlen(symname);
+	ino->u.symlink = cp;
 	dir->i_mtime = CURRENT_TIME;
 
 	return 0;
@@ -755,7 +852,8 @@ static int autofs4_dir_unlink(struct ino
 
 	spin_lock(&dcache_lock);
 	spin_lock(&sbi->lookup_lock);
-	list_add(&ino->expiring, &sbi->expiring_list);
+	if (list_empty(&ino->expiring))
+		list_add(&ino->expiring, &sbi->expiring_list);
 	spin_unlock(&sbi->lookup_lock);
 	spin_lock(&dentry->d_lock);
 	__d_drop(dentry);
@@ -783,7 +881,8 @@ static int autofs4_dir_rmdir(struct inod
 		return -ENOTEMPTY;
 	}
 	spin_lock(&sbi->lookup_lock);
-	list_add(&ino->expiring, &sbi->expiring_list);
+	if (list_empty(&ino->expiring))
+		list_add(&ino->expiring, &sbi->expiring_list);
 	spin_unlock(&sbi->lookup_lock);
 	spin_lock(&dentry->d_lock);
 	__d_drop(dentry);
@@ -819,10 +918,20 @@ static int autofs4_dir_mkdir(struct inod
 		dentry, dentry->d_name.len, dentry->d_name.name);
 
 	ino = autofs4_init_ino(ino, sbi, S_IFDIR | 0555);
-	if (ino == NULL)
-		return -ENOSPC;
+	if (!ino)
+		return -ENOMEM;
+
+	spin_lock(&sbi->lookup_lock);
+	if (!list_empty(&ino->active))
+		list_del_init(&ino->active);
+	spin_unlock(&sbi->lookup_lock);
 
 	inode = autofs4_get_inode(dir->i_sb, ino);
+	if (!inode) {
+		if (!dentry->d_fsdata)
+			kfree(ino);
+		return -ENOMEM;
+	}
 	d_add(dentry, inode);
 
 	if (dir == dir->i_sb->s_root->d_inode)
_

Patches currently in -mm which might be from raven@themaw.net are

origin.patch

