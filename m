Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E57FC433ED
	for <mm-commits@archiver.kernel.org>; Fri, 16 Apr 2021 22:45:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11FEF613C3
	for <mm-commits@archiver.kernel.org>; Fri, 16 Apr 2021 22:45:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234775AbhDPWqU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Apr 2021 18:46:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:53164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231296AbhDPWqU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Apr 2021 18:46:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F32FF6137D;
        Fri, 16 Apr 2021 22:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618613155;
        bh=aaCF2HWlKT9lX7cEAgmlF2G9RxkC7JLcX8osP4AspOs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Tk79Y6CQP5peDE4HZB6rOHeLgMIZaZJfoLE8lJtsuXdTlOj+KBAtamITapNnlPQbz
         thPgofJEh3hx9hkJ4m2GK3p+fWXqm9Z55pLmOTyyzek5iQSKFvfC71hB0LtNWZ7Bup
         kBfkUy9TUm0OYjrFS8mtgVMuSZWHfbQLZIQD1Mu0=
Date:   Fri, 16 Apr 2021 15:45:54 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 01/12] mm: eliminate "expecting prototype"
 kernel-doc warnings
Message-ID: <20210416224554.052darJdq%akpm@linux-foundation.org>
In-Reply-To: <20210416154523.3f9794326e8e1db549873cf8@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm: eliminate "expecting prototype" kernel-doc warnings

Fix stray kernel-doc warnings in mm/ due to mis-typed or missing function
names.

Quietens these kernel-doc warnings:

../mm/mmu_gather.c:264: warning: expecting prototype for tlb_gather_mmu(). Prototype was for __tlb_gather_mmu() instead
../mm/oom_kill.c:180: warning: expecting prototype for Check whether unreclaimable slab amount is greater than(). Prototype was for should_dump_unreclaim_slab() instead
../mm/shuffle.c:155: warning: expecting prototype for shuffle_free_memory(). Prototype was for __shuffle_free_memory() instead

Link: https://lkml.kernel.org/r/20210411210642.11362-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_gather.c |   29 +++++++++++++++++++----------
 mm/oom_kill.c   |    2 +-
 mm/shuffle.c    |    4 ++--
 3 files changed, 22 insertions(+), 13 deletions(-)

--- a/mm/mmu_gather.c~mm-eliminate-expecting-prototype-kernel-doc-warnings
+++ a/mm/mmu_gather.c
@@ -249,16 +249,6 @@ void tlb_flush_mmu(struct mmu_gather *tl
 	tlb_flush_mmu_free(tlb);
 }
 
-/**
- * tlb_gather_mmu - initialize an mmu_gather structure for page-table tear-down
- * @tlb: the mmu_gather structure to initialize
- * @mm: the mm_struct of the target address space
- * @fullmm: @mm is without users and we're going to destroy the full address
- *	    space (exit/execve)
- *
- * Called to initialize an (on-stack) mmu_gather structure for page-table
- * tear-down from @mm.
- */
 static void __tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm,
 			     bool fullmm)
 {
@@ -283,11 +273,30 @@ static void __tlb_gather_mmu(struct mmu_
 	inc_tlb_flush_pending(tlb->mm);
 }
 
+/**
+ * tlb_gather_mmu - initialize an mmu_gather structure for page-table tear-down
+ * @tlb: the mmu_gather structure to initialize
+ * @mm: the mm_struct of the target address space
+ *
+ * Called to initialize an (on-stack) mmu_gather structure for page-table
+ * tear-down from @mm.
+ */
 void tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm)
 {
 	__tlb_gather_mmu(tlb, mm, false);
 }
 
+/**
+ * tlb_gather_mmu_fullmm - initialize an mmu_gather structure for page-table tear-down
+ * @tlb: the mmu_gather structure to initialize
+ * @mm: the mm_struct of the target address space
+ *
+ * In this case, @mm is without users and we're going to destroy the
+ * full address space (exit/execve).
+ *
+ * Called to initialize an (on-stack) mmu_gather structure for page-table
+ * tear-down from @mm.
+ */
 void tlb_gather_mmu_fullmm(struct mmu_gather *tlb, struct mm_struct *mm)
 {
 	__tlb_gather_mmu(tlb, mm, true);
--- a/mm/oom_kill.c~mm-eliminate-expecting-prototype-kernel-doc-warnings
+++ a/mm/oom_kill.c
@@ -170,7 +170,7 @@ static bool oom_unkillable_task(struct t
 	return false;
 }
 
-/**
+/*
  * Check whether unreclaimable slab amount is greater than
  * all user memory(LRU pages).
  * dump_unreclaimable_slab() could help in the case that
--- a/mm/shuffle.c~mm-eliminate-expecting-prototype-kernel-doc-warnings
+++ a/mm/shuffle.c
@@ -147,8 +147,8 @@ void __meminit __shuffle_zone(struct zon
 	spin_unlock_irqrestore(&z->lock, flags);
 }
 
-/**
- * shuffle_free_memory - reduce the predictability of the page allocator
+/*
+ * __shuffle_free_memory - reduce the predictability of the page allocator
  * @pgdat: node page data
  */
 void __meminit __shuffle_free_memory(pg_data_t *pgdat)
_
