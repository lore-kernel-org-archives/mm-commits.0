Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA9C5C4321E
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:14:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiJCVON (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiJCVLj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:11:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A57752096
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C1866118C
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01ABCC433C1;
        Mon,  3 Oct 2022 21:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831254;
        bh=YwNd5ndcizMiT/rqKw17Gqea2Sus9TQEJJqvhfoMnC4=;
        h=Date:To:From:Subject:From;
        b=qsSK233rcCpyMp/bfl0IUoYkIsSCSbmcKR9U6dpYnJ9f2EtQDB1mpW+RGTp+pBSxV
         Sggf2frOvdrFHwZXrdbDA/brshDAjdB5HOHABYl6XJhIhWGe5hCXeui9bxRvvuWBLX
         dt2ZXLKCWoq9BskcjWJ1baHSyAsOHrn/r0TUWh9o=
Date:   Mon, 03 Oct 2022 14:07:33 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-reclaim-use-the-quota-params-generator-macro.patch removed from -mm tree
Message-Id: <20221003210734.01ABCC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/reclaim: use the quota params generator macro
has been removed from the -mm tree.  Its filename was
     mm-damon-reclaim-use-the-quota-params-generator-macro.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/reclaim: use the quota params generator macro
Date: Tue, 13 Sep 2022 17:44:47 +0000

This commit makes DAMON_RECLAIM to generate the module parameters for
DAMOS quotas using the generator macro to simplify the code and reduce
duplicates.

Link: https://lkml.kernel.org/r/20220913174449.50645-21-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |   64 ++++++++-----------------------------------
 1 file changed, 12 insertions(+), 52 deletions(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-use-the-quota-params-generator-macro
+++ a/mm/damon/reclaim.c
@@ -52,44 +52,17 @@ module_param(commit_inputs, bool, 0600);
 static unsigned long min_age __read_mostly = 120000000;
 module_param(min_age, ulong, 0600);
 
-/*
- * Limit of time for trying the reclamation in milliseconds.
- *
- * DAMON_RECLAIM tries to use only up to this time within a time window
- * (quota_reset_interval_ms) for trying reclamation of cold pages.  This can be
- * used for limiting CPU consumption of DAMON_RECLAIM.  If the value is zero,
- * the limit is disabled.
- *
- * 10 ms by default.
- */
-static unsigned long quota_ms __read_mostly = 10;
-module_param(quota_ms, ulong, 0600);
-
-/*
- * Limit of size of memory for the reclamation in bytes.
- *
- * DAMON_RECLAIM charges amount of memory which it tried to reclaim within a
- * time window (quota_reset_interval_ms) and makes no more than this limit is
- * tried.  This can be used for limiting consumption of CPU and IO.  If this
- * value is zero, the limit is disabled.
- *
- * 128 MiB by default.
- */
-static unsigned long quota_sz __read_mostly = 128 * 1024 * 1024;
-module_param(quota_sz, ulong, 0600);
-
-/*
- * The time/size quota charge reset interval in milliseconds.
- *
- * The charge reset interval for the quota of time (quota_ms) and size
- * (quota_sz).  That is, DAMON_RECLAIM does not try reclamation for more than
- * quota_ms milliseconds or quota_sz bytes within quota_reset_interval_ms
- * milliseconds.
- *
- * 1 second by default.
- */
-static unsigned long quota_reset_interval_ms __read_mostly = 1000;
-module_param(quota_reset_interval_ms, ulong, 0600);
+static struct damos_quota damon_reclaim_quota = {
+	/* use up to 10 ms time, reclaim up to 128 MiB per 1 sec by default */
+	.ms = 10,
+	.sz = 128 * 1024 * 1024,
+	.reset_interval = 1000,
+	/* Within the quota, page out older regions first. */
+	.weight_sz = 0,
+	.weight_nr_accesses = 0,
+	.weight_age = 1
+};
+DEFINE_DAMON_MODULES_DAMOS_QUOTAS(damon_reclaim_quota);
 
 struct damos_watermarks damon_reclaim_wmarks = {
 	.metric = DAMOS_WMARK_FREE_MEM_RATE,
@@ -157,26 +130,13 @@ static struct damos *damon_reclaim_new_s
 			damon_reclaim_mon_attrs.aggr_interval,
 		.max_age_region = UINT_MAX,
 	};
-	struct damos_quota quota = {
-		/*
-		 * Do not try reclamation for more than quota_ms milliseconds
-		 * or quota_sz bytes within quota_reset_interval_ms.
-		 */
-		.ms = quota_ms,
-		.sz = quota_sz,
-		.reset_interval = quota_reset_interval_ms,
-		/* Within the quota, page out older regions first. */
-		.weight_sz = 0,
-		.weight_nr_accesses = 0,
-		.weight_age = 1
-	};
 
 	return damon_new_scheme(
 			&pattern,
 			/* page out those, as soon as found */
 			DAMOS_PAGEOUT,
 			/* under the quota. */
-			&quota,
+			&damon_reclaim_quota,
 			/* (De)activate this according to the watermarks. */
 			&damon_reclaim_wmarks);
 }
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-initialize-damon_target-list-in-damon_new_target.patch

