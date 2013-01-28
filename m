From: akpm@linux-foundation.org
Subject: + ksm-reorganize-ksm_check_stable_tree.patch added to -mm tree
Date: Mon, 28 Jan 2013 15:50:38 -0800
Message-ID: <20130128235039.677E031C266@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f201.google.com ([209.85.223.201]:34523 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab3A1Xul (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Jan 2013 18:50:41 -0500
Received: by mail-ie0-f201.google.com with SMTP id c14so129570ieb.2
        for <mm-commits@vger.kernel.org>; Mon, 28 Jan 2013 15:50:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, aarcange@redhat.com, gerald.schaefer@de.ibm.com, izik.eidus@ravellosystems.com, kosaki.motohiro@gmail.com, pholasek@redhat.com, riel@redhat.com


The patch titled
     Subject: ksm: reorganize ksm_check_stable_tree
has been added to the -mm tree.  Its filename is
     ksm-reorganize-ksm_check_stable_tree.patch

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
Subject: ksm: reorganize ksm_check_stable_tree

Memory hotremove's ksm_check_stable_tree() is pitifully inefficient
(restarting whenever it finds a stale node to remove), but rearrange so
that at least it does not needlessly restart from nid 0 each time.  And
add a couple of comments: here is why we keep pfn instead of page.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Petr Holasek <pholasek@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff -puN mm/ksm.c~ksm-reorganize-ksm_check_stable_tree mm/ksm.c
--- a/mm/ksm.c~ksm-reorganize-ksm_check_stable_tree
+++ a/mm/ksm.c
@@ -1830,31 +1830,36 @@ void ksm_migrate_page(struct page *newpa
 #endif /* CONFIG_MIGRATION */
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
-static struct stable_node *ksm_check_stable_tree(unsigned long start_pfn,
-						 unsigned long end_pfn)
+static void ksm_check_stable_tree(unsigned long start_pfn,
+				  unsigned long end_pfn)
 {
+	struct stable_node *stable_node;
 	struct rb_node *node;
 	int nid;
 
-	for (nid = 0; nid < nr_node_ids; nid++)
-		for (node = rb_first(&root_stable_tree[nid]); node;
-				node = rb_next(node)) {
-			struct stable_node *stable_node;
-
+	for (nid = 0; nid < nr_node_ids; nid++) {
+		node = rb_first(&root_stable_tree[nid]);
+		while (node) {
 			stable_node = rb_entry(node, struct stable_node, node);
 			if (stable_node->kpfn >= start_pfn &&
-			    stable_node->kpfn < end_pfn)
-				return stable_node;
+			    stable_node->kpfn < end_pfn) {
+				/*
+				 * Don't get_ksm_page, page has already gone:
+				 * which is why we keep kpfn instead of page*
+				 */
+				remove_node_from_stable_tree(stable_node);
+				node = rb_first(&root_stable_tree[nid]);
+			} else
+				node = rb_next(node);
+			cond_resched();
 		}
-
-	return NULL;
+	}
 }
 
 static int ksm_memory_callback(struct notifier_block *self,
 			       unsigned long action, void *arg)
 {
 	struct memory_notify *mn = arg;
-	struct stable_node *stable_node;
 
 	switch (action) {
 	case MEM_GOING_OFFLINE:
@@ -1874,11 +1879,12 @@ static int ksm_memory_callback(struct no
 		/*
 		 * Most of the work is done by page migration; but there might
 		 * be a few stable_nodes left over, still pointing to struct
-		 * pages which have been offlined: prune those from the tree.
+		 * pages which have been offlined: prune those from the tree,
+		 * otherwise get_ksm_page() might later try to access a
+		 * non-existent struct page.
 		 */
-		while ((stable_node = ksm_check_stable_tree(mn->start_pfn,
-					mn->start_pfn + mn->nr_pages)) != NULL)
-			remove_node_from_stable_tree(stable_node);
+		ksm_check_stable_tree(mn->start_pfn,
+				      mn->start_pfn + mn->nr_pages);
 		/* fallthrough */
 
 	case MEM_CANCEL_OFFLINE:
_

Patches currently in -mm which might be from hughd@google.com are

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
swap-add-per-partition-lock-for-swapfile.patch
memcg-reduce-the-size-of-struct-memcg-244-fold.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch
ksm-allow-trees-per-numa-node.patch
ksm-add-sysfs-abi-documentation.patch
ksm-trivial-tidyups.patch
ksm-reorganize-ksm_check_stable_tree.patch
ksm-get_ksm_page-locked.patch
ksm-remove-old-stable-nodes-more-thoroughly.patch
ksm-make-ksm-page-migration-possible.patch
ksm-make-merge_across_nodes-migration-safe.patch
ksm-enable-ksm-page-migration.patch
mm-remove-offlining-arg-to-migrate_pages.patch
ksm-stop-hotremove-lockdep-warning.patch
mm-prevent-addition-of-pages-to-swap-if-may_writepage-is-unset.patch

