Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67A7FC433E0
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:42:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3093764F27
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:42:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbhBZAmM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 19:42:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:59844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229954AbhBZAmL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 19:42:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56E0260202;
        Fri, 26 Feb 2021 00:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614300090;
        bh=9iptAuhMv01a6X8UcWrkiZG89ur/ynQn0k0q2f24/cU=;
        h=Date:From:To:Subject:From;
        b=a91pqR1gJvfm7jDV0HUOBVcSrHuT2yAQ1VMxaeSCllirEgdAlTepCttmlJrFu4pK8
         R24u1JUsdtpHdKIaVwAJYNzUYdLbfYskhVNEepI4v9KnoPwY76e09V507QnpsqOxtF
         Ok29DcLs06FI5d8JpCLVuSm1z0UKnYJPly1t0TVM=
Date:   Thu, 25 Feb 2021 16:41:29 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, georgi.djakov@linaro.org, minchan@kernel.org,
        mm-commits@vger.kernel.org, pdaly@codeaurora.org,
        rdunlap@infradead.org
Subject:  [folded-merged]
 mm-cma-print-region-name-on-failure-v2.patch removed from -mm tree
Message-ID: <20210226004129.AB_P2wcP3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-cma-print-region-name-on-failure-v2
has been removed from the -mm tree.  Its filename was
     mm-cma-print-region-name-on-failure-v2.patch

This patch was dropped because it was folded into mm-cma-print-region-name-on-failure.patch

------------------------------------------------------
From: Patrick Daly <pdaly@codeaurora.org>
Subject: mm-cma-print-region-name-on-failure-v2

print the "count" variable, as it was originally in the code, per Randy

Link: https://lkml.kernel.org/r/20210209142414.12768-1-georgi.djakov@linaro.org
Signed-off-by: Patrick Daly <pdaly@codeaurora.org>
Signed-off-by: Georgi Djakov <georgi.djakov@linaro.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/cma.c~mm-cma-print-region-name-on-failure-v2
+++ a/mm/cma.c
@@ -501,7 +501,7 @@ struct page *cma_alloc(struct cma *cma,
 
 	if (ret && !no_warn) {
 		pr_err("%s: %s: alloc failed, req-size: %zu pages, ret: %d\n",
-		       __func__, cma->name, cma->count, ret);
+		       __func__, cma->name, count, ret);
 		cma_debug_show_areas(cma);
 	}
 
_

Patches currently in -mm which might be from pdaly@codeaurora.org are

mm-cma-print-region-name-on-failure.patch

