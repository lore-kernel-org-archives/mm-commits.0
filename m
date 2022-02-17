Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2936C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 17 Feb 2022 02:57:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbiBQC5T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Feb 2022 21:57:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbiBQC5S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Feb 2022 21:57:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C33B12F3
        for <mm-commits@vger.kernel.org>; Wed, 16 Feb 2022 18:57:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6AEB0B820DC
        for <mm-commits@vger.kernel.org>; Thu, 17 Feb 2022 02:57:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F32C004E1;
        Thu, 17 Feb 2022 02:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645066622;
        bh=hz3PY5HaU7NPslQYdgCO3i51INhIpY0GHu5ePgIkRcA=;
        h=Date:To:From:Subject:From;
        b=B0gz7EcYC/Tcjw7K2TMpeMSMKiy0Gl5eoUbUh7a9n9rK+YeZhBdr9E/g7+Y6qkLl3
         i1aQ4okGhS9xlVs7Ph1PrX/2c9APpNOeRfwU+MoJQVnrPEGFrE4HORGT9q79jsEJIt
         A6/GWbdfA0WSbaTXuiCxkldbu+9brSTPFP9qJb2A=
Date:   Wed, 16 Feb 2022 18:57:01 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shy828301@gmail.com, kirill@shutemov.name, jhubbard@nvidia.com,
        hughd@google.com, david@redhat.com, apopple@nvidia.com,
        aarcange@redhat.com, peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rename-zap_skip_check_mapping-to-should_zap_page.patch added to -mm tree
Message-Id: <20220217025701.E3F32C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rename zap_skip_check_mapping() to should_zap_page()
has been added to the -mm tree.  Its filename is
     mm-rename-zap_skip_check_mapping-to-should_zap_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-rename-zap_skip_check_mapping-to-should_zap_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-rename-zap_skip_check_mapping-to-should_zap_page.patch

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
Subject: mm: rename zap_skip_check_mapping() to should_zap_page()

The previous name is against the natural way people think.  Invert the
meaning and also the return value.  No functional change intended.

Link: https://lkml.kernel.org/r/20220216094810.60572-3-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Hugh Dickins <hughd@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/mm/memory.c~mm-rename-zap_skip_check_mapping-to-should_zap_page
+++ a/mm/memory.c
@@ -1326,20 +1326,19 @@ static inline bool should_zap_cows(struc
 
 /*
  * We set details->zap_mapping when we want to unmap shared but keep private
- * pages. Return true if skip zapping this page, false otherwise.
+ * pages. Return true if we should zap this page, false otherwise.
  */
-static inline bool
-zap_skip_check_mapping(struct zap_details *details, struct page *page)
+static inline bool should_zap_page(struct zap_details *details, struct page *page)
 {
 	/* If we can make a decision without *page.. */
 	if (should_zap_cows(details))
-		return false;
+		return true;
 
 	/* E.g. zero page */
 	if (!page)
-		return false;
+		return true;
 
-	return details->zap_mapping != page_rmapping(page);
+	return details->zap_mapping == page_rmapping(page);
 }
 
 static unsigned long zap_pte_range(struct mmu_gather *tlb,
@@ -1374,7 +1373,7 @@ again:
 			struct page *page;
 
 			page = vm_normal_page(vma, addr, ptent);
-			if (unlikely(zap_skip_check_mapping(details, page)))
+			if (unlikely(!should_zap_page(details, page)))
 				continue;
 			ptent = ptep_get_and_clear_full(mm, addr, pte,
 							tlb->fullmm);
@@ -1408,7 +1407,7 @@ again:
 		    is_device_exclusive_entry(entry)) {
 			struct page *page = pfn_swap_entry_to_page(entry);
 
-			if (unlikely(zap_skip_check_mapping(details, page)))
+			if (unlikely(!should_zap_page(details, page)))
 				continue;
 			pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
 			rss[mm_counter(page)]--;
@@ -1433,7 +1432,7 @@ again:
 			struct page *page;
 
 			page = pfn_swap_entry_to_page(entry);
-			if (zap_skip_check_mapping(details, page))
+			if (!should_zap_page(details, page))
 				continue;
 			rss[mm_counter(page)]--;
 		} else if (is_hwpoison_entry(entry)) {
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-fix-invalid-page-pointer-returned-with-foll_pin-gups.patch
mm-dont-skip-swap-entry-even-if-zap_details-specified.patch
mm-rename-zap_skip_check_mapping-to-should_zap_page.patch
mm-change-zap_detailszap_mapping-into-even_cows.patch
mm-rework-swap-handling-of-zap_pte_range.patch

