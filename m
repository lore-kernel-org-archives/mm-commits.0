Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA7FBC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:14:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA5CF6023F
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:14:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbhGFTQy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:16:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:50994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231727AbhGFTQy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:16:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FC0360FE3;
        Tue,  6 Jul 2021 19:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598855;
        bh=ixMd718AeNW1v8TY/vKDxOI355HGHrrOuJJd003IOEY=;
        h=Date:From:To:Subject:From;
        b=EKGtQ5lI4EmfYemYPeuO4Gvw/tlDFsbX6HMt7LG01jHwGHx9HMiTDhkFwTB2x1h/I
         ZFcwh6nfE6arIzhJeaQxPKZ1/IXvteyNGQzC8jn7zObqqoljICz0MIB/q2oLotcDVT
         rx+LdfPZ2xg6rkEFONWjJ05fWAA2K36eUeqHF7bU=
Date:   Tue, 06 Jul 2021 12:14:15 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, mm-commits@vger.kernel.org,
        vbabka@suse.cz, william.kucharski@oracle.com, willy@infradead.org
Subject:  [merged]
 mm-constify-get_pfnblock_flags_mask-and-get_pfnblock_migratetype.patch
 removed from -mm tree
Message-ID: <20210706191415.Cpg3vF010%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: constify get_pfnblock_flags_mask and get_pfnblock_migratetype
has been removed from the -mm tree.  Its filename was
     mm-constify-get_pfnblock_flags_mask-and-get_pfnblock_migratetype.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: constify get_pfnblock_flags_mask and get_pfnblock_migratetype

The struct page is not modified by these routines, so it can be marked
const.

Link: https://lkml.kernel.org/r/20210416231531.2521383-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pageblock-flags.h |    2 +-
 mm/page_alloc.c                 |   13 +++++++------
 2 files changed, 8 insertions(+), 7 deletions(-)

--- a/include/linux/pageblock-flags.h~mm-constify-get_pfnblock_flags_mask-and-get_pfnblock_migratetype
+++ a/include/linux/pageblock-flags.h
@@ -54,7 +54,7 @@ extern unsigned int pageblock_order;
 /* Forward declaration */
 struct page;
 
-unsigned long get_pfnblock_flags_mask(struct page *page,
+unsigned long get_pfnblock_flags_mask(const struct page *page,
 				unsigned long pfn,
 				unsigned long mask);
 
--- a/mm/page_alloc.c~mm-constify-get_pfnblock_flags_mask-and-get_pfnblock_migratetype
+++ a/mm/page_alloc.c
@@ -474,7 +474,7 @@ static inline bool defer_init(int nid, u
 #endif
 
 /* Return a pointer to the bitmap storing bits affecting a block of pages */
-static inline unsigned long *get_pageblock_bitmap(struct page *page,
+static inline unsigned long *get_pageblock_bitmap(const struct page *page,
 							unsigned long pfn)
 {
 #ifdef CONFIG_SPARSEMEM
@@ -484,7 +484,7 @@ static inline unsigned long *get_pageblo
 #endif /* CONFIG_SPARSEMEM */
 }
 
-static inline int pfn_to_bitidx(struct page *page, unsigned long pfn)
+static inline int pfn_to_bitidx(const struct page *page, unsigned long pfn)
 {
 #ifdef CONFIG_SPARSEMEM
 	pfn &= (PAGES_PER_SECTION-1);
@@ -495,7 +495,7 @@ static inline int pfn_to_bitidx(struct p
 }
 
 static __always_inline
-unsigned long __get_pfnblock_flags_mask(struct page *page,
+unsigned long __get_pfnblock_flags_mask(const struct page *page,
 					unsigned long pfn,
 					unsigned long mask)
 {
@@ -520,13 +520,14 @@ unsigned long __get_pfnblock_flags_mask(
  *
  * Return: pageblock_bits flags
  */
-unsigned long get_pfnblock_flags_mask(struct page *page, unsigned long pfn,
-					unsigned long mask)
+unsigned long get_pfnblock_flags_mask(const struct page *page,
+					unsigned long pfn, unsigned long mask)
 {
 	return __get_pfnblock_flags_mask(page, pfn, mask);
 }
 
-static __always_inline int get_pfnblock_migratetype(struct page *page, unsigned long pfn)
+static __always_inline int get_pfnblock_migratetype(const struct page *page,
+					unsigned long pfn)
 {
 	return __get_pfnblock_flags_mask(page, pfn, MIGRATETYPE_MASK);
 }
_

Patches currently in -mm which might be from willy@infradead.org are

mm-mark-idle-page-tracking-as-broken.patch

