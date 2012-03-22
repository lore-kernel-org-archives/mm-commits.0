From: akpm@linux-foundation.org
Subject: [merged] memcg-remove-pcg_cache-page_cgroup-flag.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:19:46 -0700
Message-ID: <20120322201946.8E0FFA024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:48025 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757108Ab2CVUTs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:19:48 -0400
Received: by mail-we0-f202.google.com with SMTP id x9so134901wej.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:19:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, hughd@google.com, mhocko@suse.cz, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: remove PCG_CACHE page_cgroup flag
has been removed from the -mm tree.  Its filename was
     memcg-remove-pcg_cache-page_cgroup-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: memcg: remove PCG_CACHE page_cgroup flag

We record 'the page is cache' with the PCG_CACHE bit in page_cgroup. 
Here, "CACHE" means anonymous user pages (and SwapCache).  This doesn't
include shmem.

Considering callers, at charge/uncharge, the caller should know what the
page is and we don't need to record it by using one bit per page.

This patch removes PCG_CACHE bit and make callers of
mem_cgroup_charge_statistics() to specify what the page is.

About page migration: Mapping of the used page is not touched during migra
tion (see page_remove_rmap) so we can rely on it and push the correct
charge type down to __mem_cgroup_uncharge_common from end_migration for
unused page.  The force flag was misleading was abused for skipping the
needless page_mapped() / PageCgroupMigration() check, as we know the
unused page is no longer mapped and cleared the migration flag just a few
lines up.  But doing the checks is no biggie and it's not worth adding
another flag just to skip them.

[akpm@linux-foundation.org: checkpatch fixes]
[hughd@google.com: fix PageAnon uncharging]
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ying Han <yinghan@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_cgroup.h |    8 ----
 mm/memcontrol.c             |   57 +++++++++++++++++++---------------
 2 files changed, 33 insertions(+), 32 deletions(-)

diff -puN include/linux/page_cgroup.h~memcg-remove-pcg_cache-page_cgroup-flag include/linux/page_cgroup.h
--- a/include/linux/page_cgroup.h~memcg-remove-pcg_cache-page_cgroup-flag
+++ a/include/linux/page_cgroup.h
@@ -4,7 +4,6 @@
 enum {
 	/* flags for mem_cgroup */
 	PCG_LOCK,  /* Lock for pc->mem_cgroup and following bits. */
-	PCG_CACHE, /* charged as cache */
 	PCG_USED, /* this object is in use. */
 	PCG_MIGRATION, /* under page migration */
 	/* flags for mem_cgroup and file and I/O status */
@@ -64,11 +63,6 @@ static inline void ClearPageCgroup##unam
 static inline int TestClearPageCgroup##uname(struct page_cgroup *pc)	\
 	{ return test_and_clear_bit(PCG_##lname, &pc->flags);  }
 
-/* Cache flag is set only once (at allocation) */
-TESTPCGFLAG(Cache, CACHE)
-CLEARPCGFLAG(Cache, CACHE)
-SETPCGFLAG(Cache, CACHE)
-
 TESTPCGFLAG(Used, USED)
 CLEARPCGFLAG(Used, USED)
 SETPCGFLAG(Used, USED)
@@ -85,7 +79,7 @@ static inline void lock_page_cgroup(stru
 {
 	/*
 	 * Don't take this lock in IRQ context.
-	 * This lock is for pc->mem_cgroup, USED, CACHE, MIGRATION
+	 * This lock is for pc->mem_cgroup, USED, MIGRATION
 	 */
 	bit_spin_lock(PCG_LOCK, &pc->flags);
 }
diff -puN mm/memcontrol.c~memcg-remove-pcg_cache-page_cgroup-flag mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-pcg_cache-page_cgroup-flag
+++ a/mm/memcontrol.c
@@ -690,15 +690,19 @@ static unsigned long mem_cgroup_read_eve
 }
 
 static void mem_cgroup_charge_statistics(struct mem_cgroup *memcg,
-					 bool file, int nr_pages)
+					 bool anon, int nr_pages)
 {
 	preempt_disable();
 
-	if (file)
-		__this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_CACHE],
+	/*
+	 * Here, RSS means 'mapped anon' and anon's SwapCache. Shmem/tmpfs is
+	 * counted as CACHE even if it's on ANON LRU.
+	 */
+	if (anon)
+		__this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_RSS],
 				nr_pages);
 	else
-		__this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_RSS],
+		__this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_CACHE],
 				nr_pages);
 
 	/* pagein of a big page is an event. So, ignore page size */
@@ -2442,6 +2446,7 @@ static void __mem_cgroup_commit_charge(s
 {
 	struct zone *uninitialized_var(zone);
 	bool was_on_lru = false;
+	bool anon;
 
 	lock_page_cgroup(pc);
 	if (unlikely(PageCgroupUsed(pc))) {
@@ -2477,19 +2482,7 @@ static void __mem_cgroup_commit_charge(s
 	 * See mem_cgroup_add_lru_list(), etc.
  	 */
 	smp_wmb();
-	switch (ctype) {
-	case MEM_CGROUP_CHARGE_TYPE_CACHE:
-	case MEM_CGROUP_CHARGE_TYPE_SHMEM:
-		SetPageCgroupCache(pc);
-		SetPageCgroupUsed(pc);
-		break;
-	case MEM_CGROUP_CHARGE_TYPE_MAPPED:
-		ClearPageCgroupCache(pc);
-		SetPageCgroupUsed(pc);
-		break;
-	default:
-		break;
-	}
+	SetPageCgroupUsed(pc);
 
 	if (lrucare) {
 		if (was_on_lru) {
@@ -2500,7 +2493,12 @@ static void __mem_cgroup_commit_charge(s
 		spin_unlock_irq(&zone->lru_lock);
 	}
 
-	mem_cgroup_charge_statistics(memcg, PageCgroupCache(pc), nr_pages);
+	if (ctype == MEM_CGROUP_CHARGE_TYPE_MAPPED)
+		anon = true;
+	else
+		anon = false;
+
+	mem_cgroup_charge_statistics(memcg, anon, nr_pages);
 	unlock_page_cgroup(pc);
 
 	/*
@@ -2565,6 +2563,7 @@ static int mem_cgroup_move_account(struc
 {
 	unsigned long flags;
 	int ret;
+	bool anon = PageAnon(page);
 
 	VM_BUG_ON(from == to);
 	VM_BUG_ON(PageLRU(page));
@@ -2593,14 +2592,14 @@ static int mem_cgroup_move_account(struc
 		__this_cpu_inc(to->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
 		preempt_enable();
 	}
-	mem_cgroup_charge_statistics(from, PageCgroupCache(pc), -nr_pages);
+	mem_cgroup_charge_statistics(from, anon, -nr_pages);
 	if (uncharge)
 		/* This is not "cancel", but cancel_charge does all we need. */
 		__mem_cgroup_cancel_charge(from, nr_pages);
 
 	/* caller should have done css_get */
 	pc->mem_cgroup = to;
-	mem_cgroup_charge_statistics(to, PageCgroupCache(pc), nr_pages);
+	mem_cgroup_charge_statistics(to, anon, nr_pages);
 	/*
 	 * We charges against "to" which may not have any tasks. Then, "to"
 	 * can be under rmdir(). But in current implementation, caller of
@@ -2921,6 +2920,7 @@ __mem_cgroup_uncharge_common(struct page
 	struct mem_cgroup *memcg = NULL;
 	unsigned int nr_pages = 1;
 	struct page_cgroup *pc;
+	bool anon;
 
 	if (mem_cgroup_disabled())
 		return NULL;
@@ -2946,8 +2946,12 @@ __mem_cgroup_uncharge_common(struct page
 	if (!PageCgroupUsed(pc))
 		goto unlock_out;
 
+	anon = PageAnon(page);
+
 	switch (ctype) {
 	case MEM_CGROUP_CHARGE_TYPE_MAPPED:
+		anon = true;
+		/* fallthrough */
 	case MEM_CGROUP_CHARGE_TYPE_DROP:
 		/* See mem_cgroup_prepare_migration() */
 		if (page_mapped(page) || PageCgroupMigration(pc))
@@ -2964,7 +2968,7 @@ __mem_cgroup_uncharge_common(struct page
 		break;
 	}
 
-	mem_cgroup_charge_statistics(memcg, PageCgroupCache(pc), -nr_pages);
+	mem_cgroup_charge_statistics(memcg, anon, -nr_pages);
 
 	ClearPageCgroupUsed(pc);
 	/*
@@ -3271,6 +3275,7 @@ void mem_cgroup_end_migration(struct mem
 {
 	struct page *used, *unused;
 	struct page_cgroup *pc;
+	bool anon;
 
 	if (!memcg)
 		return;
@@ -3292,8 +3297,10 @@ void mem_cgroup_end_migration(struct mem
 	lock_page_cgroup(pc);
 	ClearPageCgroupMigration(pc);
 	unlock_page_cgroup(pc);
-
-	__mem_cgroup_uncharge_common(unused, MEM_CGROUP_CHARGE_TYPE_FORCE);
+	anon = PageAnon(used);
+	__mem_cgroup_uncharge_common(unused,
+		anon ? MEM_CGROUP_CHARGE_TYPE_MAPPED
+		     : MEM_CGROUP_CHARGE_TYPE_CACHE);
 
 	/*
 	 * If a page is a file cache, radix-tree replacement is very atomic
@@ -3303,7 +3310,7 @@ void mem_cgroup_end_migration(struct mem
 	 * and USED bit check in mem_cgroup_uncharge_page() will do enough
 	 * check. (see prepare_charge() also)
 	 */
-	if (PageAnon(used))
+	if (anon)
 		mem_cgroup_uncharge_page(used);
 	/*
 	 * At migration, we may charge account against cgroup which has no
@@ -3333,7 +3340,7 @@ void mem_cgroup_replace_page_cache(struc
 	/* fix accounting on old pages */
 	lock_page_cgroup(pc);
 	memcg = pc->mem_cgroup;
-	mem_cgroup_charge_statistics(memcg, PageCgroupCache(pc), -1);
+	mem_cgroup_charge_statistics(memcg, false, -1);
 	ClearPageCgroupUsed(pc);
 	unlock_page_cgroup(pc);
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
linux-next.patch
mm-hugetlb-cleanup-duplicated-code-in-unmapping-vm-range.patch
proc-speedup-proc-stat-handling.patch
procfs-add-num_to_str-to-speed-up-proc-stat.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix-2.patch
procfs-speed-up-proc-pid-stat-statm.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
seq_file-add-seq_set_overflow-seq_overflow.patch
seq_file-add-seq_set_overflow-seq_overflow-fix.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch
c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch

