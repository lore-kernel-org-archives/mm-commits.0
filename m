From: akpm@linux-foundation.org
Subject: +
 reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr.patch added to -mm tree
Date: Fri, 16 Dec 2016 13:40:42 -0800
Message-ID: <58545f5a.i27O/TobdvCKdhdX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35268 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933002AbcLPVjt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2016 16:39:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mawilcox@microsoft.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: idr: support storing NULL in the IDR
has been added to the -mm tree.  Its filename is
     reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: idr: support storing NULL in the IDR

The radix tree interprets storing NULL as a deleted entry.  Several users
of the IDR API use NULL as a temporary placeholder, or intentionally
convert entries between NULL and non-NULL pointers to keep IDs reserved
but not necessarily pointing to a valid entry at any given moment.  Adapt
the radix tree to cope with NULL pointers when being used as an IDR.

Link: http://lkml.kernel.org/r/1481931156-23469-1-git-send-email-mawilcox@linuxonhyperv.com
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c                           |    7 +--
 lib/radix-tree.c                    |   26 +++++++++-----
 tools/testing/radix-tree/idr-test.c |   46 +++++++++++++++++++++++++-
 3 files changed, 65 insertions(+), 14 deletions(-)

diff -puN lib/idr.c~reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr lib/idr.c
--- a/lib/idr.c~reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr
+++ a/lib/idr.c
@@ -148,17 +148,16 @@ EXPORT_SYMBOL(idr_get_next);
 void *idr_replace(struct idr *idr, void *ptr, int id)
 {
 	struct radix_tree_node *node;
-	void **slot;
+	void **slot = NULL;
 	void *entry;
 
 	if (id < 0)
 		return ERR_PTR(-EINVAL);
-	if (!ptr || radix_tree_is_internal_node(ptr))
+	if (radix_tree_is_internal_node(ptr))
 		return ERR_PTR(-EINVAL);
 
 	entry = __radix_tree_lookup(&idr->idr_rt, id, &node, &slot);
-
-	if (!entry)
+	if (!slot || radix_tree_tag_get(&idr->idr_rt, id, IDR_FREE))
 		return ERR_PTR(-ENOENT);
 
 	__radix_tree_replace(&idr->idr_rt, node, slot, ptr, NULL, NULL);
diff -puN lib/radix-tree.c~reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr lib/radix-tree.c
--- a/lib/radix-tree.c~reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr
+++ a/lib/radix-tree.c
@@ -604,7 +604,7 @@ static int radix_tree_extend(struct radi
 		maxshift += RADIX_TREE_MAP_SHIFT;
 
 	slot = root->rnode;
-	if (!slot)
+	if (!slot && (!is_idr(root) || root_tag_get(root, IDR_FREE)))
 		goto out;
 
 	do {
@@ -615,9 +615,10 @@ static int radix_tree_extend(struct radi
 
 		if (is_idr(root)) {
 			all_tag_set(node, IDR_FREE);
-			if (!root_tag_get(root, IDR_FREE))
+			if (!root_tag_get(root, IDR_FREE)) {
 				tag_clear(node, IDR_FREE, 0);
-			root_tag_set(root, IDR_FREE);
+				root_tag_set(root, IDR_FREE);
+			}
 		} else {
 			/* Propagate the aggregated tag info to the new child */
 			for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++) {
@@ -1081,7 +1082,11 @@ static void replace_slot(struct radix_tr
 
 	WARN_ON_ONCE(radix_tree_is_internal_node(item));
 
-	count = !!item - !!old;
+	/* NULL is a valid entry in an IDR; do not adjust count */
+	if (is_idr(root))
+		count = 0;
+	else
+		count = !!item - !!old;
 	exceptional = !!radix_tree_exceptional_entry(item) -
 		      !!radix_tree_exceptional_entry(old);
 
@@ -1188,6 +1193,8 @@ void radix_tree_replace_slot(struct radi
 void radix_tree_iter_replace(struct radix_tree_root *root,
 		const struct radix_tree_iter *iter, void **slot, void *item)
 {
+	if (is_idr(root) && iter->node)
+		iter->node->count++;
 	__radix_tree_replace(root, iter->node, slot, item, NULL, NULL);
 }
 
@@ -1511,8 +1518,6 @@ int radix_tree_tag_get(struct radix_tree
 		parent = entry_to_node(node);
 		offset = radix_tree_descend(parent, &node, index);
 
-		if (!node)
-			return 0;
 		if (!tag_get(parent, tag, offset))
 			return 0;
 		if (node == RADIX_TREE_RETRY)
@@ -1964,7 +1969,7 @@ void *radix_tree_delete_item(struct radi
 	int tag;
 
 	entry = __radix_tree_lookup(root, index, &node, &slot);
-	if (!entry)
+	if (!entry && !is_idr(root))
 		return NULL;
 
 	if (item && entry != item)
@@ -1981,9 +1986,12 @@ void *radix_tree_delete_item(struct radi
 
 	offset = get_slot_offset(node, slot);
 
-	if (is_idr(root))
+	if (is_idr(root)) {
+		if (tag_get(node, IDR_FREE, offset))
+			return entry;
 		node_tag_set(root, node, IDR_FREE, offset);
-	else
+		node->count--;
+	} else
 		for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++)
 			node_tag_clear(root, node, tag, offset);
 
diff -puN tools/testing/radix-tree/idr-test.c~reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr tools/testing/radix-tree/idr-test.c
--- a/tools/testing/radix-tree/idr-test.c~reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr
+++ a/tools/testing/radix-tree/idr-test.c
@@ -74,6 +74,48 @@ void idr_replace_test(void)
 	idr_destroy(&idr);
 }
 
+/*
+ * Unlike the radix tree, you can put a NULL pointer -- with care -- into
+ * the IDR.  Some interfaces, like idr_find() do not distinguish between
+ * "present, value is NULL" and "not present", but that's exactly what some
+ * users want.
+ */
+void idr_null_test(void)
+{
+	int i;
+	DEFINE_IDR(idr);
+
+	for (i = 0; i < 10; i++) {
+		assert(idr_alloc(&idr, NULL, 0, 0, GFP_KERNEL) == i);
+	}
+
+	assert(idr_replace(&idr, DUMMY_PTR, 3) == NULL);
+	assert(idr_replace(&idr, DUMMY_PTR, 4) == NULL);
+	assert(idr_replace(&idr, NULL, 4) == DUMMY_PTR);
+	assert(idr_replace(&idr, DUMMY_PTR, 11) == ERR_PTR(-ENOENT));
+	idr_remove(&idr, 5);
+	assert(idr_alloc(&idr, NULL, 0, 0, GFP_KERNEL) == 5);
+	idr_remove(&idr, 5);
+
+	for (i = 0; i < 10; i++)
+		idr_remove(&idr, i);
+	assert(idr_is_empty(&idr));
+
+	assert(idr_alloc(&idr, NULL, 0, 0, GFP_KERNEL) == 0);
+	assert(idr_replace(&idr, DUMMY_PTR, 3) == ERR_PTR(-ENOENT));
+	assert(idr_replace(&idr, DUMMY_PTR, 0) == NULL);
+	assert(idr_replace(&idr, NULL, 0) == DUMMY_PTR);
+
+	idr_destroy(&idr);
+	assert(idr_is_empty(&idr));
+
+	for (i = 1; i < 10; i++) {
+		assert(idr_alloc(&idr, NULL, 1, 0, GFP_KERNEL) == i);
+	}
+
+	idr_destroy(&idr);
+}
+
 void idr_checks(void)
 {
 	unsigned long i;
@@ -112,8 +154,8 @@ void idr_checks(void)
 	idr_destroy(&idr);
 
 	idr_replace_test();
-
 	idr_alloc_test();
+	idr_null_test();
 }
 
 /*
@@ -176,10 +218,12 @@ void ida_checks(void)
 	ida_remove(&ida, id);
 	assert(ida_is_empty(&ida));
 	ida_destroy(&ida);
+	assert(ida_is_empty(&ida));
 
 	ida_pre_get(&ida, GFP_KERNEL);
 	ida_get_new_above(&ida, 1, &id);
 	ida_destroy(&ida);
+	assert(ida_is_empty(&ida));
 
 	for (j = 1; j < 65537; j *= 2) {
 		for (i = 0; i < j; i++) {
_

Patches currently in -mm which might be from mawilcox@microsoft.com are

radix-tree-test-suite-fix-compilation.patch
reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr.patch

