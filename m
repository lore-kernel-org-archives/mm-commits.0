From: akpm@linux-foundation.org
Subject: + memcg-make-mem_cgroup_split_huge_fixup-more-efficient.patch added to -mm tree
Date: Thu, 17 Nov 2011 13:00:55 -0800
Message-ID: <201111172100.pAHL0tb1023772@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:57524 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab1KQVA6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2011 16:00:58 -0500
Received: by ggnp4 with SMTP id p4so267019ggn.1
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2011 13:00:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, aarcange@redhat.com, bsingharora@gmail.com, hannes@cmpxchg.org, mhocko@suse.cz, rientjes@google.com


The patch titled
     Subject: memcg: make mem_cgroup_split_huge_fixup() more efficient
has been added to the -mm tree.  Its filename is
     memcg-make-mem_cgroup_split_huge_fixup-more-efficient.patch

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

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    5 ++---
 mm/huge_memory.c           |    3 ++-
 mm/memcontrol.c            |   32 ++++++++++++++++----------------
 3 files changed, 20 insertions(+), 20 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-make-mem_cgroup_split_huge_fixup-more-efficient include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-make-mem_cgroup_split_huge_fixup-more-efficient
+++ a/include/linux/memcontrol.h
@@ -158,7 +158,7 @@ u64 mem_cgroup_get_limit(struct mem_cgro
 
 void mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx);
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-void mem_cgroup_split_huge_fixup(struct page *head, struct page *tail);
+void mem_cgroup_split_huge_fixup(struct page *head);
 #endif
 
 #ifdef CONFIG_DEBUG_VM
@@ -374,8 +374,7 @@ u64 mem_cgroup_get_limit(struct mem_cgro
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
@@ -2488,38 +2488,38 @@ static void __mem_cgroup_commit_charge(s
 /*
  * Because tail pages are not marked as "used", set it. We're under
  * zone->lru_lock, 'splitting on pmd' and compund_lock.
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
-
 		/*
-		 * LRU flags cannot be copied because we need to add tail
-		 *.page to LRU by generic call and our hook will be called.
 		 * We hold lru_lock, then, reduce counter directly.
 		 */
 		lru = page_lru(head);
 		mz = page_cgroup_zoneinfo(head_pc->mem_cgroup, head);
-		MEM_CGROUP_ZSTAT(mz, lru) -= 1;
+		MEM_CGROUP_ZSTAT(mz, lru) -= HPAGE_PMD_NR - 1;
 	}
-	tail_pc->flags = head_pc->flags & ~PCGF_NOCOPY_AT_SPLIT;
-	move_unlock_page_cgroup(head_pc, &flags);
 }
 #endif
 
_
Subject: Subject: memcg: make mem_cgroup_split_huge_fixup() more efficient

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
linux-next.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
mm-avoid-livelock-on-__gfp_fs-allocations.patch
mm-avoid-livelock-on-__gfp_fs-allocations-fix.patch
cgroup-fix-task-counter-common-ancestor-logic.patch
mm-memcg-consolidate-hierarchy-iteration-primitives.patch
mm-vmscan-distinguish-global-reclaim-from-global-lru-scanning.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned.patch
mm-memcg-per-priority-per-zone-hierarchy-scan-generations.patch
mm-move-memcg-hierarchy-reclaim-to-generic-reclaim-code.patch
mm-memcg-remove-optimization-of-keeping-the-root_mem_cgroup-lru-lists-empty.patch
mm-vmscan-convert-global-reclaim-to-per-memcg-lru-lists.patch
mm-collect-lru-list-heads-into-struct-lruvec.patch
mm-make-per-memcg-lru-lists-exclusive.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags-fix.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient.patch

