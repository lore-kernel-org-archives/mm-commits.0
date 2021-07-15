Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55D44C07E96
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 04:26:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B91461362
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 04:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236304AbhGOE3n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Jul 2021 00:29:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:36050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230076AbhGOE3m (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Jul 2021 00:29:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25B326128C;
        Thu, 15 Jul 2021 04:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626323210;
        bh=bpKWtsUkDZltYMbehZ234UWxzWR/9JVpFWoeIDvnzzA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=05hqtyZBRP1umvULGfYptw3w8YkHCrcndbDYyrx3TElVDAJbaacXqcTYXdJYIr03G
         n64UBnN0Ieb2BPSu8DvC2FrRQVS2FK+BSvpBOO6ur5quClBLNGcQEXVJS7/3bEocRO
         pFT2W378FCV+hYXEyb5bN551/RxW+b5Qin/C6aYM=
Date:   Wed, 14 Jul 2021 21:26:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, yanfei.xu@windriver.com
Subject:  [patch 06/13] mm/page_alloc: correct return value when
 failing at preparing
Message-ID: <20210715042649.CGq7mTI8y%akpm@linux-foundation.org>
In-Reply-To: <20210714212609.fad116e584ba1194981a6294@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yanfei Xu <yanfei.xu@windriver.com>
Subject: mm/page_alloc: correct return value when failing at preparing

If the array passed in is already partially populated, we should return
"nr_populated" even failing at preparing arguments stage.

Link: https://lkml.kernel.org/r/20210713152100.10381-3-mgorman@techsingularity.net
Signed-off-by: Yanfei Xu <yanfei.xu@windriver.com>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Link: https://lore.kernel.org/r/20210709102855.55058-1-yanfei.xu@windriver.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-correct-return-value-when-failing-at-preparing
+++ a/mm/page_alloc.c
@@ -5255,7 +5255,7 @@ unsigned long __alloc_pages_bulk(gfp_t g
 	gfp &= gfp_allowed_mask;
 	alloc_gfp = gfp;
 	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &alloc_gfp, &alloc_flags))
-		return 0;
+		return nr_populated;
 	gfp = alloc_gfp;
 
 	/* Find an allowed local zone that meets the low watermark. */
_
