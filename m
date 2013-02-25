From: akpm@linux-foundation.org
Subject: [merged] ksm-allocate-roots-when-needed.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:56:17 -0800
Message-ID: <20130225205617.B7D8531C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:38396 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756292Ab3BYU4T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:56:19 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so347820vcd.3
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:56:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, hannes@cmpxchg.org, izik.eidus@ravellosystems.com, mgorman@suse.de, pholasek@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: allocate roots when needed
has been removed from the -mm tree.  Its filename was
     ksm-allocate-roots-when-needed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
