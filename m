From: akpm@linux-foundation.org
Subject: + memcg-remove-a-redundant-check.patch added to -mm tree
Date: Thu, 15 May 2008 19:53:26 -0700
Message-ID: <200805160253.m4G2rQni023244@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59396 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753327AbYEPCyV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 22:54:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, ebiederm@xmission.com, hugh@veritas.com, lizf@cn.fujitsu.com, menage@google.com, rientjes@google.com, xemul@openvz.org, yamamoto@valinux.co.jp


The patch titled
     memcg: remove a redundant check
has been added to the -mm tree.  Its filename is
     memcg-remove-a-redundant-check.patch

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
Subject: memcg: remove a redundant check
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Because of remove refcnt patch, it's very rare case to that
mem_cgroup_charge_common() is called against a page which is accounted.

mem_cgroup_charge_common() is called when.
 1. a page is added into file cache.
 2. an anon page is _newly_ mapped.

A racy case is that a newly-swapped-in anonymous page is referred from
prural threads in do_swap_page() at the same time.
(a page is not Locked when mem_cgroup_charge() is called from do_swap_page.)

Another case is shmem. It charges its page before calling add_to_page_cache().
Then, mem_cgroup_charge_cache() is called twice. This case is handled in
mem_cgroup_cache_charge(). But this check may be too hacky...

Signed-off-by : KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   53 +++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 28 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-a-redundant-check mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-a-redundant-check
+++ a/mm/memcontrol.c
@@ -536,28 +536,6 @@ static int mem_cgroup_charge_common(stru
 	if (mem_cgroup_subsys.disabled)
 		return 0;
 
-	/*
-	 * Should page_cgroup's go to their own slab?
-	 * One could optimize the performance of the charging routine
-	 * by saving a bit in the page_flags and using it as a lock
-	 * to see if the cgroup page already has a page_cgroup associated
-	 * with it
-	 */
-retry:
-	lock_page_cgroup(page);
-	pc = page_get_page_cgroup(page);
-	/*
-	 * The page_cgroup exists and
-	 * the page has already been accounted.
-	 */
-	if (unlikely(pc)) {
-		VM_BUG_ON(pc->page != page);
-		VM_BUG_ON(!pc->mem_cgroup);
-		unlock_page_cgroup(page);
-		goto done;
-	}
-	unlock_page_cgroup(page);
-
 	pc = kmem_cache_alloc(page_cgroup_cache, gfp_mask);
 	if (unlikely(pc == NULL))
 		goto err;
@@ -618,15 +596,10 @@ retry:
 	lock_page_cgroup(page);
 	if (unlikely(page_get_page_cgroup(page))) {
 		unlock_page_cgroup(page);
-		/*
-		 * Another charge has been added to this page already.
-		 * We take lock_page_cgroup(page) again and read
-		 * page->cgroup, increment refcnt.... just retry is OK.
-		 */
 		res_counter_uncharge(&mem->res, PAGE_SIZE);
 		css_put(&mem->css);
 		kmem_cache_free(page_cgroup_cache, pc);
-		goto retry;
+		goto done;
 	}
 	page_assign_page_cgroup(page, pc);
 
@@ -665,8 +638,32 @@ int mem_cgroup_charge(struct page *page,
 int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 				gfp_t gfp_mask)
 {
+	/*
+	 * Corner case handling. This is called from add_to_page_cache()
+	 * in usual. But some FS (shmem) precharges this page before calling it
+	 * and call add_to_page_cache() with GFP_NOWAIT.
+	 *
+	 * For GFP_NOWAIT case, the page may be pre-charged before calling
+	 * add_to_page_cache(). (See shmem.c) check it here and avoid to call
+	 * charge twice. (It works but has to pay a bit larger cost.)
+	 */
+	if (!(gfp_mask & __GFP_WAIT)) {
+		struct page_cgroup *pc;
+
+		lock_page_cgroup(page);
+		pc = page_get_page_cgroup(page);
+		if (pc) {
+			VM_BUG_ON(pc->page != page);
+			VM_BUG_ON(!pc->mem_cgroup);
+			unlock_page_cgroup(page);
+			return 0;
+		}
+		unlock_page_cgroup(page);
+	}
+
 	if (unlikely(!mm))
 		mm = &init_mm;
+
 	return mem_cgroup_charge_common(page, mm, gfp_mask,
 				MEM_CGROUP_CHARGE_TYPE_CACHE, NULL);
 }
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
memory-hotplug-memmap_init_zone-called-twice.patch
memory_hotplug-check-for-walk_memory_resource-failure-in-online_pages.patch
memory_hotplug-always-initialize-pageblock-bitmap.patch
mark-res_counter_charge_locked-with-__must_check.patch
memcg-make-global-var-read_mostly.patch
memcg-avoid-unnecessary-initialization.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-handle-swap-cache.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch

