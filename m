From: akpm@linux-foundation.org
Subject: + brlocks-lglocks-cleanups.patch added to -mm tree
Date: Fri, 13 Jan 2012 15:21:31 -0800
Message-ID: <20120113232132.21831200070@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:64742 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab2AMXVe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 18:21:34 -0500
Received: by eaad12 with SMTP id d12so29112eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 15:21:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: brlocks/lglocks: cleanups
has been added to the -mm tree.  Its filename is
     brlocks-lglocks-cleanups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: brlocks/lglocks: cleanups

lglocks and brlocks are currently generated with some complicated macros
in lglock.h.  But there's no reason to not just use common utility
functions and put all the data into a common data structure.

Since there are at least two users it makes sense to share this code in a
library.  This is also easier maintainable than a macro forest.

This will also make it later possible to dynamically allocate lglocks and
also use them in modules (this would both still need some additional, but
now straightforward, code)

In general the users now look more like normal function calls with
pointers, not magic macros.

The patch is rather large because I move over all users in one go to keep
it bisectable.  This impacts the VFS somewhat in terms of lines changed. 
But no actual behaviour change.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c            |    4 
 fs/file_table.c        |   17 +--
 fs/internal.h          |    3 
 fs/namei.c             |   24 ++--
 fs/namespace.c         |  140 ++++++++++++++--------------
 fs/pnode.c             |    4 
 fs/proc_namespace.c    |    4 
 include/linux/lglock.h |  189 +++++++--------------------------------
 kernel/Makefile        |    2 
 kernel/lglock.c        |  136 ++++++++++++++++++++++++++++
 10 files changed, 269 insertions(+), 254 deletions(-)

diff -puN fs/dcache.c~clean-up-brlocks-lglocks-v2 fs/dcache.c
--- a/fs/dcache.c~clean-up-brlocks-lglocks-v2
+++ a/fs/dcache.c
@@ -2466,7 +2466,7 @@ static int prepend_path(const struct pat
 	bool slash = false;
 	int error = 0;
 
-	br_read_lock(vfsmount_lock);
+	br_read_lock(&vfsmount_lock);
 	while (dentry != root->dentry || vfsmnt != root->mnt) {
 		struct dentry * parent;
 
@@ -2497,7 +2497,7 @@ static int prepend_path(const struct pat
 		error = prepend(buffer, buflen, "/", 1);
 
 out:
-	br_read_unlock(vfsmount_lock);
+	br_read_unlock(&vfsmount_lock);
 	return error;
 
 global_root:
diff -puN fs/file_table.c~clean-up-brlocks-lglocks-v2 fs/file_table.c
--- a/fs/file_table.c~clean-up-brlocks-lglocks-v2
+++ a/fs/file_table.c
@@ -34,7 +34,6 @@ struct files_stat_struct files_stat = {
 	.max_files = NR_FILE
 };
 
-DECLARE_LGLOCK(files_lglock);
 DEFINE_LGLOCK(files_lglock);
 
 /* SLAB cache for file structures */
@@ -422,9 +421,9 @@ static inline void __file_sb_list_add(st
  */
 void file_sb_list_add(struct file *file, struct super_block *sb)
 {
-	lg_local_lock(files_lglock);
+	lg_local_lock(&files_lglock);
 	__file_sb_list_add(file, sb);
-	lg_local_unlock(files_lglock);
+	lg_local_unlock(&files_lglock);
 }
 
 /**
@@ -437,9 +436,9 @@ void file_sb_list_add(struct file *file,
 void file_sb_list_del(struct file *file)
 {
 	if (!list_empty(&file->f_u.fu_list)) {
-		lg_local_lock_cpu(files_lglock, file_list_cpu(file));
+		lg_local_lock_cpu(&files_lglock, file_list_cpu(file));
 		list_del_init(&file->f_u.fu_list);
-		lg_local_unlock_cpu(files_lglock, file_list_cpu(file));
+		lg_local_unlock_cpu(&files_lglock, file_list_cpu(file));
 	}
 }
 
@@ -486,7 +485,7 @@ void mark_files_ro(struct super_block *s
 	struct file *f;
 
 retry:
-	lg_global_lock(files_lglock);
+	lg_global_lock(&files_lglock);
 	do_file_list_for_each_entry(sb, f) {
 		struct vfsmount *mnt;
 		if (!S_ISREG(f->f_path.dentry->d_inode->i_mode))
@@ -503,12 +502,12 @@ retry:
 		file_release_write(f);
 		mnt = mntget(f->f_path.mnt);
 		/* This can sleep, so we can't hold the spinlock. */
-		lg_global_unlock(files_lglock);
+		lg_global_unlock(&files_lglock);
 		mnt_drop_write(mnt);
 		mntput(mnt);
 		goto retry;
 	} while_file_list_for_each_entry;
-	lg_global_unlock(files_lglock);
+	lg_global_unlock(&files_lglock);
 }
 
 void __init files_init(unsigned long mempages)
@@ -526,6 +525,6 @@ void __init files_init(unsigned long mem
 	n = (mempages * (PAGE_SIZE / 1024)) / 10;
 	files_stat.max_files = max_t(unsigned long, n, NR_FILE);
 	files_defer_init();
-	lg_lock_init(files_lglock);
+	lg_lock_init(&files_lglock, "files_lglock");
 	percpu_counter_init(&nr_files, 0);
 } 
diff -puN fs/internal.h~clean-up-brlocks-lglocks-v2 fs/internal.h
--- a/fs/internal.h~clean-up-brlocks-lglocks-v2
+++ a/fs/internal.h
@@ -56,8 +56,7 @@ extern int sb_prepare_remount_readonly(s
 
 extern void __init mnt_init(void);
 
-DECLARE_BRLOCK(vfsmount_lock);
-
+extern struct lglock vfsmount_lock;
 
 /*
  * fs_struct.c
diff -puN fs/namei.c~clean-up-brlocks-lglocks-v2 fs/namei.c
--- a/fs/namei.c~clean-up-brlocks-lglocks-v2
+++ a/fs/namei.c
@@ -464,7 +464,7 @@ static int unlazy_walk(struct nameidata 
 	mntget(nd->path.mnt);
 
 	rcu_read_unlock();
-	br_read_unlock(vfsmount_lock);
+	br_read_unlock(&vfsmount_lock);
 	nd->flags &= ~LOOKUP_RCU;
 	return 0;
 
@@ -522,14 +522,14 @@ static int complete_walk(struct nameidat
 		if (unlikely(!__d_rcu_to_refcount(dentry, nd->seq))) {
 			spin_unlock(&dentry->d_lock);
 			rcu_read_unlock();
-			br_read_unlock(vfsmount_lock);
+			br_read_unlock(&vfsmount_lock);
 			return -ECHILD;
 		}
 		BUG_ON(nd->inode != dentry->d_inode);
 		spin_unlock(&dentry->d_lock);
 		mntget(nd->path.mnt);
 		rcu_read_unlock();
-		br_read_unlock(vfsmount_lock);
+		br_read_unlock(&vfsmount_lock);
 	}
 
 	if (likely(!(nd->flags & LOOKUP_JUMPED)))
@@ -696,15 +696,15 @@ int follow_up(struct path *path)
 	struct mount *parent;
 	struct dentry *mountpoint;
 
-	br_read_lock(vfsmount_lock);
+	br_read_lock(&vfsmount_lock);
 	parent = mnt->mnt_parent;
 	if (&parent->mnt == path->mnt) {
-		br_read_unlock(vfsmount_lock);
+		br_read_unlock(&vfsmount_lock);
 		return 0;
 	}
 	mntget(&parent->mnt);
 	mountpoint = dget(mnt->mnt_mountpoint);
-	br_read_unlock(vfsmount_lock);
+	br_read_unlock(&vfsmount_lock);
 	dput(path->dentry);
 	path->dentry = mountpoint;
 	mntput(path->mnt);
@@ -962,7 +962,7 @@ failed:
 	if (!(nd->flags & LOOKUP_ROOT))
 		nd->root.mnt = NULL;
 	rcu_read_unlock();
-	br_read_unlock(vfsmount_lock);
+	br_read_unlock(&vfsmount_lock);
 	return -ECHILD;
 }
 
@@ -1256,7 +1256,7 @@ static void terminate_walk(struct nameid
 		if (!(nd->flags & LOOKUP_ROOT))
 			nd->root.mnt = NULL;
 		rcu_read_unlock();
-		br_read_unlock(vfsmount_lock);
+		br_read_unlock(&vfsmount_lock);
 	}
 }
 
@@ -1490,7 +1490,7 @@ static int path_init(int dfd, const char
 		nd->path = nd->root;
 		nd->inode = inode;
 		if (flags & LOOKUP_RCU) {
-			br_read_lock(vfsmount_lock);
+			br_read_lock(&vfsmount_lock);
 			rcu_read_lock();
 			nd->seq = __read_seqcount_begin(&nd->path.dentry->d_seq);
 		} else {
@@ -1503,7 +1503,7 @@ static int path_init(int dfd, const char
 
 	if (*name=='/') {
 		if (flags & LOOKUP_RCU) {
-			br_read_lock(vfsmount_lock);
+			br_read_lock(&vfsmount_lock);
 			rcu_read_lock();
 			set_root_rcu(nd);
 		} else {
@@ -1516,7 +1516,7 @@ static int path_init(int dfd, const char
 			struct fs_struct *fs = current->fs;
 			unsigned seq;
 
-			br_read_lock(vfsmount_lock);
+			br_read_lock(&vfsmount_lock);
 			rcu_read_lock();
 
 			do {
@@ -1552,7 +1552,7 @@ static int path_init(int dfd, const char
 			if (fput_needed)
 				*fp = file;
 			nd->seq = __read_seqcount_begin(&nd->path.dentry->d_seq);
-			br_read_lock(vfsmount_lock);
+			br_read_lock(&vfsmount_lock);
 			rcu_read_lock();
 		} else {
 			path_get(&file->f_path);
diff -puN fs/namespace.c~clean-up-brlocks-lglocks-v2 fs/namespace.c
--- a/fs/namespace.c~clean-up-brlocks-lglocks-v2
+++ a/fs/namespace.c
@@ -397,7 +397,7 @@ static int mnt_make_readonly(struct moun
 {
 	int ret = 0;
 
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	mnt->mnt.mnt_flags |= MNT_WRITE_HOLD;
 	/*
 	 * After storing MNT_WRITE_HOLD, we'll read the counters. This store
@@ -431,15 +431,15 @@ static int mnt_make_readonly(struct moun
 	 */
 	smp_wmb();
 	mnt->mnt.mnt_flags &= ~MNT_WRITE_HOLD;
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 	return ret;
 }
 
 static void __mnt_unmake_readonly(struct mount *mnt)
 {
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	mnt->mnt.mnt_flags &= ~MNT_READONLY;
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 }
 
 int sb_prepare_remount_readonly(struct super_block *sb)
@@ -451,7 +451,7 @@ int sb_prepare_remount_readonly(struct s
 	if (atomic_long_read(&sb->s_remove_count))
 		return -EBUSY;
 
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	list_for_each_entry(mnt, &sb->s_mounts, mnt_instance) {
 		if (!(mnt->mnt.mnt_flags & MNT_READONLY)) {
 			mnt->mnt.mnt_flags |= MNT_WRITE_HOLD;
@@ -473,7 +473,7 @@ int sb_prepare_remount_readonly(struct s
 		if (mnt->mnt.mnt_flags & MNT_WRITE_HOLD)
 			mnt->mnt.mnt_flags &= ~MNT_WRITE_HOLD;
 	}
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 
 	return err;
 }
@@ -522,14 +522,14 @@ struct vfsmount *lookup_mnt(struct path 
 {
 	struct mount *child_mnt;
 
-	br_read_lock(vfsmount_lock);
+	br_read_lock(&vfsmount_lock);
 	child_mnt = __lookup_mnt(path->mnt, path->dentry, 1);
 	if (child_mnt) {
 		mnt_add_count(child_mnt, 1);
-		br_read_unlock(vfsmount_lock);
+		br_read_unlock(&vfsmount_lock);
 		return &child_mnt->mnt;
 	} else {
-		br_read_unlock(vfsmount_lock);
+		br_read_unlock(&vfsmount_lock);
 		return NULL;
 	}
 }
@@ -714,9 +714,9 @@ vfs_kern_mount(struct file_system_type *
 	mnt->mnt.mnt_sb = root->d_sb;
 	mnt->mnt_mountpoint = mnt->mnt.mnt_root;
 	mnt->mnt_parent = mnt;
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	list_add_tail(&mnt->mnt_instance, &root->d_sb->s_mounts);
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 	return &mnt->mnt;
 }
 EXPORT_SYMBOL_GPL(vfs_kern_mount);
@@ -745,9 +745,9 @@ static struct mount *clone_mnt(struct mo
 		mnt->mnt.mnt_root = dget(root);
 		mnt->mnt_mountpoint = mnt->mnt.mnt_root;
 		mnt->mnt_parent = mnt;
-		br_write_lock(vfsmount_lock);
+		br_write_lock(&vfsmount_lock);
 		list_add_tail(&mnt->mnt_instance, &sb->s_mounts);
-		br_write_unlock(vfsmount_lock);
+		br_write_unlock(&vfsmount_lock);
 
 		if (flag & CL_SLAVE) {
 			list_add(&mnt->mnt_slave, &old->mnt_slave_list);
@@ -803,35 +803,36 @@ static void mntput_no_expire(struct moun
 {
 put_again:
 #ifdef CONFIG_SMP
-	br_read_lock(vfsmount_lock);
+	br_read_lock(&vfsmount_lock);
 	if (likely(atomic_read(&mnt->mnt_longterm))) {
 		mnt_add_count(mnt, -1);
-		br_read_unlock(vfsmount_lock);
+		br_read_unlock(&vfsmount_lock);
 		return;
 	}
-	br_read_unlock(vfsmount_lock);
+	br_read_unlock(&vfsmount_lock);
 
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	mnt_add_count(mnt, -1);
 	if (mnt_get_count(mnt)) {
-		br_write_unlock(vfsmount_lock);
+		br_write_unlock(&vfsmount_lock);
 		return;
 	}
 #else
 	mnt_add_count(mnt, -1);
 	if (likely(mnt_get_count(mnt)))
 		return;
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 #endif
 	if (unlikely(mnt->mnt_pinned)) {
 		mnt_add_count(mnt, mnt->mnt_pinned + 1);
 		mnt->mnt_pinned = 0;
-		br_write_unlock(vfsmount_lock);
+		br_write_unlock(&vfsmount_lock);
 		acct_auto_close_mnt(&mnt->mnt);
 		goto put_again;
 	}
+
 	list_del(&mnt->mnt_instance);
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 	mntfree(mnt);
 }
 
@@ -857,21 +858,21 @@ EXPORT_SYMBOL(mntget);
 
 void mnt_pin(struct vfsmount *mnt)
 {
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	real_mount(mnt)->mnt_pinned++;
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 }
 EXPORT_SYMBOL(mnt_pin);
 
 void mnt_unpin(struct vfsmount *m)
 {
 	struct mount *mnt = real_mount(m);
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	if (mnt->mnt_pinned) {
 		mnt_add_count(mnt, 1);
 		mnt->mnt_pinned--;
 	}
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 }
 EXPORT_SYMBOL(mnt_unpin);
 
@@ -988,12 +989,12 @@ int may_umount_tree(struct vfsmount *m)
 	BUG_ON(!m);
 
 	/* write lock needed for mnt_get_count */
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	for (p = mnt; p; p = next_mnt(p, mnt)) {
 		actual_refs += mnt_get_count(p);
 		minimum_refs += 2;
 	}
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 
 	if (actual_refs > minimum_refs)
 		return 0;
@@ -1020,10 +1021,10 @@ int may_umount(struct vfsmount *mnt)
 {
 	int ret = 1;
 	down_read(&namespace_sem);
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	if (propagate_mount_busy(real_mount(mnt), 2))
 		ret = 0;
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 	up_read(&namespace_sem);
 	return ret;
 }
@@ -1040,13 +1041,13 @@ void release_mounts(struct list_head *he
 			struct dentry *dentry;
 			struct mount *m;
 
-			br_write_lock(vfsmount_lock);
+			br_write_lock(&vfsmount_lock);
 			dentry = mnt->mnt_mountpoint;
 			m = mnt->mnt_parent;
 			mnt->mnt_mountpoint = mnt->mnt.mnt_root;
 			mnt->mnt_parent = mnt;
 			m->mnt_ghosts--;
-			br_write_unlock(vfsmount_lock);
+			br_write_unlock(&vfsmount_lock);
 			dput(dentry);
 			mntput(&m->mnt);
 		}
@@ -1112,12 +1113,12 @@ static int do_umount(struct mount *mnt, 
 		 * probably don't strictly need the lock here if we examined
 		 * all race cases, but it's a slowpath.
 		 */
-		br_write_lock(vfsmount_lock);
+		br_write_lock(&vfsmount_lock);
 		if (mnt_get_count(mnt) != 2) {
-			br_write_unlock(vfsmount_lock);
+			br_write_unlock(&vfsmount_lock);
 			return -EBUSY;
 		}
-		br_write_unlock(vfsmount_lock);
+		br_write_unlock(&vfsmount_lock);
 
 		if (!xchg(&mnt->mnt_expiry_mark, 1))
 			return -EAGAIN;
@@ -1159,7 +1160,7 @@ static int do_umount(struct mount *mnt, 
 	}
 
 	down_write(&namespace_sem);
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	event++;
 
 	if (!(flags & MNT_DETACH))
@@ -1171,7 +1172,7 @@ static int do_umount(struct mount *mnt, 
 			umount_tree(mnt, 1, &umount_list);
 		retval = 0;
 	}
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 	up_write(&namespace_sem);
 	release_mounts(&umount_list);
 	return retval;
@@ -1286,19 +1287,19 @@ struct mount *copy_tree(struct mount *mn
 			q = clone_mnt(p, p->mnt.mnt_root, flag);
 			if (!q)
 				goto Enomem;
-			br_write_lock(vfsmount_lock);
+			br_write_lock(&vfsmount_lock);
 			list_add_tail(&q->mnt_list, &res->mnt_list);
 			attach_mnt(q, &path);
-			br_write_unlock(vfsmount_lock);
+			br_write_unlock(&vfsmount_lock);
 		}
 	}
 	return res;
 Enomem:
 	if (res) {
 		LIST_HEAD(umount_list);
-		br_write_lock(vfsmount_lock);
+		br_write_lock(&vfsmount_lock);
 		umount_tree(res, 0, &umount_list);
-		br_write_unlock(vfsmount_lock);
+		br_write_unlock(&vfsmount_lock);
 		release_mounts(&umount_list);
 	}
 	return NULL;
@@ -1318,9 +1319,9 @@ void drop_collected_mounts(struct vfsmou
 {
 	LIST_HEAD(umount_list);
 	down_write(&namespace_sem);
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	umount_tree(real_mount(mnt), 0, &umount_list);
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 	up_write(&namespace_sem);
 	release_mounts(&umount_list);
 }
@@ -1448,7 +1449,7 @@ static int attach_recursive_mnt(struct m
 	if (err)
 		goto out_cleanup_ids;
 
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 
 	if (IS_MNT_SHARED(dest_mnt)) {
 		for (p = source_mnt; p; p = next_mnt(p, source_mnt))
@@ -1467,7 +1468,7 @@ static int attach_recursive_mnt(struct m
 		list_del_init(&child->mnt_hash);
 		commit_tree(child);
 	}
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 
 	return 0;
 
@@ -1565,10 +1566,10 @@ static int do_change_type(struct path *p
 			goto out_unlock;
 	}
 
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	for (m = mnt; m; m = (recurse ? next_mnt(m, mnt) : NULL))
 		change_mnt_propagation(m, type);
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 
  out_unlock:
 	up_write(&namespace_sem);
@@ -1617,9 +1618,9 @@ static int do_loopback(struct path *path
 
 	err = graft_tree(mnt, path);
 	if (err) {
-		br_write_lock(vfsmount_lock);
+		br_write_lock(&vfsmount_lock);
 		umount_tree(mnt, 0, &umount_list);
-		br_write_unlock(vfsmount_lock);
+		br_write_unlock(&vfsmount_lock);
 	}
 out2:
 	unlock_mount(path);
@@ -1677,16 +1678,16 @@ static int do_remount(struct path *path,
 	else
 		err = do_remount_sb(sb, flags, data, 0);
 	if (!err) {
-		br_write_lock(vfsmount_lock);
+		br_write_lock(&vfsmount_lock);
 		mnt_flags |= mnt->mnt.mnt_flags & MNT_PROPAGATION_MASK;
 		mnt->mnt.mnt_flags = mnt_flags;
-		br_write_unlock(vfsmount_lock);
+		br_write_unlock(&vfsmount_lock);
 	}
 	up_write(&sb->s_umount);
 	if (!err) {
-		br_write_lock(vfsmount_lock);
+		br_write_lock(&vfsmount_lock);
 		touch_mnt_namespace(mnt->mnt_ns);
-		br_write_unlock(vfsmount_lock);
+		br_write_unlock(&vfsmount_lock);
 	}
 	return err;
 }
@@ -1893,9 +1894,9 @@ fail:
 	/* remove m from any expiration list it may be on */
 	if (!list_empty(&mnt->mnt_expire)) {
 		down_write(&namespace_sem);
-		br_write_lock(vfsmount_lock);
+		br_write_lock(&vfsmount_lock);
 		list_del_init(&mnt->mnt_expire);
-		br_write_unlock(vfsmount_lock);
+		br_write_unlock(&vfsmount_lock);
 		up_write(&namespace_sem);
 	}
 	mntput(m);
@@ -1911,11 +1912,11 @@ fail:
 void mnt_set_expiry(struct vfsmount *mnt, struct list_head *expiry_list)
 {
 	down_write(&namespace_sem);
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 
 	list_add_tail(&real_mount(mnt)->mnt_expire, expiry_list);
 
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 	up_write(&namespace_sem);
 }
 EXPORT_SYMBOL(mnt_set_expiry);
@@ -1935,7 +1936,7 @@ void mark_mounts_for_expiry(struct list_
 		return;
 
 	down_write(&namespace_sem);
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 
 	/* extract from the expiration list every vfsmount that matches the
 	 * following criteria:
@@ -1954,7 +1955,7 @@ void mark_mounts_for_expiry(struct list_
 		touch_mnt_namespace(mnt->mnt_ns);
 		umount_tree(mnt, 1, &umounts);
 	}
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 	up_write(&namespace_sem);
 
 	release_mounts(&umounts);
@@ -2218,9 +2219,9 @@ void mnt_make_shortterm(struct vfsmount 
 	struct mount *mnt = real_mount(m);
 	if (atomic_add_unless(&mnt->mnt_longterm, -1, 1))
 		return;
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	atomic_dec(&mnt->mnt_longterm);
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 #endif
 }
 
@@ -2249,10 +2250,9 @@ static struct mnt_namespace *dup_mnt_ns(
 		kfree(new_ns);
 		return ERR_PTR(-ENOMEM);
 	}
-	new_ns->root = new;
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	list_add_tail(&new_ns->list, &new->mnt_list);
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 
 	/*
 	 * Second pass: switch the tsk->fs->* elements and mark new vfsmounts
@@ -2416,9 +2416,9 @@ bool is_path_reachable(struct mount *mnt
 int path_is_under(struct path *path1, struct path *path2)
 {
 	int res;
-	br_read_lock(vfsmount_lock);
+	br_read_lock(&vfsmount_lock);
 	res = is_path_reachable(real_mount(path1->mnt), path1->dentry, path2);
-	br_read_unlock(vfsmount_lock);
+	br_read_unlock(&vfsmount_lock);
 	return res;
 }
 EXPORT_SYMBOL(path_is_under);
@@ -2505,7 +2505,7 @@ SYSCALL_DEFINE2(pivot_root, const char _
 	/* make sure we can reach put_old from new_root */
 	if (!is_path_reachable(real_mount(old.mnt), old.dentry, &new))
 		goto out4;
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	detach_mnt(new_mnt, &parent_path);
 	detach_mnt(root_mnt, &root_parent);
 	/* mount old root on put_old */
@@ -2513,7 +2513,7 @@ SYSCALL_DEFINE2(pivot_root, const char _
 	/* mount new_root on / */
 	attach_mnt(new_mnt, &root_parent);
 	touch_mnt_namespace(current->nsproxy->mnt_ns);
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 	chroot_fs_refs(&root, &new);
 	error = 0;
 out4:
@@ -2576,7 +2576,7 @@ void __init mnt_init(void)
 	for (u = 0; u < HASH_SIZE; u++)
 		INIT_LIST_HEAD(&mount_hashtable[u]);
 
-	br_lock_init(vfsmount_lock);
+	br_lock_init(&vfsmount_lock);
 
 	err = sysfs_init();
 	if (err)
@@ -2596,9 +2596,9 @@ void put_mnt_ns(struct mnt_namespace *ns
 	if (!atomic_dec_and_test(&ns->count))
 		return;
 	down_write(&namespace_sem);
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	umount_tree(ns->root, 0, &umount_list);
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 	up_write(&namespace_sem);
 	release_mounts(&umount_list);
 	kfree(ns);
diff -puN fs/pnode.c~clean-up-brlocks-lglocks-v2 fs/pnode.c
--- a/fs/pnode.c~clean-up-brlocks-lglocks-v2
+++ a/fs/pnode.c
@@ -257,12 +257,12 @@ int propagate_mnt(struct mount *dest_mnt
 		prev_src_mnt  = child;
 	}
 out:
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	while (!list_empty(&tmp_list)) {
 		child = list_first_entry(&tmp_list, struct mount, mnt_hash);
 		umount_tree(child, 0, &umount_list);
 	}
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 	release_mounts(&umount_list);
 	return ret;
 }
diff -puN fs/proc_namespace.c~clean-up-brlocks-lglocks-v2 fs/proc_namespace.c
--- a/fs/proc_namespace.c~clean-up-brlocks-lglocks-v2
+++ a/fs/proc_namespace.c
@@ -23,12 +23,12 @@ static unsigned mounts_poll(struct file 
 
 	poll_wait(file, &p->ns->poll, wait);
 
-	br_read_lock(vfsmount_lock);
+	br_read_lock(&vfsmount_lock);
 	if (p->m.poll_event != ns->event) {
 		p->m.poll_event = ns->event;
 		res |= POLLERR | POLLPRI;
 	}
-	br_read_unlock(vfsmount_lock);
+	br_read_unlock(&vfsmount_lock);
 
 	return res;
 }
diff -puN include/linux/lglock.h~clean-up-brlocks-lglocks-v2 include/linux/lglock.h
--- a/include/linux/lglock.h~clean-up-brlocks-lglocks-v2
+++ a/include/linux/lglock.h
@@ -23,28 +23,17 @@
 #include <linux/lockdep.h>
 #include <linux/percpu.h>
 #include <linux/cpu.h>
+#include <linux/notifier.h>
 
 /* can make br locks by using local lock for read side, global lock for write */
-#define br_lock_init(name)	name##_lock_init()
-#define br_read_lock(name)	name##_local_lock()
-#define br_read_unlock(name)	name##_local_unlock()
-#define br_write_lock(name)	name##_global_lock_online()
-#define br_write_unlock(name)	name##_global_unlock_online()
+#define br_lock_init(name)	lg_lock_init(name, #name)
+#define br_read_lock(name)	lg_local_lock(name)
+#define br_read_unlock(name)	lg_local_unlock(name)
+#define br_write_lock(name)	lg_global_lock_online(name)
+#define br_write_unlock(name)	lg_global_unlock_online(name)
 
-#define DECLARE_BRLOCK(name)	DECLARE_LGLOCK(name)
 #define DEFINE_BRLOCK(name)	DEFINE_LGLOCK(name)
 
-
-#define lg_lock_init(name)	name##_lock_init()
-#define lg_local_lock(name)	name##_local_lock()
-#define lg_local_unlock(name)	name##_local_unlock()
-#define lg_local_lock_cpu(name, cpu)	name##_local_lock_cpu(cpu)
-#define lg_local_unlock_cpu(name, cpu)	name##_local_unlock_cpu(cpu)
-#define lg_global_lock(name)	name##_global_lock()
-#define lg_global_unlock(name)	name##_global_unlock()
-#define lg_global_lock_online(name) name##_global_lock_online()
-#define lg_global_unlock_online(name) name##_global_unlock_online()
-
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 #define LOCKDEP_INIT_MAP lockdep_init_map
 
@@ -59,142 +48,34 @@
 #define DEFINE_LGLOCK_LOCKDEP(name)
 #endif
 
+struct lglock {
+	arch_spinlock_t __percpu *lock;
+	cpumask_t cpus;	/* XXX need to put on separate cacheline? */
+	spinlock_t cpu_lock;
+	struct notifier_block cpu_notifier;
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lock_class_key lock_key;
+	struct lockdep_map    lock_dep_map;
+#endif 
+};
+
+#define DEFINE_LGLOCK(name) \
+	DEFINE_PER_CPU(arch_spinlock_t, name ## _lock) = __ARCH_SPIN_LOCK_UNLOCKED; \
+	struct lglock name = { .lock = &name ## _lock, 				\
+			       .cpu_lock = __SPIN_LOCK_UNLOCKED(cpu_lock), 	\
+			       .cpu_notifier.notifier_call = lg_cpu_callback }
+
+/* Only valid for statics */
+void lg_lock_init(struct lglock *lg, char *name);
+void lg_local_lock(struct lglock *lg);
+void lg_local_unlock(struct lglock *lg);
+void lg_local_lock_cpu(struct lglock *lg, int cpu);
+void lg_local_unlock_cpu(struct lglock *lg, int cpu);
+void lg_global_lock_online(struct lglock *lg);
+void lg_global_unlock_online(struct lglock *lg);
+void lg_global_lock(struct lglock *lg);
+void lg_global_unlock(struct lglock *lg);
+
+int lg_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu);
 
-#define DECLARE_LGLOCK(name)						\
- extern void name##_lock_init(void);					\
- extern void name##_local_lock(void);					\
- extern void name##_local_unlock(void);					\
- extern void name##_local_lock_cpu(int cpu);				\
- extern void name##_local_unlock_cpu(int cpu);				\
- extern void name##_global_lock(void);					\
- extern void name##_global_unlock(void);				\
- extern void name##_global_lock_online(void);				\
- extern void name##_global_unlock_online(void);				\
-
-#define DEFINE_LGLOCK(name)						\
-									\
- DEFINE_SPINLOCK(name##_cpu_lock);					\
- cpumask_t name##_cpus __read_mostly;					\
- DEFINE_PER_CPU(arch_spinlock_t, name##_lock);				\
- DEFINE_LGLOCK_LOCKDEP(name);						\
-									\
- static int								\
- name##_lg_cpu_callback(struct notifier_block *nb,			\
-				unsigned long action, void *hcpu)	\
- {									\
-	switch (action & ~CPU_TASKS_FROZEN) {				\
-	case CPU_UP_PREPARE:						\
-		spin_lock(&name##_cpu_lock);				\
-		cpu_set((unsigned long)hcpu, name##_cpus);		\
-		spin_unlock(&name##_cpu_lock);				\
-		break;							\
-	case CPU_UP_CANCELED: case CPU_DEAD:				\
-		spin_lock(&name##_cpu_lock);				\
-		cpu_clear((unsigned long)hcpu, name##_cpus);		\
-		spin_unlock(&name##_cpu_lock);				\
-	}								\
-	return NOTIFY_OK;						\
- }									\
- static struct notifier_block name##_lg_cpu_notifier = {		\
-	.notifier_call = name##_lg_cpu_callback,			\
- };									\
- void name##_lock_init(void) {						\
-	int i;								\
-	LOCKDEP_INIT_MAP(&name##_lock_dep_map, #name, &name##_lock_key, 0); \
-	for_each_possible_cpu(i) {					\
-		arch_spinlock_t *lock;					\
-		lock = &per_cpu(name##_lock, i);			\
-		*lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;	\
-	}								\
-	register_hotcpu_notifier(&name##_lg_cpu_notifier);		\
-	get_online_cpus();						\
-	for_each_online_cpu(i)						\
-		cpu_set(i, name##_cpus);				\
-	put_online_cpus();						\
- }									\
- EXPORT_SYMBOL(name##_lock_init);					\
-									\
- void name##_local_lock(void) {						\
-	arch_spinlock_t *lock;						\
-	preempt_disable();						\
-	rwlock_acquire_read(&name##_lock_dep_map, 0, 0, _THIS_IP_);	\
-	lock = &__get_cpu_var(name##_lock);				\
-	arch_spin_lock(lock);						\
- }									\
- EXPORT_SYMBOL(name##_local_lock);					\
-									\
- void name##_local_unlock(void) {					\
-	arch_spinlock_t *lock;						\
-	rwlock_release(&name##_lock_dep_map, 1, _THIS_IP_);		\
-	lock = &__get_cpu_var(name##_lock);				\
-	arch_spin_unlock(lock);						\
-	preempt_enable();						\
- }									\
- EXPORT_SYMBOL(name##_local_unlock);					\
-									\
- void name##_local_lock_cpu(int cpu) {					\
-	arch_spinlock_t *lock;						\
-	preempt_disable();						\
-	rwlock_acquire_read(&name##_lock_dep_map, 0, 0, _THIS_IP_);	\
-	lock = &per_cpu(name##_lock, cpu);				\
-	arch_spin_lock(lock);						\
- }									\
- EXPORT_SYMBOL(name##_local_lock_cpu);					\
-									\
- void name##_local_unlock_cpu(int cpu) {				\
-	arch_spinlock_t *lock;						\
-	rwlock_release(&name##_lock_dep_map, 1, _THIS_IP_);		\
-	lock = &per_cpu(name##_lock, cpu);				\
-	arch_spin_unlock(lock);						\
-	preempt_enable();						\
- }									\
- EXPORT_SYMBOL(name##_local_unlock_cpu);				\
-									\
- void name##_global_lock_online(void) {					\
-	int i;								\
-	spin_lock(&name##_cpu_lock);					\
-	rwlock_acquire(&name##_lock_dep_map, 0, 0, _RET_IP_);		\
-	for_each_cpu(i, &name##_cpus) {					\
-		arch_spinlock_t *lock;					\
-		lock = &per_cpu(name##_lock, i);			\
-		arch_spin_lock(lock);					\
-	}								\
- }									\
- EXPORT_SYMBOL(name##_global_lock_online);				\
-									\
- void name##_global_unlock_online(void) {				\
-	int i;								\
-	rwlock_release(&name##_lock_dep_map, 1, _RET_IP_);		\
-	for_each_cpu(i, &name##_cpus) {					\
-		arch_spinlock_t *lock;					\
-		lock = &per_cpu(name##_lock, i);			\
-		arch_spin_unlock(lock);					\
-	}								\
-	spin_unlock(&name##_cpu_lock);					\
- }									\
- EXPORT_SYMBOL(name##_global_unlock_online);				\
-									\
- void name##_global_lock(void) {					\
-	int i;								\
-	preempt_disable();						\
-	rwlock_acquire(&name##_lock_dep_map, 0, 0, _RET_IP_);		\
-	for_each_possible_cpu(i) {					\
-		arch_spinlock_t *lock;					\
-		lock = &per_cpu(name##_lock, i);			\
-		arch_spin_lock(lock);					\
-	}								\
- }									\
- EXPORT_SYMBOL(name##_global_lock);					\
-									\
- void name##_global_unlock(void) {					\
-	int i;								\
-	rwlock_release(&name##_lock_dep_map, 1, _RET_IP_);		\
-	for_each_possible_cpu(i) {					\
-		arch_spinlock_t *lock;					\
-		lock = &per_cpu(name##_lock, i);			\
-		arch_spin_unlock(lock);					\
-	}								\
-	preempt_enable();						\
- }									\
- EXPORT_SYMBOL(name##_global_unlock);
 #endif
diff -puN kernel/Makefile~clean-up-brlocks-lglocks-v2 kernel/Makefile
--- a/kernel/Makefile~clean-up-brlocks-lglocks-v2
+++ a/kernel/Makefile
@@ -10,7 +10,7 @@ obj-y     = fork.o exec_domain.o panic.o
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o cred.o \
-	    async.o range.o groups.o
+	    async.o range.o groups.o lglock.o
 
 ifdef CONFIG_FUNCTION_TRACER
 # Do not trace debug files and internal ftrace files
diff -puN /dev/null kernel/lglock.c
--- /dev/null
+++ a/kernel/lglock.c
@@ -0,0 +1,136 @@
+/* See include/linux/lglock.h for description */
+#include <linux/module.h>
+#include <linux/lglock.h>
+#include <linux/cpu.h>
+#include <linux/string.h>
+
+/* Note there is no uninit, so lglocks cannot be defined in 
+ * modules (but it's fine to use them from there) 
+ * Could be added though, just undo lg_lock_init
+ */
+
+void lg_lock_init(struct lglock *lg, char *name) 
+{
+	int i;
+
+	LOCKDEP_INIT_MAP(&lg->lock_dep_map, name, &lg->lock_key, 0);
+
+	register_hotcpu_notifier(&lg->cpu_notifier);
+	get_online_cpus();
+	for_each_online_cpu (i)
+		cpu_set(i, lg->cpus);
+	put_online_cpus();
+}
+EXPORT_SYMBOL(lg_lock_init);
+
+void lg_local_lock(struct lglock *lg) 
+{
+	arch_spinlock_t *lock;
+	preempt_disable();
+	rwlock_acquire_read(&lg->lock_dep_map, 0, 0, _RET_IP_);
+	lock = this_cpu_ptr(lg->lock);
+	arch_spin_lock(lock);
+}
+EXPORT_SYMBOL(lg_local_lock);
+
+void lg_local_unlock(struct lglock *lg) 
+{
+	arch_spinlock_t *lock;
+	rwlock_release(&lg->lock_dep_map, 1, _RET_IP_);
+	lock = this_cpu_ptr(lg->lock);
+	arch_spin_unlock(lock);
+	preempt_enable();
+}
+EXPORT_SYMBOL(lg_local_unlock);
+
+void lg_local_lock_cpu(struct lglock *lg, int cpu) 
+{
+	arch_spinlock_t *lock;
+	preempt_disable();
+	rwlock_acquire_read(&lg->lock_dep_map, 0, 0, _RET_IP_);
+	lock = per_cpu_ptr(lg->lock, cpu);
+	arch_spin_lock(lock);
+}
+EXPORT_SYMBOL(lg_local_lock_cpu);
+
+void lg_local_unlock_cpu(struct lglock *lg, int cpu) 
+{
+	arch_spinlock_t *lock;
+	rwlock_release(&lg->lock_dep_map, 1, _RET_IP_);
+	lock = per_cpu_ptr(lg->lock, cpu);
+	arch_spin_unlock(lock);
+	preempt_enable();
+}
+EXPORT_SYMBOL(lg_local_unlock_cpu);
+
+void lg_global_lock_online(struct lglock *lg) 
+{
+	int i;
+	spin_lock(&lg->cpu_lock);
+	rwlock_acquire(&lg->lock_dep_map, 0, 0, _RET_IP_);
+	for_each_cpu(i, &lg->cpus) {
+		arch_spinlock_t *lock;
+		lock = per_cpu_ptr(lg->lock, i);
+		arch_spin_lock(lock);
+	}
+}
+EXPORT_SYMBOL(lg_global_lock_online);
+
+void lg_global_unlock_online(struct lglock *lg)
+{
+	int i;
+	rwlock_release(&lg->lock_dep_map, 1, _RET_IP_);
+	for_each_cpu(i, &lg->cpus) {
+		arch_spinlock_t *lock;
+		lock = per_cpu_ptr(lg->lock, i);
+		arch_spin_unlock(lock);
+	}
+	spin_unlock(&lg->cpu_lock);
+}
+EXPORT_SYMBOL(lg_global_unlock_online);
+
+void lg_global_lock(struct lglock *lg)
+{
+	int i;
+	preempt_disable();
+	rwlock_acquire(&lg->lock_dep_map, 0, 0, _RET_IP_);
+	for_each_possible_cpu(i) {
+		arch_spinlock_t *lock;
+		lock = per_cpu_ptr(lg->lock, i);
+		arch_spin_lock(lock);
+	}
+}
+EXPORT_SYMBOL(lg_global_lock);
+
+void lg_global_unlock(struct lglock *lg)
+{
+	int i;
+	rwlock_release(&lg->lock_dep_map, 1, _RET_IP_);
+	for_each_possible_cpu(i) {
+		arch_spinlock_t *lock;
+		lock = per_cpu_ptr(lg->lock, i);
+		arch_spin_unlock(lock);
+	}
+	preempt_enable();
+}
+EXPORT_SYMBOL(lg_global_unlock);
+
+int lg_cpu_callback(struct notifier_block *nb,
+                              unsigned long action, void *hcpu)
+{                                                                     
+	struct lglock *lglock = container_of(nb, struct lglock, cpu_notifier);
+	switch (action & ~CPU_TASKS_FROZEN) {                           
+	case CPU_UP_PREPARE:                                            
+		spin_lock(&lglock->cpu_lock);                            
+		cpu_set((unsigned long)hcpu, lglock->cpus);              
+		spin_unlock(&lglock->cpu_lock);                          
+		break;                                                  
+	case CPU_UP_CANCELED: case CPU_DEAD:                            
+		spin_lock(&lglock->cpu_lock);                            
+		cpu_clear((unsigned long)hcpu, lglock->cpus);            
+		spin_unlock(&lglock->cpu_lock);                          
+	}                                                               
+	return NOTIFY_OK;              
+}
+EXPORT_SYMBOL(lg_cpu_callback);
+
_
Subject: Subject: brlocks/lglocks: cleanups

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
linux-next.patch
pagemap-avoid-splitting-thp-when-reading-proc-pid-pagemap.patch
brlocks-lglocks-cleanups.patch

