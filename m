From: akpm@linux-foundation.org
Subject: - memcg-fix-lru-accounting-for-swapcache-v2.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:49:50 -0800
Message-ID: <200901082249.n08MnoFl029083@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762927AbZAHW64 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:58:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: fix LRU accounting for SwapCache
has been removed from the -mm tree.  Its filename was
     memcg-fix-lru-accounting-for-swapcache-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix LRU accounting for SwapCache
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now, a page can be deleted from SwapCache while do_swap_page(). 
memcg-fix-swap-accounting-leak-v3.patch handles that, but, LRU handling is
still broken.  (above behavior broke assumption of memcg-synchronized-lru
patch.)

This patch is a fix for LRU handling (especially for per-zone counters).
At charging SwapCache,
 - Remove page_cgroup from LRU if it's not used.
 - Add page cgroup to LRU if it's not linked to.

Reported-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   61 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 51 insertions(+), 10 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-lru-accounting-for-swapcache-v2 mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-lru-accounting-for-swapcache-v2
+++ a/mm/memcontrol.c
@@ -331,8 +331,12 @@ void mem_cgroup_del_lru_list(struct page
 		return;
 	pc = lookup_page_cgroup(page);
 	/* can happen while we handle swapcache. */
-	if (list_empty(&pc->lru))
+	if (list_empty(&pc->lru) || !pc->mem_cgroup)
 		return;
+	/*
+	 * We don't check PCG_USED bit. It's cleared when the "page" is finally
+	 * removed from global LRU.
+	 */
 	mz = page_cgroup_zoneinfo(pc);
 	mem = pc->mem_cgroup;
 	MEM_CGROUP_ZSTAT(mz, lru) -= 1;
@@ -379,16 +383,44 @@ void mem_cgroup_add_lru_list(struct page
 	MEM_CGROUP_ZSTAT(mz, lru) += 1;
 	list_add(&pc->lru, &mz->lists[lru]);
 }
+
 /*
- * To add swapcache into LRU. Be careful to all this function.
- * zone->lru_lock shouldn't be held and irq must not be disabled.
- */
-static void mem_cgroup_lru_fixup(struct page *page)
+ * At handling SwapCache, pc->mem_cgroup may be changed while it's linked to
+ * lru because the page may.be reused after it's fully uncharged (because of
+ * SwapCache behavior).To handle that, unlink page_cgroup from LRU when charge
+ * it again. This function is only used to charge SwapCache. It's done under
+ * lock_page and expected that zone->lru_lock is never held.
+ */
+static void mem_cgroup_lru_del_before_commit_swapcache(struct page *page)
+{
+	unsigned long flags;
+	struct zone *zone = page_zone(page);
+	struct page_cgroup *pc = lookup_page_cgroup(page);
+
+	spin_lock_irqsave(&zone->lru_lock, flags);
+	/*
+	 * Forget old LRU when this page_cgroup is *not* used. This Used bit
+	 * is guarded by lock_page() because the page is SwapCache.
+	 */
+	if (!PageCgroupUsed(pc))
+		mem_cgroup_del_lru_list(page, page_lru(page));
+	spin_unlock_irqrestore(&zone->lru_lock, flags);
+}
+
+static void mem_cgroup_lru_add_after_commit_swapcache(struct page *page)
 {
-	if (!isolate_lru_page(page))
-		putback_lru_page(page);
+	unsigned long flags;
+	struct zone *zone = page_zone(page);
+	struct page_cgroup *pc = lookup_page_cgroup(page);
+
+	spin_lock_irqsave(&zone->lru_lock, flags);
+	/* link when the page is linked to LRU but page_cgroup isn't */
+	if (PageLRU(page) && list_empty(&pc->lru))
+		mem_cgroup_add_lru_list(page, page_lru(page));
+	spin_unlock_irqrestore(&zone->lru_lock, flags);
 }
 
+
 void mem_cgroup_move_lists(struct page *page,
 			   enum lru_list from, enum lru_list to)
 {
@@ -1168,8 +1200,11 @@ int mem_cgroup_cache_charge_swapin(struc
 					mem = NULL; /* charge to current */
 			}
 		}
+		/* SwapCache may be still linked to LRU now. */
+		mem_cgroup_lru_del_before_commit_swapcache(page);
 		ret = mem_cgroup_charge_common(page, mm, mask,
 				MEM_CGROUP_CHARGE_TYPE_SHMEM, mem);
+		mem_cgroup_lru_add_after_commit_swapcache(page);
 		/* drop extra refcnt from tryget */
 		if (mem)
 			css_put(&mem->css);
@@ -1185,8 +1220,6 @@ int mem_cgroup_cache_charge_swapin(struc
 	}
 	if (!locked)
 		unlock_page(page);
-	/* add this page(page_cgroup) to the LRU we want. */
-	mem_cgroup_lru_fixup(page);
 
 	return ret;
 }
@@ -1201,7 +1234,9 @@ void mem_cgroup_commit_charge_swapin(str
 	if (!ptr)
 		return;
 	pc = lookup_page_cgroup(page);
+	mem_cgroup_lru_del_before_commit_swapcache(page);
 	__mem_cgroup_commit_charge(ptr, pc, MEM_CGROUP_CHARGE_TYPE_MAPPED);
+	mem_cgroup_lru_add_after_commit_swapcache(page);
 	/*
 	 * Now swap is on-memory. This means this page may be
 	 * counted both as mem and swap....double count.
@@ -1220,7 +1255,7 @@ void mem_cgroup_commit_charge_swapin(str
 
 	}
 	/* add this page(page_cgroup) to the LRU we want. */
-	mem_cgroup_lru_fixup(page);
+
 }
 
 void mem_cgroup_cancel_charge_swapin(struct mem_cgroup *mem)
@@ -1288,6 +1323,12 @@ __mem_cgroup_uncharge_common(struct page
 
 	mem_cgroup_charge_statistics(mem, pc, false);
 	ClearPageCgroupUsed(pc);
+	/*
+	 * pc->mem_cgroup is not cleared here. It will be accessed when it's
+	 * freed from LRU. This is safe because uncharged page is expected not
+	 * to be reused (freed soon). Exception is SwapCache, it's handled by
+	 * special functions.
+	 */
 
 	mz = page_cgroup_zoneinfo(pc);
 	unlock_page_cgroup(pc);
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch

