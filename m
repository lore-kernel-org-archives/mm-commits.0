Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBEC33A6EB
	for <mm-commits@vger.kernel.org>; Thu, 30 Jul 2026 19:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785439085; cv=none; b=BmI2/F5STeQq46YLtfRA+52+LdC/dwbVuMmMsafhrMgG9j+1u05B+hNsqL+Y9ISKQb+Kpn9KbFNj+bUGT4Ng4y5LvUMF5bXSccLcFlvfV1tuYr3wN15vM1HKo5wBE3C9/ksKL7/V6H3iLzGsKeK5s6PknVN4z3Q2nRQXMjaBEpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785439085; c=relaxed/simple;
	bh=UxpL7xXL34hvAuaeprj//+03nEOgh0QCB0Y5lU3SRQk=;
	h=Date:To:From:Subject:Message-Id; b=PgnkDbKj37WYvv94lKKgVlLsOJBmTm1Z/W9T9CpSEBT+H5k3nddRu0cZEVjkxCdGjcZre0C/Qt8aGWiyOjI3NtCMLxV6U+DECXrXr9QXDoHb7QMX5YCCFMeKQwOVnWmqItacbCQxvci+6Dcxni53DeWB34hcofcZBWZ3a8Tanjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hwRjNrsz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hwRjNrsz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C6B31F000E9;
	Thu, 30 Jul 2026 19:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785439083;
	bh=/5osiqI1SkmdYHqXC4prcEl1IQr6/eK3GxToiL7KUW8=;
	h=Date:To:From:Subject;
	b=hwRjNrszFn888z3OCYPfKIJdNZlXWoWYxNn849onJEI0lIEuKFJiVZsILW9FTw6ZD
	 KEYXcPfeym80lIkFuuVizLRbqSLrmzeZ0jfbh/9NK3Ixdbs93J69kOeqUSieL4QcNM
	 3MCxxMRJYIwQru3rJQfzvr47cxb2PKsFBJhoMzEo=
Date: Thu, 30 Jul 2026 12:18:02 -0700
To: mm-commits@vger.kernel.org,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-rmap-convert-page-folio-for-hwpoison-checks.patch removed from -mm tree
Message-Id: <20260730191803.3C6B31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: convert page -> folio for hwpoison checks
has been removed from the -mm tree.  Its filename was
     mm-rmap-convert-page-folio-for-hwpoison-checks.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: mm/rmap: convert page -> folio for hwpoison checks
Date: Mon, 13 Jul 2026 05:00:44 +0000

Patch series "mm/rmap: Refactor try_to_unmap_one", v3.

In preparation for batching anonymous large folio unmapping to optimize
it, refactor try_to_unmap_one.  This series refactors hugetlb,
anon-lazyfree and anon-swapbacked logic into their own functions,
significantly reducing the length of the huge try_to_unmap_one.


This patch (of 5):

try_to_unmap() receives hugetlb folios only from the hwpoison path. 
hugetlb_update_hwpoison() sets the hugetlb folio's head-page hwpoison bit,
and page_vma_mapped_walk() reports the hugetlb mapping at the head PFN, so
the previous PageHWPoison(subpage) check happened to work for hugetlb.

For non-hugetlb folios, unmap_poisoned_folio() currently rejects large
folios before calling try_to_unmap().  Hence it is always the case that if
try_to_unmap_one() handles an hwpoisoned folio, then the head page is
marked with the poison bit.

Therefore, convert the poisoned subpage checks to folio_test_hwpoison().

No functional change intended, except that, while at it, convert VM_BUG_*
to VM_WARN_*.

Link: https://lore.kernel.org/20260713050050.1017741-1-dev.jain@arm.com
Link: https://lore.kernel.org/20260713050050.1017741-2-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/mm/rmap.c~mm-rmap-convert-page-folio-for-hwpoison-checks
+++ a/mm/rmap.c
@@ -2122,10 +2122,11 @@ static bool try_to_unmap_one(struct foli
 			bool anon = folio_test_anon(folio);
 
 			/*
-			 * The try_to_unmap() is only passed a hugetlb page
-			 * in the case where the hugetlb page is poisoned.
+			 * The try_to_unmap() is only passed a hugetlb folio
+			 * in the case where the hugetlb folio contains a
+			 * poisoned page.
 			 */
-			VM_BUG_ON_PAGE(!PageHWPoison(subpage), subpage);
+			VM_WARN_ON_FOLIO(!folio_test_hwpoison(folio), folio);
 			/*
 			 * huge_pmd_unshare may unmap an entire PMD page.
 			 * There is no way of knowing exactly which PMDs may
@@ -2204,7 +2205,11 @@ static bool try_to_unmap_one(struct foli
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
 
-		if (PageHWPoison(subpage) && (flags & TTU_HWPOISON)) {
+		/*
+		 * With TTU_HWPOISON, we only expect small folios or hugetlb
+		 * folios here for now.
+		 */
+		if (folio_test_hwpoison(folio) && (flags & TTU_HWPOISON)) {
 			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
 			if (folio_test_hugetlb(folio)) {
 				hugetlb_count_sub(folio_nr_pages(folio), mm);
_

Patches currently in -mm which might be from dev.jain@arm.com are

mm-rmap-use-huge_ptep_get-in-try_to_unmap_one.patch
mm-rmap-use-huge_ptep_get-in-try_to_migrate_one.patch
mm-migrate-use-huge_ptep_get-in-remove_migration_pte.patch
mm-page_vma_mapped-use-huge_ptep_get-for-hugetlb.patch
mm-mprotect-use-huge_ptep_get-for-hugetlb.patch
mm-rmap-add-try_to_unmap_hugetlb_one.patch
mm-rmap-refactor-some-code-around-lazyfree-folio-unmapping.patch
mm-rmap-refactor-anon-folio-unmap-in-try_to_unmap_one.patch
mm-rmap-add-anon-folio-unmap-dispatcher.patch
mm-memory-move-pte_install_uffd_wp_if_needed-into-memoryc.patch
mm-memory-batch-set-uffd-wp-markers-during-zapping.patch
mm-rmap-batch-unmap-file-folios-belonging-to-uffd-wp-vmas.patch

