Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 234CFC3DA66
	for <mm-commits@archiver.kernel.org>; Wed, 23 Aug 2023 21:01:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236604AbjHWVAv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Aug 2023 17:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236906AbjHWVAd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Aug 2023 17:00:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 414F210DA
        for <mm-commits@vger.kernel.org>; Wed, 23 Aug 2023 14:00:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2D06618C1
        for <mm-commits@vger.kernel.org>; Wed, 23 Aug 2023 21:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD43CC433C9;
        Wed, 23 Aug 2023 21:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692824429;
        bh=bnQ0iUxDT8C5NJh6D7Y4Uy4lPsvL/Iq6k5CZ/9D0VWw=;
        h=Date:To:From:Subject:From;
        b=y3sd4OgwQ89YvKTyb+15jLhDastQ2XdAO77O6/PhOqS8rGKVZMZBW8Voj8jskJz8Y
         /GnZavkOyDAmg/Gdp5s1BGrvoblblTiDYbu3/no4GqzULCJdJ2unlIntxgIOc7MUPg
         pPQnrL0yj+Jj29UPRnwSqWuVt5CufsMvAPZtQm28=
Date:   Wed, 23 Aug 2023 14:00:28 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, axboe@kernel.dk,
        mike.kravetz@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-clear-flags-in-tail-pages-that-will-be-freed-individually.patch added to mm-stable branch
Message-Id: <20230823210029.CD43CC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: clear flags in tail pages that will be freed individually
has been added to the -mm mm-stable branch.  Its filename is
     hugetlb-clear-flags-in-tail-pages-that-will-be-freed-individually.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-clear-flags-in-tail-pages-that-will-be-freed-individually.patch

This patch will later appear in the mm-stable branch at
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
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: clear flags in tail pages that will be freed individually
Date: Tue, 22 Aug 2023 15:30:43 -0700

Link: https://lkml.kernel.org/r/20230822231741.GC4509@monkey
Fixes: ebc1baf5c9b4 ("mm: free up a word in the first tail page")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/mm/hugetlb.c~hugetlb-clear-flags-in-tail-pages-that-will-be-freed-individually
+++ a/mm/hugetlb.c
@@ -1484,6 +1484,7 @@ static void __destroy_compound_gigantic_
 
 	for (i = 1; i < nr_pages; i++) {
 		p = folio_page(folio, i);
+		p->flags &= ~PAGE_FLAGS_CHECK_AT_FREE;
 		p->mapping = NULL;
 		clear_compound_head(p);
 		if (!demote)
@@ -1702,8 +1703,6 @@ static void add_hugetlb_folio(struct hst
 static void __update_and_free_hugetlb_folio(struct hstate *h,
 						struct folio *folio)
 {
-	int i;
-	struct page *subpage;
 	bool clear_dtor = folio_test_hugetlb_vmemmap_optimized(folio);
 
 	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
@@ -1745,14 +1744,6 @@ static void __update_and_free_hugetlb_fo
 		spin_unlock_irq(&hugetlb_lock);
 	}
 
-	for (i = 0; i < pages_per_huge_page(h); i++) {
-		subpage = folio_page(folio, i);
-		subpage->flags &= ~(1 << PG_locked | 1 << PG_error |
-				1 << PG_referenced | 1 << PG_dirty |
-				1 << PG_active | 1 << PG_private |
-				1 << PG_writeback);
-	}
-
 	/*
 	 * Non-gigantic pages demoted from CMA allocated gigantic pages
 	 * need to be given back to CMA in free_gigantic_folio.
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-clear-flags-in-tail-pages-that-will-be-freed-individually.patch

