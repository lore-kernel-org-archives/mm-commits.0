From: akpm@linux-foundation.org
Subject: - memcg-revert-gfp-mask-fix.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:48:52 -0800
Message-ID: <200901082248.n08MmqhK028180@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760964AbZAHWtd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:49:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, hugh@veritas.com, kosaki.motohiro@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: revert gfp mask fix
has been removed from the -mm tree.  Its filename was
     memcg-revert-gfp-mask-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: revert gfp mask fix
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

My patch, memcg-fix-gfp_mask-of-callers-of-charge.patch changed gfp_mask
of callers of charge to be GFP_HIGHUSER_MOVABLE for showing what will
happen at memory reclaim.

But in recent discussion, it's NACKed because it sounds ugly.

This patch is for reverting it and add some clean up to gfp_mask of
callers of charge.  No behavior change but need review before generating
HUNK in deep queue.

This patch also adds explanation to meaning of gfp_mask passed to charge
functions in memcontrol.h.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   10 ++++++++++
 mm/filemap.c               |    2 +-
 mm/memcontrol.c            |   10 +++++-----
 mm/memory.c                |   10 ++++------
 mm/shmem.c                 |    8 ++++----
 mm/swapfile.c              |    3 +--
 6 files changed, 25 insertions(+), 18 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-revert-gfp-mask-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-revert-gfp-mask-fix
+++ a/include/linux/memcontrol.h
@@ -26,6 +26,16 @@ struct page;
 struct mm_struct;
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
+/*
+ * All "charge" functions with gfp_mask should use GFP_KERNEL or
+ * (gfp_mask & GFP_RECLAIM_MASK). In current implementatin, memcg doesn't
+ * alloc memory but reclaims memory from all available zones. So, "where I want
+ * memory from" bits of gfp_mask has no meaning. So any bits of that field is
+ * available but adding a rule is better. charge functions' gfp_mask should
+ * be set to GFP_KERNEL or gfp_mask & GFP_RECLAIM_MASK for avoiding ambiguous
+ * codes.
+ * (Of course, if memcg does memory allocation in future, GFP_KERNEL is sane.)
+ */
 
 extern int mem_cgroup_newpage_charge(struct page *page, struct mm_struct *mm,
 				gfp_t gfp_mask);
diff -puN mm/filemap.c~memcg-revert-gfp-mask-fix mm/filemap.c
--- a/mm/filemap.c~memcg-revert-gfp-mask-fix
+++ a/mm/filemap.c
@@ -460,7 +460,7 @@ int add_to_page_cache_locked(struct page
 	VM_BUG_ON(!PageLocked(page));
 
 	error = mem_cgroup_cache_charge(page, current->mm,
-					gfp_mask & ~__GFP_HIGHMEM);
+					gfp_mask & GFP_RECLAIM_MASK);
 	if (error)
 		goto out;
 
diff -puN mm/memcontrol.c~memcg-revert-gfp-mask-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-revert-gfp-mask-fix
+++ a/mm/memcontrol.c
@@ -1248,7 +1248,7 @@ int mem_cgroup_prepare_migration(struct 
 	unlock_page_cgroup(pc);
 
 	if (mem) {
-		ret = mem_cgroup_try_charge(NULL, GFP_HIGHUSER_MOVABLE, &mem);
+		ret = mem_cgroup_try_charge(NULL, GFP_KERNEL, &mem);
 		css_put(&mem->css);
 	}
 	*ptr = mem;
@@ -1378,7 +1378,7 @@ static int mem_cgroup_resize_limit(struc
 			break;
 
 		progress = try_to_free_mem_cgroup_pages(memcg,
-				GFP_HIGHUSER_MOVABLE, false);
+				GFP_KERNEL, false);
   		if (!progress)			retry_count--;
 	}
 	return ret;
@@ -1418,7 +1418,7 @@ int mem_cgroup_resize_memsw_limit(struct
 			break;
 
 		oldusage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
-		try_to_free_mem_cgroup_pages(memcg, GFP_HIGHUSER_MOVABLE, true);
+		try_to_free_mem_cgroup_pages(memcg, GFP_KERNEL, true);
 		curusage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
 		if (curusage >= oldusage)
 			retry_count--;
@@ -1464,7 +1464,7 @@ static int mem_cgroup_force_empty_list(s
 		}
 		spin_unlock_irqrestore(&zone->lru_lock, flags);
 
-		ret = mem_cgroup_move_parent(pc, mem, GFP_HIGHUSER_MOVABLE);
+		ret = mem_cgroup_move_parent(pc, mem, GFP_KERNEL);
 		if (ret == -ENOMEM)
 			break;
 
@@ -1550,7 +1550,7 @@ try_to_free:
 			goto out;
 		}
 		progress = try_to_free_mem_cgroup_pages(mem,
-						  GFP_HIGHUSER_MOVABLE, false);
+						  GFP_KERNEL, false);
 		if (!progress) {
 			nr_retries--;
 			/* maybe some writeback is necessary */
diff -puN mm/memory.c~memcg-revert-gfp-mask-fix mm/memory.c
--- a/mm/memory.c~memcg-revert-gfp-mask-fix
+++ a/mm/memory.c
@@ -2000,7 +2000,7 @@ gotten:
 	cow_user_page(new_page, old_page, address, vma);
 	__SetPageUptodate(new_page);
 
-	if (mem_cgroup_newpage_charge(new_page, mm, GFP_HIGHUSER_MOVABLE))
+	if (mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))
 		goto oom_free_new;
 
 	/*
@@ -2431,8 +2431,7 @@ static int do_swap_page(struct mm_struct
 	lock_page(page);
 	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
 
-	if (mem_cgroup_try_charge_swapin(mm, page,
-				GFP_HIGHUSER_MOVABLE, &ptr) == -ENOMEM) {
+	if (mem_cgroup_try_charge_swapin(mm, page, GFP_KERNEL, &ptr)) {
 		ret = VM_FAULT_OOM;
 		unlock_page(page);
 		goto out;
@@ -2524,7 +2523,7 @@ static int do_anonymous_page(struct mm_s
 		goto oom;
 	__SetPageUptodate(page);
 
-	if (mem_cgroup_newpage_charge(page, mm, GFP_HIGHUSER_MOVABLE))
+	if (mem_cgroup_newpage_charge(page, mm, GFP_KERNEL))
 		goto oom_free_page;
 
 	entry = mk_pte(page, vma->vm_page_prot);
@@ -2615,8 +2614,7 @@ static int __do_fault(struct mm_struct *
 				ret = VM_FAULT_OOM;
 				goto out;
 			}
-			if (mem_cgroup_newpage_charge(page,
-						mm, GFP_HIGHUSER_MOVABLE)) {
+			if (mem_cgroup_newpage_charge(page, mm, GFP_KERNEL)) {
 				ret = VM_FAULT_OOM;
 				page_cache_release(page);
 				goto out;
diff -puN mm/shmem.c~memcg-revert-gfp-mask-fix mm/shmem.c
--- a/mm/shmem.c~memcg-revert-gfp-mask-fix
+++ a/mm/shmem.c
@@ -932,8 +932,8 @@ found:
 	 * Charge page using GFP_HIGHUSER_MOVABLE while we can wait.
 	 * charged back to the user(not to caller) when swap account is used.
 	 */
-	error = mem_cgroup_cache_charge_swapin(page,
-			current->mm, GFP_HIGHUSER_MOVABLE, true);
+	error = mem_cgroup_cache_charge_swapin(page, current->mm, GFP_KERNEL,
+					true);
 	if (error)
 		goto out;
 	error = radix_tree_preload(GFP_KERNEL);
@@ -1275,7 +1275,7 @@ repeat:
 			 * charge against this swap cache here.
 			 */
 			if (mem_cgroup_cache_charge_swapin(swappage,
-						current->mm, gfp, false)) {
+				current->mm, gfp & GFP_RECLAIM_MASK, false)) {
 				page_cache_release(swappage);
 				error = -ENOMEM;
 				goto failed;
@@ -1393,7 +1393,7 @@ repeat:
 
 			/* Precharge page while we can wait, compensate after */
 			error = mem_cgroup_cache_charge(filepage, current->mm,
-					GFP_HIGHUSER_MOVABLE);
+					GFP_KERNEL);
 			if (error) {
 				page_cache_release(filepage);
 				shmem_unacct_blocks(info->flags, 1);
diff -puN mm/swapfile.c~memcg-revert-gfp-mask-fix mm/swapfile.c
--- a/mm/swapfile.c~memcg-revert-gfp-mask-fix
+++ a/mm/swapfile.c
@@ -698,8 +698,7 @@ static int unuse_pte(struct vm_area_stru
 	pte_t *pte;
 	int ret = 1;
 
-	if (mem_cgroup_try_charge_swapin(vma->vm_mm, page,
-					GFP_HIGHUSER_MOVABLE, &ptr))
+	if (mem_cgroup_try_charge_swapin(vma->vm_mm, page, GFP_KERNEL, &ptr))
 		ret = -ENOMEM;
 
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch

