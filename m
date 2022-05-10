Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 390EBC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:18:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236285AbiEJEWL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236304AbiEJEUj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D87E30F4A
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0EAA61771
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0740BC385A6;
        Tue, 10 May 2022 04:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156148;
        bh=nfRG8YDRS9x2qVsp93tBk7UbHgUUB8onZ9T725nrkeU=;
        h=Date:To:From:Subject:From;
        b=jBqCjIrI8MZh6cJkqzuAZUQstDGrmwzEQTayakwq+qkQzYPDibW59z//IXVHDTdRO
         fJZ50a/LhfWJhx/ghz5Tpd0J91YB//YKZWfKpWsqOdu8AqenKDVvXuQ+6VhIeEWP+L
         coR5lzpmVbJBn5KtFEQd05tP5k458/XK5QnQUR7M=
Date:   Mon, 09 May 2022 21:15:47 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-finish-kdamond-as-soon-as-any-callback-returns-an-error.patch removed from -mm tree
Message-Id: <20220510041548.0740BC385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core: finish kdamond as soon as any callback returns an error
has been removed from the -mm tree.  Its filename was
     mm-damon-core-finish-kdamond-as-soon-as-any-callback-returns-an-error.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: finish kdamond as soon as any callback returns an error

When 'after_sampling()' or 'after_aggregation()' DAMON callbacks return an
error, kdamond continues the remaining loop once.  It makes no much sense
to run the remaining part while something wrong already happened.  The
context might be corrupted or having invalid data.  This commit therefore
makes kdamond skips the remaining works and immediately finish in the
cases.

Link: https://lkml.kernel.org/r/20220429160606.127307-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-finish-kdamond-as-soon-as-any-callback-returns-an-error
+++ a/mm/damon/core.c
@@ -1089,8 +1089,10 @@ static int kdamond_fn(void *data)
 		if (ctx->ops.prepare_access_checks)
 			ctx->ops.prepare_access_checks(ctx);
 		if (ctx->callback.after_sampling &&
-				ctx->callback.after_sampling(ctx))
+				ctx->callback.after_sampling(ctx)) {
 			done = true;
+			continue;
+		}
 
 		kdamond_usleep(ctx->sample_interval);
 
@@ -1102,8 +1104,10 @@ static int kdamond_fn(void *data)
 					max_nr_accesses / 10,
 					sz_limit);
 			if (ctx->callback.after_aggregation &&
-					ctx->callback.after_aggregation(ctx))
+					ctx->callback.after_aggregation(ctx)) {
 				done = true;
+				continue;
+			}
 			kdamond_apply_schemes(ctx);
 			kdamond_reset_aggregated(ctx);
 			kdamond_split_regions(ctx);
_

Patches currently in -mm which might be from sj@kernel.org are


