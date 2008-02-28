From: akpm@linux-foundation.org
Subject: + memcg-mem_cgroup_charge-never-null.patch added to -mm tree
Date: Wed, 27 Feb 2008 19:52:42 -0800
Message-ID: <200802280352.m1S3qgm0014220@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754114AbYB1DxG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 22:53:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, rientjes@google.com, taka@valinux.co.jp, yamamoto@valinux.co.jp


The patch titled
     memcg: mem_cgroup_charge never NULL
has been added to the -mm tree.  Its filename is
     memcg-mem_cgroup_charge-never-null.patch

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
Subject: memcg: mem_cgroup_charge never NULL
From: Hugh Dickins <hugh@veritas.com>

My memcgroup patch to fix hang with shmem/tmpfs added NULL page handling to
mem_cgroup_charge_common.  It seemed convenient at the time, but hard to
justify now: there's a perfectly appropriate swappage to charge and uncharge
instead, this is not on any hot path through shmem_getpage, and no performance
hit was observed from the slight extra overhead.

So revert that NULL page handling from mem_cgroup_charge_common; and make it
clearer by bringing page_cgroup_assign_new_page_cgroup into its body - that
was a helper I found more of a hindrance to understanding.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: David Rientjes <rientjes@google.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   61 +++++++++++++++-------------------------------
 mm/shmem.c      |    9 ++++--
 2 files changed, 27 insertions(+), 43 deletions(-)

diff -puN mm/memcontrol.c~memcg-mem_cgroup_charge-never-null mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-mem_cgroup_charge-never-null
+++ a/mm/memcontrol.c
@@ -301,25 +301,6 @@ static void __always_inline unlock_page_
 }
 
 /*
- * Tie new page_cgroup to struct page under lock_page_cgroup()
- * This can fail if the page has been tied to a page_cgroup.
- * If success, returns 0.
- */
-static int page_cgroup_assign_new_page_cgroup(struct page *page,
-						struct page_cgroup *pc)
-{
-	int ret = 0;
-
-	lock_page_cgroup(page);
-	if (!page_get_page_cgroup(page))
-		page_assign_page_cgroup(page, pc);
-	else /* A page is tied to other pc. */
-		ret = 1;
-	unlock_page_cgroup(page);
-	return ret;
-}
-
-/*
  * Clear page->page_cgroup member under lock_page_cgroup().
  * If given "pc" value is different from one page->page_cgroup,
  * page->cgroup is not cleared.
@@ -585,26 +566,24 @@ static int mem_cgroup_charge_common(stru
 	 * with it
 	 */
 retry:
-	if (page) {
-		lock_page_cgroup(page);
-		pc = page_get_page_cgroup(page);
-		/*
-		 * The page_cgroup exists and
-		 * the page has already been accounted.
-		 */
-		if (pc) {
-			if (unlikely(!atomic_inc_not_zero(&pc->ref_cnt))) {
-				/* this page is under being uncharged ? */
-				unlock_page_cgroup(page);
-				cpu_relax();
-				goto retry;
-			} else {
-				unlock_page_cgroup(page);
-				goto done;
-			}
+	lock_page_cgroup(page);
+	pc = page_get_page_cgroup(page);
+	/*
+	 * The page_cgroup exists and
+	 * the page has already been accounted.
+	 */
+	if (pc) {
+		if (unlikely(!atomic_inc_not_zero(&pc->ref_cnt))) {
+			/* this page is under being uncharged ? */
+			unlock_page_cgroup(page);
+			cpu_relax();
+			goto retry;
+		} else {
+			unlock_page_cgroup(page);
+			goto done;
 		}
-		unlock_page_cgroup(page);
 	}
+	unlock_page_cgroup(page);
 
 	pc = kzalloc(sizeof(struct page_cgroup), gfp_mask);
 	if (pc == NULL)
@@ -663,7 +642,9 @@ retry:
 	if (ctype == MEM_CGROUP_CHARGE_TYPE_CACHE)
 		pc->flags |= PAGE_CGROUP_FLAG_CACHE;
 
-	if (!page || page_cgroup_assign_new_page_cgroup(page, pc)) {
+	lock_page_cgroup(page);
+	if (page_get_page_cgroup(page)) {
+		unlock_page_cgroup(page);
 		/*
 		 * Another charge has been added to this page already.
 		 * We take lock_page_cgroup(page) again and read
@@ -672,10 +653,10 @@ retry:
 		res_counter_uncharge(&mem->res, PAGE_SIZE);
 		css_put(&mem->css);
 		kfree(pc);
-		if (!page)
-			goto done;
 		goto retry;
 	}
+	page_assign_page_cgroup(page, pc);
+	unlock_page_cgroup(page);
 
 	mz = page_cgroup_zoneinfo(pc);
 	spin_lock_irqsave(&mz->lru_lock, flags);
diff -puN mm/shmem.c~memcg-mem_cgroup_charge-never-null mm/shmem.c
--- a/mm/shmem.c~memcg-mem_cgroup_charge-never-null
+++ a/mm/shmem.c
@@ -1370,14 +1370,17 @@ repeat:
 			shmem_swp_unmap(entry);
 			spin_unlock(&info->lock);
 			unlock_page(swappage);
-			page_cache_release(swappage);
 			if (error == -ENOMEM) {
 				/* allow reclaim from this memory cgroup */
-				error = mem_cgroup_cache_charge(NULL,
+				error = mem_cgroup_cache_charge(swappage,
 					current->mm, gfp & ~__GFP_HIGHMEM);
-				if (error)
+				if (error) {
+					page_cache_release(swappage);
 					goto failed;
+				}
+				mem_cgroup_uncharge_page(swappage);
 			}
+			page_cache_release(swappage);
 			goto repeat;
 		}
 	} else if (sgp == SGP_READ && !filepage) {
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
