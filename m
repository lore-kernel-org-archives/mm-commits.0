From: akpm@linux-foundation.org
Subject: + memcg-memcontrol-whitespace-cleanups.patch added to -mm tree
Date: Wed, 27 Feb 2008 19:52:46 -0800
Message-ID: <200802280352.m1S3qkGK014226@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759041AbYB1D6n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 22:58:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, rientjes@google.com, taka@valinux.co.jp, yamamoto@valinux.co.jp


The patch titled
     memcg: memcontrol whitespace cleanups
has been added to the -mm tree.  Its filename is
     memcg-memcontrol-whitespace-cleanups.patch

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
Subject: memcg: memcontrol whitespace cleanups
From: Hugh Dickins <hugh@veritas.com>

Sorry, before getting down to more important changes, I'd like to do some
cleanup in memcontrol.c.  This patch doesn't change the code generated, but
cleans up whitespace, moves up a double declaration, removes an unused enum,
removes void returns, removes misleading comments, that kind of thing.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   94 +++++++++++++---------------------------------
 1 file changed, 28 insertions(+), 66 deletions(-)

diff -puN mm/memcontrol.c~memcg-memcontrol-whitespace-cleanups mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-memcontrol-whitespace-cleanups
+++ a/mm/memcontrol.c
@@ -137,6 +137,7 @@ struct mem_cgroup {
 	 */
 	struct mem_cgroup_stat stat;
 };
+static struct mem_cgroup init_mem_cgroup;
 
 /*
  * We use the lower bit of the page->page_cgroup pointer as a bit spin
@@ -162,7 +163,7 @@ struct page_cgroup {
 	struct mem_cgroup *mem_cgroup;
 	atomic_t ref_cnt;		/* Helpful when pages move b/w  */
 					/* mapped and cached states     */
-	int	 flags;
+	int flags;
 };
 #define PAGE_CGROUP_FLAG_CACHE	(0x1)	/* charged as cache */
 #define PAGE_CGROUP_FLAG_ACTIVE (0x2)	/* page is active in this cgroup */
@@ -177,20 +178,11 @@ static inline enum zone_type page_cgroup
 	return page_zonenum(pc->page);
 }
 
-enum {
-	MEM_CGROUP_TYPE_UNSPEC = 0,
-	MEM_CGROUP_TYPE_MAPPED,
-	MEM_CGROUP_TYPE_CACHED,
-	MEM_CGROUP_TYPE_ALL,
-	MEM_CGROUP_TYPE_MAX,
-};
-
 enum charge_type {
 	MEM_CGROUP_CHARGE_TYPE_CACHE = 0,
 	MEM_CGROUP_CHARGE_TYPE_MAPPED,
 };
 
-
 /*
  * Always modified under lru lock. Then, not necessary to preempt_disable()
  */
@@ -199,11 +191,10 @@ static void mem_cgroup_charge_statistics
 {
 	int val = (charge)? 1 : -1;
 	struct mem_cgroup_stat *stat = &mem->stat;
-	VM_BUG_ON(!irqs_disabled());
 
+	VM_BUG_ON(!irqs_disabled());
 	if (flags & PAGE_CGROUP_FLAG_CACHE)
-		__mem_cgroup_stat_add_safe(stat,
-					MEM_CGROUP_STAT_CACHE, val);
+		__mem_cgroup_stat_add_safe(stat, MEM_CGROUP_STAT_CACHE, val);
 	else
 		__mem_cgroup_stat_add_safe(stat, MEM_CGROUP_STAT_RSS, val);
 }
@@ -240,8 +231,6 @@ static unsigned long mem_cgroup_get_all_
 	return total;
 }
 
-static struct mem_cgroup init_mem_cgroup;
-
 static inline
 struct mem_cgroup *mem_cgroup_from_cont(struct cgroup *cont)
 {
@@ -273,8 +262,7 @@ void mm_free_cgroup(struct mm_struct *mm
 
 static inline int page_cgroup_locked(struct page *page)
 {
-	return bit_spin_is_locked(PAGE_CGROUP_LOCK_BIT,
-					&page->page_cgroup);
+	return bit_spin_is_locked(PAGE_CGROUP_LOCK_BIT, &page->page_cgroup);
 }
 
 static void page_assign_page_cgroup(struct page *page, struct page_cgroup *pc)
@@ -285,8 +273,7 @@ static void page_assign_page_cgroup(stru
 
 struct page_cgroup *page_get_page_cgroup(struct page *page)
 {
-	return (struct page_cgroup *)
-		(page->page_cgroup & ~PAGE_CGROUP_LOCK);
+	return (struct page_cgroup *) (page->page_cgroup & ~PAGE_CGROUP_LOCK);
 }
 
 static void __always_inline lock_page_cgroup(struct page *page)
@@ -308,7 +295,6 @@ static void __always_inline unlock_page_
  * A can can detect failure of clearing by following
  *  clear_page_cgroup(page, pc) == pc
  */
-
 static struct page_cgroup *clear_page_cgroup(struct page *page,
 						struct page_cgroup *pc)
 {
@@ -417,6 +403,7 @@ int mem_cgroup_calc_mapped_ratio(struct 
 	rss = (long)mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_RSS);
 	return (int)((rss * 100L) / total);
 }
+
 /*
  * This function is called from vmscan.c. In page reclaiming loop. balance
  * between active and inactive list is calculated. For memory controller
@@ -480,7 +467,6 @@ long mem_cgroup_calc_reclaim_inactive(st
 	struct mem_cgroup_per_zone *mz = mem_cgroup_zoneinfo(mem, nid, zid);
 
 	nr_inactive = MEM_CGROUP_ZSTAT(mz, MEM_CGROUP_ZSTAT_INACTIVE);
-
 	return (nr_inactive >> priority);
 }
 
@@ -601,16 +587,11 @@ retry:
 	rcu_read_lock();
 	mem = rcu_dereference(mm->mem_cgroup);
 	/*
-	 * For every charge from the cgroup, increment reference
-	 * count
+	 * For every charge from the cgroup, increment reference count
 	 */
 	css_get(&mem->css);
 	rcu_read_unlock();
 
-	/*
-	 * If we created the page_cgroup, we should free it on exceeding
-	 * the cgroup limit.
-	 */
 	while (res_counter_charge(&mem->res, PAGE_SIZE)) {
 		if (!(gfp_mask & __GFP_WAIT))
 			goto out;
@@ -619,12 +600,12 @@ retry:
 			continue;
 
 		/*
- 		 * try_to_free_mem_cgroup_pages() might not give us a full
- 		 * picture of reclaim. Some pages are reclaimed and might be
- 		 * moved to swap cache or just unmapped from the cgroup.
- 		 * Check the limit again to see if the reclaim reduced the
- 		 * current usage of the cgroup before giving up
- 		 */
+		 * try_to_free_mem_cgroup_pages() might not give us a full
+		 * picture of reclaim. Some pages are reclaimed and might be
+		 * moved to swap cache or just unmapped from the cgroup.
+		 * Check the limit again to see if the reclaim reduced the
+		 * current usage of the cgroup before giving up
+		 */
 		if (res_counter_check_under_limit(&mem->res))
 			continue;
 
@@ -660,7 +641,6 @@ retry:
 
 	mz = page_cgroup_zoneinfo(pc);
 	spin_lock_irqsave(&mz->lru_lock, flags);
-	/* Update statistics vector */
 	__mem_cgroup_add_list(pc);
 	spin_unlock_irqrestore(&mz->lru_lock, flags);
 
@@ -673,26 +653,19 @@ err:
 	return -ENOMEM;
 }
 
-int mem_cgroup_charge(struct page *page, struct mm_struct *mm,
-			gfp_t gfp_mask)
+int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask)
 {
 	return mem_cgroup_charge_common(page, mm, gfp_mask,
-			MEM_CGROUP_CHARGE_TYPE_MAPPED);
+				MEM_CGROUP_CHARGE_TYPE_MAPPED);
 }
 
-/*
- * See if the cached pages should be charged at all?
- */
 int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 				gfp_t gfp_mask)
 {
-	int ret = 0;
 	if (!mm)
 		mm = &init_mm;
-
-	ret = mem_cgroup_charge_common(page, mm, gfp_mask,
+	return mem_cgroup_charge_common(page, mm, gfp_mask,
 				MEM_CGROUP_CHARGE_TYPE_CACHE);
-	return ret;
 }
 
 /*
@@ -742,11 +715,11 @@ unlock:
  * Returns non-zero if a page (under migration) has valid page_cgroup member.
  * Refcnt of page_cgroup is incremented.
  */
-
 int mem_cgroup_prepare_migration(struct page *page)
 {
 	struct page_cgroup *pc;
 	int ret = 0;
+
 	lock_page_cgroup(page);
 	pc = page_get_page_cgroup(page);
 	if (pc && atomic_inc_not_zero(&pc->ref_cnt))
@@ -759,28 +732,30 @@ void mem_cgroup_end_migration(struct pag
 {
 	mem_cgroup_uncharge_page(page);
 }
+
 /*
- * We know both *page* and *newpage* are now not-on-LRU and Pg_locked.
+ * We know both *page* and *newpage* are now not-on-LRU and PG_locked.
  * And no race with uncharge() routines because page_cgroup for *page*
  * has extra one reference by mem_cgroup_prepare_migration.
  */
-
 void mem_cgroup_page_migration(struct page *page, struct page *newpage)
 {
 	struct page_cgroup *pc;
 	struct mem_cgroup *mem;
 	unsigned long flags;
 	struct mem_cgroup_per_zone *mz;
+
 retry:
 	pc = page_get_page_cgroup(page);
 	if (!pc)
 		return;
+
 	mem = pc->mem_cgroup;
 	mz = page_cgroup_zoneinfo(pc);
 	if (clear_page_cgroup(page, pc) != pc)
 		goto retry;
-	spin_lock_irqsave(&mz->lru_lock, flags);
 
+	spin_lock_irqsave(&mz->lru_lock, flags);
 	__mem_cgroup_remove_list(pc);
 	spin_unlock_irqrestore(&mz->lru_lock, flags);
 
@@ -793,7 +768,6 @@ retry:
 	spin_lock_irqsave(&mz->lru_lock, flags);
 	__mem_cgroup_add_list(pc);
 	spin_unlock_irqrestore(&mz->lru_lock, flags);
-	return;
 }
 
 /*
@@ -802,8 +776,7 @@ retry:
  * *And* this routine doesn't reclaim page itself, just removes page_cgroup.
  */
 #define FORCE_UNCHARGE_BATCH	(128)
-static void
-mem_cgroup_force_empty_list(struct mem_cgroup *mem,
+static void mem_cgroup_force_empty_list(struct mem_cgroup *mem,
 			    struct mem_cgroup_per_zone *mz,
 			    int active)
 {
@@ -837,27 +810,27 @@ retry:
 		} else 	/* being uncharged ? ...do relax */
 			break;
 	}
+
 	spin_unlock_irqrestore(&mz->lru_lock, flags);
 	if (!list_empty(list)) {
 		cond_resched();
 		goto retry;
 	}
-	return;
 }
 
 /*
  * make mem_cgroup's charge to be 0 if there is no task.
  * This enables deleting this mem_cgroup.
  */
-
 int mem_cgroup_force_empty(struct mem_cgroup *mem)
 {
 	int ret = -EBUSY;
 	int node, zid;
+
 	css_get(&mem->css);
 	/*
 	 * page reclaim code (kswapd etc..) will move pages between
-`	 * active_list <-> inactive_list while we don't take a lock.
+	 * active_list <-> inactive_list while we don't take a lock.
 	 * So, we have to do loop here until all lists are empty.
 	 */
 	while (mem->res.usage > 0) {
@@ -879,8 +852,6 @@ out:
 	return ret;
 }
 
-
-
 int mem_cgroup_write_strategy(char *buf, unsigned long long *tmp)
 {
 	*tmp = memparse(buf, &buf);
@@ -918,8 +889,7 @@ static ssize_t mem_force_empty_write(str
 				size_t nbytes, loff_t *ppos)
 {
 	struct mem_cgroup *mem = mem_cgroup_from_cont(cont);
-	int ret;
-	ret = mem_cgroup_force_empty(mem);
+	int ret = mem_cgroup_force_empty(mem);
 	if (!ret)
 		ret = nbytes;
 	return ret;
@@ -928,7 +898,6 @@ static ssize_t mem_force_empty_write(str
 /*
  * Note: This should be removed if cgroup supports write-only file.
  */
-
 static ssize_t mem_force_empty_read(struct cgroup *cont,
 				struct cftype *cft,
 				struct file *file, char __user *userbuf,
@@ -937,7 +906,6 @@ static ssize_t mem_force_empty_read(stru
 	return -EINVAL;
 }
 
-
 static const struct mem_cgroup_stat_desc {
 	const char *msg;
 	u64 unit;
@@ -990,8 +958,6 @@ static int mem_control_stat_open(struct 
 	return single_open(file, mem_control_stat_show, cont);
 }
 
-
-
 static struct cftype mem_cgroup_files[] = {
 	{
 		.name = "usage_in_bytes",
@@ -1057,9 +1023,6 @@ static void free_mem_cgroup_per_zone_inf
 	kfree(mem->info.nodeinfo[node]);
 }
 
-
-static struct mem_cgroup init_mem_cgroup;
-
 static struct cgroup_subsys_state *
 mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
 {
@@ -1149,7 +1112,6 @@ static void mem_cgroup_move_task(struct 
 
 out:
 	mmput(mm);
-	return;
 }
 
 struct cgroup_subsys mem_cgroup_subsys = {
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
