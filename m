From: akpm@linux-foundation.org
Subject: + memcg-change-behavior-of-moving-charges-at-task-move.patch added to -mm tree
Date: Thu, 22 Mar 2012 14:36:17 -0700
Message-ID: <20120322213617.D03ECA028B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:37765 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759957Ab2CVVgU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 17:36:20 -0400
Received: by wgbdt11 with SMTP id dt11so82441wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 14:36:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, glommer@parallels.com, hannes@cmpxchg.org, hughd@google.com, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com


The patch titled
     Subject: memcg: change behavior of moving charges at task move
has been added to the -mm tree.  Its filename is
     memcg-change-behavior-of-moving-charges-at-task-move.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: memcg: change behavior of moving charges at task move

In documentation, it's said that 'shared anon are not moved'.  But in
implementation, the check was wrong.

  if (!move_anon() || page_mapcount(page) > 2)

Ah, memcg has been moving shared anon pages for a long time.

Then, here is a discussion about handling of shared anon pages.

 - It's complex
 - Now, shared file caches are moved in force.
 - It adds unclear check as page_mapcount(). To do correct check,
   we should check swap users, etc.
 - No one notice this implementation behavior. So, no one get benefit
   from the design.
 - In general, once task is moved to a cgroup for running, it will not
   be moved....
 - Finally, we have control knob as memory.move_charge_at_immigrate.

Here is a patch to allow moving shared pages, completely. This makes
memcg simpler and fix current broken code.

Note:
 IIUC, libcgroup's cgroup daemon moves tasks after exec().
 So, it's not affected.
 libcgroup's command "cgexec" does move itsef to a memcg and call exec()
 without fork(). it's not affected.

Suggested-by: Hugh Dickins <hughd@google.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |    9 +++-----
 include/linux/swap.h             |    9 --------
 mm/memcontrol.c                  |   15 ++++++--------
 mm/swapfile.c                    |   31 -----------------------------
 4 files changed, 11 insertions(+), 53 deletions(-)

diff -puN Documentation/cgroups/memory.txt~memcg-change-behavior-of-moving-charges-at-task-move Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-change-behavior-of-moving-charges-at-task-move
+++ a/Documentation/cgroups/memory.txt
@@ -185,12 +185,14 @@ behind this approach is that a cgroup th
 page will eventually get charged for it (once it is uncharged from
 the cgroup that brought it in -- this will happen on memory pressure).
 
+But see section 8.2: when moving a task to another cgroup, its pages may
+be recharged to the new cgroup, if move_charge_at_immigrate has been chosen.
+
 Exception: If CONFIG_CGROUP_CGROUP_MEM_RES_CTLR_SWAP is not used.
 When you do swapoff and make swapped-out pages of shmem(tmpfs) to
 be backed into memory in force, charges for pages are accounted against the
 caller of swapoff rather than the users of shmem.
 
-
 2.4 Swap Extension (CONFIG_CGROUP_MEM_RES_CTLR_SWAP)
 
 Swap Extension allows you to record charge for swap. A swapped-in page is
@@ -623,8 +625,7 @@ memory cgroup.
   bit | what type of charges would be moved ?
  -----+------------------------------------------------------------------------
    0  | A charge of an anonymous page(or swap of it) used by the target task.
-      | Those pages and swaps must be used only by the target task. You must
-      | enable Swap Extension(see 2.4) to enable move of swap charges.
+      | You must enable Swap Extension(see 2.4) to enable move of swap charges.
  -----+------------------------------------------------------------------------
    1  | A charge of file pages(normal file, tmpfs file(e.g. ipc shared memory)
       | and swaps of tmpfs file) mmapped by the target task. Unlike the case of
@@ -637,8 +638,6 @@ memory cgroup.
 
 8.3 TODO
 
-- Implement madvise(2) to let users decide the vma to be moved or not to be
-  moved.
 - All of moving charge operations are done under cgroup_mutex. It's not good
   behavior to hold the mutex too long, so we may need some trick.
 
diff -puN include/linux/swap.h~memcg-change-behavior-of-moving-charges-at-task-move include/linux/swap.h
--- a/include/linux/swap.h~memcg-change-behavior-of-moving-charges-at-task-move
+++ a/include/linux/swap.h
@@ -387,7 +387,6 @@ static inline void deactivate_swap_token
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 extern void
 mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout);
-extern int mem_cgroup_count_swap_user(swp_entry_t ent, struct page **pagep);
 #else
 static inline void
 mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout)
@@ -532,14 +531,6 @@ mem_cgroup_uncharge_swapcache(struct pag
 {
 }
 
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
-static inline int
-mem_cgroup_count_swap_user(swp_entry_t ent, struct page **pagep)
-{
-	return 0;
-}
-#endif
-
 #endif /* CONFIG_SWAP */
 #endif /* __KERNEL__*/
 #endif /* _LINUX_SWAP_H */
diff -puN mm/memcontrol.c~memcg-change-behavior-of-moving-charges-at-task-move mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-change-behavior-of-moving-charges-at-task-move
+++ a/mm/memcontrol.c
@@ -5147,7 +5147,7 @@ static struct page *mc_handle_present_pt
 		return NULL;
 	if (PageAnon(page)) {
 		/* we don't move shared anon */
-		if (!move_anon() || page_mapcount(page) > 2)
+		if (!move_anon())
 			return NULL;
 	} else if (!move_file())
 		/* we ignore mapcount for file pages */
@@ -5161,18 +5161,17 @@ static struct page *mc_handle_present_pt
 static struct page *mc_handle_swap_pte(struct vm_area_struct *vma,
 			unsigned long addr, pte_t ptent, swp_entry_t *entry)
 {
-	int usage_count;
 	struct page *page = NULL;
 	swp_entry_t ent = pte_to_swp_entry(ptent);
 
 	if (!move_anon() || non_swap_entry(ent))
 		return NULL;
-	usage_count = mem_cgroup_count_swap_user(ent, &page);
-	if (usage_count > 1) { /* we don't move shared anon */
-		if (page)
-			put_page(page);
-		return NULL;
-	}
+#ifdef CONFIG_SWAP
+	/*
+	 * Avoid lookup_swap_cache() not to update statistics.
+	 */
+	page = find_get_page(&swapper_space, ent.val);
+#endif
 	if (do_swap_account)
 		entry->val = ent.val;
 
diff -puN mm/swapfile.c~memcg-change-behavior-of-moving-charges-at-task-move mm/swapfile.c
--- a/mm/swapfile.c~memcg-change-behavior-of-moving-charges-at-task-move
+++ a/mm/swapfile.c
@@ -717,37 +717,6 @@ int free_swap_and_cache(swp_entry_t entr
 	return p != NULL;
 }
 
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
-/**
- * mem_cgroup_count_swap_user - count the user of a swap entry
- * @ent: the swap entry to be checked
- * @pagep: the pointer for the swap cache page of the entry to be stored
- *
- * Returns the number of the user of the swap entry. The number is valid only
- * for swaps of anonymous pages.
- * If the entry is found on swap cache, the page is stored to pagep with
- * refcount of it being incremented.
- */
-int mem_cgroup_count_swap_user(swp_entry_t ent, struct page **pagep)
-{
-	struct page *page;
-	struct swap_info_struct *p;
-	int count = 0;
-
-	page = find_get_page(&swapper_space, ent.val);
-	if (page)
-		count += page_mapcount(page);
-	p = swap_info_get(ent);
-	if (p) {
-		count += swap_count(p->swap_map[swp_offset(ent)]);
-		spin_unlock(&swap_lock);
-	}
-
-	*pagep = page;
-	return count;
-}
-#endif
