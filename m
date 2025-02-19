Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8758D2BAF4
	for <mm-commits@vger.kernel.org>; Wed, 19 Feb 2025 01:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739927444; cv=none; b=XRYDlQ1gPvdAz5wBfCMAwvPL4gWqT+eQmt5yeX1fWC8HYwFYGMT08dD+JmLDgKkwmiAjFYI+QKweI/EuJN4iorC8/DEHFp85YHhHZLMhYZw/PqLN0AvZKdwOFd5wDle/3wKqVawQtEhSc0oevodYvghsEn/HsFW1UhIHGi947Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739927444; c=relaxed/simple;
	bh=pzk21uwQjzQUEA1iQOmIuwQXhmhs//rsw/hfkdd2EDo=;
	h=Date:To:From:Subject:Message-Id; b=PbTZ2KljTkSBJR0EOEAiYk2Tf/Lna2V2ZKVCLfQQ+KR4TUwZCZbbj4pqu8KKaoXucyv9WxqI0Txy1v2+BdfP7FBmDRvOJrjrONTmo6dku/tsEYgPZo3ePNPFwz7LniZ5Eh1XvJvfK7q92esH5dQ+loA9YUPtDqyy6JkbBQRwYLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mgfhLbTC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mgfhLbTC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E0AC4CEE2;
	Wed, 19 Feb 2025 01:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739927444;
	bh=pzk21uwQjzQUEA1iQOmIuwQXhmhs//rsw/hfkdd2EDo=;
	h=Date:To:From:Subject:From;
	b=mgfhLbTCIKQEmKwTY/8AZLYaia7njGZZ0n/sWM3pNbIO4lZdHjvGl7/zms0vtBFuD
	 edX+x3EoWPNdOa/C1dXSYIHt36HWhZAW8wEi6hTltmqhQf6bfQjTozXxeYub3mq5Rt
	 hYMX5TS3O4v4W4biFBVt0N5OkXTjodVIaroSgJxE=
Date: Tue, 18 Feb 2025 17:10:43 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yang@os.amperecomputing.com,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,linmiaohe@huawei.com,kirill.shutemov@linux.intel.com,kasong@tencent.com,jhubbard@nvidia.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-use-xas_try_split-in-__filemap_add_folio.patch added to mm-unstable branch
Message-Id: <20250219011044.52E0AC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/filemap: use xas_try_split() in __filemap_add_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-filemap-use-xas_try_split-in-__filemap_add_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-use-xas_try_split-in-__filemap_add_folio.patch

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
Subject: mm/filemap: use xas_try_split() in __filemap_add_folio()
Date: Tue, 18 Feb 2025 18:54:43 -0500

Patch series "Minimize xa_node allocation during xarry split", v2.

When splitting a multi-index entry in XArray from order-n to order-m,
existing xas_split_alloc()+xas_split() approach requires 2^(n %
XA_CHUNK_SHIFT) xa_node allocations.  But its callers,
__filemap_add_folio() and shmem_split_large_entry(), use at most 1
xa_node.  To minimize xa_node allocation and remove the limitation of no
split from order-12 (or above) to order-0 (or anything between 0 and
5)[1], xas_try_split() was added[2], which allocates (n / XA_CHUNK_SHIFT -
m / XA_CHUNK_SHIFT) xa_node.  It is used for non-uniform folio split, but
can be used by __filemap_add_folio() and shmem_split_large_entry().

It is a resend on top of Buddy allocator like (or non-uniform) folio split
V8[3], which is on top of mm-everything-2025-02-15-05-49.

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

xas_try_split() is designed to be called iteratively with n = m + 1. 
xas_try_split_mini_order() is added to minmize the number of calls to
xas_try_split() by telling the caller the next minimal order to split to
instead of n - 1.  Splitting order-n to order-m when m= l * XA_CHUNK_SHIFT
does not require xa_node allocation and requires 1 xa_node when n=l *
XA_CHUNK_SHIFT and m = n - 1, so it is OK to use xas_try_split() with n >
m + 1 when no new xa_node is needed.

xfstests quick group test passed on xfs and tmpfs.

[1] https://lore.kernel.org/linux-mm/Z6YX3RznGLUD07Ao@casper.infradead.org/
[2] https://lore.kernel.org/linux-mm/20250211155034.268962-2-ziy@nvidia.com/
[3] https://lore.kernel.org/linux-mm/20250218235012.1542225-1-ziy@nvidia.com/


This patch (of 2):

During __filemap_add_folio(), a shadow entry is covering n slots and a
folio covers m slots with m < n is to be added.  Instead of splitting all
n slots, only the m slots covered by the folio need to be split and the
remaining n-m shadow entries can be retained with orders ranging from m to
n-1.  This method only requires

	(n/XA_CHUNK_SHIFT) - (m/XA_CHUNK_SHIFT)

new xa_nodes instead of
	(n % XA_CHUNK_SHIFT) * ((n/XA_CHUNK_SHIFT) - (m/XA_CHUNK_SHIFT))

new xa_nodes, compared to the original xas_split_alloc() + xas_split()
one.  For example, to insert an order-0 folio when an order-9 shadow entry
is present (assuming XA_CHUNK_SHIFT is 6), 1 xa_node is needed instead of
8.

xas_try_split_min_order() is introduced to reduce the number of calls to
xas_try_split() during split.

Link: https://lkml.kernel.org/r/20250218235444.1543173-1-ziy@nvidia.com
Link: https://lkml.kernel.org/r/20250218235444.1543173-2-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mattew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/xarray.h |    7 +++++
 lib/xarray.c           |   25 +++++++++++++++++++++
 mm/filemap.c           |   46 ++++++++++++++++-----------------------
 3 files changed, 51 insertions(+), 27 deletions(-)

--- a/include/linux/xarray.h~mm-filemap-use-xas_try_split-in-__filemap_add_folio
+++ a/include/linux/xarray.h
@@ -1557,6 +1557,7 @@ void xas_split(struct xa_state *, void *
 void xas_split_alloc(struct xa_state *, void *entry, unsigned int order, gfp_t);
 void xas_try_split(struct xa_state *xas, void *entry, unsigned int order,
 		gfp_t gfp);
+unsigned int xas_try_split_min_order(unsigned int order);
 #else
 static inline int xa_get_order(struct xarray *xa, unsigned long index)
 {
@@ -1583,6 +1584,12 @@ static inline void xas_try_split(struct
 		unsigned int order, gfp_t gfp)
 {
 }
+
+static inline unsigned int xas_try_split_min_order(unsigned int order)
+{
+	return 0;
+}
+
 #endif
 
 /**
--- a/lib/xarray.c~mm-filemap-use-xas_try_split-in-__filemap_add_folio
+++ a/lib/xarray.c
@@ -1134,6 +1134,28 @@ void xas_split(struct xa_state *xas, voi
 EXPORT_SYMBOL_GPL(xas_split);
 
 /**
+ * xas_try_split_min_order() - Minimal split order xas_try_split() can accept
+ * @order: Current entry order.
+ *
+ * xas_try_split() can split a multi-index entry to smaller than @order - 1 if
+ * no new xa_node is needed. This function provides the minimal order
+ * xas_try_split() supports.
+ *
+ * Return: the minimal order xas_try_split() supports
+ *
+ * Context: Any context.
+ *
+ */
+unsigned int xas_try_split_min_order(unsigned int order)
+{
+	if (order % XA_CHUNK_SHIFT == 0)
+		return order == 0 ? 0 : order - 1;
+
+	return order - (order % XA_CHUNK_SHIFT);
+}
+EXPORT_SYMBOL_GPL(xas_try_split_min_order);
+
+/**
  * xas_try_split() - Try to split a multi-index entry.
  * @xas: XArray operation state.
  * @entry: New entry to store in the array.
@@ -1145,6 +1167,9 @@ EXPORT_SYMBOL_GPL(xas_split);
  * be allocated, the function will use @gfp to get one. If more xa_node are
  * needed, the function gives EINVAL error.
  *
+ * NOTE: use xas_try_split_min_order() to get next split order instead of
+ * @order - 1 if you want to minmize xas_try_split() calls.
+ *
  * Context: Any context.  The caller should hold the xa_lock.
  */
 void xas_try_split(struct xa_state *xas, void *entry, unsigned int order,
--- a/mm/filemap.c~mm-filemap-use-xas_try_split-in-__filemap_add_folio
+++ a/mm/filemap.c
@@ -857,11 +857,10 @@ EXPORT_SYMBOL_GPL(replace_page_cache_fol
 noinline int __filemap_add_folio(struct address_space *mapping,
 		struct folio *folio, pgoff_t index, gfp_t gfp, void **shadowp)
 {
-	XA_STATE(xas, &mapping->i_pages, index);
-	void *alloced_shadow = NULL;
-	int alloced_order = 0;
+	XA_STATE_ORDER(xas, &mapping->i_pages, index, folio_order(folio));
 	bool huge;
 	long nr;
+	unsigned int forder = folio_order(folio);
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(folio_test_swapbacked(folio), folio);
@@ -870,7 +869,6 @@ noinline int __filemap_add_folio(struct
 	mapping_set_update(&xas, mapping);
 
 	VM_BUG_ON_FOLIO(index & (folio_nr_pages(folio) - 1), folio);
-	xas_set_order(&xas, index, folio_order(folio));
 	huge = folio_test_hugetlb(folio);
 	nr = folio_nr_pages(folio);
 
@@ -880,7 +878,7 @@ noinline int __filemap_add_folio(struct
 	folio->index = xas.xa_index;
 
 	for (;;) {
-		int order = -1, split_order = 0;
+		int order = -1;
 		void *entry, *old = NULL;
 
 		xas_lock_irq(&xas);
@@ -898,21 +896,26 @@ noinline int __filemap_add_folio(struct
 				order = xas_get_order(&xas);
 		}
 
-		/* entry may have changed before we re-acquire the lock */
-		if (alloced_order && (old != alloced_shadow || order != alloced_order)) {
-			xas_destroy(&xas);
-			alloced_order = 0;
-		}
-
 		if (old) {
-			if (order > 0 && order > folio_order(folio)) {
+			if (order > 0 && order > forder) {
+				unsigned int split_order = max(forder,
+						xas_try_split_min_order(order));
+
 				/* How to handle large swap entries? */
 				BUG_ON(shmem_mapping(mapping));
-				if (!alloced_order) {
-					split_order = order;
-					goto unlock;
+
+				while (order > forder) {
+					xas_set_order(&xas, index, split_order);
+					xas_try_split(&xas, old, order,
+						      GFP_NOWAIT);
+					if (xas_error(&xas))
+						goto unlock;
+					order = split_order;
+					split_order =
+						max(xas_try_split_min_order(
+							    split_order),
+						    forder);
 				}
-				xas_split(&xas, old, order);
 				xas_reset(&xas);
 			}
 			if (shadowp)
@@ -936,17 +939,6 @@ noinline int __filemap_add_folio(struct
 unlock:
 		xas_unlock_irq(&xas);
 
-		/* split needed, alloc here and retry. */
-		if (split_order) {
-			xas_split_alloc(&xas, old, split_order, gfp);
-			if (xas_error(&xas))
-				goto error;
-			alloced_shadow = old;
-			alloced_order = split_order;
-			xas_reset(&xas);
-			continue;
-		}
-
 		if (!xas_nomem(&xas, gfp))
 			break;
 	}
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

