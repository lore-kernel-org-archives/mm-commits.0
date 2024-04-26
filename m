Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3507C085
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103939; cv=none; b=nn5abNTE+eb0PBKK8PNzYtqOFnpIJTahA1++vZADbB2Y6mggSgTyPOqvOra/KGsaCKz6eKkbFOKuAkqCt9sU3+2dAY1hE5vtK8mBZDjYmTjywdx4Ct4DPrP//mG5pbQl3RW4FxKZdH0YrAzqyyEGuSTY59Wbbrx1SQeIClTDZFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103939; c=relaxed/simple;
	bh=kWhgN5GKJuDxLpnwasbcvOX0FgXt9//oOogUFnAwofA=;
	h=Date:To:From:Subject:Message-Id; b=tKclj2tix/kX3S/6BOOJl/wpMiyj6r6vUBR+nNBBMqW4sr8BqizlcldXn1XlYibZDlmmKJbhLoIzR/3WBLS6+KlhC1/r4eMrXfD3SyFIGdZvxgmPC0p32TjJ/nNcj/YFi317PzVgUMxcxJ3zX2LWX+9HJtTkhUovnwRHfUToabA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d5c0Sg0Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d5c0Sg0Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805D3C113CD;
	Fri, 26 Apr 2024 03:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103939;
	bh=kWhgN5GKJuDxLpnwasbcvOX0FgXt9//oOogUFnAwofA=;
	h=Date:To:From:Subject:From;
	b=d5c0Sg0QCV8Fe4FVdlRVKQpPARmBeQm6AZv2+Lp3p9oY9qmFim0N9NhLlt4kZlf6b
	 +w+Psh/AoLbn95SIduiXJ13d1uOqUTNDEUD9Sl72e2IYvmS81F2zz0ZpnHB9shCSiQ
	 b/VqKJnrmVLT20Nkabgi2C+vuWYvz2HyRI6zD/No=
Date: Thu, 25 Apr 2024 20:58:58 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,muchun.song@linux.dev,linmiaohe@huawei.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-a-call-to-compound_head-from-is_page_hwpoison.patch removed from -mm tree
Message-Id: <20240426035859.805D3C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove a call to compound_head() from is_page_hwpoison()
has been removed from the -mm tree.  Its filename was
     mm-remove-a-call-to-compound_head-from-is_page_hwpoison.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove a call to compound_head() from is_page_hwpoison()
Date: Thu, 21 Mar 2024 14:24:44 +0000

We can call it only once instead of twice.

Link: https://lkml.kernel.org/r/20240321142448.1645400-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/include/linux/page-flags.h~mm-remove-a-call-to-compound_head-from-is_page_hwpoison
+++ a/include/linux/page-flags.h
@@ -1065,11 +1065,14 @@ static inline bool PageHuge(const struct
  * best effort only and inherently racy: there is no way to synchronize with
  * failing hardware.
  */
-static inline bool is_page_hwpoison(struct page *page)
+static inline bool is_page_hwpoison(const struct page *page)
 {
+	const struct folio *folio;
+
 	if (PageHWPoison(page))
 		return true;
-	return PageHuge(page) && PageHWPoison(compound_head(page));
+	folio = page_folio(page);
+	return folio_test_hugetlb(folio) && PageHWPoison(&folio->page);
 }
 
 extern bool is_free_buddy_page(struct page *page);
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

