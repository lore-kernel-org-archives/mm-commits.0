Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D8A80C0C
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104172; cv=none; b=nPbT16LkTLeuqZNAkcJilPe1rcC6dZ3UHArviOWxv64Wt7/Xwq+ymRVr9Ii2urJaqIL9W9M9orAfAmY1tfJVGvaLKELIXnxabk4ZhERpRmJVi7IPBFqN0RpZWLpQGrEJO1x8kAhE3ZOXWhpKaqa4XVGk/sXRzEYUfHBnxVClHvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104172; c=relaxed/simple;
	bh=VdpLJhqD6Uh8dHxC04/jcBfic6LWo7UEp1jouNeR7Cw=;
	h=Date:To:From:Subject:Message-Id; b=YX5GoK5rttrpv4P001PflHbfFg9xicghOnhg3+jGuhtduf35g77PsfQZgZ17Otx/I5Nv3cVTioW7RMXG0bamvvw7+4aIluyItOGb/13PcRJimsHZlwaBYPBXwe99faUnOj9bHimrLT3rQO0Bnsk22pwh60cOtjh/YIlK7WoCwBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ILs3cZ+3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ILs3cZ+3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F12C113CD;
	Fri, 26 Apr 2024 04:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104172;
	bh=VdpLJhqD6Uh8dHxC04/jcBfic6LWo7UEp1jouNeR7Cw=;
	h=Date:To:From:Subject:From;
	b=ILs3cZ+3DN739FH2k7gZA4ixuJO5UnG7Vvk1knsr2Ht3iVDZvlNyLLvtcsHZWgfmQ
	 S7f3u/1NTHB/RQPiOqUD963OT7Anuqfe6KhrApznO9azX/ofexpPb3k5eIjsghyuJK
	 ZScUtT+rZwmCL62fXlvToinBbpEv9spIknLcoByo=
Date: Thu, 25 Apr 2024 21:02:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,peterx@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-free-non-hugetlb-large-folios-in-a-batch.patch removed from -mm tree
Message-Id: <20240426040252.87F12C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: free non-hugetlb large folios in a batch
has been removed from the -mm tree.  Its filename was
     mm-free-non-hugetlb-large-folios-in-a-batch.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: free non-hugetlb large folios in a batch
Date: Fri, 5 Apr 2024 16:32:23 +0100

Patch series "Clean up __folio_put()".

With all the changes over the last few years, __folio_put_small and
__folio_put_large have become almost identical to each other ...  except
you can't tell because they're spread over two files.  Rearrange it all so
that you can tell, and then inline them both into __folio_put().


This patch (of 5):

free_unref_folios() can now handle non-hugetlb large folios, so keep
normal large folios in the batch.  hugetlb folios still need to be handled
specially.

[peterx@redhat.com: fix panic]
  Link: https://lkml.kernel.org/r/ZikjPB0Dt5HA8-uL@x1n
Link: https://lkml.kernel.org/r/20240405153228.2563754-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20240405153228.2563754-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/swap.c~mm-free-non-hugetlb-large-folios-in-a-batch
+++ a/mm/swap.c
@@ -158,8 +158,8 @@ void put_pages_list(struct list_head *pa
 	list_for_each_entry_safe(folio, next, pages, lru) {
 		if (!folio_put_testzero(folio))
 			continue;
-		if (folio_test_large(folio)) {
-			__folio_put_large(folio);
+		if (folio_test_hugetlb(folio)) {
+			free_huge_folio(folio);
 			continue;
 		}
 		/* LRU flag must be clear because it's passed using the lru */
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

