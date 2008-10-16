From: akpm@linux-foundation.org
Subject: + vfs-add-d_ancestor.patch added to -mm tree
Date: Thu, 16 Oct 2008 15:30:01 -0700
Message-ID: <200810162230.m9GMU1wS030898@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757098AbYJPWan (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 18:30:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     vfs: add d_ancestor()
has been added to the -mm tree.  Its filename is
     vfs-add-d_ancestor.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: add d_ancestor()
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

This adds d_ancestor() instead of d_isparent(), then use it.

If new_dentry == old_dentry, is_subdir() returns 1, looks strange.
"new_dentry == old_dentry" is not subdir obviously. But I'm not
checking callers for now, so this keeps current behavior.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c            |   45 +++++++++++++++++++--------------------
 fs/namei.c             |   22 ++++++++-----------
 include/linux/dcache.h |    1 
 3 files changed, 34 insertions(+), 34 deletions(-)

diff -puN fs/dcache.c~vfs-add-d_ancestor fs/dcache.c
--- a/fs/dcache.c~vfs-add-d_ancestor
+++ a/fs/dcache.c
@@ -1720,18 +1720,23 @@ void d_move(struct dentry * dentry, stru
 	spin_unlock(&dcache_lock);
 }
 
-/*
- * Helper that returns 1 if p1 is a parent of p2, else 0
+/**
+ * d_ancestor - search for an ancestor
+ * @p1: ancestor dentry
+ * @p2: child dentry
+ *
+ * Returns the ancestor dentry of p2 which is a child of p1, if p1 is
+ * an ancestor of p2, else NULL.
  */
-static int d_isparent(struct dentry *p1, struct dentry *p2)
+struct dentry *d_ancestor(struct dentry *p1, struct dentry *p2)
 {
 	struct dentry *p;
 
 	for (p = p2; !IS_ROOT(p); p = p->d_parent) {
 		if (p->d_parent == p1)
-			return 1;
+			return p;
 	}
-	return 0;
+	return NULL;
 }
 
 /*
@@ -1755,7 +1760,7 @@ static struct dentry *__d_unalias(struct
 
 	/* Check for loops */
 	ret = ERR_PTR(-ELOOP);
-	if (d_isparent(alias, dentry))
+	if (d_ancestor(alias, dentry))
 		goto out_err;
 
 	/* See lock_rename() */
@@ -2155,31 +2160,27 @@ out:
  * Caller must ensure that "new_dentry" is pinned before calling is_subdir()
  */
   
-int is_subdir(struct dentry * new_dentry, struct dentry * old_dentry)
+int is_subdir(struct dentry *new_dentry, struct dentry *old_dentry)
 {
 	int result;
-	struct dentry * saved = new_dentry;
 	unsigned long seq;
 
-	/* need rcu_readlock to protect against the d_parent trashing due to
-	 * d_move
+	/* FIXME: This is old behavior, needed? Please check callers. */
+	if (new_dentry == old_dentry)
+		return 1;
+
+	/*
+	 * Need rcu_readlock to protect against the d_parent trashing
+	 * due to d_move
 	 */
 	rcu_read_lock();
-        do {
+	do {
 		/* for restarting inner loop in case of seq retry */
-		new_dentry = saved;
-		result = 0;
 		seq = read_seqbegin(&rename_lock);
-		for (;;) {
-			if (new_dentry != old_dentry) {
-				if (IS_ROOT(new_dentry))
-					break;
-				new_dentry = new_dentry->d_parent;
-				continue;
-			}
+		if (d_ancestor(old_dentry, new_dentry))
 			result = 1;
-			break;
-		}
+		else
+			result = 0;
 	} while (read_seqretry(&rename_lock, seq));
 	rcu_read_unlock();
 
diff -puN fs/namei.c~vfs-add-d_ancestor fs/namei.c
--- a/fs/namei.c~vfs-add-d_ancestor
+++ a/fs/namei.c
@@ -1454,20 +1454,18 @@ struct dentry *lock_rename(struct dentry
 
 	mutex_lock(&p1->d_inode->i_sb->s_vfs_rename_mutex);
 
-	for (p = p1; !IS_ROOT(p); p = p->d_parent) {
-		if (p->d_parent == p2) {
-			mutex_lock_nested(&p2->d_inode->i_mutex, I_MUTEX_PARENT);
-			mutex_lock_nested(&p1->d_inode->i_mutex, I_MUTEX_CHILD);
-			return p;
-		}
+	p = d_ancestor(p2, p1);
+	if (p) {
+		mutex_lock_nested(&p2->d_inode->i_mutex, I_MUTEX_PARENT);
+		mutex_lock_nested(&p1->d_inode->i_mutex, I_MUTEX_CHILD);
+		return p;
 	}
 
-	for (p = p2; !IS_ROOT(p); p = p->d_parent) {
-		if (p->d_parent == p1) {
-			mutex_lock_nested(&p1->d_inode->i_mutex, I_MUTEX_PARENT);
-			mutex_lock_nested(&p2->d_inode->i_mutex, I_MUTEX_CHILD);
-			return p;
-		}
+	p = d_ancestor(p1, p2);
+	if (p) {
+		mutex_lock_nested(&p1->d_inode->i_mutex, I_MUTEX_PARENT);
+		mutex_lock_nested(&p2->d_inode->i_mutex, I_MUTEX_CHILD);
+		return p;
 	}
 
 	mutex_lock_nested(&p1->d_inode->i_mutex, I_MUTEX_PARENT);
diff -puN include/linux/dcache.h~vfs-add-d_ancestor include/linux/dcache.h
--- a/include/linux/dcache.h~vfs-add-d_ancestor
+++ a/include/linux/dcache.h
@@ -287,6 +287,7 @@ static inline struct dentry *d_add_uniqu
 
 /* used for rename() and baskets */
 extern void d_move(struct dentry *, struct dentry *);
+extern struct dentry *d_ancestor(struct dentry *, struct dentry *);
 
 /* appendix may either be NULL or be used for transname suffixes */
 extern struct dentry * d_lookup(struct dentry *, struct qstr *);
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

origin.patch
vfs-replace-parent-==-dentry-d_parent-by-is_root.patch
vfs-add-d_ancestor.patch
vfs-add-__d_instantiate-helper.patch
vfs-remove-unnecessary-fsnotify_d_instantiate.patch
vfs-remove-lookup_parent-from-non-lookup_parent-lookup.patch
vfs-add-lookup_rename_target-intent.patch
fat-document-additional-vfat-mount-options.patch
fat-move-fs-vfat-and-fs-msdos-to-fs-fat.patch
fat-split-include-msdos_fsh.patch
fat-fix-and-cleanup-timestamp-conversion.patch
fat-use-generic_file_llseek-for-directory.patch
fat-cleanup-fat_parse_long-error-handling.patch
fat-improve-fat_hash.patch
fat-fix-fat_ent_update_ptr-for-fat12.patch
fat-use-fat_detach-in-fat_clear_inode.patch
vfat-fix-vfat_find-error-path-in-vfat_lookup.patch
fat-fix-cleanup-dcache-handling-for-vfat.patch
fat-kill-d_invalidate-in-vfat_lookup.patch
fat-cleanup-msdos_lookup.patch
fat-cleanup-fat-attribute-stuff.patch
fat-fix-attr_ro-in-the-case-of-umask-s_wugo-==-0.patch
fat-fix-attr_ro-for-directory.patch
fat-fix-_fat_bmap-race.patch
fat-add-printf-attribute-to-fat_fs_panic.patch
fat-mmu_private-race-fix.patch
fat-i_pos-race-fix.patch
fat-i_blocks-warning-fix.patch

