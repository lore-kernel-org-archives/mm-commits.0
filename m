Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73FB6C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:08:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiJCVIB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiJCVF4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:05:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 473A0A443
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:05:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D85D7611E2
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:05:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38EE1C433D6;
        Mon,  3 Oct 2022 21:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831131;
        bh=nzccwIRqh8E6xZv5AnPDkF5XBLPJku6d8VGB0DbmXcU=;
        h=Date:To:From:Subject:From;
        b=YwP3s96k4QjkH4ezJyt1r6ZDHj081jILYNdCETFm4H+01y10sUS1vc/PlRRgvox2g
         sDHjNmr1WoIvgSGmpVGeMeLzHo65nZ4N+J/9N4VdW/sz/V8lMafeaMsvCiYMKLHok1
         TF1X5CeoNewjqS9m4MvC0h7bKqQdXRNHmVHygEGM=
Date:   Mon, 03 Oct 2022 14:05:30 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-try_to_free_swap.patch removed from -mm tree
Message-Id: <20221003210531.38EE1C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove try_to_free_swap()
has been removed from the -mm tree.  Its filename was
     mm-remove-try_to_free_swap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove try_to_free_swap()
Date: Fri, 2 Sep 2022 20:46:44 +0100

All callers have now been converted to folio_free_swap() and we can remove
this wrapper.

Link: https://lkml.kernel.org/r/20220902194653.1739778-49-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    6 ------
 mm/folio-compat.c    |    7 -------
 mm/memory.c          |    2 +-
 3 files changed, 1 insertion(+), 14 deletions(-)

--- a/include/linux/swap.h~mm-remove-try_to_free_swap
+++ a/include/linux/swap.h
@@ -510,7 +510,6 @@ extern int __swp_swapcount(swp_entry_t e
 extern int swp_swapcount(swp_entry_t entry);
 extern struct swap_info_struct *page_swap_info(struct page *);
 extern struct swap_info_struct *swp_swap_info(swp_entry_t entry);
-extern int try_to_free_swap(struct page *);
 struct backing_dev_info;
 extern int init_swap_address_space(unsigned int type, unsigned long nr_pages);
 extern void exit_swap_address_space(unsigned int type);
@@ -594,11 +593,6 @@ static inline int swp_swapcount(swp_entr
 {
 	return 0;
 }
-
-static inline int try_to_free_swap(struct page *page)
-{
-	return 0;
-}
 
 static inline swp_entry_t folio_alloc_swap(struct folio *folio)
 {
--- a/mm/folio-compat.c~mm-remove-try_to_free_swap
+++ a/mm/folio-compat.c
@@ -146,10 +146,3 @@ void putback_lru_page(struct page *page)
 {
 	folio_putback_lru(page_folio(page));
 }
-
-#ifdef CONFIG_SWAP
-int try_to_free_swap(struct page *page)
-{
-	return folio_free_swap(page_folio(page));
-}
-#endif
--- a/mm/memory.c~mm-remove-try_to_free_swap
+++ a/mm/memory.c
@@ -3844,7 +3844,7 @@ vm_fault_t do_swap_page(struct vm_fault
 
 	if (swapcache) {
 		/*
-		 * Make sure try_to_free_swap or swapoff did not release the
+		 * Make sure folio_free_swap() or swapoff did not release the
 		 * swapcache from under us.  The page pin, and pte_same test
 		 * below, are not enough to exclude that.  Even if it is still
 		 * swapcache, we need to check that the page's swap has not
_

Patches currently in -mm which might be from willy@infradead.org are


