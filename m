From: akpm@linux-foundation.org
Subject: + memcg-remove-clear_page_cgroup-and-atomics.patch added to -mm tree
Date: Wed, 27 Feb 2008 19:52:50 -0800
Message-ID: <200802280352.m1S3qoB7014232@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38314 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754798AbYB1DxN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 22:53:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, rientjes@google.com, taka@valinux.co.jp, yamamoto@valinux.co.jp


The patch titled
     memcg: remove clear_page_cgroup and atomics
has been added to the -mm tree.  Its filename is
     memcg-remove-clear_page_cgroup-and-atomics.patch

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
Subject: memcg: remove clear_page_cgroup and atomics
From: Hugh Dickins <hugh@veritas.com>

Remove clear_page_cgroup: it's an unhelpful helper, see for example how
mem_cgroup_uncharge_page had to unlock_page_cgroup just in order to call it
(serious races from that?  I'm not sure).

Once that's gone, you can see it's pointless for page_cgroup's ref_cnt to be
atomic: it's always manipulated under lock_page_cgroup, except where
force_empty unilaterally reset it to 0 (and how does uncharge's
atomic_dec_and_test protect against that?).

Simplify this page_cgroup locking: if you've got the lock and the pc is
attached, then the ref_cnt must be positive: VM_BUG_ONs to check that, and to
check that pc->page matches page (we're on the way to finding why sometimes it
doesn't, but this patch doesn't fix that).

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  106 ++++++++++++++++++----------------------------
 1 file changed, 43 insertions(+), 63 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-clear_page_cgroup-and-atomics mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-clear_page_cgroup-and-atomics
+++ a/mm/memcontrol.c
@@ -161,8 +161,7 @@ struct page_cgroup {
 	struct list_head lru;		/* per cgroup LRU list */
 	struct page *page;
 	struct mem_cgroup *mem_cgroup;
-	atomic_t ref_cnt;		/* Helpful when pages move b/w  */
-					/* mapped and cached states     */
+	int ref_cnt;			/* cached, mapped, migrating */
 	int flags;
 };
 #define PAGE_CGROUP_FLAG_CACHE	(0x1)	/* charged as cache */
@@ -283,27 +282,6 @@ static void unlock_page_cgroup(struct pa
 	bit_spin_unlock(PAGE_CGROUP_LOCK_BIT, &page->page_cgroup);
 }
 
-/*
- * Clear page->page_cgroup member under lock_page_cgroup().
- * If given "pc" value is different from one page->page_cgroup,
- * page->cgroup is not cleared.
- * Returns a value of page->page_cgroup at lock taken.
- * A can can detect failure of clearing by following
- *  clear_page_cgroup(page, pc) == pc
- */
-static struct page_cgroup *clear_page_cgroup(struct page *page,
-						struct page_cgroup *pc)
-{
-	struct page_cgroup *ret;
-	/* lock and clear */
-	lock_page_cgroup(page);
-	ret = page_get_page_cgroup(page);
-	if (likely(ret == pc))
-		page_assign_page_cgroup(page, NULL);
-	unlock_page_cgroup(page);
-	return ret;
-}
-
 static void __mem_cgroup_remove_list(struct page_cgroup *pc)
 {
 	int from = pc->flags & PAGE_CGROUP_FLAG_ACTIVE;
@@ -555,15 +533,12 @@ retry:
 	 * the page has already been accounted.
 	 */
 	if (pc) {
-		if (unlikely(!atomic_inc_not_zero(&pc->ref_cnt))) {
-			/* this page is under being uncharged ? */
-			unlock_page_cgroup(page);
-			cpu_relax();
-			goto retry;
-		} else {
-			unlock_page_cgroup(page);
-			goto done;
-		}
+		VM_BUG_ON(pc->page != page);
+		VM_BUG_ON(pc->ref_cnt <= 0);
+
+		pc->ref_cnt++;
+		unlock_page_cgroup(page);
+		goto done;
 	}
 	unlock_page_cgroup(page);
 
@@ -612,7 +587,7 @@ retry:
 		congestion_wait(WRITE, HZ/10);
 	}
 
-	atomic_set(&pc->ref_cnt, 1);
+	pc->ref_cnt = 1;
 	pc->mem_cgroup = mem;
 	pc->page = page;
 	pc->flags = PAGE_CGROUP_FLAG_ACTIVE;
@@ -683,24 +658,24 @@ void mem_cgroup_uncharge_page(struct pag
 	if (!pc)
 		goto unlock;
 
-	if (atomic_dec_and_test(&pc->ref_cnt)) {
-		page = pc->page;
-		mz = page_cgroup_zoneinfo(pc);
-		/*
-		 * get page->cgroup and clear it under lock.
-		 * force_empty can drop page->cgroup without checking refcnt.
-		 */
+	VM_BUG_ON(pc->page != page);
+	VM_BUG_ON(pc->ref_cnt <= 0);
+
+	if (--(pc->ref_cnt) == 0) {
+		page_assign_page_cgroup(page, NULL);
 		unlock_page_cgroup(page);
-		if (clear_page_cgroup(page, pc) == pc) {
-			mem = pc->mem_cgroup;
-			css_put(&mem->css);
-			res_counter_uncharge(&mem->res, PAGE_SIZE);
-			spin_lock_irqsave(&mz->lru_lock, flags);
-			__mem_cgroup_remove_list(pc);
-			spin_unlock_irqrestore(&mz->lru_lock, flags);
-			kfree(pc);
-		}
-		lock_page_cgroup(page);
+
+		mem = pc->mem_cgroup;
+		css_put(&mem->css);
+		res_counter_uncharge(&mem->res, PAGE_SIZE);
+
+		mz = page_cgroup_zoneinfo(pc);
+		spin_lock_irqsave(&mz->lru_lock, flags);
+		__mem_cgroup_remove_list(pc);
+		spin_unlock_irqrestore(&mz->lru_lock, flags);
+
+		kfree(pc);
+		return;
 	}
 
 unlock:
@@ -714,14 +689,13 @@ unlock:
 int mem_cgroup_prepare_migration(struct page *page)
 {
 	struct page_cgroup *pc;
-	int ret = 0;
 
 	lock_page_cgroup(page);
 	pc = page_get_page_cgroup(page);
-	if (pc && atomic_inc_not_zero(&pc->ref_cnt))
-		ret = 1;
+	if (pc)
+		pc->ref_cnt++;
 	unlock_page_cgroup(page);
-	return ret;
+	return pc != NULL;
 }
 
 void mem_cgroup_end_migration(struct page *page)
@@ -740,15 +714,17 @@ void mem_cgroup_page_migration(struct pa
 	struct mem_cgroup_per_zone *mz;
 	unsigned long flags;
 
-retry:
+	lock_page_cgroup(page);
 	pc = page_get_page_cgroup(page);
-	if (!pc)
+	if (!pc) {
+		unlock_page_cgroup(page);
 		return;
+	}
 
-	mz = page_cgroup_zoneinfo(pc);
-	if (clear_page_cgroup(page, pc) != pc)
-		goto retry;
+	page_assign_page_cgroup(page, NULL);
+	unlock_page_cgroup(page);
 
+	mz = page_cgroup_zoneinfo(pc);
 	spin_lock_irqsave(&mz->lru_lock, flags);
 	__mem_cgroup_remove_list(pc);
 	spin_unlock_irqrestore(&mz->lru_lock, flags);
@@ -794,15 +770,19 @@ retry:
 	while (--count && !list_empty(list)) {
 		pc = list_entry(list->prev, struct page_cgroup, lru);
 		page = pc->page;
-		/* Avoid race with charge */
-		atomic_set(&pc->ref_cnt, 0);
-		if (clear_page_cgroup(page, pc) == pc) {
+		lock_page_cgroup(page);
+		if (page_get_page_cgroup(page) == pc) {
+			page_assign_page_cgroup(page, NULL);
+			unlock_page_cgroup(page);
 			css_put(&mem->css);
 			res_counter_uncharge(&mem->res, PAGE_SIZE);
 			__mem_cgroup_remove_list(pc);
 			kfree(pc);
-		} else 	/* being uncharged ? ...do relax */
+		} else {
+			/* racing uncharge: let page go then retry */
+			unlock_page_cgroup(page);
 			break;
+		}
 	}
 
 	spin_unlock_irqrestore(&mz->lru_lock, flags);
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
