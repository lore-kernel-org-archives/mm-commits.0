Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C49EC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:29:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377903AbiATV3L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377902AbiATV3L (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:29:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1E0C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:29:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCFE0B81E54
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85BDFC340E3;
        Thu, 20 Jan 2022 21:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714148;
        bh=TCHeE6tgwGc1eu+Bo4+z7i+ZGK3qxUQzhpuX11m6FvI=;
        h=Date:From:To:Subject:From;
        b=yLvq2RWXCXdXLAG8ib06cgeg6bsDcgjsjnECb+BNE5J0aYs0Ona/u60YGJJ9YEM05
         W02nRRx4jfT2Gp203POiSlwj6uns9El4QCtn8t+I3t5LQ4MyKN29v1w1w1xq75+gUg
         jkHNKOUZknfN/iJAijtOs/vHssrUhCHObnqFFTz0=
Date:   Thu, 20 Jan 2022 13:29:08 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org
Subject:  [merged]
 =?US-ASCII?Q?mm-damon-vaddr-use-pr=5Fdebug-for-damon=5Fva=5Fthree=5Fregio?=
 =?US-ASCII?Q?ns-failure-logging.patch?= removed from -mm tree
Message-ID: <20220120212908.spyMrzg3u%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/vaddr: use pr_debug() for damon_va_three_regions() failure logging
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-use-pr_debug-for-damon_va_three_regions-failure-logging.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/vaddr: use pr_debug() for damon_va_three_regions() failure logging

Failure of 'damon_va_three_regions()' is logged using 'pr_err()'.  But,
the function can fail in legal situations.  To avoid making users be
surprised and to keep the kernel clean, this commit makes the log to be
printed using 'pr_debug()'.

Link: https://lkml.kernel.org/r/20211229131016.23641-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-use-pr_debug-for-damon_va_three_regions-failure-logging
+++ a/mm/damon/vaddr.c
@@ -238,7 +238,7 @@ static void __damon_va_init_regions(stru
 	int i;
 
 	if (damon_va_three_regions(t, regions)) {
-		pr_err("Failed to get three regions of target %lu\n", t->id);
+		pr_debug("Failed to get three regions of target %lu\n", t->id);
 		return;
 	}
 
_

Patches currently in -mm which might be from sj@kernel.org are


