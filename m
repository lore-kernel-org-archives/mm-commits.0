Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DAB2C678D4
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbjASBWI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:22:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbjASBUB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:20:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D97616AE9
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:16:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B435C61B79
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:16:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C199C433D2;
        Thu, 19 Jan 2023 01:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674091006;
        bh=Kg8EjY13rv9AQCekJZPrXoGXEDDqR4+T2WH5HbnTxaw=;
        h=Date:To:From:Subject:From;
        b=g0so85xThHSN/gBmKDaIWgM7gE6PH5vm07yJ8aW/MFPOmy4plCaQEFvXmeAeGZD1O
         pkeERLOT4qVFHRf/KW7+Ha55p6qyvPP6dWg/9xCK2YuwK3XrhmXG/2W6NfNJbY2h/3
         HQWZ4mm7h3udeAshDfi/EQANrbduM89P/l3zeOdo=
Date:   Wed, 18 Jan 2023 17:16:45 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-paddr-remove-folio_sz-field-from-damon_pa_access_chk_result.patch removed from -mm tree
Message-Id: <20230119011646.1C199C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/paddr: remove folio_sz field from damon_pa_access_chk_result
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-remove-folio_sz-field-from-damon_pa_access_chk_result.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-damon-core-update-kernel-doc-comments-for-damos-action-supports-of-each-damon-operations-set.patch
mm-damon-core-update-kernel-doc-comments-for-damos-filters-supports-of-each-damon-operations-set.patch
docs-mm-damon-index-mention-damos-on-the-intro.patch
docs-admin-guide-mm-damon-usage-update-damos-actions-filters-supports-of-each-damon-operations-set.patch
docs-mm-damon-add-a-maintainer-profile-for-damon.patch
maintainers-damon-link-maintainer-profile-git-trees-and-website.patch
selftests-damon-sysfs-hide-expected-write-failures.patch
selftests-damon-debugfs_rm_non_contexts-hide-expected-write-error-messages.patch
scripts-spelling-add-a-few-more-typos.patch

