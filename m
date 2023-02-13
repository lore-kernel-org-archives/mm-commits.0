Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAAE7C636CC
	for <mm-commits@archiver.kernel.org>; Mon, 13 Feb 2023 21:49:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbjBMVtE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Feb 2023 16:49:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbjBMVtC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2023 16:49:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06AAF17CDA
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 13:49:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9473B6130B
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 21:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD2CC433D2;
        Mon, 13 Feb 2023 21:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676324939;
        bh=Bq3ReEgFDKhYLKbmN+bSmMNH6CCANbK/6ASEjeviofw=;
        h=Date:To:From:Subject:From;
        b=HR7qulixhU9CFfs65XNxUZmKky1Tj4aK+uK/slBEdq2UAWTrN7F2KY54NySNJs9ji
         mEp17wYafYKy5l+OlY2CMWI5Bavjr+pEEdbzxiV/jwgx7SigpKPawqdYpO/QnulC7s
         6eu5+E/gC34NYX50T1a+lLCrvGkJrLsZegfmtk1U=
Date:   Mon, 13 Feb 2023 13:48:58 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        m.szyprowski@samsung.com, alex@ghiti.fr, vishal.moola@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-fix-invalid-page-access-in-release_pte_pages.patch added to mm-unstable branch
Message-Id: <20230213214858.EAD2CC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: fix invalid page access in release_pte_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-fix-invalid-page-access-in-release_pte_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-fix-invalid-page-access-in-release_pte_pages.patch

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
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/khugepaged: fix invalid page access in release_pte_pages()
Date: Mon, 13 Feb 2023 13:43:24 -0800

release_pte_pages() converts from a pfn to a folio by using pfn_folio(). 
If the pte is not mapped, pfn_folio() will result in undefined behavior
which ends up causing a kernel panic[1].

Only call pfn_folio() once we have validated that the pte is both valid
and mapped to fix the issue.

[1] https://lore.kernel.org/linux-mm/ff300770-afe9-908d-23ed-d23e0796e899@samsung.com/

Link: https://lkml.kernel.org/r/20230213214324.34215-1-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Fixes: 9bdfeea46f49 ("mm/khugepaged: convert release_pte_pages() to use folios")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Debugged-by: Alexandre Ghiti <alex@ghiti.fr>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/khugepaged.c~mm-khugepaged-fix-invalid-page-access-in-release_pte_pages
+++ a/mm/khugepaged.c
@@ -511,11 +511,17 @@ static void release_pte_pages(pte_t *pte
 
 	while (--_pte >= pte) {
 		pte_t pteval = *_pte;
+		unsigned long pfn;
 
-		folio = pfn_folio(pte_pfn(pteval));
-		if (!pte_none(pteval) && !is_zero_pfn(pte_pfn(pteval)) &&
-				!folio_test_large(folio))
-			release_pte_folio(folio);
+		if (pte_none(pteval))
+			continue;
+		pfn = pte_pfn(pteval);
+		if (is_zero_pfn(pfn))
+			continue;
+		folio = pfn_folio(pfn);
+		if (folio_test_large(folio))
+			continue;
+		release_pte_folio(folio);
 	}
 
 	list_for_each_entry_safe(folio, tmp, compound_pagelist, lru) {
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-khugepaged-fix-invalid-page-access-in-release_pte_pages.patch
mm-add-folio_estimated_sharers.patch
mm-mempolicy-convert-queue_pages_pmd-to-queue_folios_pmd.patch
mm-mempolicy-convert-queue_pages_pte_range-to-queue_folios_pte_range.patch
mm-mempolicy-convert-queue_pages_hugetlb-to-queue_folios_hugetlb.patch
mm-mempolicy-convert-queue_pages_required-to-queue_folio_required.patch
mm-mempolicy-convert-migrate_page_add-to-migrate_folio_add.patch
mm-add-folio_get_nontail_page.patch
mm-migrate-add-folio_movable_ops.patch
mm-migrate-convert-isolate_movable_page-to-use-folios.patch
mm-migrate-convert-putback_movable_pages-to-use-folios.patch

