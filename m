Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56A9AC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 17 Feb 2022 02:57:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbiBQC5T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Feb 2022 21:57:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232010AbiBQC5T (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Feb 2022 21:57:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DDEB151D
        for <mm-commits@vger.kernel.org>; Wed, 16 Feb 2022 18:57:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A339761CF8
        for <mm-commits@vger.kernel.org>; Thu, 17 Feb 2022 02:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB1FC004E1;
        Thu, 17 Feb 2022 02:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645066624;
        bh=IWLbYbsf4+BNH7oRxMhr1g6stEL3j0fjlGqO2iaM4pc=;
        h=Date:To:From:Subject:From;
        b=S0lHMIUoOKVYwr22qjvhCH2zf3Fsc7Lyvu4k97/VDmBUeG7U60Xe94Tyz3kl+7Xjw
         CteEIOL5bH3YAR/0Rzzy9GTIPVwVOqpLxZ2ujc22WHjX/3uk3ftdzf2EIvtH4nMYd1
         EcXUogzsEpzX/8C4332/4Bf6KphYsXTOWwSJheaw=
Date:   Wed, 16 Feb 2022 18:57:03 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shy828301@gmail.com, kirill@shutemov.name, jhubbard@nvidia.com,
        hughd@google.com, david@redhat.com, apopple@nvidia.com,
        aarcange@redhat.com, peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-change-zap_detailszap_mapping-into-even_cows.patch added to -mm tree
Message-Id: <20220217025703.EFB1FC004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: change zap_details.zap_mapping into even_cows
has been added to the -mm tree.  Its filename is
     mm-change-zap_detailszap_mapping-into-even_cows.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-change-zap_detailszap_mapping-into-even_cows.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-change-zap_detailszap_mapping-into-even_cows.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm: change zap_details.zap_mapping into even_cows

Currently we have a zap_mapping pointer maintained in zap_details, when it
is specified we only want to zap the pages that has the same mapping with
what the caller has specified.

But what we want to do is actually simpler: we want to skip zapping
private (COW-ed) pages in some cases.  We can refer to
unmap_mapping_pages() callers where we could have passed in different
even_cows values.  The other user is unmap_mapping_folio() where we always
want to skip private pages.

According to Hugh, we used a mapping pointer for historical reason, as
explained here:

  https://lore.kernel.org/lkml/391aa58d-ce84-9d4-d68d-d98a9c533255@google.com/

Quoting partly from Hugh:

  Which raises the question again of why I did not just use a boolean flag
  there originally: aah, I think I've found why.  In those days there was a
  horrible "optimization", for better performance on some benchmark I guess,
  which when you read from /dev/zero into a private mapping, would map the zero
  page there (look up read_zero_pagealigned() and zeromap_page_range() if you
  dare).  So there was another category of page to be skipped along with the
  anon COWs, and I didn't want multiple tests in the zap loop, so checking
  check_mapping against page->mapping did both.  I think nowadays you could do
  it by checking for PageAnon page (or genuine swap entry) instead.

This patch replaced the zap_details.zap_mapping pointer into the even_cows
boolean, then we check it against PageAnon.

Link: https://lkml.kernel.org/r/20220216094810.60572-4-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Suggested-by: Hugh Dickins <hughd@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/mm/memory.c~mm-change-zap_detailszap_mapping-into-even_cows
+++ a/mm/memory.c
@@ -1309,8 +1309,8 @@ copy_page_range(struct vm_area_struct *d
  * Parameter block passed down to zap_pte_range in exceptional cases.
  */
 struct zap_details {
-	struct address_space *zap_mapping;	/* Check page->mapping if set */
 	struct folio *single_folio;	/* Locked folio to be unmapped */
+	bool even_cows;			/* Zap COWed private pages too? */
 };
 
 /* Whether we should zap all COWed (private) pages too */
@@ -1321,13 +1321,10 @@ static inline bool should_zap_cows(struc
 		return true;
 
 	/* Or, we zap COWed pages only if the caller wants to */
-	return !details->zap_mapping;
+	return details->even_cows;
 }
 
-/*
- * We set details->zap_mapping when we want to unmap shared but keep private
- * pages. Return true if we should zap this page, false otherwise.
- */
+/* Decides whether we should zap this page with the page pointer specified */
 static inline bool should_zap_page(struct zap_details *details, struct page *page)
 {
 	/* If we can make a decision without *page.. */
@@ -1338,7 +1335,8 @@ static inline bool should_zap_page(struc
 	if (!page)
 		return true;
 
-	return details->zap_mapping == page_rmapping(page);
+	/* Otherwise we should only zap non-anon pages */
+	return !PageAnon(page);
 }
 
 static unsigned long zap_pte_range(struct mmu_gather *tlb,
@@ -3419,7 +3417,7 @@ void unmap_mapping_folio(struct folio *f
 	first_index = folio->index;
 	last_index = folio->index + folio_nr_pages(folio) - 1;
 
-	details.zap_mapping = mapping;
+	details.even_cows = false;
 	details.single_folio = folio;
 
 	i_mmap_lock_write(mapping);
@@ -3448,7 +3446,7 @@ void unmap_mapping_pages(struct address_
 	pgoff_t	first_index = start;
 	pgoff_t	last_index = start + nr - 1;
 
-	details.zap_mapping = even_cows ? NULL : mapping;
+	details.even_cows = even_cows;
 	if (last_index < first_index)
 		last_index = ULONG_MAX;
 
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-fix-invalid-page-pointer-returned-with-foll_pin-gups.patch
mm-dont-skip-swap-entry-even-if-zap_details-specified.patch
mm-rename-zap_skip_check_mapping-to-should_zap_page.patch
mm-change-zap_detailszap_mapping-into-even_cows.patch
mm-rework-swap-handling-of-zap_pte_range.patch

