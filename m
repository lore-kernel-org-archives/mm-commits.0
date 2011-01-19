From: akpm@linux-foundation.org
Subject: + memcg-fix-used-bit-handling-at-uncharge-in-thp.patch added to -mm tree
Date: Wed, 19 Jan 2011 12:50:56 -0800
Message-ID: <201101192050.p0JKoumC002264@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47674 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751473Ab1ASUvf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Jan 2011 15:51:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, hannes@cmpxchg.org, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: fix USED bit handling at uncharge in THP
has been added to the -mm tree.  Its filename is
     memcg-fix-used-bit-handling-at-uncharge-in-thp.patch

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
Subject: memcg: fix USED bit handling at uncharge in THP
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now, under THP:

at charge:
  - PageCgroupUsed bit is set to all page_cgroup on a hugepage.
    ....set to 512 pages.
at uncharge
  - PageCgroupUsed bit is unset on the head page.

So, some pages will remain with "Used" bit.

This patch fixes that Used bit is set only to the head page.
Used bits for tail pages will be set at splitting if necessary.

This patch adds this lock order:
   compound_lock() -> page_cgroup_move_lock().

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    8 +++
 mm/huge_memory.c           |    2 
 mm/memcontrol.c            |   91 +++++++++++++++++++----------------
 3 files changed, 61 insertions(+), 40 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-fix-used-bit-handling-at-uncharge-in-thp include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-fix-used-bit-handling-at-uncharge-in-thp
+++ a/include/linux/memcontrol.h
@@ -146,6 +146,10 @@ unsigned long mem_cgroup_soft_limit_recl
 						gfp_t gfp_mask);
 u64 mem_cgroup_get_limit(struct mem_cgroup *mem);
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+void mem_cgroup_split_huge_fixup(struct page *head, struct page *tail);
+#endif
+
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
 struct mem_cgroup;
 
@@ -335,6 +339,10 @@ u64 mem_cgroup_get_limit(struct mem_cgro
 	return 0;
 }
 
+static inline mem_cgroup_split_huge_fixup(struct page *head, struct page *tail)
+{
+}
+
 #endif /* CONFIG_CGROUP_MEM_CONT */
 
 #endif /* _LINUX_MEMCONTROL_H */
diff -puN mm/huge_memory.c~memcg-fix-used-bit-handling-at-uncharge-in-thp mm/huge_memory.c
--- a/mm/huge_memory.c~memcg-fix-used-bit-handling-at-uncharge-in-thp
+++ a/mm/huge_memory.c
@@ -1203,6 +1203,8 @@ static void __split_huge_page_refcount(s
 		BUG_ON(!PageDirty(page_tail));
 		BUG_ON(!PageSwapBacked(page_tail));
 
+		mem_cgroup_split_huge_fixup(page, page_tail);
+
 		lru_add_page_tail(zone, page, page_tail);
 	}
 
diff -puN mm/memcontrol.c~memcg-fix-used-bit-handling-at-uncharge-in-thp mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-used-bit-handling-at-uncharge-in-thp
+++ a/mm/memcontrol.c
@@ -1614,7 +1614,7 @@ void mem_cgroup_update_page_stat(struct 
 	if (unlikely(!mem || !PageCgroupUsed(pc)))
 		goto out;
 	/* pc->mem_cgroup is unstable ? */
-	if (unlikely(mem_cgroup_stealed(mem))) {
+	if (unlikely(mem_cgroup_stealed(mem)) || PageTransHuge(page)) {
 		/* take a lock against to access pc->mem_cgroup */
 		move_lock_page_cgroup(pc, &flags);
 		need_unlock = true;
@@ -2083,14 +2083,27 @@ struct mem_cgroup *try_get_mem_cgroup_fr
 	return mem;
 }
 
-/*
- * commit a charge got by __mem_cgroup_try_charge() and makes page_cgroup to be
- * USED state. If already USED, uncharge and return.
- */
-static void ____mem_cgroup_commit_charge(struct mem_cgroup *mem,
-					 struct page_cgroup *pc,
-					 enum charge_type ctype)
+static void __mem_cgroup_commit_charge(struct mem_cgroup *mem,
+				       struct page_cgroup *pc,
+				       enum charge_type ctype,
+				       int page_size)
 {
+	int nr_pages = page_size >> PAGE_SHIFT;
+
+	/* try_charge() can return NULL to *memcg, taking care of it. */
+	if (!mem)
+		return;
+
+	lock_page_cgroup(pc);
+	if (unlikely(PageCgroupUsed(pc))) {
+		unlock_page_cgroup(pc);
+		mem_cgroup_cancel_charge(mem, page_size);
+		return;
+	}
+	/*
+	 * we don't need page_cgroup_lock about tail pages, becase they are not
+	 * accessed by any other context at this point.
+	 */
 	pc->mem_cgroup = mem;
 	/*
 	 * We access a page_cgroup asynchronously without lock_page_cgroup().
@@ -2114,35 +2127,7 @@ static void ____mem_cgroup_commit_charge
 		break;
 	}
 
-	mem_cgroup_charge_statistics(mem, PageCgroupCache(pc), 1);
-}
-
-static void __mem_cgroup_commit_charge(struct mem_cgroup *mem,
-				       struct page_cgroup *pc,
-				       enum charge_type ctype,
-				       int page_size)
-{
-	int i;
-	int count = page_size >> PAGE_SHIFT;
-
-	/* try_charge() can return NULL to *memcg, taking care of it. */
-	if (!mem)
-		return;
-
-	lock_page_cgroup(pc);
-	if (unlikely(PageCgroupUsed(pc))) {
-		unlock_page_cgroup(pc);
-		mem_cgroup_cancel_charge(mem, page_size);
-		return;
-	}
-
-	/*
-	 * we don't need page_cgroup_lock about tail pages, becase they are not
-	 * accessed by any other context at this point.
-	 */
-	for (i = 0; i < count; i++)
-		____mem_cgroup_commit_charge(mem, pc + i, ctype);
-
+	mem_cgroup_charge_statistics(mem, PageCgroupCache(pc), nr_pages);
 	unlock_page_cgroup(pc);
 	/*
 	 * "charge_statistics" updated event counter. Then, check it.
@@ -2152,6 +2137,34 @@ static void __mem_cgroup_commit_charge(s
 	memcg_check_events(mem, pc->page);
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+
+#define PCGF_NOCOPY_AT_SPLIT ((1 << PCG_LOCK) | (1 << PCG_MOVE_LOCK) |\
+			(1 << PCG_ACCT_LRU) | (1 << PCG_MIGRATION))
+/*
+ * Because tail pages are not marked as "used", set it. We're under
+ * zone->lru_lock, 'splitting on pmd' and compund_lock.
+ */
+void mem_cgroup_split_huge_fixup(struct page *head, struct page *tail)
+{
+	struct page_cgroup *head_pc = lookup_page_cgroup(head);
+	struct page_cgroup *tail_pc = lookup_page_cgroup(tail);
+	unsigned long flags;
+
+	/*
+	 * We have no races witch charge/uncharge but will have races with
+	 * page state accounting.
+	 */
+	move_lock_page_cgroup(head_pc, &flags);
+
+	tail_pc->mem_cgroup = head_pc->mem_cgroup;
+	smp_wmb(); /* see __commit_charge() */
+	/* we don't need to copy all flags...*/
+	tail_pc->flags = head_pc->flags & ~PCGF_NOCOPY_AT_SPLIT;
+	move_unlock_page_cgroup(head_pc, &flags);
+}
+#endif
+
 /**
  * __mem_cgroup_move_account - move account of the page
  * @pc:	page_cgroup of the page.
@@ -2545,7 +2558,6 @@ direct_uncharge:
 static struct mem_cgroup *
 __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
 {
-	int i;
 	int count;
 	struct page_cgroup *pc;
 	struct mem_cgroup *mem = NULL;
@@ -2595,8 +2607,7 @@ __mem_cgroup_uncharge_common(struct page
 		break;
 	}
 
-	for (i = 0; i < count; i++)
-		mem_cgroup_charge_statistics(mem, PageCgroupCache(pc), -1);
+	mem_cgroup_charge_statistics(mem, PageCgroupCache(pc), -count);
 
 	ClearPageCgroupUsed(pc);
 	/*
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

memcg-modify-accounting-function-for-supporting-thp-better.patch
memcg-fix-used-bit-handling-at-uncharge-in-thp.patch
memcg-fix-lru-accounting-with-thp.patch
memcg-fix-rmdir-force_empty-with-thp.patch
memcg-correctly-order-reading-pcg_used-and-pc-mem_cgroup.patch
mm-add-replace_page_cache_page-function.patch

