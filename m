Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6F0DC433DB
	for <mm-commits@archiver.kernel.org>; Mon,  8 Feb 2021 21:06:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73EE864E56
	for <mm-commits@archiver.kernel.org>; Mon,  8 Feb 2021 21:06:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbhBHVGS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Feb 2021 16:06:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:59758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234677AbhBHVGE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Feb 2021 16:06:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04A2D60230;
        Mon,  8 Feb 2021 21:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612818324;
        bh=pukLus9JYDRfhMH2FIlLFKdYiuBJctIfGPRSjx6NipI=;
        h=Date:From:To:Subject:From;
        b=yX3ZlU0HcB1tHG53Lo+GCodFzYR2De4nvd5N0Ylp60nHQt1i6qgA1glgYFje3QCwa
         h4zFA01K+Csnhb4z3q4R9xYhLMWm7kPKmcj1aF0JPE6qxTi8oln1wp0zT3YmyVfFmB
         WevDwlLOdS8oB3ZecSL1O0ZWwVS/89PBLf0dSLO0=
Date:   Mon, 08 Feb 2021 13:05:23 -0800
From:   akpm@linux-foundation.org
To:     georgi.djakov@linaro.org, minchan@kernel.org,
        mm-commits@vger.kernel.org, pdaly@codeaurora.org
Subject:  + mm-cma-print-region-name-on-failure.patch added to -mm
 tree
Message-ID: <20210208210523.bWPUB054J%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: print region name on failure
has been added to the -mm tree.  Its filename is
     mm-cma-print-region-name-on-failure.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-cma-print-region-name-on-failure.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-print-region-name-on-failure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Patrick Daly <pdaly@codeaurora.org>
Subject: mm: cma: print region name on failure

Print the name of the cma region for convienience.  This is useful
information to have when cma_alloc() fails.

Link: https://lkml.kernel.org/r/20210208115200.20286-1-georgi.djakov@linaro.org
Signed-off-by: Patrick Daly <pdaly@codeaurora.org>
Signed-off-by: Georgi Djakov <georgi.djakov@linaro.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/cma.c~mm-cma-print-region-name-on-failure
+++ a/mm/cma.c
@@ -500,8 +500,8 @@ struct page *cma_alloc(struct cma *cma,
 	}
 
 	if (ret && !no_warn) {
-		pr_err("%s: alloc failed, req-size: %zu pages, ret: %d\n",
-			__func__, count, ret);
+		pr_err("%s: %s: alloc failed, req-size: %zu pages, ret: %d\n",
+		       __func__, cma->name, cma->count, ret);
 		cma_debug_show_areas(cma);
 	}
 
_

Patches currently in -mm which might be from pdaly@codeaurora.org are

mm-cma-print-region-name-on-failure.patch

