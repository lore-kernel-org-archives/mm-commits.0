From: akpm@linux-foundation.org
Subject: [merged]
 memcg-thp-swap-make-mem_cgroup_swapout-support-thp.patch removed from -mm
 tree
Date: Thu, 07 Sep 2017 11:40:07 -0700
Message-ID: <20170907184007.mFH9oT0Mw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57292 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755818AbdIGSkI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:40:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, axboe@kernel.dk, dan.j.williams@intel.com, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, minchan@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com, ross.zwisler@intel.com, shli@kernel.org, vishal.l.verma@intel.com, ying.huang@intel.com


The patch titled
     Subject: memcg, THP, swap: make mem_cgroup_swapout() support THP
has been removed from the -mm tree.  Its filename was
     memcg-thp-swap-make-mem_cgroup_swapout-support-thp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: memcg, THP, swap: make mem_cgroup_swapout() support THP

This patch makes mem_cgroup_swapout() works for the transparent huge page
(THP).  Which will move the memory cgroup charge from memory to swap for a
THP.

This will be used for the THP swap support.  Where a THP may be swapped
out as a whole to a set of (HPAGE_PMD_NR) continuous swap slots on the
swap device.

Link: http://lkml.kernel.org/r/20170724051840.2309-11-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ross Zwisler <ross.zwisler@intel.com> [for brd.c, zram_drv.c, pmem.c]
Cc: Shaohua Li <shli@kernel.org>
Cc: Vishal L Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff -puN mm/memcontrol.c~memcg-thp-swap-make-mem_cgroup_swapout-support-thp mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-thp-swap-make-mem_cgroup_swapout-support-thp
+++ a/mm/memcontrol.c
@@ -4654,8 +4654,8 @@ static enum mc_target_type get_mctgt_typ
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /*
- * We don't consider swapping or file mapped pages because THP does not
- * support them for now.
+ * We don't consider PMD mapped swapping or file mapped pages because THP does
+ * not support them for now.
  * Caller should make sure that pmd_trans_huge(pmd) is true.
  */
 static enum mc_target_type get_mctgt_type_thp(struct vm_area_struct *vma,
@@ -5913,6 +5913,7 @@ static struct mem_cgroup *mem_cgroup_id_
 void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
 {
 	struct mem_cgroup *memcg, *swap_memcg;
+	unsigned int nr_entries;
 	unsigned short oldid;
 
 	VM_BUG_ON_PAGE(PageLRU(page), page);
@@ -5933,19 +5934,24 @@ void mem_cgroup_swapout(struct page *pag
 	 * ancestor for the swap instead and transfer the memory+swap charge.
 	 */
 	swap_memcg = mem_cgroup_id_get_online(memcg);
-	oldid = swap_cgroup_record(entry, mem_cgroup_id(swap_memcg), 1);
+	nr_entries = hpage_nr_pages(page);
+	/* Get references for the tail pages, too */
+	if (nr_entries > 1)
+		mem_cgroup_id_get_many(swap_memcg, nr_entries - 1);
+	oldid = swap_cgroup_record(entry, mem_cgroup_id(swap_memcg),
+				   nr_entries);
 	VM_BUG_ON_PAGE(oldid, page);
-	mem_cgroup_swap_statistics(swap_memcg, 1);
+	mem_cgroup_swap_statistics(swap_memcg, nr_entries);
 
 	page->mem_cgroup = NULL;
 
 	if (!mem_cgroup_is_root(memcg))
-		page_counter_uncharge(&memcg->memory, 1);
+		page_counter_uncharge(&memcg->memory, nr_entries);
 
 	if (memcg != swap_memcg) {
 		if (!mem_cgroup_is_root(swap_memcg))
-			page_counter_charge(&swap_memcg->memsw, 1);
-		page_counter_uncharge(&memcg->memsw, 1);
+			page_counter_charge(&swap_memcg->memsw, nr_entries);
+		page_counter_uncharge(&memcg->memsw, nr_entries);
 	}
 
 	/*
@@ -5955,7 +5961,8 @@ void mem_cgroup_swapout(struct page *pag
 	 * only synchronisation we have for udpating the per-CPU variables.
 	 */
 	VM_BUG_ON(!irqs_disabled());
-	mem_cgroup_charge_statistics(memcg, page, false, -1);
+	mem_cgroup_charge_statistics(memcg, page, PageTransHuge(page),
+				     -nr_entries);
 	memcg_check_events(memcg, page);
 
 	if (!mem_cgroup_is_root(memcg))
_

Patches currently in -mm which might be from ying.huang@intel.com are


