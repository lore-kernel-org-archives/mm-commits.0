From: akpm@google.com
Subject: + brlocks-lglocks-clean-up-code.patch added to -mm tree
Date: Thu, 29 Sep 2011 15:44:27 -0700
Message-ID: <201109292244.p8TMiRCd019659@wpaz24.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:48451 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049Ab1I2Won (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Sep 2011 18:44:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, npiggin@kernel.dk, viro@zeniv.linux.org.uk


The patch titled
     Subject: brlocks/lglocks: clean up code
has been added to the -mm tree.  Its filename is
     brlocks-lglocks-clean-up-code.patch

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
From: Andi Kleen <ak@linux.intel.com>
Subject: brlocks/lglocks: clean up code

lglocks and brlocks are currently generated with some complicated macros
in lglock.h.  But there's no reason I can see to not just use common
utility functions that get pointers to the lglock.

Since there are at least two users it makes sense to share this code in a
library.

This will also make it later possible to dynamically allocate lglocks.

In general the users now look more like normal function calls with
pointers, not magic macros.

The patch is rather large because I move over all users in one go to keep
it bisectable.  This impacts the VFS somewhat in terms of lines changed. 
But no actual behaviour change.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Nick Piggin <npiggin@kernel.dk>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 fs/dcache.c            |   10 +-
 fs/file_table.c        |   23 ++---
 fs/internal.h          |    3 
 fs/namei.c             |   26 +++---
 fs/namespace.c         |  124 +++++++++++++++----------------
 fs/pnode.c             |    4 -
 include/linux/lglock.h |  154 ++++++---------------------------------
 kernel/Makefile        |    2 
 kernel/lglock.c        |  101 +++++++++++++++++++++++++
 9 files changed, 223 insertions(+), 224 deletions(-)

diff -puN fs/dcache.c~brlocks-lglocks-clean-up-code fs/dcache.c
--- a/fs/dcache.c~brlocks-lglocks-clean-up-code
+++ a/fs/dcache.c
@@ -2415,7 +2415,7 @@ static int prepend_path(const struct pat
 	bool slash = false;
 	int error = 0;
 
-	br_read_lock(vfsmount_lock);
+	br_read_lock(&vfsmount_lock);
 	while (dentry != root->dentry || vfsmnt != root->mnt) {
 		struct dentry * parent;
 
@@ -2446,7 +2446,7 @@ out:
 	if (!error && !slash)
 		error = prepend(buffer, buflen, "/", 1);
 
-	br_read_unlock(vfsmount_lock);
+	br_read_unlock(&vfsmount_lock);
 	return error;
 
 global_root:
@@ -2801,11 +2801,11 @@ int path_is_under(struct path *path1, st
 	struct dentry *dentry = path1->dentry;
 	int res;
 
-	br_read_lock(vfsmount_lock);
+	br_read_lock(&vfsmount_lock);
 	if (mnt != path2->mnt) {
 		for (;;) {
 			if (mnt->mnt_parent == mnt) {
-				br_read_unlock(vfsmount_lock);
+				br_read_unlock(&vfsmount_lock);
 				return 0;
 			}
 			if (mnt->mnt_parent == path2->mnt)
@@ -2815,7 +2815,7 @@ int path_is_under(struct path *path1, st
 		dentry = mnt->mnt_mountpoint;
 	}
 	res = is_subdir(dentry, path2->dentry);
-	br_read_unlock(vfsmount_lock);
+	br_read_unlock(&vfsmount_lock);
 	return res;
 }
 EXPORT_SYMBOL(path_is_under);
diff -puN fs/file_table.c~brlocks-lglocks-clean-up-code fs/file_table.c
--- a/fs/file_table.c~brlocks-lglocks-clean-up-code
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
 
@@ -478,7 +477,7 @@ int fs_may_remount_ro(struct super_block
 {
 	struct file *file;
 	/* Check that no files are currently opened for writing. */
-	lg_global_lock(files_lglock);
+	lg_global_lock(&files_lglock);
 	do_file_list_for_each_entry(sb, file) {
 		struct inode *inode = file->f_path.dentry->d_inode;
 
@@ -490,10 +489,10 @@ int fs_may_remount_ro(struct super_block
 		if (S_ISREG(inode->i_mode) && (file->f_mode & FMODE_WRITE))
 			goto too_bad;
 	} while_file_list_for_each_entry;
-	lg_global_unlock(files_lglock);
+	lg_global_unlock(&files_lglock);
 	return 1; /* Tis' cool bro. */
 too_bad:
-	lg_global_unlock(files_lglock);
+	lg_global_unlock(&files_lglock);
 	return 0;
 }
 
@@ -509,7 +508,7 @@ void mark_files_ro(struct super_block *s
 	struct file *f;
 
 retry:
-	lg_global_lock(files_lglock);
+	lg_global_lock(&files_lglock);
 	do_file_list_for_each_entry(sb, f) {
 		struct vfsmount *mnt;
 		if (!S_ISREG(f->f_path.dentry->d_inode->i_mode))
@@ -526,12 +525,12 @@ retry:
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
@@ -549,6 +548,6 @@ void __init files_init(unsigned long mem
 	n = (mempages * (PAGE_SIZE / 1024)) / 10;
 	files_stat.max_files = max_t(unsigned long, n, NR_FILE);
 	files_defer_init();
-	lg_lock_init(files_lglock);
+	lg_lock_init(&files_lglock, "files_lglock");
 	percpu_counter_init(&nr_files, 0);
 } 
diff -puN fs/internal.h~brlocks-lglocks-clean-up-code fs/internal.h
--- a/fs/internal.h~brlocks-lglocks-clean-up-code
+++ a/fs/internal.h
@@ -77,8 +77,7 @@ extern void mnt_make_shortterm(struct vf
 
 extern void __init mnt_init(void);
 
-DECLARE_BRLOCK(vfsmount_lock);
-
+extern struct lglock vfsmount_lock;
 
 /*
  * fs_struct.c
diff -puN fs/namei.c~brlocks-lglocks-clean-up-code fs/namei.c
--- a/fs/namei.c~brlocks-lglocks-clean-up-code
+++ a/fs/namei.c
@@ -469,7 +469,7 @@ static int unlazy_walk(struct nameidata 
 	mntget(nd->path.mnt);
 
 	rcu_read_unlock();
-	br_read_unlock(vfsmount_lock);
+	br_read_unlock(&vfsmount_lock);
 	nd->flags &= ~LOOKUP_RCU;
 	return 0;
 
@@ -527,14 +527,14 @@ static int complete_walk(struct nameidat
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
@@ -699,15 +699,15 @@ int follow_up(struct path *path)
 	struct vfsmount *parent;
 	struct dentry *mountpoint;
 
-	br_read_lock(vfsmount_lock);
+	br_read_lock(&vfsmount_lock);
 	parent = path->mnt->mnt_parent;
 	if (parent == path->mnt) {
-		br_read_unlock(vfsmount_lock);
+		br_read_unlock(&vfsmount_lock);
 		return 0;
 	}
 	mntget(parent);
 	mountpoint = dget(path->mnt->mnt_mountpoint);
-	br_read_unlock(vfsmount_lock);
+	br_read_unlock(&vfsmount_lock);
 	dput(path->dentry);
 	path->dentry = mountpoint;
 	mntput(path->mnt);
@@ -839,7 +839,7 @@ static int follow_managed(struct path *p
 			/* Something is mounted on this dentry in another
 			 * namespace and/or whatever was mounted there in this
 			 * namespace got unmounted before we managed to get the
-			 * vfsmount_lock */
+			 * &vfsmount_lock */
 		}
 
 		/* Handle an automount point */
@@ -964,7 +964,7 @@ failed:
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
diff -puN fs/namespace.c~brlocks-lglocks-clean-up-code fs/namespace.c
--- a/fs/namespace.c~brlocks-lglocks-clean-up-code
+++ a/fs/namespace.c
@@ -421,7 +421,7 @@ static int mnt_make_readonly(struct vfsm
 {
 	int ret = 0;
 
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	mnt->mnt_flags |= MNT_WRITE_HOLD;
 	/*
 	 * After storing MNT_WRITE_HOLD, we'll read the counters. This store
@@ -455,15 +455,15 @@ static int mnt_make_readonly(struct vfsm
 	 */
 	smp_wmb();
 	mnt->mnt_flags &= ~MNT_WRITE_HOLD;
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 	return ret;
 }
 
 static void __mnt_unmake_readonly(struct vfsmount *mnt)
 {
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	mnt->mnt_flags &= ~MNT_READONLY;
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 }
 
 static void free_vfsmnt(struct vfsmount *mnt)
@@ -510,10 +510,10 @@ struct vfsmount *lookup_mnt(struct path 
 {
 	struct vfsmount *child_mnt;
 
-	br_read_lock(vfsmount_lock);
+	br_read_lock(&vfsmount_lock);
 	if ((child_mnt = __lookup_mnt(path->mnt, path->dentry, 1)))
 		mntget(child_mnt);
-	br_read_unlock(vfsmount_lock);
+	br_read_unlock(&vfsmount_lock);
 	return child_mnt;
 }
 
@@ -778,34 +778,34 @@ static void mntput_no_expire(struct vfsm
 {
 put_again:
 #ifdef CONFIG_SMP
-	br_read_lock(vfsmount_lock);
+	br_read_lock(&vfsmount_lock);
 	if (likely(atomic_read(&mnt->mnt_longterm))) {
 		mnt_dec_count(mnt);
-		br_read_unlock(vfsmount_lock);
+		br_read_unlock(&vfsmount_lock);
 		return;
 	}
-	br_read_unlock(vfsmount_lock);
+	br_read_unlock(&vfsmount_lock);
 
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	mnt_dec_count(mnt);
 	if (mnt_get_count(mnt)) {
-		br_write_unlock(vfsmount_lock);
+		br_write_unlock(&vfsmount_lock);
 		return;
 	}
 #else
 	mnt_dec_count(mnt);
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
 		acct_auto_close_mnt(mnt);
 		goto put_again;
 	}
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 	mntfree(mnt);
 }
 
@@ -830,20 +830,20 @@ EXPORT_SYMBOL(mntget);
 
 void mnt_pin(struct vfsmount *mnt)
 {
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	mnt->mnt_pinned++;
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 }
 EXPORT_SYMBOL(mnt_pin);
 
 void mnt_unpin(struct vfsmount *mnt)
 {
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	if (mnt->mnt_pinned) {
 		mnt_inc_count(mnt);
 		mnt->mnt_pinned--;
 	}
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 }
 EXPORT_SYMBOL(mnt_unpin);
 
@@ -933,12 +933,12 @@ int mnt_had_events(struct proc_mounts *p
 	struct mnt_namespace *ns = p->ns;
 	int res = 0;
 
-	br_read_lock(vfsmount_lock);
+	br_read_lock(&vfsmount_lock);
 	if (p->m.poll_event != ns->event) {
 		p->m.poll_event = ns->event;
 		res = 1;
 	}
-	br_read_unlock(vfsmount_lock);
+	br_read_unlock(&vfsmount_lock);
 
 	return res;
 }
@@ -1161,12 +1161,12 @@ int may_umount_tree(struct vfsmount *mnt
 	struct vfsmount *p;
 
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
@@ -1193,10 +1193,10 @@ int may_umount(struct vfsmount *mnt)
 {
 	int ret = 1;
 	down_read(&namespace_sem);
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	if (propagate_mount_busy(mnt, 2))
 		ret = 0;
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 	up_read(&namespace_sem);
 	return ret;
 }
@@ -1213,13 +1213,13 @@ void release_mounts(struct list_head *he
 			struct dentry *dentry;
 			struct vfsmount *m;
 
-			br_write_lock(vfsmount_lock);
+			br_write_lock(&vfsmount_lock);
 			dentry = mnt->mnt_mountpoint;
 			m = mnt->mnt_parent;
 			mnt->mnt_mountpoint = mnt->mnt_root;
 			mnt->mnt_parent = mnt;
 			m->mnt_ghosts--;
-			br_write_unlock(vfsmount_lock);
+			br_write_unlock(&vfsmount_lock);
 			dput(dentry);
 			mntput(m);
 		}
@@ -1285,12 +1285,12 @@ static int do_umount(struct vfsmount *mn
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
@@ -1332,7 +1332,7 @@ static int do_umount(struct vfsmount *mn
 	}
 
 	down_write(&namespace_sem);
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	event++;
 
 	if (!(flags & MNT_DETACH))
@@ -1344,7 +1344,7 @@ static int do_umount(struct vfsmount *mn
 			umount_tree(mnt, 1, &umount_list);
 		retval = 0;
 	}
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 	up_write(&namespace_sem);
 	release_mounts(&umount_list);
 	return retval;
@@ -1456,19 +1456,19 @@ struct vfsmount *copy_tree(struct vfsmou
 			q = clone_mnt(p, p->mnt_root, flag);
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
@@ -1487,9 +1487,9 @@ void drop_collected_mounts(struct vfsmou
 {
 	LIST_HEAD(umount_list);
 	down_write(&namespace_sem);
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	umount_tree(mnt, 0, &umount_list);
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 	up_write(&namespace_sem);
 	release_mounts(&umount_list);
 }
@@ -1617,7 +1617,7 @@ static int attach_recursive_mnt(struct v
 	if (err)
 		goto out_cleanup_ids;
 
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 
 	if (IS_MNT_SHARED(dest_mnt)) {
 		for (p = source_mnt; p; p = next_mnt(p, source_mnt))
@@ -1636,7 +1636,7 @@ static int attach_recursive_mnt(struct v
 		list_del_init(&child->mnt_hash);
 		commit_tree(child);
 	}
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 
 	return 0;
 
@@ -1733,10 +1733,10 @@ static int do_change_type(struct path *p
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
@@ -1783,9 +1783,9 @@ static int do_loopback(struct path *path
 
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
@@ -1842,16 +1842,16 @@ static int do_remount(struct path *path,
 	else
 		err = do_remount_sb(sb, flags, data, 0);
 	if (!err) {
-		br_write_lock(vfsmount_lock);
+		br_write_lock(&vfsmount_lock);
 		mnt_flags |= path->mnt->mnt_flags & MNT_PROPAGATION_MASK;
 		path->mnt->mnt_flags = mnt_flags;
-		br_write_unlock(vfsmount_lock);
+		br_write_unlock(&vfsmount_lock);
 	}
 	up_write(&sb->s_umount);
 	if (!err) {
-		br_write_lock(vfsmount_lock);
+		br_write_lock(&vfsmount_lock);
 		touch_mnt_namespace(path->mnt->mnt_ns);
-		br_write_unlock(vfsmount_lock);
+		br_write_unlock(&vfsmount_lock);
 	}
 	return err;
 }
@@ -2056,9 +2056,9 @@ fail:
 	/* remove m from any expiration list it may be on */
 	if (!list_empty(&m->mnt_expire)) {
 		down_write(&namespace_sem);
-		br_write_lock(vfsmount_lock);
+		br_write_lock(&vfsmount_lock);
 		list_del_init(&m->mnt_expire);
-		br_write_unlock(vfsmount_lock);
+		br_write_unlock(&vfsmount_lock);
 		up_write(&namespace_sem);
 	}
 	mntput(m);
@@ -2074,11 +2074,11 @@ fail:
 void mnt_set_expiry(struct vfsmount *mnt, struct list_head *expiry_list)
 {
 	down_write(&namespace_sem);
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 
 	list_add_tail(&mnt->mnt_expire, expiry_list);
 
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 	up_write(&namespace_sem);
 }
 EXPORT_SYMBOL(mnt_set_expiry);
@@ -2098,7 +2098,7 @@ void mark_mounts_for_expiry(struct list_
 		return;
 
 	down_write(&namespace_sem);
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 
 	/* extract from the expiration list every vfsmount that matches the
 	 * following criteria:
@@ -2117,7 +2117,7 @@ void mark_mounts_for_expiry(struct list_
 		touch_mnt_namespace(mnt->mnt_ns);
 		umount_tree(mnt, 1, &umounts);
 	}
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 	up_write(&namespace_sem);
 
 	release_mounts(&umounts);
@@ -2380,9 +2380,9 @@ void mnt_make_shortterm(struct vfsmount 
 #ifdef CONFIG_SMP
 	if (atomic_add_unless(&mnt->mnt_longterm, -1, 1))
 		return;
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	atomic_dec(&mnt->mnt_longterm);
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 #endif
 }
 
@@ -2410,9 +2410,9 @@ static struct mnt_namespace *dup_mnt_ns(
 		kfree(new_ns);
 		return ERR_PTR(-ENOMEM);
 	}
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	list_add_tail(&new_ns->list, &new_ns->root->mnt_list);
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 
 	/*
 	 * Second pass: switch the tsk->fs->* elements and mark new vfsmounts
@@ -2619,7 +2619,7 @@ SYSCALL_DEFINE2(pivot_root, const char _
 			goto out4;
 	} else if (!is_subdir(old.dentry, new.dentry))
 		goto out4;
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	detach_mnt(new.mnt, &parent_path);
 	detach_mnt(root.mnt, &root_parent);
 	/* mount old root on put_old */
@@ -2627,7 +2627,7 @@ SYSCALL_DEFINE2(pivot_root, const char _
 	/* mount new_root on / */
 	attach_mnt(new.mnt, &root_parent);
 	touch_mnt_namespace(current->nsproxy->mnt_ns);
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 	chroot_fs_refs(&root, &new);
 	error = 0;
 out4:
@@ -2690,7 +2690,7 @@ void __init mnt_init(void)
 	for (u = 0; u < HASH_SIZE; u++)
 		INIT_LIST_HEAD(&mount_hashtable[u]);
 
-	br_lock_init(vfsmount_lock);
+	br_lock_init(&vfsmount_lock);
 
 	err = sysfs_init();
 	if (err)
@@ -2710,9 +2710,9 @@ void put_mnt_ns(struct mnt_namespace *ns
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
diff -puN fs/pnode.c~brlocks-lglocks-clean-up-code fs/pnode.c
--- a/fs/pnode.c~brlocks-lglocks-clean-up-code
+++ a/fs/pnode.c
@@ -273,12 +273,12 @@ int propagate_mnt(struct vfsmount *dest_
 		prev_src_mnt  = child;
 	}
 out:
-	br_write_lock(vfsmount_lock);
+	br_write_lock(&vfsmount_lock);
 	while (!list_empty(&tmp_list)) {
 		child = list_first_entry(&tmp_list, struct vfsmount, mnt_hash);
 		umount_tree(child, 0, &umount_list);
 	}
-	br_write_unlock(vfsmount_lock);
+	br_write_unlock(&vfsmount_lock);
 	release_mounts(&umount_list);
 	return ret;
 }
diff -puN include/linux/lglock.h~brlocks-lglocks-clean-up-code include/linux/lglock.h
--- a/include/linux/lglock.h~brlocks-lglocks-clean-up-code
+++ a/include/linux/lglock.h
@@ -24,26 +24,14 @@
 #include <linux/percpu.h>
 
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
 
@@ -58,115 +46,27 @@
 #define DEFINE_LGLOCK_LOCKDEP(name)
 #endif
 
+struct lglock {
+	arch_spinlock_t __percpu *lock;
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lock_class_key lock_key;
+	struct lockdep_map    lock_dep_map;
+#endif 
+};
+
+#define DEFINE_LGLOCK(name) \
+	DEFINE_PER_CPU(arch_spinlock_t, name ## _lock) = __ARCH_SPIN_LOCK_UNLOCKED; \
+	struct lglock name = { .lock = &name ## _lock }
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
- DEFINE_PER_CPU(arch_spinlock_t, name##_lock);				\
- DEFINE_LGLOCK_LOCKDEP(name);						\
-									\
- void name##_lock_init(void) {						\
-	int i;								\
-	LOCKDEP_INIT_MAP(&name##_lock_dep_map, #name, &name##_lock_key, 0); \
-	for_each_possible_cpu(i) {					\
-		arch_spinlock_t *lock;					\
-		lock = &per_cpu(name##_lock, i);			\
-		*lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;	\
-	}								\
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
-	preempt_disable();						\
-	rwlock_acquire(&name##_lock_dep_map, 0, 0, _RET_IP_);		\
-	for_each_online_cpu(i) {					\
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
-	for_each_online_cpu(i) {					\
-		arch_spinlock_t *lock;					\
-		lock = &per_cpu(name##_lock, i);			\
-		arch_spin_unlock(lock);					\
-	}								\
-	preempt_enable();						\
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
diff -puN kernel/Makefile~brlocks-lglocks-clean-up-code kernel/Makefile
--- a/kernel/Makefile~brlocks-lglocks-clean-up-code
+++ a/kernel/Makefile
@@ -11,7 +11,7 @@ obj-y     = sched.o fork.o exec_domain.o
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o sched_clock.o cred.o \
 	    async.o range.o
-obj-y += groups.o
+obj-y += groups.o lglock.o
 
 ifdef CONFIG_FUNCTION_TRACER
 # Do not trace debug files and internal ftrace files
diff -puN /dev/null kernel/lglock.c
--- /dev/null
+++ a/kernel/lglock.c
@@ -0,0 +1,101 @@
+/* See include/linux/lglock.h for description */
+#include <linux/module.h>
+#include <linux/lglock.h>
+
+void lg_lock_init(struct lglock *lg, char *name) 
+{
+	LOCKDEP_INIT_MAP(&lg->lock_dep_map, name, &lg->lock_key, 0);
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
+	preempt_disable();
+	rwlock_acquire(&lg->lock_dep_map, 0, 0, _RET_IP_);
+	for_each_online_cpu(i) {
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
+	for_each_online_cpu(i) {
+		arch_spinlock_t *lock;
+		lock = per_cpu_ptr(lg->lock, i);
+		arch_spin_unlock(lock);
+	}
+	preempt_enable();
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
_
Subject: Subject: brlocks/lglocks: clean up code

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
linux-next.patch
brlocks-lglocks-clean-up-code.patch
hwpoison-convert-pr_debugs-to-pr_infos.patch
lib-bitmapc-quiet-sparse-noise-about-address-space.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch
dio-separate-fields-only-used-in-the-submission-path-from-struct-dio.patch
dio-separate-fields-only-used-in-the-submission-path-from-struct-dio-checkpatch-fixes.patch
dio-fix-a-wrong-comment.patch
dio-rearrange-fields-in-dio-dio_submit-to-avoid-holes.patch
dio-use-a-slab-cache-for-struct-dio.patch
dio-separate-map_bh-from-dio-v2.patch
dio-inline-the-complete-submission-path-v2.patch
dio-inline-the-complete-submission-path-v2-checkpatch-fixes.patch
dio-merge-direct_io_walker-into-__blockdev_direct_io.patch
dio-merge-direct_io_walker-into-__blockdev_direct_io-checkpatch-fixes.patch
dio-remove-unnecessary-dio-argument-from-dio_pages_present.patch
dio-remove-unused-dio-parameter-from-dio_bio_add_page.patch
vfs-cache-request_queue-in-struct-block_device.patch
dio-optimize-cache-misses-in-the-submission-path-v2.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
dio-optimize-cache-misses-in-the-submission-path-v2-fix.patch

