From: akpm@linux-foundation.org
Subject: - dentries-extract-common-code-to-remove-dentry-from-lru.patch removed from -mm tree
Date: Thu, 14 Feb 2008 19:17:17 -0500
Message-ID: <200802150720.m1F7Kd8i025841@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41754 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760927AbYBOH3T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 02:29:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     dentries: Extract common code to remove dentry from lru
has been removed from the -mm tree.  Its filename was
     dentries-extract-common-code-to-remove-dentry-from-lru.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dentries: Extract common code to remove dentry from lru
From: Christoph Lameter <clameter@sgi.com>

Extract the common code to remove a dentry from the lru into a new function
dentry_lru_remove().

Two call sites used list_del() instead of list_del_init().  AFAIK the
performance of both is the same.  dentry_lru_remove() does a list_del_init().

As a result dentry->d_lru is now always empty when a dentry is freed.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |   42 ++++++++++++++----------------------------
 1 file changed, 14 insertions(+), 28 deletions(-)

diff -puN fs/dcache.c~dentries-extract-common-code-to-remove-dentry-from-lru fs/dcache.c
--- a/fs/dcache.c~dentries-extract-common-code-to-remove-dentry-from-lru
+++ a/fs/dcache.c
@@ -95,6 +95,14 @@ static void d_free(struct dentry *dentry
 		call_rcu(&dentry->d_u.d_rcu, d_callback);
 }
 
+static void dentry_lru_remove(struct dentry *dentry)
+{
+	if (!list_empty(&dentry->d_lru)) {
+		list_del_init(&dentry->d_lru);
+		dentry_stat.nr_unused--;
+	}
+}
+
 /*
  * Release the dentry's inode, using the filesystem
  * d_iput() operation if defined.
@@ -211,13 +219,7 @@ repeat:
 unhash_it:
 	__d_drop(dentry);
 kill_it:
-	/* If dentry was on d_lru list
-	 * delete it from there
-	 */
-	if (!list_empty(&dentry->d_lru)) {
-		list_del(&dentry->d_lru);
-		dentry_stat.nr_unused--;
-	}
+	dentry_lru_remove(dentry);
 	dentry = d_kill(dentry);
 	if (dentry)
 		goto repeat;
@@ -285,10 +287,7 @@ int d_invalidate(struct dentry * dentry)
 static inline struct dentry * __dget_locked(struct dentry *dentry)
 {
 	atomic_inc(&dentry->d_count);
-	if (!list_empty(&dentry->d_lru)) {
-		dentry_stat.nr_unused--;
-		list_del_init(&dentry->d_lru);
-	}
+	dentry_lru_remove(dentry);
 	return dentry;
 }
 
@@ -404,10 +403,7 @@ static void prune_one_dentry(struct dent
 
 		if (dentry->d_op && dentry->d_op->d_delete)
 			dentry->d_op->d_delete(dentry);
-		if (!list_empty(&dentry->d_lru)) {
-			list_del(&dentry->d_lru);
-			dentry_stat.nr_unused--;
-		}
+		dentry_lru_remove(dentry);
 		__d_drop(dentry);
 		dentry = d_kill(dentry);
 		spin_lock(&dcache_lock);
@@ -596,10 +592,7 @@ static void shrink_dcache_for_umount_sub
 
 	/* detach this root from the system */
 	spin_lock(&dcache_lock);
-	if (!list_empty(&dentry->d_lru)) {
-		dentry_stat.nr_unused--;
-		list_del_init(&dentry->d_lru);
-	}
+	dentry_lru_remove(dentry);
 	__d_drop(dentry);
 	spin_unlock(&dcache_lock);
 
@@ -613,11 +606,7 @@ static void shrink_dcache_for_umount_sub
 			spin_lock(&dcache_lock);
 			list_for_each_entry(loop, &dentry->d_subdirs,
 					    d_u.d_child) {
-				if (!list_empty(&loop->d_lru)) {
-					dentry_stat.nr_unused--;
-					list_del_init(&loop->d_lru);
-				}
-
+				dentry_lru_remove(loop);
 				__d_drop(loop);
 				cond_resched_lock(&dcache_lock);
 			}
@@ -799,10 +788,7 @@ resume:
 		struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
 		next = tmp->next;
 
-		if (!list_empty(&dentry->d_lru)) {
-			dentry_stat.nr_unused--;
-			list_del_init(&dentry->d_lru);
-		}
+		dentry_lru_remove(dentry);
 		/* 
 		 * move only zero ref count dentries to the end 
 		 * of the unused list for prune_dcache
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
gregkh-driver-kset-move-sys-slab-to-sys-kernel-slab-slabinfo-fallback-from-sys-kernel-slab-to-sys-slab.patch
git-unionfs.patch
git-slub.patch
x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch
remove-set_migrateflags.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch
