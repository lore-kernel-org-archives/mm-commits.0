From: akpm@linux-foundation.org
Subject: + memcg-fix-rmdir-force_empty-with-thp.patch added to -mm tree
Date: Wed, 19 Jan 2011 12:51:00 -0800
Message-ID: <201101192051.p0JKp0cx002271@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38478 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751473Ab1ASUvg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Jan 2011 15:51:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, hannes@cmpxchg.org, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: fix rmdir, force_empty with THP
has been added to the -mm tree.  Its filename is
     memcg-fix-rmdir-force_empty-with-thp.patch

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
Subject: memcg: fix rmdir, force_empty with THP
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now, when THP is enabled, memcg's rmdir() function is broken because
move_account() for THP page is not supported.

This will cause account leak or -EBUSY issue at rmdir().
This patch fixes the issue by supporting move_account() THP pages.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-rmdir-force_empty-with-thp mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-rmdir-force_empty-with-thp
+++ a/mm/memcontrol.c
@@ -2197,8 +2197,11 @@ void mem_cgroup_split_huge_fixup(struct 
  */
 
 static void __mem_cgroup_move_account(struct page_cgroup *pc,
-	struct mem_cgroup *from, struct mem_cgroup *to, bool uncharge)
+	struct mem_cgroup *from, struct mem_cgroup *to, bool uncharge,
+	int charge_size)
 {
+	int nr_pages = charge_size >> PAGE_SHIFT;
+
 	VM_BUG_ON(from == to);
 	VM_BUG_ON(PageLRU(pc->page));
 	VM_BUG_ON(!page_is_cgroup_locked(pc));
@@ -2212,14 +2215,14 @@ static void __mem_cgroup_move_account(st
 		__this_cpu_inc(to->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
 		preempt_enable();
 	}
-	mem_cgroup_charge_statistics(from, PageCgroupCache(pc), -1);
+	mem_cgroup_charge_statistics(from, PageCgroupCache(pc), -nr_pages);
 	if (uncharge)
 		/* This is not "cancel", but cancel_charge does all we need. */
-		mem_cgroup_cancel_charge(from, PAGE_SIZE);
+		mem_cgroup_cancel_charge(from, charge_size);
 
 	/* caller should have done css_get */
 	pc->mem_cgroup = to;
-	mem_cgroup_charge_statistics(to, PageCgroupCache(pc), 1);
+	mem_cgroup_charge_statistics(to, PageCgroupCache(pc), nr_pages);
 	/*
 	 * We charges against "to" which may not have any tasks. Then, "to"
 	 * can be under rmdir(). But in current implementation, caller of
@@ -2234,15 +2237,19 @@ static void __mem_cgroup_move_account(st
  * __mem_cgroup_move_account()
  */
 static int mem_cgroup_move_account(struct page_cgroup *pc,
-		struct mem_cgroup *from, struct mem_cgroup *to, bool uncharge)
+		struct mem_cgroup *from, struct mem_cgroup *to,
+		bool uncharge, int charge_size)
 {
 	int ret = -EINVAL;
 	unsigned long flags;
 
+	if ((charge_size > PAGE_SIZE) && !PageTransHuge(pc->page))
+		return -EBUSY;
+
 	lock_page_cgroup(pc);
 	if (PageCgroupUsed(pc) && pc->mem_cgroup == from) {
 		move_lock_page_cgroup(pc, &flags);
-		__mem_cgroup_move_account(pc, from, to, uncharge);
+		__mem_cgroup_move_account(pc, from, to, uncharge, charge_size);
 		move_unlock_page_cgroup(pc, &flags);
 		ret = 0;
 	}
@@ -2267,6 +2274,8 @@ static int mem_cgroup_move_parent(struct
 	struct cgroup *cg = child->css.cgroup;
 	struct cgroup *pcg = cg->parent;
 	struct mem_cgroup *parent;
+	int charge = PAGE_SIZE;
+	unsigned long flags;
 	int ret;
 
 	/* Is ROOT ? */
@@ -2278,17 +2287,23 @@ static int mem_cgroup_move_parent(struct
 		goto out;
 	if (isolate_lru_page(page))
 		goto put;
+	/* The page is isolated from LRU and we have no race with splitting */
+	charge = PAGE_SIZE << compound_order(page);
 
 	parent = mem_cgroup_from_cont(pcg);
-	ret = __mem_cgroup_try_charge(NULL, gfp_mask, &parent, false,
-				      PAGE_SIZE);
+	ret = __mem_cgroup_try_charge(NULL, gfp_mask, &parent, false, charge);
 	if (ret || !parent)
 		goto put_back;
 
-	ret = mem_cgroup_move_account(pc, child, parent, true);
+	if (charge > PAGE_SIZE)
+		flags = compound_lock_irqsave(page);
+
+	ret = mem_cgroup_move_account(pc, child, parent, true, charge);
 	if (ret)
-		mem_cgroup_cancel_charge(parent, PAGE_SIZE);
+		mem_cgroup_cancel_charge(parent, charge);
 put_back:
+	if (charge > PAGE_SIZE)
+		compound_unlock_irqrestore(page, flags);
 	putback_lru_page(page);
 put:
 	put_page(page);
@@ -4868,7 +4883,7 @@ retry:
 				goto put;
 			pc = lookup_page_cgroup(page);
 			if (!mem_cgroup_move_account(pc,
-						mc.from, mc.to, false)) {
+					mc.from, mc.to, false, PAGE_SIZE)) {
 				mc.precharge--;
 				/* we uncharge from mc.from later. */
 				mc.moved_charge++;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

memcg-modify-accounting-function-for-supporting-thp-better.patch
memcg-fix-used-bit-handling-at-uncharge-in-thp.patch
memcg-fix-lru-accounting-with-thp.patch
memcg-fix-rmdir-force_empty-with-thp.patch
memcg-correctly-order-reading-pcg_used-and-pc-mem_cgroup.patch
mm-add-replace_page_cache_page-function.patch

