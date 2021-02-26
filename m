Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B725BC433E9
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:17:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 748C064F17
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhBZBR3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:17:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:48970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229492AbhBZBRL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:17:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3444064EDC;
        Fri, 26 Feb 2021 01:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302190;
        bh=ggn0p2fdOJkIBElRAnGekKbMcEGELEf1UZfPWGA6FlY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=2fUmH0vMM7dL7bDbzmd2AWjXaf1xgZdGdb3HMCMYHkGzOVXZ1kJs/JWPIxuVaviOj
         cOHsXGVFGSOQdDSFZZE9PALvpyOTIkYA3SIOsSDCl1LmAtdsZkWQ1NBcxbKwifTL9Y
         wpyhzfUHEzJQtM5lcSdotbXsOlxtyP3OeuthAySE=
Date:   Thu, 25 Feb 2021 17:16:29 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org, hughd@google.com,
        linux-mm@kvack.org, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, riel@surriel.com,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org,
        xuyu@linux.alibaba.com
Subject:  [patch 018/118] mm,shmem,thp: limit shmem THP allocations
 to requested zones
Message-ID: <20210226011629.y0GUQrjp_%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Rik van Riel <riel@surriel.com>
Subject: mm,shmem,thp: limit shmem THP allocations to requested zones

Hugh pointed out that the gma500 driver uses shmem pages, but needs to
limit them to the DMA32 zone.  Ensure the allocations resulting from the
gfp_mask returned by limit_gfp_mask use the zone flags that were
originally passed to shmem_getpage_gfp.

Link: https://lkml.kernel.org/r/20210224121016.1314ed6d@imladris.surriel.com
Signed-off-by: Rik van Riel <riel@surriel.com>
Suggested-by: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xu Yu <xuyu@linux.alibaba.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/shmem.c~mmshmemthp-limit-shmem-thp-allocations-to-requested-zones
+++ a/mm/shmem.c
@@ -1513,7 +1513,11 @@ static gfp_t limit_gfp_mask(gfp_t huge_g
 {
 	gfp_t allowflags = __GFP_IO | __GFP_FS | __GFP_RECLAIM;
 	gfp_t denyflags = __GFP_NOWARN | __GFP_NORETRY;
-	gfp_t result = huge_gfp & ~allowflags;
+	gfp_t zoneflags = limit_gfp & GFP_ZONEMASK;
+	gfp_t result = huge_gfp & ~(allowflags | GFP_ZONEMASK);
+
+	/* Allow allocations only from the originally specified zones. */
+	result |= zoneflags;
 
 	/*
 	 * Minimize the result gfp by taking the union with the deny flags,
_
