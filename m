Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3B5134A9
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 19:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dCKypCth"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A64C433C8;
	Fri, 29 Dec 2023 19:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703879986;
	bh=57ppdVU2XCsW0gJSRflvrsJ4U6+U6w9T8055cUu4ucc=;
	h=Date:To:From:Subject:From;
	b=dCKypCthWvFNyucRU1XSgAzsHBObb2Vby8Cm87Ie6jzLb/3LIbcaegIrZ4nXlbAhn
	 T4yXIuJ3HQqucCZvh4vJf7CpZrLaHFcyFsq+wkp2qYuR/9zzP7EA8y9/C34IowKA0V
	 +Ctd5vLsQ3MJHl9z1lJAapdYd7gBISlZF0KWX3gc=
Date: Fri, 29 Dec 2023 11:59:46 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,apopple@nvidia.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-migrate_vma_insert_page-to-use-a-folio.patch removed from -mm tree
Message-Id: <20231229195946.88A64C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: convert migrate_vma_insert_page() to use a folio
has been removed from the -mm tree.  Its filename was
     mm-convert-migrate_vma_insert_page-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert migrate_vma_insert_page() to use a folio
Date: Mon, 11 Dec 2023 16:22:12 +0000

Replaces five calls to compound_head() with one.

Link: https://lkml.kernel.org/r/20231211162214.2146080-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
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

mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

