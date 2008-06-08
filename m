From: akpm@linux-foundation.org
Subject: + hugetlb-support-larger-than-max_order.patch added to -mm tree
Date: Sun, 08 Jun 2008 12:11:47 -0700
Message-ID: <200806081911.m58JBlbl016158@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44498 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754216AbYFHTLy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:11:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, abh@cray.com, ak@suse.de


The patch titled
     hugetlb: support larger than MAX_ORDER
has been added to the -mm tree.  Its filename is
     hugetlb-support-larger-than-max_order.patch

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
Subject: hugetlb: support larger than MAX_ORDER
From: Nick Piggin <npiggin@suse.de>

This is needed on x86-64 to handle GB pages in hugetlbfs, because it is
not practical to enlarge MAX_ORDER to 1GB.

Instead the 1GB pages are only allocated at boot using the bootmem
allocator using the hugepages=...  option.

These 1G bootmem pages are never freed.  In theory it would be possible to
implement that with some complications, but since it would be a one-way
street (>= MAX_ORDER pages cannot be allocated later) I decided not to
currently.

The >= MAX_ORDER code is not ifdef'ed per architecture.  It is not very
big and the ifdef uglyness seemed not be worth it.

Known problems: /proc/meminfo and "free" do not display the memory
allocated for gb pages in "Total".  This is a little confusing for the
user.

Acked-by: Andrew Hastings <abh@cray.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   83 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 81 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-support-larger-than-max_order mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-support-larger-than-max_order
+++ a/mm/hugetlb.c
@@ -14,6 +14,7 @@
 #include <linux/mempolicy.h>
 #include <linux/cpuset.h>
 #include <linux/mutex.h>
+#include <linux/bootmem.h>
 #include <linux/sysfs.h>
 
 #include <asm/page.h>
@@ -307,7 +308,7 @@ static void free_huge_page(struct page *
 	INIT_LIST_HEAD(&page->lru);
 
 	spin_lock(&hugetlb_lock);
-	if (h->surplus_huge_pages_node[nid]) {
+	if (h->surplus_huge_pages_node[nid] && huge_page_order(h) < MAX_ORDER) {
 		update_and_free_page(h, page);
 		h->surplus_huge_pages--;
 		h->surplus_huge_pages_node[nid]--;
@@ -368,6 +369,9 @@ static struct page *alloc_fresh_huge_pag
 {
 	struct page *page;
 
+	if (h->order >= MAX_ORDER)
+		return NULL;
+
 	page = alloc_pages_node(nid,
 		htlb_alloc_mask|__GFP_COMP|__GFP_THISNODE|
 						__GFP_REPEAT|__GFP_NOWARN,
@@ -434,6 +438,9 @@ static struct page *alloc_buddy_huge_pag
 	struct page *page;
 	unsigned int nid;
 
+	if (h->order >= MAX_ORDER)
+		return NULL;
+
 	/*
 	 * Assume we will successfully allocate the surplus page to
 	 * prevent racing processes from causing the surplus to exceed
@@ -610,6 +617,10 @@ static void return_unused_surplus_pages(
 	/* Uncommit the reservation */
 	h->resv_huge_pages -= unused_resv_pages;
 
+	/* Cannot return gigantic pages currently */
+	if (h->order >= MAX_ORDER)
+		return;
+
 	nr_pages = min(unused_resv_pages, h->surplus_huge_pages);
 
 	while (remaining_iterations-- && nr_pages) {
@@ -838,6 +849,63 @@ static struct page *alloc_huge_page(stru
 	return page;
 }
 
+static __initdata LIST_HEAD(huge_boot_pages);
+
+struct huge_bootmem_page {
+	struct list_head list;
+	struct hstate *hstate;
+};
+
+static int __init alloc_bootmem_huge_page(struct hstate *h)
+{
+	struct huge_bootmem_page *m;
+	int nr_nodes = nodes_weight(node_online_map);
+
+	while (nr_nodes) {
+		void *addr;
+
+		addr = __alloc_bootmem_node_nopanic(
+				NODE_DATA(h->hugetlb_next_nid),
+				huge_page_size(h), huge_page_size(h), 0);
+
+		if (addr) {
+			/*
+			 * Use the beginning of the huge page to store the
+			 * huge_bootmem_page struct (until gather_bootmem
+			 * puts them into the mem_map).
+			 */
+			m = addr;
+			if (m)
+				goto found;
+		}
+		hstate_next_node(h);
+		nr_nodes--;
+	}
+	return 0;
+
+found:
+	BUG_ON((unsigned long)virt_to_phys(m) & (huge_page_size(h) - 1));
+	/* Put them into a private list first because mem_map is not up yet */
+	list_add(&m->list, &huge_boot_pages);
+	m->hstate = h;
+	return 1;
+}
+
+/* Put bootmem huge pages into the standard lists after mem_map is up */
+static void __init gather_bootmem_prealloc(void)
+{
+	struct huge_bootmem_page *m;
+
+	list_for_each_entry(m, &huge_boot_pages, list) {
+		struct page *page = virt_to_page(m);
+		struct hstate *h = m->hstate;
+		__ClearPageReserved(page);
+		WARN_ON(page_count(page) != 1);
+		prep_compound_page(page, h->order);
+		prep_new_huge_page(h, page, page_to_nid(page));
+	}
+}
+
 static void __init hugetlb_init_one_hstate(struct hstate *h)
 {
 	unsigned long i;
@@ -848,7 +916,10 @@ static void __init hugetlb_init_one_hsta
 	h->hugetlb_next_nid = first_node(node_online_map);
 
 	for (i = 0; i < h->max_huge_pages; ++i) {
-		if (!alloc_fresh_huge_page(h))
+		if (h->order >= MAX_ORDER) {
+			if (!alloc_bootmem_huge_page(h))
+				break;
+		} else if (!alloc_fresh_huge_page(h))
 			break;
 	}
 	h->max_huge_pages = h->free_huge_pages = h->nr_huge_pages = i;
@@ -881,6 +952,9 @@ static void try_to_free_low(struct hstat
 {
 	int i;
 
+	if (h->order >= MAX_ORDER)
+		return;
+
 	for (i = 0; i < MAX_NUMNODES; ++i) {
 		struct page *page, *next;
 		struct list_head *freel = &h->hugepage_freelists[i];
@@ -907,6 +981,9 @@ static unsigned long set_max_huge_pages(
 {
 	unsigned long min_count, ret;
 
+	if (h->order >= MAX_ORDER)
+		return h->max_huge_pages;
+
 	/*
 	 * Increase the pool size
 	 * First take pages out of surplus state.  Then make up the
@@ -1129,6 +1206,8 @@ static int __init hugetlb_init(void)
 
 	hugetlb_init_hstates();
 
+	gather_bootmem_prealloc();
+
 	report_hugepages();
 
 	hugetlb_sysfs_init();
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

