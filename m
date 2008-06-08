From: akpm@linux-foundation.org
Subject: + hugetlb-support-boot-allocate-different-sizes.patch added to -mm tree
Date: Sun, 08 Jun 2008 12:11:50 -0700
Message-ID: <200806081911.m58JBoQq016164@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46543 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754489AbYFHTMX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:12:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, abh@cray.com, agl@us.ibm.com, ak@suse.de, nacc@us.ibm.com


The patch titled
     hugetlb: support boot allocate different sizes
has been added to the -mm tree.  Its filename is
     hugetlb-support-boot-allocate-different-sizes.patch

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
Subject: hugetlb: support boot allocate different sizes
From: Nick Piggin <npiggin@suse.de>

Make some infrastructure changes to allow boot-time allocation of
different hugepage page sizes.

- move all basic hstate initialisation into hugetlb_add_hstate
- create a new function hugetlb_hstate_alloc_pages() to do the
  actual initial page allocations. Call this function early in
  order to allocate giant pages from bootmem.
- Check for multiple hugepages= parameters

Acked-by: Adam Litke <agl@us.ibm.com>
Acked-by: Nishanth Aravamudan <nacc@us.ibm.com>
Acked-by: Andrew Hastings <abh@cray.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   39 ++++++++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-support-boot-allocate-different-sizes mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-support-boot-allocate-different-sizes
+++ a/mm/hugetlb.c
@@ -906,15 +906,10 @@ static void __init gather_bootmem_preall
 	}
 }
 
-static void __init hugetlb_init_one_hstate(struct hstate *h)
+static void __init hugetlb_hstate_alloc_pages(struct hstate *h)
 {
 	unsigned long i;
 
-	for (i = 0; i < MAX_NUMNODES; ++i)
-		INIT_LIST_HEAD(&h->hugepage_freelists[i]);
-
-	h->hugetlb_next_nid = first_node(node_online_map);
-
 	for (i = 0; i < h->max_huge_pages; ++i) {
 		if (h->order >= MAX_ORDER) {
 			if (!alloc_bootmem_huge_page(h))
@@ -922,7 +917,7 @@ static void __init hugetlb_init_one_hsta
 		} else if (!alloc_fresh_huge_page(h))
 			break;
 	}
-	h->max_huge_pages = h->free_huge_pages = h->nr_huge_pages = i;
+	h->max_huge_pages = i;
 }
 
 static void __init hugetlb_init_hstates(void)
@@ -930,7 +925,9 @@ static void __init hugetlb_init_hstates(
 	struct hstate *h;
 
 	for_each_hstate(h) {
-		hugetlb_init_one_hstate(h);
+		/* oversize hugepages were init'ed in early boot */
+		if (h->order < MAX_ORDER)
+			hugetlb_hstate_alloc_pages(h);
 	}
 }
 
@@ -1232,6 +1229,8 @@ module_exit(hugetlb_exit);
 void __init hugetlb_add_hstate(unsigned order)
 {
 	struct hstate *h;
+	unsigned long i;
+
 	if (size_to_hstate(PAGE_SIZE << order)) {
 		printk(KERN_WARNING "hugepagesz= specified twice, ignoring\n");
 		return;
@@ -1241,15 +1240,21 @@ void __init hugetlb_add_hstate(unsigned 
 	h = &hstates[max_hstate++];
 	h->order = order;
 	h->mask = ~((1ULL << (order + PAGE_SHIFT)) - 1);
+	h->nr_huge_pages = 0;
+	h->free_huge_pages = 0;
+	for (i = 0; i < MAX_NUMNODES; ++i)
+		INIT_LIST_HEAD(&h->hugepage_freelists[i]);
+	h->hugetlb_next_nid = first_node(node_online_map);
 	snprintf(h->name, HSTATE_NAME_LEN, "hugepages-%lukB",
 					huge_page_size(h)/1024);
-	hugetlb_init_one_hstate(h);
+
 	parsed_hstate = h;
 }
 
 static int __init hugetlb_setup(char *s)
 {
 	unsigned long *mhp;
+	static unsigned long *last_mhp;
 
 	/*
 	 * !max_hstate means we haven't parsed a hugepagesz= parameter yet,
@@ -1260,9 +1265,25 @@ static int __init hugetlb_setup(char *s)
 	else
 		mhp = &parsed_hstate->max_huge_pages;
 
+	if (mhp == last_mhp) {
+		printk(KERN_WARNING "hugepages= specified twice without "
+			"interleaving hugepagesz=, ignoring\n");
+		return 1;
+	}
+
 	if (sscanf(s, "%lu", mhp) <= 0)
 		*mhp = 0;
 
+	/*
+	 * Global state is always initialized later in hugetlb_init.
+	 * But we need to allocate >= MAX_ORDER hstates here early to still
+	 * use the bootmem allocator.
+	 */
+	if (max_hstate && parsed_hstate->order >= MAX_ORDER)
+		hugetlb_hstate_alloc_pages(parsed_hstate);
+
+	last_mhp = mhp;
+
 	return 1;
 }
 __setup("hugepages=", hugetlb_setup);
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

