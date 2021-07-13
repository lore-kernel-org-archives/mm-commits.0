Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42158C07E95
	for <mm-commits@archiver.kernel.org>; Tue, 13 Jul 2021 23:15:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1841961363
	for <mm-commits@archiver.kernel.org>; Tue, 13 Jul 2021 23:15:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236666AbhGMXSp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Jul 2021 19:18:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:53654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235417AbhGMXSp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Jul 2021 19:18:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F9C461361;
        Tue, 13 Jul 2021 23:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626218154;
        bh=yPegGxBp2AFPXH+ONpMFoYlj0H468kfx9mYyz9Mwoqo=;
        h=Date:From:To:Subject:From;
        b=DqeyZPF6N5aOFh+j3sdy9yKtsvHR8DeWZmYXMav0FfKVdTwFA356+VcymoQKhM3Nh
         zxAuoFAtdd2da1TiZkGCtd+jbrMzdVT8ptDrFsp4/CqZDOhAnh4BOLBzESeNfST6jZ
         jMCn0V+qXnjJrvmKG+66qjeuuL/ciFgE7XAyFU5Q=
Date:   Tue, 13 Jul 2021 16:15:53 -0700
From:   akpm@linux-foundation.org
To:     mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        yanfei.xu@windriver.com
Subject:  +
 mm-page_alloc-correct-return-value-when-failing-at-preparing.patch added to
 -mm tree
Message-ID: <20210713231553.PKhfKxEUK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: correct return value when failing at preparing
has been added to the -mm tree.  Its filename is
     mm-page_alloc-correct-return-value-when-failing-at-preparing.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-correct-return-value-when-failing-at-preparing.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-correct-return-value-when-failing-at-preparing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from yanfei.xu@windriver.com are

mm-page_alloc-correct-return-value-when-failing-at-preparing.patch

