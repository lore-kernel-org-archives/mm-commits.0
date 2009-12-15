From: akpm@linux-foundation.org
Subject: [folded] swap_info-include-first_swap_extent-fix-fix.patch removed from -mm tree
Date: Mon, 14 Dec 2009 16:58:15 -0800
Message-ID: <200912150058.nBF0wGXS021014@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37891 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758162AbZLOA6i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 19:58:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, jirislaby@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     fix to swap_info-include-first_swap_extent-fix.patch
has been removed from the -mm tree.  Its filename was
     swap_info-include-first_swap_extent-fix-fix.patch

This patch was dropped because it was folded into swap_info-include-first_swap_extent.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix to swap_info-include-first_swap_extent-fix.patch
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Sorry, just noticed what the diff contexts don't show: Jiri's patch is
initializing p->first_swap_extent.list at a point before p has been
decided - we may kfree that newly allocated p and go on to reuse an
existing free entry for p.

Now, the patch is not actually wrong: an existing free entry will have a
good empty first_swap_extent.list; but it looks suspicious, it seems
strange to initialize a field in something we're about to kfree, and I'd
rather we put that initialization back to where it was in 2.6.32.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/swapfile.c~swap_info-include-first_swap_extent-fix-fix mm/swapfile.c
--- a/mm/swapfile.c~swap_info-include-first_swap_extent-fix-fix
+++ a/mm/swapfile.c
@@ -1817,7 +1817,6 @@ SYSCALL_DEFINE2(swapon, const char __use
 		kfree(p);
 		goto out;
 	}
-	INIT_LIST_HEAD(&p->first_swap_extent.list);
 	if (type >= nr_swapfiles) {
 		p->type = type;
 		swap_info[type] = p;
@@ -1836,6 +1835,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 		 * would be relying on p->type to remain valid.
 		 */
 	}
+	INIT_LIST_HEAD(&p->first_swap_extent.list);
 	p->flags = SWP_USED;
 	p->next = -1;
 	spin_unlock(&swap_lock);
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
vmalloc-adjust-gfp-mask-passed-on-nested-vmalloc-invocation.patch
swap_info-private-to-swapfilec.patch
swap_info-change-to-array-of-pointers.patch
swap_info-include-first_swap_extent.patch
swap_info-include-first_swap_extent-fix-fix.patch
swap_info-miscellaneous-minor-cleanups.patch
swap_info-swap_has_cache-cleanups.patch
swap_info-swap_map-of-chars-not-shorts.patch
swap_info-swap-count-continuations.patch
swap_info-note-swap_map_shmem.patch
swap_info-reorder-its-fields.patch
swap-rework-map_swap_page-again.patch
rmap-fix-the-comment-for-try_to_unmap_anon.patch
oom_kill-use-rss-value-instead-of-vm-size-for-badness.patch
mm-define-page_mapping_flags.patch
mm-mlocking-in-try_to_unmap_one.patch
mm-mlocking-in-try_to_unmap_one-fix.patch
mm-mlocking-in-try_to_unmap_one-fix-fix.patch
mm-config_mmu-for-pg_mlocked.patch
mm-pass-address-down-to-rmap-ones.patch
mm-stop-ptlock-enlarging-struct-page.patch
mm-sigbus-instead-of-abusing-oom.patch
ksm-three-remove_rmap_item_from_tree-cleanups.patch
ksm-remove-redundancies-when-merging-page.patch
ksm-cleanup-some-function-arguments.patch
ksm-singly-linked-rmap_list.patch
ksm-separate-stable_node.patch
ksm-stable_node-point-to-page-and-back.patch
ksm-fix-mlockfreed-to-munlocked.patch
ksm-let-shared-pages-be-swappable.patch
ksm-hold-anon_vma-in-rmap_item.patch
ksm-hold-anon_vma-in-rmap_item-fix.patch
ksm-take-keyhole-reference-to-page.patch
ksm-share-anon-page-without-allocating.patch
ksm-mem-cgroup-charge-swapin-copy.patch
ksm-rmap_walk-to-remove_migation_ptes.patch
ksm-memory-hotremove-migration-only.patch
ksm-remove-unswappable-max_kernel_pages.patch
hugetlb-prevent-deadlock-in-__unmap_hugepage_range-when-alloc_huge_page-fails-2.patch
mm-simplify-try_to_unmap_one.patch
mm-simplify-try_to_unmap_one-fix.patch
mm-uncached-vma-support-with-writenotify.patch
hugetlb-acquire-the-i_mmap_lock-before-walking-the-prio_tree-to-unmap-a-page-v2.patch
mm-remove-unevictable_migrate_page-function.patch
mlock-replace-stale-comments-in-munlock_vma_page.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore-build-fix.patch
mm-hugetlb-fix-hugepage-memory-leak-in-walk_page_range.patch
mm-hugetlb-fix-hugepage-memory-leak-in-walk_page_range-update.patch
mm-hugetlb-add-hugepage-support-to-pagemap.patch
mm-hugetlb-add-hugepage-support-to-pagemap-update.patch
mm-hugetlb-add-hugepage-support-to-pagemap-build-fix.patch

