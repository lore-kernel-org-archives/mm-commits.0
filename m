From: akpm@linux-foundation.org
Subject: + memcg-convert-per-cpu-stock-from-bytes-to-page-granularity.patch added to -mm tree
Date: Wed, 09 Feb 2011 13:35:25 -0800
Message-ID: <201102092135.p19LZPJu023526@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53934 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754958Ab1BIVf7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Feb 2011 16:35:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: convert per-cpu stock from bytes to page granularity
has been added to the -mm tree.  Its filename is
     memcg-convert-per-cpu-stock-from-bytes-to-page-granularity.patch

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
Subject: memcg: convert per-cpu stock from bytes to page granularity
From: Johannes Weiner <hannes@cmpxchg.org>

We never keep subpage quantities in the per-cpu stock.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff -puN mm/memcontrol.c~memcg-convert-per-cpu-stock-from-bytes-to-page-granularity mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-convert-per-cpu-stock-from-bytes-to-page-granularity
+++ a/mm/memcontrol.c
@@ -1640,14 +1640,14 @@ EXPORT_SYMBOL(mem_cgroup_update_page_sta
 #define CHARGE_SIZE	(32 * PAGE_SIZE)
 struct memcg_stock_pcp {
 	struct mem_cgroup *cached; /* this never be root cgroup */
-	int charge;
+	unsigned int nr_pages;
 	struct work_struct work;
 };
 static DEFINE_PER_CPU(struct memcg_stock_pcp, memcg_stock);
 static atomic_t memcg_drain_count;
 
 /*
- * Try to consume stocked charge on this cpu. If success, PAGE_SIZE is consumed
+ * Try to consume stocked charge on this cpu. If success, one page is consumed
  * from local stock and true is returned. If the stock is 0 or charges from a
  * cgroup which is not current target, returns false. This stock will be
  * refilled.
@@ -1658,8 +1658,8 @@ static bool consume_stock(struct mem_cgr
 	bool ret = true;
 
 	stock = &get_cpu_var(memcg_stock);
-	if (mem == stock->cached && stock->charge)
-		stock->charge -= PAGE_SIZE;
+	if (mem == stock->cached && stock->nr_pages)
+		stock->nr_pages--;
 	else /* need to call res_counter_charge */
 		ret = false;
 	put_cpu_var(memcg_stock);
@@ -1673,13 +1673,15 @@ static void drain_stock(struct memcg_sto
 {
 	struct mem_cgroup *old = stock->cached;
 
-	if (stock->charge) {
-		res_counter_uncharge(&old->res, stock->charge);
+	if (stock->nr_pages) {
+		unsigned long bytes = stock->nr_pages * PAGE_SIZE;
+
+		res_counter_uncharge(&old->res, bytes);
 		if (do_swap_account)
-			res_counter_uncharge(&old->memsw, stock->charge);
+			res_counter_uncharge(&old->memsw, bytes);
+		stock->nr_pages = 0;
 	}
 	stock->cached = NULL;
-	stock->charge = 0;
 }
 
 /*
@@ -1696,7 +1698,7 @@ static void drain_local_stock(struct wor
  * Cache charges(val) which is from res_counter, to local per_cpu area.
  * This will be consumed by consume_stock() function, later.
  */
-static void refill_stock(struct mem_cgroup *mem, int val)
+static void refill_stock(struct mem_cgroup *mem, unsigned int nr_pages)
 {
 	struct memcg_stock_pcp *stock = &get_cpu_var(memcg_stock);
 
@@ -1704,7 +1706,7 @@ static void refill_stock(struct mem_cgro
 		drain_stock(stock);
 		stock->cached = mem;
 	}
-	stock->charge += val;
+	stock->nr_pages += nr_pages;
 	put_cpu_var(memcg_stock);
 }
 
@@ -2002,7 +2004,7 @@ again:
 	} while (ret != CHARGE_OK);
 
 	if (csize > page_size)
-		refill_stock(mem, csize - page_size);
+		refill_stock(mem, (csize - page_size) >> PAGE_SHIFT);
 	css_put(&mem->css);
 done:
 	*memcg = mem;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

vmscan-fix-zone-shrinking-exit-when-scan-work-is-done.patch
mm-introduce-delete_from_page_cache.patch
mm-hugetlbfs-change-remove_from_page_cache.patch
mm-shmem-change-remove_from_page_cache.patch
mm-truncate-change-remove_from_page_cache.patch
mm-good-bye-remove_from_page_cache.patch
mm-change-__remove_from_page_cache.patch
mm-batch-free-pcp-list-if-possible.patch
mm-batch-free-pcp-list-if-possible-fix.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path-fix.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-fix-ugly-initialization-of-return-value-is-in-caller.patch
memcg-soft-limit-reclaim-should-end-at-limit-not-below.patch
memcg-simplify-the-way-memory-limits-are-checked.patch
memcg-remove-unused-page-flag-bitfield-defines.patch
memcg-remove-impossible-conditional-when-committing.patch
memcg-remove-null-check-from-lookup_page_cgroup-result.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update.patch
memcg-no-uncharged-pages-reach-page_cgroup_zoneinfo.patch
memcg-change-page_cgroup_zoneinfo-signature.patch
memcg-fold-__mem_cgroup_move_account-into-caller.patch
memcg-condense-page_cgroup-to-page-lookup-points.patch
memcg-remove-direct-page_cgroup-to-page-pointer.patch
memcg-remove-direct-page_cgroup-to-page-pointer-fix.patch
memcg-remove-direct-page_cgroup-to-page-pointer-fix-fix.patch
memcg-keep-only-one-charge-cancelling-function.patch
memcg-convert-per-cpu-stock-from-bytes-to-page-granularity.patch
memcg-convert-uncharge-batching-from-bytes-to-page-granularity.patch
memcg-unify-charge-uncharge-quantities-to-units-of-pages.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch

