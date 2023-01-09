Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E80CC54EBE
	for <mm-commits@archiver.kernel.org>; Mon,  9 Jan 2023 22:16:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237372AbjAIWQd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Jan 2023 17:16:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237838AbjAIWNd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2023 17:13:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51C74BB7
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 14:13:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF0726140F
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 22:13:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD74C433D2;
        Mon,  9 Jan 2023 22:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673302411;
        bh=owwW988049Z2zR2yOGIEnklZ7cmFT00BzxoqYVW04jA=;
        h=Date:To:From:Subject:From;
        b=HrtgBse33vjqRTZGvZ5RoBUx3VtuiU6cXtw9BrkTQTSDgr/AaVf30SHORjffXFotU
         p01YwdlX6/uhsxUVohjRfbWmrslI/zal4BBwM6MEQVdN2NYR3lKT22SR+Zg/mheCEs
         PobUAtH9VUvfnPIvR3Nd258sMMn2kKGpLpO4Nugo=
Date:   Mon, 09 Jan 2023 14:13:30 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-vaddr-rename-damon_young_walk_private-page_sz-to-folio_sz.patch added to mm-unstable branch
Message-Id: <20230109221331.1FD74C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/vaddr: rename 'damon_young_walk_private->page_sz' to 'folio_sz'
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-vaddr-rename-damon_young_walk_private-page_sz-to-folio_sz.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-vaddr-rename-damon_young_walk_private-page_sz-to-folio_sz.patch

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
Subject: mm/damon/vaddr: rename 'damon_young_walk_private->page_sz' to 'folio_sz'
Date: Mon, 9 Jan 2023 21:33:30 +0000

Patch series "mm/damon/{v,p}addr: misc fixups for folio usage".

DAMON's monitoring operations set for the virtual and the physical address
spaces use folio now, but some code is not reflecting the fact.  Further
cleanup the code for folio usage.


This patch (of 6):

DAMON's virtual address space monitoring operations set is using folio
now.  Rename 'damon_pa_access_chk_result->page_sz' to reflect the fact.

Link: https://lkml.kernel.org/r/20230109213335.62525-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20230109213335.62525-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-rename-damon_young_walk_private-page_sz-to-folio_sz
+++ a/mm/damon/vaddr.c
@@ -422,7 +422,8 @@ static void damon_va_prepare_access_chec
 }
 
 struct damon_young_walk_private {
-	unsigned long *page_sz;
+	/* size of the folio for the access checked virtual memory address */
+	unsigned long *folio_sz;
 	bool young;
 };
 
@@ -452,7 +453,7 @@ static int damon_young_pmd_entry(pmd_t *
 		if (pmd_young(*pmd) || !folio_test_idle(folio) ||
 					mmu_notifier_test_young(walk->mm,
 						addr)) {
-			*priv->page_sz = HPAGE_PMD_SIZE;
+			*priv->folio_sz = HPAGE_PMD_SIZE;
 			priv->young = true;
 		}
 		folio_put(folio);
@@ -474,7 +475,7 @@ regular_page:
 		goto out;
 	if (pte_young(*pte) || !folio_test_idle(folio) ||
 			mmu_notifier_test_young(walk->mm, addr)) {
-		*priv->page_sz = PAGE_SIZE;
+		*priv->folio_sz = PAGE_SIZE;
 		priv->young = true;
 	}
 	folio_put(folio);
@@ -504,7 +505,7 @@ static int damon_young_hugetlb_entry(pte
 
 	if (pte_young(entry) || !folio_test_idle(folio) ||
 	    mmu_notifier_test_young(walk->mm, addr)) {
-		*priv->page_sz = huge_page_size(h);
+		*priv->folio_sz = huge_page_size(h);
 		priv->young = true;
 	}
 
@@ -524,10 +525,10 @@ static const struct mm_walk_ops damon_yo
 };
 
 static bool damon_va_young(struct mm_struct *mm, unsigned long addr,
-		unsigned long *page_sz)
+		unsigned long *folio_sz)
 {
 	struct damon_young_walk_private arg = {
-		.page_sz = page_sz,
+		.folio_sz = folio_sz,
 		.young = false,
 	};
 
@@ -547,18 +548,18 @@ static void __damon_va_check_access(stru
 				struct damon_region *r, bool same_target)
 {
 	static unsigned long last_addr;
-	static unsigned long last_page_sz = PAGE_SIZE;
+	static unsigned long last_folio_sz = PAGE_SIZE;
 	static bool last_accessed;
 
 	/* If the region is in the last checked page, reuse the result */
-	if (same_target && (ALIGN_DOWN(last_addr, last_page_sz) ==
-				ALIGN_DOWN(r->sampling_addr, last_page_sz))) {
+	if (same_target && (ALIGN_DOWN(last_addr, last_folio_sz) ==
+				ALIGN_DOWN(r->sampling_addr, last_folio_sz))) {
 		if (last_accessed)
 			r->nr_accesses++;
 		return;
 	}
 
-	last_accessed = damon_va_young(mm, r->sampling_addr, &last_page_sz);
+	last_accessed = damon_va_young(mm, r->sampling_addr, &last_folio_sz);
 	if (last_accessed)
 		r->nr_accesses++;
 
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

