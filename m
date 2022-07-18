Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFE20C43334
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:16:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbiGRAQZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiGRAQZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:16:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4178795B3
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:16:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E22B5B80E27
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:16:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8548BC3411E;
        Mon, 18 Jul 2022 00:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103381;
        bh=Gt4aDyNucNDSJIXnBkC1cG1oEosuznz2MzHM6qKqgGs=;
        h=Date:To:From:Subject:From;
        b=qBWduGd7IxXh7MA13BWq7SEAMXlgbJaGUNBzIu1Ie9/yM+C1f0zU12xoWrzL81TKi
         1JMO8kA/fZVrLW4ACLSIWsfdWHv8kyfQ9RRKOla32boI0COhqQGYz6Esk9iR4DYFz8
         bpwAP9yfNseyjuc/78IyK2IAgGArCtpcbaB7+Kcw=
Date:   Sun, 17 Jul 2022 17:16:20 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-lru_sort-fix-potential-memory-leak-in-damon_lru_sort_init.patch removed from -mm tree
Message-Id: <20220718001621.8548BC3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/lru_sort: fix potential memory leak in damon_lru_sort_init()
has been removed from the -mm tree.  Its filename was
     mm-damon-lru_sort-fix-potential-memory-leak-in-damon_lru_sort_init.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/lru_sort: fix potential memory leak in damon_lru_sort_init()
Date: Thu, 14 Jul 2022 17:04:58 +0000

damon_lru_sort_init() returns an error when damon_select_ops() fails
without freeing 'ctx' which allocated before.  This commit fixes the
potential memory leak by freeing 'ctx' under the situation.

Link: https://lkml.kernel.org/r/20220714170458.49727-1-sj@kernel.org
Fixes: 40e983cca927 ("mm/damon: introduce DAMON-based LRU-lists Sorting")
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-fix-potential-memory-leak-in-damon_lru_sort_init
+++ a/mm/damon/lru_sort.c
@@ -524,8 +524,10 @@ static int __init damon_lru_sort_init(vo
 	if (!ctx)
 		return -ENOMEM;
 
-	if (damon_select_ops(ctx, DAMON_OPS_PADDR))
+	if (damon_select_ops(ctx, DAMON_OPS_PADDR)) {
+		damon_destroy_ctx(ctx);
 		return -EINVAL;
+	}
 
 	ctx->callback.after_wmarks_check = damon_lru_sort_after_wmarks_check;
 	ctx->callback.after_aggregation = damon_lru_sort_after_aggregation;
_

Patches currently in -mm which might be from sj@kernel.org are


