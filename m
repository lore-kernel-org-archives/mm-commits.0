From: akpm@linux-foundation.org
Subject: [merged] mm-introduce-delete_from_page_cache.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:34:10 -0700
Message-ID: <201103232037.p2NKbkjT028268@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41632 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933284Ab1CWU6F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:58:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, edward.shishkin@gmail.com, hannes@cmpxchg.org, hch@infradead.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.i


The patch titled
     mm: introduce delete_from_page_cache()
has been removed from the -mm tree.  Its filename was
     mm-introduce-delete_from_page_cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: introduce delete_from_page_cache()
From: Minchan Kim <minchan.kim@gmail.com>

Presently we increase the page refcount in add_to_page_cache() but don't
decrease it in remove_from_page_cache().  Such asymmetry adds confusion,
requiring that callers notice it and a comment explaining why they release
a page reference.  It's not a good API.

A long time ago, Hugh tried it (http://lkml.org/lkml/2004/10/24/140) but
gave up because reiser4's drop_page() had to unlock the page between
removing it from page cache and doing the page_cache_release().  But now
the situation is changed.  I think at least things in current mainline
don't have any obstacles.  The problem is for out-of-mainline filesystems
- if they have done such things as reiser4, this patch could be a problem
but they will discover this at compile time since we remove
remove_from_page_cache().



This patch:

This function works as just wrapper remove_from_page_cache().  The
difference is that it decreases page references in itself.  So caller have
to make sure it has a page reference before calling.

This patch is ready for removing remove_from_page_cache().

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Edward Shishkin <edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    1 +
 mm/filemap.c            |   16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff -puN include/linux/pagemap.h~mm-introduce-delete_from_page_cache include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-introduce-delete_from_page_cache
+++ a/include/linux/pagemap.h
@@ -455,6 +455,7 @@ int add_to_page_cache_locked(struct page
 				pgoff_t index, gfp_t gfp_mask);
 int add_to_page_cache_lru(struct page *page, struct address_space *mapping,
 				pgoff_t index, gfp_t gfp_mask);
+extern void delete_from_page_cache(struct page *page);
 extern void remove_from_page_cache(struct page *page);
 extern void __remove_from_page_cache(struct page *page);
 int replace_page_cache_page(struct page *old, struct page *new, gfp_t gfp_mask);
diff -puN mm/filemap.c~mm-introduce-delete_from_page_cache mm/filemap.c
--- a/mm/filemap.c~mm-introduce-delete_from_page_cache
+++ a/mm/filemap.c
@@ -155,6 +155,22 @@ void remove_from_page_cache(struct page 
 }
 EXPORT_SYMBOL(remove_from_page_cache);
 
+/**
+ * delete_from_page_cache - delete page from page cache
+ * @page: the page which the kernel is trying to remove from page cache
+ *
+ * This must be called only on pages that have
+ * been verified to be in the page cache and locked.
+ * It will never put the page into the free list,
+ * the caller has a reference on the page.
+ */
+void delete_from_page_cache(struct page *page)
+{
+	remove_from_page_cache(page);
+	page_cache_release(page);
+}
+EXPORT_SYMBOL(delete_from_page_cache);
+
 static int sync_page(void *word)
 {
 	struct address_space *mapping;
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

origin.patch
linux-next.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-soft-limit-reclaim-should-end-at-limit-not-below.patch
memcg-simplify-the-way-memory-limits-are-checked.patch
memcg-remove-unused-page-flag-bitfield-defines.patch
memcg-remove-impossible-conditional-when-committing.patch
memcg-remove-null-check-from-lookup_page_cgroup-result.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update-fix.patch
memcg-no-uncharged-pages-reach-page_cgroup_zoneinfo.patch
memcg-change-page_cgroup_zoneinfo-signature.patch
memcg-change-page_cgroup_zoneinfo-signature-fix.patch
memcg-fold-__mem_cgroup_move_account-into-caller.patch
memcg-condense-page_cgroup-to-page-lookup-points.patch
memcg-remove-direct-page_cgroup-to-page-pointer.patch
memcg-remove-direct-page_cgroup-to-page-pointer-fix.patch
memcg-charged-pages-always-have-valid-per-memcg-zone-info.patch
memcg-remove-memcg-reclaim_param_lock.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-add-dirty-limiting-routines.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-make-background-writeback-memcg-aware.patch

