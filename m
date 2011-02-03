From: akpm@linux-foundation.org
Subject: + memcg-condense-page_cgroup-to-page-lookup-points.patch added to -mm tree
Date: Thu, 03 Feb 2011 15:31:15 -0800
Message-ID: <201102032331.p13NVFjC031219@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56147 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752227Ab1BCXb0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2011 18:31:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: condense page_cgroup-to-page lookup points
has been added to the -mm tree.  Its filename is
     memcg-condense-page_cgroup-to-page-lookup-points.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: condense page_cgroup-to-page lookup points
From: Johannes Weiner <hannes@cmpxchg.org>

The per-cgroup LRU lists string up 'struct page_cgroup's.  To get from
those structures to the page they represent, a lookup is required. 
Currently, the lookup is done through a direct pointer in struct
page_cgroup, so a lot of functions down the callchain do this lookup by
themselves instead of receiving the page pointer from their callers.

The next patch removes this pointer, however, and the lookup is no longer
that straight-forward.  In preparation for that, this patch only leaves
the non-optional lookups when coming directly from the LRU list and passes
the page down the stack.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff -puN mm/memcontrol.c~memcg-condense-page_cgroup-to-page-lookup-points mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-condense-page_cgroup-to-page-lookup-points
+++ a/mm/memcontrol.c
@@ -1051,9 +1051,11 @@ unsigned long mem_cgroup_isolate_pages(u
 		if (scan >= nr_to_scan)
 			break;
 
-		page = pc->page;
 		if (unlikely(!PageCgroupUsed(pc)))
 			continue;
+
+		page = pc->page;
+
 		if (unlikely(!PageLRU(page)))
 			continue;
 
@@ -2082,6 +2084,7 @@ struct mem_cgroup *try_get_mem_cgroup_fr
 }
 
 static void __mem_cgroup_commit_charge(struct mem_cgroup *mem,
+				       struct page *page,
 				       struct page_cgroup *pc,
 				       enum charge_type ctype,
 				       int page_size)
@@ -2128,7 +2131,7 @@ static void __mem_cgroup_commit_charge(s
 	 * Insert ancestor (and ancestor's ancestors), to softlimit RB-tree.
 	 * if they exceeds softlimit.
 	 */
-	memcg_check_events(mem, pc->page);
+	memcg_check_events(mem, page);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -2175,6 +2178,7 @@ void mem_cgroup_split_huge_fixup(struct 
 
 /**
  * mem_cgroup_move_account - move account of the page
+ * @page: the page
  * @pc:	page_cgroup of the page.
  * @from: mem_cgroup which the page is moved from.
  * @to:	mem_cgroup which the page is moved to. @from != @to.
@@ -2190,7 +2194,7 @@ void mem_cgroup_split_huge_fixup(struct 
  * true, this function does "uncharge" from old cgroup, but it doesn't if
  * @uncharge is false, so a caller should do "uncharge".
  */
-static int mem_cgroup_move_account(struct page_cgroup *pc,
+static int mem_cgroup_move_account(struct page *page, struct page_cgroup *pc,
 				   struct mem_cgroup *from, struct mem_cgroup *to,
 				   bool uncharge, int charge_size)
 {
@@ -2199,7 +2203,7 @@ static int mem_cgroup_move_account(struc
 	int ret;
 
 	VM_BUG_ON(from == to);
-	VM_BUG_ON(PageLRU(pc->page));
+	VM_BUG_ON(PageLRU(page));
 	/*
 	 * The page is isolated from LRU. So, collapse function
 	 * will not handle this page. But page splitting can happen.
@@ -2207,7 +2211,7 @@ static int mem_cgroup_move_account(struc
 	 * hold it.
 	 */
 	ret = -EBUSY;
-	if (charge_size > PAGE_SIZE && !PageTransHuge(pc->page))
+	if (charge_size > PAGE_SIZE && !PageTransHuge(page))
 		goto out;
 
 	lock_page_cgroup(pc);
@@ -2247,8 +2251,8 @@ unlock:
 	/*
 	 * check events
 	 */
-	memcg_check_events(to, pc->page);
-	memcg_check_events(from, pc->page);
+	memcg_check_events(to, page);
+	memcg_check_events(from, page);
 out:
 	return ret;
 }
@@ -2257,11 +2261,11 @@ out:
  * move charges to its parent.
  */
 
-static int mem_cgroup_move_parent(struct page_cgroup *pc,
+static int mem_cgroup_move_parent(struct page *page,
+				  struct page_cgroup *pc,
 				  struct mem_cgroup *child,
 				  gfp_t gfp_mask)
 {
-	struct page *page = pc->page;
 	struct cgroup *cg = child->css.cgroup;
 	struct cgroup *pcg = cg->parent;
 	struct mem_cgroup *parent;
@@ -2291,7 +2295,7 @@ static int mem_cgroup_move_parent(struct
 	if (page_size > PAGE_SIZE)
 		flags = compound_lock_irqsave(page);
 
-	ret = mem_cgroup_move_account(pc, child, parent, true, page_size);
+	ret = mem_cgroup_move_account(page, pc, child, parent, true, page_size);
 	if (ret)
 		mem_cgroup_cancel_charge(parent, page_size);
 
@@ -2337,7 +2341,7 @@ static int mem_cgroup_charge_common(stru
 	if (ret || !mem)
 		return ret;
 
-	__mem_cgroup_commit_charge(mem, pc, ctype, page_size);
+	__mem_cgroup_commit_charge(mem, page, pc, ctype, page_size);
 	return 0;
 }
 
@@ -2475,7 +2479,7 @@ __mem_cgroup_commit_charge_swapin(struct
 	cgroup_exclude_rmdir(&ptr->css);
 	pc = lookup_page_cgroup(page);
 	mem_cgroup_lru_del_before_commit_swapcache(page);
-	__mem_cgroup_commit_charge(ptr, pc, ctype, PAGE_SIZE);
+	__mem_cgroup_commit_charge(ptr, page, pc, ctype, PAGE_SIZE);
 	mem_cgroup_lru_add_after_commit_swapcache(page);
 	/*
 	 * Now swap is on-memory. This means this page may be
@@ -2930,7 +2934,7 @@ int mem_cgroup_prepare_migration(struct 
 		ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
 	else
 		ctype = MEM_CGROUP_CHARGE_TYPE_SHMEM;
-	__mem_cgroup_commit_charge(mem, pc, ctype, PAGE_SIZE);
+	__mem_cgroup_commit_charge(mem, page, pc, ctype, PAGE_SIZE);
 	return ret;
 }
 
@@ -3281,6 +3285,8 @@ static int mem_cgroup_force_empty_list(s
 	loop += 256;
 	busy = NULL;
 	while (loop--) {
+		struct page *page;
+
 		ret = 0;
 		spin_lock_irqsave(&zone->lru_lock, flags);
 		if (list_empty(list)) {
@@ -3296,7 +3302,9 @@ static int mem_cgroup_force_empty_list(s
 		}
 		spin_unlock_irqrestore(&zone->lru_lock, flags);
 
-		ret = mem_cgroup_move_parent(pc, mem, GFP_KERNEL);
+		page = pc->page;
+
+		ret = mem_cgroup_move_parent(page, pc, mem, GFP_KERNEL);
 		if (ret == -ENOMEM)
 			break;
 
@@ -4913,7 +4921,7 @@ retry:
 			if (isolate_lru_page(page))
 				goto put;
 			pc = lookup_page_cgroup(page);
-			if (!mem_cgroup_move_account(pc,
+			if (!mem_cgroup_move_account(page, pc,
 					mc.from, mc.to, false, PAGE_SIZE)) {
 				mc.precharge--;
 				/* we uncharge from mc.from later. */
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path-fix.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-fix-ugly-initialization-of-return-value-is-in-caller.patch
memcg-soft-limit-reclaim-should-end-at-limit-not-below.patch
memcg-simplify-the-way-memory-limits-are-checked.patch
memcg-remove-unused-page-flag-bitfield-defines.patch
memcg-remove-impossible-conditional-when-committing.patch
memcg-remove-null-check-from-lookup_page_cgroup-result.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages.patch
memcg-no-uncharged-pages-reach-page_cgroup_zoneinfo.patch
memcg-change-page_cgroup_zoneinfo-signature.patch
memcg-fold-__mem_cgroup_move_account-into-caller.patch
memcg-condense-page_cgroup-to-page-lookup-points.patch
memcg-remove-direct-page_cgroup-to-page-pointer.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch

