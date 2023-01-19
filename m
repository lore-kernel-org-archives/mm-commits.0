Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8691C678D4
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbjASBWL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:22:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbjASBUC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:20:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA771814E
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:16:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16A3EB81D7E
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:16:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B791DC433EF;
        Thu, 19 Jan 2023 01:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674091004;
        bh=zf5KTI+5H/obm26vLfb/P2sJnW9G/cZAl7eIYrLS+H8=;
        h=Date:To:From:Subject:From;
        b=THC49NoIMqX4ClBumNDexB1emHtmbc3JtTJKGVLqwq5oNjlDueYzjT3tIjYNLR12R
         BHVViFVIsJvr6g+OnG5fij4uNBfFCsBaSZhhwrwcGl1EY+pVGjcpYdHx7XVXii4hk5
         JMf2DmnvnRJfIFMyZI32Jgh1PFg8QFS2zIyoSH3Q=
Date:   Wed, 18 Jan 2023 17:16:44 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-paddr-rename-damon_pa_access_chk_result-page_sz-to-folio_sz.patch removed from -mm tree
Message-Id: <20230119011644.B791DC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/paddr: rename 'damon_pa_access_chk_result->page_sz' to 'folio_sz'
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-rename-damon_pa_access_chk_result-page_sz-to-folio_sz.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/paddr: rename 'damon_pa_access_chk_result->page_sz' to 'folio_sz'
Date: Mon, 9 Jan 2023 21:33:33 +0000

DAMON's physical address space monitoring operations set is using folio
now.  Rename 'damon_pa_access_chk_result->page_sz' to reflect the fact.

Link: https://lkml.kernel.org/r/20230109213335.62525-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-rename-damon_pa_access_chk_result-page_sz-to-folio_sz
+++ a/mm/damon/paddr.c
@@ -80,7 +80,8 @@ static void damon_pa_prepare_access_chec
 }
 
 struct damon_pa_access_chk_result {
-	unsigned long page_sz;
+	/* size of the folio for the access checked physical memory address */
+	unsigned long folio_sz;
 	bool accessed;
 };
 
@@ -91,7 +92,7 @@ static bool __damon_pa_young(struct foli
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, addr, 0);
 
 	result->accessed = false;
-	result->page_sz = PAGE_SIZE;
+	result->folio_sz = PAGE_SIZE;
 	while (page_vma_mapped_walk(&pvmw)) {
 		addr = pvmw.address;
 		if (pvmw.pte) {
@@ -103,7 +104,7 @@ static bool __damon_pa_young(struct foli
 			result->accessed = pmd_young(*pvmw.pmd) ||
 				!folio_test_idle(folio) ||
 				mmu_notifier_test_young(vma->vm_mm, addr);
-			result->page_sz = HPAGE_PMD_SIZE;
+			result->folio_sz = HPAGE_PMD_SIZE;
 #else
 			WARN_ON_ONCE(1);
 #endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
@@ -118,11 +119,11 @@ static bool __damon_pa_young(struct foli
 	return !result->accessed;
 }
 
-static bool damon_pa_young(unsigned long paddr, unsigned long *page_sz)
+static bool damon_pa_young(unsigned long paddr, unsigned long *folio_sz)
 {
 	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
 	struct damon_pa_access_chk_result result = {
-		.page_sz = PAGE_SIZE,
+		.folio_sz = PAGE_SIZE,
 		.accessed = false,
 	};
 	struct rmap_walk_control rwc = {
@@ -157,25 +158,25 @@ static bool damon_pa_young(unsigned long
 	folio_put(folio);
 
 out:
-	*page_sz = result.page_sz;
+	*folio_sz = result.folio_sz;
 	return result.accessed;
 }
 
 static void __damon_pa_check_access(struct damon_region *r)
 {
 	static unsigned long last_addr;
-	static unsigned long last_page_sz = PAGE_SIZE;
+	static unsigned long last_folio_sz = PAGE_SIZE;
 	static bool last_accessed;
 
 	/* If the region is in the last checked page, reuse the result */
-	if (ALIGN_DOWN(last_addr, last_page_sz) ==
-				ALIGN_DOWN(r->sampling_addr, last_page_sz)) {
+	if (ALIGN_DOWN(last_addr, last_folio_sz) ==
+				ALIGN_DOWN(r->sampling_addr, last_folio_sz)) {
 		if (last_accessed)
 			r->nr_accesses++;
 		return;
 	}
 
-	last_accessed = damon_pa_young(r->sampling_addr, &last_page_sz);
+	last_accessed = damon_pa_young(r->sampling_addr, &last_folio_sz);
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

