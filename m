From: akpm@linux-foundation.org
Subject: + memcgroup-tidy-up-mem_cgroup_charge_common.patch added to -mm tree
Date: Tue, 18 Dec 2007 14:41:51 -0800
Message-ID: <200712182241.lBIMfp7B025702@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48124 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751535AbXLRWma (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Dec 2007 17:42:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     ] memcgroup: tidy up mem_cgroup_charge_common
has been added to the -mm tree.  Its filename is
     memcgroup-tidy-up-mem_cgroup_charge_common.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ] memcgroup: tidy up mem_cgroup_charge_common
From: Hugh Dickins <hugh@veritas.com>

Tidy up mem_cgroup_charge_common before extending it.  Adjust some comments,
but mainly clean up its loop: I've an aversion to loops full of continues,
then a break or a goto at the bottom.  And the is_atomic test should be on the
__GFP_WAIT bit, not GFP_ATOMIC bits.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   44 +++++++++++++++-----------------------------
 1 file changed, 15 insertions(+), 29 deletions(-)

diff -puN mm/memcontrol.c~memcgroup-tidy-up-mem_cgroup_charge_common mm/memcontrol.c
--- a/mm/memcontrol.c~memcgroup-tidy-up-mem_cgroup_charge_common
+++ a/mm/memcontrol.c
@@ -345,23 +345,22 @@ retry:
 			goto done;
 		}
 	}
-
 	unlock_page_cgroup(page);
 
 	pc = kzalloc(sizeof(struct page_cgroup), gfp_mask);
 	if (pc == NULL)
 		goto err;
 
-	rcu_read_lock();
 	/*
-	 * We always charge the cgroup the mm_struct belongs to
-	 * the mm_struct's mem_cgroup changes on task migration if the
+	 * We always charge the cgroup the mm_struct belongs to.
+	 * The mm_struct's mem_cgroup changes on task migration if the
 	 * thread group leader migrates. It's possible that mm is not
 	 * set, if so charge the init_mm (happens for pagecache usage).
 	 */
 	if (!mm)
 		mm = &init_mm;
 
+	rcu_read_lock();
 	mem = rcu_dereference(mm->mem_cgroup);
 	/*
 	 * For every charge from the cgroup, increment reference
@@ -375,12 +374,8 @@ retry:
 	 * the cgroup limit.
 	 */
 	while (res_counter_charge(&mem->res, PAGE_SIZE)) {
-		bool is_atomic = gfp_mask & GFP_ATOMIC;
-		/*
-		 * We cannot reclaim under GFP_ATOMIC, fail the charge
-		 */
-		if (is_atomic)
-			goto noreclaim;
+		if (!(gfp_mask & __GFP_WAIT))
+			goto out;
 
 		if (try_to_free_mem_cgroup_pages(mem, gfp_mask))
 			continue;
@@ -394,23 +389,12 @@ retry:
  		 */
 		if (res_counter_check_under_limit(&mem->res))
 			continue;
-			/*
-			 * Since we control both RSS and cache, we end up with a
-			 * very interesting scenario where we end up reclaiming
-			 * memory (essentially RSS), since the memory is pushed
-			 * to swap cache, we eventually end up adding those
-			 * pages back to our list. Hence we give ourselves a
-			 * few chances before we fail
-			 */
-		else if (nr_retries--) {
-			congestion_wait(WRITE, HZ/10);
-			continue;
+
+		if (!nr_retries--) {
+			mem_cgroup_out_of_memory(mem, gfp_mask);
+			goto out;
 		}
-noreclaim:
-		css_put(&mem->css);
-		if (!is_atomic)
-			mem_cgroup_out_of_memory(mem, GFP_KERNEL);
-		goto free_pc;
+		congestion_wait(WRITE, HZ/10);
 	}
 
 	atomic_set(&pc->ref_cnt, 1);
@@ -419,10 +403,11 @@ noreclaim:
 	pc->flags = 0;
 	if (ctype == MEM_CGROUP_CHARGE_TYPE_CACHE)
 		pc->flags |= PAGE_CGROUP_FLAG_CACHE;
+
 	if (page_cgroup_assign_new_page_cgroup(page, pc)) {
 		/*
-		 * an another charge is added to this page already.
-		 * we do take lock_page_cgroup(page) again and read
+		 * Another charge has been added to this page already.
+		 * We take lock_page_cgroup(page) again and read
 		 * page->cgroup, increment refcnt.... just retry is OK.
 		 */
 		res_counter_uncharge(&mem->res, PAGE_SIZE);
@@ -437,7 +422,8 @@ noreclaim:
 
 done:
 	return 0;
-free_pc:
+out:
+	css_put(&mem->css);
 	kfree(pc);
 err:
 	return -ENOMEM;
_

Patches currently in -mm which might be from hugh@veritas.com are

git-unionfs.patch
swapin_readahead-excise-numa-bogosity.patch
swapin_readahead-move-and-rearrange-args.patch
swapin-needs-gfp_mask-for-loop-on-tmpfs.patch
shmem-sgp_quick-and-sgp_fault-redundant.patch
shmem_getpage-return-page-locked.patch
shmem_file_write-is-redundant.patch
swapin-fix-valid_swaphandles-defect.patch
swapoff-scan-ptes-preemptibly.patch
shmem-factor-out-sbi-free_inodes-manipulations.patch
shmem-factor-out-sbi-free_inodes-manipulations-fix.patch
tmpfs-fix-mounts-when-size-is-less-than-the-page-size.patch
tmpfs-move-swap_state-stats-update.patch
tmpfs-shuffle-add_to_swap_caches.patch
tmpfs-move-swap-swizzling-into-shmem.patch
tmpfs-allow-filepage-alongside-swappage.patch
tmpfs-allocate-on-read-when-stacked.patch
tmpfs-make-shmem_unuse-more-preemptible.patch
tmpfs-open-a-window-in-shmem_unuse_inode.patch
tmpfs-radix_tree_preloading.patch
tmpfs-fix-shmem_swaplist-races.patch
maps4-add-proportional-set-size-accounting-in-smaps.patch
mm-dont-waste-swap-on-locked-pages.patch
skip-writing-data-pages-when-inode-is-under-i_sync.patch
printk-trivial-optimizations-fix.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
memcgroup-temporarily-revert-swapoff-mod.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-memcgroup-fix-try_to_free-order.patch
memcgroup-reinstate-swapoff-mod.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
memcgroup-tidy-up-mem_cgroup_charge_common.patch
memcgroup-fix-hang-with-shmem-tmpfs.patch
prio_tree-debugging-patch.patch
