From: akpm@linux-foundation.org
Subject: + memcg-fold-__mem_cgroup_move_account-into-caller.patch added to -mm tree
Date: Thu, 03 Feb 2011 15:31:13 -0800
Message-ID: <201102032331.p13NVDWJ031215@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50116 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753061Ab1BCXb2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2011 18:31:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: fold __mem_cgroup_move_account into caller
has been added to the -mm tree.  Its filename is
     memcg-fold-__mem_cgroup_move_account-into-caller.patch

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
Subject: memcg: fold __mem_cgroup_move_account into caller
From: Johannes Weiner <hannes@cmpxchg.org>

It is one logical function, no need to have it split up.

Also, get rid of some checks from the inner function that ensured the
sanity of the outer function.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
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
@@ -2174,33 +2174,49 @@ void mem_cgroup_split_huge_fixup(struct 
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
@@ -2224,40 +2240,16 @@ static void __mem_cgroup_move_account(st
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

