Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F1F39AF9
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 15:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714665119; cv=none; b=iycqfaLAGcWzzd7x0EXLKu3Fy+AXkSzCYZHQbpG7mg5ZKnxPvXUb60S5924ufUq31StZPHGEKfs1XXxfhfcU2TRKGdlgqwDR/6FgQk6/OrUlfgYX0yszh6Xhudll/25WD99R6nOfxrYYmmj2pEJhFu0VhsfLc0jQai0J75pJUMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714665119; c=relaxed/simple;
	bh=p/lBBsiHscNmvb3eBni7lOlU8golBp0TTgX4+hX7f/M=;
	h=Date:To:From:Subject:Message-Id; b=KwfTwjRQx2k0TRvabhHJV4iy5VvGsztweKLohdPjIqKbebrAGFmXRmVZuX4jBY5vkDgwd8Z1D8HEohbw5in6T5IY29cvsbGvy2DkHW4ClnrK+PvXbGv3D9Eo43MvExRQdRL2GgSsNzWk0hwmg1EPhDWdCBzWtfp0ZtgRahknftg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mqklvlfw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mqklvlfw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1590BC113CC;
	Thu,  2 May 2024 15:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714665119;
	bh=p/lBBsiHscNmvb3eBni7lOlU8golBp0TTgX4+hX7f/M=;
	h=Date:To:From:Subject:From;
	b=mqklvlfwAz4OHW9K7WsLJyPWwJdz8f/qZ3j2HImCFpvxLDhu7e8zXF2WWf2DkQzP6
	 riskKR4W2FdSiCPFwzS8RcrFvj2woYgj0km+MFR7QJEJDBPROT+kaTEevIHM8tijZQ
	 LqgJZ/fm6S09S/2vjm5LgQ6xelsdaq+fRfcJ1bxE=
Date: Thu, 02 May 2024 08:51:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,mcgrof@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xarray-set-the-marks-correctly-when-splitting-an-entry.patch added to mm-hotfixes-unstable branch
Message-Id: <20240502155159.1590BC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: XArray: Set the marks correctly when splitting an entry
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     xarray-set-the-marks-correctly-when-splitting-an-entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xarray-set-the-marks-correctly-when-splitting-an-entry.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: XArray: Set the marks correctly when splitting an entry
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

xarray-set-the-marks-correctly-when-splitting-an-entry.patch
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
squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch

