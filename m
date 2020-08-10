Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72BB9C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:40:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44A432065D
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027209;
	bh=/XSxNBT6f0GsSlDatxM+zlOZbqDYKzCFjqBVxwVglt0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=YUvyWbymDAgpMLZasrZBRDCL5qgz4Bas8xErW6+UjJSV2rQXnIdHzjiMI60/I4Bqg
	 tPO8HkcFM3RODG/y+MbOX13/I2UTDRooUJo7kiwQ0+JNNNCgSTMf4khFKxVAzl3wgn
	 3zMPqVYtSt1AT8PFKDWjFUDKNh0uN9AG+JfGMiso=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgHJCkJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:40:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:43158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbgHJCkI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:40:08 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92C2D206C3;
        Mon, 10 Aug 2020 02:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027206;
        bh=/XSxNBT6f0GsSlDatxM+zlOZbqDYKzCFjqBVxwVglt0=;
        h=Date:From:To:Subject:From;
        b=h6bjjYf7my5OwvPv41DgcqYQgofBxioY6zzPDa5BVIW3EIM3riNhCXkHaMxoi3FZy
         G1It0asUVOYTNMpNZf6ug7C3kove4O9uNc7qkfoDeT3E1Wd5hMB5jjSLBoIrVX9IwU
         mbqqRKSf5dXj5OE4dVpdAVxgJ2XtS7joVtKdnUzQ=
Date:   Sun, 09 Aug 2020 19:40:06 -0700
From:   akpm@linux-foundation.org
To:     mgorman@suse.de, mm-commits@vger.kernel.org,
        richard.weiyang@linux.alibaba.com
Subject:  [merged]
 mm-page_allocc-simplify-pageblock-bitmap-access.patch removed from -mm tree
Message-ID: <20200810024006.sG18j6jD1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: simplify pageblock bitmap access
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-simplify-pageblock-bitmap-access.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/page_alloc.c: simplify pageblock bitmap access

Due to commit e58469bafd05 ("mm: page_alloc: use word-based accesses for
get/set pageblock bitmaps"), pageblock bitmap is accessed with word-based
access.  This operation could be simplified a little.

Intuitively, if we want to get a bit range [start_idx, end_idx] in a word,
we can do like this:

    mask = (1 << (end_bitidx - start_bitidx + 1)) - 1;
    ret = (word >> start_idx) & mask;

And also if we want to set a bit range [start_idx, end_idx] with flags, we
can do the same by just shift start_bitidx.

By doing so we reduce some instructions for these two helper functions:

                                Before   Patched
    set_pfnblock_flags_mask     209      198(-5%)
    get_pfnblock_flags_mask     101      87(-13%)

Since the syntax is changed a little, we need to check the whole 4-bit
migrate_type instead of part of it.

Link: http://lkml.kernel.org/r/20200623124201.8199-3-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pageblock-flags.h |   22 +++++++---------------
 mm/page_alloc.c                 |   13 ++++++-------
 2 files changed, 13 insertions(+), 22 deletions(-)

--- a/include/linux/pageblock-flags.h~mm-page_allocc-simplify-pageblock-bitmap-access
+++ a/include/linux/pageblock-flags.h
@@ -66,25 +66,17 @@ void set_pfnblock_flags_mask(struct page
 				unsigned long mask);
 
 /* Declarations for getting and setting flags. See mm/page_alloc.c */
-#define get_pageblock_flags_group(page, start_bitidx, end_bitidx) \
-	get_pfnblock_flags_mask(page, page_to_pfn(page),		\
-			end_bitidx,					\
-			(1 << (end_bitidx - start_bitidx + 1)) - 1)
-#define set_pageblock_flags_group(page, flags, start_bitidx, end_bitidx) \
-	set_pfnblock_flags_mask(page, flags, page_to_pfn(page),		\
-			end_bitidx,					\
-			(1 << (end_bitidx - start_bitidx + 1)) - 1)
-
 #ifdef CONFIG_COMPACTION
 #define get_pageblock_skip(page) \
-			get_pageblock_flags_group(page, PB_migrate_skip,     \
-							PB_migrate_skip)
+	get_pfnblock_flags_mask(page, page_to_pfn(page),	\
+			PB_migrate_skip, (1 << (PB_migrate_skip)))
 #define clear_pageblock_skip(page) \
-			set_pageblock_flags_group(page, 0, PB_migrate_skip,  \
-							PB_migrate_skip)
+	set_pfnblock_flags_mask(page, 0, page_to_pfn(page),	\
+			PB_migrate_skip, (1 << PB_migrate_skip))
 #define set_pageblock_skip(page) \
-			set_pageblock_flags_group(page, 1, PB_migrate_skip,  \
-							PB_migrate_skip)
+	set_pfnblock_flags_mask(page, (1 << PB_migrate_skip),	\
+			page_to_pfn(page),			\
+			PB_migrate_skip, (1 << PB_migrate_skip))
 #else
 static inline bool get_pageblock_skip(struct page *page)
 {
--- a/mm/page_alloc.c~mm-page_allocc-simplify-pageblock-bitmap-access
+++ a/mm/page_alloc.c
@@ -489,8 +489,7 @@ static __always_inline unsigned long __g
 	bitidx &= (BITS_PER_LONG-1);
 
 	word = bitmap[word_bitidx];
-	bitidx += end_bitidx;
-	return (word >> (BITS_PER_LONG - bitidx - 1)) & mask;
+	return (word >> bitidx) & mask;
 }
 
 unsigned long get_pfnblock_flags_mask(struct page *page, unsigned long pfn,
@@ -532,9 +531,8 @@ void set_pfnblock_flags_mask(struct page
 
 	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
 
-	bitidx += end_bitidx;
-	mask <<= (BITS_PER_LONG - bitidx - 1);
-	flags <<= (BITS_PER_LONG - bitidx - 1);
+	mask <<= bitidx;
+	flags <<= bitidx;
 
 	word = READ_ONCE(bitmap[word_bitidx]);
 	for (;;) {
@@ -551,8 +549,9 @@ void set_pageblock_migratetype(struct pa
 		     migratetype < MIGRATE_PCPTYPES))
 		migratetype = MIGRATE_UNMOVABLE;
 
-	set_pageblock_flags_group(page, (unsigned long)migratetype,
-					PB_migrate, PB_migrate_end);
+	set_pfnblock_flags_mask(page, (unsigned long)migratetype,
+				page_to_pfn(page), PB_migrate_end,
+				MIGRATETYPE_MASK);
 }
 
 #ifdef CONFIG_DEBUG_VM
_

Patches currently in -mm which might be from richard.weiyang@linux.alibaba.com are


