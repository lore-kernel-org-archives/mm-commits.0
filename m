Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77080C678DD
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:22:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbjASBWJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:22:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbjASBUC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:20:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7512E2C647
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:16:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10AAA61B0B
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:16:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68DB8C433F0;
        Thu, 19 Jan 2023 01:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674091007;
        bh=cKX7qggz9aOgCgJDJfw62ZxjXizggUbCslTzY7PvMhk=;
        h=Date:To:From:Subject:From;
        b=XMAGD3x3Pg4Fmw0kwJdxVKJOnVgntIAk41Q2Sv+l6A3lL46lqEhcttxYDi1l+Q0XQ
         r5V0LF6okbLY/3NgD0gKhddpv/MTp7czwG+1MYvMSIgYhzO17KFyEoGoWBH3WiazRc
         UDbdf46H0SI9UwkCQKkVKMW7cW9/kc8rvKoyMv/w=
Date:   Wed, 18 Jan 2023 17:16:46 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-paddr-remove-damon_pa_access_chk_result-struct.patch removed from -mm tree
Message-Id: <20230119011647.68DB8C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/paddr: remove damon_pa_access_chk_result struct
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-remove-damon_pa_access_chk_result-struct.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/paddr: remove damon_pa_access_chk_result struct
Date: Mon, 9 Jan 2023 21:33:35 +0000

'damon_pa_access_chk_result' struct contains only one field.  Use a
variable instead.

Link: https://lkml.kernel.org/r/20230109213335.62525-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |   28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-remove-damon_pa_access_chk_result-struct
+++ a/mm/damon/paddr.c
@@ -79,50 +79,44 @@ static void damon_pa_prepare_access_chec
 	}
 }
 
-struct damon_pa_access_chk_result {
-	bool accessed;
-};
-
 static bool __damon_pa_young(struct folio *folio, struct vm_area_struct *vma,
 		unsigned long addr, void *arg)
 {
-	struct damon_pa_access_chk_result *result = arg;
+	bool *accessed = arg;
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, addr, 0);
 
-	result->accessed = false;
+	*accessed = false;
 	while (page_vma_mapped_walk(&pvmw)) {
 		addr = pvmw.address;
 		if (pvmw.pte) {
-			result->accessed = pte_young(*pvmw.pte) ||
+			*accessed = pte_young(*pvmw.pte) ||
 				!folio_test_idle(folio) ||
 				mmu_notifier_test_young(vma->vm_mm, addr);
 		} else {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-			result->accessed = pmd_young(*pvmw.pmd) ||
+			*accessed = pmd_young(*pvmw.pmd) ||
 				!folio_test_idle(folio) ||
 				mmu_notifier_test_young(vma->vm_mm, addr);
 #else
 			WARN_ON_ONCE(1);
 #endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
 		}
-		if (result->accessed) {
+		if (*accessed) {
 			page_vma_mapped_walk_done(&pvmw);
 			break;
 		}
 	}
 
 	/* If accessed, stop walking */
-	return !result->accessed;
+	return *accessed == false;
 }
 
 static bool damon_pa_young(unsigned long paddr, unsigned long *folio_sz)
 {
 	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
-	struct damon_pa_access_chk_result result = {
-		.accessed = false,
-	};
+	bool accessed = false;
 	struct rmap_walk_control rwc = {
-		.arg = &result,
+		.arg = &accessed,
 		.rmap_one = __damon_pa_young,
 		.anon_lock = folio_lock_anon_vma_read,
 	};
@@ -133,9 +127,9 @@ static bool damon_pa_young(unsigned long
 
 	if (!folio_mapped(folio) || !folio_raw_mapping(folio)) {
 		if (folio_test_idle(folio))
-			result.accessed = false;
+			accessed = false;
 		else
-			result.accessed = true;
+			accessed = true;
 		folio_put(folio);
 		goto out;
 	}
@@ -154,7 +148,7 @@ static bool damon_pa_young(unsigned long
 
 out:
 	*folio_sz = folio_size(folio);
-	return result.accessed;
+	return accessed;
 }
 
 static void __damon_pa_check_access(struct damon_region *r)
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

