Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64222C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:25:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33EED22D00
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781550;
	bh=ZkLO//6enNp1LRTd6Cwm41IfTmF0eE+DjpXghoGd+Gs=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=l9R4SOYa0Sn7lqOWx521GlUKOhUlttOg3ugD9gK1n4OYLX9QrSKMpAkMgMjJXEZf7
	 jbkFpgedpol7lPqa/aND3I8v+08q/ZXShjRWqhFTtYNzSZlKMtELY2NaV0/NgIY+Kz
	 yg0KQX2xMcP2y2j7HeSjyoPv5eWooHso528wHo5k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726459AbgHGGZu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:25:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:34504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgHGGZt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:25:49 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7715222CAE;
        Fri,  7 Aug 2020 06:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781548;
        bh=ZkLO//6enNp1LRTd6Cwm41IfTmF0eE+DjpXghoGd+Gs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=qmd37TwsMbl3WnWuF5j6q4cGQrfZY/v0coMA5NYj/rCwgMpEdufmAluXIa2R7ILPN
         +tZ8yvnDgdDfDIkyLQevIw4jQeKziqOVFa45b7+og283tnaewMMih4CnmgrvpqZ7BS
         +l0AP/IHvBZL+R4d4Qkm00Qd4ucBZC+0eJgfHz40=
Date:   Thu, 06 Aug 2020 23:25:48 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org, mgorman@suse.de,
        mm-commits@vger.kernel.org, richard.weiyang@linux.alibaba.com,
        torvalds@linux-foundation.org
Subject:  [patch 150/163] mm/page_alloc.c: simplify pageblock
 bitmap access
Message-ID: <20200807062548.Aqdsn7bvu%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
