From: akpm@linux-foundation.org
Subject: [merged] tmpfs-copy-truncate_inode_pages_range.patch removed from -mm tree
Date: Tue, 16 Aug 2011 11:51:10 -0700
Message-ID: <201108161848.p7GImHt3015274@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46415 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753129Ab1HPSsv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 14:48:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     tmpfs: copy truncate_inode_pages_range
has been removed from the -mm tree.  Its filename was
     tmpfs-copy-truncate_inode_pages_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tmpfs: copy truncate_inode_pages_range
From: Hugh Dickins <hughd@google.com>

Bring truncate.c's code for truncate_inode_pages_range() inline into
shmem_truncate_range(), replacing its first call (there's a followup call
below, but leave that one, it will disappear next).

Don't play with it yet, apart from leaving out the cleancache flush, and
(importantly) the nrpages == 0 skip, and moving shmem_setattr()'s partial
page preparation into its partial page handling.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   99 ++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 79 insertions(+), 20 deletions(-)

diff -puN mm/shmem.c~tmpfs-copy-truncate_inode_pages_range mm/shmem.c
--- a/mm/shmem.c~tmpfs-copy-truncate_inode_pages_range
+++ a/mm/shmem.c
@@ -50,6 +50,7 @@ static struct vfsmount *shm_mnt;
 #include <linux/shmem_fs.h>
 #include <linux/writeback.h>
 #include <linux/blkdev.h>
+#include <linux/pagevec.h>
 #include <linux/percpu_counter.h>
 #include <linux/splice.h>
 #include <linux/security.h>
@@ -242,11 +243,88 @@ void shmem_truncate_range(struct inode *
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	pgoff_t start = (lstart + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+	unsigned partial = lstart & (PAGE_CACHE_SIZE - 1);
 	pgoff_t end = (lend >> PAGE_CACHE_SHIFT);
+	struct pagevec pvec;
 	pgoff_t index;
 	swp_entry_t swap;
+	int i;
+
+	BUG_ON((lend & (PAGE_CACHE_SIZE - 1)) != (PAGE_CACHE_SIZE - 1));
+
+	pagevec_init(&pvec, 0);
+	index = start;
+	while (index <= end && pagevec_lookup(&pvec, mapping, index,
+			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1)) {
+		mem_cgroup_uncharge_start();
+		for (i = 0; i < pagevec_count(&pvec); i++) {
+			struct page *page = pvec.pages[i];
+
+			/* We rely upon deletion not changing page->index */
+			index = page->index;
+			if (index > end)
+				break;
+
+			if (!trylock_page(page))
+				continue;
+			WARN_ON(page->index != index);
+			if (PageWriteback(page)) {
+				unlock_page(page);
+				continue;
+			}
+			truncate_inode_page(mapping, page);
+			unlock_page(page);
+		}
+		pagevec_release(&pvec);
+		mem_cgroup_uncharge_end();
+		cond_resched();
+		index++;
+	}
+
+	if (partial) {
+		struct page *page = NULL;
+		shmem_getpage(inode, start - 1, &page, SGP_READ, NULL);
+		if (page) {
+			zero_user_segment(page, partial, PAGE_CACHE_SIZE);
+			set_page_dirty(page);
+			unlock_page(page);
+			page_cache_release(page);
+		}
+	}
+
+	index = start;
+	for ( ; ; ) {
+		cond_resched();
+		if (!pagevec_lookup(&pvec, mapping, index,
+			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1)) {
+			if (index == start)
+				break;
+			index = start;
+			continue;
+		}
+		if (index == start && pvec.pages[0]->index > end) {
+			pagevec_release(&pvec);
+			break;
+		}
+		mem_cgroup_uncharge_start();
+		for (i = 0; i < pagevec_count(&pvec); i++) {
+			struct page *page = pvec.pages[i];
+
+			/* We rely upon deletion not changing page->index */
+			index = page->index;
+			if (index > end)
+				break;
 
-	truncate_inode_pages_range(mapping, lstart, lend);
+			lock_page(page);
+			WARN_ON(page->index != index);
+			wait_on_page_writeback(page);
+			truncate_inode_page(mapping, page);
+			unlock_page(page);
+		}
+		pagevec_release(&pvec);
+		mem_cgroup_uncharge_end();
+		index++;
+	}
 
 	if (end > SHMEM_NR_DIRECT)
 		end = SHMEM_NR_DIRECT;
@@ -289,24 +367,7 @@ static int shmem_setattr(struct dentry *
 	if (S_ISREG(inode->i_mode) && (attr->ia_valid & ATTR_SIZE)) {
 		loff_t oldsize = inode->i_size;
 		loff_t newsize = attr->ia_size;
-		struct page *page = NULL;
 
-		if (newsize < oldsize) {
-			/*
-			 * If truncating down to a partial page, then
-			 * if that page is already allocated, hold it
-			 * in memory until the truncation is over, so
-			 * truncate_partial_page cannot miss it were
-			 * it assigned to swap.
-			 */
-			if (newsize & (PAGE_CACHE_SIZE-1)) {
-				(void) shmem_getpage(inode,
-					newsize >> PAGE_CACHE_SHIFT,
-						&page, SGP_READ, NULL);
-				if (page)
-					unlock_page(page);
-			}
-		}
 		if (newsize != oldsize) {
 			i_size_write(inode, newsize);
 			inode->i_ctime = inode->i_mtime = CURRENT_TIME;
@@ -318,8 +379,6 @@ static int shmem_setattr(struct dentry *
 			/* unmap again to remove racily COWed private pages */
 			unmap_mapping_range(inode->i_mapping, holebegin, 0, 1);
 		}
-		if (page)
-			page_cache_release(page);
 	}
 
 	setattr_copy(inode, attr);
_

Patches currently in -mm which might be from hughd@google.com are

linux-next.patch
radix_tree-clean-away-saw_unset_tag-leftovers.patch
tmpfs-add-tmpfs-to-the-kconfig-prompt-to-make-it-obvious.patch
prio_tree-debugging-patch.patch

