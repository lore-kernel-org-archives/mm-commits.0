Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A144D582
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 17:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DBAnwIx8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B3AC433C8;
	Mon, 11 Dec 2023 17:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702315425;
	bh=28TKPN5XiKmwqghL089Bv5h12blN5xm7a1Scp+bB/9Y=;
	h=Date:To:From:Subject:From;
	b=DBAnwIx8kbKlm1YkAviHYVri+R5fukSmGQeykthMF7dD4Vy7Q1UG4kLaSUbItzVCu
	 mBkcn0MbbbwyG6vNf0Qw4S7FJtEvb18NDUcSRN4FZp1p3VOvo56+8ppBQzdxd8BxhZ
	 iXHTvvnJYh4KKjKH2bVGjoACIe0XbdlxGwDH3fHc=
Date: Mon, 11 Dec 2023 09:23:45 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-migrate_vma_insert_page-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20231211172345.B2B3AC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: convert migrate_vma_insert_page() to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-migrate_vma_insert_page-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-migrate_vma_insert_page-to-use-a-folio.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert migrate_vma_insert_page() to use a folio
Date: Mon, 11 Dec 2023 16:22:12 +0000

Replaces five calls to compound_head() with one.

Link: https://lkml.kernel.org/r/20231211162214.2146080-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/mm/migrate_device.c~mm-convert-migrate_vma_insert_page-to-use-a-folio
+++ a/mm/migrate_device.c
@@ -564,6 +564,7 @@ static void migrate_vma_insert_page(stru
 				    struct page *page,
 				    unsigned long *src)
 {
+	struct folio *folio = page_folio(page);
 	struct vm_area_struct *vma = migrate->vma;
 	struct mm_struct *mm = vma->vm_mm;
 	bool flush = false;
@@ -596,17 +597,17 @@ static void migrate_vma_insert_page(stru
 		goto abort;
 	if (unlikely(anon_vma_prepare(vma)))
 		goto abort;
-	if (mem_cgroup_charge(page_folio(page), vma->vm_mm, GFP_KERNEL))
+	if (mem_cgroup_charge(folio, vma->vm_mm, GFP_KERNEL))
 		goto abort;
 
 	/*
-	 * The memory barrier inside __SetPageUptodate makes sure that
-	 * preceding stores to the page contents become visible before
+	 * The memory barrier inside __folio_mark_uptodate makes sure that
+	 * preceding stores to the folio contents become visible before
 	 * the set_pte_at() write.
 	 */
-	__SetPageUptodate(page);
+	__folio_mark_uptodate(folio);
 
-	if (is_device_private_page(page)) {
+	if (folio_is_device_private(folio)) {
 		swp_entry_t swp_entry;
 
 		if (vma->vm_flags & VM_WRITE)
@@ -617,8 +618,8 @@ static void migrate_vma_insert_page(stru
 						page_to_pfn(page));
 		entry = swp_entry_to_pte(swp_entry);
 	} else {
-		if (is_zone_device_page(page) &&
-		    !is_device_coherent_page(page)) {
+		if (folio_is_zone_device(folio) &&
+		    !folio_is_device_coherent(folio)) {
 			pr_warn_once("Unsupported ZONE_DEVICE page type.\n");
 			goto abort;
 		}
@@ -652,10 +653,10 @@ static void migrate_vma_insert_page(stru
 		goto unlock_abort;
 
 	inc_mm_counter(mm, MM_ANONPAGES);
-	page_add_new_anon_rmap(page, vma, addr);
-	if (!is_zone_device_page(page))
-		lru_cache_add_inactive_or_unevictable(page, vma);
-	get_page(page);
+	folio_add_new_anon_rmap(folio, vma, addr);
+	if (!folio_is_zone_device(folio))
+		folio_add_lru_vma(folio, vma);
+	folio_get(folio);
 
 	if (flush) {
 		flush_cache_page(vma, addr, pte_pfn(orig_pte));
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch
mm-convert-ksm_might_need_to_copy-to-work-on-folios.patch
mm-simplify-the-assertions-in-unuse_pte.patch
mm-convert-unuse_pte-to-use-a-folio-throughout.patch
mm-remove-some-calls-to-page_add_new_anon_rmap.patch
mm-remove-stale-example-from-comment.patch
mm-remove-references-to-page_add_new_anon_rmap-in-comments.patch
mm-convert-migrate_vma_insert_page-to-use-a-folio.patch
mm-convert-collapse_huge_page-to-use-a-folio.patch
mm-remove-page_add_new_anon_rmap-and-lru_cache_add_inactive_or_unevictable.patch

