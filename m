Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91546C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:42:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236118AbiCVVnw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236107AbiCVVnr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:43:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35335F258
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:42:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6696B6101E
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:42:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2AEC340EE;
        Tue, 22 Mar 2022 21:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985338;
        bh=WVtPcyz9kcIwZgZyI2+nTxY5HfwCQe0PeJBQjxrXGPU=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=JaxSM9itPcAF6XKUl12FYSRGmuPAawHyl6L6isRVmH9Y0h/KdwWt2MdOLPaD1fkv8
         HouhNcXHy6NjfSE5XB3ZmCwWfigg3WClLf5XTWC2ha4uviiHvxFo8FwFXtlEn/WvYX
         jEK+W6RNbZBcmYY+o3vtV0rOvwVT/lJ+LTAE5W98=
Date:   Tue, 22 Mar 2022 14:42:18 -0700
To:     willy@infradead.org, vbabka@suse.cz, shy828301@gmail.com,
        kirill@shutemov.name, jhubbard@nvidia.com, hughd@google.com,
        david@redhat.com, apopple@nvidia.com, aarcange@redhat.com,
        peterx@redhat.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 074/227] mm: rename zap_skip_check_mapping() to should_zap_page()
Message-Id: <20220322214218.BA2AEC340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Peter Xu <peterx@redhat.com>
Subject: mm: rename zap_skip_check_mapping() to should_zap_page()

The previous name is against the natural way people think.  Invert the
meaning and also the return value.  No functional change intended.

Link: https://lkml.kernel.org/r/20220216094810.60572-3-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Hugh Dickins <hughd@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
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
 
 	/* E.g. the caller passes NULL for the case of a zero page */
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
@@ -1429,7 +1428,7 @@ again:
 			struct page *page;
 
 			page = pfn_swap_entry_to_page(entry);
-			if (zap_skip_check_mapping(details, page))
+			if (!should_zap_page(details, page))
 				continue;
 			rss[mm_counter(page)]--;
 		} else if (is_hwpoison_entry(entry)) {
_
