Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2668C13FE3
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Oubtw7e5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7038C433C8;
	Fri, 29 Dec 2023 20:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880093;
	bh=fkyvDLvXky0+f/8iP7h+DwnQkRgOFygE2bRFLREWWIE=;
	h=Date:To:From:Subject:From;
	b=Oubtw7e5RrqjQD3zWeZZXN08xN6e7GfqoUTt1NbHGgGwaWi+VJLH+vCMplhcbkIPn
	 +LYPARjQZ9BXwEyzddaVlV3U53FDdMaYfDKb7AO0ZO93hfuuIywHod29Tp+KssZ+6J
	 V5BZYm/4kXH9/mNVlZ8JA+2Q/AZHyh6QhrjQKPm0=
Date: Fri, 29 Dec 2023 12:01:32 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-page_add_file_rmap-folio_add_file_rmap_pmd.patch removed from -mm tree
Message-Id: <20231229200132.E7038C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: page_add_file_rmap() -> folio_add_file_rmap_pmd()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-page_add_file_rmap-folio_add_file_rmap_pmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/huge_memory: page_add_file_rmap() -> folio_add_file_rmap_pmd()
Date: Wed, 20 Dec 2023 23:44:33 +0100

Let's convert remove_migration_pmd() and while at it, perform some folio
conversion.

Link: https://lkml.kernel.org/r/20231220224504.646757-10-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-page_add_file_rmap-folio_add_file_rmap_pmd
+++ a/mm/huge_memory.c
@@ -3577,6 +3577,7 @@ int set_pmd_migration_entry(struct page_
 
 void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
 {
+	struct folio *folio = page_folio(new);
 	struct vm_area_struct *vma = pvmw->vma;
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long address = pvmw->address;
@@ -3588,7 +3589,7 @@ void remove_migration_pmd(struct page_vm
 		return;
 
 	entry = pmd_to_swp_entry(*pvmw->pmd);
-	get_page(new);
+	folio_get(folio);
 	pmde = mk_huge_pmd(new, READ_ONCE(vma->vm_page_prot));
 	if (pmd_swp_soft_dirty(*pvmw->pmd))
 		pmde = pmd_mksoft_dirty(pmde);
@@ -3599,10 +3600,10 @@ void remove_migration_pmd(struct page_vm
 	if (!is_migration_entry_young(entry))
 		pmde = pmd_mkold(pmde);
 	/* NOTE: this may contain setting soft-dirty on some archs */
-	if (PageDirty(new) && is_migration_entry_dirty(entry))
+	if (folio_test_dirty(folio) && is_migration_entry_dirty(entry))
 		pmde = pmd_mkdirty(pmde);
 
-	if (PageAnon(new)) {
+	if (folio_test_anon(folio)) {
 		rmap_t rmap_flags = RMAP_COMPOUND;
 
 		if (!is_readable_migration_entry(entry))
@@ -3610,9 +3611,9 @@ void remove_migration_pmd(struct page_vm
 
 		page_add_anon_rmap(new, vma, haddr, rmap_flags);
 	} else {
-		page_add_file_rmap(new, vma, true);
+		folio_add_file_rmap_pmd(folio, new, vma);
 	}
-	VM_BUG_ON(pmd_write(pmde) && PageAnon(new) && !PageAnonExclusive(new));
+	VM_BUG_ON(pmd_write(pmde) && folio_test_anon(folio) && !PageAnonExclusive(new));
 	set_pmd_at(mm, haddr, pvmw->pmd, pmde);
 
 	/* No need to invalidate - it was non-present before */
_

Patches currently in -mm which might be from david@redhat.com are


