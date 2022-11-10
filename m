Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AAC7C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 10 Nov 2022 00:09:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbiKJAJa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Nov 2022 19:09:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231611AbiKJAJX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2022 19:09:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85AACA1A4
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 16:09:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 373F6B81F46
        for <mm-commits@vger.kernel.org>; Thu, 10 Nov 2022 00:09:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF88BC433D6;
        Thu, 10 Nov 2022 00:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668038959;
        bh=ulMcZVCcWeibZtr6fmiWIa5QHCvwQbIc+ImCaOioJOc=;
        h=Date:To:From:Subject:From;
        b=nV0W80FsEhuM2xb3OYaurNq8rvRA7KwIvN2T25eopEknhQMOTMoFpv5FdhMCcG0ip
         D7UBVTWjp/g8qO/yIJ8fbW7Eot2UhPqXGwtSWVY/1WD0Ky2ePXbe7F0iMkK51LZEsE
         aKhFrMPslktgmqhRVnUNgoq/JwkqJW9f+Rh459aw=
Date:   Wed, 09 Nov 2022 16:09:19 -0800
To:     mm-commits@vger.kernel.org, hughd@google.com, hannes@cmpxchg.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmu_gather-prepare-to-gather-encoded-page-pointers-with-flags.patch added to mm-unstable branch
Message-Id: <20221110000919.CF88BC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mmu_gather: prepare to gather encoded page pointers with flags
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmu_gather-prepare-to-gather-encoded-page-pointers-with-flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmu_gather-prepare-to-gather-encoded-page-pointers-with-flags.patch

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
From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: mm: mmu_gather: prepare to gather encoded page pointers with flags
Date: Wed, 9 Nov 2022 12:30:50 -0800

This is purely a preparatory patch that makes all the data structures
ready for encoding flags with the mmu_gather page pointers.

The code currently always sets the flag to zero and doesn't use it yet,
but now it's tracking the type state along.  The next step will be to
actually start using it.

Link: https://lkml.kernel.org/r/20221109203051.1835763-3-torvalds@linux-foundation.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/tlb.h |    8 +++++---
 include/asm-generic/tlb.h   |    9 +++++----
 include/linux/swap.h        |    2 +-
 mm/mmu_gather.c             |    8 ++++----
 mm/swap_state.c             |   11 ++++-------
 5 files changed, 19 insertions(+), 19 deletions(-)

--- a/arch/s390/include/asm/tlb.h~mm-mmu_gather-prepare-to-gather-encoded-page-pointers-with-flags
+++ a/arch/s390/include/asm/tlb.h
@@ -25,7 +25,8 @@
 void __tlb_remove_table(void *_table);
 static inline void tlb_flush(struct mmu_gather *tlb);
 static inline bool __tlb_remove_page_size(struct mmu_gather *tlb,
-					  struct page *page, int page_size);
+					  struct encoded_page *page,
+					  int page_size);
 
 #define tlb_flush tlb_flush
 #define pte_free_tlb pte_free_tlb
@@ -42,9 +43,10 @@ static inline bool __tlb_remove_page_siz
  * has already been freed, so just do free_page_and_swap_cache.
  */
 static inline bool __tlb_remove_page_size(struct mmu_gather *tlb,
-					  struct page *page, int page_size)
+					  struct encoded_page *page,
+					  int page_size)
 {
-	free_page_and_swap_cache(page);
+	free_page_and_swap_cache(encoded_page_ptr(page));
 	return false;
 }
 
--- a/include/asm-generic/tlb.h~mm-mmu_gather-prepare-to-gather-encoded-page-pointers-with-flags
+++ a/include/asm-generic/tlb.h
@@ -242,7 +242,7 @@ struct mmu_gather_batch {
 	struct mmu_gather_batch	*next;
 	unsigned int		nr;
 	unsigned int		max;
-	struct page		*pages[];
+	struct encoded_page	*encoded_pages[];
 };
 
 #define MAX_GATHER_BATCH	\
@@ -256,7 +256,8 @@ struct mmu_gather_batch {
  */
 #define MAX_GATHER_BATCH_COUNT	(10000UL/MAX_GATHER_BATCH)
 
-extern bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page,
+extern bool __tlb_remove_page_size(struct mmu_gather *tlb,
+				   struct encoded_page *page,
 				   int page_size);
 #endif
 
@@ -431,13 +432,13 @@ static inline void tlb_flush_mmu_tlbonly
 static inline void tlb_remove_page_size(struct mmu_gather *tlb,
 					struct page *page, int page_size)
 {
-	if (__tlb_remove_page_size(tlb, page, page_size))
+	if (__tlb_remove_page_size(tlb, encode_page(page, 0), page_size))
 		tlb_flush_mmu(tlb);
 }
 
 static inline bool __tlb_remove_page(struct mmu_gather *tlb, struct page *page)
 {
-	return __tlb_remove_page_size(tlb, page, PAGE_SIZE);
+	return __tlb_remove_page_size(tlb, encode_page(page, 0), PAGE_SIZE);
 }
 
 /* tlb_remove_page
--- a/include/linux/swap.h~mm-mmu_gather-prepare-to-gather-encoded-page-pointers-with-flags
+++ a/include/linux/swap.h
@@ -463,7 +463,7 @@ static inline unsigned long total_swapca
 
 extern void free_swap_cache(struct page *page);
 extern void free_page_and_swap_cache(struct page *);
-extern void free_pages_and_swap_cache(struct page **, int);
+extern void free_pages_and_swap_cache(struct encoded_page **, int);
 /* linux/mm/swapfile.c */
 extern atomic_long_t nr_swap_pages;
 extern long total_swap_pages;
--- a/mm/mmu_gather.c~mm-mmu_gather-prepare-to-gather-encoded-page-pointers-with-flags
+++ a/mm/mmu_gather.c
@@ -48,7 +48,7 @@ static void tlb_batch_pages_flush(struct
 	struct mmu_gather_batch *batch;
 
 	for (batch = &tlb->local; batch && batch->nr; batch = batch->next) {
-		struct page **pages = batch->pages;
+		struct encoded_page **pages = batch->encoded_pages;
 
 		do {
 			/*
@@ -77,7 +77,7 @@ static void tlb_batch_list_free(struct m
 	tlb->local.next = NULL;
 }
 
-bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page, int page_size)
+bool __tlb_remove_page_size(struct mmu_gather *tlb, struct encoded_page *page, int page_size)
 {
 	struct mmu_gather_batch *batch;
 
@@ -92,13 +92,13 @@ bool __tlb_remove_page_size(struct mmu_g
 	 * Add the page and check if we are full. If so
 	 * force a flush.
 	 */
-	batch->pages[batch->nr++] = page;
+	batch->encoded_pages[batch->nr++] = page;
 	if (batch->nr == batch->max) {
 		if (!tlb_next_batch(tlb))
 			return true;
 		batch = tlb->active;
 	}
-	VM_BUG_ON_PAGE(batch->nr > batch->max, page);
+	VM_BUG_ON_PAGE(batch->nr > batch->max, encoded_page_ptr(page));
 
 	return false;
 }
--- a/mm/swap_state.c~mm-mmu_gather-prepare-to-gather-encoded-page-pointers-with-flags
+++ a/mm/swap_state.c
@@ -303,15 +303,12 @@ void free_page_and_swap_cache(struct pag
  * Passed an array of pages, drop them all from swapcache and then release
  * them.  They are removed from the LRU and freed if this is their last use.
  */
-void free_pages_and_swap_cache(struct page **pages, int nr)
+void free_pages_and_swap_cache(struct encoded_page **pages, int nr)
 {
-	struct page **pagep = pages;
-	int i;
-
 	lru_add_drain();
-	for (i = 0; i < nr; i++)
-		free_swap_cache(pagep[i]);
-	release_pages(pagep, nr);
+	for (int i = 0; i < nr; i++)
+		free_swap_cache(encoded_page_ptr(pages[i]));
+	release_pages(pages, nr);
 }
 
 static inline bool swap_use_vma_readahead(void)
_

Patches currently in -mm which might be from torvalds@linux-foundation.org are

mm-introduce-encoded-page-pointers-with-embedded-extra-bits.patch
mm-teach-release_pages-to-take-an-array-of-encoded-page-pointers-too.patch
mm-mmu_gather-prepare-to-gather-encoded-page-pointers-with-flags.patch
mm-delay-page_remove_rmap-until-after-the-tlb-has-been-flushed.patch

