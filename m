From: akpm@linux-foundation.org
Subject: [merged]
 mm-get-rid-of-radix-tree-gfp-mask-for-pagecache_get_page-was-re-how-to-handle-tif_memdie-stalls.patch removed from -mm tree
Date: Tue, 30 Dec 2014 13:28:22 -0800
Message-ID: <54a318f6.1nEWVBOZPFH98DRL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35024 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbaL3V2Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Dec 2014 16:28:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, david@fromorbit.com, hannes@cmpxchg.org, mgorman@suse.de, oleg@redhat.com, penguin-kernel@i-love.sakura.ne.jp, rientjes@google.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: get rid of radix tree gfp mask for pagecache_get_page
has been removed from the -mm tree.  Its filename was
     mm-get-rid-of-radix-tree-gfp-mask-for-pagecache_get_page-was-re-how-to-handle-tif_memdie-stalls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: mm: get rid of radix tree gfp mask for pagecache_get_page

2457aec63745 ("mm: non-atomically mark page accessed during page cache
allocation where possible") has added a separate parameter for specifying
gfp mask for radix tree allocations.

Not only this is less than optimal from the API point of view because it
is error prone, it is also buggy currently because
grab_cache_page_write_begin is using GFP_KERNEL for radix tree and if
fgp_flags doesn't contain GFP_NOFS (mostly controlled by fs by
AOP_FLAG_NOFS flag) but the mapping_gfp_mask has __GFP_FS cleared then the
radix tree allocation wouldn't obey the restriction and might recurse into
filesystem and cause deadlocks.  This is the case for most filesystems
unfortunately because only ext4 and gfs2 are using AOP_FLAG_NOFS.

Let's simply remove radix_gfp_mask parameter because the allocation
context is same for both page cache and for the radix tree.  Just make
sure that the radix tree gets only the sane subset of the mask (e.g.  do
not pass __GFP_WRITE).

Long term it is more preferable to convert remaining users of
AOP_FLAG_NOFS to use mapping_gfp_mask instead and simplify this interface
even further.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Dave Chinner <david@fromorbit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: David Rientjes <rientjes@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   13 ++++++-------
 mm/filemap.c            |   29 ++++++++++++-----------------
 2 files changed, 18 insertions(+), 24 deletions(-)

diff -puN include/linux/pagemap.h~mm-get-rid-of-radix-tree-gfp-mask-for-pagecache_get_page-was-re-how-to-handle-tif_memdie-stalls include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-get-rid-of-radix-tree-gfp-mask-for-pagecache_get_page-was-re-how-to-handle-tif_memdie-stalls
+++ a/include/linux/pagemap.h
@@ -251,7 +251,7 @@ pgoff_t page_cache_prev_hole(struct addr
 #define FGP_NOWAIT		0x00000020
 
 struct page *pagecache_get_page(struct address_space *mapping, pgoff_t offset,
-		int fgp_flags, gfp_t cache_gfp_mask, gfp_t radix_gfp_mask);
+		int fgp_flags, gfp_t cache_gfp_mask);
 
 /**
  * find_get_page - find and get a page reference
@@ -266,13 +266,13 @@ struct page *pagecache_get_page(struct a
 static inline struct page *find_get_page(struct address_space *mapping,
 					pgoff_t offset)
 {
-	return pagecache_get_page(mapping, offset, 0, 0, 0);
+	return pagecache_get_page(mapping, offset, 0, 0);
 }
 
 static inline struct page *find_get_page_flags(struct address_space *mapping,
 					pgoff_t offset, int fgp_flags)
 {
-	return pagecache_get_page(mapping, offset, fgp_flags, 0, 0);
+	return pagecache_get_page(mapping, offset, fgp_flags, 0);
 }
 
 /**
@@ -292,7 +292,7 @@ static inline struct page *find_get_page
 static inline struct page *find_lock_page(struct address_space *mapping,
 					pgoff_t offset)
 {
-	return pagecache_get_page(mapping, offset, FGP_LOCK, 0, 0);
+	return pagecache_get_page(mapping, offset, FGP_LOCK, 0);
 }
 
 /**
@@ -319,7 +319,7 @@ static inline struct page *find_or_creat
 {
 	return pagecache_get_page(mapping, offset,
 					FGP_LOCK|FGP_ACCESSED|FGP_CREAT,
-					gfp_mask, gfp_mask & GFP_RECLAIM_MASK);
+					gfp_mask);
 }
 
 /**
@@ -340,8 +340,7 @@ static inline struct page *grab_cache_pa
 {
 	return pagecache_get_page(mapping, index,
 			FGP_LOCK|FGP_CREAT|FGP_NOFS|FGP_NOWAIT,
-			mapping_gfp_mask(mapping),
-			GFP_NOFS);
+			mapping_gfp_mask(mapping));
 }
 
 struct page *find_get_entry(struct address_space *mapping, pgoff_t offset);
diff -puN mm/filemap.c~mm-get-rid-of-radix-tree-gfp-mask-for-pagecache_get_page-was-re-how-to-handle-tif_memdie-stalls mm/filemap.c
--- a/mm/filemap.c~mm-get-rid-of-radix-tree-gfp-mask-for-pagecache_get_page-was-re-how-to-handle-tif_memdie-stalls
+++ a/mm/filemap.c
@@ -1046,8 +1046,7 @@ EXPORT_SYMBOL(find_lock_entry);
  * @mapping: the address_space to search
  * @offset: the page index
  * @fgp_flags: PCG flags
- * @cache_gfp_mask: gfp mask to use for the page cache data page allocation
- * @radix_gfp_mask: gfp mask to use for radix tree node allocation
+ * @gfp_mask: gfp mask to use for the page cache data page allocation
  *
  * Looks up the page cache slot at @mapping & @offset.
  *
@@ -1056,11 +1055,9 @@ EXPORT_SYMBOL(find_lock_entry);
  * FGP_ACCESSED: the page will be marked accessed
  * FGP_LOCK: Page is return locked
  * FGP_CREAT: If page is not present then a new page is allocated using
- *		@cache_gfp_mask and added to the page cache and the VM's LRU
- *		list. If radix tree nodes are allocated during page cache
- *		insertion then @radix_gfp_mask is used. The page is returned
- *		locked and with an increased refcount. Otherwise, %NULL is
- *		returned.
+ *		@gfp_mask and added to the page cache and the VM's LRU
+ *		list. The page is returned locked and with an increased
+ *		refcount. Otherwise, %NULL is returned.
  *
  * If FGP_LOCK or FGP_CREAT are specified then the function may sleep even
  * if the GFP flags specified for FGP_CREAT are atomic.
@@ -1068,7 +1065,7 @@ EXPORT_SYMBOL(find_lock_entry);
  * If there is a page cache page, it is returned with an increased refcount.
  */
 struct page *pagecache_get_page(struct address_space *mapping, pgoff_t offset,
-	int fgp_flags, gfp_t cache_gfp_mask, gfp_t radix_gfp_mask)
+	int fgp_flags, gfp_t gfp_mask)
 {
 	struct page *page;
 
@@ -1105,13 +1102,11 @@ no_page:
 	if (!page && (fgp_flags & FGP_CREAT)) {
 		int err;
 		if ((fgp_flags & FGP_WRITE) && mapping_cap_account_dirty(mapping))
-			cache_gfp_mask |= __GFP_WRITE;
-		if (fgp_flags & FGP_NOFS) {
-			cache_gfp_mask &= ~__GFP_FS;
-			radix_gfp_mask &= ~__GFP_FS;
-		}
+			gfp_mask |= __GFP_WRITE;
+		if (fgp_flags & FGP_NOFS)
+			gfp_mask &= ~__GFP_FS;
 
-		page = __page_cache_alloc(cache_gfp_mask);
+		page = __page_cache_alloc(gfp_mask);
 		if (!page)
 			return NULL;
 
@@ -1122,7 +1117,8 @@ no_page:
 		if (fgp_flags & FGP_ACCESSED)
 			__SetPageReferenced(page);
 
-		err = add_to_page_cache_lru(page, mapping, offset, radix_gfp_mask);
+		err = add_to_page_cache_lru(page, mapping, offset,
+				gfp_mask & GFP_RECLAIM_MASK);
 		if (unlikely(err)) {
 			page_cache_release(page);
 			page = NULL;
@@ -2443,8 +2439,7 @@ struct page *grab_cache_page_write_begin
 		fgp_flags |= FGP_NOFS;
 
 	page = pagecache_get_page(mapping, index, fgp_flags,
-			mapping_gfp_mask(mapping),
-			GFP_KERNEL);
+			mapping_gfp_mask(mapping));
 	if (page)
 		wait_for_stable_page(page);
 
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
mm-prevent-endless-growth-of-anon_vma-hierarchy.patch
memcg-fix-destination-cgroup-leak-on-task-charges-migration.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-update.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-fix.patch
memcg-zap-__memcg_chargeuncharge_slab.patch
memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache.patch
memcg-zap-memcg_slab_caches-and-memcg_slab_mutex.patch
oom-dont-count-on-mm-less-current-process.patch
oom-make-sure-that-tif_memdie-is-set-under-task_lock.patch
swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch

