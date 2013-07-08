From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-take-page-buffers-dirty-and-locked-state-into-account-v3.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:25:02 -0700
Message-ID: <51db120e.Gq70UImXH4NLcHVW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50362 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165Ab3GHTZI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:25:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zcalusic@bitsync.net, trond.myklebust@fys.uio.no, riel@redhat.com, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, jslaby@suse.cz, hannes@cmpxchg.org, dormando@rydia.net, Valdis.Kletnieks@vt.edu, mgorman@suse.de

Subject: [merged] mm-vmscan-take-page-buffers-dirty-and-locked-state-into-account-v3.patch removed from -mm tree
To: mgorman@suse.de,Valdis.Kletnieks@vt.edu,dormando@rydia.net,hannes@cmpxchg.org,jslaby@suse.cz,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,riel@redhat.com,trond.myklebust@fys.uio.no,zcalusic@bitsync.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:25:02 -0700


The patch titled
     Subject: mm: vmscan: take page buffers dirty and locked state into account
has been removed from the -mm tree.  Its filename was
     mm-vmscan-take-page-buffers-dirty-and-locked-state-into-account-v3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: vmscan: take page buffers dirty and locked state into account

Page reclaim keeps track of dirty and under writeback pages and uses it to
determine if wait_iff_congested() should stall or if kswapd should begin
writing back pages.  This fails to account for buffer pages that can be
under writeback but not PageWriteback which is the case for filesystems
like ext3 ordered mode.  Furthermore, PageDirty buffer pages can have all
the buffers clean and writepage does no IO so it should not be accounted
as congested.

This patch adds an address_space operation that filesystems may optionally
use to check if a page is really dirty or really under writeback.  An
implementation is provided for for buffer_heads is added and used for
block operations and ext3 in ordered mode.  By default the page flags are
obeyed.

Credit goes to Jan Kara for identifying that the page flags alone are not
sufficient for ext3 and sanity checking a number of ideas on how the
problem could be addressed.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Zlatko Calusic <zcalusic@bitsync.net>
Cc: dormando <dormando@rydia.net>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c              |    1 +
 fs/buffer.c                 |   34 ++++++++++++++++++++++++++++++++++
 fs/ext3/inode.c             |    1 +
 include/linux/buffer_head.h |    3 +++
 include/linux/fs.h          |    1 +
 mm/vmscan.c                 |   10 ++++++++++
 6 files changed, 50 insertions(+)

diff -puN fs/block_dev.c~mm-vmscan-take-page-buffers-dirty-and-locked-state-into-account-v3 fs/block_dev.c
--- a/fs/block_dev.c~mm-vmscan-take-page-buffers-dirty-and-locked-state-into-account-v3
+++ a/fs/block_dev.c
@@ -1562,6 +1562,7 @@ static const struct address_space_operat
 	.writepages	= generic_writepages,
 	.releasepage	= blkdev_releasepage,
 	.direct_IO	= blkdev_direct_IO,
+	.is_dirty_writeback = buffer_check_dirty_writeback,
 };
 
 const struct file_operations def_blk_fops = {
diff -puN fs/buffer.c~mm-vmscan-take-page-buffers-dirty-and-locked-state-into-account-v3 fs/buffer.c
--- a/fs/buffer.c~mm-vmscan-take-page-buffers-dirty-and-locked-state-into-account-v3
+++ a/fs/buffer.c
@@ -83,6 +83,40 @@ void unlock_buffer(struct buffer_head *b
 EXPORT_SYMBOL(unlock_buffer);
 
 /*
+ * Returns if the page has dirty or writeback buffers. If all the buffers
+ * are unlocked and clean then the PageDirty information is stale. If
+ * any of the pages are locked, it is assumed they are locked for IO.
+ */
+void buffer_check_dirty_writeback(struct page *page,
+				     bool *dirty, bool *writeback)
+{
+	struct buffer_head *head, *bh;
+	*dirty = false;
+	*writeback = false;
+
+	BUG_ON(!PageLocked(page));
+
+	if (!page_has_buffers(page))
+		return;
+
+	if (PageWriteback(page))
+		*writeback = true;
+
+	head = page_buffers(page);
+	bh = head;
+	do {
+		if (buffer_locked(bh))
+			*writeback = true;
+
+		if (buffer_dirty(bh))
+			*dirty = true;
+
+		bh = bh->b_this_page;
+	} while (bh != head);
+}
+EXPORT_SYMBOL(buffer_check_dirty_writeback);
+
+/*
  * Block until a buffer comes unlocked.  This doesn't stop it
  * from becoming locked again - you have to lock it yourself
  * if you want to preserve its state.
diff -puN fs/ext3/inode.c~mm-vmscan-take-page-buffers-dirty-and-locked-state-into-account-v3 fs/ext3/inode.c
--- a/fs/ext3/inode.c~mm-vmscan-take-page-buffers-dirty-and-locked-state-into-account-v3
+++ a/fs/ext3/inode.c
@@ -1985,6 +1985,7 @@ static const struct address_space_operat
 	.direct_IO		= ext3_direct_IO,
 	.migratepage		= buffer_migrate_page,
 	.is_partially_uptodate  = block_is_partially_uptodate,
+	.is_dirty_writeback	= buffer_check_dirty_writeback,
 	.error_remove_page	= generic_error_remove_page,
 };
 
diff -puN include/linux/buffer_head.h~mm-vmscan-take-page-buffers-dirty-and-locked-state-into-account-v3 include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~mm-vmscan-take-page-buffers-dirty-and-locked-state-into-account-v3
+++ a/include/linux/buffer_head.h
@@ -139,6 +139,9 @@ BUFFER_FNS(Prio, prio)
 	})
 #define page_has_buffers(page)	PagePrivate(page)
 
+void buffer_check_dirty_writeback(struct page *page,
+				     bool *dirty, bool *writeback);
+
 /*
  * Declarations
  */
diff -puN include/linux/fs.h~mm-vmscan-take-page-buffers-dirty-and-locked-state-into-account-v3 include/linux/fs.h
--- a/include/linux/fs.h~mm-vmscan-take-page-buffers-dirty-and-locked-state-into-account-v3
+++ a/include/linux/fs.h
@@ -380,6 +380,7 @@ struct address_space_operations {
 	int (*launder_page) (struct page *);
 	int (*is_partially_uptodate) (struct page *, read_descriptor_t *,
 					unsigned long);
+	void (*is_dirty_writeback) (struct page *, bool *, bool *);
 	int (*error_remove_page)(struct address_space *, struct page *);
 
 	/* swapfile support */
diff -puN mm/vmscan.c~mm-vmscan-take-page-buffers-dirty-and-locked-state-into-account-v3 mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-take-page-buffers-dirty-and-locked-state-into-account-v3
+++ a/mm/vmscan.c
@@ -673,6 +673,8 @@ static enum page_references page_check_r
 static void page_check_dirty_writeback(struct page *page,
 				       bool *dirty, bool *writeback)
 {
+	struct address_space *mapping;
+
 	/*
 	 * Anonymous pages are not handled by flushers and must be written
 	 * from reclaim context. Do not stall reclaim based on them
@@ -686,6 +688,14 @@ static void page_check_dirty_writeback(s
 	/* By default assume that the page flags are accurate */
 	*dirty = PageDirty(page);
 	*writeback = PageWriteback(page);
+
+	/* Verify dirty/writeback state if the filesystem supports it */
+	if (!page_has_private(page))
+		return;
+
+	mapping = page_mapping(page);
+	if (mapping && mapping->a_ops->is_dirty_writeback)
+		mapping->a_ops->is_dirty_writeback(page, dirty, writeback);
 }
 
 /*
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch
fs-bump-inode-and-dentry-counters-to-long.patch
super-fix-calculation-of-shrinkable-objects-for-small-numbers.patch
dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch
dentry-move-to-per-sb-lru-locks.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
mm-new-shrinker-api.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
list-add-a-new-lru-list-type.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
list_lru-per-node-api.patch
shrinker-add-node-awareness.patch
vmscan-per-node-deferred-work.patch
fs-convert-inode-and-dentry-shrinking-to-be-node-aware.patch
xfs-convert-buftarg-lru-to-generic-code.patch
xfs-rework-buffer-dispose-list-tracking.patch
xfs-convert-dquot-cache-lru-to-list_lru.patch
fs-convert-fs-shrinkers-to-new-scan-count-api.patch
drivers-convert-shrinkers-to-new-count-scan-api.patch
i915-bail-out-earlier-when-shrinker-cannot-acquire-mutex.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch
shrinker-kill-old-shrink-api.patch
list_lru-dynamically-adjust-node-arrays.patch
zbud-add-to-mm.patch
zswap-add-to-mm.patch
zswap-add-documentation.patch
mm-vmscan-do-not-continue-scanning-if-reclaim-was-aborted-for-compaction.patch
mm-vmscan-do-not-scale-writeback-pages-when-deciding-whether-to-set-zone_writeback.patch
mm-memmap_init_zone-performance-improvement.patch

