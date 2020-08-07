Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7CC8C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:57:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89ED122CF7
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596779850;
	bh=d6m3V6gxJY0CGiTzB6vmRYw3CsFsARzwDsxh1QAj1uY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=cQEGY/dCNj0L9uar/wB/PnuqPIYU3uFf9c/0/N9GqvuY1GiYdUMt07AtTN2QUyolq
	 GYSLILywFkCLS7gEHqb9gycJv/CXjII5/LLPBJKrpdsbPog0qU7WSXb8BRoF+x2qH4
	 WF6QXHl30Zvc08E94BKtcZszqznz6Add2Fr4a9Yg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbgHGF5a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 01:57:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:46364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGF5a (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 01:57:30 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D14221744;
        Fri,  7 Aug 2020 05:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596779849;
        bh=d6m3V6gxJY0CGiTzB6vmRYw3CsFsARzwDsxh1QAj1uY=;
        h=Date:From:To:Subject:From;
        b=pofr+K82NA4j0VS718ErxWSIeP3s3iW2CRZGnqszufLdaIr02H/uuTOSkOj0efoPm
         y5Ny6yCWyDb1s+TsWn99TuwX7N2TvN/ooXlGGqaHy4K5QcRKMHTb2Jtl38MlmVXmfX
         Lzr59I6V6JVqmIE65ZBa+IVYuR+VPG8V8nVafx9E=
Date:   Thu, 06 Aug 2020 22:57:28 -0700
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, hannes@cmpxchg.org, jaewon31.kim@samsung.com,
        mgorman@techsingularity.net, mhocko@kernel.org, minchan@kernel.org,
        mm-commits@vger.kernel.org, vbabka@suse.cz, ytk.lee@samsung.com
Subject:  [folded-merged]
 page_alloc-consider-highatomic-reserve-in-watermark-fast-v5.patch removed
 from -mm tree
Message-ID: <20200807055728.o5_ou4_Nk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: page_alloc-consider-highatomic-reserve-in-watermark-fast-v5
has been removed from the -mm tree.  Its filename was
     page_alloc-consider-highatomic-reserve-in-watermark-fast-v5.patch

This patch was dropped because it was folded into page_alloc-consider-highatomic-reserve-in-watermark-fast.patch

------------------------------------------------------
From: Jaewon Kim <jaewon31.kim@samsung.com>
Subject: page_alloc-consider-highatomic-reserve-in-watermark-fast-v5

remove redundant code for high-order

Link: http://lkml.kernel.org/r/20200623035242.27232-1-jaewon31.kim@samsung.com
Reported-by: Yong-Taek Lee <ytk.lee@samsung.com>
Suggested-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Jaewon Kim <jaewon31.kim@samsung.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Baoquan He <bhe@redhat.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~page_alloc-consider-highatomic-reserve-in-watermark-fast-v5
+++ a/mm/page_alloc.c
@@ -3591,18 +3591,18 @@ static inline bool zone_watermark_fast(s
 				unsigned int alloc_flags)
 {
 	long free_pages;
-	long unusable_free;
 
 	free_pages = zone_page_state(z, NR_FREE_PAGES);
-	unusable_free = __zone_watermark_unusable_free(z, order, alloc_flags);
 
 	/*
 	 * Fast check for order-0 only. If this fails then the reserves
 	 * need to be calculated.
 	 */
 	if (!order) {
-		long fast_free = free_pages - unusable_free;
+		long fast_free;
 
+		fast_free = free_pages;
+		fast_free -= __zone_watermark_unusable_free(z, 0, alloc_flags);
 		if (fast_free > mark + z->lowmem_reserve[highest_zoneidx])
 			return true;
 	}
_

Patches currently in -mm which might be from jaewon31.kim@samsung.com are

page_alloc-consider-highatomic-reserve-in-watermark-fast.patch

