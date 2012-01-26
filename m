From: akpm@linux-foundation.org
Subject: + memcg-remove-pcg_cache-page_cgroup-flag.patch added to -mm tree
Date: Wed, 25 Jan 2012 16:25:49 -0800
Message-ID: <20120126002549.A1648A0291@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:38893 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab2AZAZu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2012 19:25:50 -0500
Received: by ggnk1 with SMTP id k1so11907ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2012 16:25:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, hughd@google.com, mhocko@suse.cz, yinghan@google.com


The patch titled
     Subject: memcg: remove PCG_CACHE page_cgroup flag
has been added to the -mm tree.  Its filename is
     memcg-remove-pcg_cache-page_cgroup-flag.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: memcg: remove PCG_CACHE page_cgroup flag

We record 'the page is cache' with the PCG_CACHE bit in page_cgroup. 
Here, "CACHE" means anonymous user pages (and SwapCache).  This doesn't
include shmem.

Consdering callers, at charge/uncharge, the caller should know what the
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

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ying Han <yinghan@google.com>
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
@@ -670,15 +670,19 @@ static unsigned long mem_cgroup_read_eve
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
@@ -2405,6 +2409,8 @@ static void __mem_cgroup_commit_charge(s
 				       struct page_cgroup *pc,
 				       enum charge_type ctype)
 {
+	bool anon;
+
 	lock_page_cgroup(pc);
 	if (unlikely(PageCgroupUsed(pc))) {
 		unlock_page_cgroup(pc);
@@ -2424,21 +2430,14 @@ static void __mem_cgroup_commit_charge(s
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
 
-	mem_cgroup_charge_statistics(memcg, PageCgroupCache(pc), nr_pages);
+	SetPageCgroupUsed(pc);
+	if (ctype == MEM_CGROUP_CHARGE_TYPE_MAPPED)
+		anon = true;
+	else
+		anon = false;
+
+	mem_cgroup_charge_statistics(memcg, anon, nr_pages);
 	unlock_page_cgroup(pc);
 	WARN_ON_ONCE(PageLRU(page));
 	/*
@@ -2503,6 +2502,7 @@ static int mem_cgroup_move_account(struc
 {
 	unsigned long flags;
 	int ret;
+	bool anon = PageAnon(page);
 
 	VM_BUG_ON(from == to);
 	VM_BUG_ON(PageLRU(page));
@@ -2531,14 +2531,14 @@ static int mem_cgroup_move_account(struc
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
@@ -2884,6 +2884,7 @@ __mem_cgroup_uncharge_common(struct page
 	struct mem_cgroup *memcg = NULL;
 	unsigned int nr_pages = 1;
 	struct page_cgroup *pc;
+	bool anon;
 
 	if (mem_cgroup_disabled())
 		return NULL;
@@ -2915,6 +2916,7 @@ __mem_cgroup_uncharge_common(struct page
 		/* See mem_cgroup_prepare_migration() */
 		if (page_mapped(page) || PageCgroupMigration(pc))
 			goto unlock_out;
+		anon = true;
 		break;
 	case MEM_CGROUP_CHARGE_TYPE_SWAPOUT:
 		if (!PageAnon(page)) {	/* Shared memory */
@@ -2922,12 +2924,14 @@ __mem_cgroup_uncharge_common(struct page
 				goto unlock_out;
 		} else if (page_mapped(page)) /* Anon */
 				goto unlock_out;
+		anon = true;
 		break;
 	default:
+		anon = false;
 		break;
 	}
 
-	mem_cgroup_charge_statistics(memcg, PageCgroupCache(pc), -nr_pages);
+	mem_cgroup_charge_statistics(memcg, anon, -nr_pages);
 
 	ClearPageCgroupUsed(pc);
 	/*
@@ -3251,6 +3255,7 @@ void mem_cgroup_end_migration(struct mem
 {
 	struct page *used, *unused;
 	struct page_cgroup *pc;
+	bool anon;
 
 	if (!memcg)
 		return;
@@ -3272,8 +3277,10 @@ void mem_cgroup_end_migration(struct mem
 	lock_page_cgroup(pc);
 	ClearPageCgroupMigration(pc);
 	unlock_page_cgroup(pc);
-
-	__mem_cgroup_uncharge_common(unused, MEM_CGROUP_CHARGE_TYPE_FORCE);
+	anon = PageAnon(used);
+	__mem_cgroup_uncharge_common(unused,
+		anon ? MEM_CGROUP_CHARGE_TYPE_MAPPED
+                     : MEM_CGROUP_CHARGE_TYPE_CACHE);
 
 	/*
 	 * If a page is a file cache, radix-tree replacement is very atomic
@@ -3283,7 +3290,7 @@ void mem_cgroup_end_migration(struct mem
 	 * and USED bit check in mem_cgroup_uncharge_page() will do enough
 	 * check. (see prepare_charge() also)
 	 */
-	if (PageAnon(used))
+	if (anon)
 		mem_cgroup_uncharge_page(used);
 	/*
 	 * At migration, we may charge account against cgroup which has no
@@ -3313,7 +3320,7 @@ void mem_cgroup_replace_page_cache(struc
 	/* fix accounting on old pages */
 	lock_page_cgroup(pc);
 	memcg = pc->mem_cgroup;
-	mem_cgroup_charge_statistics(memcg, PageCgroupCache(pc), -1);
+	mem_cgroup_charge_statistics(memcg, false, -1);
 	ClearPageCgroupUsed(pc);
 	unlock_page_cgroup(pc);
 
_
Subject: Subject: memcg: remove PCG_CACHE page_cgroup flag

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
mm-postpone-migrated-page-mapping-reset.patch
linux-next.patch
mm-oom-avoid-looping-when-chosen-thread-detaches-its-mm.patch
mm-oom-fold-oom_kill_task-into-oom_kill_process.patch
mm-oom-do-not-emit-oom-killer-warning-if-chosen-thread-is-already-exiting.patch
mm-add-rss-counters-consistency-check.patch
mm-vmscanc-cleanup-with-s-reclaim_mode-isolate_mode.patch
mm-make-get_mm_counter-static-inline.patch
memcg-replace-mem_cont-by-mem_res_ctlr.patch
memcg-replace-mem-and-mem_cont-stragglers.patch
memcg-lru_size-instead-of-mem_cgroup_zstat.patch
memcg-enum-lru_list-lru.patch
memcg-remove-redundant-returns.patch
memcg-remove-unnecessary-thp-check-in-page-stat-accounting.patch
idr-make-idr_get_next-good-for-rcu_read_lock.patch
cgroup-revert-ss_id_lock-to-spinlock.patch
memcg-let-css_get_next-rely-upon-rcu_read_lock.patch
memcg-remove-pcg_cache-page_cgroup-flag.patch
proc-speedup-proc-stat-handling.patch

