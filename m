Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACC86C77B7A
	for <mm-commits@archiver.kernel.org>; Fri, 19 May 2023 21:40:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjESVki (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 May 2023 17:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjESVkh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 May 2023 17:40:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB57101
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 14:40:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E183E65B0A
        for <mm-commits@vger.kernel.org>; Fri, 19 May 2023 21:40:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42876C433EF;
        Fri, 19 May 2023 21:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684532435;
        bh=WWGrIFhZRBqhQq33e4ySbopfQZhVFif0WvOkFGcyn9k=;
        h=Date:To:From:Subject:From;
        b=ecxMnZYev+BId1FeXIseAYrNLuYpM/nXVO9n5W0Jb5mptJvvx4zgtgmND42WYKzzM
         Fhpz57S4He8axDOiFM6wCOADrNQDa+231IV4XKGfeqPYkz32/gqiD4ebkJmvIGR8Q9
         bcw4P/MSz9H4W3+tmm00qfKtWle2fl9iWdgfd0ds=
Date:   Fri, 19 May 2023 14:40:34 -0700
To:     mm-commits@vger.kernel.org, hannes@cmpxchg.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_isolation-write-proper-kerneldoc.patch added to mm-unstable branch
Message-Id: <20230519214035.42876C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_isolation: write proper kerneldoc
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_isolation-write-proper-kerneldoc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_isolation-write-proper-kerneldoc.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_isolation: write proper kerneldoc
Date: Fri, 19 May 2023 13:16:52 +0200

And remove the incorrect header comments.

Link: https://lkml.kernel.org/r/20230519111652.40658-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-isolation.h |   20 ++++----------------
 mm/page_isolation.c            |   29 ++++++++++++++++++++++++-----
 2 files changed, 28 insertions(+), 21 deletions(-)

--- a/include/linux/page-isolation.h~mm-page_isolation-write-proper-kerneldoc
+++ a/include/linux/page-isolation.h
@@ -37,24 +37,12 @@ void set_pageblock_migratetype(struct pa
 int move_freepages_block(struct zone *zone, struct page *page,
 				int migratetype, int *num_movable);
 
-/*
- * Changes migrate type in [start_pfn, end_pfn) to be MIGRATE_ISOLATE.
- */
-int
-start_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
-			 int migratetype, int flags, gfp_t gfp_flags);
+int start_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
+			     int migratetype, int flags, gfp_t gfp_flags);
 
-/*
- * Changes MIGRATE_ISOLATE to MIGRATE_MOVABLE.
- * target range is [start_pfn, end_pfn)
- */
-void
-undo_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
-			int migratetype);
+void undo_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
+			     int migratetype);
 
-/*
- * Test all pages in [start_pfn, end_pfn) are isolated or not.
- */
 int test_pages_isolated(unsigned long start_pfn, unsigned long end_pfn,
 			int isol_flags);
 
--- a/mm/page_isolation.c~mm-page_isolation-write-proper-kerneldoc
+++ a/mm/page_isolation.c
@@ -481,8 +481,7 @@ failed:
 }
 
 /**
- * start_isolate_page_range() - make page-allocation-type of range of pages to
- * be MIGRATE_ISOLATE.
+ * start_isolate_page_range() - mark page range MIGRATE_ISOLATE
  * @start_pfn:		The lower PFN of the range to be isolated.
  * @end_pfn:		The upper PFN of the range to be isolated.
  * @migratetype:	Migrate type to set in error recovery.
@@ -571,8 +570,14 @@ int start_isolate_page_range(unsigned lo
 	return 0;
 }
 
-/*
- * Make isolated pages available again.
+/**
+ * undo_isolate_page_range - undo effects of start_isolate_page_range()
+ * @start_pfn:		The lower PFN of the isolated range
+ * @end_pfn:		The upper PFN of the isolated range
+ * @migratetype:	New migrate type to set on the range
+ *
+ * This finds every MIGRATE_ISOLATE page block in the given range
+ * and switches it to @migratetype.
  */
 void undo_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
 			    int migratetype)
@@ -631,7 +636,21 @@ __test_page_isolated_in_pageblock(unsign
 	return pfn;
 }
 
-/* Caller should ensure that requested range is in a single zone */
+/**
+ * test_pages_isolated - check if pageblocks in range are isolated
+ * @start_pfn:		The first PFN of the isolated range
+ * @end_pfn:		The first PFN *after* the isolated range
+ * @isol_flags:		Testing mode flags
+ *
+ * This tests if all in the specified range are free.
+ *
+ * If %MEMORY_OFFLINE is specified in @flags, it will consider
+ * poisoned and offlined pages free as well.
+ *
+ * Caller must ensure the requested range doesn't span zones.
+ *
+ * Returns 0 if true, -EBUSY if one or more pages are in use.
+ */
 int test_pages_isolated(unsigned long start_pfn, unsigned long end_pfn,
 			int isol_flags)
 {
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-compaction-remove-compaction-result-helpers.patch
mm-compaction-simplify-should_compact_retry.patch
mm-compaction-refactor-__compaction_suitable.patch
mm-compaction-remove-unnecessary-is_via_compact_memory-checks.patch
mm-compaction-drop-redundant-watermark-check-in-compaction_zonelist_suitable.patch
mm-page_isolation-write-proper-kerneldoc.patch

