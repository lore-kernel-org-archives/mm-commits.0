From: akpm@linux-foundation.org
Subject: - memcg-fix-gfp_mask-of-callers-of-charge.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:48:01 -0800
Message-ID: <200901082248.n08Mm1g8027403@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761552AbZAHWsk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:48:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: fix gfp_mask of callers of charge
has been removed from the -mm tree.  Its filename was
     memcg-fix-gfp_mask-of-callers-of-charge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix gfp_mask of callers of charge
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Fix misuse of gfp_kernel.

Now, most of callers of mem_cgroup_charge_xxx functions uses GFP_KERNEL.

I think that this is from the fact that page_cgroup *was* dynamically
allocated.

But now, we allocate all page_cgroup at boot.  And
mem_cgroup_try_to_free_pages() reclaim memory from GFP_HIGHUSER_MOVABLE +
specified GFP_RECLAIM_MASK.

  * This is because we just want to reduce memory usage.
    "Where we should reclaim from ?" is not a problem in memcg.

This patch modifies gfp masks to be GFP_HIGUSER_MOVABLE if possible.

Note: This patch is not for fixing behavior but for showing sane information
      in source code.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 +++++---
 mm/memory.c     |    9 +++++----
 mm/shmem.c      |    6 +++---
 mm/swapfile.c   |    2 +-
 4 files changed, 14 insertions(+), 11 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-gfp_mask-of-callers-of-charge mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-gfp_mask-of-callers-of-charge
+++ a/mm/memcontrol.c
@@ -808,8 +808,9 @@ int mem_cgroup_prepare_migration(struct 
 	}
 	unlock_page_cgroup(pc);
 	if (mem) {
-		ret = mem_cgroup_charge_common(newpage, NULL, GFP_KERNEL,
-			ctype, mem);
+		ret = mem_cgroup_charge_common(newpage, NULL,
+					GFP_HIGHUSER_MOVABLE,
+					ctype, mem);
 		css_put(&mem->css);
 	}
 	return ret;
@@ -889,7 +890,8 @@ static int mem_cgroup_resize_limit(struc
 			ret = -EBUSY;
 			break;
 		}
-		progress = try_to_free_mem_cgroup_pages(memcg, GFP_KERNEL);
+		progress = try_to_free_mem_cgroup_pages(memcg,
+				GFP_HIGHUSER_MOVABLE);
 		if (!progress)
 			retry_count--;
 	}
diff -puN mm/memory.c~memcg-fix-gfp_mask-of-callers-of-charge mm/memory.c
--- a/mm/memory.c~memcg-fix-gfp_mask-of-callers-of-charge
+++ a/mm/memory.c
@@ -2000,7 +2000,7 @@ gotten:
 	cow_user_page(new_page, old_page, address, vma);
 	__SetPageUptodate(new_page);
 
-	if (mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))
+	if (mem_cgroup_newpage_charge(new_page, mm, GFP_HIGHUSER_MOVABLE))
 		goto oom_free_new;
 
 	/*
@@ -2431,7 +2431,7 @@ static int do_swap_page(struct mm_struct
 	lock_page(page);
 	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
 
-	if (mem_cgroup_try_charge(mm, GFP_KERNEL, &ptr) == -ENOMEM) {
+	if (mem_cgroup_try_charge(mm, GFP_HIGHUSER_MOVABLE, &ptr) == -ENOMEM) {
 		ret = VM_FAULT_OOM;
 		unlock_page(page);
 		goto out;
@@ -2512,7 +2512,7 @@ static int do_anonymous_page(struct mm_s
 		goto oom;
 	__SetPageUptodate(page);
 
-	if (mem_cgroup_newpage_charge(page, mm, GFP_KERNEL))
+	if (mem_cgroup_newpage_charge(page, mm, GFP_HIGHUSER_MOVABLE))
 		goto oom_free_page;
 
 	entry = mk_pte(page, vma->vm_page_prot);
@@ -2603,7 +2603,8 @@ static int __do_fault(struct mm_struct *
 				ret = VM_FAULT_OOM;
 				goto out;
 			}
-			if (mem_cgroup_newpage_charge(page, mm, GFP_KERNEL)) {
+			if (mem_cgroup_newpage_charge(page,
+						mm, GFP_HIGHUSER_MOVABLE)) {
 				ret = VM_FAULT_OOM;
 				page_cache_release(page);
 				goto out;
diff -puN mm/shmem.c~memcg-fix-gfp_mask-of-callers-of-charge mm/shmem.c
--- a/mm/shmem.c~memcg-fix-gfp_mask-of-callers-of-charge
+++ a/mm/shmem.c
@@ -928,8 +928,8 @@ found:
 	error = 1;
 	if (!inode)
 		goto out;
-	/* Precharge page using GFP_KERNEL while we can wait */
-	error = mem_cgroup_cache_charge(page, current->mm, GFP_KERNEL);
+	/* Charge page using GFP_HIGHUSER_MOVABLE while we can wait */
+	error = mem_cgroup_cache_charge(page, current->mm, GFP_HIGHUSER_MOVABLE);
 	if (error)
 		goto out;
 	error = radix_tree_preload(GFP_KERNEL);
@@ -1379,7 +1379,7 @@ repeat:
 
 			/* Precharge page while we can wait, compensate after */
 			error = mem_cgroup_cache_charge(filepage, current->mm,
-							gfp & ~__GFP_HIGHMEM);
+					GFP_HIGHUSER_MOVABLE);
 			if (error) {
 				page_cache_release(filepage);
 				shmem_unacct_blocks(info->flags, 1);
diff -puN mm/swapfile.c~memcg-fix-gfp_mask-of-callers-of-charge mm/swapfile.c
--- a/mm/swapfile.c~memcg-fix-gfp_mask-of-callers-of-charge
+++ a/mm/swapfile.c
@@ -695,7 +695,7 @@ static int unuse_pte(struct vm_area_stru
 	pte_t *pte;
 	int ret = 1;
 
-	if (mem_cgroup_try_charge(vma->vm_mm, GFP_KERNEL, &ptr))
+	if (mem_cgroup_try_charge(vma->vm_mm, GFP_HIGHUSER_MOVABLE, &ptr))
 		ret = -ENOMEM;
 
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch

