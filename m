Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A26C7604D
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104042; cv=none; b=VFpMNpQR8WFUbbqnZ30mDeufbfnkKcb21C+pckb9Ivf0+66pHsXDFO2UQ0Uw8fi/pz5ZJSEQ1S4wmQoGkerO0q1koqKVaYpbQry+gfoQ94nIYVfp66aMIaGqokHiYMwPHEg80oektmwvH45dzPgSEAc2x2mQI/LXCArb51aBLO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104042; c=relaxed/simple;
	bh=1aHnKZAj0phKwIO3RGKWToyhZBzqOP+0M3SV3d7nqtw=;
	h=Date:To:From:Subject:Message-Id; b=VfYs0bUjli4PNDjNYPNddaexLLfpLTxVp7kPDOxHD47WcomBqq2GI+0b3RkuTaOksXmXquaPLpsho9O2zaAQdqpisIJXpHBrju+Ui1EzfxRwB17xXCMwms1fu7NJRoRJ972kCLBM/X5YriiFIrF+LFO2PGBnO5VzrALeP/hYDUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kfguE1Ek; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kfguE1Ek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E423FC116B1;
	Fri, 26 Apr 2024 04:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104042;
	bh=1aHnKZAj0phKwIO3RGKWToyhZBzqOP+0M3SV3d7nqtw=;
	h=Date:To:From:Subject:From;
	b=kfguE1EkjQAd7U7chQ8NSqQexKE16aCC1Wh2Y0FzZAWI4vhjYBRLjw0Zr/rzC7EWS
	 ya/VJqTTqPTIZD0jNTeNYGnu+z3fO29nt1XAx8cd9Glgcg8kk5TW95fqzVstrcKe0p
	 /Uso4HJZUowcL8/OPw7sun9ZACNpii6XoGx3+NmY=
Date: Thu, 25 Apr 2024 21:00:41 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-is_huge_zero_folio.patch removed from -mm tree
Message-Id: <20240426040041.E423FC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add is_huge_zero_folio()
has been removed from the -mm tree.  Its filename was
     mm-add-is_huge_zero_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add is_huge_zero_folio()
Date: Tue, 26 Mar 2024 20:28:22 +0000

This is the folio equivalent of is_huge_zero_page().  It doesn't add any
efficiency, but it does prevent the caller from passing a tail page and
getting confused when the predicate returns false.

Link: https://lkml.kernel.org/r/20240326202833.523759-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c          |    2 +-
 include/linux/huge_mm.h |   10 ++++++++++
 mm/huge_memory.c        |    6 +++---
 mm/mempolicy.c          |    2 +-
 mm/swap.c               |    2 +-
 mm/swap_state.c         |    2 +-
 mm/userfaultfd.c        |    2 +-
 7 files changed, 18 insertions(+), 8 deletions(-)

--- a/fs/proc/page.c~mm-add-is_huge_zero_folio
+++ a/fs/proc/page.c
@@ -155,7 +155,7 @@ u64 stable_page_flags(const struct page
 	else if (folio_test_large(folio)) {
 		if ((k & (1 << PG_lru)) || is_anon)
 			u |= 1 << KPF_THP;
-		else if (is_huge_zero_page(&folio->page)) {
+		else if (is_huge_zero_folio(folio)) {
 			u |= 1 << KPF_ZERO_PAGE;
 			u |= 1 << KPF_THP;
 		}
--- a/include/linux/huge_mm.h~mm-add-is_huge_zero_folio
+++ a/include/linux/huge_mm.h
@@ -356,6 +356,11 @@ static inline bool is_huge_zero_page(con
 	return READ_ONCE(huge_zero_page) == page;
 }
 
+static inline bool is_huge_zero_folio(const struct folio *folio)
+{
+	return READ_ONCE(huge_zero_page) == &folio->page;
+}
+
 static inline bool is_huge_zero_pmd(pmd_t pmd)
 {
 	return pmd_present(pmd) && READ_ONCE(huge_zero_pfn) == pmd_pfn(pmd);
@@ -484,6 +489,11 @@ static inline bool is_huge_zero_page(con
 {
 	return false;
 }
+
+static inline bool is_huge_zero_folio(const struct folio *folio)
+{
+	return false;
+}
 
 static inline bool is_huge_zero_pmd(pmd_t pmd)
 {
--- a/mm/huge_memory.c~mm-add-is_huge_zero_folio
+++ a/mm/huge_memory.c
@@ -789,12 +789,12 @@ struct deferred_split *get_deferred_spli
 }
 #endif
 
-static inline bool is_transparent_hugepage(struct folio *folio)
+static inline bool is_transparent_hugepage(const struct folio *folio)
 {
 	if (!folio_test_large(folio))
 		return false;
 
-	return is_huge_zero_page(&folio->page) ||
+	return is_huge_zero_folio(folio) ||
 		folio_test_large_rmappable(folio);
 }
 
@@ -3085,7 +3085,7 @@ int split_huge_page_to_list_to_order(str
 	}
 
 
-	is_hzp = is_huge_zero_page(&folio->page);
+	is_hzp = is_huge_zero_folio(folio);
 	if (is_hzp) {
 		pr_warn_ratelimited("Called split_huge_page for huge zero page\n");
 		return -EBUSY;
--- a/mm/mempolicy.c~mm-add-is_huge_zero_folio
+++ a/mm/mempolicy.c
@@ -510,7 +510,7 @@ static void queue_folios_pmd(pmd_t *pmd,
 		return;
 	}
 	folio = pfn_folio(pmd_pfn(*pmd));
-	if (is_huge_zero_page(&folio->page)) {
+	if (is_huge_zero_folio(folio)) {
 		walk->action = ACTION_CONTINUE;
 		return;
 	}
--- a/mm/swap.c~mm-add-is_huge_zero_folio
+++ a/mm/swap.c
@@ -985,7 +985,7 @@ void folios_put_refs(struct folio_batch
 		struct folio *folio = folios->folios[i];
 		unsigned int nr_refs = refs ? refs[i] : 1;
 
-		if (is_huge_zero_page(&folio->page))
+		if (is_huge_zero_folio(folio))
 			continue;
 
 		if (folio_is_zone_device(folio)) {
--- a/mm/swap_state.c~mm-add-is_huge_zero_folio
+++ a/mm/swap_state.c
@@ -301,7 +301,7 @@ void free_page_and_swap_cache(struct pag
 	struct folio *folio = page_folio(page);
 
 	free_swap_cache(folio);
-	if (!is_huge_zero_page(page))
+	if (!is_huge_zero_folio(folio))
 		folio_put(folio);
 }
 
--- a/mm/userfaultfd.c~mm-add-is_huge_zero_folio
+++ a/mm/userfaultfd.c
@@ -1664,7 +1664,7 @@ ssize_t move_pages(struct userfaultfd_ct
 			    !pmd_none(dst_pmdval)) {
 				struct folio *folio = pfn_folio(pmd_pfn(*src_pmd));
 
-				if (!folio || (!is_huge_zero_page(&folio->page) &&
+				if (!folio || (!is_huge_zero_folio(folio) &&
 					       !PageAnonExclusive(&folio->page))) {
 					spin_unlock(ptl);
 					err = -EBUSY;
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

