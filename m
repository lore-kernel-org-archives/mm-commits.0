From: akpm@linux-foundation.org
Subject: [merged] mm-for-fs-add-truncate_pagecache_range.patch removed from -mm tree
Date: Thu, 29 Mar 2012 12:13:20 -0700
Message-ID: <20120329191320.A6A9CA01E3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:62030 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933693Ab2C2TNW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Mar 2012 15:13:22 -0400
Received: by qabg24 with SMTP id g24so17792qab.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 12:13:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, adilger.kernel@dilger.ca, bpm@sgi.com, david@fromorbit.com, elder@kernel.org, hch@lst.de, jlbec@evilplan.org, mfasheh@suse.com, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm for fs: add truncate_pagecache_range()
has been removed from the -mm tree.  Its filename was
     mm-for-fs-add-truncate_pagecache_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm for fs: add truncate_pagecache_range()

Holepunching filesystems ext4 and xfs are using truncate_inode_pages_range
but forgetting to unmap pages first (ocfs2 remembers).  This is not really
a bug, since races already require truncate_inode_page() to handle that
case once the page is locked; but it can be very inefficient if the file
being punched happens to be mapped into many vmas.

Provide a drop-in replacement truncate_pagecache_range() which does the
unmapping pass first, handling the awkward mismatch between arguments to
truncate_inode_pages_range() and arguments to unmap_mapping_range().

Note that holepunching does not unmap privately COWed pages in the range:
POSIX requires that we do so when truncating, but it's hard to justify,
difficult to implement without an i_size cutoff, and no filesystem is
attempting to implement it.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 mm/truncate.c      |   40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 1 deletion(-)

diff -puN include/linux/mm.h~mm-for-fs-add-truncate_pagecache_range include/linux/mm.h
--- a/include/linux/mm.h~mm-for-fs-add-truncate_pagecache_range
+++ a/include/linux/mm.h
@@ -954,7 +954,7 @@ extern void truncate_pagecache(struct in
 extern void truncate_setsize(struct inode *inode, loff_t newsize);
 extern int vmtruncate(struct inode *inode, loff_t offset);
 extern int vmtruncate_range(struct inode *inode, loff_t offset, loff_t end);
-
+void truncate_pagecache_range(struct inode *inode, loff_t offset, loff_t end);
 int truncate_inode_page(struct address_space *mapping, struct page *page);
 int generic_error_remove_page(struct address_space *mapping, struct page *page);
 
diff -puN mm/truncate.c~mm-for-fs-add-truncate_pagecache_range mm/truncate.c
--- a/mm/truncate.c~mm-for-fs-add-truncate_pagecache_range
+++ a/mm/truncate.c
@@ -626,3 +626,43 @@ int vmtruncate_range(struct inode *inode
 
 	return 0;
 }
+
+/**
+ * truncate_pagecache_range - unmap and remove pagecache that is hole-punched
+ * @inode: inode
+ * @lstart: offset of beginning of hole
+ * @lend: offset of last byte of hole
+ *
+ * This function should typically be called before the filesystem
+ * releases resources associated with the freed range (eg. deallocates
+ * blocks). This way, pagecache will always stay logically coherent
+ * with on-disk format, and the filesystem would not have to deal with
+ * situations such as writepage being called for a page that has already
+ * had its underlying blocks deallocated.
+ */
+void truncate_pagecache_range(struct inode *inode, loff_t lstart, loff_t lend)
+{
+	struct address_space *mapping = inode->i_mapping;
+	loff_t unmap_start = round_up(lstart, PAGE_SIZE);
+	loff_t unmap_end = round_down(1 + lend, PAGE_SIZE) - 1;
+	/*
+	 * This rounding is currently just for example: unmap_mapping_range
+	 * expands its hole outwards, whereas we want it to contract the hole
+	 * inwards.  However, existing callers of truncate_pagecache_range are
+	 * doing their own page rounding first; and truncate_inode_pages_range
+	 * currently BUGs if lend is not pagealigned-1 (it handles partial
+	 * page at start of hole, but not partial page at end of hole).  Note
+	 * unmap_mapping_range allows holelen 0 for all, and we allow lend -1.
+	 */
+
+	/*
+	 * Unlike in truncate_pagecache, unmap_mapping_range is called only
+	 * once (before truncating pagecache), and without "even_cows" flag:
+	 * hole-punching should not remove private COWed pages from the hole.
+	 */
+	if ((u64)unmap_end > (u64)unmap_start)
+		unmap_mapping_range(mapping, unmap_start,
+				    1 + unmap_end - unmap_start, 0);
+	truncate_inode_pages_range(mapping, lstart, lend);
+}
+EXPORT_SYMBOL(truncate_pagecache_range);
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
memcg-fix-change-behavior-of-shared-anon-at-moving-task.patch
memcg-swap-mem_cgroup_move_swap_account-never-needs-fixup.patch
memcg-swap-use-mem_cgroup_uncharge_swap.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch
prio_tree-debugging-patch.patch

