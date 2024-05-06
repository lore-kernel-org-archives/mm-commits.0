Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DFB2913
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714955337; cv=none; b=WY6ai8nE7pFuy7rzrY/nsU2tap7GUBSsYdgGTRiHadQTURcq9e+mhYpLA44iELa5X1bBziF56Y/FJI9+yRHx99kX3NmYC1iMcXsx8JS8wn1rkotOd9+SGaxNOJcBxW9TNzPcO97j56+mCnMU93SCUYHgl10QMgKt3UpsFJfS4Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714955337; c=relaxed/simple;
	bh=n+EjY+7TZgCMjAf2wZQJETUD2xj94Yr9fm6AyW+WFCQ=;
	h=Date:To:From:Subject:Message-Id; b=Hd4eVvPWzelxT+J2plDtDkSARjnGV+uUtFGwNLZA/veuD0IvBGXGygrlHSh9DwDtlJVroanyKhwtt+W1o2CEllxF8UV4lqWZ6453jA+NQq8omXlukTriP8B31LdrYZrZPBy4U0CSRZPtET5GTdt+0aZCpNvm8GSlhNqp1oqPu+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=osFG5qls; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="osFG5qls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5473DC113CC;
	Mon,  6 May 2024 00:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714955337;
	bh=n+EjY+7TZgCMjAf2wZQJETUD2xj94Yr9fm6AyW+WFCQ=;
	h=Date:To:From:Subject:From;
	b=osFG5qls/csp/cdr2YKS+7d3M1lwvB5ymW55SGD7Pzp6QazZm2Z8Lv3eJ9zkrN7NN
	 +eac71mczTY3O72u/15e+eyeLvZOJdsoz6oW8JNxrl9KrxatD4ocdmAWRGQtzFB+WY
	 ISl8ezmmdDF8QeV9RdAizPQ1n9qoGWLQ6EmAoHh0=
Date: Sun, 05 May 2024 17:28:56 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,mcgrof@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] xarray-set-the-marks-correctly-when-splitting-an-entry.patch removed from -mm tree
Message-Id: <20240506002857.5473DC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: XArray: set the marks correctly when splitting an entry
has been removed from the -mm tree.  Its filename was
     xarray-set-the-marks-correctly-when-splitting-an-entry.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: XArray: set the marks correctly when splitting an entry
Date: Wed, 1 May 2024 16:31:18 +0100

If we created a new node to replace an entry which had search marks set,
we were setting the search mark on every entry in that node.  That works
fine when we're splitting to order 0, but when splitting to a larger
order, we must not set the search marks on the sibling entries.

Link: https://lkml.kernel.org/r/20240501153120.4094530-1-willy@infradead.org
Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: Luis Chamberlain <mcgrof@kernel.org>
Link: https://lore.kernel.org/r/ZjFGCOYk3FK_zVy3@bombadil.infradead.org
Tested-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_xarray.c |   14 +++++++++++++-
 lib/xarray.c      |   23 +++++++++++++++++++----
 2 files changed, 32 insertions(+), 5 deletions(-)

--- a/lib/test_xarray.c~xarray-set-the-marks-correctly-when-splitting-an-entry
+++ a/lib/test_xarray.c
@@ -1788,9 +1788,11 @@ static void check_split_1(struct xarray
 				unsigned int order, unsigned int new_order)
 {
 	XA_STATE_ORDER(xas, xa, index, new_order);
-	unsigned int i;
+	unsigned int i, found;
+	void *entry;
 
 	xa_store_order(xa, index, order, xa, GFP_KERNEL);
+	xa_set_mark(xa, index, XA_MARK_1);
 
 	xas_split_alloc(&xas, xa, order, GFP_KERNEL);
 	xas_lock(&xas);
@@ -1807,6 +1809,16 @@ static void check_split_1(struct xarray
 	xa_set_mark(xa, index, XA_MARK_0);
 	XA_BUG_ON(xa, !xa_get_mark(xa, index, XA_MARK_0));
 
+	xas_set_order(&xas, index, 0);
+	found = 0;
+	rcu_read_lock();
+	xas_for_each_marked(&xas, entry, ULONG_MAX, XA_MARK_1) {
+		found++;
+		XA_BUG_ON(xa, xa_is_internal(entry));
+	}
+	rcu_read_unlock();
+	XA_BUG_ON(xa, found != 1 << (order - new_order));
+
 	xa_destroy(xa);
 }
 
--- a/lib/xarray.c~xarray-set-the-marks-correctly-when-splitting-an-entry
+++ a/lib/xarray.c
@@ -969,8 +969,22 @@ static unsigned int node_get_marks(struc
 	return marks;
 }
 
+static inline void node_mark_slots(struct xa_node *node, unsigned int sibs,
+		xa_mark_t mark)
+{
+	int i;
+
+	if (sibs == 0)
+		node_mark_all(node, mark);
+	else {
+		for (i = 0; i < XA_CHUNK_SIZE; i += sibs + 1)
+			node_set_mark(node, i, mark);
+	}
+}
+
 static void node_set_marks(struct xa_node *node, unsigned int offset,
-			struct xa_node *child, unsigned int marks)
+			struct xa_node *child, unsigned int sibs,
+			unsigned int marks)
 {
 	xa_mark_t mark = XA_MARK_0;
 
@@ -978,7 +992,7 @@ static void node_set_marks(struct xa_nod
 		if (marks & (1 << (__force unsigned int)mark)) {
 			node_set_mark(node, offset, mark);
 			if (child)
-				node_mark_all(child, mark);
+				node_mark_slots(child, sibs, mark);
 		}
 		if (mark == XA_MARK_MAX)
 			break;
@@ -1077,7 +1091,8 @@ void xas_split(struct xa_state *xas, voi
 			child->nr_values = xa_is_value(entry) ?
 					XA_CHUNK_SIZE : 0;
 			RCU_INIT_POINTER(child->parent, node);
-			node_set_marks(node, offset, child, marks);
+			node_set_marks(node, offset, child, xas->xa_sibs,
+					marks);
 			rcu_assign_pointer(node->slots[offset],
 					xa_mk_node(child));
 			if (xa_is_value(curr))
@@ -1086,7 +1101,7 @@ void xas_split(struct xa_state *xas, voi
 		} else {
 			unsigned int canon = offset - xas->xa_sibs;
 
-			node_set_marks(node, canon, NULL, marks);
+			node_set_marks(node, canon, NULL, 0, marks);
 			rcu_assign_pointer(node->slots[canon], entry);
 			while (offset > canon)
 				rcu_assign_pointer(node->slots[offset--],
_

Patches currently in -mm which might be from willy@infradead.org are

doc-improve-the-description-of-__folio_mark_dirty.patch
buffer-add-kernel-doc-for-block_dirty_folio.patch
buffer-add-kernel-doc-for-try_to_free_buffers.patch
buffer-fix-__bread-and-__bread_gfp-kernel-doc.patch
buffer-add-kernel-doc-for-brelse-and-__brelse.patch
buffer-add-kernel-doc-for-bforget-and-__bforget.patch
buffer-improve-bdev_getblk-documentation.patch
doc-split-bufferrst-out-of-api-summaryrst.patch
doc-split-bufferrst-out-of-api-summaryrst-fix.patch
mm-memory-failure-remove-fsdax_pgoff-argument-from-__add_to_kill.patch
mm-memory-failure-pass-addr-to-__add_to_kill.patch
mm-return-the-address-from-page_mapped_in_vma.patch
mm-make-page_mapped_in_vma-conditional-on-config_memory_failure.patch
mm-memory-failure-convert-shake_page-to-shake_folio.patch
mm-convert-hugetlb_page_mapping_lock_write-to-folio.patch
mm-memory-failure-convert-memory_failure-to-use-a-folio.patch
mm-memory-failure-convert-hwpoison_user_mappings-to-take-a-folio.patch
mm-memory-failure-add-some-folio-conversions-to-unpoison_memory.patch
mm-memory-failure-use-folio-functions-throughout-collect_procs.patch
mm-memory-failure-pass-the-folio-to-collect_procs_ksm.patch
fscrypt-convert-bh_get_inode_and_lblk_num-to-use-a-folio.patch
f2fs-convert-f2fs_clear_page_cache_dirty_tag-to-use-a-folio.patch
memory-failure-remove-calls-to-page_mapping.patch
migrate-expand-the-use-of-folio-in-__migrate_device_pages.patch
userfault-expand-folio-use-in-mfill_atomic_install_pte.patch
mm-remove-page_cache_alloc.patch
mm-remove-put_devmap_managed_page.patch
mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs.patch
mm-remove-page_ref_sub_return.patch
gup-use-folios-for-gup_devmap.patch
mm-add-kernel-doc-for-folio_mark_accessed.patch
mm-remove-pagereferenced.patch
mm-simplify-thp_vma_allowable_order.patch
mm-assert-the-mmap_lock-is-held-in-__anon_vma_prepare.patch
mm-delay-the-check-for-a-null-anon_vma.patch
mm-fix-some-minor-per-vma-lock-issues-in-userfaultfd.patch
mm-optimise-vmf_anon_prepare-for-vmas-without-an-anon_vma.patch
thp-remove-hpage_pmd_order-minimum-assertion.patch
squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch

