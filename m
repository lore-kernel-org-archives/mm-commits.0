Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B756C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 17 Feb 2022 02:57:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbiBQC5U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Feb 2022 21:57:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbiBQC5U (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Feb 2022 21:57:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CCFEB12F3
        for <mm-commits@vger.kernel.org>; Wed, 16 Feb 2022 18:57:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95B1B61CD4
        for <mm-commits@vger.kernel.org>; Thu, 17 Feb 2022 02:57:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9FB7C004E1;
        Thu, 17 Feb 2022 02:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645066626;
        bh=vzyZ/HuU+AE8Vv6uNXIO38vUczmJ4P8eOiTmn8LwurE=;
        h=Date:To:From:Subject:From;
        b=0c5QFxc6LxYfiPz22V9XcpLfDivFgNvhwvZc62U/xFzN2N+s4pwUN34+lSjvfhsir
         CApMh/ZmG+D5DQsOJZ1X6LZohybhGaZkciEgbrRpvjqg0+Zil3UbKDy1FXGZqlUg0u
         7I7Y0DljeTkHIOvgbYOkLkLojKCtbiXClrD2zKHo=
Date:   Wed, 16 Feb 2022 18:57:05 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shy828301@gmail.com, kirill@shutemov.name, jhubbard@nvidia.com,
        hughd@google.com, david@redhat.com, apopple@nvidia.com,
        aarcange@redhat.com, peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rework-swap-handling-of-zap_pte_range.patch added to -mm tree
Message-Id: <20220217025705.E9FB7C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rework swap handling of zap_pte_range
has been added to the -mm tree.  Its filename is
     mm-rework-swap-handling-of-zap_pte_range.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-rework-swap-handling-of-zap_pte_range.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-rework-swap-handling-of-zap_pte_range.patch

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
Subject: mm: rework swap handling of zap_pte_range

Clean the code up by merging the device private/exclusive swap entry
handling with the rest, then we merge the pte clear operation too.

struct* page is defined in multiple places in the function, move it upward.

free_swap_and_cache() is only useful for !non_swap_entry() case, put it
into the condition.

No functional change intended.

Link: https://lkml.kernel.org/r/20220216094810.60572-5-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

--- a/mm/memory.c~mm-rework-swap-handling-of-zap_pte_range
+++ a/mm/memory.c
@@ -1361,6 +1361,8 @@ again:
 	arch_enter_lazy_mmu_mode();
 	do {
 		pte_t ptent = *pte;
+		struct page *page;
+
 		if (pte_none(ptent))
 			continue;
 
@@ -1368,8 +1370,6 @@ again:
 			break;
 
 		if (pte_present(ptent)) {
-			struct page *page;
-
 			page = vm_normal_page(vma, addr, ptent);
 			if (unlikely(!should_zap_page(details, page)))
 				continue;
@@ -1403,21 +1403,14 @@ again:
 		entry = pte_to_swp_entry(ptent);
 		if (is_device_private_entry(entry) ||
 		    is_device_exclusive_entry(entry)) {
-			struct page *page = pfn_swap_entry_to_page(entry);
-
+			page = pfn_swap_entry_to_page(entry);
 			if (unlikely(!should_zap_page(details, page)))
 				continue;
-			pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
 			rss[mm_counter(page)]--;
-
 			if (is_device_private_entry(entry))
 				page_remove_rmap(page, false);
-
 			put_page(page);
-			continue;
-		}
-
-		if (!non_swap_entry(entry)) {
+		} else if (!non_swap_entry(entry)) {
 			/*
 			 * If this is a genuine swap entry, then it must be an
 			 * private anon page.  If the caller wants to skip
@@ -1426,9 +1419,9 @@ again:
 			if (!should_zap_cows(details))
 				continue;
 			rss[MM_SWAPENTS]--;
+			if (unlikely(!free_swap_and_cache(entry)))
+				print_bad_pte(vma, addr, ptent, NULL);
 		} else if (is_migration_entry(entry)) {
-			struct page *page;
-
 			page = pfn_swap_entry_to_page(entry);
 			if (!should_zap_page(details, page))
 				continue;
@@ -1441,8 +1434,6 @@ again:
 			/* We should have covered all the swap entry types */
 			WARN_ON_ONCE(1);
 		}
-		if (unlikely(!free_swap_and_cache(entry)))
-			print_bad_pte(vma, addr, ptent, NULL);
 		pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-fix-invalid-page-pointer-returned-with-foll_pin-gups.patch
mm-dont-skip-swap-entry-even-if-zap_details-specified.patch
mm-rename-zap_skip_check_mapping-to-should_zap_page.patch
mm-change-zap_detailszap_mapping-into-even_cows.patch
mm-rework-swap-handling-of-zap_pte_range.patch

