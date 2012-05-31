From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-change-behavior-of-shared-anon-at-moving-task.patch removed from -mm tree
Date: Thu, 31 May 2012 12:16:40 -0700
Message-ID: <20120531191640.8DF79A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:34772 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932955Ab2EaTQm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 May 2012 15:16:42 -0400
Received: by mail-lpp01m010-f74.google.com with SMTP id r15so75709lag.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:16:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, glommer@parallels.com, hannes@cmpxchg.org, hughd@google.com, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: fix/change behavior of shared anon at moving task
has been removed from the -mm tree.  Its filename was
     memcg-fix-change-behavior-of-shared-anon-at-moving-task.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -184,12 +184,14 @@ behind this approach is that a cgroup th
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
@@ -615,8 +617,7 @@ memory cgroup.
   bit | what type of charges would be moved ?
  -----+------------------------------------------------------------------------
    0  | A charge of an anonymous page(or swap of it) used by the target task.
-      | Those pages and swaps must be used only by the target task. You must
-      | enable Swap Extension(see 2.4) to enable move of swap charges.
+      | You must enable Swap Extension(see 2.4) to enable move of swap charges.
  -----+------------------------------------------------------------------------
    1  | A charge of file pages(normal file, tmpfs file(e.g. ipc shared memory)
       | and swaps of tmpfs file) mmapped by the target task. Unlike the case of
@@ -629,8 +630,6 @@ memory cgroup.
 
 8.3 TODO
 
-- Implement madvise(2) to let users decide the vma to be moved or not to be
-  moved.
 - All of moving charge operations are done under cgroup_mutex. It's not good
   behavior to hold the mutex too long, so we may need some trick.
 
diff -puN include/linux/swap.h~memcg-fix-change-behavior-of-shared-anon-at-moving-task include/linux/swap.h
--- a/include/linux/swap.h~memcg-fix-change-behavior-of-shared-anon-at-moving-task
+++ a/include/linux/swap.h
@@ -359,7 +359,6 @@ struct backing_dev_info;
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 extern void
 mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout);
-extern int mem_cgroup_count_swap_user(swp_entry_t ent, struct page **pagep);
 #else
 static inline void
 mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout)
@@ -470,14 +469,6 @@ mem_cgroup_uncharge_swapcache(struct pag
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
@@ -5154,7 +5154,7 @@ static struct page *mc_handle_present_pt
 		return NULL;
 	if (PageAnon(page)) {
 		/* we don't move shared anon */
-		if (!move_anon() || page_mapcount(page) > 2)
+		if (!move_anon())
 			return NULL;
 	} else if (!move_file())
 		/* we ignore mapcount for file pages */
@@ -5165,26 +5165,32 @@ static struct page *mc_handle_present_pt
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
-
 #ifdef CONFIG_HIBERNATION
 /*
  * Find the swap type that corresponds to given device (if any).
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
linux-next.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlbfs-dont-use-err_ptr-with-vm_fault-values.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
hugetlb-simplify-migrate_huge_page-fix.patch
memcg-add-hugetlb-extension.patch
memcg-add-hugetlb-extension-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch
hugetlb-add-charge-uncharge-calls-for-hugetlb-alloc-free.patch
memcg-track-resource-index-in-cftype-private.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-add-failcnt-support-for-hugetlb-extension.patch
hugetlbfs-add-a-list-for-tracking-in-use-hugetlb-pages.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration.patch
memcg-add-memory-controller-documentation-for-hugetlb-management.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-fixes.patch
memcg-use-res_counter_uncharge_until-in-mem_cgroup_move_hugetlb_parent.patch
memcg-move-charges-to-root-cgroup-if-use_hierarchy=0-in-mem_cgroup_move_hugetlb_parent.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9-fix.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch
c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch
c-r-prctl-simplify-pr_set_mm-on-mm-code-data-assignment.patch
c-r-prctl-simplify-pr_set_mm-on-mm-code-data-assignment-fix.patch
c-r-prctl-return-efault-instead-of-einval-in-case-if-underlied-vma-is-not-found.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-add-minimal-address-test-to-pr_set_mm.patch
c-r-prctl-drop-vma-flags-test-on-pr_set_mm_-stack-data-assignment.patch

