From: akpm@linux-foundation.org
Subject: [merged]
 memcg-sanitize-__mem_cgroup_try_charge-call-protocol.patch removed from -mm tree
Date: Tue, 08 Apr 2014 13:53:50 -0700
Message-ID: <534461de.grva8z7hLpPULRvF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56544 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739AbaDHUxv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:53:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, hannes@cmpxchg.org

Subject: [merged] memcg-sanitize-__mem_cgroup_try_charge-call-protocol.patch removed from -mm tree
To: hannes@cmpxchg.org,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:53:50 -0700


The patch titled
     Subject: memcg: sanitize __mem_cgroup_try_charge() call protocol
has been removed from the -mm tree.  Its filename was
     memcg-sanitize-__mem_cgroup_try_charge-call-protocol.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: memcg: sanitize __mem_cgroup_try_charge() call protocol

Some callsites pass a memcg directly, some callsites pass an mm that then
has to be translated to a memcg.  This makes for a terrible function
interface.

Just push the mm-to-memcg translation into the respective callsites and
always pass a memcg to mem_cgroup_try_charge().

[mhocko@suse.cz: add charge mm helper]
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  211 ++++++++++++++++++++++------------------------
 1 file changed, 104 insertions(+), 107 deletions(-)

diff -puN mm/memcontrol.c~memcg-sanitize-__mem_cgroup_try_charge-call-protocol mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-sanitize-__mem_cgroup_try_charge-call-protocol
+++ a/mm/memcontrol.c
@@ -2575,7 +2575,7 @@ static int memcg_cpu_hotplug_callback(st
 }
 
 
-/* See __mem_cgroup_try_charge() for details */
+/* See mem_cgroup_try_charge() for details */
 enum {
 	CHARGE_OK,		/* success */
 	CHARGE_RETRY,		/* need to retry but retry is not bad */
@@ -2648,45 +2648,34 @@ static int mem_cgroup_do_charge(struct m
 	return CHARGE_NOMEM;
 }
 
-/*
- * __mem_cgroup_try_charge() does
- * 1. detect memcg to be charged against from passed *mm and *ptr,
- * 2. update res_counter
- * 3. call memory reclaim if necessary.
- *
- * In some special case, if the task is fatal, fatal_signal_pending() or
- * has TIF_MEMDIE, this function returns -EINTR while writing root_mem_cgroup
- * to *ptr. There are two reasons for this. 1: fatal threads should quit as soon
- * as possible without any hazards. 2: all pages should have a valid
- * pc->mem_cgroup. If mm is NULL and the caller doesn't pass a valid memcg
- * pointer, that is treated as a charge to root_mem_cgroup.
- *
- * So __mem_cgroup_try_charge() will return
- *  0       ...  on success, filling *ptr with a valid memcg pointer.
- *  -ENOMEM ...  charge failure because of resource limits.
- *  -EINTR  ...  if thread is fatal. *ptr is filled with root_mem_cgroup.
- *
- * Unlike the exported interface, an "oom" parameter is added. if oom==true,
- * the oom-killer can be invoked.
- */
-static int __mem_cgroup_try_charge(struct mm_struct *mm,
-				   gfp_t gfp_mask,
-				   unsigned int nr_pages,
-				   struct mem_cgroup **ptr,
-				   bool oom)
+/**
+ * mem_cgroup_try_charge - try charging a memcg
+ * @memcg: memcg to charge
+ * @nr_pages: number of pages to charge
+ * @oom: trigger OOM if reclaim fails
+ *
+ * Returns 0 if @memcg was charged successfully, -EINTR if the charge
+ * was bypassed to root_mem_cgroup, and -ENOMEM if the charge failed.
+ */
+static int mem_cgroup_try_charge(struct mem_cgroup *memcg,
+				 gfp_t gfp_mask,
+				 unsigned int nr_pages,
+				 bool oom)
 {
 	unsigned int batch = max(CHARGE_BATCH, nr_pages);
 	int nr_oom_retries = MEM_CGROUP_RECLAIM_RETRIES;
-	struct mem_cgroup *memcg = NULL;
 	int ret;
 
+	if (mem_cgroup_is_root(memcg))
+		goto done;
 	/*
-	 * Unlike gloval-vm's OOM-kill, we're not in memory shortage
-	 * in system level. So, allow to go ahead dying process in addition to
-	 * MEMDIE process.
+	 * Unlike in global OOM situations, memcg is not in a physical
+	 * memory shortage.  Allow dying and OOM-killed tasks to
+	 * bypass the last charges so that they can exit quickly and
+	 * free their memory.
 	 */
-	if (unlikely(test_thread_flag(TIF_MEMDIE)
-		     || fatal_signal_pending(current)))
+	if (unlikely(test_thread_flag(TIF_MEMDIE) ||
+		     fatal_signal_pending(current)))
 		goto bypass;
 
 	if (unlikely(task_in_memcg_oom(current)))
@@ -2695,14 +2684,6 @@ static int __mem_cgroup_try_charge(struc
 	if (gfp_mask & __GFP_NOFAIL)
 		oom = false;
 again:
-	if (*ptr) { /* css should be a valid one */
-		memcg = *ptr;
-		css_get(&memcg->css);
-	} else {
-		memcg = get_mem_cgroup_from_mm(mm);
-	}
-	if (mem_cgroup_is_root(memcg))
-		goto done;
 	if (consume_stock(memcg, nr_pages))
 		goto done;
 
@@ -2710,10 +2691,8 @@ again:
 		bool invoke_oom = oom && !nr_oom_retries;
 
 		/* If killed, bypass charge */
-		if (fatal_signal_pending(current)) {
-			css_put(&memcg->css);
+		if (fatal_signal_pending(current))
 			goto bypass;
-		}
 
 		ret = mem_cgroup_do_charge(memcg, gfp_mask, batch,
 					   nr_pages, invoke_oom);
@@ -2722,17 +2701,12 @@ again:
 			break;
 		case CHARGE_RETRY: /* not in OOM situation but retry */
 			batch = nr_pages;
-			css_put(&memcg->css);
-			memcg = NULL;
 			goto again;
 		case CHARGE_WOULDBLOCK: /* !__GFP_WAIT */
-			css_put(&memcg->css);
 			goto nomem;
 		case CHARGE_NOMEM: /* OOM routine works */
-			if (!oom || invoke_oom) {
-				css_put(&memcg->css);
+			if (!oom || invoke_oom)
 				goto nomem;
-			}
 			nr_oom_retries--;
 			break;
 		}
@@ -2741,19 +2715,43 @@ again:
 	if (batch > nr_pages)
 		refill_stock(memcg, batch - nr_pages);
 done:
-	css_put(&memcg->css);
-	*ptr = memcg;
 	return 0;
 nomem:
-	if (!(gfp_mask & __GFP_NOFAIL)) {
-		*ptr = NULL;
+	if (!(gfp_mask & __GFP_NOFAIL))
 		return -ENOMEM;
-	}
 bypass:
-	*ptr = root_mem_cgroup;
 	return -EINTR;
 }
 
+/**
+ * mem_cgroup_try_charge_mm - try charging a mm
+ * @mm: mm_struct to charge
+ * @nr_pages: number of pages to charge
+ * @oom: trigger OOM if reclaim fails
+ *
+ * Returns the charged mem_cgroup associated with the given mm_struct or
+ * NULL the charge failed.
+ */
+static struct mem_cgroup *mem_cgroup_try_charge_mm(struct mm_struct *mm,
+				 gfp_t gfp_mask,
+				 unsigned int nr_pages,
+				 bool oom)
+
+{
+	struct mem_cgroup *memcg;
+	int ret;
+
+	memcg = get_mem_cgroup_from_mm(mm);
+	ret = mem_cgroup_try_charge(memcg, gfp_mask, nr_pages, oom);
+	css_put(&memcg->css);
+	if (ret == -EINTR)
+		memcg = root_mem_cgroup;
+	else if (ret)
+		memcg = NULL;
+
+	return memcg;
+}
+
 /*
  * Somemtimes we have to undo a charge we got by try_charge().
  * This function is for that and do uncharge, put css's refcnt.
@@ -2949,20 +2947,17 @@ static int mem_cgroup_slabinfo_read(stru
 static int memcg_charge_kmem(struct mem_cgroup *memcg, gfp_t gfp, u64 size)
 {
 	struct res_counter *fail_res;
-	struct mem_cgroup *_memcg;
 	int ret = 0;
 
 	ret = res_counter_charge(&memcg->kmem, size, &fail_res);
 	if (ret)
 		return ret;
 
-	_memcg = memcg;
-	ret = __mem_cgroup_try_charge(NULL, gfp, size >> PAGE_SHIFT,
-				      &_memcg, oom_gfp_allowed(gfp));
-
+	ret = mem_cgroup_try_charge(memcg, gfp, size >> PAGE_SHIFT,
+				    oom_gfp_allowed(gfp));
 	if (ret == -EINTR)  {
 		/*
-		 * __mem_cgroup_try_charge() chosed to bypass to root due to
+		 * mem_cgroup_try_charge() chosed to bypass to root due to
 		 * OOM kill or fatal signal.  Since our only options are to
 		 * either fail the allocation or charge it to this cgroup, do
 		 * it as a temporary condition. But we can't fail. From a
@@ -2972,7 +2967,7 @@ static int memcg_charge_kmem(struct mem_
 		 *
 		 * This condition will only trigger if the task entered
 		 * memcg_charge_kmem in a sane state, but was OOM-killed during
-		 * __mem_cgroup_try_charge() above. Tasks that were already
+		 * mem_cgroup_try_charge() above. Tasks that were already
 		 * dying when the allocation triggers should have been already
 		 * directed to the root cgroup in memcontrol.h
 		 */
@@ -3826,10 +3821,9 @@ out:
 int mem_cgroup_newpage_charge(struct page *page,
 			      struct mm_struct *mm, gfp_t gfp_mask)
 {
-	struct mem_cgroup *memcg = NULL;
 	unsigned int nr_pages = 1;
+	struct mem_cgroup *memcg;
 	bool oom = true;
-	int ret;
 
 	if (mem_cgroup_disabled())
 		return 0;
@@ -3848,9 +3842,9 @@ int mem_cgroup_newpage_charge(struct pag
 		oom = false;
 	}
 
-	ret = __mem_cgroup_try_charge(mm, gfp_mask, nr_pages, &memcg, oom);
-	if (ret == -ENOMEM)
-		return ret;
+	memcg = mem_cgroup_try_charge_mm(mm, gfp_mask, nr_pages, oom);
+	if (!memcg)
+		return -ENOMEM;
 	__mem_cgroup_commit_charge(memcg, page, nr_pages,
 				   MEM_CGROUP_CHARGE_TYPE_ANON, false);
 	return 0;
@@ -3867,7 +3861,7 @@ static int __mem_cgroup_try_charge_swapi
 					  gfp_t mask,
 					  struct mem_cgroup **memcgp)
 {
-	struct mem_cgroup *memcg;
+	struct mem_cgroup *memcg = NULL;
 	struct page_cgroup *pc;
 	int ret;
 
@@ -3880,31 +3874,29 @@ static int __mem_cgroup_try_charge_swapi
 	 * in turn serializes uncharging.
 	 */
 	if (PageCgroupUsed(pc))
-		return 0;
-	if (!do_swap_account)
-		goto charge_cur_mm;
-	memcg = try_get_mem_cgroup_from_page(page);
+		goto out;
+	if (do_swap_account)
+		memcg = try_get_mem_cgroup_from_page(page);
 	if (!memcg)
-		goto charge_cur_mm;
-	*memcgp = memcg;
-	ret = __mem_cgroup_try_charge(NULL, mask, 1, memcgp, true);
+		memcg = get_mem_cgroup_from_mm(mm);
+	ret = mem_cgroup_try_charge(memcg, mask, 1, true);
 	css_put(&memcg->css);
 	if (ret == -EINTR)
-		ret = 0;
-	return ret;
-charge_cur_mm:
-	ret = __mem_cgroup_try_charge(mm, mask, 1, memcgp, true);
-	if (ret == -EINTR)
-		ret = 0;
-	return ret;
+		memcg = root_mem_cgroup;
+	else if (ret)
+		return ret;
+out:
+	*memcgp = memcg;
+	return 0;
 }
 
 int mem_cgroup_try_charge_swapin(struct mm_struct *mm, struct page *page,
 				 gfp_t gfp_mask, struct mem_cgroup **memcgp)
 {
-	*memcgp = NULL;
-	if (mem_cgroup_disabled())
+	if (mem_cgroup_disabled()) {
+		*memcgp = NULL;
 		return 0;
+	}
 	/*
 	 * A racing thread's fault, or swapoff, may have already
 	 * updated the pte, and even removed page from swap cache: in
@@ -3912,12 +3904,13 @@ int mem_cgroup_try_charge_swapin(struct
 	 * there's also a KSM case which does need to charge the page.
 	 */
 	if (!PageSwapCache(page)) {
-		int ret;
+		struct mem_cgroup *memcg;
 
-		ret = __mem_cgroup_try_charge(mm, gfp_mask, 1, memcgp, true);
-		if (ret == -EINTR)
-			ret = 0;
-		return ret;
+		memcg = mem_cgroup_try_charge_mm(mm, gfp_mask, 1, true);
+		if (!memcg)
+			return -ENOMEM;
+		*memcgp = memcg;
+		return 0;
 	}
 	return __mem_cgroup_try_charge_swapin(mm, page, gfp_mask, memcgp);
 }
@@ -3964,8 +3957,8 @@ void mem_cgroup_commit_charge_swapin(str
 int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 				gfp_t gfp_mask)
 {
-	struct mem_cgroup *memcg = NULL;
 	enum charge_type type = MEM_CGROUP_CHARGE_TYPE_CACHE;
+	struct mem_cgroup *memcg;
 	int ret;
 
 	if (mem_cgroup_disabled())
@@ -3973,23 +3966,28 @@ int mem_cgroup_cache_charge(struct page
 	if (PageCompound(page))
 		return 0;
 
-	if (!PageSwapCache(page)) {
-		/*
-		 * Page cache insertions can happen without an actual
-		 * task context, e.g. during disk probing on boot.
-		 */
-		if (!mm)
-			memcg = root_mem_cgroup;
-		ret = __mem_cgroup_try_charge(mm, gfp_mask, 1, &memcg, true);
-		if (ret != -ENOMEM)
-			__mem_cgroup_commit_charge(memcg, page, 1, type, false);
-	} else { /* page is swapcache/shmem */
+	if (PageSwapCache(page)) { /* shmem */
 		ret = __mem_cgroup_try_charge_swapin(mm, page,
 						     gfp_mask, &memcg);
-		if (!ret)
-			__mem_cgroup_commit_charge_swapin(page, memcg, type);
+		if (ret)
+			return ret;
+		__mem_cgroup_commit_charge_swapin(page, memcg, type);
+		return 0;
 	}
-	return ret;
+
+	/*
+	 * Page cache insertions can happen without an actual mm
+	 * context, e.g. during disk probing on boot.
+	 */
+	if (unlikely(!mm))
+		memcg = root_mem_cgroup;
+	else {
+		memcg = mem_cgroup_try_charge_mm(mm, gfp_mask, 1, true);
+		if (!memcg)
+			return -ENOMEM;
+	}
+	__mem_cgroup_commit_charge(memcg, page, 1, type, false);
+	return 0;
 }
 
 static void mem_cgroup_do_uncharge(struct mem_cgroup *memcg,
@@ -6601,8 +6599,7 @@ one_by_one:
 			batch_count = PRECHARGE_COUNT_AT_ONCE;
 			cond_resched();
 		}
-		ret = __mem_cgroup_try_charge(NULL,
-					GFP_KERNEL, 1, &memcg, false);
+		ret = mem_cgroup_try_charge(memcg, GFP_KERNEL, 1, false);
 		if (ret)
 			/* mem_cgroup_clear_mc() will do uncharge later */
 			return ret;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-vmscan-do-not-swap-anon-pages-just-because-freefile-is-low.patch

