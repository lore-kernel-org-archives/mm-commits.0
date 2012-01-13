From: akpm@linux-foundation.org
Subject: [merged] memcg-make-mem_cgroup_split_huge_fixup-more-efficient.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:33:14 -0800
Message-ID: <20120113203315.2E1B95C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:49326 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759096Ab2AMUdR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:33:17 -0500
Received: by mail-ee0-f74.google.com with SMTP id e50so23664eek.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:33:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, aarcange@redhat.com, bsingharora@gmail.com, hannes@cmpxchg.org, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: make mem_cgroup_split_huge_fixup() more efficient
has been removed from the -mm tree.  Its filename was
     memcg-make-mem_cgroup_split_huge_fixup-more-efficient.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: memcg: make mem_cgroup_split_huge_fixup() more efficient

In split_huge_page(), mem_cgroup_split_huge_fixup() is called to handle
page_cgroup modifcations.  It takes move_lock_page_cgroup() and modifies
page_cgroup and LRU accounting jobs and called HPAGE_PMD_SIZE - 1 times.

But thinking again,
  - compound_lock() is held at move_accout...then, it's not necessary
    to take move_lock_page_cgroup().
  - LRU is locked and all tail pages will go into the same LRU as
    head is now on.
  - page_cgroup is contiguous in huge page range.

This patch fixes mem_cgroup_split_huge_fixup() as to be called once per
hugepage and reduce costs for spliting.

[akpm@linux-foundation.org: fix typo, per Michal]
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    5 ++---
 mm/huge_memory.c           |    3 ++-
 mm/memcontrol.c            |   34 +++++++++++++++++-----------------
 3 files changed, 21 insertions(+), 21 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-make-mem_cgroup_split_huge_fixup-more-efficient include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-make-mem_cgroup_split_huge_fixup-more-efficient
+++ a/include/linux/memcontrol.h
@@ -163,7 +163,7 @@ u64 mem_cgroup_get_limit(struct mem_cgro
 
 void mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx);
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-void mem_cgroup_split_huge_fixup(struct page *head, struct page *tail);
+void mem_cgroup_split_huge_fixup(struct page *head);
 #endif
 
 #ifdef CONFIG_DEBUG_VM
@@ -379,8 +379,7 @@ u64 mem_cgroup_get_limit(struct mem_cgro
 	return 0;
 }
 
-static inline void mem_cgroup_split_huge_fixup(struct page *head,
-						struct page *tail)
+static inline void mem_cgroup_split_huge_fixup(struct page *head)
 {
 }
 
diff -puN mm/huge_memory.c~memcg-make-mem_cgroup_split_huge_fixup-more-efficient mm/huge_memory.c
--- a/mm/huge_memory.c~memcg-make-mem_cgroup_split_huge_fixup-more-efficient
+++ a/mm/huge_memory.c
@@ -1207,6 +1207,8 @@ static void __split_huge_page_refcount(s
 	/* prevent PageLRU to go away from under us, and freeze lru stats */
 	spin_lock_irq(&zone->lru_lock);
 	compound_lock(page);
+	/* complete memcg works before add pages to LRU */
+	mem_cgroup_split_huge_fixup(page);
 
 	for (i = 1; i < HPAGE_PMD_NR; i++) {
 		struct page *page_tail = page + i;
@@ -1278,7 +1280,6 @@ static void __split_huge_page_refcount(s
 		BUG_ON(!PageDirty(page_tail));
 		BUG_ON(!PageSwapBacked(page_tail));
 
-		mem_cgroup_split_huge_fixup(page, page_tail);
 
 		lru_add_page_tail(zone, page, page_tail);
 	}
diff -puN mm/memcontrol.c~memcg-make-mem_cgroup_split_huge_fixup-more-efficient mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-make-mem_cgroup_split_huge_fixup-more-efficient
+++ a/mm/memcontrol.c
@@ -2553,39 +2553,39 @@ static void __mem_cgroup_commit_charge(s
 			(1 << PCG_ACCT_LRU) | (1 << PCG_MIGRATION))
 /*
  * Because tail pages are not marked as "used", set it. We're under
- * zone->lru_lock, 'splitting on pmd' and compund_lock.
+ * zone->lru_lock, 'splitting on pmd' and compound_lock.
+ * charge/uncharge will be never happen and move_account() is done under
+ * compound_lock(), so we don't have to take care of races.
  */
-void mem_cgroup_split_huge_fixup(struct page *head, struct page *tail)
+void mem_cgroup_split_huge_fixup(struct page *head)
 {
 	struct page_cgroup *head_pc = lookup_page_cgroup(head);
-	struct page_cgroup *tail_pc = lookup_page_cgroup(tail);
-	unsigned long flags;
+	struct page_cgroup *pc;
+	int i;
 
 	if (mem_cgroup_disabled())
 		return;
-	/*
-	 * We have no races with charge/uncharge but will have races with
-	 * page state accounting.
-	 */
-	move_lock_page_cgroup(head_pc, &flags);
+	for (i = 1; i < HPAGE_PMD_NR; i++) {
+		pc = head_pc + i;
+		pc->mem_cgroup = head_pc->mem_cgroup;
+		smp_wmb();/* see __commit_charge() */
+		/*
+		 * LRU flags cannot be copied because we need to add tail
+		 * page to LRU by generic call and our hooks will be called.
+		 */
+		pc->flags = head_pc->flags & ~PCGF_NOCOPY_AT_SPLIT;
+	}
 
-	tail_pc->mem_cgroup = head_pc->mem_cgroup;
-	smp_wmb(); /* see __commit_charge() */
 	if (PageCgroupAcctLRU(head_pc)) {
 		enum lru_list lru;
 		struct mem_cgroup_per_zone *mz;
