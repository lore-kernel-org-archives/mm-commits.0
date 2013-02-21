From: akpm@linux-foundation.org
Subject: + ksm-shrink-32-bit-rmap_item-back-to-32-bytes.patch added to -mm tree
Date: Thu, 21 Feb 2013 14:09:56 -0800
Message-ID: <20130221220957.6304F5A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:59438 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191Ab3BUWJ6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 17:09:58 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so3834yen.3
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 14:09:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, aarcange@redhat.com, hannes@cmpxchg.org, izik.eidus@ravellosystems.com, mgorman@suse.de, pholasek@redhat.com


The patch titled
     Subject: ksm: shrink 32-bit rmap_item back to 32 bytes
has been added to the -mm tree.  Its filename is
     ksm-shrink-32-bit-rmap_item-back-to-32-bytes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: ksm: shrink 32-bit rmap_item back to 32 bytes

Think of struct rmap_item as an extension of struct page (restricted to
MADV_MERGEABLE areas): there may be a lot of them, we need to keep them
small, especially on 32-bit architectures of limited lowmem.

Siting "int nid" after "unsigned int checksum" works nicely on 64-bit,
making no change to its 64-byte struct rmap_item; but bloats the 32-bit
struct rmap_item from (nicely cache-aligned) 32 bytes to 36 bytes, which
rounds up to 40 bytes once allocated from slab.  We'd better avoid that.

Hey, I only just remembered that the anon_vma pointer in struct rmap_item
has no purpose until the rmap_item is hung from a stable tree node (which
has its own nid field); and rmap_item's nid field no purpose than to say
which tree root to tell rb_erase() when unlinking from an unstable tree.

Double them up in a union.  There's just one place where we set anon_vma
early (when we already hold mmap_sem): now we must remove tree_rmap_item
from its unstable tree there, before overwriting nid.  No need to spatter
BUG()s around: we'd be seeing oopses if this were wrong.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Petr Holasek <pholasek@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff -puN mm/ksm.c~ksm-shrink-32-bit-rmap_item-back-to-32-bytes mm/ksm.c
--- a/mm/ksm.c~ksm-shrink-32-bit-rmap_item-back-to-32-bytes
+++ a/mm/ksm.c
@@ -150,23 +150,25 @@ struct stable_node {
  * struct rmap_item - reverse mapping item for virtual addresses
  * @rmap_list: next rmap_item in mm_slot's singly-linked rmap_list
  * @anon_vma: pointer to anon_vma for this mm,address, when in stable tree
+ * @nid: NUMA node id of unstable tree in which linked (may not match page)
  * @mm: the memory structure this rmap_item is pointing into
  * @address: the virtual address this rmap_item tracks (+ flags in low bits)
  * @oldchecksum: previous checksum of the page at that virtual address
- * @nid: NUMA node id of unstable tree in which linked (may not match page)
  * @node: rb node of this rmap_item in the unstable tree
  * @head: pointer to stable_node heading this list in the stable tree
  * @hlist: link into hlist of rmap_items hanging off that stable_node
  */
 struct rmap_item {
 	struct rmap_item *rmap_list;
-	struct anon_vma *anon_vma;	/* when stable */
+	union {
+		struct anon_vma *anon_vma;	/* when stable */
+#ifdef CONFIG_NUMA
+		int nid;		/* when node of unstable tree */
+#endif
+	};
 	struct mm_struct *mm;
 	unsigned long address;		/* + low bits used for flags below */
 	unsigned int oldchecksum;	/* when unstable */
-#ifdef CONFIG_NUMA
-	int nid;
-#endif
 	union {
 		struct rb_node node;	/* when node of unstable tree */
 		struct {		/* when listed from stable tree */
@@ -1094,6 +1096,9 @@ static int try_to_merge_with_ksm_page(st
 	if (err)
 		goto out;
 
+	/* Unstable nid is in union with stable anon_vma: remove first */
+	remove_rmap_item_from_tree(rmap_item);
+
 	/* Must get reference to anon_vma while still holding mmap_sem */
 	rmap_item->anon_vma = vma->anon_vma;
 	get_anon_vma(vma->anon_vma);
@@ -1468,14 +1473,11 @@ static void cmp_and_merge_page(struct pa
 		kpage = try_to_merge_two_pages(rmap_item, page,
 						tree_rmap_item, tree_page);
 		put_page(tree_page);
-		/*
-		 * As soon as we merge this page, we want to remove the
-		 * rmap_item of the page we have merged with from the unstable
-		 * tree, and insert it instead as new node in the stable tree.
-		 */
 		if (kpage) {
-			remove_rmap_item_from_tree(tree_rmap_item);
-
+			/*
+			 * The pages were successfully merged: insert new
+			 * node in the stable tree and add both rmap_items.
+			 */
 			lock_page(kpage);
 			stable_node = stable_tree_insert(kpage);
 			if (stable_node) {
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit.patch
pageattr-prevent-pse-and-gloabl-leftovers-to-confuse-pmd-pte_present-and-pmd_huge.patch
mm-memcg-only-evict-file-pages-when-we-have-plenty.patch
mm-vmscan-save-work-scanning-almost-empty-lru-lists.patch
mm-vmscan-clarify-how-swappiness-highest-priority-memcg-interact.patch
mm-vmscan-improve-comment-on-low-page-cache-handling.patch
mm-vmscan-clean-up-get_scan_count.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-reduce-rmap-overhead-for-ex-ksm-page-copies-created-on-swap-faults.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mmksm-use-new-hashtable-implementation.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch-fix.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch-fix-fix.patch
mm-avoid-calling-pgdat_balanced-needlessly.patch
mm-numa-fix-minor-typo-in-numa_next_scan.patch
mm-numa-take-thp-into-account-when-migrating-pages-for-numa-balancing.patch
mm-numa-handle-side-effects-in-count_vm_numa_events-for-config_numa_balancing.patch
mm-move-page-flags-layout-to-separate-header.patch
mm-fold-page-_last_nid-into-page-flags-where-possible.patch
mm-numa-cleanup-flow-of-transhuge-page-migration.patch
mm-dont-inline-page_mapping.patch
swap-make-each-swap-partition-have-one-address_space.patch
swap-make-each-swap-partition-have-one-address_space-fix.patch
swap-make-each-swap-partition-have-one-address_space-fix-fix.patch
swap-add-per-partition-lock-for-swapfile.patch
swap-add-per-partition-lock-for-swapfile-fix-fix-fix.patch
memcg-reduce-the-size-of-struct-memcg-244-fold.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch
ksm-allow-trees-per-numa-node.patch
ksm-add-sysfs-abi-documentation.patch
ksm-trivial-tidyups.patch
ksm-trivial-tidyups-fix.patch
ksm-reorganize-ksm_check_stable_tree.patch
ksm-get_ksm_page-locked.patch
ksm-remove-old-stable-nodes-more-thoroughly.patch
ksm-make-ksm-page-migration-possible.patch
ksm-make-merge_across_nodes-migration-safe.patch
ksm-enable-ksm-page-migration.patch
mm-remove-offlining-arg-to-migrate_pages.patch
ksm-stop-hotremove-lockdep-warning.patch
mm-shmem-use-new-radix-tree-iterator.patch
mm-mlockc-document-scary-looking-stack-expansion-mlock-chain.patch
mmu_notifier_unregister-null-pointer-deref-and-multiple-release-callouts.patch
mm-use-up-free-swap-space-before-reaching-oom-kill.patch
memcg-stop-warning-on-memcg_propagate_kmem.patch
mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages.patch
mm-accelerate-mm_populate-treatment-of-thp-pages.patch
mm-accelerate-munlock-treatment-of-thp-pages.patch
tmpfs-fix-use-after-free-of-mempolicy-object.patch
tmpfs-fix-mempolicy-object-leaks.patch
tmpfs-fix-mempolicy-object-leaks-fix.patch
ksm-add-some-comments.patch
ksm-treat-unstable-nid-like-in-stable-tree.patch
ksm-shrink-32-bit-rmap_item-back-to-32-bytes.patch
mmksm-foll_migration-do-migration_entry_wait.patch
mmksm-swapoff-might-need-to-copy.patch
mm-cleanup-swapcache-in-do_swap_page.patch
ksm-allocate-roots-when-needed.patch

