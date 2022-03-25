Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2280FC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357404AbiCYBd7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357399AbiCYBdA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 900E0BD8BE
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 276016192B
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82620C340EC;
        Fri, 25 Mar 2022 01:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171859;
        bh=dnTilWjP4dmsbAqVASdfWKA8zM91p+DnH7xYHCcJ5Zc=;
        h=Date:To:From:Subject:From;
        b=EtriY17uou5scYN0vQWhLTXxQpXoXF5KO7ER4J+MJ+N5A3ilXzqZrIuA/BbjtIah5
         ChRqjGY4bfwLdj8SsoXpRBNSsR/VhljnkrtjtEh+TdevKc3XeCXuJo9gwDgjT8Z45m
         sonL0PKx+EmbOHozgsuAMCqGtTeqUNUJVEfeO1d8=
Date:   Thu, 24 Mar 2022 18:30:58 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shy828301@gmail.com, kirill@shutemov.name, jhubbard@nvidia.com,
        hughd@google.com, david@redhat.com, apopple@nvidia.com,
        aarcange@redhat.com, peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-rename-zap_skip_check_mapping-to-should_zap_page.patch removed from -mm tree
Message-Id: <20220325013059.82620C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rename zap_skip_check_mapping() to should_zap_page()
has been removed from the -mm tree.  Its filename was
     mm-rename-zap_skip_check_mapping-to-should_zap_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from peterx@redhat.com are


