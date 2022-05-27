Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5E96C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 27 May 2022 02:14:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233548AbiE0COx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 May 2022 22:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231421AbiE0COw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 May 2022 22:14:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB77E6FA05
        for <mm-commits@vger.kernel.org>; Thu, 26 May 2022 19:14:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4818DB82219
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 02:14:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC44FC385A9;
        Fri, 27 May 2022 02:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653617688;
        bh=56YeJM8l/w8udkoCp7tp5E7YSutA23MFdD0QC8tbUy8=;
        h=Date:To:From:Subject:From;
        b=EqKyP7BxcAD03sAu34Ufu1t0pqF19aQPV7lBYkt2BbkEhAUJVCBFQKs12avlqrff5
         dnTEtGUuv3/hL1+Rx7QwhjB/0cSOKKeK4FrNh6Xip1Mvn21eLiPIF2fIvJX8HpphaY
         ImnYRNgniZIDQ7FAkHTUGx5OkFVTVZfGkt9w+ZEY=
Date:   Thu, 26 May 2022 19:14:47 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@kernel.org,
        renzhengeek@gmail.com, quic_qiancai@quicinc.com, osalvador@suse.de,
        opendmb@gmail.com, m.szyprowski@samsung.com, michael@walle.cc,
        mgorman@techsingularity.net, david@redhat.com,
        christophe.leroy@csgroup.eu, ziy@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page-isolation-skip-isolated-pageblock-in-start_isolate_page_range.patch added to mm-unstable branch
Message-Id: <20220527021447.EC44FC385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page-isolation: skip isolated pageblock in start_isolate_page_range()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page-isolation-skip-isolated-pageblock-in-start_isolate_page_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page-isolation-skip-isolated-pageblock-in-start_isolate_page_range.patch

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
Subject: mm: page-isolation: skip isolated pageblock in start_isolate_page_range()
Date: Thu, 26 May 2022 19:15:30 -0400

start_isolate_page_range() first isolates the first and the last
pageblocks in the range and ensure pages across range boundaries are split
during isolation.  But it missed the case when the range is <= a pageblock
and the first and the last pageblocks are the same one, so the second
isolate_single_pageblock() will always fail.  To fix it, skip the
pageblock isolation in second isolate_single_pageblock().

Link: https://lkml.kernel.org/r/20220526231531.2404977-1-zi.yan@sent.com
Fixes: 88ee134320b8 ("mm: fix a potential infinite loop in start_isolate_page_range()")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
  Link: https://lore.kernel.org/linux-mm/ac65adc0-a7e4-cdfe-a0d8-757195b86293@samsung.com/
Reported-by: Michael Walle <michael@walle.cc>
Tested-by: Michael Walle <michael@walle.cc>
  Link: https://lore.kernel.org/linux-mm/8ca048ca8b547e0dd1c95387ee05c23d@walle.cc/
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@redhat.com>
Cc: Doug Berger <opendmb@gmail.com>
Cc: Eric Ren <renzhengeek@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Qian Cai <quic_qiancai@quicinc.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |   26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

--- a/mm/page_isolation.c~mm-page-isolation-skip-isolated-pageblock-in-start_isolate_page_range
+++ a/mm/page_isolation.c
@@ -300,7 +300,7 @@ __first_valid_page(unsigned long pfn, un
  * the in-use page then splitting the free page.
  */
 static int isolate_single_pageblock(unsigned long boundary_pfn, int flags,
-			gfp_t gfp_flags, bool isolate_before)
+			gfp_t gfp_flags, bool isolate_before, bool skip_isolation)
 {
 	unsigned char saved_mt;
 	unsigned long start_pfn;
@@ -327,11 +327,16 @@ static int isolate_single_pageblock(unsi
 				      zone->zone_start_pfn);
 
 	saved_mt = get_pageblock_migratetype(pfn_to_page(isolate_pageblock));
-	ret = set_migratetype_isolate(pfn_to_page(isolate_pageblock), saved_mt, flags,
-			isolate_pageblock, isolate_pageblock + pageblock_nr_pages);
 
-	if (ret)
-		return ret;
+	if (skip_isolation)
+		VM_BUG_ON(!is_migrate_isolate(saved_mt));
+	else {
+		ret = set_migratetype_isolate(pfn_to_page(isolate_pageblock), saved_mt, flags,
+				isolate_pageblock, isolate_pageblock + pageblock_nr_pages);
+
+		if (ret)
+			return ret;
+	}
 
 	/*
 	 * Bail out early when the to-be-isolated pageblock does not form
@@ -463,7 +468,8 @@ static int isolate_single_pageblock(unsi
 	return 0;
 failed:
 	/* restore the original migratetype */
-	unset_migratetype_isolate(pfn_to_page(isolate_pageblock), saved_mt);
+	if (!skip_isolation)
+		unset_migratetype_isolate(pfn_to_page(isolate_pageblock), saved_mt);
 	return -EBUSY;
 }
 
@@ -522,14 +528,18 @@ int start_isolate_page_range(unsigned lo
 	unsigned long isolate_start = ALIGN_DOWN(start_pfn, pageblock_nr_pages);
 	unsigned long isolate_end = ALIGN(end_pfn, pageblock_nr_pages);
 	int ret;
+	bool skip_isolation = false;
 
 	/* isolate [isolate_start, isolate_start + pageblock_nr_pages) pageblock */
-	ret = isolate_single_pageblock(isolate_start, flags, gfp_flags, false);
+	ret = isolate_single_pageblock(isolate_start, flags, gfp_flags, false, skip_isolation);
 	if (ret)
 		return ret;
 
+	if (isolate_start == isolate_end - pageblock_nr_pages)
+		skip_isolation = true;
+
 	/* isolate [isolate_end - pageblock_nr_pages, isolate_end) pageblock */
-	ret = isolate_single_pageblock(isolate_end, flags, gfp_flags, true);
+	ret = isolate_single_pageblock(isolate_end, flags, gfp_flags, true, skip_isolation);
 	if (ret) {
 		unset_migratetype_isolate(pfn_to_page(isolate_start), migratetype);
 		return ret;
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-page-isolation-skip-isolated-pageblock-in-start_isolate_page_range.patch
mm-split-free-page-with-properly-free-memory-accounting-and-without-race.patch

