Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69A7DC433DB
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:17:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2179464F17
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:17:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhBZBRe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:17:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:49316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229947AbhBZBRa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:17:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32D1564EFA;
        Fri, 26 Feb 2021 01:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302205;
        bh=FwFNgBg2TD9zBBEY/VN/QzuR/0eMAZ8lqzeehwdlq2I=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Ju5+mizWd4QWXGTDjnE7hWZY+Gj65Uf52loRMBCsLWI5xotZZtlPTgAzWeODRARJ2
         YcvCwNjyyWv8Ijd+yVPhmazTP0Ig5dIAgtUE65ASP6zzD7Md0Dac8ZWPpLkLJKEsHz
         ufwSIOPXY7gQZNCUV+k8DKj+I6O9Gmo7J62b+60k=
Date:   Thu, 25 Feb 2021 17:16:44 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com,
        georgi.djakov@linaro.org, linux-mm@kvack.org, minchan@kernel.org,
        mm-commits@vger.kernel.org, pdaly@codeaurora.org,
        rdunlap@infradead.org, torvalds@linux-foundation.org
Subject:  [patch 022/118] mm: cma: print region name on failure
Message-ID: <20210226011644.KJZzeyhzx%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Patrick Daly <pdaly@codeaurora.org>
Subject: mm: cma: print region name on failure

Print the name of the CMA region for convenience.  This is useful
information to have when cma_alloc() fails.

[pdaly@codeaurora.org: print the "count" variable]
  Link: https://lkml.kernel.org/r/20210209142414.12768-1-georgi.djakov@linaro.org
Link: https://lkml.kernel.org/r/20210208115200.20286-1-georgi.djakov@linaro.org
Signed-off-by: Patrick Daly <pdaly@codeaurora.org>
Signed-off-by: Georgi Djakov <georgi.djakov@linaro.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
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
+		       __func__, cma->name, count, ret);
 		cma_debug_show_areas(cma);
 	}
 
_
