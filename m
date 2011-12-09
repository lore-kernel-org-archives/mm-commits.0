From: akpm@linux-foundation.org
Subject: + memcg-add-mem_cgroup_replace_page_cache-to-fix-lru-issue.patch added to -mm tree
Date: Fri, 09 Dec 2011 15:43:08 -0800
Message-ID: <201112092343.pB9Nh819028036@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:60383 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab1LIXnL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2011 18:43:11 -0500
Received: by mail-ey0-f202.google.com with SMTP id d1so22824eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 09 Dec 2011 15:43:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, hughd@google.com, mhocko@suse.cz, mszeredi@suse.cz


The patch titled
     Subject: memcg: add mem_cgroup_replace_page_cache() to fix LRU issue
has been added to the -mm tree.  Its filename is
     memcg-add-mem_cgroup_replace_page_cache-to-fix-lru-issue.patch

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

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 ++++
 mm/filemap.c               |   18 +-------------
 mm/memcontrol.c            |   44 +++++++++++++++++++++++++++++++++++
 3 files changed, 52 insertions(+), 16 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-add-mem_cgroup_replace_page_cache-to-fix-lru-issue include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-add-mem_cgroup_replace_page_cache-to-fix-lru-issue
+++ a/include/linux/memcontrol.h
@@ -119,6 +119,8 @@ struct zone_reclaim_stat*
 mem_cgroup_get_reclaim_stat_from_page(struct page *page);
 extern void mem_cgroup_print_oom_info(struct mem_cgroup *memcg,
 					struct task_struct *p);
+extern void mem_cgroup_replace_page_cache(struct page *oldpage,
+					struct page *newpage);
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 extern int do_swap_account;
@@ -366,6 +368,10 @@ static inline
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
@@ -3366,6 +3366,50 @@ void mem_cgroup_end_migration(struct mem
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
Subject: Subject: memcg: add mem_cgroup_replace_page_cache() to fix LRU issue

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
linux-next.patch
memcg-add-mem_cgroup_replace_page_cache-to-fix-lru-issue.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
mm-avoid-livelock-on-__gfp_fs-allocations-v2.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix.patch
vmscan-add-task-name-to-warn_scan_unevictable-messages.patch
mm-exclude-reserved-pages-from-dirtyable-memory.patch
mm-exclude-reserved-pages-from-dirtyable-memory-fix.patch
mm-writeback-cleanups-in-preparation-for-per-zone-dirty-limits.patch
mm-try-to-distribute-dirty-pages-fairly-across-zones.patch
mm-filemap-pass-__gfp_write-from-grab_cache_page_write_begin.patch
btrfs-pass-__gfp_write-for-buffered-write-page-allocations.patch
cgroup-fix-task-counter-common-ancestor-logic.patch
mm-memcg-consolidate-hierarchy-iteration-primitives.patch
mm-vmscan-distinguish-global-reclaim-from-global-lru-scanning.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned.patch
mm-memcg-per-priority-per-zone-hierarchy-scan-generations.patch
mm-move-memcg-hierarchy-reclaim-to-generic-reclaim-code.patch
mm-memcg-remove-optimization-of-keeping-the-root_mem_cgroup-lru-lists-empty.patch
mm-vmscan-convert-global-reclaim-to-per-memcg-lru-lists.patch
mm-collect-lru-list-heads-into-struct-lruvec.patch
mm-make-per-memcg-lru-lists-exclusive.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags-fix.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient-fix.patch
mm-memcg-shorten-preempt-disabled-section-around-event-checks.patch
documentation-cgroups-memorytxt-fix-typo.patch
memcg-fix-pgpgin-pgpgout-documentation.patch
mm-oom_kill-remove-memcg-argument-from-oom_kill_task.patch
mm-unify-remaining-mem_cont-mem-etc-variable-names-to-memcg.patch
mm-memcg-clean-up-fault-accounting.patch
mm-memcg-lookup_page_cgroup-almost-never-returns-null.patch
mm-page_cgroup-check-page_cgroup-arrays-in-lookup_page_cgroup-only-when-necessary.patch
mm-memcg-remove-unneeded-checks-from-newpage_charge.patch
mm-memcg-remove-unneeded-checks-from-uncharge_page.patch
page_cgroup-add-helper-function-to-get-swap_cgroup.patch

