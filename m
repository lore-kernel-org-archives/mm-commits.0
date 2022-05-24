Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87493C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 24 May 2022 18:16:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237570AbiEXSQl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 24 May 2022 14:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiEXSQk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 May 2022 14:16:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D027221E
        for <mm-commits@vger.kernel.org>; Tue, 24 May 2022 11:16:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99956615A2
        for <mm-commits@vger.kernel.org>; Tue, 24 May 2022 18:16:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB336C34100;
        Tue, 24 May 2022 18:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653416198;
        bh=3whdgzhIRGiyZz+bJb/K2itSO8NdROgUzRmRaH8eCg8=;
        h=Date:To:From:Subject:From;
        b=h4EvBk9XYY3wullShOGdYCirR4wfYFaJ8hUs4pYc5sJs8aKjl6jtSIc54cYFRa4Ai
         /I3IsR88zmLB3RGM1VDFHIlIpCVDj5KW4nSs0aXk7NH/xyE2/ZLxd6SxI8aQVSvxeV
         Sjax1My/ojMEBZSmUXit3XYpiHLBNmv+uO1DjDqw=
Date:   Tue, 24 May 2022 11:16:37 -0700
To:     mm-commits@vger.kernel.org, paulmck@kernel.org,
        jhubbard@nvidia.com, david@redhat.com, minchan@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-is_pinnable_page-against-a-cma-page.patch added to mm-unstable branch
Message-Id: <20220524181637.EB336C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix is_pinnable_page against a cma page
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-is_pinnable_page-against-a-cma-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-is_pinnable_page-against-a-cma-page.patch

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
From: Minchan Kim <minchan@kernel.org>
Subject: mm: fix is_pinnable_page against a cma page
Date: Tue, 24 May 2022 10:15:25 -0700

Pages in the CMA area could have MIGRATE_ISOLATE as well as MIGRATE_CMA so
the current is_pinnable_page() could miss CMA pages which have
MIGRATE_ISOLATE.  It ends up pinning CMA pages as longterm for the
pin_user_pages() API so CMA allocations keep failing until the pin is
released.

     CPU 0                                   CPU 1 - Task B

cma_alloc
alloc_contig_range
                                        pin_user_pages_fast(FOLL_LONGTERM)
change pageblock as MIGRATE_ISOLATE
                                        internal_get_user_pages_fast
                                        lockless_pages_from_mm
                                        gup_pte_range
                                        try_grab_folio
                                        is_pinnable_page
                                          return true;
                                        So, pinned the page successfully.
page migration failure with pinned page
                                        ..
                                        .. After 30 sec
                                        unpin_user_page(page)

CMA allocation succeeded after 30 sec.

The CMA allocation path protects the migration type change race using
zone->lock but what GUP path need to know is just whether the page is on
CMA area or not rather than exact migration type.  Thus, we don't need
zone->lock but just checks migration type in either of (MIGRATE_ISOLATE
and MIGRATE_CMA).

Adding the MIGRATE_ISOLATE check in is_pinnable_page could cause rejecting
of pinning pages on MIGRATE_ISOLATE pageblocks even though it's neither
CMA nor movable zone if the page is temporarily unmovable.  However, such
a migration failure by unexpected temporal refcount holding is general
issue, not only come from MIGRATE_ISOLATE and the MIGRATE_ISOLATE is also
transient state like other temporal elevated refcount problem.

Link: https://lkml.kernel.org/r/20220524171525.976723-1-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    9 +++++++--
 mm/page_alloc.c    |    8 ++++++--
 2 files changed, 13 insertions(+), 4 deletions(-)

--- a/include/linux/mm.h~mm-fix-is_pinnable_page-against-a-cma-page
+++ a/include/linux/mm.h
@@ -1594,8 +1594,13 @@ static inline bool page_needs_cow_for_dm
 #ifdef CONFIG_MIGRATION
 static inline bool is_pinnable_page(struct page *page)
 {
-	return !(is_zone_movable_page(page) || is_migrate_cma_page(page)) ||
-		is_zero_pfn(page_to_pfn(page));
+#ifdef CONFIG_CMA
+	int mt = get_pageblock_migratetype(page);
+
+	if (mt == MIGRATE_CMA || mt == MIGRATE_ISOLATE)
+		return false;
+#endif
+	return !(is_zone_movable_page(page) || is_zero_pfn(page_to_pfn(page)));
 }
 #else
 static inline bool is_pinnable_page(struct page *page)
--- a/mm/page_alloc.c~mm-fix-is_pinnable_page-against-a-cma-page
+++ a/mm/page_alloc.c
@@ -490,8 +490,12 @@ unsigned long __get_pfnblock_flags_mask(
 	bitidx = pfn_to_bitidx(page, pfn);
 	word_bitidx = bitidx / BITS_PER_LONG;
 	bitidx &= (BITS_PER_LONG-1);
-
-	word = bitmap[word_bitidx];
+	/*
+	 * This races, without locks, with set_pfnblock_flags_mask(). Ensure
+	 * a consistent read of the memory array, so that results, even though
+	 * racy, are not corrupted.
+	 */
+	word = READ_ONCE(bitmap[word_bitidx]);
 	return (word >> bitidx) & mask;
 }
 
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-fix-is_pinnable_page-against-a-cma-page.patch

