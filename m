From: akpm@linux-foundation.org
Subject: + mm-remove-unnecessary-uses-of-lock_page_memcg.patch added to
 -mm tree
Date: Tue, 02 Feb 2016 14:42:21 -0800
Message-ID: <56b130cd.3p2fYpjF3j+rIZrd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32976 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbcBBWmW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 17:42:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove unnecessary uses of lock_page_memcg()
has been added to the -mm tree.  Its filename is
     mm-remove-unnecessary-uses-of-lock_page_memcg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-unnecessary-uses-of-lock_page_memcg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-unnecessary-uses-of-lock_page_memcg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: remove unnecessary uses of lock_page_memcg()

There are several users that nest lock_page_memcg() inside lock_page() to
prevent page->mem_cgroup from changing.  But the page lock prevents pages
from moving between cgroups, so that is unnecessary overhead.

Remove lock_page_memcg() in contexts with locked contexts and fix the
debug code in the page stat functions to be okay with the page lock.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   12 +++++++-----
 mm/filemap.c               |    7 +------
 mm/page-writeback.c        |    2 --
 mm/truncate.c              |    3 ---
 mm/vmscan.c                |    4 ----
 5 files changed, 8 insertions(+), 20 deletions(-)

diff -puN include/linux/memcontrol.h~mm-remove-unnecessary-uses-of-lock_page_memcg include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-remove-unnecessary-uses-of-lock_page_memcg
+++ a/include/linux/memcontrol.h
@@ -28,6 +28,7 @@
 #include <linux/eventfd.h>
 #include <linux/mmzone.h>
 #include <linux/writeback.h>
+#include <linux/page-flags.h>
 
 struct mem_cgroup;
 struct page;
@@ -464,18 +465,19 @@ void unlock_page_memcg(struct page *page
  * @idx: page state item to account
  * @val: number of pages (positive or negative)
  *
- * Callers must use lock_page_memcg() to prevent double accounting
- * when the page is concurrently being moved to another memcg:
+ * The @page must be locked or the caller must use lock_page_memcg()
+ * to prevent double accounting when the page is concurrently being
+ * moved to another memcg:
  *
- *   lock_page_memcg(page);
+ *   lock_page(page) or lock_page_memcg(page)
  *   if (TestClearPageState(page))
  *     mem_cgroup_update_page_stat(page, state, -1);
- *   unlock_page_memcg(page);
+ *   unlock_page(page) or unlock_page_memcg(page)
  */
 static inline void mem_cgroup_update_page_stat(struct page *page,
 				 enum mem_cgroup_stat_index idx, int val)
 {
-	VM_BUG_ON(!rcu_read_lock_held());
+	VM_BUG_ON(!(rcu_read_lock_held() || PageLocked(page)));
 
 	if (page->mem_cgroup)
 		this_cpu_add(page->mem_cgroup->stat->count[idx], val);
diff -puN mm/filemap.c~mm-remove-unnecessary-uses-of-lock_page_memcg mm/filemap.c
--- a/mm/filemap.c~mm-remove-unnecessary-uses-of-lock_page_memcg
+++ a/mm/filemap.c
@@ -176,8 +176,7 @@ static void page_cache_tree_delete(struc
 /*
  * Delete a page from the page cache and free it. Caller has to make
  * sure the page is locked and that nobody else uses it - or that usage
- * is safe.  The caller must hold the mapping's tree_lock and
- * lock_page_memcg().
+ * is safe.  The caller must hold the mapping's tree_lock.
  */
 void __delete_from_page_cache(struct page *page, void *shadow)
 {
@@ -237,11 +236,9 @@ void delete_from_page_cache(struct page
 
 	freepage = mapping->a_ops->freepage;
 
-	lock_page_memcg(page);
 	spin_lock_irqsave(&mapping->tree_lock, flags);
 	__delete_from_page_cache(page, NULL);
 	spin_unlock_irqrestore(&mapping->tree_lock, flags);
-	unlock_page_memcg(page);
 
 	if (freepage)
 		freepage(page);
@@ -538,7 +535,6 @@ int replace_page_cache_page(struct page
 		new->mapping = mapping;
 		new->index = offset;
 
-		lock_page_memcg(old);
 		spin_lock_irqsave(&mapping->tree_lock, flags);
 		__delete_from_page_cache(old, NULL);
 		error = radix_tree_insert(&mapping->page_tree, offset, new);
@@ -553,7 +549,6 @@ int replace_page_cache_page(struct page
 		if (PageSwapBacked(new))
 			__inc_zone_page_state(new, NR_SHMEM);
 		spin_unlock_irqrestore(&mapping->tree_lock, flags);
-		unlock_page_memcg(old);
 		mem_cgroup_migrate(old, new);
 		radix_tree_preload_end();
 		if (freepage)
diff -puN mm/page-writeback.c~mm-remove-unnecessary-uses-of-lock_page_memcg mm/page-writeback.c
--- a/mm/page-writeback.c~mm-remove-unnecessary-uses-of-lock_page_memcg
+++ a/mm/page-writeback.c
@@ -2700,7 +2700,6 @@ int clear_page_dirty_for_io(struct page
 		 * always locked coming in here, so we get the desired
 		 * exclusion.
 		 */
-		lock_page_memcg(page);
 		wb = unlocked_inode_to_wb_begin(inode, &locked);
 		if (TestClearPageDirty(page)) {
 			mem_cgroup_dec_page_stat(page, MEM_CGROUP_STAT_DIRTY);
@@ -2709,7 +2708,6 @@ int clear_page_dirty_for_io(struct page
 			ret = 1;
 		}
 		unlocked_inode_to_wb_end(inode, locked);
-		unlock_page_memcg(page);
 		return ret;
 	}
 	return TestClearPageDirty(page);
diff -puN mm/truncate.c~mm-remove-unnecessary-uses-of-lock_page_memcg mm/truncate.c
--- a/mm/truncate.c~mm-remove-unnecessary-uses-of-lock_page_memcg
+++ a/mm/truncate.c
@@ -527,7 +527,6 @@ invalidate_complete_page2(struct address
 	if (page_has_private(page) && !try_to_release_page(page, GFP_KERNEL))
 		return 0;
 
-	lock_page_memcg(page);
 	spin_lock_irqsave(&mapping->tree_lock, flags);
 	if (PageDirty(page))
 		goto failed;
@@ -535,7 +534,6 @@ invalidate_complete_page2(struct address
 	BUG_ON(page_has_private(page));
 	__delete_from_page_cache(page, NULL);
 	spin_unlock_irqrestore(&mapping->tree_lock, flags);
-	unlock_page_memcg(page);
 
 	if (mapping->a_ops->freepage)
 		mapping->a_ops->freepage(page);
@@ -544,7 +542,6 @@ invalidate_complete_page2(struct address
 	return 1;
 failed:
 	spin_unlock_irqrestore(&mapping->tree_lock, flags);
-	unlock_page_memcg(page);
 	return 0;
 }
 
diff -puN mm/vmscan.c~mm-remove-unnecessary-uses-of-lock_page_memcg mm/vmscan.c
--- a/mm/vmscan.c~mm-remove-unnecessary-uses-of-lock_page_memcg
+++ a/mm/vmscan.c
@@ -607,7 +607,6 @@ static int __remove_mapping(struct addre
 	BUG_ON(!PageLocked(page));
 	BUG_ON(mapping != page_mapping(page));
 
-	lock_page_memcg(page);
 	spin_lock_irqsave(&mapping->tree_lock, flags);
 	/*
 	 * The non racy check for a busy page.
@@ -647,7 +646,6 @@ static int __remove_mapping(struct addre
 		mem_cgroup_swapout(page, swap);
 		__delete_from_swap_cache(page);
 		spin_unlock_irqrestore(&mapping->tree_lock, flags);
-		unlock_page_memcg(page);
 		swapcache_free(swap);
 	} else {
 		void (*freepage)(struct page *);
@@ -675,7 +673,6 @@ static int __remove_mapping(struct addre
 			shadow = workingset_eviction(mapping, page);
 		__delete_from_page_cache(page, shadow);
 		spin_unlock_irqrestore(&mapping->tree_lock, flags);
-		unlock_page_memcg(page);
 
 		if (freepage != NULL)
 			freepage(page);
@@ -685,7 +682,6 @@ static int __remove_mapping(struct addre
 
 cannot_free:
 	spin_unlock_irqrestore(&mapping->tree_lock, flags);
-	unlock_page_memcg(page);
 	return 0;
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

proc-revert-proc-pid-maps-annotation.patch
mm-memcontrol-drop-superfluous-entry-in-the-per-memcg-stats-array.patch
documentation-cgroup-v2-add-memorystat-sock-description.patch
mm-memcontrol-generalize-locking-for-the-page-mem_cgroup-binding.patch
mm-workingset-define-radix-entry-eviction-mask.patch
mm-workingset-separate-shadow-unpacking-and-refault-calculation.patch
mm-workingset-eviction-buckets-for-bigmem-lowbit-machines.patch
mm-workingset-per-cgroup-cache-thrash-detection.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages.patch
mm-simplify-lock_page_memcg.patch
mm-remove-unnecessary-uses-of-lock_page_memcg.patch
mm-oom_killc-dont-skip-pf_exiting-tasks-when-searching-for-a-victim.patch

