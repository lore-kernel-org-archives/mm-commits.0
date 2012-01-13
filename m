From: akpm@linux-foundation.org
Subject: [merged] memcg-simplify-lru-handling-by-new-rule.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:34:20 -0800
Message-ID: <20120113203421.2B09820004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:57647 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759096Ab2AMUeX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:34:23 -0500
Received: by mail-ee0-f74.google.com with SMTP id e50so23684eek.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:34:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, hughd@google.com, mhocko@suse.cz, mszeredi@suse.cz, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: simplify LRU handling by new rule
has been removed from the -mm tree.  Its filename was
     memcg-simplify-lru-handling-by-new-rule.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: memcg: simplify LRU handling by new rule

Now, at LRU handling, memory cgroup needs to do complicated works to see
valid pc->mem_cgroup, which may be overwritten.

This patch is for relaxing the protocol. This patch guarantees
   - when pc->mem_cgroup is overwritten, page must not be on LRU.

By this, LRU routine can believe pc->mem_cgroup and don't need to check
bits on pc->flags.  This new rule may adds small overheads to swapin.  But
in most case, lru handling gets faster.

After this patch, PCG_ACCT_LRU bit is obsolete and removed.

[akpm@linux-foundation.org: remove unneeded VM_BUG_ON(), restore hannes's christmas tree]
[akpm@linux-foundation.org: clean up code comment]
[hughd@google.com: fix NULL mem_cgroup_try_charge]
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_cgroup.h |    8 --
 mm/memcontrol.c             |  123 ++++++++++++++--------------------
 2 files changed, 54 insertions(+), 77 deletions(-)

diff -puN include/linux/page_cgroup.h~memcg-simplify-lru-handling-by-new-rule include/linux/page_cgroup.h
--- a/include/linux/page_cgroup.h~memcg-simplify-lru-handling-by-new-rule
+++ a/include/linux/page_cgroup.h
@@ -10,8 +10,6 @@ enum {
 	/* flags for mem_cgroup and file and I/O status */
 	PCG_MOVE_LOCK, /* For race between move_account v.s. following bits */
 	PCG_FILE_MAPPED, /* page is accounted as "mapped" */
-	/* No lock in page_cgroup */
-	PCG_ACCT_LRU, /* page has been accounted for (under lru_lock) */
 	__NR_PCG_FLAGS,
 };
 
@@ -75,12 +73,6 @@ TESTPCGFLAG(Used, USED)
 CLEARPCGFLAG(Used, USED)
 SETPCGFLAG(Used, USED)
 
-SETPCGFLAG(AcctLRU, ACCT_LRU)
-CLEARPCGFLAG(AcctLRU, ACCT_LRU)
-TESTPCGFLAG(AcctLRU, ACCT_LRU)
-TESTCLEARPCGFLAG(AcctLRU, ACCT_LRU)
-
-
 SETPCGFLAG(FileMapped, FILE_MAPPED)
 CLEARPCGFLAG(FileMapped, FILE_MAPPED)
 TESTPCGFLAG(FileMapped, FILE_MAPPED)
diff -puN mm/memcontrol.c~memcg-simplify-lru-handling-by-new-rule mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-simplify-lru-handling-by-new-rule
+++ a/mm/memcontrol.c
@@ -1040,30 +1040,7 @@ struct lruvec *mem_cgroup_lru_add_list(s
 		return &zone->lruvec;
 
 	pc = lookup_page_cgroup(page);
-	VM_BUG_ON(PageCgroupAcctLRU(pc));
-	/*
-	 * putback:				charge:
-	 * SetPageLRU				SetPageCgroupUsed
-	 * smp_mb				smp_mb
-	 * PageCgroupUsed && add to memcg LRU	PageLRU && add to memcg LRU
-	 *
-	 * Ensure that one of the two sides adds the page to the memcg
-	 * LRU during a race.
-	 */
-	smp_mb();
-	/*
-	 * If the page is uncharged, it may be freed soon, but it
-	 * could also be swap cache (readahead, swapoff) that needs to
-	 * be reclaimable in the future.  root_mem_cgroup will babysit
-	 * it for the time being.
-	 */
-	if (PageCgroupUsed(pc)) {
-		/* Ensure pc->mem_cgroup is visible after reading PCG_USED. */
-		smp_rmb();
-		memcg = pc->mem_cgroup;
-		SetPageCgroupAcctLRU(pc);
-	} else
-		memcg = root_mem_cgroup;
+	memcg = pc->mem_cgroup;
 	mz = page_cgroup_zoneinfo(memcg, page);
 	/* compound_order() is stabilized through lru_lock */
 	MEM_CGROUP_ZSTAT(mz, lru) += 1 << compound_order(page);
@@ -1090,18 +1067,8 @@ void mem_cgroup_lru_del_list(struct page
 		return;
 
 	pc = lookup_page_cgroup(page);
-	/*
-	 * root_mem_cgroup babysits uncharged LRU pages, but
-	 * PageCgroupUsed is cleared when the page is about to get
-	 * freed.  PageCgroupAcctLRU remembers whether the
-	 * LRU-accounting happened against pc->mem_cgroup or
-	 * root_mem_cgroup.
-	 */
-	if (TestClearPageCgroupAcctLRU(pc)) {
-		VM_BUG_ON(!pc->mem_cgroup);
-		memcg = pc->mem_cgroup;
-	} else
-		memcg = root_mem_cgroup;
+	memcg = pc->mem_cgroup;
+	VM_BUG_ON(!memcg);
 	mz = page_cgroup_zoneinfo(memcg, page);
 	/* huge page split is done under lru_lock. so, we have no races. */
 	MEM_CGROUP_ZSTAT(mz, lru) -= 1 << compound_order(page);
@@ -2217,8 +2184,25 @@ static int mem_cgroup_do_charge(struct m
 }
 
 /*
- * Unlike exported interface, "oom" parameter is added. if oom==true,
- * oom-killer can be invoked.
+ * __mem_cgroup_try_charge() does
+ * 1. detect memcg to be charged against from passed *mm and *ptr,
+ * 2. update res_counter
+ * 3. call memory reclaim if necessary.
+ *
+ * In some special case, if the task is fatal, fatal_signal_pending() or
+ * has TIF_MEMDIE, this function returns -EINTR while writing root_mem_cgroup
+ * to *ptr. There are two reasons for this. 1: fatal threads should quit as soon
+ * as possible without any hazards. 2: all pages should have a valid
+ * pc->mem_cgroup. If mm is NULL and the caller doesn't pass a valid memcg
+ * pointer, that is treated as a charge to root_mem_cgroup.
+ *
+ * So __mem_cgroup_try_charge() will return
+ *  0       ...  on success, filling *ptr with a valid memcg pointer.
+ *  -ENOMEM ...  charge failure because of resource limits.
+ *  -EINTR  ...  if thread is fatal. *ptr is filled with root_mem_cgroup.
+ *
+ * Unlike the exported interface, an "oom" parameter is added. if oom==true,
+ * the oom-killer can be invoked.
  */
 static int __mem_cgroup_try_charge(struct mm_struct *mm,
 				   gfp_t gfp_mask,
@@ -2247,7 +2231,7 @@ static int __mem_cgroup_try_charge(struc
 	 * set, if so charge the init_mm (happens for pagecache usage).
 	 */
 	if (!*ptr && !mm)
-		goto bypass;
+		*ptr = root_mem_cgroup;
 again:
 	if (*ptr) { /* css should be a valid one */
 		memcg = *ptr;
@@ -2273,7 +2257,9 @@ again:
 		 * task-struct. So, mm->owner can be NULL.
 		 */
 		memcg = mem_cgroup_from_task(p);
-		if (!memcg || mem_cgroup_is_root(memcg)) {
+		if (!memcg)
+			memcg = root_mem_cgroup;
+		if (mem_cgroup_is_root(memcg)) {
 			rcu_read_unlock();
 			goto done;
 		}
@@ -2348,8 +2334,8 @@ nomem:
 	*ptr = NULL;
 	return -ENOMEM;
 bypass:
-	*ptr = NULL;
-	return 0;
+	*ptr = root_mem_cgroup;
+	return -EINTR;
 }
 
 /*
@@ -2457,6 +2443,7 @@ static void __mem_cgroup_commit_charge(s
 
 	mem_cgroup_charge_statistics(memcg, PageCgroupCache(pc), nr_pages);
 	unlock_page_cgroup(pc);
+	WARN_ON_ONCE(PageLRU(page));
 	/*
 	 * "charge_statistics" updated event counter. Then, check it.
 	 * Insert ancestor (and ancestor's ancestors), to softlimit RB-tree.
@@ -2468,7 +2455,7 @@ static void __mem_cgroup_commit_charge(s
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 
 #define PCGF_NOCOPY_AT_SPLIT ((1 << PCG_LOCK) | (1 << PCG_MOVE_LOCK) |\
-			(1 << PCG_ACCT_LRU) | (1 << PCG_MIGRATION))
+			(1 << PCG_MIGRATION))
 /*
  * Because tail pages are not marked as "used", set it. We're under
  * zone->lru_lock, 'splitting on pmd' and compound_lock.
@@ -2478,7 +2465,9 @@ static void __mem_cgroup_commit_charge(s
 void mem_cgroup_split_huge_fixup(struct page *head)
 {
 	struct page_cgroup *head_pc = lookup_page_cgroup(head);
+	struct mem_cgroup_per_zone *mz;
 	struct page_cgroup *pc;
+	enum lru_list lru;
 	int i;
 
 	if (mem_cgroup_disabled())
@@ -2487,23 +2476,15 @@ void mem_cgroup_split_huge_fixup(struct 
 		pc = head_pc + i;
 		pc->mem_cgroup = head_pc->mem_cgroup;
 		smp_wmb();/* see __commit_charge() */
-		/*
-		 * LRU flags cannot be copied because we need to add tail
-		 * page to LRU by generic call and our hooks will be called.
-		 */
 		pc->flags = head_pc->flags & ~PCGF_NOCOPY_AT_SPLIT;
 	}
-
-	if (PageCgroupAcctLRU(head_pc)) {
-		enum lru_list lru;
-		struct mem_cgroup_per_zone *mz;
-		/*
-		 * We hold lru_lock, then, reduce counter directly.
-		 */
-		lru = page_lru(head);
-		mz = page_cgroup_zoneinfo(head_pc->mem_cgroup, head);
-		MEM_CGROUP_ZSTAT(mz, lru) -= HPAGE_PMD_NR - 1;
-	}
+	/*
+	 * Tail pages will be added to LRU.
+	 * We hold lru_lock,then,reduce counter directly.
+	 */
+	lru = page_lru(head);
+	mz = page_cgroup_zoneinfo(head_pc->mem_cgroup, head);
+	MEM_CGROUP_ZSTAT(mz, lru) -= HPAGE_PMD_NR - 1;
 }
 #endif
 
@@ -2620,7 +2601,7 @@ static int mem_cgroup_move_parent(struct
 
 	parent = mem_cgroup_from_cont(pcg);
 	ret = __mem_cgroup_try_charge(NULL, gfp_mask, nr_pages, &parent, false);
-	if (ret || !parent)
+	if (ret)
 		goto put_back;
 
 	if (nr_pages > 1)
@@ -2667,9 +2648,8 @@ static int mem_cgroup_charge_common(stru
 
 	pc = lookup_page_cgroup(page);
 	ret = __mem_cgroup_try_charge(mm, gfp_mask, nr_pages, &memcg, oom);
-	if (ret || !memcg)
+	if (ret == -ENOMEM)
 		return ret;
-
 	__mem_cgroup_commit_charge(memcg, page, nr_pages, pc, ctype);
 	return 0;
 }
@@ -2736,10 +2716,9 @@ int mem_cgroup_cache_charge(struct page 
 	if (!page_is_file_cache(page))
 		type = MEM_CGROUP_CHARGE_TYPE_SHMEM;
 
-	if (!PageSwapCache(page)) {
+	if (!PageSwapCache(page))
 		ret = mem_cgroup_charge_common(page, mm, gfp_mask, type);
-		WARN_ON_ONCE(PageLRU(page));
-	} else { /* page is swapcache/shmem */
+	else { /* page is swapcache/shmem */
 		ret = mem_cgroup_try_charge_swapin(mm, page, gfp_mask, &memcg);
 		if (!ret)
 			__mem_cgroup_commit_charge_swapin(page, memcg, type);
@@ -2781,11 +2760,16 @@ int mem_cgroup_try_charge_swapin(struct 
 	*memcgp = memcg;
 	ret = __mem_cgroup_try_charge(NULL, mask, 1, memcgp, true);
 	css_put(&memcg->css);
+	if (ret == -EINTR)
+		ret = 0;
 	return ret;
 charge_cur_mm:
 	if (unlikely(!mm))
 		mm = &init_mm;
-	return __mem_cgroup_try_charge(mm, mask, 1, memcgp, true);
+	ret = __mem_cgroup_try_charge(mm, mask, 1, memcgp, true);
+	if (ret == -EINTR)
+		ret = 0;
+	return ret;
 }
 
 static void
@@ -3245,7 +3229,7 @@ int mem_cgroup_prepare_migration(struct 
 	*memcgp = memcg;
 	ret = __mem_cgroup_try_charge(NULL, gfp_mask, 1, memcgp, false);
 	css_put(&memcg->css);/* drop extra refcnt */
-	if (ret || *memcgp == NULL) {
+	if (ret) {
 		if (PageAnon(page)) {
 			lock_page_cgroup(pc);
 			ClearPageCgroupMigration(pc);
@@ -3255,6 +3239,7 @@ int mem_cgroup_prepare_migration(struct 
 			 */
 			mem_cgroup_uncharge_page(page);
 		}
+		/* we'll need to revisit this error code (we have -EINTR) */
 		return -ENOMEM;
 	}
 	/*
@@ -3674,7 +3659,7 @@ static int mem_cgroup_force_empty_list(s
 		pc = lookup_page_cgroup(page);
 
 		ret = mem_cgroup_move_parent(page, pc, memcg, GFP_KERNEL);
-		if (ret == -ENOMEM)
+		if (ret == -ENOMEM || ret == -EINTR)
 			break;
 
 		if (ret == -EBUSY || ret == -EINVAL) {
@@ -5065,9 +5050,9 @@ one_by_one:
 		}
 		ret = __mem_cgroup_try_charge(NULL,
 					GFP_KERNEL, 1, &memcg, false);
-		if (ret || !memcg)
+		if (ret)
 			/* mem_cgroup_clear_mc() will do uncharge later */
-			return -ENOMEM;
+			return ret;
 		mc.precharge++;
 	}
 	return ret;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
mm-fix-null-ptr-dereference-in-__count_immobile_pages.patch
mm-__count_immobile_pages-make-sure-the-node-is-online.patch
mm-hugetlb-undo-change-to-page-mapcount-in-fault-handler.patch

