From: akpm@linux-foundation.org
Subject: + memcg-fix-change-behavior-of-shared-anon-at-moving-task.patch added to -mm tree
Date: Mon, 26 Mar 2012 16:46:28 -0700
Message-ID: <20120326234628.C600CA02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:52493 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab2CZXqb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 19:46:31 -0400
Received: by eekc41 with SMTP id c41so300098eek.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 16:46:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, glommer@parallels.com, hannes@cmpxchg.org, hughd@google.com, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com


The patch titled
     Subject: memcg: fix/change behavior of shared anon at moving task
has been added to the -mm tree.  Its filename is
     memcg-fix-change-behavior-of-shared-anon-at-moving-task.patch

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
Subject: memcg: fix/change behavior of shared anon at moving task

This patch changes memcg's behavior at task_move().

At task_move(), the kernel scans a task's page table and move the changes
for mapped pages from source cgroup to target cgroup.  There has been a
bug at handling shared anonymous pages for a long time.

Before patch:
  - The spec says 'shared anonymous pages are not moved.'
  - The implementation was 'shared anonymoys pages may be moved'.
    If page_mapcount <=2, shared anonymous pages's charge were moved.

After patch:
  - The spec says 'all anonymous pages are moved'.
  - The implementation is 'all anonymous pages are moved'.

Considering usage of memcg, this will not affect user's experience. 
'shared anonymous' pages only exists between a tree of processes which
don't do exec().  Moving one of process without exec() seems not sane. 
For example, libcgroup will not be affected by this change.  (Anyway, no
one noticed the implementation for a long time...)

Below is a discussion log:

 - current spec/implementation are complex
 - Now, shared file caches are moved
 - It adds unclear check as page_mapcount(). To do correct check,
   we should check swap users, etc.
 - No one notice this implementation behavior. So, no one get benefit
   from the design.
 - In general, once task is moved to a cgroup for running, it will not
   be moved....
 - Finally, we have control knob as memory.move_charge_at_immigrate.

Here is a patch to allow moving shared pages, completely. This makes
memcg simpler and fix current broken code.

Suggested-by: Hugh Dickins <hughd@google.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Glauber Costa <glommer@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |    9 +++-----
 include/linux/swap.h             |    9 --------
 mm/memcontrol.c                  |   22 +++++++++++++-------
 mm/swapfile.c                    |   31 -----------------------------
 4 files changed, 18 insertions(+), 53 deletions(-)

diff -puN Documentation/cgroups/memory.txt~memcg-fix-change-behavior-of-shared-anon-at-moving-task Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-fix-change-behavior-of-shared-anon-at-moving-task
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
 
diff -puN include/linux/swap.h~memcg-fix-change-behavior-of-shared-anon-at-moving-task include/linux/swap.h
--- a/include/linux/swap.h~memcg-fix-change-behavior-of-shared-anon-at-moving-task
+++ a/include/linux/swap.h
@@ -390,7 +390,6 @@ static inline void deactivate_swap_token
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 extern void
 mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout);
-extern int mem_cgroup_count_swap_user(swp_entry_t ent, struct page **pagep);
 #else
 static inline void
 mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout)
@@ -535,14 +534,6 @@ mem_cgroup_uncharge_swapcache(struct pag
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
diff -puN mm/memcontrol.c~memcg-fix-change-behavior-of-shared-anon-at-moving-task mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-change-behavior-of-shared-anon-at-moving-task
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
@@ -5158,26 +5158,32 @@ static struct page *mc_handle_present_pt
 	return page;
 }
 
+#ifdef CONFIG_SWAP
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
+	/*
+	 * Because lookup_swap_cache() updates some statistics counter,
+	 * we call find_get_page() with swapper_space directly.
+	 */
+	page = find_get_page(&swapper_space, ent.val);
 	if (do_swap_account)
 		entry->val = ent.val;
 
 	return page;
 }
+#else
+static struct page *mc_handle_swap_pte(struct vm_area_struct *vma,
+			unsigned long addr, pte_t ptent, swp_entry_t *entry)
+{
+	return NULL;
+}
+#endif
 
 static struct page *mc_handle_file_pte(struct vm_area_struct *vma,
 			unsigned long addr, pte_t ptent, swp_entry_t *entry)
diff -puN mm/swapfile.c~memcg-fix-change-behavior-of-shared-anon-at-moving-task mm/swapfile.c
--- a/mm/swapfile.c~memcg-fix-change-behavior-of-shared-anon-at-moving-task
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
