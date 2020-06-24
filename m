From: akpm@linux-foundation.org
Subject: +
 mm-page_allocc-remove-unnecessary-end_bitidx-for-_pfnblock_flags_mask.patch
 added to -mm tree
Date: Wed, 24 Jun 2020 14:54:55 -0700
Message-ID: <20200624215455.Rna8B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729463AbgFXVy4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 17:54:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mgorman@suse.de, richard.weiyang@linux.alibaba.com


The patch titled
     Subject: mm/page_alloc.c: remove unnecessary end_bitidx for [set|get]_pfnblock_flags_mask()
has been added to the -mm tree.  Its filename is
     mm-page_allocc-remove-unnecessary-end_bitidx-for-_pfnblock_flags_mask.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_allocc-remove-unnecessary-end_bitidx-for-_pfnblock_flags_mask.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_allocc-remove-unnecessary-end_bitidx-for-_pfnblock_flags_mask.patch

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
Subject: mm/page_alloc.c: remove unnecessary end_bitidx for [set|get]_pfnblock_flags_mask()

After previous cleanup, the end_bitidx is not necessary any more.

Link: http://lkml.kernel.org/r/20200623124201.8199-4-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h          |    3 +--
 include/linux/pageblock-flags.h |    8 +++-----
 mm/page_alloc.c                 |   15 +++++----------
 3 files changed, 9 insertions(+), 17 deletions(-)

--- a/include/linux/mmzone.h~mm-page_allocc-remove-unnecessary-end_bitidx-for-_pfnblock_flags_mask
+++ a/include/linux/mmzone.h
@@ -91,8 +91,7 @@ extern int page_group_by_mobility_disabl
 #define MIGRATETYPE_MASK ((1UL << PB_migratetype_bits) - 1)
 
 #define get_pageblock_migratetype(page)					\
-	get_pfnblock_flags_mask(page, page_to_pfn(page),		\
-			PB_migrate_end, MIGRATETYPE_MASK)
+	get_pfnblock_flags_mask(page, page_to_pfn(page), MIGRATETYPE_MASK)
 
 struct free_area {
 	struct list_head	free_list[MIGRATE_TYPES];
--- a/include/linux/pageblock-flags.h~mm-page_allocc-remove-unnecessary-end_bitidx-for-_pfnblock_flags_mask
+++ a/include/linux/pageblock-flags.h
@@ -56,27 +56,25 @@ struct page;
 
 unsigned long get_pfnblock_flags_mask(struct page *page,
 				unsigned long pfn,
-				unsigned long end_bitidx,
 				unsigned long mask);
 
 void set_pfnblock_flags_mask(struct page *page,
 				unsigned long flags,
 				unsigned long pfn,
-				unsigned long end_bitidx,
 				unsigned long mask);
 
 /* Declarations for getting and setting flags. See mm/page_alloc.c */
 #ifdef CONFIG_COMPACTION
 #define get_pageblock_skip(page) \
 	get_pfnblock_flags_mask(page, page_to_pfn(page),	\
-			PB_migrate_skip, (1 << (PB_migrate_skip)))
+			(1 << (PB_migrate_skip)))
 #define clear_pageblock_skip(page) \
 	set_pfnblock_flags_mask(page, 0, page_to_pfn(page),	\
-			PB_migrate_skip, (1 << PB_migrate_skip))
+			(1 << PB_migrate_skip))
 #define set_pageblock_skip(page) \
 	set_pfnblock_flags_mask(page, (1 << PB_migrate_skip),	\
 			page_to_pfn(page),			\
-			PB_migrate_skip, (1 << PB_migrate_skip))
+			(1 << PB_migrate_skip))
 #else
 static inline bool get_pageblock_skip(struct page *page)
 {
--- a/mm/page_alloc.c~mm-page_allocc-remove-unnecessary-end_bitidx-for-_pfnblock_flags_mask
+++ a/mm/page_alloc.c
@@ -472,14 +472,13 @@ static inline int pfn_to_bitidx(struct p
  * get_pfnblock_flags_mask - Return the requested group of flags for the pageblock_nr_pages block of pages
  * @page: The page within the block of interest
  * @pfn: The target page frame number
- * @end_bitidx: The last bit of interest to retrieve
  * @mask: mask of bits that the caller is interested in
  *
  * Return: pageblock_bits flags
  */
-static __always_inline unsigned long __get_pfnblock_flags_mask(struct page *page,
+static __always_inline
+unsigned long __get_pfnblock_flags_mask(struct page *page,
 					unsigned long pfn,
-					unsigned long end_bitidx,
 					unsigned long mask)
 {
 	unsigned long *bitmap;
@@ -496,15 +495,14 @@ static __always_inline unsigned long __g
 }
 
 unsigned long get_pfnblock_flags_mask(struct page *page, unsigned long pfn,
-					unsigned long end_bitidx,
 					unsigned long mask)
 {
-	return __get_pfnblock_flags_mask(page, pfn, end_bitidx, mask);
+	return __get_pfnblock_flags_mask(page, pfn, mask);
 }
 
 static __always_inline int get_pfnblock_migratetype(struct page *page, unsigned long pfn)
 {
-	return __get_pfnblock_flags_mask(page, pfn, PB_migrate_end, MIGRATETYPE_MASK);
+	return __get_pfnblock_flags_mask(page, pfn, MIGRATETYPE_MASK);
 }
 
 /**
@@ -512,12 +510,10 @@ static __always_inline int get_pfnblock_
  * @page: The page within the block of interest
  * @flags: The flags to set
  * @pfn: The target page frame number
- * @end_bitidx: The last bit of interest
  * @mask: mask of bits that the caller is interested in
  */
 void set_pfnblock_flags_mask(struct page *page, unsigned long flags,
 					unsigned long pfn,
-					unsigned long end_bitidx,
 					unsigned long mask)
 {
 	unsigned long *bitmap;
@@ -553,8 +549,7 @@ void set_pageblock_migratetype(struct pa
 		migratetype = MIGRATE_UNMOVABLE;
 
 	set_pfnblock_flags_mask(page, (unsigned long)migratetype,
-				page_to_pfn(page), PB_migrate_end,
-				MIGRATETYPE_MASK);
+				page_to_pfn(page), MIGRATETYPE_MASK);
 }
 
 #ifdef CONFIG_DEBUG_VM
_

Patches currently in -mm which might be from richard.weiyang@linux.alibaba.com are

mm-page_allocc-replace-the-definition-of-nr_migratetype_bits-with-pb_migratetype_bits.patch
mm-page_allocc-extract-the-common-part-in-pfn_to_bitidx.patch
mm-page_allocc-simplify-pageblock-bitmap-access.patch
mm-page_allocc-remove-unnecessary-end_bitidx-for-_pfnblock_flags_mask.patch
