From: akpm@linux-foundation.org
Subject: + autofs4-always-use-lookup-for-lookup.patch added to -mm tree
Date: Tue, 06 Oct 2009 13:50:41 -0700
Message-ID: <200910062050.n96KogiK010058@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45890 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933347AbZJFUvy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Oct 2009 16:51:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raven@themaw.net, adilger@sun.com, hch@infradead.org, sage@newdream.net, viro@ZenIV.linux.org.uk, yehuda@newdream.net


The patch titled
     autofs4: always use lookup for lookup
has been added to the -mm tree.  Its filename is
     autofs4-always-use-lookup-for-lookup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: autofs4: always use lookup for lookup
From: Ian Kent <raven@themaw.net>

We need to be able to cope with the directory mutex being held during
->d_revalidate() in some cases, but not all cases, and not necessarily by
us.  Because we need to release the mutex when we call back to the daemon
to do perform a mount we must be sure that it is us who holds the mutex so
we must redirect mount requests to ->lookup() if the mutex is held.

Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Sage Weil <sage@newdream.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Yehuda Saheh <yehuda@newdream.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/autofs_i.h |    7 
 fs/autofs4/expire.c   |    6 
 fs/autofs4/inode.c    |    1 
 fs/autofs4/root.c     |  474 ++++++++++++++++++++++++++--------------
 4 files changed, 330 insertions(+), 158 deletions(-)

diff -puN fs/autofs4/autofs_i.h~autofs4-always-use-lookup-for-lookup fs/autofs4/autofs_i.h
--- a/fs/autofs4/autofs_i.h~autofs4-always-use-lookup-for-lookup
+++ a/fs/autofs4/autofs_i.h
@@ -60,6 +60,11 @@ do {							\
 		current->pid, __func__, ##args);	\
 } while (0)
 
+struct rehash_entry {
+	struct task_struct *task;
+	struct list_head list;
+};
+
 /* Unified info structure.  This is pointed to by both the dentry and
    inode structures.  Each file in the filesystem has an instance of this
    structure.  It holds a reference to the dentry, so dentries are never
@@ -76,6 +81,7 @@ struct autofs_info {
 
 	struct list_head active;
 	int active_count;
+	struct list_head rehash_list;
 
 	struct list_head expiring;
 
@@ -98,6 +104,7 @@ struct autofs_info {
 #define AUTOFS_INF_EXPIRING	(1<<0) /* dentry is in the process of expiring */
 #define AUTOFS_INF_MOUNTPOINT	(1<<1) /* mountpoint status for direct expire */
 #define AUTOFS_INF_PENDING	(1<<2) /* dentry pending mount */
+#define AUTOFS_INF_REHASH	(1<<3) /* dentry in transit to ->lookup() */
 
 struct autofs_wait_queue {
 	wait_queue_head_t queue;
diff -puN fs/autofs4/expire.c~autofs4-always-use-lookup-for-lookup fs/autofs4/expire.c
--- a/fs/autofs4/expire.c~autofs4-always-use-lookup-for-lookup
+++ a/fs/autofs4/expire.c
@@ -279,6 +279,7 @@ struct dentry *autofs4_expire_direct(str
 			root->d_mounted--;
 		}
 		ino->flags |= AUTOFS_INF_EXPIRING;
+		autofs4_add_expiring(root);
 		init_completion(&ino->expire_complete);
 		spin_unlock(&sbi->fs_lock);
 		return root;
@@ -406,6 +407,7 @@ found:
 		expired, (int)expired->d_name.len, expired->d_name.name);
 	ino = autofs4_dentry_ino(expired);
 	ino->flags |= AUTOFS_INF_EXPIRING;
+	autofs4_add_expiring(expired);
 	init_completion(&ino->expire_complete);
 	spin_unlock(&sbi->fs_lock);
 	spin_lock(&dcache_lock);
@@ -433,7 +435,7 @@ int autofs4_expire_wait(struct dentry *d
 
 		DPRINTK("expire done status=%d", status);
 
-		if (d_unhashed(dentry))
+		if (d_unhashed(dentry) && IS_DEADDIR(dentry->d_inode))
 			return -EAGAIN;
 
 		return status;
@@ -473,6 +475,7 @@ int autofs4_expire_run(struct super_bloc
 	spin_lock(&sbi->fs_lock);
 	ino = autofs4_dentry_ino(dentry);
 	ino->flags &= ~AUTOFS_INF_EXPIRING;
+	autofs4_del_expiring(dentry);
 	complete_all(&ino->expire_complete);
 	spin_unlock(&sbi->fs_lock);
 
@@ -503,6 +506,7 @@ int autofs4_do_expire_multi(struct super
 			ino->flags &= ~AUTOFS_INF_MOUNTPOINT;
 		}
 		ino->flags &= ~AUTOFS_INF_EXPIRING;
+		autofs4_del_expiring(dentry);
 		complete_all(&ino->expire_complete);
 		spin_unlock(&sbi->fs_lock);
 		dput(dentry);
diff -puN fs/autofs4/inode.c~autofs4-always-use-lookup-for-lookup fs/autofs4/inode.c
--- a/fs/autofs4/inode.c~autofs4-always-use-lookup-for-lookup
+++ a/fs/autofs4/inode.c
@@ -49,6 +49,7 @@ struct autofs_info *autofs4_init_ino(str
 		ino->dentry = NULL;
 		ino->size = 0;
 		INIT_LIST_HEAD(&ino->active);
+		INIT_LIST_HEAD(&ino->rehash_list);
 		ino->active_count = 0;
 		INIT_LIST_HEAD(&ino->expiring);
 		atomic_set(&ino->count, 0);
diff -puN fs/autofs4/root.c~autofs4-always-use-lookup-for-lookup fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-always-use-lookup-for-lookup
+++ a/fs/autofs4/root.c
@@ -104,6 +104,99 @@ static void autofs4_del_active(struct de
 	return;
 }
 
+static void autofs4_add_rehash_entry(struct autofs_info *ino,
+				     struct rehash_entry *entry)
+{
+	entry->task = current;
+	INIT_LIST_HEAD(&entry->list);
+	list_add(&entry->list, &ino->rehash_list);
+	return;
+}
+
+static void autofs4_remove_rehash_entry(struct autofs_info *ino)
+{
+	struct list_head *head = &ino->rehash_list;
+	struct rehash_entry *entry;
+	list_for_each_entry(entry, head, list) {
+		if (entry->task == current) {
+			list_del(&entry->list);
+			kfree(entry);
+			break;
+		}
+	}
+	return;
+}
+
+static void autofs4_remove_rehash_entrys(struct autofs_info *ino)
+{
+	struct autofs_sb_info *sbi = ino->sbi;
+	struct rehash_entry *entry, *next;
+	struct list_head *head;
+
+	spin_lock(&sbi->fs_lock);
+	spin_lock(&sbi->lookup_lock);
+	if (!(ino->flags & AUTOFS_INF_REHASH)) {
+		spin_unlock(&sbi->lookup_lock);
+		spin_unlock(&sbi->fs_lock);
+		return;
+	}
+	ino->flags &= ~AUTOFS_INF_REHASH;
+	head = &ino->rehash_list;
+	list_for_each_entry_safe(entry, next, head, list) {
+		list_del(&entry->list);
+		kfree(entry);
+	}
+	spin_unlock(&sbi->lookup_lock);
+	spin_unlock(&sbi->fs_lock);
+	dput(ino->dentry);
+
+	return;
+}
+
+static void autofs4_revalidate_drop(struct dentry *dentry,
+				    struct rehash_entry *entry)
+{
+	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	/*
+	 * Add to the active list so we can pick this up in
+	 * ->lookup(). Also add an entry to a rehash list so
+	 * we know when there are no dentrys in flight so we
+	 * know when we can rehash the dentry.
+	 */
+	spin_lock(&sbi->lookup_lock);
+	if (list_empty(&ino->active))
+		list_add(&ino->active, &sbi->active_list);
+	autofs4_add_rehash_entry(ino, entry);
+	spin_unlock(&sbi->lookup_lock);
+	if (!(ino->flags & AUTOFS_INF_REHASH)) {
+		ino->flags |= AUTOFS_INF_REHASH;
+		dget(dentry);
+		spin_lock(&dentry->d_lock);
+		__d_drop(dentry);
+		spin_unlock(&dentry->d_lock);
+	}
+	return;
+}
+
+static void autofs4_revalidate_rehash(struct dentry *dentry)
+{
+	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	if (ino->flags & AUTOFS_INF_REHASH) {
+		spin_lock(&sbi->lookup_lock);
+		autofs4_remove_rehash_entry(ino);
+		if (list_empty(&ino->rehash_list)) {
+			spin_unlock(&sbi->lookup_lock);
+			ino->flags &= ~AUTOFS_INF_REHASH;
+			d_rehash(dentry);
+			dput(ino->dentry);
+		} else
+			spin_unlock(&sbi->lookup_lock);
+	}
+	return;
+}
+
 static unsigned int autofs4_need_mount(unsigned int flags)
 {
 	unsigned int res = 0;
@@ -143,7 +236,7 @@ out:
 	return dcache_dir_open(inode, file);
 }
 
-static int try_to_fill_dentry(struct dentry *dentry, int flags)
+static int try_to_fill_dentry(struct dentry *dentry)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
@@ -156,55 +249,17 @@ static int try_to_fill_dentry(struct den
 	 * Wait for a pending mount, triggering one if there
 	 * isn't one already
 	 */
-	if (dentry->d_inode == NULL) {
-		DPRINTK("waiting for mount name=%.*s",
-			 dentry->d_name.len, dentry->d_name.name);
+	DPRINTK("waiting for mount name=%.*s",
+		 dentry->d_name.len, dentry->d_name.name);
 
-		status = autofs4_wait(sbi, dentry, NFY_MOUNT);
+	status = autofs4_wait(sbi, dentry, NFY_MOUNT);
 
-		DPRINTK("mount done status=%d", status);
-
-		/* Turn this into a real negative dentry? */
-		if (status == -ENOENT) {
-			spin_lock(&sbi->fs_lock);
-			ino->flags &= ~AUTOFS_INF_PENDING;
-			spin_unlock(&sbi->fs_lock);
-			return status;
-		} else if (status) {
-			/* Return a negative dentry, but leave it "pending" */
-			return status;
-		}
-	/* Trigger mount for path component or follow link */
-	} else if (ino->flags & AUTOFS_INF_PENDING ||
-			autofs4_need_mount(flags) ||
-			current->link_count) {
-		DPRINTK("waiting for mount name=%.*s",
-			dentry->d_name.len, dentry->d_name.name);
-
-		spin_lock(&sbi->fs_lock);
-		ino->flags |= AUTOFS_INF_PENDING;
-		spin_unlock(&sbi->fs_lock);
-		status = autofs4_wait(sbi, dentry, NFY_MOUNT);
+	DPRINTK("mount done status=%d", status);
 
-		DPRINTK("mount done status=%d", status);
+	/* Update expiry counter */
+	ino->last_used = jiffies;
 
-		if (status) {
-			spin_lock(&sbi->fs_lock);
-			ino->flags &= ~AUTOFS_INF_PENDING;
-			spin_unlock(&sbi->fs_lock);
-			return status;
-		}
-	}
-
-	/* Initialize expiry counter after successful mount */
-	if (ino)
-		ino->last_used = jiffies;
-
-	spin_lock(&sbi->fs_lock);
-	ino->flags &= ~AUTOFS_INF_PENDING;
-	spin_unlock(&sbi->fs_lock);
-
-	return 0;
+	return status;
 }
 
 /* For autofs direct mounts the follow link triggers the mount */
@@ -258,10 +313,16 @@ static void *autofs4_follow_link(struct 
 	 */
 	if (ino->flags & AUTOFS_INF_PENDING ||
 	    (!d_mountpoint(dentry) && list_empty(&dentry->d_subdirs))) {
+		ino->flags |= AUTOFS_INF_PENDING;
 		spin_unlock(&dcache_lock);
 		spin_unlock(&sbi->fs_lock);
 
-		status = try_to_fill_dentry(dentry, 0);
+		status = try_to_fill_dentry(dentry);
+
+		spin_lock(&sbi->fs_lock);
+		ino->flags &= ~AUTOFS_INF_PENDING;
+		spin_unlock(&sbi->fs_lock);
+
 		if (status)
 			goto out_error;
 
@@ -300,18 +361,47 @@ static int autofs4_revalidate(struct den
 {
 	struct inode *dir = dentry->d_parent->d_inode;
 	struct autofs_sb_info *sbi = autofs4_sbi(dir->i_sb);
-	int oz_mode = autofs4_oz_mode(sbi);
+	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	struct rehash_entry *entry;
 	int flags = nd ? nd->flags : 0;
-	int status = 1;
+	unsigned int mutex_aquired;
+
+	DPRINTK("name = %.*s oz_mode = %d",
+		dentry->d_name.len, dentry->d_name.name, oz_mode);
+
+	/* Daemon never causes a mount to trigger */
+	if (autofs4_oz_mode(sbi))
+		return 1;
+
+	entry = kmalloc(sizeof(struct rehash_entry), GFP_KERNEL);
+	if (!entry)
+		return -ENOMEM;
+
+	mutex_aquired = mutex_trylock(&dir->i_mutex);
 
-	/* Pending dentry */
 	spin_lock(&sbi->fs_lock);
+	spin_lock(&dcache_lock);
+	/* Pending dentry */
 	if (autofs4_ispending(dentry)) {
-		/* The daemon never causes a mount to trigger */
-		spin_unlock(&sbi->fs_lock);
+		int status;
 
-		if (oz_mode)
-			return 1;
+		/*
+		 * We can only unhash and send this to ->lookup() if
+		 * the directory mutex is held over d_revalidate() and
+		 * ->lookup(). This prevents the VFS from incorrectly
+		 * seeing the dentry as non-existent.
+		 */
+		ino->flags |= AUTOFS_INF_PENDING;
+		if (!mutex_aquired) {
+			autofs4_revalidate_drop(dentry, entry);
+			spin_unlock(&dcache_lock);
+			spin_unlock(&sbi->fs_lock);
+			return 0;
+		}
+		spin_unlock(&dcache_lock);
+		spin_unlock(&sbi->fs_lock);
+		mutex_unlock(&dir->i_mutex);
+		kfree(entry);
 
 		/*
 		 * If the directory has gone away due to an expire
@@ -325,45 +415,82 @@ static int autofs4_revalidate(struct den
 		 * A zero status is success otherwise we have a
 		 * negative error code.
 		 */
-		status = try_to_fill_dentry(dentry, flags);
+		status = try_to_fill_dentry(dentry);
+
+		spin_lock(&sbi->fs_lock);
+		ino->flags &= ~AUTOFS_INF_PENDING;
+		spin_unlock(&sbi->fs_lock);
+
 		if (status == 0)
 			return 1;
 
 		return status;
 	}
-	spin_unlock(&sbi->fs_lock);
-
-	/* Negative dentry.. invalidate if "old" */
-	if (dentry->d_inode == NULL)
-		return 0;
 
 	/* Check for a non-mountpoint directory with no contents */
-	spin_lock(&dcache_lock);
 	if (S_ISDIR(dentry->d_inode->i_mode) &&
 	    !d_mountpoint(dentry) && list_empty(&dentry->d_subdirs)) {
 		DPRINTK("dentry=%p %.*s, emptydir",
 			 dentry, dentry->d_name.len, dentry->d_name.name);
-		spin_unlock(&dcache_lock);
 
-		/* The daemon never causes a mount to trigger */
-		if (oz_mode)
-			return 1;
+		if (autofs4_need_mount(flags) || current->link_count) {
+			int status;
 
-		/*
-		 * A zero status is success otherwise we have a
-		 * negative error code.
-		 */
-		status = try_to_fill_dentry(dentry, flags);
-		if (status == 0)
-			return 1;
+			/*
+			 * We can only unhash and send this to ->lookup() if
+			 * the directory mutex is held over d_revalidate() and
+			 * ->lookup(). This prevents the VFS from incorrectly
+			 * seeing the dentry as non-existent.
+			 */
+			ino->flags |= AUTOFS_INF_PENDING;
+			if (!mutex_aquired) {
+				autofs4_revalidate_drop(dentry, entry);
+				spin_unlock(&dcache_lock);
+				spin_unlock(&sbi->fs_lock);
+				return 0;
+			}
+			spin_unlock(&dcache_lock);
+			spin_unlock(&sbi->fs_lock);
+			mutex_unlock(&dir->i_mutex);
+			kfree(entry);
 
-		return status;
+			/*
+			 * A zero status is success otherwise we have a
+			 * negative error code.
+			 */
+			status = try_to_fill_dentry(dentry);
+
+			spin_lock(&sbi->fs_lock);
+			ino->flags &= ~AUTOFS_INF_PENDING;
+			spin_unlock(&sbi->fs_lock);
+
+			if (status == 0)
+				return 1;
+
+			return status;
+		}
 	}
 	spin_unlock(&dcache_lock);
+	spin_unlock(&sbi->fs_lock);
+
+	if (mutex_aquired)
+		mutex_unlock(&dir->i_mutex);
+
+	kfree(entry);
 
 	return 1;
 }
 
+static void autofs4_free_rehash_entrys(struct autofs_info *inf)
+{
+	struct list_head *head = &inf->rehash_list;
+	struct rehash_entry *entry, *next;
+	list_for_each_entry_safe(entry, next, head, list) {
+		list_del(&entry->list);
+		kfree(entry);
+	}
+}
+
 void autofs4_dentry_release(struct dentry *de)
 {
 	struct autofs_info *inf;
@@ -382,6 +509,8 @@ void autofs4_dentry_release(struct dentr
 				list_del(&inf->active);
 			if (!list_empty(&inf->expiring))
 				list_del(&inf->expiring);
+			if (!list_empty(&inf->rehash_list))
+				autofs4_free_rehash_entrys(inf);
 			spin_unlock(&sbi->lookup_lock);
 		}
 
@@ -414,6 +543,7 @@ static struct dentry *autofs4_lookup_act
 	const unsigned char *str = name->name;
 	struct list_head *p, *head;
 
+restart:
 	spin_lock(&dcache_lock);
 	spin_lock(&sbi->lookup_lock);
 	head = &sbi->active_list;
@@ -431,6 +561,19 @@ static struct dentry *autofs4_lookup_act
 		if (atomic_read(&active->d_count) == 0)
 			goto next;
 
+		if (active->d_inode && IS_DEADDIR(active->d_inode)) {
+			if (!list_empty(&ino->rehash_list)) {
+				dget(active);
+				spin_unlock(&active->d_lock);
+				spin_unlock(&sbi->lookup_lock);
+				spin_unlock(&dcache_lock);
+				autofs4_remove_rehash_entrys(ino);
+				dput(active);
+				goto restart;
+			}
+			goto next;
+		}
+
 		qstr = &active->d_name;
 
 		if (active->d_name.hash != hash)
@@ -443,13 +586,11 @@ static struct dentry *autofs4_lookup_act
 		if (memcmp(qstr->name, str, len))
 			goto next;
 
-		if (d_unhashed(active)) {
-			dget(active);
-			spin_unlock(&active->d_lock);
-			spin_unlock(&sbi->lookup_lock);
-			spin_unlock(&dcache_lock);
-			return active;
-		}
+		dget(active);
+		spin_unlock(&active->d_lock);
+		spin_unlock(&sbi->lookup_lock);
+		spin_unlock(&dcache_lock);
+		return active;
 next:
 		spin_unlock(&active->d_lock);
 	}
@@ -498,13 +639,11 @@ static struct dentry *autofs4_lookup_exp
 		if (memcmp(qstr->name, str, len))
 			goto next;
 
-		if (d_unhashed(expiring)) {
-			dget(expiring);
-			spin_unlock(&expiring->d_lock);
-			spin_unlock(&sbi->lookup_lock);
-			spin_unlock(&dcache_lock);
-			return expiring;
-		}
+		dget(expiring);
+		spin_unlock(&expiring->d_lock);
+		spin_unlock(&sbi->lookup_lock);
+		spin_unlock(&dcache_lock);
+		return expiring;
 next:
 		spin_unlock(&expiring->d_lock);
 	}
@@ -514,6 +653,48 @@ next:
 	return NULL;
 }
 
+static struct autofs_info *init_new_dentry(struct autofs_sb_info *sbi,
+					   struct dentry *dentry, int oz_mode)
+{
+	struct autofs_info *ino;
+
+	/*
+	 * Mark the dentry incomplete but don't hash it. We do this
+	 * to serialize our inode creation operations (symlink and
+	 * mkdir) which prevents deadlock during the callback to
+	 * the daemon. Subsequent user space lookups for the same
+	 * dentry are placed on the wait queue while the daemon
+	 * itself is allowed passage unresticted so the create
+	 * operation itself can then hash the dentry. Finally,
+	 * we check for the hashed dentry and return the newly
+	 * hashed dentry.
+	 */
+	dentry->d_op = &autofs4_root_dentry_operations;
+
+	/*
+	 * And we need to ensure that the same dentry is used for
+	 * all following lookup calls until it is hashed so that
+	 * the dentry flags are persistent throughout the request.
+	 */
+	ino = autofs4_init_ino(NULL, sbi, 0555);
+	if (!ino)
+		return ERR_PTR(-ENOMEM);
+
+	dentry->d_fsdata = ino;
+	ino->dentry = dentry;
+
+	/*
+	 * Only set the mount pending flag for new dentrys not created
+	 * by the daemon.
+	 */
+	if (!oz_mode)
+		ino->flags |= AUTOFS_INF_PENDING;
+
+	d_instantiate(dentry, NULL);
+
+	return ino;
+}
+
 /* Lookups in the root directory */
 static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 {
@@ -521,6 +702,7 @@ static struct dentry *autofs4_lookup(str
 	struct autofs_info *ino;
 	struct dentry *expiring, *active;
 	int oz_mode;
+	int status = 0;
 
 	DPRINTK("name = %.*s",
 		dentry->d_name.len, dentry->d_name.name);
@@ -535,44 +717,26 @@ static struct dentry *autofs4_lookup(str
 	DPRINTK("pid = %u, pgrp = %u, catatonic = %d, oz_mode = %d",
 		 current->pid, task_pgrp_nr(current), sbi->catatonic, oz_mode);
 
+	spin_lock(&sbi->fs_lock);
 	active = autofs4_lookup_active(dentry);
 	if (active) {
 		dentry = active;
 		ino = autofs4_dentry_ino(dentry);
+		/* If this came from revalidate, rehash it */
+		autofs4_revalidate_rehash(dentry);
+		spin_unlock(&sbi->fs_lock);
 	} else {
-		/*
-		 * Mark the dentry incomplete but don't hash it. We do this
-		 * to serialize our inode creation operations (symlink and
-		 * mkdir) which prevents deadlock during the callback to
-		 * the daemon. Subsequent user space lookups for the same
-		 * dentry are placed on the wait queue while the daemon
-		 * itself is allowed passage unresticted so the create
-		 * operation itself can then hash the dentry. Finally,
-		 * we check for the hashed dentry and return the newly
-		 * hashed dentry.
-		 */
-		dentry->d_op = &autofs4_root_dentry_operations;
-
-		/*
-		 * And we need to ensure that the same dentry is used for
-		 * all following lookup calls until it is hashed so that
-		 * the dentry flags are persistent throughout the request.
-		 */
-		ino = autofs4_init_ino(NULL, sbi, 0555);
-		if (!ino)
-			return ERR_PTR(-ENOMEM);
-
-		dentry->d_fsdata = ino;
-		ino->dentry = dentry;
-
-		autofs4_add_active(dentry);
-
-		d_instantiate(dentry, NULL);
+		spin_unlock(&sbi->fs_lock);
+		ino = init_new_dentry(sbi, dentry, oz_mode);
+		if (IS_ERR(ino))
+			return (struct dentry *) ino;
 	}
 
+	autofs4_add_active(dentry);
+
 	if (!oz_mode) {
-		mutex_unlock(&dir->i_mutex);
 		expiring = autofs4_lookup_expiring(dentry);
+		mutex_unlock(&dir->i_mutex);
 		if (expiring) {
 			/*
 			 * If we are racing with expire the request might not
@@ -580,23 +744,22 @@ static struct dentry *autofs4_lookup(str
 			 * so it must have been successful, so just wait for it.
 			 */
 			autofs4_expire_wait(expiring);
-			autofs4_del_expiring(expiring);
 			dput(expiring);
 		}
-
+		status = try_to_fill_dentry(dentry);
+		mutex_lock(&dir->i_mutex);
 		spin_lock(&sbi->fs_lock);
-		ino->flags |= AUTOFS_INF_PENDING;
+		ino->flags &= ~AUTOFS_INF_PENDING;
 		spin_unlock(&sbi->fs_lock);
-		if (dentry->d_op && dentry->d_op->d_revalidate)
-			(dentry->d_op->d_revalidate)(dentry, nd);
-		mutex_lock(&dir->i_mutex);
 	}
 
+	autofs4_del_active(dentry);
+
 	/*
-	 * If we are still pending, check if we had to handle
+	 * If we had a mount fail, check if we had to handle
 	 * a signal. If so we can force a restart..
 	 */
-	if (ino->flags & AUTOFS_INF_PENDING) {
+	if (status) {
 		/* See if we were interrupted */
 		if (signal_pending(current)) {
 			sigset_t *sigset = &current->pending.signal;
@@ -608,43 +771,46 @@ static struct dentry *autofs4_lookup(str
 			    return ERR_PTR(-ERESTARTNOINTR);
 			}
 		}
-		if (!oz_mode) {
-			spin_lock(&sbi->fs_lock);
-			ino->flags &= ~AUTOFS_INF_PENDING;
-			spin_unlock(&sbi->fs_lock);
-		}
 	}
 
 	/*
-	 * If this dentry is unhashed, then we shouldn't honour this
-	 * lookup.  Returning ENOENT here doesn't do the right thing
-	 * for all system calls, but it should be OK for the operations
-	 * we permit from an autofs.
+	 * User space can (and has done in the past) remove and re-create
+	 * this directory during the callback. This can leave us with an
+	 * unhashed dentry, but a successful mount!  So we need to
+	 * perform another cached lookup in case the dentry now exists.
 	 */
-	if (!oz_mode && d_unhashed(dentry)) {
-		/*
-		 * A user space application can (and has done in the past)
-		 * remove and re-create this directory during the callback.
-		 * This can leave us with an unhashed dentry, but a
-		 * successful mount!  So we need to perform another
-		 * cached lookup in case the dentry now exists.
-		 */
-		struct dentry *parent = dentry->d_parent;
-		struct dentry *new = d_lookup(parent, &dentry->d_name);
-		if (new != NULL)
-			dentry = new;
-		else
-			dentry = ERR_PTR(-ENOENT);
+	if (!oz_mode && !have_submounts(dentry)) {
+		struct dentry *new;
+		new = d_lookup(dentry->d_parent, &dentry->d_name);
+		if (new) {
+			if (active)
+				dput(active);
+			return new;
+		} else {
+			if (!status)
+				status = -ENOENT;
+		}
+	}
 
+	/*
+	 * If we had a mount failure, return status to user space.
+	 * If the mount succeeded and we used a dentry from the active queue
+	 * return it.
+	 */
+	if (status) {
+		dentry = ERR_PTR(status);
 		if (active)
 			dput(active);
-
 		return dentry;
+	} else {
+		/*
+		 * Valid successful mount, return active dentry or NULL
+		 * for a new dentry.
+		 */
+		if (active)
+			return active;
 	}
 
-	if (active)
-		return active;
-
 	return NULL;
 }
 
@@ -668,8 +834,6 @@ static int autofs4_dir_symlink(struct in
 	if (!ino)
 		return -ENOMEM;
 
-	autofs4_del_active(dentry);
-
 	ino->size = strlen(symname);
 	cp = kmalloc(ino->size + 1, GFP_KERNEL);
 	if (!cp) {
@@ -746,7 +910,6 @@ static int autofs4_dir_unlink(struct ino
 	dir->i_mtime = CURRENT_TIME;
 
 	spin_lock(&dcache_lock);
-	autofs4_add_expiring(dentry);
 	spin_lock(&dentry->d_lock);
 	__d_drop(dentry);
 	spin_unlock(&dentry->d_lock);
@@ -772,7 +935,6 @@ static int autofs4_dir_rmdir(struct inod
 		spin_unlock(&dcache_lock);
 		return -ENOTEMPTY;
 	}
-	autofs4_add_expiring(dentry);
 	spin_lock(&dentry->d_lock);
 	__d_drop(dentry);
 	spin_unlock(&dentry->d_lock);
@@ -810,8 +972,6 @@ static int autofs4_dir_mkdir(struct inod
 	if (!ino)
 		return -ENOMEM;
 
-	autofs4_del_active(dentry);
