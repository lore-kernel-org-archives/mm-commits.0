From: akpm@linux-foundation.org
Subject: [merged] ksm-trivial-tidyups.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:53:50 -0800
Message-ID: <20130225205350.B78D85A4277@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:33110 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759804Ab3BYUxw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:53:52 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so347909vea.0
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:53:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, gerald.schaefer@de.ibm.com, izik.eidus@ravellosystems.com, kosaki.motohiro@gmail.com, pholasek@redhat.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: trivial tidyups
has been removed from the -mm tree.  Its filename was
     ksm-trivial-tidyups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: ksm: trivial tidyups

Add NUMA() and DO_NUMA() macros to minimize blight of #ifdef CONFIG_NUMAs
(but indeed we don't want to expand struct rmap_item by nid when not
NUMA).  Add comment, remove "unsigned" from rmap_item->nid, as "int nid"
elsewhere.  Define ksm_merge_across_nodes 1U when #ifndef NUMA to help
optimizing out.  Use ?: in get_kpfn_nid().  Adjust a few comments noticed
in ongoing work.

Leave stable_tree_insert()'s rb_linkage until after the node has been set
up, as unstable_tree_search_insert() does: ksm_thread_mutex and page lock
make either way safe, but we're going to copy and I prefer this precedent.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Petr Holasek <pholasek@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   48 ++++++++++++++++++++++--------------------------
 1 file changed, 22 insertions(+), 26 deletions(-)

diff -puN mm/ksm.c~ksm-trivial-tidyups mm/ksm.c
--- a/mm/ksm.c~ksm-trivial-tidyups
+++ a/mm/ksm.c
@@ -41,6 +41,14 @@
 #include <asm/tlbflush.h>
 #include "internal.h"
 
+#ifdef CONFIG_NUMA
+#define NUMA(x)		(x)
+#define DO_NUMA(x)	do { (x); } while (0)
+#else
+#define NUMA(x)		(0)
+#define DO_NUMA(x)	do { } while (0)
+#endif
+
 /*
  * A few notes about the KSM scanning process,
  * to make it easier to understand the data structures below:
@@ -130,6 +138,7 @@ struct stable_node {
  * @mm: the memory structure this rmap_item is pointing into
  * @address: the virtual address this rmap_item tracks (+ flags in low bits)
  * @oldchecksum: previous checksum of the page at that virtual address
+ * @nid: NUMA node id of unstable tree in which linked (may not match page)
  * @node: rb node of this rmap_item in the unstable tree
  * @head: pointer to stable_node heading this list in the stable tree
  * @hlist: link into hlist of rmap_items hanging off that stable_node
@@ -141,7 +150,7 @@ struct rmap_item {
 	unsigned long address;		/* + low bits used for flags below */
 	unsigned int oldchecksum;	/* when unstable */
 #ifdef CONFIG_NUMA
-	unsigned int nid;
+	int nid;
 #endif
 	union {
 		struct rb_node node;	/* when node of unstable tree */
@@ -192,8 +201,12 @@ static unsigned int ksm_thread_pages_to_
 /* Milliseconds ksmd should sleep between batches */
 static unsigned int ksm_thread_sleep_millisecs = 20;
 
+#ifdef CONFIG_NUMA
 /* Zeroed when merging across nodes is not allowed */
 static unsigned int ksm_merge_across_nodes = 1;
+#else
+#define ksm_merge_across_nodes	1U
+#endif
 
 #define KSM_RUN_STOP	0
 #define KSM_RUN_MERGE	1
@@ -456,10 +469,7 @@ out:		page = NULL;
  */
 static inline int get_kpfn_nid(unsigned long kpfn)
 {
-	if (ksm_merge_across_nodes)
-		return 0;
-	else
-		return pfn_to_nid(kpfn);
+	return ksm_merge_across_nodes ? 0 : pfn_to_nid(kpfn);
 }
 
 static void remove_node_from_stable_tree(struct stable_node *stable_node)
@@ -479,7 +489,6 @@ static void remove_node_from_stable_tree
 	}
 
 	nid = get_kpfn_nid(stable_node->kpfn);
-
 	rb_erase(&stable_node->node, &root_stable_tree[nid]);
 	free_stable_node(stable_node);
 }
@@ -578,13 +587,8 @@ static void remove_rmap_item_from_tree(s
 		age = (unsigned char)(ksm_scan.seqnr - rmap_item->address);
 		BUG_ON(age > 1);
 		if (!age)
-#ifdef CONFIG_NUMA
 			rb_erase(&rmap_item->node,
-					&root_unstable_tree[rmap_item->nid]);
-#else
-			rb_erase(&rmap_item->node, &root_unstable_tree[0]);
-#endif
-
+				 &root_unstable_tree[NUMA(rmap_item->nid)]);
 		ksm_pages_unshared--;
 		rmap_item->address &= PAGE_MASK;
 	}
@@ -604,7 +608,7 @@ static void remove_trailing_rmap_items(s
 }
 
 /*
- * Though it's very tempting to unmerge in_stable_tree(rmap_item)s rather
+ * Though it's very tempting to unmerge rmap_items from stable tree rather
  * than check every pte of a given vma, the locking doesn't quite work for
  * that - an rmap_item is assigned to the stable tree after inserting ksm
  * page and upping mmap_sem.  Nor does it fit with the way we skip dup'ing
@@ -1058,7 +1062,7 @@ static struct page *stable_tree_search(s
 }
 
 /*
- * stable_tree_insert - insert rmap_item pointing to new ksm page
+ * stable_tree_insert - insert stable tree node pointing to new ksm page
  * into the stable tree.
  *
  * This function returns the stable tree node just allocated on success,
@@ -1108,13 +1112,11 @@ static struct stable_node *stable_tree_i
 	if (!stable_node)
 		return NULL;
 
-	rb_link_node(&stable_node->node, parent, new);
-	rb_insert_color(&stable_node->node, &root_stable_tree[nid]);
-
 	INIT_HLIST_HEAD(&stable_node->hlist);
-
 	stable_node->kpfn = kpfn;
 	set_page_stable_node(kpage, stable_node);
+	rb_link_node(&stable_node->node, parent, new);
+	rb_insert_color(&stable_node->node, &root_stable_tree[nid]);
 
 	return stable_node;
 }
@@ -1170,8 +1172,6 @@ struct rmap_item *unstable_tree_search_i
 		 * If tree_page has been migrated to another NUMA node, it
 		 * will be flushed out and put into the right unstable tree
 		 * next time: only merge with it if merge_across_nodes.
-		 * Just notice, we don't have similar problem for PageKsm
-		 * because their migration is disabled now. (62b61f611e)
 		 */
 		if (!ksm_merge_across_nodes && page_to_nid(tree_page) != nid) {
 			put_page(tree_page);
@@ -1195,9 +1195,7 @@ struct rmap_item *unstable_tree_search_i
 
 	rmap_item->address |= UNSTABLE_FLAG;
 	rmap_item->address |= (ksm_scan.seqnr & SEQNR_MASK);
-#ifdef CONFIG_NUMA
-	rmap_item->nid = nid;
-#endif
+	DO_NUMA(rmap_item->nid = nid);
 	rb_link_node(&rmap_item->node, parent, new);
 	rb_insert_color(&rmap_item->node, root);
 
@@ -1213,13 +1211,11 @@ struct rmap_item *unstable_tree_search_i
 static void stable_tree_append(struct rmap_item *rmap_item,
 			       struct stable_node *stable_node)
 {
-#ifdef CONFIG_NUMA
 	/*
 	 * Usually rmap_item->nid is already set correctly,
 	 * but it may be wrong after switching merge_across_nodes.
 	 */
-	rmap_item->nid = get_kpfn_nid(stable_node->kpfn);
-#endif
+	DO_NUMA(rmap_item->nid = get_kpfn_nid(stable_node->kpfn));
 	rmap_item->head = stable_node;
 	rmap_item->address |= STABLE_FLAG;
 	hlist_add_head(&rmap_item->hlist, &stable_node->hlist);
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit.patch
pageattr-prevent-pse-and-gloabl-leftovers-to-confuse-pmd-pte_present-and-pmd_huge.patch
mm-accelerate-munlock-treatment-of-thp-pages.patch

