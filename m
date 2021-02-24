Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3592C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:08:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8695F64F08
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:08:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbhBXUIC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:08:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:59504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234917AbhBXUHW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:07:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACA5564F26;
        Wed, 24 Feb 2021 20:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197193;
        bh=ZqorPdS+5o6z98fVqJGmBGjcGtgCA8dZsxbVd3l6lzE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=iGlRr2b+sFDgca7zeL+fh9dO6rwbBghk5878IpMTVOwtVJi6ud9R3CxWiM1KaZ73L
         2fMEPgVZDmJcGimhuzsFydbO7NfxOTe+MHHG5nXdDr1ukYGtdJT60hapgU/5z0BNAi
         bQ9xKr9D7QSXZUK/4iuDWsWzTfHUS11yE92yN59s=
Date:   Wed, 24 Feb 2021 12:06:32 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        david@redhat.com, gustavoars@kernel.org, linux-mm@kvack.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org, osalvador@suse.de,
        peterz@infradead.org, richard.weiyang@linux.alibaba.com,
        rppt@kernel.org, sam@ravnborg.org, tglx@linutronix.de,
        torvalds@linux-foundation.org
Subject:  [patch 108/173] mm: simplify free_highmem_page() and
 free_reserved_page()
Message-ID: <20210224200632.FywpPUWVq%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: mm: simplify free_highmem_page() and free_reserved_page()

adjust_managed_page_count() as called by free_reserved_page() properly
handles pages in a highmem zone, so we can reuse it for
free_highmem_page().

We can now get rid of totalhigh_pages_inc() and simplify
free_reserved_page().

Link: https://lkml.kernel.org/r/20210126182113.19892-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem-internal.h |    5 -----
 include/linux/mm.h               |   16 ++--------------
 mm/page_alloc.c                  |   11 -----------
 3 files changed, 2 insertions(+), 30 deletions(-)

--- a/include/linux/highmem-internal.h~mm-simplify-free_highmem_page-and-free_reserved_page
+++ a/include/linux/highmem-internal.h
@@ -127,11 +127,6 @@ static inline unsigned long totalhigh_pa
 	return (unsigned long)atomic_long_read(&_totalhigh_pages);
 }
 
-static inline void totalhigh_pages_inc(void)
-{
-	atomic_long_inc(&_totalhigh_pages);
-}
-
 static inline void totalhigh_pages_add(long count)
 {
 	atomic_long_add(count, &_totalhigh_pages);
--- a/include/linux/mm.h~mm-simplify-free_highmem_page-and-free_reserved_page
+++ a/include/linux/mm.h
@@ -2310,32 +2310,20 @@ extern void free_initmem(void);
 extern unsigned long free_reserved_area(void *start, void *end,
 					int poison, const char *s);
 
-#ifdef	CONFIG_HIGHMEM
-/*
- * Free a highmem page into the buddy system, adjusting totalhigh_pages
- * and totalram_pages.
- */
-extern void free_highmem_page(struct page *page);
-#endif
-
 extern void adjust_managed_page_count(struct page *page, long count);
 extern void mem_init_print_info(const char *str);
 
 extern void reserve_bootmem_region(phys_addr_t start, phys_addr_t end);
 
 /* Free the reserved page into the buddy system, so it gets managed. */
-static inline void __free_reserved_page(struct page *page)
+static inline void free_reserved_page(struct page *page)
 {
 	ClearPageReserved(page);
 	init_page_count(page);
 	__free_page(page);
-}
-
-static inline void free_reserved_page(struct page *page)
-{
-	__free_reserved_page(page);
 	adjust_managed_page_count(page, 1);
 }
+#define free_highmem_page(page) free_reserved_page(page)
 
 static inline void mark_page_reserved(struct page *page)
 {
--- a/mm/page_alloc.c~mm-simplify-free_highmem_page-and-free_reserved_page
+++ a/mm/page_alloc.c
@@ -7691,17 +7691,6 @@ unsigned long free_reserved_area(void *s
 	return pages;
 }
 
-#ifdef	CONFIG_HIGHMEM
-void free_highmem_page(struct page *page)
-{
-	__free_reserved_page(page);
-	totalram_pages_inc();
-	atomic_long_inc(&page_zone(page)->managed_pages);
-	totalhigh_pages_inc();
-}
-#endif
-
-
 void __init mem_init_print_info(const char *str)
 {
 	unsigned long physpages, codesize, datasize, rosize, bss_size;
_
