Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93A04C46467
	for <mm-commits@archiver.kernel.org>; Sat, 14 Jan 2023 03:45:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbjANDp0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Jan 2023 22:45:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbjANDpY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2023 22:45:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AADE8E9BA
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2023 19:45:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF9806239C
        for <mm-commits@vger.kernel.org>; Sat, 14 Jan 2023 03:45:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2046C433D2;
        Sat, 14 Jan 2023 03:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673667922;
        bh=fhZR14tWQyRpfMk3ZLk6CYiZfJ8tgsfjKp/nuRHyWkw=;
        h=Date:To:From:Subject:From;
        b=LlCAHNsTiyurYi8W6pVNrb4UqEU9Vh7D4LrhEfUrAHsXCZaWq2xiZm8PbjtayT1/c
         hTO5uCgBmb9ap1bCSJGtNqoYoSfhHWI+vuITycq0BaEgn6rdjbail6Yc5LSZqHzEtD
         GvTkG+pWkbyARFHZaqnb3Rx1Rix1VhuNb0lU72Rk=
Date:   Fri, 13 Jan 2023 19:45:21 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mike.kravetz@oracle.com, vishal.moola@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-convert-release_pte_pages-to-use-folios.patch added to mm-unstable branch
Message-Id: <20230114034521.F2046C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: convert release_pte_pages() to use folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-convert-release_pte_pages-to-use-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-convert-release_pte_pages-to-use-folios.patch

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
Subject: mm/khugepaged: convert release_pte_pages() to use folios
Date: Fri, 13 Jan 2023 16:15:56 -0800

Converts release_pte_pages() to use folios instead of pages.

Link: https://lkml.kernel.org/r/20230114001556.43795-2-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/khugepaged.c~mm-khugepaged-convert-release_pte_pages-to-use-folios
+++ a/mm/khugepaged.c
@@ -509,20 +509,20 @@ static void release_pte_page(struct page
 static void release_pte_pages(pte_t *pte, pte_t *_pte,
 		struct list_head *compound_pagelist)
 {
-	struct page *page, *tmp;
+	struct folio *folio, *tmp;
 
 	while (--_pte >= pte) {
 		pte_t pteval = *_pte;
 
-		page = pte_page(pteval);
+		folio = pfn_folio(pte_pfn(pteval));
 		if (!pte_none(pteval) && !is_zero_pfn(pte_pfn(pteval)) &&
-				!PageCompound(page))
-			release_pte_page(page);
+				!folio_test_large(folio))
+			release_pte_folio(folio);
 	}
 
-	list_for_each_entry_safe(page, tmp, compound_pagelist, lru) {
-		list_del(&page->lru);
-		release_pte_page(page);
+	list_for_each_entry_safe(folio, tmp, compound_pagelist, lru) {
+		list_del(&folio->lru);
+		release_pte_folio(folio);
 	}
 }
 
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-memory-add-vm_normal_folio.patch
madvise-convert-madvise_cold_or_pageout_pte_range-to-use-folios.patch
mm-damon-convert-damon_pa_mark_accessed_or_deactivate-to-use-folios.patch
mm-swap-convert-deactivate_page-to-folio_deactivate.patch
ext4-convert-mext_page_double_lock-to-mext_folio_double_lock.patch
mm-khugepaged-introduce-release_pte_folio-to-replace-release_pte_page.patch
mm-khugepaged-convert-release_pte_pages-to-use-folios.patch

