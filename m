From: akpm@linux-foundation.org
Subject: + ksm-add-some-comments.patch added to -mm tree
Date: Thu, 21 Feb 2013 14:09:50 -0800
Message-ID: <20130221220951.660CA31C251@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:33776 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756874Ab3BUWJx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 17:09:53 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so18818qah.4
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 14:09:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, aarcange@redhat.com, hannes@cmpxchg.org, izik.eidus@ravellosystems.com, mgorman@suse.de, pholasek@redhat.com


The patch titled
     Subject: ksm: add some comments
has been added to the -mm tree.  Its filename is
     ksm-add-some-comments.patch

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
Subject: ksm: add some comments

Added slightly more detail to the Documentation of merge_across_nodes, a
few comments in areas indicated by review, and renamed get_ksm_page()'s
argument from "locked" to "lock_it".  No functional change.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Petr Holasek <pholasek@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/ksm.txt |   16 ++++++++++++----
 mm/ksm.c                 |   18 ++++++++++++++----
 2 files changed, 26 insertions(+), 8 deletions(-)

diff -puN Documentation/vm/ksm.txt~ksm-add-some-comments Documentation/vm/ksm.txt
--- a/Documentation/vm/ksm.txt~ksm-add-some-comments
+++ a/Documentation/vm/ksm.txt
@@ -60,10 +60,18 @@ sleep_millisecs  - how many milliseconds
 
 merge_across_nodes - specifies if pages from different numa nodes can be merged.
                    When set to 0, ksm merges only pages which physically
-                   reside in the memory area of same NUMA node. It brings
-                   lower latency to access to shared page. Value can be
-                   changed only when there is no ksm shared pages in system.
-                   Default: 1
+                   reside in the memory area of same NUMA node. That brings
+                   lower latency to access of shared pages. Systems with more
+                   nodes, at significant NUMA distances, are likely to benefit
+                   from the lower latency of setting 0. Smaller systems, which
+                   need to minimize memory usage, are likely to benefit from
+                   the greater sharing of setting 1 (default). You may wish to
+                   compare how your system performs under each setting, before
+                   deciding on which to use. merge_across_nodes setting can be
+                   changed only when there are no ksm shared pages in system:
+                   set run 2 to unmerge pages first, then to 1 after changing
+                   merge_across_nodes, to remerge according to the new setting.
+                   Default: 1 (merging across nodes as in earlier releases)
 
 run              - set 0 to stop ksmd from running but keep merged pages,
                    set 1 to run ksmd e.g. "echo 1 > /sys/kernel/mm/ksm/run",
diff -puN mm/ksm.c~ksm-add-some-comments mm/ksm.c
--- a/mm/ksm.c~ksm-add-some-comments
+++ a/mm/ksm.c
@@ -87,6 +87,9 @@
  *    take 10 attempts to find a page in the unstable tree, once it is found,
  *    it is secured in the stable tree.  (When we scan a new page, we first
  *    compare it against the stable tree, and then against the unstable tree.)
+ *
+ * If the merge_across_nodes tunable is unset, then KSM maintains multiple
+ * stable trees and multiple unstable trees: one of each for each NUMA node.
  */
 
 /**
@@ -526,7 +529,7 @@ static void remove_node_from_stable_tree
  * a page to put something that might look like our key in page->mapping.
  * is on its way to being freed; but it is an anomaly to bear in mind.
  */
-static struct page *get_ksm_page(struct stable_node *stable_node, bool locked)
+static struct page *get_ksm_page(struct stable_node *stable_node, bool lock_it)
 {
 	struct page *page;
 	void *expected_mapping;
@@ -575,7 +578,7 @@ again:
 		goto stale;
 	}
 
-	if (locked) {
+	if (lock_it) {
 		lock_page(page);
 		if (ACCESS_ONCE(page->mapping) != expected_mapping) {
 			unlock_page(page);
@@ -705,10 +708,17 @@ static int remove_stable_node(struct sta
 		return 0;
 	}
 
-	if (WARN_ON_ONCE(page_mapped(page)))
+	if (WARN_ON_ONCE(page_mapped(page))) {
+		/*
+		 * This should not happen: but if it does, just refuse to let
+		 * merge_across_nodes be switched - there is no need to panic.
+		 */
 		err = -EBUSY;
-	else {
+	} else {
 		/*
+		 * The stable node did not yet appear stale to get_ksm_page(),
+		 * since that allows for an unmapped ksm page to be recognized
+		 * right up until it is freed; but the node is safe to remove.
 		 * This page might be in a pagevec waiting to be freed,
 		 * or it might be PageSwapCache (perhaps under writeback),
 		 * or it might have been removed from swapcache a moment ago.
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

