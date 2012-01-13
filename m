From: akpm@linux-foundation.org
Subject: [merged] memcg-add-mem_cgroup_replace_page_cache-to-fix-lru-issue.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:32:20 -0800
Message-ID: <20120113203220.C208B10004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:36212 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759086Ab2AMUcV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:32:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, hughd@google.com, mhocko@suse.cz, mszeredi@suse.cz, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: add mem_cgroup_replace_page_cache() to fix LRU issue
has been removed from the -mm tree.  Its filename was
     memcg-add-mem_cgroup_replace_page_cache-to-fix-lru-issue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: memcg: add mem_cgroup_replace_page_cache() to fix LRU issue

Commit ef6a3c6311 ("mm: add replace_page_cache_page() function") added a
function replace_page_cache_page().  This function replaces a page in the
radix-tree with a new page.  WHen doing this, memory cgroup needs to fix
up the accounting information.  memcg need to check PCG_USED bit etc.

In some(many?) cases, 'newpage' is on LRU before calling
replace_page_cache().  So, memcg's LRU accounting information should be
fixed, too.

This patch adds mem_cgroup_replace_page_cache() and removes the old hooks.
 In that function, old pages will be unaccounted without touching
res_counter and new page will be accounted to the memcg (of old page). 
WHen overwriting pc->mem_cgroup of newpage, take zone->lru_lock and avoid
races with LRU handling.

Background:
  replace_page_cache_page() is called by FUSE code in its splice() handling.
  Here, 'newpage' is replacing oldpage but this newpage is not a newly allocated
  page and may be on LRU. LRU mis-accounting will be critical for memory cgroup
  because rmdir() checks the whole LRU is empty and there is no account leak.
  If a page is on the other LRU than it should be, rmdir() will fail.

This bug was added in March 2011, but no bug report yet.  I guess there
are not many people who use memcg and FUSE at the same time with upstream
kernels.

The result of this bug is that admin cannot destroy a memcg because of
account leak.  So, no panic, no deadlock.  And, even if an active cgroup
exist, umount can succseed.  So no problem at shutdown.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 ++++
 mm/filemap.c               |   18 +-------------
 mm/memcontrol.c            |   44 +++++++++++++++++++++++++++++++++++
 3 files changed, 52 insertions(+), 16 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-add-mem_cgroup_replace_page_cache-to-fix-lru-issue include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-add-mem_cgroup_replace_page_cache-to-fix-lru-issue
+++ a/include/linux/memcontrol.h
@@ -122,6 +122,8 @@ struct zone_reclaim_stat*
 mem_cgroup_get_reclaim_stat_from_page(struct page *page);
 extern void mem_cgroup_print_oom_info(struct mem_cgroup *memcg,
 					struct task_struct *p);
+extern void mem_cgroup_replace_page_cache(struct page *oldpage,
+					struct page *newpage);
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 extern int do_swap_account;
@@ -369,6 +371,10 @@ static inline
 void mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx)
 {
 }
+static inline void mem_cgroup_replace_page_cache(struct page *oldpage,
+				struct page *newpage)
+{
+}
 #endif /* CONFIG_CGROUP_MEM_CONT */
 
 #if !defined(CONFIG_CGROUP_MEM_RES_CTLR) || !defined(CONFIG_DEBUG_VM)
diff -puN mm/filemap.c~memcg-add-mem_cgroup_replace_page_cache-to-fix-lru-issue mm/filemap.c
--- a/mm/filemap.c~memcg-add-mem_cgroup_replace_page_cache-to-fix-lru-issue
+++ a/mm/filemap.c
@@ -393,24 +393,11 @@ EXPORT_SYMBOL(filemap_write_and_wait_ran
 int replace_page_cache_page(struct page *old, struct page *new, gfp_t gfp_mask)
 {
 	int error;
-	struct mem_cgroup *memcg = NULL;
 
 	VM_BUG_ON(!PageLocked(old));
 	VM_BUG_ON(!PageLocked(new));
 	VM_BUG_ON(new->mapping);
 
-	/*
-	 * This is not page migration, but prepare_migration and
-	 * end_migration does enough work for charge replacement.
-	 *
-	 * In the longer term we probably want a specialized function
-	 * for moving the charge from old to new in a more efficient
-	 * manner.
-	 */
-	error = mem_cgroup_prepare_migration(old, new, &memcg, gfp_mask);
-	if (error)
-		return error;
-
 	error = radix_tree_preload(gfp_mask & ~__GFP_HIGHMEM);
 	if (!error) {
 		struct address_space *mapping = old->mapping;
@@ -432,13 +419,12 @@ int replace_page_cache_page(struct page 
 		if (PageSwapBacked(new))
 			__inc_zone_page_state(new, NR_SHMEM);
 		spin_unlock_irq(&mapping->tree_lock);
+		/* mem_cgroup codes must not be called under tree_lock */
+		mem_cgroup_replace_page_cache(old, new);
 		radix_tree_preload_end();
 		if (freepage)
 			freepage(old);
 		page_cache_release(old);
-		mem_cgroup_end_migration(memcg, old, new, true);
-	} else {
-		mem_cgroup_end_migration(memcg, old, new, false);
 	}
 
 	return error;
diff -puN mm/memcontrol.c~memcg-add-mem_cgroup_replace_page_cache-to-fix-lru-issue mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-mem_cgroup_replace_page_cache-to-fix-lru-issue
+++ a/mm/memcontrol.c
@@ -3432,6 +3432,50 @@ void mem_cgroup_end_migration(struct mem
 	cgroup_release_and_wakeup_rmdir(&memcg->css);
 }
 
+/*
+ * At replace page cache, newpage is not under any memcg but it's on
+ * LRU. So, this function doesn't touch res_counter but handles LRU
+ * in correct way. Both pages are locked so we cannot race with uncharge.
+ */
+void mem_cgroup_replace_page_cache(struct page *oldpage,
+				  struct page *newpage)
+{
+	struct mem_cgroup *memcg;
+	struct page_cgroup *pc;
+	struct zone *zone;
+	enum charge_type type = MEM_CGROUP_CHARGE_TYPE_CACHE;
+	unsigned long flags;
+
+	if (mem_cgroup_disabled())
+		return;
+
+	pc = lookup_page_cgroup(oldpage);
+	/* fix accounting on old pages */
+	lock_page_cgroup(pc);
+	memcg = pc->mem_cgroup;
+	mem_cgroup_charge_statistics(memcg, PageCgroupCache(pc), -1);
+	ClearPageCgroupUsed(pc);
+	unlock_page_cgroup(pc);
+
+	if (PageSwapBacked(oldpage))
+		type = MEM_CGROUP_CHARGE_TYPE_SHMEM;
+
+	zone = page_zone(newpage);
+	pc = lookup_page_cgroup(newpage);
+	/*
+	 * Even if newpage->mapping was NULL before starting replacement,
+	 * the newpage may be on LRU(or pagevec for LRU) already. We lock
+	 * LRU while we overwrite pc->mem_cgroup.
+	 */
+	spin_lock_irqsave(&zone->lru_lock, flags);
+	if (PageLRU(newpage))
+		del_page_from_lru_list(zone, newpage, page_lru(newpage));
+	__mem_cgroup_commit_charge(memcg, newpage, 1, pc, type);
+	if (PageLRU(newpage))
+		add_page_to_lru_list(zone, newpage, page_lru(newpage));
+	spin_unlock_irqrestore(&zone->lru_lock, flags);
+}
+
 #ifdef CONFIG_DEBUG_VM
 static struct page_cgroup *lookup_page_cgroup_used(struct page *page)
 {
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
mm-fix-null-ptr-dereference-in-__count_immobile_pages.patch
mm-__count_immobile_pages-make-sure-the-node-is-online.patch
mm-hugetlb-undo-change-to-page-mapcount-in-fault-handler.patch

