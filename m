Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09697C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiJCVOV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbiJCVLt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:11:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D318520AF
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4849B811C4
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9059CC433D6;
        Mon,  3 Oct 2022 21:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831259;
        bh=eEmSRDM7sGgXizQB5M8jg3P5o/Y8pK4BdBCLd/piQ3M=;
        h=Date:To:From:Subject:From;
        b=VU8rbUaaao+TghYrkTWaID0YhETKvx22LuF8vNz9J2nW7l79vRbks2kcbrvwt8KNe
         yvSyhYgnxMh3F1XpwpT0aFBLxDz3nF7A5CZLLTyKDp0mu85h6fc1+JXwzRmMV0s5pX
         LzDwi18rFtNy2qxwa5/MF7SBfMztUxJs90qY/iOQ=
Date:   Mon, 03 Oct 2022 14:07:38 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, kaixuxia@tencent.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-simplify-the-kdamond-stop-mechanism-by-removing-done.patch removed from -mm tree
Message-Id: <20221003210739.9059CC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core: simplify the kdamond stop mechanism by removing 'done'
has been removed from the -mm tree.  Its filename was
     mm-damon-core-simplify-the-kdamond-stop-mechanism-by-removing-done.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kaixu Xia <kaixuxia@tencent.com>
Subject: mm/damon/core: simplify the kdamond stop mechanism by removing 'done'
Date: Tue, 13 Sep 2022 17:11:26 +0800

When the 'kdamond_wait_activation()' function or 'after_sampling()' or
'after_aggregation()' DAMON callbacks return an error, it is unnecessary
to use bool 'done' to check if kdamond should be finished.  This commit
simplifies the kdamond stop mechanism by removing 'done' and break the
while loop directly in the cases.

Link: https://lkml.kernel.org/r/1663060287-30201-4-git-send-email-kaixuxia@tencent.com
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-simplify-the-kdamond-stop-mechanism-by-removing-done
+++ a/mm/damon/core.c
@@ -1152,30 +1152,25 @@ static int kdamond_fn(void *data)
 	struct damon_region *r, *next;
 	unsigned int max_nr_accesses = 0;
 	unsigned long sz_limit = 0;
-	bool done = false;
 
 	pr_debug("kdamond (%d) starts\n", current->pid);
 
 	if (ctx->ops.init)
 		ctx->ops.init(ctx);
 	if (ctx->callback.before_start && ctx->callback.before_start(ctx))
-		done = true;
+		goto done;
 
 	sz_limit = damon_region_sz_limit(ctx);
 
-	while (!kdamond_need_stop(ctx) && !done) {
-		if (kdamond_wait_activation(ctx)) {
-			done = true;
-			continue;
-		}
+	while (!kdamond_need_stop(ctx)) {
+		if (kdamond_wait_activation(ctx))
+			break;
 
 		if (ctx->ops.prepare_access_checks)
 			ctx->ops.prepare_access_checks(ctx);
 		if (ctx->callback.after_sampling &&
-				ctx->callback.after_sampling(ctx)) {
-			done = true;
-			continue;
-		}
+				ctx->callback.after_sampling(ctx))
+			break;
 
 		kdamond_usleep(ctx->attrs.sample_interval);
 
@@ -1187,10 +1182,8 @@ static int kdamond_fn(void *data)
 					max_nr_accesses / 10,
 					sz_limit);
 			if (ctx->callback.after_aggregation &&
-					ctx->callback.after_aggregation(ctx)) {
-				done = true;
-				continue;
-			}
+					ctx->callback.after_aggregation(ctx))
+				break;
 			kdamond_apply_schemes(ctx);
 			kdamond_reset_aggregated(ctx);
 			kdamond_split_regions(ctx);
@@ -1204,6 +1197,7 @@ static int kdamond_fn(void *data)
 			sz_limit = damon_region_sz_limit(ctx);
 		}
 	}
+done:
 	damon_for_each_target(t, ctx) {
 		damon_for_each_region_safe(r, next, t)
 			damon_destroy_region(r, t);
_

Patches currently in -mm which might be from kaixuxia@tencent.com are


