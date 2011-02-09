From: akpm@linux-foundation.org
Subject: + memcg-keep-only-one-charge-cancelling-function.patch added to -mm tree
Date: Wed, 09 Feb 2011 13:35:22 -0800
Message-ID: <201102092135.p19LZNKm023520@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751512Ab1BIVf5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Feb 2011 16:35:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: keep only one charge cancelling function
has been added to the -mm tree.  Its filename is
     memcg-keep-only-one-charge-cancelling-function.patch

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
Subject: memcg: keep only one charge cancelling function
From: Johannes Weiner <hannes@cmpxchg.org>

We have two charge cancelling functions: one takes a page count, the other
a page size.  The second one just divides the parameter by PAGE_SIZE and
then calls the first one.  This is trivial, no need for an extra function.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff -puN mm/memcontrol.c~memcg-keep-only-one-charge-cancelling-function mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-keep-only-one-charge-cancelling-function
+++ a/mm/memcontrol.c
@@ -2020,22 +2020,18 @@ bypass:
  * This function is for that and do uncharge, put css's refcnt.
  * gotten by try_charge().
  */
-static void __mem_cgroup_cancel_charge(struct mem_cgroup *mem,
-							unsigned long count)
+static void mem_cgroup_cancel_charge(struct mem_cgroup *mem,
+				     unsigned int nr_pages)
 {
 	if (!mem_cgroup_is_root(mem)) {
-		res_counter_uncharge(&mem->res, PAGE_SIZE * count);
+		unsigned long bytes = nr_pages * PAGE_SIZE;
+
+		res_counter_uncharge(&mem->res, bytes);
 		if (do_swap_account)
-			res_counter_uncharge(&mem->memsw, PAGE_SIZE * count);
+			res_counter_uncharge(&mem->memsw, bytes);
 	}
 }
 
-static void mem_cgroup_cancel_charge(struct mem_cgroup *mem,
-				     int page_size)
-{
-	__mem_cgroup_cancel_charge(mem, page_size >> PAGE_SHIFT);
-}
-
 /*
  * A helper function to get mem_cgroup from ID. must be called under
  * rcu_read_lock(). The caller must check css_is_removed() or some if
@@ -2094,7 +2090,7 @@ static void __mem_cgroup_commit_charge(s
 	lock_page_cgroup(pc);
 	if (unlikely(PageCgroupUsed(pc))) {
 		unlock_page_cgroup(pc);
-		mem_cgroup_cancel_charge(mem, page_size);
+		mem_cgroup_cancel_charge(mem, nr_pages);
 		return;
 	}
 	/*
@@ -2232,7 +2228,7 @@ static int mem_cgroup_move_account(struc
 	mem_cgroup_charge_statistics(from, PageCgroupCache(pc), -nr_pages);
 	if (uncharge)
 		/* This is not "cancel", but cancel_charge does all we need. */
-		mem_cgroup_cancel_charge(from, charge_size);
+		mem_cgroup_cancel_charge(from, nr_pages);
 
 	/* caller should have done css_get */
 	pc->mem_cgroup = to;
@@ -2297,7 +2293,7 @@ static int mem_cgroup_move_parent(struct
 
 	ret = mem_cgroup_move_account(page, pc, child, parent, true, page_size);
 	if (ret)
-		mem_cgroup_cancel_charge(parent, page_size);
+		mem_cgroup_cancel_charge(parent, page_size >> PAGE_SHIFT);
 
 	if (page_size > PAGE_SIZE)
 		compound_unlock_irqrestore(page, flags);
@@ -2528,7 +2524,7 @@ void mem_cgroup_cancel_charge_swapin(str
 		return;
 	if (!mem)
 		return;
-	mem_cgroup_cancel_charge(mem, PAGE_SIZE);
+	mem_cgroup_cancel_charge(mem, 1);
 }
 
 static void
@@ -4807,7 +4803,7 @@ static void __mem_cgroup_clear_mc(void)
 
 	/* we must uncharge all the leftover precharges from mc.to */
 	if (mc.precharge) {
-		__mem_cgroup_cancel_charge(mc.to, mc.precharge);
+		mem_cgroup_cancel_charge(mc.to, mc.precharge);
 		mc.precharge = 0;
 	}
 	/*
@@ -4815,7 +4811,7 @@ static void __mem_cgroup_clear_mc(void)
 	 * we must uncharge here.
 	 */
 	if (mc.moved_charge) {
-		__mem_cgroup_cancel_charge(mc.from, mc.moved_charge);
+		mem_cgroup_cancel_charge(mc.from, mc.moved_charge);
 		mc.moved_charge = 0;
 	}
 	/* we must fixup refcnts and charges */
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

