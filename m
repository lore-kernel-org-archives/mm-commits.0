Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C270B80BF8
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104175; cv=none; b=YsOEVSto+KtV1WG7ksp843kW/B06L4zft0yDzaxa++RTcUKiiJuQP9qzl8gk23ad9c5vHVomLrMofYmfDvwnNSq3vc9s98kLv28BwziilcSEl7FQgEHXS3shPSNXLN8CJLAEyCGN+mwiARriycfcOJ09HHrtxajqCzcrmfzzTfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104175; c=relaxed/simple;
	bh=x172XNst0qrMrk0AhppAdmiSLH1I61oo0IM1GA6w9uA=;
	h=Date:To:From:Subject:Message-Id; b=ESLvNtvdU898/f3nGQh9UelsLjHPXQdruO+hQNpU800JtDR72MLWoOncr/4Pm7wwj6cCg3l2vNcMICkwuBKjfRGkwAqPcobiQi+q0PTb39MyZpFsFyUATR3Mp68INQkF4I6SO19OAORMeE2xyjtiwjnrgOUL4IVEVyybw0Nbl8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lrvh/eSu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lrvh/eSu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F40C113CD;
	Fri, 26 Apr 2024 04:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104175;
	bh=x172XNst0qrMrk0AhppAdmiSLH1I61oo0IM1GA6w9uA=;
	h=Date:To:From:Subject:From;
	b=lrvh/eSuVgFZ+vKhDaDfcs7G6wSe0OFalhXui/WJuBLHXCY7GEnHaHzHfJ46qO5Pu
	 z+dSs6t+VCB9OrrdfJpS6M9S83vluuvOLoI+fV6YQp8/ZAk6HH4p/GMrdnWxDY/qHb
	 WERgwS5PLpGFlu93P3Tny1Z0ZRFDfwwGgiIuGdYY=
Date: Thu, 25 Apr 2024 21:02:55 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-inline-destroy_large_folio-into-__folio_put_large.patch removed from -mm tree
Message-Id: <20240426040255.93F40C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: inline destroy_large_folio() into __folio_put_large()
has been removed from the -mm tree.  Its filename was
     mm-inline-destroy_large_folio-into-__folio_put_large.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: inline destroy_large_folio() into __folio_put_large()
Date: Fri, 5 Apr 2024 16:32:25 +0100

destroy_large_folio() has only one caller, move its contents there.

Link: https://lkml.kernel.org/r/20240405153228.2563754-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 --
 mm/page_alloc.c    |   14 --------------
 mm/swap.c          |   13 ++++++++++---
 3 files changed, 10 insertions(+), 19 deletions(-)

--- a/include/linux/mm.h~mm-inline-destroy_large_folio-into-__folio_put_large
+++ a/include/linux/mm.h
@@ -1318,8 +1318,6 @@ void folio_copy(struct folio *dst, struc
 
 unsigned long nr_free_buffer_pages(void);
 
-void destroy_large_folio(struct folio *folio);
-
 /* Returns the number of bytes in this potentially compound page. */
 static inline unsigned long page_size(struct page *page)
 {
--- a/mm/page_alloc.c~mm-inline-destroy_large_folio-into-__folio_put_large
+++ a/mm/page_alloc.c
@@ -565,20 +565,6 @@ void prep_compound_page(struct page *pag
 	prep_compound_head(page, order);
 }
 
-void destroy_large_folio(struct folio *folio)
-{
-	if (folio_test_hugetlb(folio)) {
-		free_huge_folio(folio);
-		return;
-	}
-
-	if (folio_test_large_rmappable(folio))
-		folio_undo_large_rmappable(folio);
-
-	mem_cgroup_uncharge(folio);
-	free_unref_page(&folio->page, folio_order(folio));
-}
-
 static inline void set_buddy_order(struct page *page, unsigned int order)
 {
 	set_page_private(page, order);
--- a/mm/swap.c~mm-inline-destroy_large_folio-into-__folio_put_large
+++ a/mm/swap.c
@@ -127,9 +127,16 @@ static void __folio_put_large(struct fol
 	 * (it's never listed to any LRU lists) and no memcg routines should
 	 * be called for hugetlb (it has a separate hugetlb_cgroup.)
 	 */
-	if (!folio_test_hugetlb(folio))
-		page_cache_release(folio);
-	destroy_large_folio(folio);
+	if (folio_test_hugetlb(folio)) {
+		free_huge_folio(folio);
+		return;
+	}
+
+	page_cache_release(folio);
+	if (folio_test_large_rmappable(folio))
+		folio_undo_large_rmappable(folio);
+	mem_cgroup_uncharge(folio);
+	free_unref_page(&folio->page, folio_order(folio));
 }
 
 void __folio_put(struct folio *folio)
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

