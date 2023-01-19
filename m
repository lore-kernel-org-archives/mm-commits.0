Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CABDC38159
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:22:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbjASBWF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:22:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbjASBUB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:20:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9BA6CCDE
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:16:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13F55B81FB9
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:16:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4500C433F1;
        Thu, 19 Jan 2023 01:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674091000;
        bh=62D2oQSTFFXx87Ztg5eMyDNrpLrMotffL0txLcyP6Yk=;
        h=Date:To:From:Subject:From;
        b=h1QptfYoW/2B2zCfz46Ihhs84zJLRM+Y5o+tr41v1Y1+1RUyDeHyznVZ3TiPOx/bb
         vDsFEJD5jmyIH1CU6WyuwRbRbKXxk8n0Q8bOQUWrrb3AcrZxAaJTvR/n2d82wg+SUF
         9fRNz/NBraocB94l1m4VpdzmmCOrVQaCZ3R3vHAs=
Date:   Wed, 18 Jan 2023 17:16:40 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-vaddr-rename-damon_young_walk_private-page_sz-to-folio_sz.patch removed from -mm tree
Message-Id: <20230119011640.A4500C433F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/vaddr: rename 'damon_young_walk_private->page_sz' to 'folio_sz'
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-rename-damon_young_walk_private-page_sz-to-folio_sz.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-damon-core-update-kernel-doc-comments-for-damos-action-supports-of-each-damon-operations-set.patch
mm-damon-core-update-kernel-doc-comments-for-damos-filters-supports-of-each-damon-operations-set.patch
docs-mm-damon-index-mention-damos-on-the-intro.patch
docs-admin-guide-mm-damon-usage-update-damos-actions-filters-supports-of-each-damon-operations-set.patch
docs-mm-damon-add-a-maintainer-profile-for-damon.patch
maintainers-damon-link-maintainer-profile-git-trees-and-website.patch
selftests-damon-sysfs-hide-expected-write-failures.patch
selftests-damon-debugfs_rm_non_contexts-hide-expected-write-error-messages.patch
scripts-spelling-add-a-few-more-typos.patch

