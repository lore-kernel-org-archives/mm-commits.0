Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B3880BF8
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104176; cv=none; b=TuKNwHIhYiQPXOsx0aQVGQLTa8qcXsGEW94331MJ5DxmhSOKXDL0TaPuKJw48XtNjPh3AQlhZTqxcX2e7rRmlhxpu3zTe2g85Kn+LlNEPpUNFyA5Kgm0ZDp5TfnqLhmLWqVYMcAenUFv39NCDLc+b4vvjEbxm4wuOcd4n91za68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104176; c=relaxed/simple;
	bh=OvOHNrxSGc6Y+y3eAwWlRKfnWLJ25hZHwUW28D9mgZ8=;
	h=Date:To:From:Subject:Message-Id; b=lM67FlXyDNbRRfMYMqlIowbajrTRqxLmoigdDoMnFm8fZx1UTBflaK306EOekbPoQcaoNtCQwiPdhmkEVVASY6MMaxF7bhTYincOn+Jf4kv3mmu9dLWId9O3SqImnB+f4E8kIvAtJfx+TZF0VHfSUzstpdPizA88hDYMvJDgsa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fvMtyXrB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fvMtyXrB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97834C116B1;
	Fri, 26 Apr 2024 04:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104176;
	bh=OvOHNrxSGc6Y+y3eAwWlRKfnWLJ25hZHwUW28D9mgZ8=;
	h=Date:To:From:Subject:From;
	b=fvMtyXrB3qzABSQNHs+Q0OUCgpgiKhkA8OlyijQYkEETgkdDF+sIYlx8WKgM82vCR
	 vpBrg2z/hvn4/rpmA1VLESrLjHdoNpvXa9k5db/lG5oIm4pGqp0llekLDDK/4OVdpb
	 SGsuOKadpYrpNQw+0efjvgDUQTbxZk/kRkN5/aUs=
Date: Thu, 25 Apr 2024 21:02:56 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-combine-__folio_put_small-__folio_put_large-and-__folio_put.patch removed from -mm tree
Message-Id: <20240426040256.97834C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: combine __folio_put_small, __folio_put_large and __folio_put
has been removed from the -mm tree.  Its filename was
     mm-combine-__folio_put_small-__folio_put_large-and-__folio_put.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: combine __folio_put_small, __folio_put_large and __folio_put
Date: Fri, 5 Apr 2024 16:32:26 +0100

It's now obvious that __folio_put_small() and __folio_put_large() do
almost exactly the same thing.  Inline them both into __folio_put().

Link: https://lkml.kernel.org/r/20240405153228.2563754-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   32 ++++++--------------------------
 1 file changed, 6 insertions(+), 26 deletions(-)

--- a/mm/swap.c~mm-combine-__folio_put_small-__folio_put_large-and-__folio_put
+++ a/mm/swap.c
@@ -112,42 +112,22 @@ static void page_cache_release(struct fo
 		unlock_page_lruvec_irqrestore(lruvec, flags);
 }
 
-static void __folio_put_small(struct folio *folio)
-{
-	page_cache_release(folio);
-	mem_cgroup_uncharge(folio);
-	free_unref_page(&folio->page, 0);
-}
-
-static void __folio_put_large(struct folio *folio)
+void __folio_put(struct folio *folio)
 {
-	/*
-	 * __page_cache_release() is supposed to be called for thp, not for
-	 * hugetlb. This is because hugetlb page does never have PageLRU set
-	 * (it's never listed to any LRU lists) and no memcg routines should
-	 * be called for hugetlb (it has a separate hugetlb_cgroup.)
-	 */
-	if (folio_test_hugetlb(folio)) {
+	if (unlikely(folio_is_zone_device(folio))) {
+		free_zone_device_page(&folio->page);
+		return;
+	} else if (folio_test_hugetlb(folio)) {
 		free_huge_folio(folio);
 		return;
 	}
 
 	page_cache_release(folio);
-	if (folio_test_large_rmappable(folio))
+	if (folio_test_large(folio) && folio_test_large_rmappable(folio))
 		folio_undo_large_rmappable(folio);
 	mem_cgroup_uncharge(folio);
 	free_unref_page(&folio->page, folio_order(folio));
 }
-
-void __folio_put(struct folio *folio)
-{
-	if (unlikely(folio_is_zone_device(folio)))
-		free_zone_device_page(&folio->page);
-	else if (unlikely(folio_test_large(folio)))
-		__folio_put_large(folio);
-	else
-		__folio_put_small(folio);
-}
 EXPORT_SYMBOL(__folio_put);
 
 /**
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
mm-remove-page_mapping.patch
mm-remove-page_cache_alloc.patch
mm-remove-put_devmap_managed_page.patch
mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs.patch
mm-remove-page_ref_sub_return.patch
gup-use-folios-for-gup_devmap.patch
mm-add-kernel-doc-for-folio_mark_accessed.patch
mm-remove-pagereferenced.patch
mm-simplify-thp_vma_allowable_order.patch

