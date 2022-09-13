Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB626C54EE9
	for <mm-commits@archiver.kernel.org>; Tue, 13 Sep 2022 22:15:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiIMWPB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Sep 2022 18:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiIMWO6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Sep 2022 18:14:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B592FBE14
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 15:14:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33B6CB810EA
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 22:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCFC5C433C1;
        Tue, 13 Sep 2022 22:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663107293;
        bh=u7FftbL1hgwa/Zn9cXiYl13WJHWOA1EjY1xn1hvTLhU=;
        h=Date:To:From:Subject:From;
        b=lctdOofgtJRh7X/g6ZZ+uypEuV8dhmapkw9gj+ZJ7LowwUhs53OJrvZFpj6dC3TWV
         AD0ahzTOYs399coFAEG+M8YANcnMxkPZCDlaLrQfpUyIqZCRgfhlizTPir4D+AlNjX
         uAX5hpW9qjJUVYkdtKuGosXCU4iNcx94KVfP6jRU=
Date:   Tue, 13 Sep 2022 15:14:52 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, kaixuxia@tencent.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-simplify-the-kdamond-stop-mechanism-by-removing-done.patch added to mm-unstable branch
Message-Id: <20220913221452.DCFC5C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: simplify the kdamond stop mechanism by removing 'done'
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-simplify-the-kdamond-stop-mechanism-by-removing-done.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-simplify-the-kdamond-stop-mechanism-by-removing-done.patch

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

mm-damon-sysfs-simplify-the-judgement-whether-kdamonds-are-busy.patch
mm-damon-core-iterate-the-regions-list-from-current-point-in-damon_set_regions.patch
mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme.patch
mm-damon-sysfs-use-the-wrapper-directly-to-check-if-the-kdamond-is-running.patch
mm-damon-simplify-the-parameter-passing-for-prepare_access_checks.patch
mm-damon-sysfs-simplify-the-variable-pid-assignment-operation.patch
mm-damon-core-simplify-the-kdamond-stop-mechanism-by-removing-done.patch
mm-damon-vaddr-indicate-the-target-is-invalid-when-nr_regions-is-zero.patch

