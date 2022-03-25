Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1232C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357399AbiCYBeB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357400AbiCYBdA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D45BD8BD
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44E886192B
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B061C340F1;
        Fri, 25 Mar 2022 01:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171860;
        bh=4HUxCBErQ1gribIKSh8/C+zR01ZcobfoI7zghExNVGw=;
        h=Date:To:From:Subject:From;
        b=IULWsPYdtekdRrGapugT460+VLGmig1qNL9ZJ8FHvCALQGAvsL1lc4MR9PIoxuGKE
         K0SjNKFHuT22eQM+/auGsV4VcnYLv7YbNmahBgAr1LLzq6E7uOCFz2kIoXfz32hnNw
         Noy8g1Emw4EpmE4mmreF+9H6SI/rsKztt7Jbx2LQ=
Date:   Thu, 24 Mar 2022 18:31:00 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shy828301@gmail.com, kirill@shutemov.name, jhubbard@nvidia.com,
        hughd@google.com, david@redhat.com, apopple@nvidia.com,
        aarcange@redhat.com, peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-change-zap_detailszap_mapping-into-even_cows.patch removed from -mm tree
Message-Id: <20220325013100.9B061C340F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: change zap_details.zap_mapping into even_cows
has been removed from the -mm tree.  Its filename was
     mm-change-zap_detailszap_mapping-into-even_cows.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

This patch replaces the zap_details.zap_mapping pointer into the even_cows
boolean, then we check it against PageAnon.

Link: https://lkml.kernel.org/r/20220216094810.60572-4-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Suggested-by: Hugh Dickins <hughd@google.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
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
@@ -3398,7 +3396,7 @@ void unmap_mapping_folio(struct folio *f
 	first_index = folio->index;
 	last_index = folio->index + folio_nr_pages(folio) - 1;
 
-	details.zap_mapping = mapping;
+	details.even_cows = false;
 	details.single_folio = folio;
 
 	i_mmap_lock_write(mapping);
@@ -3427,7 +3425,7 @@ void unmap_mapping_pages(struct address_
 	pgoff_t	first_index = start;
 	pgoff_t	last_index = start + nr - 1;
 
-	details.zap_mapping = even_cows ? NULL : mapping;
+	details.even_cows = even_cows;
 	if (last_index < first_index)
 		last_index = ULONG_MAX;
 
_

Patches currently in -mm which might be from peterx@redhat.com are


