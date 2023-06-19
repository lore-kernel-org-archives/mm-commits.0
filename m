Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5C4CEB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjFSXUT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjFSXUT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:20:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4D8F9
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECA9460F14
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F95C433C0;
        Mon, 19 Jun 2023 23:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216817;
        bh=JzIa3bbRf+5dHb92ZRzKyJeWaw+qarQCjRcFA2GqbFY=;
        h=Date:To:From:Subject:From;
        b=2WuPscBVMJLtgzW/fJx2QQhRhdq33Mop/20Exx0MJQXdZpmAvYT5/oLqvcJTDKjUM
         4Q9VZP9CIS+/ayqy7IG34Xw5f705LZ9DZ/51aFDd2hq+9fZ/zRROhzapXExG9HM/rX
         1ZVC6cLVegVYAaEsv/CuQUzmRU2S+tOQtlU3IYvY=
Date:   Mon, 19 Jun 2023 16:20:16 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, hannes@cmpxchg.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_isolation-write-proper-kerneldoc.patch removed from -mm tree
Message-Id: <20230619232017.54F95C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: page_isolation: write proper kerneldoc
has been removed from the -mm tree.  Its filename was
     mm-page_isolation-write-proper-kerneldoc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_isolation: write proper kerneldoc
Date: Fri, 19 May 2023 13:16:52 +0200

And remove the incorrect header comments.

[akpm@linux-foundation.org: s/lower/first/, s/upper/last/, per Mike]
Link: https://lkml.kernel.org/r/20230519111652.40658-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-isolation.h |   20 +++---------------
 mm/page_isolation.c            |   33 ++++++++++++++++++++++++-------
 2 files changed, 30 insertions(+), 23 deletions(-)

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
@@ -481,10 +481,9 @@ failed:
 }
 
 /**
- * start_isolate_page_range() - make page-allocation-type of range of pages to
- * be MIGRATE_ISOLATE.
- * @start_pfn:		The lower PFN of the range to be isolated.
- * @end_pfn:		The upper PFN of the range to be isolated.
+ * start_isolate_page_range() - mark page range MIGRATE_ISOLATE
+ * @start_pfn:		The first PFN of the range to be isolated.
+ * @end_pfn:		The last PFN of the range to be isolated.
  * @migratetype:	Migrate type to set in error recovery.
  * @flags:		The following flags are allowed (they can be combined in
  *			a bit mask)
@@ -571,8 +570,14 @@ int start_isolate_page_range(unsigned lo
 	return 0;
 }
 
-/*
- * Make isolated pages available again.
+/**
+ * undo_isolate_page_range - undo effects of start_isolate_page_range()
+ * @start_pfn:		The first PFN of the isolated range
+ * @end_pfn:		The last PFN of the isolated range
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


