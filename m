Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1B02110E;
	Tue, 30 Sep 2025 21:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759269096; cv=none; b=Mba3JmzC2bg7P/j5Oo9egaNRMevy1hrCLW1wDsFOEAMuK9W+b4DjfeKpl9YvsZWpxkXmVHfEDgoPsOar1ThNff81ChnDAme7lZbMAI+7VuVcy55/xi7rP/a39wuC5FQJEGkPztP8Xhr3cUgs6SxR+7yxJ58pTbqIdWwJYlWYOTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759269096; c=relaxed/simple;
	bh=bslu/l2CcgWsTKNdAVrk3vTbm98RpTdFT8fD9YRhjFM=;
	h=Date:To:From:Subject:Message-Id; b=htKyCY+oatDka5oxbF1Z0X/lZZuUdK3MPt0JRKSJfvktP2LU1lj+urBN8jPyKoQsRklr01roW0FZdgsXDxTfmfFxiT36pNa2NtIZB6pycZWu6w885rmW8d0nyBXte7pxjWjuPq2mfy4aKBpN9OV7uW05vo1KLnLvvZo0iJjlGYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qOGwF/Ly; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qOGwF/Ly"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC142C4CEF0;
	Tue, 30 Sep 2025 21:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759269096;
	bh=bslu/l2CcgWsTKNdAVrk3vTbm98RpTdFT8fD9YRhjFM=;
	h=Date:To:From:Subject:From;
	b=qOGwF/LyRJbK0V8i+olAnqSYl3oIV8/6ewzXNg53a5X4O0g/NIn228j8OXhswBx3S
	 OAUF1arma1VKB4UKXYVZxNcb3e66dXb69iBBXWAcK4hs8iP1EQvFHBHLwUxktNefnr
	 42B+HpcjnIUjZ4OteLncJdj5mi6AAwN5uCmKQ6Cc=
Date: Tue, 30 Sep 2025 14:51:35 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,ying.huang@linux.alibaba.com,vbabka@suse.cz,usamaarif642@gmail.com,stable@vger.kernel.org,ryan.roberts@arm.com,riel@surriel.com,rakie.kim@sk.com,peterx@redhat.com,npache@redhat.com,matthew.brost@intel.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,jannh@google.com,gourry@gourry.net,dev.jain@arm.com,david@redhat.com,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-fix-soft-dirty-and-uffd-wp-bit-loss-when-remapping-zero-filled-mthp-subpage-to-shared-zeropage.patch added to mm-hotfixes-unstable branch
Message-Id: <20250930215135.EC142C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: fix soft-dirty and uffd-wp bit loss when remapping zero-filled mTHP subpage to shared zeropage
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-rmap-fix-soft-dirty-and-uffd-wp-bit-loss-when-remapping-zero-filled-mthp-subpage-to-shared-zeropage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-fix-soft-dirty-and-uffd-wp-bit-loss-when-remapping-zero-filled-mthp-subpage-to-shared-zeropage.patch

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
From: Lance Yang <lance.yang@linux.dev>
Subject: mm/rmap: fix soft-dirty and uffd-wp bit loss when remapping zero-filled mTHP subpage to shared zeropage
Date: Tue, 30 Sep 2025 16:10:40 +0800

When splitting an mTHP and replacing a zero-filled subpage with the shared
zeropage, try_to_map_unused_to_zeropage() currently drops several
important PTE bits.

For userspace tools like CRIU, which rely on the soft-dirty mechanism for
incremental snapshots, losing the soft-dirty bit means modified pages are
missed, leading to inconsistent memory state after restore.

As pointed out by David, the more critical uffd-wp bit is also dropped. 
This breaks the userfaultfd write-protection mechanism, causing writes to
be silently missed by monitoring applications, which can lead to data
corruption.

Preserve both the soft-dirty and uffd-wp bits from the old PTE when
creating the new zeropage mapping to ensure they are correctly tracked.

Link: https://lkml.kernel.org/r/20250930081040.80926-1-lance.yang@linux.dev
Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/mm/migrate.c~mm-rmap-fix-soft-dirty-and-uffd-wp-bit-loss-when-remapping-zero-filled-mthp-subpage-to-shared-zeropage
+++ a/mm/migrate.c
@@ -297,8 +297,7 @@ bool isolate_folio_to_list(struct folio
 }
 
 static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
-					  struct folio *folio,
-					  unsigned long idx)
+		struct folio *folio, pte_t old_pte, unsigned long idx)
 {
 	struct page *page = folio_page(folio, idx);
 	pte_t newpte;
@@ -307,7 +306,7 @@ static bool try_to_map_unused_to_zeropag
 		return false;
 	VM_BUG_ON_PAGE(!PageAnon(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
-	VM_BUG_ON_PAGE(pte_present(ptep_get(pvmw->pte)), page);
+	VM_BUG_ON_PAGE(pte_present(old_pte), page);
 
 	if (folio_test_mlocked(folio) || (pvmw->vma->vm_flags & VM_LOCKED) ||
 	    mm_forbids_zeropage(pvmw->vma->vm_mm))
@@ -323,6 +322,12 @@ static bool try_to_map_unused_to_zeropag
 
 	newpte = pte_mkspecial(pfn_pte(my_zero_pfn(pvmw->address),
 					pvmw->vma->vm_page_prot));
+
+	if (pte_swp_soft_dirty(old_pte))
+		newpte = pte_mksoft_dirty(newpte);
+	if (pte_swp_uffd_wp(old_pte))
+		newpte = pte_mkuffd_wp(newpte);
+
 	set_pte_at(pvmw->vma->vm_mm, pvmw->address, pvmw->pte, newpte);
 
 	dec_mm_counter(pvmw->vma->vm_mm, mm_counter(folio));
@@ -365,13 +370,13 @@ static bool remove_migration_pte(struct
 			continue;
 		}
 #endif
+		old_pte = ptep_get(pvmw.pte);
 		if (rmap_walk_arg->map_unused_to_zeropage &&
-		    try_to_map_unused_to_zeropage(&pvmw, folio, idx))
+		    try_to_map_unused_to_zeropage(&pvmw, folio, old_pte, idx))
 			continue;
 
 		folio_get(folio);
 		pte = mk_pte(new, READ_ONCE(vma->vm_page_prot));
-		old_pte = ptep_get(pvmw.pte);
 
 		entry = pte_to_swp_entry(old_pte);
 		if (!is_migration_entry_young(entry))
_

Patches currently in -mm which might be from lance.yang@linux.dev are

hung_task-fix-warnings-caused-by-unaligned-lock-pointers.patch
mm-thp-fix-mte-tag-mismatch-when-replacing-zero-filled-subpages.patch
mm-rmap-fix-soft-dirty-and-uffd-wp-bit-loss-when-remapping-zero-filled-mthp-subpage-to-shared-zeropage.patch
mm-clean-up-is_guard_pte_marker.patch

