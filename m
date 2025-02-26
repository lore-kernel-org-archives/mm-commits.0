Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E7925A32F
	for <mm-commits@vger.kernel.org>; Wed, 26 Feb 2025 21:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740604476; cv=none; b=a729Hd3pVv3Yf8wxqpsg/tnJHD0GzAFune+HLM6L4H0TxV037JTsXpYAfMKqtg7vDJxne5/9YpWWVy8gcagaJ7y8zJwHIsj+ncW311RRqc3vp1jaKVl14KLyktRFHn/F0XDuzgNJU1seauWRrDahMZArh1y/Gl57f4WWqpCisQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740604476; c=relaxed/simple;
	bh=Rn8bQ0rO6PaSlMzXzkC/BVViSD+ChS5Z0SfHVssGDyk=;
	h=Date:To:From:Subject:Message-Id; b=jIquAqHCjV7gk8C0/3nsZBhv3h9nQ0AKlaGYhd9te/xwQv+aQUdtNWhOndaHWF1oOrb6TAwAkrVzj02rCtqBmi7GmeDBVWECYHsOTd6vS5mMA0YqVkQXzHCbeE+Qj8hegF3B0KyAWj37/xsMZwwkcjfMISVy6UrNCga2TQQSzCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YHtioGpy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YHtioGpy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF3D2C4CEE9;
	Wed, 26 Feb 2025 21:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740604475;
	bh=Rn8bQ0rO6PaSlMzXzkC/BVViSD+ChS5Z0SfHVssGDyk=;
	h=Date:To:From:Subject:From;
	b=YHtioGpy0kaaENp2RBvCh0J1lSgWtP7yxhzfU1MFtszd5/jRhI8h8NydJ2MdgOc50
	 BWawJW6YyNSLwaFNv87qAH2PpZRCFU6I7Dw2xoxWdpMlxZw327Q8vW/kfS7+aAklnv
	 CKsHdZ0eTCMu/cIOltQgv0YB98DdwcF3KBUw3jWU=
Date: Wed, 26 Feb 2025 13:14:35 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yang@os.amperecomputing.com,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,linmiaohe@huawei.com,kirill.shutemov@linux.intel.com,kasong@tencent.com,jhubbard@nvidia.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-add-buddy-allocator-like-non-uniform-folio_split.patch added to mm-unstable branch
Message-Id: <20250226211435.CF3D2C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: add buddy allocator like (non-uniform) folio_split()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-add-buddy-allocator-like-non-uniform-folio_split.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-add-buddy-allocator-like-non-uniform-folio_split.patch

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
Subject: mm/huge_memory: add buddy allocator like (non-uniform) folio_split()
Date: Wed, 26 Feb 2025 16:00:27 -0500

folio_split() splits a large folio in the same way as buddy allocator
splits a large free page for allocation.  The purpose is to minimize the
number of folios after the split.  For example, if user wants to free the
3rd subpage in a order-9 folio, folio_split() will split the order-9 folio
as:

O-0, O-0, O-0, O-0, O-2, O-3, O-4, O-5, O-6, O-7, O-8 if it is anon,
since anon folio does not support order-1 yet.
-----------------------------------------------------------------
|   |   |   |   |     |   |       |                             |
|O-0|O-0|O-0|O-0| O-2 |...|  O-7  |             O-8             |
|   |   |   |   |     |   |       |                             |
-----------------------------------------------------------------

O-1,      O-0, O-0, O-2, O-3, O-4, O-5, O-6, O-7, O-9 if it is pagecache
---------------------------------------------------------------
|     |   |   |     |   |       |                             |
| O-1 |O-0|O-0| O-2 |...|  O-7  |             O-8             |
|     |   |   |     |   |       |                             |
---------------------------------------------------------------

It generates fewer folios (i.e., 11 or 10) than existing page split
approach, which splits the order-9 to 512 order-0 folios.  It also reduces
the number of new xa_node needed during a pagecache folio split from 8 to
1, potentially decreasing the folio split failure rate due to memory
constraints.

folio_split() and existing split_huge_page_to_list_to_order() share the
folio unmapping and remapping code in __folio_split() and the common
backend split code in __split_unmapped_folio() using uniform_split
variable to distinguish their operations.

uniform_split_supported() and non_uniform_split_supported() are added to
factor out check code and will be used outside __folio_split() in the
following commit.

Link: https://lkml.kernel.org/r/20250226210032.2044041-5-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |  160 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 123 insertions(+), 37 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-add-buddy-allocator-like-non-uniform-folio_split
+++ a/mm/huge_memory.c
@@ -3847,12 +3847,85 @@ after_split:
 	return ret;
 }
 
+static bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
+		bool warns)
+{
+	if (folio_test_anon(folio)) {
+		/* order-1 is not supported for anonymous THP. */
+		VM_WARN_ONCE(warns && new_order == 1,
+				"Cannot split to order-1 folio");
+		return new_order != 1;
+	} else if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
+	    !mapping_large_folio_support(folio->mapping)) {
+		/*
+		 * No split if the file system does not support large folio.
+		 * Note that we might still have THPs in such mappings due to
+		 * CONFIG_READ_ONLY_THP_FOR_FS. But in that case, the mapping
+		 * does not actually support large folios properly.
+		 */
+		VM_WARN_ONCE(warns,
+			"Cannot split file folio to non-0 order");
+		return false;
+	}
+
+	/* Only swapping a whole PMD-mapped folio is supported */
+	if (folio_test_swapcache(folio)) {
+		VM_WARN_ONCE(warns,
+			"Cannot split swapcache folio to non-0 order");
+		return false;
+	}
+
+	return true;
+}
+
+/* See comments in non_uniform_split_supported() */
+static bool uniform_split_supported(struct folio *folio, unsigned int new_order,
+		bool warns)
+{
+	if (folio_test_anon(folio)) {
+		VM_WARN_ONCE(warns && new_order == 1,
+				"Cannot split to order-1 folio");
+		return new_order != 1;
+	} else  if (new_order) {
+		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
+		    !mapping_large_folio_support(folio->mapping)) {
+			VM_WARN_ONCE(warns,
+				"Cannot split file folio to non-0 order");
+			return false;
+		}
+	}
+
+	if (new_order && folio_test_swapcache(folio)) {
+		VM_WARN_ONCE(warns,
+			"Cannot split swapcache folio to non-0 order");
+		return false;
+	}
+
+	return true;
+}
+
+/*
+ * __folio_split: split a folio at @split_at to a @new_order folio
+ * @folio: folio to split
+ * @new_order: the order of the new folio
+ * @split_at: a page within the new folio
+ * @lock_at: a page within @folio to be left locked to caller
+ * @list: after-split folios will be put on it if non NULL
+ * @uniform_split: perform uniform split or not (non-uniform split)
+ *
+ * It calls __split_unmapped_folio() to perform uniform and non-uniform split.
+ * It is in charge of checking whether the split is supported or not and
+ * preparing @folio for __split_unmapped_folio().
+ *
+ * return: 0: successful, <0 failed (if -ENOMEM is returned, @folio might be
+ * split but not to @new_order, the caller needs to check)
+ */
 static int __folio_split(struct folio *folio, unsigned int new_order,
-		struct page *page, struct list_head *list)
+		struct page *split_at, struct page *lock_at,
+		struct list_head *list, bool uniform_split)
 {
 	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
-	/* reset xarray order to new order after split */
-	XA_STATE_ORDER(xas, &folio->mapping->i_pages, folio->index, new_order);
+	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
 	bool is_anon = folio_test_anon(folio);
 	struct address_space *mapping = NULL;
 	struct anon_vma *anon_vma = NULL;
@@ -3864,32 +3937,17 @@ static int __folio_split(struct folio *f
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
 
+	if (folio != page_folio(split_at) || folio != page_folio(lock_at))
+		return -EINVAL;
+
 	if (new_order >= folio_order(folio))
 		return -EINVAL;
 
-	if (is_anon) {
-		/* order-1 is not supported for anonymous THP. */
-		if (new_order == 1) {
-			VM_WARN_ONCE(1, "Cannot split to order-1 folio");
-			return -EINVAL;
-		}
-	} else if (new_order) {
-		/*
-		 * No split if the file system does not support large folio.
-		 * Note that we might still have THPs in such mappings due to
-		 * CONFIG_READ_ONLY_THP_FOR_FS. But in that case, the mapping
-		 * does not actually support large folios properly.
-		 */
-		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
-		    !mapping_large_folio_support(folio->mapping)) {
-			VM_WARN_ONCE(1,
-				"Cannot split file folio to non-0 order");
-			return -EINVAL;
-		}
-	}
+	if (uniform_split && !uniform_split_supported(folio, new_order, true))
+		return -EINVAL;
 
-	/* Only swapping a whole PMD-mapped folio is supported */
-	if (folio_test_swapcache(folio) && new_order)
+	if (!uniform_split &&
+	    !non_uniform_split_supported(folio, new_order, true))
 		return -EINVAL;
 
 	is_hzp = is_huge_zero_folio(folio);
@@ -3946,10 +4004,13 @@ static int __folio_split(struct folio *f
 			goto out;
 		}
 
-		xas_split_alloc(&xas, folio, folio_order(folio), gfp);
-		if (xas_error(&xas)) {
-			ret = xas_error(&xas);
-			goto out;
+		if (uniform_split) {
+			xas_set_order(&xas, folio->index, new_order);
+			xas_split_alloc(&xas, folio, folio_order(folio), gfp);
+			if (xas_error(&xas)) {
+				ret = xas_error(&xas);
+				goto out;
+			}
 		}
 
 		anon_vma = NULL;
@@ -4014,7 +4075,6 @@ static int __folio_split(struct folio *f
 		if (mapping) {
 			int nr = folio_nr_pages(folio);
 
-			xas_split(&xas, folio, folio_order(folio));
 			if (folio_test_pmd_mappable(folio) &&
 			    new_order < HPAGE_PMD_ORDER) {
 				if (folio_test_swapbacked(folio)) {
@@ -4028,12 +4088,9 @@ static int __folio_split(struct folio *f
 			}
 		}
 
-		if (is_anon) {
-			mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
-			mod_mthp_stat(new_order, MTHP_STAT_NR_ANON, 1 << (order - new_order));
-		}
-		__split_huge_page(page, list, end, new_order);
-		ret = 0;
+		ret = __split_unmapped_folio(folio, new_order,
+				split_at, lock_at, list, end, &xas, mapping,
+				uniform_split);
 	} else {
 		spin_unlock(&ds_queue->split_queue_lock);
 fail:
@@ -4111,7 +4168,36 @@ int split_huge_page_to_list_to_order(str
 {
 	struct folio *folio = page_folio(page);
 
-	return __folio_split(folio, new_order, page, list);
+	return __folio_split(folio, new_order, &folio->page, page, list, true);
+}
+
+/*
+ * folio_split: split a folio at @split_at to a @new_order folio
+ * @folio: folio to split
+ * @new_order: the order of the new folio
+ * @split_at: a page within the new folio
+ *
+ * return: 0: successful, <0 failed (if -ENOMEM is returned, @folio might be
+ * split but not to @new_order, the caller needs to check)
+ *
+ * It has the same prerequisites and returns as
+ * split_huge_page_to_list_to_order().
+ *
+ * Split a folio at @split_at to a new_order folio, leave the
+ * remaining subpages of the original folio as large as possible. For example,
+ * in the case of splitting an order-9 folio at its third order-3 subpages to
+ * an order-3 folio, there are 2^(9-3)=64 order-3 subpages in the order-9 folio.
+ * After the split, there will be a group of folios with different orders and
+ * the new folio containing @split_at is marked in bracket:
+ * [order-4, {order-3}, order-3, order-5, order-6, order-7, order-8].
+ *
+ * After split, folio is left locked for caller.
+ */
+static int folio_split(struct folio *folio, unsigned int new_order,
+		struct page *split_at, struct list_head *list)
+{
+	return __folio_split(folio, new_order, split_at, &folio->page, list,
+			false);
 }
 
 int min_order_for_split(struct folio *folio)
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

