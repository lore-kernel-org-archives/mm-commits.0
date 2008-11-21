From: akpm@linux-foundation.org
Subject: + mm-remove-gfp_highuser_pagecache.patch added to -mm tree
Date: Fri, 21 Nov 2008 12:11:52 -0800
Message-ID: <200811212011.mALKBqBI017641@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752115AbYKUUMB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 15:12:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, mel@csn.ul.ie, nickpiggin@yahoo.com.au


The patch titled
     mm: remove GFP_HIGHUSER_PAGECACHE
has been added to the -mm tree.  Its filename is
     mm-remove-gfp_highuser_pagecache.patch

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
Subject: mm: remove GFP_HIGHUSER_PAGECACHE
From: Hugh Dickins <hugh@veritas.com>

GFP_HIGHUSER_PAGECACHE is just an alias for GFP_HIGHUSER_MOVABLE, making
that harder to track down: remove it, and its out-of-work brothers
GFP_NOFS_PAGECACHE and GFP_USER_PAGECACHE.

Since we're making that improvement to hotremove_migrate_alloc(), I think
we can now also remove one of the "o"s from its comment.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c          |    4 ++--
 include/linux/gfp.h |    6 ------
 mm/memory_hotplug.c |    9 +++------
 3 files changed, 5 insertions(+), 14 deletions(-)

diff -puN fs/inode.c~mm-remove-gfp_highuser_pagecache fs/inode.c
--- a/fs/inode.c~mm-remove-gfp_highuser_pagecache
+++ a/fs/inode.c
@@ -164,7 +164,7 @@ struct inode *inode_init_always(struct s
 	mapping->a_ops = &empty_aops;
 	mapping->host = inode;
 	mapping->flags = 0;
-	mapping_set_gfp_mask(mapping, GFP_HIGHUSER_PAGECACHE);
+	mapping_set_gfp_mask(mapping, GFP_HIGHUSER_MOVABLE);
 	mapping->assoc_mapping = NULL;
 	mapping->backing_dev_info = &default_backing_dev_info;
 	mapping->writeback_index = 0;
@@ -599,7 +599,7 @@ EXPORT_SYMBOL_GPL(inode_add_to_lists);
  *	@sb: superblock
  *
  *	Allocates a new inode for given superblock. The default gfp_mask
- *	for allocations related to inode->i_mapping is GFP_HIGHUSER_PAGECACHE.
+ *	for allocations related to inode->i_mapping is GFP_HIGHUSER_MOVABLE.
  *	If HIGHMEM pages are unsuitable or it is known that pages allocated
  *	for the page cache are not reclaimable or migratable,
  *	mapping_set_gfp_mask() must be called with suitable flags on the
diff -puN include/linux/gfp.h~mm-remove-gfp_highuser_pagecache include/linux/gfp.h
--- a/include/linux/gfp.h~mm-remove-gfp_highuser_pagecache
+++ a/include/linux/gfp.h
@@ -70,12 +70,6 @@ struct vm_area_struct;
 #define GFP_HIGHUSER_MOVABLE	(__GFP_WAIT | __GFP_IO | __GFP_FS | \
 				 __GFP_HARDWALL | __GFP_HIGHMEM | \
 				 __GFP_MOVABLE)
-#define GFP_NOFS_PAGECACHE	(__GFP_WAIT | __GFP_IO | __GFP_MOVABLE)
-#define GFP_USER_PAGECACHE	(__GFP_WAIT | __GFP_IO | __GFP_FS | \
-				 __GFP_HARDWALL | __GFP_MOVABLE)
-#define GFP_HIGHUSER_PAGECACHE	(__GFP_WAIT | __GFP_IO | __GFP_FS | \
-				 __GFP_HARDWALL | __GFP_HIGHMEM | \
-				 __GFP_MOVABLE)
 
 #ifdef CONFIG_NUMA
 #define GFP_THISNODE	(__GFP_THISNODE | __GFP_NOWARN | __GFP_NORETRY)
diff -puN mm/memory_hotplug.c~mm-remove-gfp_highuser_pagecache mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-remove-gfp_highuser_pagecache
+++ a/mm/memory_hotplug.c
@@ -626,15 +626,12 @@ int scan_lru_pages(unsigned long start, 
 }
 
 static struct page *
-hotremove_migrate_alloc(struct page *page,
-			unsigned long private,
-			int **x)
+hotremove_migrate_alloc(struct page *page, unsigned long private, int **x)
 {
-	/* This should be improoooooved!! */
-	return alloc_page(GFP_HIGHUSER_PAGECACHE);
+	/* This should be improooooved!! */
+	return alloc_page(GFP_HIGHUSER_MOVABLE);
 }
 
-
 #define NR_OFFLINE_AT_ONCE_PAGES	(256)
 static int
 do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
linux-next.patch
mm-dont-mark_page_accessed-in-shmem_fault.patch
mm-apply_to_range-call-pte-function-with-lazy-updates.patch
mm-remove-cgroup_mm_owner_callbacks.patch
mm-remove-aop_writepage_activate.patch
mm-remove-gfp_highuser_pagecache.patch
mm-add-setclearpageswapcache-stubs.patch
mm-replace-some-bug_ons-by-vm_bug_ons.patch
mm-add_active_or_unevictable-into-rmap.patch
mm-make-page_lock_anon_vma-static.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-swap-cgroup-for-remembering-usage-fix-2.patch
memcg-swap-cgroup-for-remembering-usage-fix-3.patch
memcg-swap-cgroup-for-remembering-usage-fix-4.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
prio_tree-debugging-patch.patch

