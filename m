Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B583C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 24 May 2022 20:23:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241453AbiEXUXs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 24 May 2022 16:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241372AbiEXUXk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 May 2022 16:23:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E0B5D5EC
        for <mm-commits@vger.kernel.org>; Tue, 24 May 2022 13:23:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3EBD61730
        for <mm-commits@vger.kernel.org>; Tue, 24 May 2022 20:23:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F43C34100;
        Tue, 24 May 2022 20:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653423818;
        bh=PkfZZMo3cpt1EnOnh++ShhSBBVq+meBTWvRfWvfGU24=;
        h=Date:To:From:Subject:From;
        b=jvD9YFOZx4je2hlX5rPucAVNQgf0vbSaNqkuVeK1PbUmlD8wen4YV/zXrmXhToEkQ
         cY4YAOisz0VKO+glcHdH1hKj03Zg+brLSXdAHseJSShqv+HTjkMdByhkC5phcEjwVu
         JzVLtdhtgQ7UgzB723j8IBGImwAzxAGcfteR5qO8=
Date:   Tue, 24 May 2022 13:23:37 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@linux.ibm.com,
        renzhengeek@gmail.com, quic_qiancai@quicinc.com, osalvador@suse.de,
        minchan@kernel.org, mgorman@techsingularity.net, david@redhat.com,
        christophe.leroy@csgroup.eu, ziy@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-a-potential-infinite-loop-in-start_isolate_page_range.patch added to mm-unstable branch
Message-Id: <20220524202338.22F43C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix a potential infinite loop in start_isolate_page_range()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-a-potential-infinite-loop-in-start_isolate_page_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-a-potential-infinite-loop-in-start_isolate_page_range.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm: fix a potential infinite loop in start_isolate_page_range()
Date: Tue, 24 May 2022 15:47:56 -0400

In isolate_single_pageblock() called by start_isolate_page_range(), there
are some pageblock isolation issues causing a potential infinite loop when
isolating a page range.  This is reported by Qian Cai.

1. the pageblock was isolated by just changing pageblock migratetype
   without checking unmovable pages. Calling set_migratetype_isolate() to
   isolate pageblock properly.
2. an off-by-one error caused migrating pages unnecessarily, since the page
   is not crossing pageblock boundary.
3. migrating a compound page across pageblock boundary then splitting the
   free page later has a small race window that the free page might be
   allocated again, so that the code will try again, causing an potential
   infinite loop. Temporarily set the to-be-migrated page's pageblock to
   MIGRATE_ISOLATE to prevent that and bail out early if no free page is
   found after page migration.

An additional fix to split_free_page() aims to avoid crashing in
__free_one_page().  When the free page is split at the specified
split_pfn_offset, free_page_order should check both the first bit of
free_page_pfn and the last bit of split_pfn_offset and use the smaller
one.  For example, if free_page_pfn=3D0x10000, split_pfn_offset=3D0xc000,
free_page_order should first be 0x8000 then 0x4000, instead of 0x4000 then
0x8000, which the original algorithm did.

Link: https://lkml.kernel.org/r/20220524194756.1698351-1-zi.yan@sent.com
Fixes: b2c9e2fbba ("mm: make alloc_contig_range work at pageblock granulari=
ty")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: Qian Cai <quic_qiancai@quicinc.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@redhat.com>
Cc: Eric Ren <renzhengeek@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c     |    5 +++-
 mm/page_isolation.c |   52 ++++++++++++++++++++++++++++++++----------
 2 files changed, 44 insertions(+), 13 deletions(-)

--- a/mm/page_alloc.c~mm-fix-a-potential-infinite-loop-in-start_isolate_page_range
+++ a/mm/page_alloc.c
@@ -1114,13 +1114,16 @@ void split_free_page(struct page *free_p
 	unsigned long flags;
 	int free_page_order;
 
+	if (split_pfn_offset == 0)
+		return;
+
 	spin_lock_irqsave(&zone->lock, flags);
 	del_page_from_free_list(free_page, zone, order);
 	for (pfn = free_page_pfn;
 	     pfn < free_page_pfn + (1UL << order);) {
 		int mt = get_pfnblock_migratetype(pfn_to_page(pfn), pfn);
 
-		free_page_order = ffs(split_pfn_offset) - 1;
+		free_page_order = min(pfn ? __ffs(pfn) : order, __fls(split_pfn_offset));
 		__free_one_page(pfn_to_page(pfn), pfn, zone, free_page_order,
 				mt, FPI_NONE);
 		pfn += 1UL << free_page_order;
--- a/mm/page_isolation.c~mm-fix-a-potential-infinite-loop-in-start_isolate_page_range
+++ a/mm/page_isolation.c
@@ -283,6 +283,7 @@ __first_valid_page(unsigned long pfn, un
  * isolate_single_pageblock() -- tries to isolate a pageblock that might be
  * within a free or in-use page.
  * @boundary_pfn:		pageblock-aligned pfn that a page might cross
+ * @flags:			isolation flags
  * @gfp_flags:			GFP flags used for migrating pages
  * @isolate_before:	isolate the pageblock before the boundary_pfn
  *
@@ -298,14 +299,15 @@ __first_valid_page(unsigned long pfn, un
  * either. The function handles this by splitting the free page or migrating
  * the in-use page then splitting the free page.
  */
-static int isolate_single_pageblock(unsigned long boundary_pfn, gfp_t gfp_flags,
-			bool isolate_before)
+static int isolate_single_pageblock(unsigned long boundary_pfn, int flags,
+			gfp_t gfp_flags, bool isolate_before)
 {
 	unsigned char saved_mt;
 	unsigned long start_pfn;
 	unsigned long isolate_pageblock;
 	unsigned long pfn;
 	struct zone *zone;
+	int ret;
 
 	VM_BUG_ON(!IS_ALIGNED(boundary_pfn, pageblock_nr_pages));
 
@@ -325,7 +327,11 @@ static int isolate_single_pageblock(unsi
 				      zone->zone_start_pfn);
 
 	saved_mt = get_pageblock_migratetype(pfn_to_page(isolate_pageblock));
-	set_pageblock_migratetype(pfn_to_page(isolate_pageblock), MIGRATE_ISOLATE);
+	ret = set_migratetype_isolate(pfn_to_page(isolate_pageblock), saved_mt, flags,
+			isolate_pageblock, isolate_pageblock + pageblock_nr_pages);
+
+	if (ret)
+		return ret;
 
 	/*
 	 * Bail out early when the to-be-isolated pageblock does not form
@@ -374,7 +380,7 @@ static int isolate_single_pageblock(unsi
 			struct page *head = compound_head(page);
 			unsigned long head_pfn = page_to_pfn(head);
 
-			if (head_pfn + nr_pages < boundary_pfn) {
+			if (head_pfn + nr_pages <= boundary_pfn) {
 				pfn = head_pfn + nr_pages;
 				continue;
 			}
@@ -386,7 +392,8 @@ static int isolate_single_pageblock(unsi
 			if (PageHuge(page) || PageLRU(page) || __PageMovable(page)) {
 				int order;
 				unsigned long outer_pfn;
-				int ret;
+				int page_mt = get_pageblock_migratetype(page);
+				bool isolate_page = !is_migrate_isolate_page(page);
 				struct compact_control cc = {
 					.nr_migratepages = 0,
 					.order = -1,
@@ -399,9 +406,31 @@ static int isolate_single_pageblock(unsi
 				};
 				INIT_LIST_HEAD(&cc.migratepages);
 
+				/*
+				 * XXX: mark the page as MIGRATE_ISOLATE so that
+				 * no one else can grab the freed page after migration.
+				 * Ideally, the page should be freed as two separate
+				 * pages to be added into separate migratetype free
+				 * lists.
+				 */
+				if (isolate_page) {
+					ret = set_migratetype_isolate(page, page_mt,
+						flags, head_pfn, head_pfn + nr_pages);
+					if (ret)
+						goto failed;
+				}
+
 				ret = __alloc_contig_migrate_range(&cc, head_pfn,
 							head_pfn + nr_pages);
 
+				/*
+				 * restore the page's migratetype so that it can
+				 * be split into separate migratetype free lists
+				 * later.
+				 */
+				if (isolate_page)
+					unset_migratetype_isolate(page, page_mt);
+
 				if (ret)
 					goto failed;
 				/*
@@ -417,10 +446,9 @@ static int isolate_single_pageblock(unsi
 				order = 0;
 				outer_pfn = pfn;
 				while (!PageBuddy(pfn_to_page(outer_pfn))) {
-					if (++order >= MAX_ORDER) {
-						outer_pfn = pfn;
-						break;
-					}
+					/* stop if we cannot find the free page */
+					if (++order >= MAX_ORDER)
+						goto failed;
 					outer_pfn &= ~0UL << order;
 				}
 				pfn = outer_pfn;
@@ -435,7 +463,7 @@ static int isolate_single_pageblock(unsi
 	return 0;
 failed:
 	/* restore the original migratetype */
-	set_pageblock_migratetype(pfn_to_page(isolate_pageblock), saved_mt);
+	unset_migratetype_isolate(pfn_to_page(isolate_pageblock), saved_mt);
 	return -EBUSY;
 }
 
@@ -496,12 +524,12 @@ int start_isolate_page_range(unsigned lo
 	int ret;
 
 	/* isolate [isolate_start, isolate_start + pageblock_nr_pages) pageblock */
-	ret = isolate_single_pageblock(isolate_start, gfp_flags, false);
+	ret = isolate_single_pageblock(isolate_start, flags, gfp_flags, false);
 	if (ret)
 		return ret;
 
 	/* isolate [isolate_end - pageblock_nr_pages, isolate_end) pageblock */
-	ret = isolate_single_pageblock(isolate_end, gfp_flags, true);
+	ret = isolate_single_pageblock(isolate_end, flags, gfp_flags, true);
 	if (ret) {
 		unset_migratetype_isolate(pfn_to_page(isolate_start), migratetype);
 		return ret;
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-fix-a-potential-infinite-loop-in-start_isolate_page_range.patch

