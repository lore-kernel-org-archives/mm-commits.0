Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE0E1D63EF
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274631; cv=none; b=mPH8kHjB1/Xr8W9WNrVYQii+JSr/gJqsspn9r3mx8yM2IpCdfM3Q9nlLptobLQwVP2ypIF6rnnRtsP38anECFCkKriUmNmryzU24bHuS9nunLoNXFvAJy+GsZ5neVeThN2f57Wh9edSKMUWz2Inr+BHTKBckuowNoe+Kg6jdbtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274631; c=relaxed/simple;
	bh=tKTaCF/PIubXs9pUJ7HbiZIuR7bO1iG8ECB6pKJZoMg=;
	h=Date:To:From:Subject:Message-Id; b=KotLXS/+NFoXCqzxjj2wOHkuJFK4OAE3yWu0Tb+4ylUEmiYQ5xZGwVtedUvEasryKzNY0VKcXFkqvZY7P2QQbtXAhhsMIWcm+X0YQGIhvfTvRU3yj/17Yz41P0qA+h6CzY4QqNXQwBr7VfxXIBo2vsYeU/VyY1GOnhjo88Qfp58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cxeUVdEM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cxeUVdEM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4251CC4CEDD;
	Tue, 18 Mar 2025 05:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274631;
	bh=tKTaCF/PIubXs9pUJ7HbiZIuR7bO1iG8ECB6pKJZoMg=;
	h=Date:To:From:Subject:From;
	b=cxeUVdEMOGu3q3igzpc9vIkYolRrAFWjYZGBzLcDMvlFeDkDC73Hs4hxzGm65fthg
	 1wpjQPy/m9PhC8IQBQjjgCu/M9nWpK6y1UaSBpM3YvD3sePHvxlIb47kVkCWWPnTxq
	 krop4+rC1JUPoeZqSeEe8J0S80fhEs1Scqh+g6B0=
Date: Mon, 17 Mar 2025 22:10:30 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yang@os.amperecomputing.com,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,linmiaohe@huawei.com,kirill.shutemov@linux.intel.com,kasong@tencent.com,jhubbard@nvidia.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-filemap-use-xas_try_split-in-__filemap_add_folio.patch removed from -mm tree
Message-Id: <20250318051031.4251CC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/filemap: use xas_try_split() in __filemap_add_folio()
has been removed from the -mm tree.  Its filename was
     mm-filemap-use-xas_try_split-in-__filemap_add_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/filemap: use xas_try_split() in __filemap_add_folio()
Date: Fri, 14 Mar 2025 18:21:12 -0400

Patch series "Minimize xa_node allocation during xarry split", v3.

When splitting a multi-index entry in XArray from order-n to order-m,
existing xas_split_alloc()+xas_split() approach requires 2^(n %
XA_CHUNK_SHIFT) xa_node allocations.  But its callers,
__filemap_add_folio() and shmem_split_large_entry(), use at most 1
xa_node.  To minimize xa_node allocation and remove the limitation of no
split from order-12 (or above) to order-0 (or anything between 0 and
5)[1], xas_try_split() was added[2], which allocates (n / XA_CHUNK_SHIFT -
m / XA_CHUNK_SHIFT) xa_node.  It is used for non-uniform folio split, but
can be used by __filemap_add_folio() and shmem_split_large_entry().

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
[2] https://lore.kernel.org/linux-mm/20250226210032.2044041-1-ziy@nvidia.com/


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

Link: https://lkml.kernel.org/r/20250314222113.711703-1-ziy@nvidia.com
Link: https://lkml.kernel.org/r/20250314222113.711703-2-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
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

 include/linux/xarray.h |    7 ++++++
 lib/xarray.c           |   25 +++++++++++++++++++++
 mm/filemap.c           |   45 +++++++++++++++------------------------
 3 files changed, 50 insertions(+), 27 deletions(-)

--- a/include/linux/xarray.h~mm-filemap-use-xas_try_split-in-__filemap_add_folio
+++ a/include/linux/xarray.h
@@ -1556,6 +1556,7 @@ int xas_get_order(struct xa_state *xas);
 void xas_split(struct xa_state *, void *entry, unsigned int order);
 void xas_split_alloc(struct xa_state *, void *entry, unsigned int order, gfp_t);
 void xas_try_split(struct xa_state *xas, void *entry, unsigned int order);
+unsigned int xas_try_split_min_order(unsigned int order);
 #else
 static inline int xa_get_order(struct xarray *xa, unsigned long index)
 {
@@ -1582,6 +1583,12 @@ static inline void xas_try_split(struct
 		unsigned int order)
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
@@ -1135,6 +1135,28 @@ void xas_split(struct xa_state *xas, voi
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
  * needed, the function will use GFP_NOWAIT to get one if xas->xa_alloc is
  * NULL. If more new xa_node are needed, the function gives EINVAL error.
  *
+ * NOTE: use xas_try_split_min_order() to get next split order instead of
+ * @order - 1 if you want to minmize xas_try_split() calls.
+ *
  * Context: Any context.  The caller should hold the xa_lock.
  */
 void xas_try_split(struct xa_state *xas, void *entry, unsigned int order)
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
@@ -898,21 +896,25 @@ noinline int __filemap_add_folio(struct
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
+					xas_try_split(&xas, old, order);
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
@@ -936,17 +938,6 @@ noinline int __filemap_add_folio(struct
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


