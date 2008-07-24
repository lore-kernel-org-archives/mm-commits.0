From: akpm@linux-foundation.org
Subject: - hugetlb-support-larger-than-max_order.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:23:13 -0700
Message-ID: <200807242323.m6ONNDro010641@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33999 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753997AbYGXXXW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:23:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, abh@cray.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     hugetlb: support larger than MAX_ORDER
has been removed from the -mm tree.  Its filename was
     hugetlb-support-larger-than-max_order.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -489,7 +490,7 @@ static void free_huge_page(struct page *
 	INIT_LIST_HEAD(&page->lru);
 
 	spin_lock(&hugetlb_lock);
-	if (h->surplus_huge_pages_node[nid]) {
+	if (h->surplus_huge_pages_node[nid] && huge_page_order(h) < MAX_ORDER) {
 		update_and_free_page(h, page);
 		h->surplus_huge_pages--;
 		h->surplus_huge_pages_node[nid]--;
@@ -550,6 +551,9 @@ static struct page *alloc_fresh_huge_pag
 {
 	struct page *page;
 
+	if (h->order >= MAX_ORDER)
+		return NULL;
+
 	page = alloc_pages_node(nid,
 		htlb_alloc_mask|__GFP_COMP|__GFP_THISNODE|
 						__GFP_REPEAT|__GFP_NOWARN,
@@ -616,6 +620,9 @@ static struct page *alloc_buddy_huge_pag
 	struct page *page;
 	unsigned int nid;
 
+	if (h->order >= MAX_ORDER)
+		return NULL;
+
 	/*
 	 * Assume we will successfully allocate the surplus page to
 	 * prevent racing processes from causing the surplus to exceed
@@ -792,6 +799,10 @@ static void return_unused_surplus_pages(
 	/* Uncommit the reservation */
 	h->resv_huge_pages -= unused_resv_pages;
 
+	/* Cannot return gigantic pages currently */
+	if (h->order >= MAX_ORDER)
+		return;
+
 	nr_pages = min(unused_resv_pages, h->surplus_huge_pages);
 
 	while (remaining_iterations-- && nr_pages) {
@@ -913,6 +924,63 @@ static struct page *alloc_huge_page(stru
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
@@ -923,7 +991,10 @@ static void __init hugetlb_init_one_hsta
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
@@ -956,6 +1027,9 @@ static void try_to_free_low(struct hstat
 {
 	int i;
 
+	if (h->order >= MAX_ORDER)
+		return;
+
 	for (i = 0; i < MAX_NUMNODES; ++i) {
 		struct page *page, *next;
 		struct list_head *freel = &h->hugepage_freelists[i];
@@ -982,6 +1056,9 @@ static unsigned long set_max_huge_pages(
 {
 	unsigned long min_count, ret;
 
+	if (h->order >= MAX_ORDER)
+		return h->max_huge_pages;
+
 	/*
 	 * Increase the pool size
 	 * First take pages out of surplus state.  Then make up the
@@ -1210,6 +1287,8 @@ static int __init hugetlb_init(void)
 
 	hugetlb_init_hstates();
 
+	gather_bootmem_prealloc();
+
 	report_hugepages();
 
 	hugetlb_sysfs_init();
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

