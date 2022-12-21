Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEA4EC4332F
	for <mm-commits@archiver.kernel.org>; Wed, 21 Dec 2022 21:20:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiLUVUs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Dec 2022 16:20:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbiLUVUp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Dec 2022 16:20:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5120F24D
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2022 13:20:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7DA0B81C5A
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2022 21:20:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 738ABC433EF;
        Wed, 21 Dec 2022 21:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671657637;
        bh=6hGxcsawpwIfvtXHoR27EeQ1pSIGv9nyf/4A6kzgrXk=;
        h=Date:To:From:Subject:From;
        b=NvmaUYcKdIeb5GLeXzyEjHggTrK5rlIXiobW83ttStsLL/XaOqlfXMbhbAmBF78Om
         8W/RACsdmmHv++uKqScRZw9TeBnddElbOMVC11s8Qngqorf47LYDfWp75SBZz9P84m
         R34XtJETG8kE8XIq8zsG0VHXOW3JkQRhqtkmZPBQ=
Date:   Wed, 21 Dec 2022 13:20:36 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, sj@kernel.org,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-convert-deactivate_page-to-folio_deactivate.patch added to mm-unstable branch
Message-Id: <20221221212037.738ABC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: convert deactivate_page() to folio_deactivate()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-convert-deactivate_page-to-folio_deactivate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-convert-deactivate_page-to-folio_deactivate.patch

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
Subject: mm/swap: convert deactivate_page() to folio_deactivate()
Date: Wed, 21 Dec 2022 10:08:48 -0800

Deactivate_page() has already been converted to use folios, this change
converts it to take in a folio argument instead of calling page_folio(). 
It also renames the function folio_deactivate() to be more consistent with
other folio functions.

Link: https://lkml.kernel.org/r/20221221180848.20774-5-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 +-
 mm/damon/paddr.c     |    2 +-
 mm/madvise.c         |    4 ++--
 mm/swap.c            |   14 ++++++--------
 4 files changed, 10 insertions(+), 12 deletions(-)

--- a/include/linux/swap.h~mm-swap-convert-deactivate_page-to-folio_deactivate
+++ a/include/linux/swap.h
@@ -401,7 +401,7 @@ extern void lru_add_drain(void);
 extern void lru_add_drain_cpu(int cpu);
 extern void lru_add_drain_cpu_zone(struct zone *zone);
 extern void lru_add_drain_all(void);
-extern void deactivate_page(struct page *page);
+void folio_deactivate(struct folio *folio);
 void folio_mark_lazyfree(struct folio *folio);
 extern void swap_setup(void);
 
--- a/mm/damon/paddr.c~mm-swap-convert-deactivate_page-to-folio_deactivate
+++ a/mm/damon/paddr.c
@@ -297,7 +297,7 @@ static inline unsigned long damon_pa_mar
 		if (mark_accessed)
 			folio_mark_accessed(folio);
 		else
-			deactivate_page(&folio->page);
+			folio_deactivate(folio);
 		folio_put(folio);
 		applied += folio_nr_pages(folio);
 	}
--- a/mm/madvise.c~mm-swap-convert-deactivate_page-to-folio_deactivate
+++ a/mm/madvise.c
@@ -416,7 +416,7 @@ static int madvise_cold_or_pageout_pte_r
 					list_add(&folio->lru, &folio_list);
 			}
 		} else
-			deactivate_page(&folio->page);
+			folio_deactivate(folio);
 huge_unlock:
 		spin_unlock(ptl);
 		if (pageout)
@@ -510,7 +510,7 @@ regular_folio:
 					list_add(&folio->lru, &folio_list);
 			}
 		} else
-			deactivate_page(&folio->page);
+			folio_deactivate(folio);
 	}
 
 	arch_leave_lazy_mmu_mode();
--- a/mm/swap.c~mm-swap-convert-deactivate_page-to-folio_deactivate
+++ a/mm/swap.c
@@ -733,17 +733,15 @@ void deactivate_file_folio(struct folio
 }
 
 /*
- * deactivate_page - deactivate a page
- * @page: page to deactivate
+ * folio_deactivate - deactivate a folio
+ * @folio: folio to deactivate
  *
- * deactivate_page() moves @page to the inactive list if @page was on the active
- * list and was not an unevictable page.  This is done to accelerate the reclaim
- * of @page.
+ * folio_deactivate() moves @folio to the inactive list if @folio was on the
+ * active list and was not unevictable. This is done to accelerate the
+ * reclaim of @folio.
  */
-void deactivate_page(struct page *page)
+void folio_deactivate(struct folio *folio)
 {
-	struct folio *folio = page_folio(page);
-
 	if (folio_test_lru(folio) && !folio_test_unevictable(folio) &&
 	    (folio_test_active(folio) || lru_gen_enabled())) {
 		struct folio_batch *fbatch;
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-memory-add-vm_normal_folio.patch
madvise-convert-madvise_cold_or_pageout_pte_range-to-use-folios.patch
mm-damon-convert-damon_pa_mark_accessed_or_deactivate-to-use-folios.patch
mm-swap-convert-deactivate_page-to-folio_deactivate.patch

