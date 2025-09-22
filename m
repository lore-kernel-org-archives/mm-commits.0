Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC63121D3F5;
	Mon, 22 Sep 2025 22:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758580310; cv=none; b=b4A6Nz3VIzupHiJVMLmyD+sJdhEwBDIUJaDupNgSEidak0Dnmhe8s2dtTT7DiJeE0cl0iTwkyoTj67cfdaHf6SXJT73uo473Xug5Nc+1aaO/R7xNCAJPD/ecK13GhBi0KgDUE2KxbQfq2wXqH5pnTyVXDVlxjFHER5h152ZEEtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758580310; c=relaxed/simple;
	bh=IRVE3RzrnmzqED9rH5Kl1EzZeTA3qBfY7avoHEPz9WI=;
	h=Date:To:From:Subject:Message-Id; b=o260ClqBFEpvNUe5tfpLCDSFACBoVws1Q4Y2+mnIvDBdHerYT2Ipk6VxCGghTEkkrxSbiqsG7S+MdLIpp9B3qnUTYAeBRm+t+RnmmyP99Ok7J4Pgl+MWc1twvGSV9kUp4I8RcvSICkHZB8iyqvRKiyLhRmrDIvqkFAI57xvHtuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AlxR0kwF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AlxR0kwF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54029C4CEF0;
	Mon, 22 Sep 2025 22:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758580309;
	bh=IRVE3RzrnmzqED9rH5Kl1EzZeTA3qBfY7avoHEPz9WI=;
	h=Date:To:From:Subject:From;
	b=AlxR0kwFrCdOkw185VDUV42gEPN8eoALoHrJfub2mHU5T+hlmsIk64kpc6y5YNfru
	 9fHdrEcogJG5Jw30zlRuwCQrT6EPpvZf2Ve8L8PsJhwsNzvnZgZSoiywbiLc7xPRAE
	 muAjE2GqWdjByeEiaWDnTbVfowhZBfbfPLH/hWik=
Date: Mon, 22 Sep 2025 15:31:48 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,ying.huang@linux.alibaba.com,willy@infradead.org,usamaarif642@gmail.com,surenb@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,samuel.holland@sifive.com,ryncsn@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,roman.gushchin@linux.dev,riel@surriel.com,rakie.kim@sk.com,Qun-wei.Lin@mediatek.com,palmer@rivosinc.com,npache@redhat.com,matthew.brost@intel.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kaleshsingh@google.com,joshua.hahnjy@gmail.com,hughd@google.com,hannes@cmpxchg.org,gourry@gourry.net,dev.jain@arm.com,david@redhat.com,chinwen.chang@mediatek.com,charlie@rivosinc.com,cerasuolodomenico@gmail.com,catalin.marinas@arm.com,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,andrew.yang@mediatek.com,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-fix-mte-tag-mismatch-when-replacing-zero-filled-subpages.patch added to mm-hotfixes-unstable branch
Message-Id: <20250922223149.54029C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/thp: fix MTE tag mismatch when replacing zero-filled subpages
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-thp-fix-mte-tag-mismatch-when-replacing-zero-filled-subpages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-thp-fix-mte-tag-mismatch-when-replacing-zero-filled-subpages.patch

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
Subject: mm/thp: fix MTE tag mismatch when replacing zero-filled subpages
Date: Mon, 22 Sep 2025 10:14:58 +0800


When both THP and MTE are enabled, splitting a THP and replacing its
zero-filled subpages with the shared zeropage can cause MTE tag mismatch
faults in userspace.

Remapping zero-filled subpages to the shared zeropage is unsafe, as the
zeropage has a fixed tag of zero, which may not match the tag expected by
the userspace pointer.

KSM already avoids this problem by using memcmp_pages(), which on arm64
intentionally reports MTE-tagged pages as non-identical to prevent unsafe
merging.

As suggested by David[1], this patch adopts the same pattern, replacing the
memchr_inv() byte-level check with a call to pages_identical(). This
leverages existing architecture-specific logic to determine if a page is
truly identical to the shared zeropage.

Having both the THP shrinker and KSM rely on pages_identical() makes the
design more future-proof, IMO. Instead of handling quirks in generic code,
we just let the architecture decide what makes two pages identical.

[1] https://lore.kernel.org/all/ca2106a3-4bb2-4457-81af-301fd99fbef4@redhat.com

Link: https://lkml.kernel.org/r/20250922021458.68123-1-lance.yang@linux.dev
Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Reported-by: Qun-wei Lin <Qun-wei.Lin@mediatek.com>
Closes: https://lore.kernel.org/all/a7944523fcc3634607691c35311a5d59d1a3f8d4.camel@mediatek.com
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Usama Arif <usamaarif642@gmail.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: andrew.yang <andrew.yang@mediatek.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Charlie Jenkins <charlie@rivosinc.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Samuel Holland <samuel.holland@sifive.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   15 +++------------
 mm/migrate.c     |    8 +-------
 2 files changed, 4 insertions(+), 19 deletions(-)

--- a/mm/huge_memory.c~mm-thp-fix-mte-tag-mismatch-when-replacing-zero-filled-subpages
+++ a/mm/huge_memory.c
@@ -4115,32 +4115,23 @@ static unsigned long deferred_split_coun
 static bool thp_underused(struct folio *folio)
 {
 	int num_zero_pages = 0, num_filled_pages = 0;
-	void *kaddr;
 	int i;
 
 	if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
 		return false;
 
 	for (i = 0; i < folio_nr_pages(folio); i++) {
-		kaddr = kmap_local_folio(folio, i * PAGE_SIZE);
-		if (!memchr_inv(kaddr, 0, PAGE_SIZE)) {
-			num_zero_pages++;
-			if (num_zero_pages > khugepaged_max_ptes_none) {
-				kunmap_local(kaddr);
+		if (pages_identical(folio_page(folio, i), ZERO_PAGE(0))) {
+			if (++num_zero_pages > khugepaged_max_ptes_none)
 				return true;
-			}
 		} else {
 			/*
 			 * Another path for early exit once the number
 			 * of non-zero filled pages exceeds threshold.
 			 */
-			num_filled_pages++;
-			if (num_filled_pages >= HPAGE_PMD_NR - khugepaged_max_ptes_none) {
-				kunmap_local(kaddr);
+			if (++num_filled_pages >= HPAGE_PMD_NR - khugepaged_max_ptes_none)
 				return false;
-			}
 		}
-		kunmap_local(kaddr);
 	}
 	return false;
 }
--- a/mm/migrate.c~mm-thp-fix-mte-tag-mismatch-when-replacing-zero-filled-subpages
+++ a/mm/migrate.c
@@ -301,9 +301,7 @@ static bool try_to_map_unused_to_zeropag
 					  unsigned long idx)
 {
 	struct page *page = folio_page(folio, idx);
-	bool contains_data;
 	pte_t newpte;
-	void *addr;
 
 	if (PageCompound(page))
 		return false;
@@ -320,11 +318,7 @@ static bool try_to_map_unused_to_zeropag
 	 * this subpage has been non present. If the subpage is only zero-filled
 	 * then map it to the shared zeropage.
 	 */
-	addr = kmap_local_page(page);
-	contains_data = memchr_inv(addr, 0, PAGE_SIZE);
-	kunmap_local(addr);
-
-	if (contains_data)
+	if (!pages_identical(page, ZERO_PAGE(0)))
 		return false;
 
 	newpte = pte_mkspecial(pfn_pte(my_zero_pfn(pvmw->address),
_

Patches currently in -mm which might be from lance.yang@linux.dev are

hung_task-fix-warnings-caused-by-unaligned-lock-pointers.patch
mm-thp-fix-mte-tag-mismatch-when-replacing-zero-filled-subpages.patch
selftests-mm-skip-soft-dirty-tests-when-config_mem_soft_dirty-is-disabled.patch

