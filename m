From: akpm@linux-foundation.org
Subject: [merged] tmpfs-take-control-of-its-truncate_range.patch removed from -mm tree
Date: Tue, 28 Jun 2011 13:42:20 -0700
Message-ID: <201106282042.p5SKg2ln002959@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750713Ab1F1Um1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Jun 2011 16:42:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, hch@infradead.org, mm-commits@vger.kernel.org


The patch titled
     tmpfs: take control of its truncate_range
has been removed from the -mm tree.  Its filename was
     tmpfs-take-control-of-its-truncate_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tmpfs: take control of its truncate_range
From: Hugh Dickins <hughd@google.com>

2.6.35's new truncate convention gave tmpfs the opportunity to control its
file truncation, no longer enforced from outside by vmtruncate().  We
shall want to build upon that, to handle pagecache and swap together.

Slightly redefine the ->truncate_range interface: let it now be called
between the unmap_mapping_range()s, with the filesystem responsible for
doing the truncate_inode_pages_range() from it - just as the filesystem is
nowadays responsible for doing that from its ->setattr.

Let's rename shmem_notify_change() to shmem_setattr().  Instead of calling
the generic truncate_setsize(), bring that code in so we can call
shmem_truncate_range() - which will later be updated to perform its own
variant of truncate_inode_pages_range().

Remove the punch_hole unmap_mapping_range() from shmem_truncate_range():
now that the COW's unmap_mapping_range() comes after ->truncate_range,
there is no need to call it a third time.

Export shmem_truncate_range() and add it to the list in shmem_fs.h, so
that i915_gem_object_truncate() can call it explicitly in future; get this
patch in first, then update drm/i915 once this is available (until then,
i915 will just be doing the truncate_inode_pages() twice).

Though introduced five years ago, no other filesystem is implementing
->truncate_range, and its only other user is madvise(,,MADV_REMOVE): we
expect to convert it to fallocate(,FALLOC_FL_PUNCH_HOLE,,) shortly,
whereupon ->truncate_range can be removed from inode_operations -
shmem_truncate_range() will help i915 across that transition too.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |    1 
 mm/shmem.c               |   51 +++++++++++++++++++++----------------
 mm/truncate.c            |    4 +-
 3 files changed, 32 insertions(+), 24 deletions(-)

diff -puN include/linux/shmem_fs.h~tmpfs-take-control-of-its-truncate_range include/linux/shmem_fs.h
--- a/include/linux/shmem_fs.h~tmpfs-take-control-of-its-truncate_range
+++ a/include/linux/shmem_fs.h
@@ -61,6 +61,7 @@ extern struct file *shmem_file_setup(con
 					loff_t size, unsigned long flags);
 extern int shmem_zero_setup(struct vm_area_struct *);
 extern int shmem_lock(struct file *file, int lock, struct user_struct *user);
+extern void shmem_truncate_range(struct inode *inode, loff_t start, loff_t end);
 extern int shmem_unuse(swp_entry_t entry, struct page *page);
 extern void mem_cgroup_get_shmem_target(struct inode *inode, pgoff_t pgoff,
 					struct page **pagep, swp_entry_t *ent);
diff -puN mm/shmem.c~tmpfs-take-control-of-its-truncate_range mm/shmem.c
--- a/mm/shmem.c~tmpfs-take-control-of-its-truncate_range
+++ a/mm/shmem.c
@@ -539,7 +539,7 @@ static void shmem_free_pages(struct list
 	} while (next);
 }
 
-static void shmem_truncate_range(struct inode *inode, loff_t start, loff_t end)
+void shmem_truncate_range(struct inode *inode, loff_t start, loff_t end)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	unsigned long idx;
@@ -562,6 +562,8 @@ static void shmem_truncate_range(struct 
 	spinlock_t *punch_lock;
 	unsigned long upper_limit;
 
+	truncate_inode_pages_range(inode->i_mapping, start, end);
+
 	inode->i_ctime = inode->i_mtime = CURRENT_TIME;
 	idx = (start + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 	if (idx >= info->next_index)
@@ -738,16 +740,8 @@ done2:
 		 * lowered next_index.  Also, though shmem_getpage checks
 		 * i_size before adding to cache, no recheck after: so fix the
 		 * narrow window there too.
-		 *
-		 * Recalling truncate_inode_pages_range and unmap_mapping_range
-		 * every time for punch_hole (which never got a chance to clear
-		 * SHMEM_PAGEIN at the start of vmtruncate_range) is expensive,
-		 * yet hardly ever necessary: try to optimize them out later.
 		 */
 		truncate_inode_pages_range(inode->i_mapping, start, end);
-		if (punch_hole)
-			unmap_mapping_range(inode->i_mapping, start,
-							end - start, 1);
 	}
 
 	spin_lock(&info->lock);
@@ -766,22 +760,23 @@ done2:
 		shmem_free_pages(pages_to_free.next);
 	}
 }
+EXPORT_SYMBOL_GPL(shmem_truncate_range);
 
-static int shmem_notify_change(struct dentry *dentry, struct iattr *attr)
+static int shmem_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	struct inode *inode = dentry->d_inode;
-	loff_t newsize = attr->ia_size;
 	int error;
 
 	error = inode_change_ok(inode, attr);
 	if (error)
 		return error;
 
-	if (S_ISREG(inode->i_mode) && (attr->ia_valid & ATTR_SIZE)
-					&& newsize != inode->i_size) {
+	if (S_ISREG(inode->i_mode) && (attr->ia_valid & ATTR_SIZE)) {
+		loff_t oldsize = inode->i_size;
+		loff_t newsize = attr->ia_size;
 		struct page *page = NULL;
 
-		if (newsize < inode->i_size) {
+		if (newsize < oldsize) {
 			/*
 			 * If truncating down to a partial page, then
 			 * if that page is already allocated, hold it
@@ -810,12 +805,19 @@ static int shmem_notify_change(struct de
 				spin_unlock(&info->lock);
 			}
 		}
-
-		/* XXX(truncate): truncate_setsize should be called last */
-		truncate_setsize(inode, newsize);
+		if (newsize != oldsize) {
+			i_size_write(inode, newsize);
+			inode->i_ctime = inode->i_mtime = CURRENT_TIME;
+		}
+		if (newsize < oldsize) {
+			loff_t holebegin = round_up(newsize, PAGE_SIZE);
+			unmap_mapping_range(inode->i_mapping, holebegin, 0, 1);
+			shmem_truncate_range(inode, newsize, (loff_t)-1);
+			/* unmap again to remove racily COWed private pages */
+			unmap_mapping_range(inode->i_mapping, holebegin, 0, 1);
+		}
 		if (page)
 			page_cache_release(page);
-		shmem_truncate_range(inode, newsize, (loff_t)-1);
 	}
 
 	setattr_copy(inode, attr);
@@ -832,7 +834,6 @@ static void shmem_evict_inode(struct ino
 	struct shmem_xattr *xattr, *nxattr;
 
 	if (inode->i_mapping->a_ops == &shmem_aops) {
-		truncate_inode_pages(inode->i_mapping, 0);
 		shmem_unacct_size(info->flags, inode->i_size);
 		inode->i_size = 0;
 		shmem_truncate_range(inode, 0, (loff_t)-1);
@@ -2706,7 +2707,7 @@ static const struct file_operations shme
 };
 
 static const struct inode_operations shmem_inode_operations = {
-	.setattr	= shmem_notify_change,
+	.setattr	= shmem_setattr,
 	.truncate_range	= shmem_truncate_range,
 #ifdef CONFIG_TMPFS_XATTR
 	.setxattr	= shmem_setxattr,
@@ -2739,7 +2740,7 @@ static const struct inode_operations shm
 	.removexattr	= shmem_removexattr,
 #endif
 #ifdef CONFIG_TMPFS_POSIX_ACL
-	.setattr	= shmem_notify_change,
+	.setattr	= shmem_setattr,
 	.check_acl	= generic_check_acl,
 #endif
 };
@@ -2752,7 +2753,7 @@ static const struct inode_operations shm
 	.removexattr	= shmem_removexattr,
 #endif
 #ifdef CONFIG_TMPFS_POSIX_ACL
-	.setattr	= shmem_notify_change,
+	.setattr	= shmem_setattr,
 	.check_acl	= generic_check_acl,
 #endif
 };
@@ -2908,6 +2909,12 @@ int shmem_lock(struct file *file, int lo
 	return 0;
 }
 
+void shmem_truncate_range(struct inode *inode, loff_t start, loff_t end)
+{
+	truncate_inode_pages_range(inode->i_mapping, start, end);
+}
+EXPORT_SYMBOL_GPL(shmem_truncate_range);
+
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 /**
  * mem_cgroup_get_shmem_target - find a page or entry assigned to the shmem file
diff -puN mm/truncate.c~tmpfs-take-control-of-its-truncate_range mm/truncate.c
--- a/mm/truncate.c~tmpfs-take-control-of-its-truncate_range
+++ a/mm/truncate.c
@@ -619,9 +619,9 @@ int vmtruncate_range(struct inode *inode
 	mutex_lock(&inode->i_mutex);
 	down_write(&inode->i_alloc_sem);
 	unmap_mapping_range(mapping, offset, (end - offset), 1);
-	truncate_inode_pages_range(mapping, offset, end);
-	unmap_mapping_range(mapping, offset, (end - offset), 1);
 	inode->i_op->truncate_range(inode, offset, end);
+	/* unmap again to remove racily COWed private pages */
+	unmap_mapping_range(mapping, offset, (end - offset), 1);
 	up_write(&inode->i_alloc_sem);
 	mutex_unlock(&inode->i_mutex);
 
_

Patches currently in -mm which might be from hughd@google.com are

mm-cleanup-descriptions-of-filler-arg.patch
mm-truncate-functions-are-in-truncatec.patch
mm-tidy-vmtruncate_range-and-related-functions.patch
mm-consistent-truncate-and-invalidate-loops.patch
mm-pincer-in-truncate_inode_pages_range.patch
tmpfs-no-need-to-use-i_lock.patch
linux-next.patch
tmpfs-clone-shmem_file_splice_read.patch
tmpfs-refine-shmem_file_splice_read.patch
tmpfs-pass-gfp-to-shmem_getpage_gfp.patch
tmpfs-remove_shmem_readpage.patch
tmpfs-simplify-prealloc_page.patch
tmpfs-simplify-filepage-swappage.patch
tmpfs-simplify-unuse-and-writepage.patch
radix_tree-exceptional-entries-and-indices.patch
mm-let-swap-use-exceptional-entries.patch
tmpfs-demolish-old-swap-vector-support.patch
tmpfs-miscellaneous-trivial-cleanups.patch
tmpfs-copy-truncate_inode_pages_range.patch
tmpfs-convert-shmem_truncate_range-to-radix-swap.patch
tmpfs-convert-shmem_unuse_inode-to-radix-swap.patch
tmpfs-convert-shmem_getpage_gfp-to-radix-swap.patch
tmpfs-convert-mem_cgroup-shmem-to-radix-swap.patch
tmpfs-convert-shmem_writepage-and-enable-swap.patch
tmpfs-use-kmemdup-for-short-symlinks.patch
mm-a-few-small-updates-for-radix-swap.patch
mm-a-few-small-updates-for-radix-swap-fix.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl-v3.patch
prio_tree-debugging-patch.patch

