From: akpm@linux-foundation.org
Subject: + hugetlb-abstract-numa-round-robin-selection.patch added to -mm tree
Date: Sun, 08 Jun 2008 12:11:40 -0700
Message-ID: <200806081911.m58JBe31016146@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57339 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754490AbYFHTML (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:12:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, agl@us.ibm.com, ak@suse.de, nacc@us.ibm.com


The patch titled
     hugetlb: abstract numa round robin selection
has been added to the -mm tree.  Its filename is
     hugetlb-abstract-numa-round-robin-selection.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -383,6 +383,27 @@ static struct page *alloc_fresh_huge_pag
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
@@ -396,21 +417,7 @@ static int alloc_fresh_huge_page(struct 
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

hugetlb-fix-lockdep-error.patch
vt-fix-vc_resize-locking.patch
linux-next.patch
spufs-convert-nopfn-to-fault.patch
mspec-convert-nopfn-to-fault.patch
mspec-convert-nopfn-to-fault-fix.patch
mm-remove-nopfn.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-build-fix.patch
hugetlb-factor-out-prep_new_huge_page.patch
hugetlb-modular-state-for-hugetlb-page-size.patch
hugetlb-modular-state-for-hugetlb-page-size-checkpatch-fixes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes.patch
hugetlb-multiple-hstates-for-multiple-page-sizes-checkpatch-fixes.patch
hugetlbfs-per-mount-huge-page-sizes.patch
hugetlb-new-sysfs-interface.patch
hugetlb-abstract-numa-round-robin-selection.patch
mm-introduce-non-panic-alloc_bootmem.patch
mm-export-prep_compound_page-to-mm.patch
hugetlb-support-larger-than-max_order.patch
hugetlb-support-boot-allocate-different-sizes.patch
hugetlb-printk-cleanup.patch
hugetlb-introduce-pud_huge.patch
x86-support-gb-hugepages-on-64-bit.patch
x86-add-hugepagesz-option-on-64-bit.patch
hugetlb-override-default-huge-page-size.patch
hugetlb-allow-arch-overried-hugepage-allocation.patch
powerpc-function-to-allocate-gigantic-hugepages.patch
powerpc-scan-device-tree-for-gigantic-pages.patch
powerpc-define-support-for-16g-hugepages.patch
fs-check-for-statfs-overflow.patch
powerpc-support-multiple-hugepage-sizes.patch
x86-implement-pte_special.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
mm-readahead-scan-lockless.patch
radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
mm-speculative-page-references.patch
mm-lockless-pagecache.patch
mm-spinlock-tree_lock.patch
powerpc-implement-pte_special.patch
powerpc-lockless-get_user_pages_fast.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
vmscan-mlocked-pages-are-non-reclaimable.patch
vmscan-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-mlocked-pages-statistics.patch
reiser4.patch
likeliness-accounting-change-and-cleanup.patch

