Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66DBBC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 15 Jul 2022 00:41:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbiGOAlK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Jul 2022 20:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiGOAlJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jul 2022 20:41:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1BB5491CA
        for <mm-commits@vger.kernel.org>; Thu, 14 Jul 2022 17:41:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9401F6205B
        for <mm-commits@vger.kernel.org>; Fri, 15 Jul 2022 00:41:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A68C34114;
        Fri, 15 Jul 2022 00:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657845667;
        bh=811k43TAohXBpnDomkVNWWhQvRKK8USgx5tSmiDrNlk=;
        h=Date:To:From:Subject:From;
        b=RrytCDVSi9N0vP8i6D4zRFz0Cr34NHoiiMk+rLKHPb44gCs3o1OLcC03LhOdndSq+
         4zuM0frwJRKpUcBaYJj3fUCbv/HfihYMuCotaVndbiO4dz1xii1o/66EEeb/Hc7PAi
         zWzdo6BiyIbufUxhBH8BmCLucEXFHibRrkAIi02M=
Date:   Thu, 14 Jul 2022 17:41:06 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-lru_sort-fix-potential-memory-leak-in-damon_lru_sort_init.patch added to mm-unstable branch
Message-Id: <20220715004106.E7A68C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/lru_sort: fix potential memory leak in damon_lru_sort_init()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-lru_sort-fix-potential-memory-leak-in-damon_lru_sort_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-lru_sort-fix-potential-memory-leak-in-damon_lru_sort_init.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-damon-lru_sort-fix-potential-memory-leak-in-damon_lru_sort_init.patch

