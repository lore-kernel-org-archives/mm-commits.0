From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-let-mem_cgroup_move_account-have-effect-only-if-mmu-enabled.patch removed from -mm tree
Date: Wed, 15 Apr 2015 12:11:31 -0700
Message-ID: <552eb7e3.IaQQ5dFCSkX8BOch%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48373 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932554AbbDOTLc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:11:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 762976180@qq.com, gang.chen.5i5j@gmail.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: let mem_cgroup_move_account() have effect only if MMU enabled
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-let-mem_cgroup_move_account-have-effect-only-if-mmu-enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chen Gang <762976180@qq.com>
Subject: mm: memcontrol: let mem_cgroup_move_account() have effect only if MMU enabled

When !MMU, it will report warning. The related warning with allmodconfig
under c6x:

    CC      mm/memcontrol.o
  mm/memcontrol.c:2802:12: warning: 'mem_cgroup_move_account' defined but not used [-Wunused-function]
   static int mem_cgroup_move_account(struct page *page,
              ^

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  172 +++++++++++++++++++++++-----------------------
 1 file changed, 86 insertions(+), 86 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-let-mem_cgroup_move_account-have-effect-only-if-mmu-enabled mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-let-mem_cgroup_move_account-have-effect-only-if-mmu-enabled
+++ a/mm/memcontrol.c
@@ -2785,92 +2785,6 @@ void mem_cgroup_split_huge_fixup(struct
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-/**
- * mem_cgroup_move_account - move account of the page
- * @page: the page
- * @nr_pages: number of regular pages (>1 for huge pages)
- * @from: mem_cgroup which the page is moved from.
- * @to:	mem_cgroup which the page is moved to. @from != @to.
- *
- * The caller must confirm following.
- * - page is not on LRU (isolate_page() is useful.)
- * - compound_lock is held when nr_pages > 1
- *
- * This function doesn't do "charge" to new cgroup and doesn't do "uncharge"
- * from old cgroup.
- */
-static int mem_cgroup_move_account(struct page *page,
-				   unsigned int nr_pages,
-				   struct mem_cgroup *from,
-				   struct mem_cgroup *to)
-{
-	unsigned long flags;
-	int ret;
-
-	VM_BUG_ON(from == to);
-	VM_BUG_ON_PAGE(PageLRU(page), page);
-	/*
-	 * The page is isolated from LRU. So, collapse function
-	 * will not handle this page. But page splitting can happen.
-	 * Do this check under compound_page_lock(). The caller should
-	 * hold it.
-	 */
-	ret = -EBUSY;
-	if (nr_pages > 1 && !PageTransHuge(page))
-		goto out;
-
-	/*
-	 * Prevent mem_cgroup_migrate() from looking at page->mem_cgroup
-	 * of its source page while we change it: page migration takes
-	 * both pages off the LRU, but page cache replacement doesn't.
-	 */
-	if (!trylock_page(page))
-		goto out;
-
-	ret = -EINVAL;
-	if (page->mem_cgroup != from)
-		goto out_unlock;
-
-	spin_lock_irqsave(&from->move_lock, flags);
-
-	if (!PageAnon(page) && page_mapped(page)) {
-		__this_cpu_sub(from->stat->count[MEM_CGROUP_STAT_FILE_MAPPED],
-			       nr_pages);
-		__this_cpu_add(to->stat->count[MEM_CGROUP_STAT_FILE_MAPPED],
-			       nr_pages);
-	}
-
-	if (PageWriteback(page)) {
-		__this_cpu_sub(from->stat->count[MEM_CGROUP_STAT_WRITEBACK],
-			       nr_pages);
-		__this_cpu_add(to->stat->count[MEM_CGROUP_STAT_WRITEBACK],
-			       nr_pages);
-	}
-
-	/*
-	 * It is safe to change page->mem_cgroup here because the page
-	 * is referenced, charged, and isolated - we can't race with
-	 * uncharging, charging, migration, or LRU putback.
-	 */
-
-	/* caller should have done css_get */
-	page->mem_cgroup = to;
-	spin_unlock_irqrestore(&from->move_lock, flags);
-
-	ret = 0;
-
-	local_irq_disable();
-	mem_cgroup_charge_statistics(to, page, nr_pages);
-	memcg_check_events(to, page);
-	mem_cgroup_charge_statistics(from, page, -nr_pages);
-	memcg_check_events(from, page);
-	local_irq_enable();
-out_unlock:
-	unlock_page(page);
-out:
-	return ret;
-}
-
 #ifdef CONFIG_MEMCG_SWAP
 static void mem_cgroup_swap_statistics(struct mem_cgroup *memcg,
 					 bool charge)
@@ -4822,6 +4736,92 @@ static struct page *mc_handle_file_pte(s
 	return page;
 }
 
+/**
+ * mem_cgroup_move_account - move account of the page
+ * @page: the page
+ * @nr_pages: number of regular pages (>1 for huge pages)
+ * @from: mem_cgroup which the page is moved from.
+ * @to:	mem_cgroup which the page is moved to. @from != @to.
+ *
+ * The caller must confirm following.
+ * - page is not on LRU (isolate_page() is useful.)
+ * - compound_lock is held when nr_pages > 1
+ *
+ * This function doesn't do "charge" to new cgroup and doesn't do "uncharge"
+ * from old cgroup.
+ */
+static int mem_cgroup_move_account(struct page *page,
+				   unsigned int nr_pages,
+				   struct mem_cgroup *from,
+				   struct mem_cgroup *to)
+{
+	unsigned long flags;
+	int ret;
+
+	VM_BUG_ON(from == to);
+	VM_BUG_ON_PAGE(PageLRU(page), page);
+	/*
+	 * The page is isolated from LRU. So, collapse function
+	 * will not handle this page. But page splitting can happen.
+	 * Do this check under compound_page_lock(). The caller should
+	 * hold it.
+	 */
+	ret = -EBUSY;
+	if (nr_pages > 1 && !PageTransHuge(page))
+		goto out;
+
+	/*
+	 * Prevent mem_cgroup_migrate() from looking at page->mem_cgroup
+	 * of its source page while we change it: page migration takes
+	 * both pages off the LRU, but page cache replacement doesn't.
+	 */
+	if (!trylock_page(page))
+		goto out;
+
+	ret = -EINVAL;
+	if (page->mem_cgroup != from)
+		goto out_unlock;
+
+	spin_lock_irqsave(&from->move_lock, flags);
+
+	if (!PageAnon(page) && page_mapped(page)) {
+		__this_cpu_sub(from->stat->count[MEM_CGROUP_STAT_FILE_MAPPED],
+			       nr_pages);
+		__this_cpu_add(to->stat->count[MEM_CGROUP_STAT_FILE_MAPPED],
+			       nr_pages);
+	}
+
+	if (PageWriteback(page)) {
+		__this_cpu_sub(from->stat->count[MEM_CGROUP_STAT_WRITEBACK],
+			       nr_pages);
+		__this_cpu_add(to->stat->count[MEM_CGROUP_STAT_WRITEBACK],
+			       nr_pages);
+	}
+
+	/*
+	 * It is safe to change page->mem_cgroup here because the page
+	 * is referenced, charged, and isolated - we can't race with
+	 * uncharging, charging, migration, or LRU putback.
+	 */
+
+	/* caller should have done css_get */
+	page->mem_cgroup = to;
+	spin_unlock_irqrestore(&from->move_lock, flags);
+
+	ret = 0;
+
+	local_irq_disable();
+	mem_cgroup_charge_statistics(to, page, nr_pages);
+	memcg_check_events(to, page);
+	mem_cgroup_charge_statistics(from, page, -nr_pages);
+	memcg_check_events(from, page);
+	local_irq_enable();
+out_unlock:
+	unlock_page(page);
+out:
+	return ret;
+}
+
 static enum mc_target_type get_mctgt_type(struct vm_area_struct *vma,
 		unsigned long addr, pte_t ptent, union mc_target *target)
 {
_

Patches currently in -mm which might be from 762976180@qq.com are

origin.patch
linux-next.patch

