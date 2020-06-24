From: akpm@linux-foundation.org
Subject: + mm-page_allocc-simplify-pageblock-bitmap-access.patch
 added to -mm tree
Date: Wed, 24 Jun 2020 14:54:53 -0700
Message-ID: <20200624215453.3tNLQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390681AbgFXVyy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 17:54:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mgorman@suse.de, richard.weiyang@linux.alibaba.com


The patch titled
     Subject: mm/page_alloc.c: simplify pageblock bitmap access
has been added to the -mm tree.  Its filename is
     mm-page_allocc-simplify-pageblock-bitmap-access.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_allocc-simplify-pageblock-bitmap-access.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_allocc-simplify-pageblock-bitmap-access.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -492,8 +492,7 @@ static __always_inline unsigned long __g
 	bitidx &= (BITS_PER_LONG-1);
 
 	word = bitmap[word_bitidx];
-	bitidx += end_bitidx;
-	return (word >> (BITS_PER_LONG - bitidx - 1)) & mask;
+	return (word >> bitidx) & mask;
 }
 
 unsigned long get_pfnblock_flags_mask(struct page *page, unsigned long pfn,
@@ -535,9 +534,8 @@ void set_pfnblock_flags_mask(struct page
 
 	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
 
-	bitidx += end_bitidx;
-	mask <<= (BITS_PER_LONG - bitidx - 1);
-	flags <<= (BITS_PER_LONG - bitidx - 1);
+	mask <<= bitidx;
+	flags <<= bitidx;
 
 	word = READ_ONCE(bitmap[word_bitidx]);
 	for (;;) {
@@ -554,8 +552,9 @@ void set_pageblock_migratetype(struct pa
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

mm-page_allocc-replace-the-definition-of-nr_migratetype_bits-with-pb_migratetype_bits.patch
mm-page_allocc-extract-the-common-part-in-pfn_to_bitidx.patch
mm-page_allocc-simplify-pageblock-bitmap-access.patch
mm-page_allocc-remove-unnecessary-end_bitidx-for-_pfnblock_flags_mask.patch
