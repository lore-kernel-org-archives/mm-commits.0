From: akpm@linux-foundation.org
Subject: + memcg-change-page_cgroup_zoneinfo-signature.patch added to -mm tree
Date: Thu, 03 Feb 2011 15:31:11 -0800
Message-ID: <201102032331.p13NVBr2031211@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41256 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752665Ab1BCXb2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2011 18:31:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: change page_cgroup_zoneinfo signature
has been added to the -mm tree.  Its filename is
     memcg-change-page_cgroup_zoneinfo-signature.patch

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
Subject: memcg: change page_cgroup_zoneinfo signature
From: Johannes Weiner <hannes@cmpxchg.org>

Instead of passing a whole struct page_cgroup to this function, let it
take only what it really needs from it: the struct mem_cgroup and the
page.

This has the advantage that reading pc->mem_cgroup is now done at the same
place where the ordering rules for this pointer are enforced and
explained.

It is also in preparation for removing the pc->page backpointer.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_cgroup.h |   10 ----------
 mm/memcontrol.c             |   17 ++++++++---------
 2 files changed, 8 insertions(+), 19 deletions(-)

diff -puN include/linux/page_cgroup.h~memcg-change-page_cgroup_zoneinfo-signature include/linux/page_cgroup.h
--- a/include/linux/page_cgroup.h~memcg-change-page_cgroup_zoneinfo-signature
+++ a/include/linux/page_cgroup.h
@@ -85,16 +85,6 @@ SETPCGFLAG(Migration, MIGRATION)
 CLEARPCGFLAG(Migration, MIGRATION)
 TESTPCGFLAG(Migration, MIGRATION)
 
-static inline int page_cgroup_nid(struct page_cgroup *pc)
-{
-	return page_to_nid(pc->page);
-}
-
-static inline enum zone_type page_cgroup_zid(struct page_cgroup *pc)
-{
-	return page_zonenum(pc->page);
-}
-
 static inline void lock_page_cgroup(struct page_cgroup *pc)
 {
 	/*
diff -puN mm/memcontrol.c~memcg-change-page_cgroup_zoneinfo-signature mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-change-page_cgroup_zoneinfo-signature
+++ a/mm/memcontrol.c
@@ -364,11 +364,10 @@ struct cgroup_subsys_state *mem_cgroup_c
 }
 
 static struct mem_cgroup_per_zone *
-page_cgroup_zoneinfo(struct page_cgroup *pc)
+page_cgroup_zoneinfo(struct mem_cgroup *mem, struct page *page)
 {
-	struct mem_cgroup *mem = pc->mem_cgroup;
-	int nid = page_cgroup_nid(pc);
-	int zid = page_cgroup_zid(pc);
+	int nid = page_to_nid(page);
+	int zid = page_zonenum(page);
 
 	return mem_cgroup_zoneinfo(mem, nid, zid);
 }
@@ -800,7 +799,7 @@ void mem_cgroup_del_lru_list(struct page
 	 * We don't check PCG_USED bit. It's cleared when the "page" is finally
 	 * removed from global LRU.
 	 */
-	mz = page_cgroup_zoneinfo(pc);
+	mz = page_cgroup_zoneinfo(pc->mem_cgroup, page);
 	/* huge page split is done under lru_lock. so, we have no races. */
 	MEM_CGROUP_ZSTAT(mz, lru) -= 1 << compound_order(page);
 	if (mem_cgroup_is_root(pc->mem_cgroup))
@@ -830,7 +829,7 @@ void mem_cgroup_rotate_lru_list(struct p
 	smp_rmb();
 	if (mem_cgroup_is_root(pc->mem_cgroup))
 		return;
-	mz = page_cgroup_zoneinfo(pc);
+	mz = page_cgroup_zoneinfo(pc->mem_cgroup, page);
 	list_move(&pc->lru, &mz->lists[lru]);
 }
 
@@ -847,7 +846,7 @@ void mem_cgroup_add_lru_list(struct page
 		return;
 	/* Ensure pc->mem_cgroup is visible after reading PCG_USED. */
 	smp_rmb();
-	mz = page_cgroup_zoneinfo(pc);
+	mz = page_cgroup_zoneinfo(pc->mem_cgroup, page);
 	/* huge page split is done under lru_lock. so, we have no races. */
 	MEM_CGROUP_ZSTAT(mz, lru) += 1 << compound_order(page);
 	SetPageCgroupAcctLRU(pc);
@@ -1017,7 +1016,7 @@ mem_cgroup_get_reclaim_stat_from_page(st
 		return NULL;
 	/* Ensure pc->mem_cgroup is visible after reading PCG_USED. */
 	smp_rmb();
-	mz = page_cgroup_zoneinfo(pc);
+	mz = page_cgroup_zoneinfo(pc->mem_cgroup, page);
 	if (!mz)
 		return NULL;
 
@@ -2166,7 +2165,7 @@ void mem_cgroup_split_huge_fixup(struct 
 		 * We hold lru_lock, then, reduce counter directly.
 		 */
 		lru = page_lru(head);
-		mz = page_cgroup_zoneinfo(head_pc);
+		mz = page_cgroup_zoneinfo(head_pc->mem_cgroup, head);
 		MEM_CGROUP_ZSTAT(mz, lru) -= 1;
 	}
 	tail_pc->flags = head_pc->flags & ~PCGF_NOCOPY_AT_SPLIT;
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

