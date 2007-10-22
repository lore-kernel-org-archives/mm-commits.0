From: akpm@linux-foundation.org
Subject: + dentries-extract-common-code-to-remove-dentry-from-lru.patch added to -mm tree
Date: Mon, 22 Oct 2007 14:34:03 -0700
Message-ID: <200710222134.l9MLY36Z016111@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41436 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751339AbXJVVeH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Oct 2007 17:34:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     dentries: Extract common code to remove dentry from lru
has been added to the -mm tree.  Its filename is
     dentries-extract-common-code-to-remove-dentry-from-lru.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
+				dentry_lru_remove(dentry);
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
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
mem-policy-fix-mempolicy-usage-in-pci-driver.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
git-x86.patch
slub-avoid-atomic-operation-for-slab_unlock.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
move-vmalloc_to_page-to-mm-vmalloc.patch
vmalloc-add-const-to-void-parameters.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries.patch
vmalloc-clean-up-page-array-indexing.patch
vunmap-return-page-array-passed-on-vmap.patch
slub-move-count_partial.patch
slub-rename-numa-defrag_ratio-to-remote_node_defrag_ratio.patch
slub-consolidate-add_partial-and-add_partial_tail-to-one-function.patch
vm-allow-get_page_unless_zero-on-compound-pages.patch
dentries-extract-common-code-to-remove-dentry-from-lru.patch
bufferhead-revert-constructor-removal.patch
revoke-core-code.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch
