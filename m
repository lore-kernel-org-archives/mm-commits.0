From: akpm@linux-foundation.org
Subject: [folded] ksm-kernel-samepage-merging-fix-rare-page-leak.patch removed from -mm tree
Date: Mon, 21 Sep 2009 14:21:37 -0700
Message-ID: <200909212121.n8LLLbNW004393@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753489AbZIUVWV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Sep 2009 17:22:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, ieidus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ksm: fix rare page leak
has been removed from the -mm tree.  Its filename was
     ksm-kernel-samepage-merging-fix-rare-page-leak.patch

This patch was dropped because it was folded into ksm-kernel-samepage-merging.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm: fix rare page leak
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

In the rare case when stable_tree_insert() finds a match when the prior
stable_tree_search() did not, it forgot to free the page reference (the
omission looks intentional, but I think that's because something else used
to be done there).

Fix that by one put_page() for all three cases, call it tree_page rather
than page2[0], clarify the comment on this exceptional case, and remove
the comment in stable_tree_search() which contradicts it!

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Acked-by: Izik Eidus <ieidus@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff -puN mm/ksm.c~ksm-kernel-samepage-merging-fix-rare-page-leak mm/ksm.c
--- a/mm/ksm.c~ksm-kernel-samepage-merging-fix-rare-page-leak
+++ a/mm/ksm.c
@@ -858,10 +858,6 @@ static struct rmap_item *stable_tree_sea
 		if (!tree_rmap_item)
 			return NULL;
 
-		/*
-		 * We can trust the value of the memcmp as we know the pages
-		 * are write protected.
-		 */
 		ret = memcmp_pages(page, page2[0]);
 
 		if (ret < 0) {
@@ -893,18 +889,18 @@ static struct rmap_item *stable_tree_ins
 {
 	struct rb_node **new = &root_stable_tree.rb_node;
 	struct rb_node *parent = NULL;
-	struct page *page2[1];
 
 	while (*new) {
 		struct rmap_item *tree_rmap_item, *next_rmap_item;
+		struct page *tree_page;
 		int ret;
 
 		tree_rmap_item = rb_entry(*new, struct rmap_item, node);
 		while (tree_rmap_item) {
 			BUG_ON(!in_stable_tree(tree_rmap_item));
 			cond_resched();
-			page2[0] = get_ksm_page(tree_rmap_item);
-			if (page2[0])
+			tree_page = get_ksm_page(tree_rmap_item);
+			if (tree_page)
 				break;
 			next_rmap_item = tree_rmap_item->next;
 			remove_rmap_item_from_tree(tree_rmap_item);
@@ -913,22 +909,19 @@ static struct rmap_item *stable_tree_ins
 		if (!tree_rmap_item)
 			return NULL;
 
-		ret = memcmp_pages(page, page2[0]);
+		ret = memcmp_pages(page, tree_page);
+		put_page(tree_page);
 
 		parent = *new;
-		if (ret < 0) {
-			put_page(page2[0]);
+		if (ret < 0)
 			new = &parent->rb_left;
-		} else if (ret > 0) {
-			put_page(page2[0]);
+		else if (ret > 0)
 			new = &parent->rb_right;
-		} else {
+		else {
 			/*
-			 * It is not a bug when we come here (the fact that
-			 * we didn't find the page inside the stable tree):
-			 * because when we searched for the page inside the
-			 * stable tree it was still not write-protected,
-			 * so therefore it could have changed later.
+			 * It is not a bug that stable_tree_search() didn't
+			 * find this node: because at that time our page was
+			 * not yet write-protected, so may have changed since.
 			 */
 			return NULL;
 		}
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
mm-oom-analysis-add-shmem-vmstat.patch
mm-vmstat-add-isolate-pages.patch
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-kernel-samepage-merging-fix-rare-page-leak.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch
ksm-rename-kernel_pages_allocated.patch
ksm-move-pages_sharing-updates.patch
ksm-pages_unshared-and-pages_volatile.patch
ksm-break-cow-once-unshared.patch
ksm-keep-quiet-while-list-empty.patch
ksm-five-little-cleanups.patch
ksm-fix-endless-loop-on-oom.patch
ksm-distribute-remove_mm_from_lists.patch
ksm-fix-oom-deadlock.patch
ksm-fix-deadlock-with-munlock-in-exit_mmap.patch
ksm-sysfs-and-defaults.patch
ksm-add-some-documentation.patch
ksm-remove-vm_mergeable_flags.patch
ksm-clean-up-obsolete-references.patch
ksm-unmerge-is-an-origin-of-ooms.patch
ksm-mremap-use-err-from-ksm_madvise.patch
mm-add_to_swap_cache-must-not-sleep.patch
mm-add_to_swap_cache-does-not-return-eexist.patch
mm-includecheck-fix-for-mm-shmemc.patch
mm-introduce-page_lru_base_type-fix.patch
mm-replace-various-uses-of-num_physpages-by-totalram_pages.patch
mm-munlock-use-follow_page.patch
mm-remove-unused-gup-flags.patch
mm-add-get_dump_page.patch
mm-foll_dump-replace-foll_anon.patch
mm-follow_hugetlb_page-flags.patch
mm-fix-anonymous-dirtying.patch
mm-reinstate-zero_page.patch
mm-foll-flags-for-gup-flags.patch
mm-munlock-avoid-zero_page.patch
mm-hugetlbfs_pagecache_present.patch
mm-zero_page-without-pte_special.patch
mm-zero_page-without-pte_special-mips-fix.patch
mm-move-highest_memmap_pfn.patch
mmap-remove-unnecessary-code.patch
tmpfs-depend-on-shmem.patch
mmap-avoid-unnecessary-anon_vma-lock-acquisition-in-vma_adjust.patch
mmap-avoid-unnecessary-anon_vma-lock-acquisition-in-vma_adjust-tweak.patch
mmap-save-some-cycles-for-the-shared-anonymous-mapping.patch
hugetlbfs-allow-the-creation-of-files-suitable-for-map_private-on-the-vfs-internal-mount.patch
mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions-fix.patch
hugetlb-add-map_hugetlb-example.patch
shmem-initialize-struct-shmem_sb_info-to-zero.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
walk-system-ram-range-fix.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
prio_tree-debugging-patch.patch

