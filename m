Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CDB21CC54
	for <mm-commits@vger.kernel.org>; Wed, 26 Feb 2025 21:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740604472; cv=none; b=ENgKac12/NuiNCTpk9z0u88uA3XgwcRXHszPCvov0DKjp6f1J8VeZTo53fFAraMGPOiKI5akvi1SjdTM2/5XqC4cfeDEXN5p8CzYLss7kYVNP0g/byBn0EEXwsPtCI1/ZGufYvg2ns9mMMLEX0+tQYA61YbeW1QMzgIJMNIHtKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740604472; c=relaxed/simple;
	bh=P/HE6/Osuxky89Z6y1TU81WSZQRuPXFXKKul6EQRd3k=;
	h=Date:To:From:Subject:Message-Id; b=gqFAWLsCukfgD0W4nGKQ3T2FYD0dustsX9nE/YVJjxmYlF1hXloRJgLSayNhl4OkW3ZQw1aYgOv6UoefTw8thghXrCDFwR8Btw9wh519eaPyS7R/pSqW3B8RXgOcC83WlRYO27nHPOJbDlGLsa0MFDf3J4X0nKNdp/Rq2vhPBE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rjzDbbEc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rjzDbbEc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2B9C4CED6;
	Wed, 26 Feb 2025 21:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740604471;
	bh=P/HE6/Osuxky89Z6y1TU81WSZQRuPXFXKKul6EQRd3k=;
	h=Date:To:From:Subject:From;
	b=rjzDbbEccpYFn2pnkV9BYxYDNGmG5rd19MNUfXjYmiWEqs+OxkExGArPXmfv0WgwI
	 +RXawc3waL9S2sEAUZ8HCFBSBUM4cP3KZYJsWgoOwiTM1T7xy1fPAMqClrLVDpcU/2
	 g6JQdJR6jqtl0i3QGAmtKuel1ExYovYIKOs9lsEY=
Date: Wed, 26 Feb 2025 13:14:30 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yang@os.amperecomputing.com,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,linmiaohe@huawei.com,kirill.shutemov@linux.intel.com,kasong@tencent.com,jhubbard@nvidia.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xarray-add-xas_try_split-to-split-a-multi-index-entry.patch added to mm-unstable branch
Message-Id: <20250226211431.2A2B9C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xarray: add xas_try_split() to split a multi-index entry
has been added to the -mm mm-unstable branch.  Its filename is
     xarray-add-xas_try_split-to-split-a-multi-index-entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xarray-add-xas_try_split-to-split-a-multi-index-entry.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: xarray: add xas_try_split() to split a multi-index entry
Date: Wed, 26 Feb 2025 16:00:24 -0500

Patch series "Buddy allocator like (or non-uniform) folio split", v9.

This patchset adds a new buddy allocator like (or non-uniform) large folio
split from a order-n folio to order-m with m < n.  It reduces

1. the total number of after-split folios from 2^(n-m) to n-m+1;

2. the amount of memory needed for multi-index xarray split from 2^(n/6-m/6) to
   n/6-m/6, assuming XA_CHUNK_SHIFT=6;

3. keep more large folios after a split from all order-m folios to
   order-(n-1) to order-m folios.

For example, to split an order-9 to order-0, folio split generates 10 (or
11 for anonymous memory) folios instead of 512, allocates 1 xa_node
instead of 8, and leaves 1 order-8, 1 order-7, ..., 1 order-1 and 2
order-0 folios (or 4 order-0 for anonymous memory) instead of 512 order-0
folios.

Instead of duplicating existing split_huge_page*() code, __folio_split()
is introduced as the shared backend code for both
split_huge_page_to_list_to_order() and folio_split().  __folio_split() can
support both uniform split and buddy allocator like (or non-uniform)
split.  All existing split_huge_page*() users can be gradually converted
to use folio_split() if possible.  In this patchset, I converted
truncate_inode_partial_folio() to use folio_split().


This patch (of 8):

A preparation patch for non-uniform folio split, which always split a
folio into half iteratively, and minimal xarray entry split.

Currently, xas_split_alloc() and xas_split() always split all slots from a
multi-index entry.  They cost the same number of xa_node as the
to-be-split slots.  For example, to split an order-9 entry, which takes
2^(9-6)=8 slots, assuming XA_CHUNK_SHIFT is 6 (!CONFIG_BASE_SMALL), 8
xa_node are needed.  Instead xas_try_split() is intended to be used
iteratively to split the order-9 entry into 2 order-8 entries, then split
one order-8 entry, based on the given index, to 2 order-7 entries, ...,
and split one order-1 entry to 2 order-0 entries.  When splitting the
order-6 entry and a new xa_node is needed, xas_try_split() will try to
allocate one if possible.  As a result, xas_try_split() would only need
one xa_node instead of 8.

When a new xa_node is needed during the split, xas_try_split() can try to
allocate one but no more.  -ENOMEM will be return if a node cannot be
allocated.  -EINVAL will be return if a sibling node is split or cascade
split happens, where two or more new nodes are needed, and these are not
supported by xas_try_split().

xas_split_alloc() and xas_split() split an order-9 to order-0:

         ---------------------------------
         |   |   |   |   |   |   |   |   |
         | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
         |   |   |   |   |   |   |   |   |
         ---------------------------------
           |   |                   |   |
     -------   ---               ---   -------
     |           |     ...       |           |
     V           V               V           V
----------- -----------     ----------- -----------
| xa_node | | xa_node | ... | xa_node | | xa_node |
----------- -----------     ----------- -----------

xas_try_split() splits an order-9 to order-0:
   ---------------------------------
   |   |   |   |   |   |   |   |   |
   | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
   |   |   |   |   |   |   |   |   |
   ---------------------------------
     |
     |
     V
-----------
| xa_node |
-----------

Link: https://lkml.kernel.org/r/20250226210032.2044041-1-ziy@nvidia.com
Link: https://lkml.kernel.org/r/20250226210032.2044041-2-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/xarray.rst |   14 ++
 include/linux/xarray.h            |    6 +
 lib/test_xarray.c                 |   52 +++++++++++
 lib/xarray.c                      |  131 +++++++++++++++++++++++++---
 tools/testing/radix-tree/Makefile |    1 
 5 files changed, 191 insertions(+), 13 deletions(-)

--- a/Documentation/core-api/xarray.rst~xarray-add-xas_try_split-to-split-a-multi-index-entry
+++ a/Documentation/core-api/xarray.rst
@@ -489,7 +489,19 @@ Storing ``NULL`` into any index of a mul
 entry at every index to ``NULL`` and dissolve the tie.  A multi-index
 entry can be split into entries occupying smaller ranges by calling
 xas_split_alloc() without the xa_lock held, followed by taking the lock
-and calling xas_split().
+and calling xas_split() or calling xas_try_split() with xa_lock. The
+difference between xas_split_alloc()+xas_split() and xas_try_alloc() is
+that xas_split_alloc() + xas_split() split the entry from the original
+order to the new order in one shot uniformly, whereas xas_try_split()
+iteratively splits the entry containing the index non-uniformly.
+For example, to split an order-9 entry, which takes 2^(9-6)=8 slots,
+assuming ``XA_CHUNK_SHIFT`` is 6, xas_split_alloc() + xas_split() need
+8 xa_node. xas_try_split() splits the order-9 entry into
+2 order-8 entries, then split one order-8 entry, based on the given index,
+to 2 order-7 entries, ..., and split one order-1 entry to 2 order-0 entries.
+When splitting the order-6 entry and a new xa_node is needed, xas_try_split()
+will try to allocate one if possible. As a result, xas_try_split() would only
+need 1 xa_node instead of 8.
 
 Functions and structures
 ========================
--- a/include/linux/xarray.h~xarray-add-xas_try_split-to-split-a-multi-index-entry
+++ a/include/linux/xarray.h
@@ -1555,6 +1555,7 @@ int xa_get_order(struct xarray *, unsign
 int xas_get_order(struct xa_state *xas);
 void xas_split(struct xa_state *, void *entry, unsigned int order);
 void xas_split_alloc(struct xa_state *, void *entry, unsigned int order, gfp_t);
+void xas_try_split(struct xa_state *xas, void *entry, unsigned int order);
 #else
 static inline int xa_get_order(struct xarray *xa, unsigned long index)
 {
@@ -1576,6 +1577,11 @@ static inline void xas_split_alloc(struc
 		unsigned int order, gfp_t gfp)
 {
 }
+
+static inline void xas_try_split(struct xa_state *xas, void *entry,
+		unsigned int order)
+{
+}
 #endif
 
 /**
--- a/lib/test_xarray.c~xarray-add-xas_try_split-to-split-a-multi-index-entry
+++ a/lib/test_xarray.c
@@ -1858,6 +1858,54 @@ static void check_split_1(struct xarray
 	xa_destroy(xa);
 }
 
+static void check_split_2(struct xarray *xa, unsigned long index,
+				unsigned int order, unsigned int new_order)
+{
+	XA_STATE_ORDER(xas, xa, index, new_order);
+	unsigned int i, found;
+	void *entry;
+
+	xa_store_order(xa, index, order, xa, GFP_KERNEL);
+	xa_set_mark(xa, index, XA_MARK_1);
+
+	/* allocate a node for xas_try_split() */
+	xas_set_err(&xas, -ENOMEM);
+	XA_BUG_ON(xa, !xas_nomem(&xas, GFP_KERNEL));
+
+	xas_lock(&xas);
+	xas_try_split(&xas, xa, order);
+	if (((new_order / XA_CHUNK_SHIFT) < (order / XA_CHUNK_SHIFT)) &&
+	    new_order < order - 1) {
+		XA_BUG_ON(xa, !xas_error(&xas) || xas_error(&xas) != -EINVAL);
+		xas_unlock(&xas);
+		goto out;
+	}
+	for (i = 0; i < (1 << order); i += (1 << new_order))
+		__xa_store(xa, index + i, xa_mk_index(index + i), 0);
+	xas_unlock(&xas);
+
+	for (i = 0; i < (1 << order); i++) {
+		unsigned int val = index + (i & ~((1 << new_order) - 1));
+		XA_BUG_ON(xa, xa_load(xa, index + i) != xa_mk_index(val));
+	}
+
+	xa_set_mark(xa, index, XA_MARK_0);
+	XA_BUG_ON(xa, !xa_get_mark(xa, index, XA_MARK_0));
+
+	xas_set_order(&xas, index, 0);
+	found = 0;
+	rcu_read_lock();
+	xas_for_each_marked(&xas, entry, ULONG_MAX, XA_MARK_1) {
+		found++;
+		XA_BUG_ON(xa, xa_is_internal(entry));
+	}
+	rcu_read_unlock();
+	XA_BUG_ON(xa, found != 1 << (order - new_order));
+out:
+	xas_destroy(&xas);
+	xa_destroy(xa);
+}
+
 static noinline void check_split(struct xarray *xa)
 {
 	unsigned int order, new_order;
@@ -1869,6 +1917,10 @@ static noinline void check_split(struct
 			check_split_1(xa, 0, order, new_order);
 			check_split_1(xa, 1UL << order, order, new_order);
 			check_split_1(xa, 3UL << order, order, new_order);
+
+			check_split_2(xa, 0, order, new_order);
+			check_split_2(xa, 1UL << order, order, new_order);
+			check_split_2(xa, 3UL << order, order, new_order);
 		}
 	}
 }
--- a/lib/xarray.c~xarray-add-xas_try_split-to-split-a-multi-index-entry
+++ a/lib/xarray.c
@@ -1007,6 +1007,26 @@ static void node_set_marks(struct xa_nod
 	}
 }
 
+static void __xas_init_node_for_split(struct xa_state *xas,
+		struct xa_node *node, void *entry)
+{
+	unsigned int i;
+	void *sibling = NULL;
+	unsigned int mask = xas->xa_sibs;
+
+	if (!node)
+		return;
+	node->array = xas->xa;
+	for (i = 0; i < XA_CHUNK_SIZE; i++) {
+		if ((i & mask) == 0) {
+			RCU_INIT_POINTER(node->slots[i], entry);
+			sibling = xa_mk_sibling(i);
+		} else {
+			RCU_INIT_POINTER(node->slots[i], sibling);
+		}
+	}
+}
+
 /**
  * xas_split_alloc() - Allocate memory for splitting an entry.
  * @xas: XArray operation state.
@@ -1025,7 +1045,6 @@ void xas_split_alloc(struct xa_state *xa
 		gfp_t gfp)
 {
 	unsigned int sibs = (1 << (order % XA_CHUNK_SHIFT)) - 1;
-	unsigned int mask = xas->xa_sibs;
 
 	/* XXX: no support for splitting really large entries yet */
 	if (WARN_ON(xas->xa_shift + 2 * XA_CHUNK_SHIFT <= order))
@@ -1034,22 +1053,13 @@ void xas_split_alloc(struct xa_state *xa
 		return;
 
 	do {
-		unsigned int i;
-		void *sibling = NULL;
 		struct xa_node *node;
 
 		node = kmem_cache_alloc_lru(radix_tree_node_cachep, xas->xa_lru, gfp);
 		if (!node)
 			goto nomem;
-		node->array = xas->xa;
-		for (i = 0; i < XA_CHUNK_SIZE; i++) {
-			if ((i & mask) == 0) {
-				RCU_INIT_POINTER(node->slots[i], entry);
-				sibling = xa_mk_sibling(i);
-			} else {
-				RCU_INIT_POINTER(node->slots[i], sibling);
-			}
-		}
+
+		__xas_init_node_for_split(xas, node, entry);
 		RCU_INIT_POINTER(node->parent, xas->xa_alloc);
 		xas->xa_alloc = node;
 	} while (sibs-- > 0);
@@ -1122,6 +1132,103 @@ void xas_split(struct xa_state *xas, voi
 	xas_update(xas, node);
 }
 EXPORT_SYMBOL_GPL(xas_split);
+
+/**
+ * xas_try_split() - Try to split a multi-index entry.
+ * @xas: XArray operation state.
+ * @entry: New entry to store in the array.
+ * @order: Current entry order.
+ *
+ * The size of the new entries is set in @xas.  The value in @entry is
+ * copied to all the replacement entries. If and only if one new xa_node is
+ * needed, the function will use GFP_NOWAIT to get one if xas->xa_alloc is
+ * NULL. If more new xa_node are needed, the function gives EINVAL error.
+ *
+ * Context: Any context.  The caller should hold the xa_lock.
+ */
+void xas_try_split(struct xa_state *xas, void *entry, unsigned int order)
+{
+	unsigned int sibs = (1 << (order % XA_CHUNK_SHIFT)) - 1;
+	unsigned int offset, marks;
+	struct xa_node *node;
+	void *curr = xas_load(xas);
+	int values = 0;
+	gfp_t gfp = GFP_NOWAIT;
+
+	node = xas->xa_node;
+	if (xas_top(node))
+		return;
+
+	if (xas->xa->xa_flags & XA_FLAGS_ACCOUNT)
+		gfp |= __GFP_ACCOUNT;
+
+	marks = node_get_marks(node, xas->xa_offset);
+
+	offset = xas->xa_offset + sibs;
+
+	if (xas->xa_shift < node->shift) {
+		struct xa_node *child = xas->xa_alloc;
+		unsigned int expected_sibs =
+			(1 << ((order - 1) % XA_CHUNK_SHIFT)) - 1;
+
+		/*
+		 * No support for splitting sibling entries
+		 * (horizontally) or cascade split (vertically), which
+		 * requires two or more new xa_nodes.
+		 * Since if one xa_node allocation fails,
+		 * it is hard to free the prior allocations.
+		 */
+		if (sibs || xas->xa_sibs != expected_sibs) {
+			xas_destroy(xas);
+			xas_set_err(xas, -EINVAL);
+			return;
+		}
+
+		if (!child) {
+			child = kmem_cache_alloc_lru(radix_tree_node_cachep,
+						     xas->xa_lru, gfp);
+			if (!child) {
+				xas_destroy(xas);
+				xas_set_err(xas, -ENOMEM);
+				return;
+			}
+			RCU_INIT_POINTER(child->parent, xas->xa_alloc);
+		}
+		__xas_init_node_for_split(xas, child, entry);
+
+		xas->xa_alloc = rcu_dereference_raw(child->parent);
+		child->shift = node->shift - XA_CHUNK_SHIFT;
+		child->offset = offset;
+		child->count = XA_CHUNK_SIZE;
+		child->nr_values = xa_is_value(entry) ?
+				XA_CHUNK_SIZE : 0;
+		RCU_INIT_POINTER(child->parent, node);
+		node_set_marks(node, offset, child, xas->xa_sibs,
+				marks);
+		rcu_assign_pointer(node->slots[offset],
+				xa_mk_node(child));
+		if (xa_is_value(curr))
+			values--;
+		xas_update(xas, child);
+
+	} else {
+		do {
+			unsigned int canon = offset - xas->xa_sibs;
+
+			node_set_marks(node, canon, NULL, 0, marks);
+			rcu_assign_pointer(node->slots[canon], entry);
+			while (offset > canon)
+				rcu_assign_pointer(node->slots[offset--],
+						xa_mk_sibling(canon));
+			values += (xa_is_value(entry) - xa_is_value(curr)) *
+					(xas->xa_sibs + 1);
+		} while (offset-- > xas->xa_offset);
+	}
+
+	node->nr_values += values;
+	xas_update(xas, node);
+}
+EXPORT_SYMBOL_GPL(xas_try_split);
 #endif
 
 /**
--- a/tools/testing/radix-tree/Makefile~xarray-add-xas_try_split-to-split-a-multi-index-entry
+++ a/tools/testing/radix-tree/Makefile
@@ -14,6 +14,7 @@ include ../shared/shared.mk
 
 main:	$(OFILES)
 
+xarray.o: ../../../lib/test_xarray.c
 idr-test.o: ../../../lib/test_ida.c
 idr-test: idr-test.o $(CORE_OFILES)
 
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-make-file-backed-thp-split-work-by-writing-pmd-size-data.patch
mm-huge_memory-allow-split-shmem-large-folio-to-any-lower-order.patch
selftests-mm-test-splitting-file-backed-thp-to-any-lower-order.patch
xarray-add-xas_try_split-to-split-a-multi-index-entry.patch
mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split.patch
mm-huge_memory-move-folio-split-common-code-to-__folio_split.patch
mm-huge_memory-add-buddy-allocator-like-non-uniform-folio_split.patch
mm-huge_memory-remove-the-old-unused-__split_huge_page.patch
mm-huge_memory-add-folio_split-to-debugfs-testing-interface.patch
mm-truncate-use-buddy-allocator-like-folio-split-for-truncate-operation.patch
selftests-mm-add-tests-for-folio_split-buddy-allocator-like-split.patch
mm-filemap-use-xas_try_split-in-__filemap_add_folio.patch
mm-shmem-use-xas_try_split-in-shmem_split_large_entry.patch
mm-shmem-use-xas_try_split-in-shmem_split_large_entry-fix.patch

