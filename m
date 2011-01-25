From: akpm@linux-foundation.org
Subject: + memcg-fix-race-at-move_parent-around-compound_order.patch added to -mm tree
Date: Tue, 25 Jan 2011 12:40:15 -0800
Message-ID: <201101252040.p0PKeFJn006707@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753578Ab1AYUlY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Jan 2011 15:41:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, hannes@cmpxchg.org, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: fix race at move_parent around compound_order()
has been added to the -mm tree.  Its filename is
     memcg-fix-race-at-move_parent-around-compound_order.patch

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
Subject: memcg: fix race at move_parent around compound_order()
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

A fix up mem_cgroup_move_parent() which use compound_order() in
asynchrnous manner.  This compound_order() may return unknown value
because we don't take lock.  Use PageTransHuge() and HPAGE_SIZE instead of
it.

Also clean up for mem_cgroup_move_parent().
 - remove unnecessary initialization of local variable.
 - rename charge_size -> page_size
 - remove unnecessary (wrong) comment.
 - added a comment about THP.

Note:
 Current design take compound_page_lock() in caller of move_account().
 This should be revisited when we implement direct move_task of hugepage
 without splitting.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-race-at-move_parent-around-compound_order mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-race-at-move_parent-around-compound_order
+++ a/mm/memcontrol.c
@@ -2236,7 +2236,12 @@ static int mem_cgroup_move_account(struc
 {
 	int ret = -EINVAL;
 	unsigned long flags;
-
+	/*
+	 * The page is isolated from LRU. So, collapse function
+ 	 * will not handle this page. But page splitting can happen.
+ 	 * Do this check under compound_page_lock(). The caller should
+ 	 * hold it.
+ 	 */
 	if ((charge_size > PAGE_SIZE) && !PageTransHuge(pc->page))
 		return -EBUSY;
 
@@ -2268,7 +2273,7 @@ static int mem_cgroup_move_parent(struct
 	struct cgroup *cg = child->css.cgroup;
 	struct cgroup *pcg = cg->parent;
 	struct mem_cgroup *parent;
-	int charge = PAGE_SIZE;
+	int page_size = PAGE_SIZE;
 	unsigned long flags;
 	int ret;
 
@@ -2281,22 +2286,24 @@ static int mem_cgroup_move_parent(struct
 		goto out;
 	if (isolate_lru_page(page))
 		goto put;
-	/* The page is isolated from LRU and we have no race with splitting */
-	charge = PAGE_SIZE << compound_order(page);
+
+	if (PageTransHuge(page))
+		page_size = HPAGE_SIZE;
 
 	parent = mem_cgroup_from_cont(pcg);
-	ret = __mem_cgroup_try_charge(NULL, gfp_mask, &parent, false, charge);
+	ret = __mem_cgroup_try_charge(NULL, gfp_mask,
+				&parent, false, page_size);
 	if (ret || !parent)
 		goto put_back;
 
-	if (charge > PAGE_SIZE)
+	if (page_size > PAGE_SIZE)
 		flags = compound_lock_irqsave(page);
 
-	ret = mem_cgroup_move_account(pc, child, parent, true, charge);
+	ret = mem_cgroup_move_account(pc, child, parent, true, page_size);
 	if (ret)
-		mem_cgroup_cancel_charge(parent, charge);
+		mem_cgroup_cancel_charge(parent, page_size);
 
-	if (charge > PAGE_SIZE)
+	if (page_size > PAGE_SIZE)
 		compound_unlock_irqrestore(page, flags);
 put_back:
 	putback_lru_page(page);
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

mm-fix-deferred-congestion-timeout-if-preferred-zone-is-not-allowed.patch
mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator.patch
mm-memcontrolc-fix-uninitialized-variable-use-in-mem_cgroup_move_parent.patch
memcg-fix-account-leak-at-failure-of-memsw-acconting.patch
memcg-bugfix-check-mem_cgroup_disabled-at-split-fixup.patch
memcg-fix-race-at-move_parent-around-compound_order.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-oom-kill.patch
oom-suppress-show_mem-for-many-nodes-in-irq-context-on-page-alloc-failure.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-page-alloc-failure.patch
mm-add-replace_page_cache_page-function.patch

