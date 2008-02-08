From: akpm@linux-foundation.org
Subject: - memcgroup-fix-hang-with-shmem-tmpfs.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:04:19 -0800
Message-ID: <200802080804.m18840ac014163@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38973 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760799AbYBHIUw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:20:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     memcgroup: fix hang with shmem/tmpfs
has been removed from the -mm tree.  Its filename was
     memcgroup-fix-hang-with-shmem-tmpfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcgroup: fix hang with shmem/tmpfs
From: Hugh Dickins <hugh@veritas.com>

The memcgroup regime relies upon a cgroup reclaiming pages from itself within
add_to_page_cache: which may involve some waiting.  Whereas shmem and tmpfs
rely upon using add_to_page_cache while holding a spinlock: when it cannot
wait.  The consequence is that when a cgroup reaches its limit, shmem_getpage
just hangs - unless there is outside memory pressure too, neither kswapd nor
radix_tree_preload get it out of the retry loop.

In most cases we can mem_cgroup_cache_charge the page waitably first, to
attach the page_cgroup in advance, so add_to_page_cache will do no more than
increment a count; then mem_cgroup_uncharge_page after (in both success and
failure cases) to balance the books again.

And where there used to be a congestion_wait for kswapd (recently made
redundant by radix_tree_preload), use mem_cgroup_cache_charge with NULL page
to go through a cycle of allocation and freeing, without accounting to any
particular page, and without updating the statistics vector.  This brings the
cgroup below its limit so the next try usually succeeds.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   37 +++++++++++++++++++++----------------
 mm/shmem.c      |   28 +++++++++++++++++++++++++++-
 2 files changed, 48 insertions(+), 17 deletions(-)

diff -puN mm/memcontrol.c~memcgroup-fix-hang-with-shmem-tmpfs mm/memcontrol.c
--- a/mm/memcontrol.c~memcgroup-fix-hang-with-shmem-tmpfs
+++ a/mm/memcontrol.c
@@ -329,23 +329,26 @@ static int mem_cgroup_charge_common(stru
 	 * with it
 	 */
 retry:
-	lock_page_cgroup(page);
-	pc = page_get_page_cgroup(page);
-	/*
-	 * The page_cgroup exists and the page has already been accounted
-	 */
-	if (pc) {
-		if (unlikely(!atomic_inc_not_zero(&pc->ref_cnt))) {
-			/* this page is under being uncharged ? */
-			unlock_page_cgroup(page);
-			cpu_relax();
-			goto retry;
-		} else {
-			unlock_page_cgroup(page);
-			goto done;
+	if (page) {
+		lock_page_cgroup(page);
+		pc = page_get_page_cgroup(page);
+		/*
+		 * The page_cgroup exists and
+		 * the page has already been accounted.
+		 */
+		if (pc) {
+			if (unlikely(!atomic_inc_not_zero(&pc->ref_cnt))) {
+				/* this page is under being uncharged ? */
+				unlock_page_cgroup(page);
+				cpu_relax();
+				goto retry;
+			} else {
+				unlock_page_cgroup(page);
+				goto done;
+			}
 		}
+		unlock_page_cgroup(page);
 	}
-	unlock_page_cgroup(page);
 
 	pc = kzalloc(sizeof(struct page_cgroup), gfp_mask);
 	if (pc == NULL)
@@ -404,7 +407,7 @@ retry:
 	if (ctype == MEM_CGROUP_CHARGE_TYPE_CACHE)
 		pc->flags |= PAGE_CGROUP_FLAG_CACHE;
 
-	if (page_cgroup_assign_new_page_cgroup(page, pc)) {
+	if (!page || page_cgroup_assign_new_page_cgroup(page, pc)) {
 		/*
 		 * Another charge has been added to this page already.
 		 * We take lock_page_cgroup(page) again and read
@@ -413,6 +416,8 @@ retry:
 		res_counter_uncharge(&mem->res, PAGE_SIZE);
 		css_put(&mem->css);
 		kfree(pc);
+		if (!page)
+			goto done;
 		goto retry;
 	}
 
diff -puN mm/shmem.c~memcgroup-fix-hang-with-shmem-tmpfs mm/shmem.c
--- a/mm/shmem.c~memcgroup-fix-hang-with-shmem-tmpfs
+++ a/mm/shmem.c
@@ -912,9 +912,13 @@ found:
 	error = 1;
 	if (!inode)
 		goto out;
-	error = radix_tree_preload(GFP_KERNEL);
+	/* Precharge page while we can wait, compensate afterwards */
+	error = mem_cgroup_cache_charge(page, current->mm, GFP_KERNEL);
 	if (error)
 		goto out;
+	error = radix_tree_preload(GFP_KERNEL);
+	if (error)
+		goto uncharge;
 	error = 1;
 
 	spin_lock(&info->lock);
@@ -947,6 +951,8 @@ found:
 		shmem_swp_unmap(ptr);
 	spin_unlock(&info->lock);
 	radix_tree_preload_end();
+uncharge:
+	mem_cgroup_uncharge_page(page);
 out:
 	unlock_page(page);
 	page_cache_release(page);
@@ -1308,6 +1314,13 @@ repeat:
 			spin_unlock(&info->lock);
 			unlock_page(swappage);
 			page_cache_release(swappage);
+			if (error == -ENOMEM) {
+				/* allow reclaim from this memory cgroup */
+				error = mem_cgroup_cache_charge(NULL,
+					current->mm, gfp & ~__GFP_HIGHMEM);
+				if (error)
+					goto failed;
+			}
 			goto repeat;
 		}
 	} else if (sgp == SGP_READ && !filepage) {
@@ -1353,6 +1366,17 @@ repeat:
 				goto failed;
 			}
 
+			/* Precharge page while we can wait, compensate after */
+			error = mem_cgroup_cache_charge(filepage, current->mm,
+							gfp & ~__GFP_HIGHMEM);
+			if (error) {
+				page_cache_release(filepage);
+				shmem_unacct_blocks(info->flags, 1);
+				shmem_free_blocks(inode, 1);
+				filepage = NULL;
+				goto failed;
+			}
+
 			spin_lock(&info->lock);
 			entry = shmem_swp_alloc(info, idx, sgp);
 			if (IS_ERR(entry))
@@ -1364,6 +1388,7 @@ repeat:
 			if (error || swap.val || 0 != add_to_page_cache_lru(
 					filepage, mapping, idx, GFP_NOWAIT)) {
 				spin_unlock(&info->lock);
+				mem_cgroup_uncharge_page(filepage);
 				page_cache_release(filepage);
 				shmem_unacct_blocks(info->flags, 1);
 				shmem_free_blocks(inode, 1);
@@ -1372,6 +1397,7 @@ repeat:
 					goto failed;
 				goto repeat;
 			}
+			mem_cgroup_uncharge_page(filepage);
 			info->flags |= SHMEM_PAGEIN;
 		}
 
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
git-unionfs.patch
git-x86.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
mount-options-fix-tmpfs.patch
mount-options-fix-tmpfs-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
prio_tree-debugging-patch.patch
