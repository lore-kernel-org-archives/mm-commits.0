From: akpm@linux-foundation.org
Subject: + ksm-allocate-roots-when-needed.patch added to -mm tree
Date: Thu, 21 Feb 2013 14:10:08 -0800
Message-ID: <20130221221009.52DF75A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:48887 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758655Ab3BUWKK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 17:10:10 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so3893yen.2
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 14:10:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, aarcange@redhat.com, hannes@cmpxchg.org, izik.eidus@ravellosystems.com, mgorman@suse.de, pholasek@redhat.com


The patch titled
     Subject: ksm: allocate roots when needed
has been added to the -mm tree.  Its filename is
     ksm-allocate-roots-when-needed.patch

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
Subject: ksm: allocate roots when needed

It is a pity to have MAX_NUMNODES+MAX_NUMNODES tree roots statically
allocated, particularly when very few users will ever actually tune
merge_across_nodes 0 to use more than 1+1 of those trees.  Not a big deal
(only 16kB wasted on each machine with CONFIG_MAXSMP), but a pity.

Start off with 1+1 statically allocated, then if merge_across_nodes is
ever tuned, allocate for nr_node_ids+nr_node_ids.  Do not attempt to free
up the extra if it's tuned back, that would be a waste of effort.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Petr Holasek <pholasek@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   72 ++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 49 insertions(+), 23 deletions(-)

diff -puN mm/ksm.c~ksm-allocate-roots-when-needed mm/ksm.c
--- a/mm/ksm.c~ksm-allocate-roots-when-needed
+++ a/mm/ksm.c
@@ -183,8 +183,10 @@ struct rmap_item {
 #define STABLE_FLAG	0x200	/* is listed from the stable tree */
 
 /* The stable and unstable tree heads */
-static struct rb_root root_unstable_tree[MAX_NUMNODES];
-static struct rb_root root_stable_tree[MAX_NUMNODES];
+static struct rb_root one_stable_tree[1] = { RB_ROOT };
+static struct rb_root one_unstable_tree[1] = { RB_ROOT };
+static struct rb_root *root_stable_tree = one_stable_tree;
+static struct rb_root *root_unstable_tree = one_unstable_tree;
 
 /* Recently migrated nodes of stable tree, pending proper placement */
 static LIST_HEAD(migrate_nodes);
@@ -224,8 +226,10 @@ static unsigned int ksm_thread_sleep_mil
 #ifdef CONFIG_NUMA
 /* Zeroed when merging across nodes is not allowed */
 static unsigned int ksm_merge_across_nodes = 1;
+static int ksm_nr_node_ids = 1;
 #else
 #define ksm_merge_across_nodes	1U
+#define ksm_nr_node_ids		1
 #endif
 
 #define KSM_RUN_STOP	0
@@ -508,7 +512,7 @@ static void remove_node_from_stable_tree
 		list_del(&stable_node->list);
 	else
 		rb_erase(&stable_node->node,
-			 &root_stable_tree[NUMA(stable_node->nid)]);
+			 root_stable_tree + NUMA(stable_node->nid));
 	free_stable_node(stable_node);
 }
 
@@ -644,7 +648,7 @@ static void remove_rmap_item_from_tree(s
 		BUG_ON(age > 1);
 		if (!age)
 			rb_erase(&rmap_item->node,
-				 &root_unstable_tree[NUMA(rmap_item->nid)]);
+				 root_unstable_tree + NUMA(rmap_item->nid));
 		ksm_pages_unshared--;
 		rmap_item->address &= PAGE_MASK;
 	}
@@ -742,7 +746,7 @@ static int remove_all_stable_nodes(void)
 	int nid;
 	int err = 0;
 
-	for (nid = 0; nid < nr_node_ids; nid++) {
+	for (nid = 0; nid < ksm_nr_node_ids; nid++) {
 		while (root_stable_tree[nid].rb_node) {
 			stable_node = rb_entry(root_stable_tree[nid].rb_node,
 						struct stable_node, node);
@@ -1150,6 +1154,7 @@ static struct page *try_to_merge_two_pag
 static struct page *stable_tree_search(struct page *page)
 {
 	int nid;
+	struct rb_root *root;
 	struct rb_node **new;
 	struct rb_node *parent;
 	struct stable_node *stable_node;
@@ -1163,8 +1168,9 @@ static struct page *stable_tree_search(s
 	}
 
 	nid = get_kpfn_nid(page_to_pfn(page));
+	root = root_stable_tree + nid;
 again:
-	new = &root_stable_tree[nid].rb_node;
+	new = &root->rb_node;
 	parent = NULL;
 
 	while (*new) {
@@ -1219,7 +1225,7 @@ again:
 	list_del(&page_node->list);
 	DO_NUMA(page_node->nid = nid);
 	rb_link_node(&page_node->node, parent, new);
-	rb_insert_color(&page_node->node, &root_stable_tree[nid]);
+	rb_insert_color(&page_node->node, root);
 	get_page(page);
 	return page;
 
@@ -1227,11 +1233,10 @@ replace:
 	if (page_node) {
 		list_del(&page_node->list);
 		DO_NUMA(page_node->nid = nid);
-		rb_replace_node(&stable_node->node,
-				&page_node->node, &root_stable_tree[nid]);
+		rb_replace_node(&stable_node->node, &page_node->node, root);
 		get_page(page);
 	} else {
-		rb_erase(&stable_node->node, &root_stable_tree[nid]);
+		rb_erase(&stable_node->node, root);
 		page = NULL;
 	}
 	stable_node->head = &migrate_nodes;
@@ -1250,13 +1255,15 @@ static struct stable_node *stable_tree_i
 {
 	int nid;
 	unsigned long kpfn;
+	struct rb_root *root;
 	struct rb_node **new;
 	struct rb_node *parent = NULL;
 	struct stable_node *stable_node;
 
 	kpfn = page_to_pfn(kpage);
 	nid = get_kpfn_nid(kpfn);
-	new = &root_stable_tree[nid].rb_node;
+	root = root_stable_tree + nid;
+	new = &root->rb_node;
 
 	while (*new) {
 		struct page *tree_page;
@@ -1295,7 +1302,7 @@ static struct stable_node *stable_tree_i
 	set_page_stable_node(kpage, stable_node);
 	DO_NUMA(stable_node->nid = nid);
 	rb_link_node(&stable_node->node, parent, new);
-	rb_insert_color(&stable_node->node, &root_stable_tree[nid]);
+	rb_insert_color(&stable_node->node, root);
 
 	return stable_node;
 }
@@ -1325,7 +1332,7 @@ struct rmap_item *unstable_tree_search_i
 	int nid;
 
 	nid = get_kpfn_nid(page_to_pfn(page));
-	root = &root_unstable_tree[nid];
+	root = root_unstable_tree + nid;
 	new = &root->rb_node;
 
 	while (*new) {
@@ -1422,7 +1429,7 @@ static void cmp_and_merge_page(struct pa
 		if (stable_node->head != &migrate_nodes &&
 		    get_kpfn_nid(stable_node->kpfn) != NUMA(stable_node->nid)) {
 			rb_erase(&stable_node->node,
-				 &root_stable_tree[NUMA(stable_node->nid)]);
+				 root_stable_tree + NUMA(stable_node->nid));
 			stable_node->head = &migrate_nodes;
 			list_add(&stable_node->list, stable_node->head);
 		}
@@ -1574,7 +1581,7 @@ static struct rmap_item *scan_get_next_r
 			}
 		}
 
-		for (nid = 0; nid < nr_node_ids; nid++)
+		for (nid = 0; nid < ksm_nr_node_ids; nid++)
 			root_unstable_tree[nid] = RB_ROOT;
 
 		spin_lock(&ksm_mmlist_lock);
@@ -2094,8 +2101,8 @@ static void ksm_check_stable_tree(unsign
 	struct rb_node *node;
 	int nid;
 
-	for (nid = 0; nid < nr_node_ids; nid++) {
-		node = rb_first(&root_stable_tree[nid]);
+	for (nid = 0; nid < ksm_nr_node_ids; nid++) {
+		node = rb_first(root_stable_tree + nid);
 		while (node) {
 			stable_node = rb_entry(node, struct stable_node, node);
 			if (stable_node->kpfn >= start_pfn &&
@@ -2105,7 +2112,7 @@ static void ksm_check_stable_tree(unsign
 				 * which is why we keep kpfn instead of page*
 				 */
 				remove_node_from_stable_tree(stable_node);
-				node = rb_first(&root_stable_tree[nid]);
+				node = rb_first(root_stable_tree + nid);
 			} else
 				node = rb_next(node);
 			cond_resched();
@@ -2298,8 +2305,31 @@ static ssize_t merge_across_nodes_store(
 	if (ksm_merge_across_nodes != knob) {
 		if (ksm_pages_shared || remove_all_stable_nodes())
 			err = -EBUSY;
-		else
+		else if (root_stable_tree == one_stable_tree) {
+			struct rb_root *buf;
+			/*
+			 * This is the first time that we switch away from the
+			 * default of merging across nodes: must now allocate
+			 * a buffer to hold as many roots as may be needed.
+			 * Allocate stable and unstable together:
+			 * MAXSMP NODES_SHIFT 10 will use 16kB.
+			 */
+			buf = kcalloc(nr_node_ids + nr_node_ids,
+				sizeof(*buf), GFP_KERNEL | __GFP_ZERO);
+			/* Let us assume that RB_ROOT is NULL is zero */
+			if (!buf)
+				err = -ENOMEM;
+			else {
+				root_stable_tree = buf;
+				root_unstable_tree = buf + nr_node_ids;
+				/* Stable tree is empty but not the unstable */
+				root_unstable_tree[0] = one_unstable_tree[0];
+			}
+		}
+		if (!err) {
 			ksm_merge_across_nodes = knob;
+			ksm_nr_node_ids = knob ? 1 : nr_node_ids;
+		}
 	}
 	mutex_unlock(&ksm_thread_mutex);
 
@@ -2378,15 +2408,11 @@ static int __init ksm_init(void)
 {
 	struct task_struct *ksm_thread;
 	int err;
-	int nid;
 
 	err = ksm_slab_init();
 	if (err)
 		goto out;
 
-	for (nid = 0; nid < nr_node_ids; nid++)
-		root_stable_tree[nid] = RB_ROOT;
-
 	ksm_thread = kthread_run(ksm_scan_thread, NULL, "ksmd");
 	if (IS_ERR(ksm_thread)) {
 		printk(KERN_ERR "ksm: creating kthread failed\n");
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

