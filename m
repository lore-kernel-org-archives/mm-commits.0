Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD3F36C5AE
	for <mm-commits@vger.kernel.org>; Thu, 30 Jul 2026 19:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785439604; cv=none; b=FZCVRBbZeAi0saL0JUq2f8CKX623zhmza8LTtvZonTN5VcoPkYRthQqr4TeeMmYrF0TRzcf3jCLb/hw/aFR2zkfkFhwNJEv1eVQ7KZ0S6q6e7xlQ4FpE3S7kl/1D0VQhJdEduQyPXf1LgnBovAiUw/U5sqQW2SLA/iY+NF1yqVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785439604; c=relaxed/simple;
	bh=nyWjKMjtmWFLITJbsZNaWcZe6pflmXdW4eJl2qPIOQU=;
	h=Date:To:From:Subject:Message-Id; b=lbbsW3yF3SMaPfMTNCFJGBDDaRNryKDlkWFB/KbWZv1AbrjJ6DWXGnurfLv8mGa6WMECmNJ2SjJJQVbwnbr5xZIPh21Brk9xfoa3x6S1ecQJ/j8AVz6cLuOicsYb8qljDTv6p9/9y2WbkjH0aq3iX548ngH8nkUXSJdck/240TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x9JKN0sZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x9JKN0sZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E411F00A3A;
	Thu, 30 Jul 2026 19:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785439597;
	bh=rvazwo5R7bFtxZx0Zx5FT3sTCIoxHtqJ6Offm8ZE9fU=;
	h=Date:To:From:Subject;
	b=x9JKN0sZuJ/ppqyjOSuwFQcKlLWIm1gSY3KFPRXZCJhwXeKPzT5bnpFSx1hYB52Iu
	 qWHHv+KHJKrjCqpiQswT/ChFlA74fq9QpkVQY62MU+3L3sYhL+V1NGitqPyDhKzNy2
	 appOVjugKYe8rodo6Sd+Ilxw+5zV5AjC6csaI9wM=
Date: Thu, 30 Jul 2026 12:26:36 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,ryan.roberts@arm.com,riel@surriel.com,osalvador@suse.de,muchun.song@linux.dev,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jannh@google.com,harry@kernel.org,david@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-add-anon-folio-unmap-dispatcher.patch added to mm-unstable branch
Message-Id: <20260730192636.E7E411F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: add anon folio unmap dispatcher
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-add-anon-folio-unmap-dispatcher.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-add-anon-folio-unmap-dispatcher.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: mm/rmap: add anon folio unmap dispatcher
Date: Thu, 30 Jul 2026 09:45:56 +0000

Add ttu_anon_folio() as the common entry point for anonymous folio
unmapping.  It dispatches to the lazyfree or swapbacked helper as
appropriate.

Keep restoration of cleared PTEs in the caller, where the PTEs were
removed.

No functional change intended.

Link: https://lore.kernel.org/20260730094559.418003-6-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   45 +++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

--- a/mm/rmap.c~mm-rmap-add-anon-folio-unmap-dispatcher
+++ a/mm/rmap.c
@@ -2172,6 +2172,26 @@ static bool ttu_anon_swapbacked_folio(st
 	return true;
 }
 
+static bool ttu_anon_folio(struct vm_area_struct *vma, struct folio *folio,
+		struct page *page, unsigned long address, pte_t *ptep,
+		pte_t pteval, unsigned long nr_pages)
+{
+	/*
+	 * Store the swap location in the pte.
+	 * See handle_pte_fault() ...
+	 */
+	if (WARN_ON_ONCE(folio_test_swapbacked(folio) !=
+			 folio_test_swapcache(folio)))
+		return false;
+
+	if (!folio_test_swapbacked(folio))
+		return ttu_anon_lazyfree_folio(vma, folio, nr_pages);
+
+	/* nr_pages > 1 not supported yet */
+	return ttu_anon_swapbacked_folio(vma, folio, page, address, ptep,
+					 pteval);
+}
+
 /*
  * @arg: enum ttu_flags will be passed to this argument
  */
@@ -2349,31 +2369,12 @@ static bool try_to_unmap_one(struct foli
 			 */
 			dec_mm_counter(mm, mm_counter(folio));
 		} else if (folio_test_anon(folio)) {
-			/*
-			 * Store the swap location in the pte.
-			 * See handle_pte_fault() ...
-			 */
-			if (unlikely(folio_test_swapbacked(folio) !=
-					folio_test_swapcache(folio))) {
-				WARN_ON_ONCE(1);
+			if (!ttu_anon_folio(vma, folio, page, address,
+					    pvmw.pte, pteval, nr_pages)) {
+				set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
 				goto walk_abort;
 			}
 
-			/* MADV_FREE page check */
-			if (!folio_test_swapbacked(folio)) {
-				if (!ttu_anon_lazyfree_folio(vma, folio,
-							     nr_pages)) {
-					set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
-					goto walk_abort;
-				}
-				goto finish_unmap;
-			}
-
-			if (!ttu_anon_swapbacked_folio(vma, folio, page, address,
-						pvmw.pte, pteval)) {
-				set_pte_at(mm, address, pvmw.pte, pteval);
-				goto walk_abort;
-			}
 			goto finish_unmap;
 		} else {
 			/*
_

Patches currently in -mm which might be from dev.jain@arm.com are

mm-rmap-use-huge_ptep_get-in-try_to_unmap_one.patch
mm-rmap-use-huge_ptep_get-in-try_to_migrate_one.patch
mm-migrate-use-huge_ptep_get-in-remove_migration_pte.patch
mm-page_vma_mapped-use-huge_ptep_get-for-hugetlb.patch
mm-mprotect-use-huge_ptep_get-for-hugetlb.patch
mm-rmap-convert-page-folio-for-hwpoison-checks.patch
mm-rmap-add-try_to_unmap_poisoned_hugetlb_one.patch
mm-rmap-refactor-some-code-around-lazyfree-folio-unmapping.patch
mm-rmap-refactor-anon-folio-unmap-in-try_to_unmap_one.patch
mm-rmap-add-anon-folio-unmap-dispatcher.patch
mm-memory-move-pte_install_uffd_wp_if_needed-into-memoryc.patch
mm-memory-batch-set-uffd-wp-markers-during-zapping.patch
mm-rmap-batch-unmap-file-folios-belonging-to-uffd-wp-vmas.patch

