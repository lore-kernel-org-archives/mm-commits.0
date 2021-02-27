Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F432C4332B
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:29:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAB7564F40
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:29:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbhB0C3u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:29:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:51008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230045AbhB0C3o (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:29:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8476364F31;
        Sat, 27 Feb 2021 02:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614392944;
        bh=sAuPZL3qkKYocZrVfo5Jh5KY6oP1/ZZMlPDzZEi7KWE=;
        h=Date:From:To:Subject:From;
        b=I1jrFXaI9g9fmwPofoA5s8ibAmhDC3zk1WWuYcyviWOsueUNClCQwSZV1hAWZwv1z
         awTh+zmvY1GDbhY4RLqUCiFSHlHqbXjyo3nT+8dacrIpCxsR46KGlm0KajkYNaxEYI
         cjjOWWavcqKNdFZBfdyZpn0GABr5ywgNrnHqcT0k=
Date:   Fri, 26 Feb 2021 18:29:04 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, georgi.djakov@linaro.org, minchan@kernel.org,
        mm-commits@vger.kernel.org, pdaly@codeaurora.org,
        rdunlap@infradead.org
Subject:  [merged] mm-cma-print-region-name-on-failure.patch
 removed from -mm tree
Message-ID: <20210227022904.2zynDhapc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: print region name on failure
has been removed from the -mm tree.  Its filename was
     mm-cma-print-region-name-on-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from pdaly@codeaurora.org are


