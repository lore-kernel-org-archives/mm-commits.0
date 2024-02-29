Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AAAB79F1
	for <mm-commits@vger.kernel.org>; Thu, 29 Feb 2024 18:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709231869; cv=none; b=Nrct99tuYidIe4TK7YnMacL4KJHJYNvdEiUng5aiHlAr7P5ZmSRJ275yhnkJ4G654C2x5RStzN4h2oq0Qw9gpco50MBCV/1cFiUoZGjvln2mlOfMbUeUmaxL+pr51TTyAXD5KBDDDapofaXOOcXt/KgPLvTJySpMkShAyHvm4io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709231869; c=relaxed/simple;
	bh=bxC818/D0XBaCALXxyoQq79wPohxzgMOOOoFvpiO2x8=;
	h=Date:To:From:Subject:Message-Id; b=p8yY1bM/sXuB6KLeb1ELxxukf70rwiWtEH3ejnlFmrt+KfH2Ev4KOw8Iw9Ux59cZKPGwDxlIZP3f6pgW6BYkGAKexq22Q+d9ACnFkbiWz/k8qUyk1sd9SCFORUpU09S6906tjOvcGUfgdjQ0N3HHV3mE6DqSU/egsiLBhZN96mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wcg6k2i1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wcg6k2i1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F7CC433F1;
	Thu, 29 Feb 2024 18:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709231869;
	bh=bxC818/D0XBaCALXxyoQq79wPohxzgMOOOoFvpiO2x8=;
	h=Date:To:From:Subject:From;
	b=wcg6k2i1LUhogRlbNz1jqrGKP5QK6FFEO+SszJg+VbrIQMnUpep4RbIyUsJFAQyz2
	 AeBxY0K026SOIPZtAJHO2O8/X2E49yJLecWbFn13BFNG8LUoWtNDLzffs3sFib2XWG
	 NbWbjp/RzU4w8puiKAPsZHJtk4cG0A67B+e7pR/I=
Date: Thu, 29 Feb 2024 10:37:48 -0800
To: mm-commits@vger.kernel.org,gregory.price@memverge.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-use-a-folio-in-do_mbind.patch added to mm-unstable branch
Message-Id: <20240229183748.F2F7CC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mempolicy: use a folio in do_mbind()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mempolicy-use-a-folio-in-do_mbind.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-use-a-folio-in-do_mbind.patch

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
Subject: mm/mempolicy: use a folio in do_mbind()
Date: Thu, 29 Feb 2024 15:29:45 +0000

We actually add folios to the pagelist already, but then work with them as
pages.  Removes a call to compound_head() in PageKsm() and removes a
reference to page->index.

Link: https://lkml.kernel.org/r/20240229153015.1996829-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Gregory Price <gregory.price@memverge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-use-a-folio-in-do_mbind
+++ a/mm/mempolicy.c
@@ -1356,29 +1356,30 @@ static long do_mbind(unsigned long start
 		 */
 		if (new->mode == MPOL_INTERLEAVE ||
 		    new->mode == MPOL_WEIGHTED_INTERLEAVE) {
-			struct page *page;
+			struct folio *folio;
 			unsigned int order;
 			unsigned long addr = -EFAULT;
 
-			list_for_each_entry(page, &pagelist, lru) {
-				if (!PageKsm(page))
+			list_for_each_entry(folio, &pagelist, lru) {
+				if (!folio_test_ksm(folio))
 					break;
 			}
-			if (!list_entry_is_head(page, &pagelist, lru)) {
+			if (!list_entry_is_head(folio, &pagelist, lru)) {
 				vma_iter_init(&vmi, mm, start);
 				for_each_vma_range(vmi, vma, end) {
-					addr = page_address_in_vma(page, vma);
+					addr = page_address_in_vma(
+						folio_page(folio, 0), vma);
 					if (addr != -EFAULT)
 						break;
 				}
 			}
 			if (addr != -EFAULT) {
-				order = compound_order(page);
+				order = folio_order(folio);
 				/* We already know the pol, but not the ilx */
 				mpol_cond_put(get_vma_policy(vma, addr, order,
 							     &mmpol.ilx));
 				/* Set base from which to increment by index */
-				mmpol.ilx -= page->index >> order;
+				mmpol.ilx -= folio->index >> order;
 			}
 		}
 	}
_

Patches currently in -mm which might be from willy@infradead.org are

mm-support-order-1-folios-in-the-page-cache.patch
mm-make-folios_put-the-basis-of-release_pages.patch
mm-convert-free_unref_page_list-to-use-folios.patch
mm-add-free_unref_folios.patch
mm-use-folios_put-in-__folio_batch_release.patch
memcg-add-mem_cgroup_uncharge_folios.patch
mm-remove-use-of-folio-list-from-folios_put.patch
mm-use-free_unref_folios-in-put_pages_list.patch
mm-use-__page_cache_release-in-folios_put.patch
mm-handle-large-folios-in-free_unref_folios.patch
mm-allow-non-hugetlb-large-folios-to-be-batch-processed.patch
mm-free-folios-in-a-batch-in-shrink_folio_list.patch
mm-free-folios-directly-in-move_folios_to_lru.patch
memcg-remove-mem_cgroup_uncharge_list.patch
mm-remove-free_unref_page_list.patch
mm-remove-lru_to_page.patch
mm-convert-free_pages_and_swap_cache-to-use-folios_put.patch
mm-use-a-folio-in-__collapse_huge_page_copy_succeeded.patch
mm-convert-free_swap_cache-to-take-a-folio.patch
mm-use-folio-more-widely-in-__split_huge_page.patch
mm-separate-out-folio_flags-from-pageflags.patch
mm-remove-pagewaiters-pagesetwaiters-and-pageclearwaiters.patch
mm-remove-pageyoung-and-pageidle-definitions.patch
mm-add-__dump_folio.patch
mm-make-dump_page-take-a-const-argument.patch
mm-constify-testing-page-folio-flags.patch
mm-constify-more-page-folio-tests.patch
mm-remove-cast-from-page_to_nid.patch
mm-mempolicy-use-a-folio-in-do_mbind.patch

