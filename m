From: akpm@linux-foundation.org
Subject: - memcg-fix-swap-accounting-leak-v3.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:49:43 -0800
Message-ID: <200901082249.n08MnhVV028965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763043AbZAHWuY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:50:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, hugh@veritas.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: fix swap accounting leak
has been removed from the -mm tree.  Its filename was
     memcg-fix-swap-accounting-leak-v3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix swap accounting leak
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Fix swapin charge operation of memcg.

Now, memcg has hooks to swap-out operation and checks SwapCache is really
unused or not.  That check depends on contents of struct page.  I.e.  If
PageAnon(page) && page_mapped(page), the page is recoginized as
still-in-use.

Now, reuse_swap_page() calles delete_from_swap_cache() before establishment
of any rmap. Then, in followinig sequence

	(Page fault with WRITE)
	try_charge() (charge += PAGESIZE)
	commit_charge() (Check page_cgroup is used or not..)
	reuse_swap_page()
		-> delete_from_swapcache()
			-> mem_cgroup_uncharge_swapcache() (charge -= PAGESIZE)
	......
New charge is uncharged soon....
To avoid this,  move commit_charge() after page_mapcount() goes up to 1.
By this,

	try_charge()		(usage += PAGESIZE)
	reuse_swap_page()	(may usage -= PAGESIZE if PCG_USED is set)
	commit_charge()		(If page_cgroup is not marked as PCG_USED,
				 add new charge.)
Accounting will be correct.

Changelog (v2) -> (v3)
  - fixed invalid charge to swp_entry==0.
  - updated documentation.
Changelog (v1) -> (v2)
  - fixed comment.

[nishimura@mxp.nes.nec.co.jp: swap accounting leak doc fix]
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com> 
Tested-by: Balbir Singh <balbir@linux.vnet.ibm.com> 
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/controllers/memcg_test.txt |   41 ++++++++++++++++++---
 mm/memcontrol.c                          |    7 ++-
 mm/memory.c                              |   11 +++--
 3 files changed, 46 insertions(+), 13 deletions(-)

diff -puN Documentation/controllers/memcg_test.txt~memcg-fix-swap-accounting-leak-v3 Documentation/controllers/memcg_test.txt
--- a/Documentation/controllers/memcg_test.txt~memcg-fix-swap-accounting-leak-v3
+++ a/Documentation/controllers/memcg_test.txt
@@ -1,6 +1,6 @@
 Memory Resource Controller(Memcg)  Implementation Memo.
-Last Updated: 2008/12/10
-Base Kernel Version: based on 2.6.28-rc7-mm.
+Last Updated: 2008/12/15
+Base Kernel Version: based on 2.6.28-rc8-mm.
 
 Because VM is getting complex (one of reasons is memcg...), memcg's behavior
 is complex. This is a document for memcg's internal behavior.
@@ -111,9 +111,40 @@ Under below explanation, we assume CONFI
 	(b) If the SwapCache has been mapped by processes, it has been
 	    charged already.
 
-	In case (a), we charge it. In case (b), we don't charge it.
-	(But racy state between (a) and (b) exists. We do check it.)
-	At charging, a charge recorded in swap_cgroup is moved to page_cgroup.
+	This swap-in is one of the most complicated work. In do_swap_page(),
+	following events occur when pte is unchanged.
+
+	(1) the page (SwapCache) is looked up.
+	(2) lock_page()
+	(3) try_charge_swapin()
+	(4) reuse_swap_page() (may call delete_swap_cache())
+	(5) commit_charge_swapin()
+	(6) swap_free().
+
+	Considering following situation for example.
+
+	(A) The page has not been charged before (2) and reuse_swap_page()
+	    doesn't call delete_from_swap_cache().
+	(B) The page has not been charged before (2) and reuse_swap_page()
+	    calls delete_from_swap_cache().
+	(C) The page has been charged before (2) and reuse_swap_page() doesn't
+	    call delete_from_swap_cache().
+	(D) The page has been charged before (2) and reuse_swap_page() calls
+	    delete_from_swap_cache().
+
+	    memory.usage/memsw.usage changes to this page/swp_entry will be
+	 Case          (A)      (B)       (C)     (D)
+         Event
+       Before (2)     0/ 1     0/ 1      1/ 1    1/ 1
+          ===========================================
+          (3)        +1/+1    +1/+1     +1/+1   +1/+1
+          (4)          -       0/ 0       -     -1/ 0
+          (5)         0/-1     0/ 0     -1/-1    0/ 0
+          (6)          -       0/-1       -      0/-1
+          ===========================================
+       Result         1/ 1     1/ 1      1/ 1    1/ 1
+
+       In any cases, charges to this page should be 1/ 1.
 
 	4.2 Swap-out.
 	At swap-out, typical state transition is below.
diff -puN mm/memcontrol.c~memcg-fix-swap-accounting-leak-v3 mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-swap-accounting-leak-v3
+++ a/mm/memcontrol.c
@@ -1169,10 +1169,11 @@ void mem_cgroup_commit_charge_swapin(str
 	/*
 	 * Now swap is on-memory. This means this page may be
 	 * counted both as mem and swap....double count.
-	 * Fix it by uncharging from memsw. This SwapCache is stable
-	 * because we're still under lock_page().
+	 * Fix it by uncharging from memsw. Basically, this SwapCache is stable
+	 * under lock_page(). But in do_swap_page()::memory.c, reuse_swap_page()
+	 * may call delete_from_swap_cache() before reach here.
 	 */
-	if (do_swap_account) {
+	if (do_swap_account && PageSwapCache(page)) {
 		swp_entry_t ent = {.val = page_private(page)};
 		struct mem_cgroup *memcg;
 		memcg = swap_cgroup_record(ent, NULL);
diff -puN mm/memory.c~memcg-fix-swap-accounting-leak-v3 mm/memory.c
--- a/mm/memory.c~memcg-fix-swap-accounting-leak-v3
+++ a/mm/memory.c
@@ -2457,22 +2457,23 @@ static int do_swap_page(struct mm_struct
 	 * while the page is counted on swap but not yet in mapcount i.e.
 	 * before page_add_anon_rmap() and swap_free(); try_to_free_swap()
 	 * must be called after the swap_free(), or it will never succeed.
-	 * And mem_cgroup_commit_charge_swapin(), which uses the swp_entry
-	 * in page->private, must be called before reuse_swap_page(),
-	 * which may delete_from_swap_cache().
+	 * Because delete_from_swap_page() may be called by reuse_swap_page(),
+	 * mem_cgroup_commit_charge_swapin() may not be able to find swp_entry
+	 * in page->private. In this case, a record in swap_cgroup  is silently
+	 * discarded at swap_free().
 	 */
 
-	mem_cgroup_commit_charge_swapin(page, ptr);
 	inc_mm_counter(mm, anon_rss);
 	pte = mk_pte(page, vma->vm_page_prot);
 	if (write_access && reuse_swap_page(page)) {
 		pte = maybe_mkwrite(pte_mkdirty(pte), vma);
 		write_access = 0;
 	}
