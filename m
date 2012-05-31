From: akpm@linux-foundation.org
Subject: [merged] tmpfs-undo-fallocation-on-failure.patch removed from -mm tree
Date: Thu, 31 May 2012 12:15:47 -0700
Message-ID: <20120531191547.5C34FA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:39916 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932941Ab2EaTPs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:15:48 -0400
Received: by yenl3 with SMTP id l3so137962yen.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:15:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, amwang@redhat.com, hch@infradead.org, kay@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs: undo fallocation on failure
has been removed from the -mm tree.  Its filename was
     tmpfs-undo-fallocation-on-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: tmpfs: undo fallocation on failure

In the previous episode, we left the already-fallocated pages attached to
the file when shmem_fallocate() fails part way through.

Now try to do better, by extending the earlier optimization of !Uptodate
pages (then always under page lock) to !Uptodate pages (outside of page
lock), representing fallocated pages.  And don't waste time clearing them
at the time of fallocate(), leave that until later if necessary.

Adapt shmem_truncate_range() to shmem_undo_range(), so that a failing
fallocate can recognize and remove precisely those !Uptodate allocations
which it added (and were not independently allocated by racing tasks).

But unless we start playing with swapfile.c and memcontrol.c too, once one
of our fallocated pages reaches shmem_writepage(), we do then have to
instantiate it as an ordinarily allocated page, before swapping out.  This
is unsatisfactory, but improved in the next episode.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Cong Wang <amwang@redhat.com>
Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |  105 ++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 72 insertions(+), 33 deletions(-)

diff -puN mm/shmem.c~tmpfs-undo-fallocation-on-failure mm/shmem.c
--- a/mm/shmem.c~tmpfs-undo-fallocation-on-failure
+++ a/mm/shmem.c
@@ -89,7 +89,8 @@ enum sgp_type {
 	SGP_READ,	/* don't exceed i_size, don't allocate page */
 	SGP_CACHE,	/* don't exceed i_size, may allocate page */
 	SGP_DIRTY,	/* like SGP_CACHE, but set new page dirty */
-	SGP_WRITE,	/* may exceed i_size, may allocate page */
+	SGP_WRITE,	/* may exceed i_size, may allocate !Uptodate page */
+	SGP_FALLOC,	/* like SGP_WRITE, but make existing page Uptodate */
 };
 
 #ifdef CONFIG_TMPFS
@@ -427,8 +428,10 @@ void shmem_unlock_mapping(struct address
 
 /*
  * Remove range of pages and swap entries from radix tree, and free them.
+ * If !unfalloc, truncate or punch hole; if unfalloc, undo failed fallocate.
  */
-void shmem_truncate_range(struct inode *inode, loff_t lstart, loff_t lend)
+static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
+								 bool unfalloc)
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
@@ -462,6 +465,8 @@ void shmem_truncate_range(struct inode *
 				break;
 
 			if (radix_tree_exceptional_entry(page)) {
+				if (unfalloc)
+					continue;
 				nr_swaps_freed += !shmem_free_swap(mapping,
 								index, page);
 				continue;
@@ -469,9 +474,11 @@ void shmem_truncate_range(struct inode *
 
 			if (!trylock_page(page))
 				continue;
-			if (page->mapping == mapping) {
-				VM_BUG_ON(PageWriteback(page));
-				truncate_inode_page(mapping, page);
+			if (!unfalloc || !PageUptodate(page)) {
+				if (page->mapping == mapping) {
+					VM_BUG_ON(PageWriteback(page));
+					truncate_inode_page(mapping, page);
+				}
 			}
 			unlock_page(page);
 		}
@@ -517,12 +524,12 @@ void shmem_truncate_range(struct inode *
 				min(end - index, (pgoff_t)PAGEVEC_SIZE),
 							pvec.pages, indices);
 		if (!pvec.nr) {
-			if (index == start)
+			if (index == start || unfalloc)
 				break;
 			index = start;
 			continue;
 		}
-		if (index == start && indices[0] >= end) {
+		if ((index == start || unfalloc) && indices[0] >= end) {
 			shmem_deswap_pagevec(&pvec);
 			pagevec_release(&pvec);
 			break;
@@ -536,15 +543,19 @@ void shmem_truncate_range(struct inode *
 				break;
 
 			if (radix_tree_exceptional_entry(page)) {
+				if (unfalloc)
+					continue;
 				nr_swaps_freed += !shmem_free_swap(mapping,
 								index, page);
 				continue;
 			}
 
 			lock_page(page);
-			if (page->mapping == mapping) {
-				VM_BUG_ON(PageWriteback(page));
-				truncate_inode_page(mapping, page);
+			if (!unfalloc || !PageUptodate(page)) {
+				if (page->mapping == mapping) {
+					VM_BUG_ON(PageWriteback(page));
+					truncate_inode_page(mapping, page);
+				}
 			}
 			unlock_page(page);
 		}
@@ -558,7 +569,11 @@ void shmem_truncate_range(struct inode *
 	info->swapped -= nr_swaps_freed;
 	shmem_recalc_inode(inode);
 	spin_unlock(&info->lock);
+}
 
+void shmem_truncate_range(struct inode *inode, loff_t lstart, loff_t lend)
+{
+	shmem_undo_range(inode, lstart, lend, false);
 	inode->i_ctime = inode->i_mtime = CURRENT_TIME;
 }
 EXPORT_SYMBOL_GPL(shmem_truncate_range);
@@ -771,6 +786,18 @@ static int shmem_writepage(struct page *
 		WARN_ON_ONCE(1);	/* Still happens? Tell us about it! */
 		goto redirty;
 	}
+
+	/*
+	 * This is somewhat ridiculous, but without plumbing a SWAP_MAP_FALLOC
+	 * value into swapfile.c, the only way we can correctly account for a
+	 * fallocated page arriving here is now to initialize it and write it.
+	 */
+	if (!PageUptodate(page)) {
+		clear_highpage(page);
+		flush_dcache_page(page);
+		SetPageUptodate(page);
+	}
+
 	swap = get_swap_page();
 	if (!swap.val)
 		goto redirty;
@@ -994,6 +1021,7 @@ static int shmem_getpage_gfp(struct inod
 	swp_entry_t swap;
 	int error;
 	int once = 0;
+	int alloced = 0;
 
 	if (index > (MAX_LFS_FILESIZE >> PAGE_CACHE_SHIFT))
 		return -EFBIG;
@@ -1005,19 +1033,21 @@ repeat:
 		page = NULL;
 	}
 
-	if (sgp != SGP_WRITE &&
+	if (sgp != SGP_WRITE && sgp != SGP_FALLOC &&
 	    ((loff_t)index << PAGE_CACHE_SHIFT) >= i_size_read(inode)) {
 		error = -EINVAL;
 		goto failed;
 	}
 
+	/* fallocated page? */
+	if (page && !PageUptodate(page)) {
+		if (sgp != SGP_READ)
+			goto clear;
+		unlock_page(page);
+		page_cache_release(page);
+		page = NULL;
+	}
 	if (page || (sgp == SGP_READ && !swap.val)) {
-		/*
-		 * Once we can get the page lock, it must be uptodate:
-		 * if there were an error in reading back from swap,
-		 * the page would not be inserted into the filecache.
-		 */
-		BUG_ON(page && !PageUptodate(page));
 		*pagep = page;
 		return 0;
 	}
@@ -1114,9 +1144,18 @@ repeat:
 		inode->i_blocks += BLOCKS_PER_PAGE;
 		shmem_recalc_inode(inode);
 		spin_unlock(&info->lock);
+		alloced = true;
 
 		/*
-		 * Let SGP_WRITE caller clear ends if write does not fill page
+		 * Let SGP_FALLOC use the SGP_WRITE optimization on a new page.
+		 */
+		if (sgp == SGP_FALLOC)
+			sgp = SGP_WRITE;
+clear:
+		/*
+		 * Let SGP_WRITE caller clear ends if write does not fill page;
+		 * but SGP_FALLOC on a page fallocated earlier must initialize
+		 * it now, lest undo on failure cancel our earlier guarantee.
 		 */
 		if (sgp != SGP_WRITE) {
 			clear_highpage(page);
@@ -1128,10 +1167,13 @@ repeat:
 	}
 
 	/* Perhaps the file has been truncated since we checked */
-	if (sgp != SGP_WRITE &&
+	if (sgp != SGP_WRITE && sgp != SGP_FALLOC &&
 	    ((loff_t)index << PAGE_CACHE_SHIFT) >= i_size_read(inode)) {
 		error = -EINVAL;
-		goto trunc;
+		if (alloced)
+			goto trunc;
+		else
+			goto failed;
 	}
 	*pagep = page;
 	return 0;
@@ -1140,6 +1182,7 @@ repeat:
 	 * Error recovery.
 	 */
 trunc:
+	info = SHMEM_I(inode);
 	ClearPageDirty(page);
 	delete_from_page_cache(page);
 	spin_lock(&info->lock);
@@ -1147,6 +1190,7 @@ trunc:
 	inode->i_blocks -= BLOCKS_PER_PAGE;
 	spin_unlock(&info->lock);
 decused:
+	sbinfo = SHMEM_SB(inode->i_sb);
 	if (sbinfo->max_blocks)
 		percpu_counter_add(&sbinfo->used_blocks, -1);
 unacct:
@@ -1645,25 +1689,20 @@ static long shmem_fallocate(struct file 
 		if (signal_pending(current))
 			error = -EINTR;
 		else
-			error = shmem_getpage(inode, index, &page, SGP_WRITE,
+			error = shmem_getpage(inode, index, &page, SGP_FALLOC,
 									NULL);
 		if (error) {
-			/*
-			 * We really ought to free what we allocated so far,
-			 * but it would be wrong to free pages allocated
-			 * earlier, or already now in use: i_mutex does not
-			 * exclude all cases.  We do not know what to free.
-			 */
+			/* Remove the !PageUptodate pages we added */
+			shmem_undo_range(inode,
+				(loff_t)start << PAGE_CACHE_SHIFT,
+				(loff_t)index << PAGE_CACHE_SHIFT, true);
 			goto ctime;
 		}
 
-		if (!PageUptodate(page)) {
-			clear_highpage(page);
-			flush_dcache_page(page);
-			SetPageUptodate(page);
-		}
 		/*
-		 * set_page_dirty so that memory pressure will swap rather
+		 * If !PageUptodate, leave it that way so that freeable pages
+		 * can be recognized if we need to rollback on error later.
+		 * But set_page_dirty so that memory pressure will swap rather
 		 * than free the pages we are allocating (and SGP_CACHE pages
 		 * might still be clean: we now need to mark those dirty too).
 		 */
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
proc-clean-up-proc-pid-environ-handling.patch
proc-remove-mm_for_maps.patch
proc-use-mm_access-instead-of-ptrace_may_access.patch
proc-report-file-anon-bit-in-proc-pid-pagemap.patch
proc-use-is_err_or_null.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
prio_tree-debugging-patch.patch

