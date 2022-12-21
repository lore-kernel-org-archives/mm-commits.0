Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA14AC10F1B
	for <mm-commits@archiver.kernel.org>; Wed, 21 Dec 2022 21:20:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbiLUVUk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Dec 2022 16:20:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbiLUVUh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Dec 2022 16:20:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9D8201AA
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2022 13:20:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C6AC61956
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2022 21:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71321C433EF;
        Wed, 21 Dec 2022 21:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671657635;
        bh=X8h5wrpvaSrwxiNfbSPTHZ3isdo29uvHg4yxcV7uYGo=;
        h=Date:To:From:Subject:From;
        b=pVH/9nDoxABGVE1cYf9U/XnHPxxYrWPKWG/9LlgNYam7dKiXIbKz7cgnkjpyIQfpB
         CQDDaO04qbkzlUuRVjaIW1L1ZgDQlWrtPGqIpTMJxFfIbuxQETIswb3C0BeMwrqt0C
         vQi4tWcny9Vl0OMhxGXVRZwfMsJlPcyzi2o3NkIg=
Date:   Wed, 21 Dec 2022 13:20:34 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, sj@kernel.org,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-convert-damon_pa_mark_accessed_or_deactivate-to-use-folios.patch added to mm-unstable branch
Message-Id: <20221221212035.71321C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: convert damon_pa_mark_accessed_or_deactivate() to use folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-convert-damon_pa_mark_accessed_or_deactivate-to-use-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-convert-damon_pa_mark_accessed_or_deactivate-to-use-folios.patch

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
Subject: mm/damon: convert damon_pa_mark_accessed_or_deactivate() to use folios
Date: Wed, 21 Dec 2022 10:08:47 -0800

This change replaces 2 calls to compound_head() from put_page() and 1 call
from mark_page_accessed() with one from page_folio().  This is in
preparation for the conversion of deactivate_page() to folio_deactivate().

Link: https://lkml.kernel.org/r/20221221180848.20774-4-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-convert-damon_pa_mark_accessed_or_deactivate-to-use-folios
+++ a/mm/damon/paddr.c
@@ -283,21 +283,23 @@ static inline unsigned long damon_pa_mar
 
 	for (addr = r->ar.start; addr < r->ar.end; addr += PAGE_SIZE) {
 		struct page *page = damon_get_page(PHYS_PFN(addr));
+		struct folio *folio;
 
 		if (!page)
 			continue;
+		folio = page_folio(page);
 
-		if (damos_pa_filter_out(s, page)) {
-			put_page(page);
+		if (damos_pa_filter_out(s, &folio->page)) {
+			folio_put(folio);
 			continue;
 		}
 
 		if (mark_accessed)
-			mark_page_accessed(page);
+			folio_mark_accessed(folio);
 		else
-			deactivate_page(page);
-		put_page(page);
-		applied++;
+			deactivate_page(&folio->page);
+		folio_put(folio);
+		applied += folio_nr_pages(folio);
 	}
 	return applied * PAGE_SIZE;
 }
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-memory-add-vm_normal_folio.patch
madvise-convert-madvise_cold_or_pageout_pte_range-to-use-folios.patch
mm-damon-convert-damon_pa_mark_accessed_or_deactivate-to-use-folios.patch
mm-swap-convert-deactivate_page-to-folio_deactivate.patch

