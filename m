From: akpm@linux-foundation.org
Subject: [merged] memcg-fold-__mem_cgroup_move_account-into-caller.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:24:45 -0700
Message-ID: <201103250724.p2P7OdpD025878@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44443 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933818Ab1CYHYt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:24:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: fold __mem_cgroup_move_account into caller
has been removed from the -mm tree.  Its filename was
     memcg-fold-__mem_cgroup_move_account-into-caller.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fold __mem_cgroup_move_account into caller
From: Johannes Weiner <hannes@cmpxchg.org>

It is one logical function, no need to have it split up.

Also, get rid of some checks from the inner function that ensured the
sanity of the outer function.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_cgroup.h |    5 --
 mm/memcontrol.c             |   66 ++++++++++++++--------------------
 2 files changed, 29 insertions(+), 42 deletions(-)

diff -puN include/linux/page_cgroup.h~memcg-fold-__mem_cgroup_move_account-into-caller include/linux/page_cgroup.h
--- a/include/linux/page_cgroup.h~memcg-fold-__mem_cgroup_move_account-into-caller
+++ a/include/linux/page_cgroup.h
@@ -99,11 +99,6 @@ static inline void unlock_page_cgroup(st
 	bit_spin_unlock(PCG_LOCK, &pc->flags);
 }
 
-static inline int page_is_cgroup_locked(struct page_cgroup *pc)
-{
-	return bit_spin_is_locked(PCG_LOCK, &pc->flags);
-}
-
 static inline void move_lock_page_cgroup(struct page_cgroup *pc,
 	unsigned long *flags)
 {
diff -puN mm/memcontrol.c~memcg-fold-__mem_cgroup_move_account-into-caller mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fold-__mem_cgroup_move_account-into-caller
+++ a/mm/memcontrol.c
@@ -2200,33 +2200,49 @@ void mem_cgroup_split_huge_fixup(struct 
 #endif
 
 /**
- * __mem_cgroup_move_account - move account of the page
+ * mem_cgroup_move_account - move account of the page
  * @pc:	page_cgroup of the page.
  * @from: mem_cgroup which the page is moved from.
  * @to:	mem_cgroup which the page is moved to. @from != @to.
  * @uncharge: whether we should call uncharge and css_put against @from.
+ * @charge_size: number of bytes to charge (regular or huge page)
  *
  * The caller must confirm following.
  * - page is not on LRU (isolate_page() is useful.)
- * - the pc is locked, used, and ->mem_cgroup points to @from.
+ * - compound_lock is held when charge_size > PAGE_SIZE
  *
  * This function doesn't do "charge" nor css_get to new cgroup. It should be
  * done by a caller(__mem_cgroup_try_charge would be usefull). If @uncharge is
  * true, this function does "uncharge" from old cgroup, but it doesn't if
  * @uncharge is false, so a caller should do "uncharge".
  */
-
-static void __mem_cgroup_move_account(struct page_cgroup *pc,
-	struct mem_cgroup *from, struct mem_cgroup *to, bool uncharge,
-	int charge_size)
+static int mem_cgroup_move_account(struct page_cgroup *pc,
+				   struct mem_cgroup *from, struct mem_cgroup *to,
+				   bool uncharge, int charge_size)
 {
 	int nr_pages = charge_size >> PAGE_SHIFT;
+	unsigned long flags;
+	int ret;
 
 	VM_BUG_ON(from == to);
 	VM_BUG_ON(PageLRU(pc->page));
-	VM_BUG_ON(!page_is_cgroup_locked(pc));
-	VM_BUG_ON(!PageCgroupUsed(pc));
-	VM_BUG_ON(pc->mem_cgroup != from);
+	/*
+	 * The page is isolated from LRU. So, collapse function
+	 * will not handle this page. But page splitting can happen.
+	 * Do this check under compound_page_lock(). The caller should
+	 * hold it.
+	 */
+	ret = -EBUSY;
+	if (charge_size > PAGE_SIZE && !PageTransHuge(pc->page))
+		goto out;
+
+	lock_page_cgroup(pc);
+
+	ret = -EINVAL;
+	if (!PageCgroupUsed(pc) || pc->mem_cgroup != from)
+		goto unlock;
+
+	move_lock_page_cgroup(pc, &flags);
 
 	if (PageCgroupFileMapped(pc)) {
 		/* Update mapped_file data for mem_cgroup */
@@ -2250,40 +2266,16 @@ static void __mem_cgroup_move_account(st
 	 * garanteed that "to" is never removed. So, we don't check rmdir
 	 * status here.
 	 */
-}
-
-/*
- * check whether the @pc is valid for moving account and call
- * __mem_cgroup_move_account()
- */
-static int mem_cgroup_move_account(struct page_cgroup *pc,
-		struct mem_cgroup *from, struct mem_cgroup *to,
-		bool uncharge, int charge_size)
-{
-	int ret = -EINVAL;
-	unsigned long flags;
-	/*
-	 * The page is isolated from LRU. So, collapse function
-	 * will not handle this page. But page splitting can happen.
-	 * Do this check under compound_page_lock(). The caller should
-	 * hold it.
-	 */
-	if ((charge_size > PAGE_SIZE) && !PageTransHuge(pc->page))
-		return -EBUSY;
-
-	lock_page_cgroup(pc);
-	if (PageCgroupUsed(pc) && pc->mem_cgroup == from) {
-		move_lock_page_cgroup(pc, &flags);
-		__mem_cgroup_move_account(pc, from, to, uncharge, charge_size);
-		move_unlock_page_cgroup(pc, &flags);
-		ret = 0;
-	}
+	move_unlock_page_cgroup(pc, &flags);
+	ret = 0;
+unlock:
 	unlock_page_cgroup(pc);
 	/*
 	 * check events
 	 */
 	memcg_check_events(to, pc->page);
 	memcg_check_events(from, pc->page);
+out:
 	return ret;
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-add-vm-counters-for-transparent-hugepages.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-add-dirty-limiting-routines.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-make-background-writeback-memcg-aware.patch

