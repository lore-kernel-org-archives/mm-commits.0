Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C84CC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236152AbiCVVoF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236131AbiCVVnz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:43:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 814DC5F4C2
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:42:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38C6DB81DB1
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:42:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E25CFC340F4;
        Tue, 22 Mar 2022 21:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985345;
        bh=F1QTr47N+B/kQaHUt9g/8MjSLEV7cYIWjwYDApu4qdY=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=uGkVjBGn6A8ANywWERVebEM+nEUBUQYcVeFJIPxtKErCAk6iUGco5Oa7FmvQnsFOv
         27kysIx2MNMgiem1f8mQnbnj8DG5sE5pRoS+xH2d6/2CtIOcvh10x0Y1OkwLVdEP+V
         RPIi5Zd5xRmUYyWpWxszjzpX3kMn3mPEFXQWq8Qg=
Date:   Tue, 22 Mar 2022 14:42:24 -0700
To:     willy@infradead.org, vbabka@suse.cz, shy828301@gmail.com,
        kirill@shutemov.name, jhubbard@nvidia.com, hughd@google.com,
        david@redhat.com, apopple@nvidia.com, aarcange@redhat.com,
        peterx@redhat.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 076/227] mm: rework swap handling of zap_pte_range
Message-Id: <20220322214224.E25CFC340F4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
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
@@ -1403,28 +1403,21 @@ again:
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
 			/* Genuine swap entry, hence a private anon page */
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
@@ -1436,8 +1429,6 @@ again:
 			/* We should have covered all the swap entry types */
 			WARN_ON_ONCE(1);
 		}
-		if (unlikely(!free_swap_and_cache(entry)))
-			print_bad_pte(vma, addr, ptent, NULL);
 		pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 
_
