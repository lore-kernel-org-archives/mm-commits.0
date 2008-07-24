From: akpm@linux-foundation.org
Subject: - hugetlb-abstract-numa-round-robin-selection.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:23:07 -0700
Message-ID: <200807242323.m6ONN7IL010628@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53353 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754352AbYGXXXp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:23:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, agl@us.ibm.com, ak@suse.de, nacc@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb: abstract numa round robin selection
has been removed from the -mm tree.  Its filename was
     hugetlb-abstract-numa-round-robin-selection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: abstract numa round robin selection
From: Nick Piggin <npiggin@suse.de>

Need this as a separate function for a future patch.

No behaviour change.

Acked-by: Adam Litke <agl@us.ibm.com>
Acked-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-abstract-numa-round-robin-selection mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-abstract-numa-round-robin-selection
+++ a/mm/hugetlb.c
@@ -565,6 +565,27 @@ static struct page *alloc_fresh_huge_pag
 	return page;
 }
 
+/*
+ * Use a helper variable to find the next node and then
+ * copy it back to hugetlb_next_nid afterwards:
+ * otherwise there's a window in which a racer might
+ * pass invalid nid MAX_NUMNODES to alloc_pages_node.
+ * But we don't need to use a spin_lock here: it really
+ * doesn't matter if occasionally a racer chooses the
+ * same nid as we do.  Move nid forward in the mask even
+ * if we just successfully allocated a hugepage so that
+ * the next caller gets hugepages on the next node.
+ */
+static int hstate_next_node(struct hstate *h)
+{
+	int next_nid;
+	next_nid = next_node(h->hugetlb_next_nid, node_online_map);
+	if (next_nid == MAX_NUMNODES)
+		next_nid = first_node(node_online_map);
+	h->hugetlb_next_nid = next_nid;
+	return next_nid;
+}
+
 static int alloc_fresh_huge_page(struct hstate *h)
 {
 	struct page *page;
@@ -578,21 +599,7 @@ static int alloc_fresh_huge_page(struct 
 		page = alloc_fresh_huge_page_node(h, h->hugetlb_next_nid);
 		if (page)
 			ret = 1;
-		/*
-		 * Use a helper variable to find the next node and then
-		 * copy it back to hugetlb_next_nid afterwards:
-		 * otherwise there's a window in which a racer might
-		 * pass invalid nid MAX_NUMNODES to alloc_pages_node.
-		 * But we don't need to use a spin_lock here: it really
-		 * doesn't matter if occasionally a racer chooses the
-		 * same nid as we do.  Move nid forward in the mask even
-		 * if we just successfully allocated a hugepage so that
-		 * the next caller gets hugepages on the next node.
-		 */
-		next_nid = next_node(h->hugetlb_next_nid, node_online_map);
-		if (next_nid == MAX_NUMNODES)
-			next_nid = first_node(node_online_map);
-		h->hugetlb_next_nid = next_nid;
+		next_nid = hstate_next_node(h);
 	} while (!page && h->hugetlb_next_nid != start_nid);
 
 	if (ret)
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
x86-implement-pte_special.patch
x86-implement-pte_special-fix.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
x86-support-1gb-hugepages-with-get_user_pages_lockless.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-speculative-page-references-fix.patch
mm-speculative-page-references-fix-add_to_page_cache.patch
mm-speculative-page-references-fix-add_to_page_cache-fix.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
powerpc-implement-pte_special-update.patch
powerpc-lockless-get_user_pages.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
vmscan-move-isolate_lru_page-to-vmscanc-fix.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mlock-mlocked-pages-are-unevictable-fix-fix-munlock-page-table-walk-now-requires-mm.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

