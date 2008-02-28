From: akpm@linux-foundation.org
Subject: + memcg-move_lists-on-page-not-page_cgroup.patch added to -mm tree
Date: Wed, 27 Feb 2008 19:52:32 -0800
Message-ID: <200802280352.m1S3qWLU014205@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55562 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753320AbYB1DxG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 22:53:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, rientjes@google.com, taka@valinux.co.jp, yamamoto@valinux.co.jp


The patch titled
     memcg: move_lists on page not page_cgroup
has been added to the -mm tree.  Its filename is
     memcg-move_lists-on-page-not-page_cgroup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: move_lists on page not page_cgroup
From: Hugh Dickins <hugh@veritas.com>

Each caller of mem_cgroup_move_lists is having to use page_get_page_cgroup:
it's more convenient if it acts upon the page itself not the page_cgroup; and
in a later patch this becomes important to handle within memcontrol.c.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: David Rientjes <rientjes@google.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    5 ++---
 mm/memcontrol.c            |    4 +++-
 mm/swap.c                  |    2 +-
 mm/vmscan.c                |    5 +++--
 4 files changed, 9 insertions(+), 7 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-move_lists-on-page-not-page_cgroup include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-move_lists-on-page-not-page_cgroup
+++ a/include/linux/memcontrol.h
@@ -36,7 +36,7 @@ extern int mem_cgroup_charge(struct page
 				gfp_t gfp_mask);
 extern void mem_cgroup_uncharge(struct page_cgroup *pc);
 extern void mem_cgroup_uncharge_page(struct page *page);
-extern void mem_cgroup_move_lists(struct page_cgroup *pc, bool active);
+extern void mem_cgroup_move_lists(struct page *page, bool active);
 extern unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
 					struct list_head *dst,
 					unsigned long *scanned, int order,
@@ -106,8 +106,7 @@ static inline void mem_cgroup_uncharge_p
 {
 }
 
-static inline void mem_cgroup_move_lists(struct page_cgroup *pc,
-						bool active)
+static inline void mem_cgroup_move_lists(struct page *page, bool active)
 {
 }
 
diff -puN mm/memcontrol.c~memcg-move_lists-on-page-not-page_cgroup mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-move_lists-on-page-not-page_cgroup
+++ a/mm/memcontrol.c
@@ -407,11 +407,13 @@ int task_in_mem_cgroup(struct task_struc
 /*
  * This routine assumes that the appropriate zone's lru lock is already held
  */
-void mem_cgroup_move_lists(struct page_cgroup *pc, bool active)
+void mem_cgroup_move_lists(struct page *page, bool active)
 {
+	struct page_cgroup *pc;
 	struct mem_cgroup_per_zone *mz;
 	unsigned long flags;
 
+	pc = page_get_page_cgroup(page);
 	if (!pc)
 		return;
 
diff -puN mm/swap.c~memcg-move_lists-on-page-not-page_cgroup mm/swap.c
--- a/mm/swap.c~memcg-move_lists-on-page-not-page_cgroup
+++ a/mm/swap.c
@@ -176,7 +176,7 @@ void activate_page(struct page *page)
 		SetPageActive(page);
 		add_page_to_active_list(zone, page);
 		__count_vm_event(PGACTIVATE);
-		mem_cgroup_move_lists(page_get_page_cgroup(page), true);
+		mem_cgroup_move_lists(page, true);
 	}
 	spin_unlock_irq(&zone->lru_lock);
 }
diff -puN mm/vmscan.c~memcg-move_lists-on-page-not-page_cgroup mm/vmscan.c
--- a/mm/vmscan.c~memcg-move_lists-on-page-not-page_cgroup
+++ a/mm/vmscan.c
@@ -1128,7 +1128,7 @@ static void shrink_active_list(unsigned 
 		ClearPageActive(page);
 
 		list_move(&page->lru, &zone->inactive_list);
-		mem_cgroup_move_lists(page_get_page_cgroup(page), false);
+		mem_cgroup_move_lists(page, false);
 		pgmoved++;
 		if (!pagevec_add(&pvec, page)) {
 			__mod_zone_page_state(zone, NR_INACTIVE, pgmoved);
@@ -1156,8 +1156,9 @@ static void shrink_active_list(unsigned 
 		VM_BUG_ON(PageLRU(page));
 		SetPageLRU(page);
 		VM_BUG_ON(!PageActive(page));
+
 		list_move(&page->lru, &zone->active_list);
-		mem_cgroup_move_lists(page_get_page_cgroup(page), true);
+		mem_cgroup_move_lists(page, true);
 		pgmoved++;
 		if (!pagevec_add(&pvec, page)) {
 			__mod_zone_page_state(zone, NR_ACTIVE, pgmoved);
_

Patches currently in -mm which might be from hugh@veritas.com are

git-unionfs.patch
memcg-mm_match_cgroup-not-vm_match_cgroup.patch
memcg-move_lists-on-page-not-page_cgroup.patch
memcg-page_cache_release-not-__free_page.patch
memcg-when-do_swaps-do_wp_page-fails.patch
memcg-fix-vm_bug_on-from-page-migration.patch
memcg-bad-page-if-page_cgroup-when-free.patch
memcg-mem_cgroup_charge-never-null.patch
memcg-remove-mem_cgroup_uncharge.patch
memcg-memcontrol-whitespace-cleanups.patch
memcg-memcontrol-uninlined-and-static.patch
memcg-remove-clear_page_cgroup-and-atomics.patch
memcg-css_put-after-remove_list.patch
memcg-fix-mem_cgroup_move_lists-locking.patch
memcg-simplify-force_empty-and-move_lists.patch
memcg-fix-oops-on-null-lru-list.patch
mmap_region-cleanup-the-final-vma_merge-related-code.patch
mm-try-both-endianess-when-checking-for-endianess.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
prio_tree-debugging-patch.patch
