From: akpm@linux-foundation.org
Subject: + memcg-fix-lru-accounting-with-thp.patch added to -mm tree
Date: Wed, 19 Jan 2011 12:50:58 -0800
Message-ID: <201101192050.p0JKow5l002267@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40166 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752647Ab1ASUv0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Jan 2011 15:51:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, hannes@cmpxchg.org, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: fix LRU accounting with THP
has been added to the -mm tree.  Its filename is
     memcg-fix-lru-accounting-with-thp.patch

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
Subject: memcg: fix LRU accounting with THP
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

memory cgroup's LRU stat should take care of size of pages because
Transparent Hugepage inserts hugepage into LRU.  If this value is the
number wrong, memory reclaim will not work well.

Note: only head page of THP's huge page is linked into LRU.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-lru-accounting-with-thp mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-lru-accounting-with-thp
+++ a/mm/memcontrol.c
@@ -814,7 +814,8 @@ void mem_cgroup_del_lru_list(struct page
 	 * removed from global LRU.
 	 */
 	mz = page_cgroup_zoneinfo(pc);
-	MEM_CGROUP_ZSTAT(mz, lru) -= 1;
+	/* huge page split is done under lru_lock. so, we have no races. */
+	MEM_CGROUP_ZSTAT(mz, lru) -= 1 << compound_order(page);
 	if (mem_cgroup_is_root(pc->mem_cgroup))
 		return;
 	VM_BUG_ON(list_empty(&pc->lru));
@@ -865,7 +866,8 @@ void mem_cgroup_add_lru_list(struct page
 		return;
 
 	mz = page_cgroup_zoneinfo(pc);
-	MEM_CGROUP_ZSTAT(mz, lru) += 1;
+	/* huge page split is done under lru_lock. so, we have no races. */
+	MEM_CGROUP_ZSTAT(mz, lru) += 1 << compound_order(page);
 	SetPageCgroupAcctLRU(pc);
 	if (mem_cgroup_is_root(pc->mem_cgroup))
 		return;
@@ -2152,14 +2154,26 @@ void mem_cgroup_split_huge_fixup(struct 
 	unsigned long flags;
 
 	/*
-	 * We have no races witch charge/uncharge but will have races with
+	 * We have no races with charge/uncharge but will have races with
 	 * page state accounting.
 	 */
 	move_lock_page_cgroup(head_pc, &flags);
 
 	tail_pc->mem_cgroup = head_pc->mem_cgroup;
 	smp_wmb(); /* see __commit_charge() */
-	/* we don't need to copy all flags...*/
+	if (PageCgroupAcctLRU(head_pc)) {
+		enum lru_list lru;
+		struct mem_cgroup_per_zone *mz;
+
+		/*
+		 * LRU flags cannot be copied because we need to add tail
+		 *.page to LRU by generic call and our hook will be called.
+		 * We hold lru_lock, then, reduce counter directly.
+		 */
+		lru = page_lru(head);
+		mz = page_cgroup_zoneinfo(head_pc);
+		MEM_CGROUP_ZSTAT(mz, lru) -= 1;
+	}
 	tail_pc->flags = head_pc->flags & ~PCGF_NOCOPY_AT_SPLIT;
 	move_unlock_page_cgroup(head_pc, &flags);
 }
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

memcg-modify-accounting-function-for-supporting-thp-better.patch
memcg-fix-used-bit-handling-at-uncharge-in-thp.patch
memcg-fix-lru-accounting-with-thp.patch
memcg-fix-rmdir-force_empty-with-thp.patch
memcg-correctly-order-reading-pcg_used-and-pc-mem_cgroup.patch
mm-add-replace_page_cache_page-function.patch

