Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96002C54EBD
	for <mm-commits@archiver.kernel.org>; Mon,  9 Jan 2023 22:13:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235472AbjAIWNq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Jan 2023 17:13:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237627AbjAIWNp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2023 17:13:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A261B17599
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 14:13:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F3B2B80DE2
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 22:13:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A1EC433EF;
        Mon,  9 Jan 2023 22:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673302419;
        bh=yK+NignC8HzPDFMiWVdFm8XwuEu8wkdiznlAdxsaz74=;
        h=Date:To:From:Subject:From;
        b=oGZhYFy/HOJLGvf6mYX0QpN3eGMhtCRMWUSk+WzaTDMKDwdfbSRxMbvIPnctfe4Ez
         4/FkfTi/wo7UkbTK16+vb0EGJsVLSedT3tHHYAP6P7JTFLzajfMlsaY8pOQu04iNUX
         d2a/QsfmDyZUpNK6TZoED5Es/FcZJNPOkKU8NRwk=
Date:   Mon, 09 Jan 2023 14:13:38 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-remove-folio_sz-field-from-damon_pa_access_chk_result.patch added to mm-unstable branch
Message-Id: <20230109221339.A2A1EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/paddr: remove folio_sz field from damon_pa_access_chk_result
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-paddr-remove-folio_sz-field-from-damon_pa_access_chk_result.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-remove-folio_sz-field-from-damon_pa_access_chk_result.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/paddr: remove folio_sz field from damon_pa_access_chk_result
Date: Mon, 9 Jan 2023 21:33:34 +0000

DAMON physical address space monitoring operations set gets and saves size
of the folio for a given physical address inside rmap walks, but it can be
directly caluclated outside of the walks.  Remove the 'folio_sz' field
from 'damon_pa_access_chk_result struct' and calculate the size directly
from outside of the walks.

Link: https://lkml.kernel.org/r/20230109213335.62525-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-remove-folio_sz-field-from-damon_pa_access_chk_result
+++ a/mm/damon/paddr.c
@@ -80,8 +80,6 @@ static void damon_pa_prepare_access_chec
 }
 
 struct damon_pa_access_chk_result {
-	/* size of the folio for the access checked physical memory address */
-	unsigned long folio_sz;
 	bool accessed;
 };
 
@@ -92,7 +90,6 @@ static bool __damon_pa_young(struct foli
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, addr, 0);
 
 	result->accessed = false;
-	result->folio_sz = PAGE_SIZE;
 	while (page_vma_mapped_walk(&pvmw)) {
 		addr = pvmw.address;
 		if (pvmw.pte) {
@@ -104,7 +101,6 @@ static bool __damon_pa_young(struct foli
 			result->accessed = pmd_young(*pvmw.pmd) ||
 				!folio_test_idle(folio) ||
 				mmu_notifier_test_young(vma->vm_mm, addr);
-			result->folio_sz = HPAGE_PMD_SIZE;
 #else
 			WARN_ON_ONCE(1);
 #endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
@@ -123,7 +119,6 @@ static bool damon_pa_young(unsigned long
 {
 	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
 	struct damon_pa_access_chk_result result = {
-		.folio_sz = PAGE_SIZE,
 		.accessed = false,
 	};
 	struct rmap_walk_control rwc = {
@@ -158,7 +153,7 @@ static bool damon_pa_young(unsigned long
 	folio_put(folio);
 
 out:
-	*folio_sz = result.folio_sz;
+	*folio_sz = folio_size(folio);
 	return result.accessed;
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

include-linux-mm-fix-release_pages_arg-kernel-doc-comment.patch
mm-damon-core-implement-damos-filter.patch
mm-damon-paddr-support-damos-filters.patch
mm-damon-reclaim-add-a-parameter-called-skip_anon-for-avoiding-anonymous-pages-reclamation.patch
docs-admin-guide-damon-reclaim-document-skip_anon-parameter.patch
mm-damon-sysfs-schemes-implement-filters-directory.patch
mm-damon-sysfs-schemes-implement-filter-directory.patch
mm-damon-sysfs-schemes-connect-filter-directory-and-filters-directory.patch
mm-damon-sysfs-schemes-implement-scheme-filters.patch
mm-damon-sysfs-schemes-implement-scheme-filters-fix.patch
mm-damon-sysfs-schemes-implement-scheme-filters-fix-fix-2.patch
selftests-damon-sysfs-test-filters-directory.patch
docs-admin-guide-mm-damon-usage-document-damos-filters-of-sysfs.patch
docs-abi-damon-document-scheme-filters-files.patch
mm-page_reporting-replace-rcu_access_pointer-with-rcu_dereference_protected.patch
mm-switch-vma_merge-split_vma-and-__split_vma-to-vma-iterator-fix.patch
maintainers-add-types-to-akpm-mm-git-trees-entries.patch
maintainers-memory-management-add-tools-vm-as-managed-files.patch
tools-vm-rename-tools-vm-to-tools-mm.patch
selftests-vm-rename-selftets-vm-to-selftests-mm.patch
docs-admin-guide-mm-numaperf-increase-depth-of-subsections.patch
docs-admin-guide-mm-numaperf-increase-depth-of-subsections-fix.patch
mm-damon-vaddr-rename-damon_young_walk_private-page_sz-to-folio_sz.patch
mm-damon-vaddr-support-folio-of-neither-hpage_pmd_size-nor-page_size.patch
mm-damon-vaddr-record-appropriate-folio-size-when-the-access-is-not-found.patch
mm-damon-paddr-rename-damon_pa_access_chk_result-page_sz-to-folio_sz.patch
mm-damon-paddr-remove-folio_sz-field-from-damon_pa_access_chk_result.patch
mm-damon-paddr-remove-damon_pa_access_chk_result-struct.patch
scripts-spelling-add-a-few-more-typos.patch

