Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234E37C085
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103944; cv=none; b=Gsog5RuzpPgTKK5HlmDZphYDziTdA7nPeoDpG21bz5LwXW/zIvgnstl13E45DDBeaRGR/wJFdDamIIFM76LKam47eOViUkcSCMg4d30kFDpyEzQUruFfxQHj+7sg5l4y5mgeAi94oxhRasSc6fjoeEbcn4BZa7HZljH7QTWnNiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103944; c=relaxed/simple;
	bh=OCXm1Nt4iQcMXFNMeYb/FCAMzh/bNQtgLK4znA2g5M0=;
	h=Date:To:From:Subject:Message-Id; b=QvgMalyqOPWdjKxDGl/KpaFXh1FNpkTrBVTHAOvfVA7IUUXs3/21zrKYmK8N0l7mhwt2tO6m04QcH3U3C6031o9qp1CaoB+8b9/6Y9QND8qvti5ENMAf2O5VEFLrRaYs2QTsZXxzxEA3vRT3qP+4yCFb3VrAO7bkUPiHUYr+sm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tG5bXmm+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tG5bXmm+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF5AFC116B1;
	Fri, 26 Apr 2024 03:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103944;
	bh=OCXm1Nt4iQcMXFNMeYb/FCAMzh/bNQtgLK4znA2g5M0=;
	h=Date:To:From:Subject:From;
	b=tG5bXmm+OBshQHJ2GSK4M9vrfwmlh3aB9yXqzkZ4NmOpVAgnGLq9s2xTiYvRIgpdN
	 1Szt+RR64VJjN6RlhTKjSkYvKRXgDfwYxbtK/qiJkEIoUw+roT3aAaktQYtPUv+kuR
	 RYaW4J++BUqZXt/yMNrpzMWDnFw1yZFRxHlF2WhA=
Date: Thu, 25 Apr 2024 20:59:03 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,osalvador@suse.de,muchun.song@linux.dev,linmiaohe@huawei.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-remove-mention-of-destructors.patch removed from -mm tree
Message-Id: <20240426035903.EF5AFC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlb: remove mention of destructors
has been removed from the -mm tree.  Its filename was
     hugetlb-remove-mention-of-destructors.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: hugetlb: remove mention of destructors
Date: Thu, 21 Mar 2024 14:24:47 +0000

We no longer have destructors or dtors, merely a page flag (technically a
page type flag, but that's an implementation detail).  Remove
__clear_hugetlb_destructor, fix up comments and the occasional variable
name.

Link: https://lkml.kernel.org/r/20240321142448.1645400-10-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   40 ++++++++++++++++------------------------
 1 file changed, 16 insertions(+), 24 deletions(-)

--- a/mm/hugetlb.c~hugetlb-remove-mention-of-destructors
+++ a/mm/hugetlb.c
@@ -1619,19 +1619,11 @@ static inline void destroy_compound_giga
 						unsigned int order) { }
 #endif
 
-static inline void __clear_hugetlb_destructor(struct hstate *h,
-						struct folio *folio)
-{
-	lockdep_assert_held(&hugetlb_lock);
-
-	__folio_clear_hugetlb(folio);
-}
-
 /*
  * Remove hugetlb folio from lists.
- * If vmemmap exists for the folio, update dtor so that the folio appears
- * as just a compound page.  Otherwise, wait until after allocating vmemmap
- * to update dtor.
+ * If vmemmap exists for the folio, clear the hugetlb flag so that the
+ * folio appears as just a compound page.  Otherwise, wait until after
+ * allocating vmemmap to clear the flag.
  *
  * A reference is held on the folio, except in the case of demote.
  *
@@ -1662,12 +1654,12 @@ static void __remove_hugetlb_folio(struc
 	}
 
 	/*
-	 * We can only clear the hugetlb destructor after allocating vmemmap
+	 * We can only clear the hugetlb flag after allocating vmemmap
 	 * pages.  Otherwise, someone (memory error handling) may try to write
 	 * to tail struct pages.
 	 */
 	if (!folio_test_hugetlb_vmemmap_optimized(folio))
-		__clear_hugetlb_destructor(h, folio);
+		__folio_clear_hugetlb(folio);
 
 	 /*
 	  * In the case of demote we do not ref count the page as it will soon
@@ -1741,7 +1733,7 @@ static void add_hugetlb_folio(struct hst
 static void __update_and_free_hugetlb_folio(struct hstate *h,
 						struct folio *folio)
 {
-	bool clear_dtor = folio_test_hugetlb_vmemmap_optimized(folio);
+	bool clear_flag = folio_test_hugetlb_vmemmap_optimized(folio);
 
 	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
 		return;
@@ -1754,11 +1746,11 @@ static void __update_and_free_hugetlb_fo
 		return;
 
 	/*
-	 * If folio is not vmemmap optimized (!clear_dtor), then the folio
+	 * If folio is not vmemmap optimized (!clear_flag), then the folio
 	 * is no longer identified as a hugetlb page.  hugetlb_vmemmap_restore_folio
 	 * can only be passed hugetlb pages and will BUG otherwise.
 	 */
-	if (clear_dtor && hugetlb_vmemmap_restore_folio(h, folio)) {
+	if (clear_flag && hugetlb_vmemmap_restore_folio(h, folio)) {
 		spin_lock_irq(&hugetlb_lock);
 		/*
 		 * If we cannot allocate vmemmap pages, just refuse to free the
@@ -1779,11 +1771,11 @@ static void __update_and_free_hugetlb_fo
 
 	/*
 	 * If vmemmap pages were allocated above, then we need to clear the
-	 * hugetlb destructor under the hugetlb lock.
+	 * hugetlb flag under the hugetlb lock.
 	 */
 	if (folio_test_hugetlb(folio)) {
 		spin_lock_irq(&hugetlb_lock);
-		__clear_hugetlb_destructor(h, folio);
+		__folio_clear_hugetlb(folio);
 		spin_unlock_irq(&hugetlb_lock);
 	}
 
@@ -1885,7 +1877,7 @@ static void bulk_vmemmap_restore_error(s
 		list_for_each_entry_safe(folio, t_folio, non_hvo_folios, lru) {
 			list_del(&folio->lru);
 			spin_lock_irq(&hugetlb_lock);
-			__clear_hugetlb_destructor(h, folio);
+			__folio_clear_hugetlb(folio);
 			spin_unlock_irq(&hugetlb_lock);
 			update_and_free_hugetlb_folio(h, folio, false);
 			cond_resched();
@@ -1910,7 +1902,7 @@ static void bulk_vmemmap_restore_error(s
 			} else {
 				list_del(&folio->lru);
 				spin_lock_irq(&hugetlb_lock);
-				__clear_hugetlb_destructor(h, folio);
+				__folio_clear_hugetlb(folio);
 				spin_unlock_irq(&hugetlb_lock);
 				update_and_free_hugetlb_folio(h, folio, false);
 				cond_resched();
@@ -1943,14 +1935,14 @@ retry:
 	 * should only be pages on the non_hvo_folios list.
 	 * Do note that the non_hvo_folios list could be empty.
 	 * Without HVO enabled, ret will be 0 and there is no need to call
-	 * __clear_hugetlb_destructor as this was done previously.
+	 * __folio_clear_hugetlb as this was done previously.
 	 */
 	VM_WARN_ON(!list_empty(folio_list));
 	VM_WARN_ON(ret < 0);
 	if (!list_empty(&non_hvo_folios) && ret) {
 		spin_lock_irq(&hugetlb_lock);
 		list_for_each_entry(folio, &non_hvo_folios, lru)
-			__clear_hugetlb_destructor(h, folio);
+			__folio_clear_hugetlb(folio);
 		spin_unlock_irq(&hugetlb_lock);
 	}
 
@@ -1975,7 +1967,7 @@ void free_huge_folio(struct folio *folio
 {
 	/*
 	 * Can't pass hstate in here because it is called from the
-	 * compound page destructor.
+	 * generic mm code.
 	 */
 	struct hstate *h = folio_hstate(folio);
 	int nid = folio_nid(folio);
@@ -2125,7 +2117,7 @@ static bool __prep_compound_gigantic_fol
 			set_compound_head(p, &folio->page);
 	}
 	__folio_set_head(folio);
-	/* we rely on prep_new_hugetlb_folio to set the destructor */
+	/* we rely on prep_new_hugetlb_folio to set the hugetlb flag */
 	folio_set_order(folio, order);
 	atomic_set(&folio->_entire_mapcount, -1);
 	atomic_set(&folio->_nr_pages_mapped, 0);
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

