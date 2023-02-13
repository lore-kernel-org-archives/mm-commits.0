Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51A13C636D4
	for <mm-commits@archiver.kernel.org>; Mon, 13 Feb 2023 23:55:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjBMXzM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Feb 2023 18:55:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBMXzL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2023 18:55:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067161B7
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 15:55:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8BE8B818FF
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 23:55:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D5BC433D2;
        Mon, 13 Feb 2023 23:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676332508;
        bh=59pNvKH6ir1+NOcEbBEbqZpHb/ooChO0rsTtRCwaUYg=;
        h=Date:To:From:Subject:From;
        b=Igtf5b2DkvvOuLleLs24LnGOCrIZGq35+R4+OtZTCJegaUVVsMu87/dQR5JnU5PE5
         2iH+P1QgG7tzyVWquwyr9s/Ymch2XYx9kqpVW5m87z/V4quzTsyoUPDYIhvPFxWXMD
         bp3g/ysyCpoKukb8MHBTuNGrc5RGJDxTdEdJEKz4=
Date:   Mon, 13 Feb 2023 15:55:07 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        m.szyprowski@samsung.com, alex@ghiti.fr, vishal.moola@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-fix-invalid-page-access-in-release_pte_pages.patch removed from -mm tree
Message-Id: <20230213235508.67D5BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: fix invalid page access in release_pte_pages()
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-fix-invalid-page-access-in-release_pte_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
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


