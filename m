Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77773ECAAA1
	for <mm-commits@archiver.kernel.org>; Thu, 15 Sep 2022 21:26:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiIOV0P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Sep 2022 17:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiIOV0O (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Sep 2022 17:26:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE8CB32076
        for <mm-commits@vger.kernel.org>; Thu, 15 Sep 2022 14:26:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5937862699
        for <mm-commits@vger.kernel.org>; Thu, 15 Sep 2022 21:26:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B2CC433D6;
        Thu, 15 Sep 2022 21:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663277171;
        bh=IdNN1N3+56Nh/rh95S8zKzZK8DT5pqGIuH96chmHm1I=;
        h=Date:To:From:Subject:From;
        b=ZX9llS5NCp4DCcZ1RkX4BpcElstn2SAYV1s+AhpnAUXf3Xa+V0ihWnL5b639xQJSb
         6Mx5tbVo38OMsmc23myZCFAA43ilXRNiTSPvRgrOQ7/FodULMc+4daT5OUCvTlpQXD
         WlyHhWh5fgD12xjNMapvyWC3IudAT+2y/S+pyc20=
Date:   Thu, 15 Sep 2022 14:26:11 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, xhao@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-simplify-scheme-create-in-lru_sortc.patch added to mm-unstable branch
Message-Id: <20220915212611.B4B2CC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: simplify scheme create in lru_sort.c
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-simplify-scheme-create-in-lru_sortc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-simplify-scheme-create-in-lru_sortc.patch

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
From: Xin Hao <xhao@linux.alibaba.com>
Subject: mm/damon: simplify scheme create in lru_sort.c
Date: Thu, 15 Sep 2022 13:30:41 +0000

In damon_lru_sort_new_hot_scheme() and damon_lru_sort_new_cold_scheme(),
they have so much in common, so we can combine them into a single
function, and we just need to distinguish their differences.

Link: https://lkml.kernel.org/r/20220915133041.71819-1-sj@kernel.org
Signed-off-by: Xin Hao <xhao@linux.alibaba.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Suggested-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Xin Hao <xhao@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |   39 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

--- a/mm/damon/lru_sort.c~mm-damon-simplify-scheme-create-in-lru_sortc
+++ a/mm/damon/lru_sort.c
@@ -132,6 +132,18 @@ DEFINE_DAMON_MODULES_DAMOS_STATS_PARAMS(
 		lru_sort_tried_cold_regions, lru_sorted_cold_regions,
 		cold_quota_exceeds);
 
+struct damos_access_pattern damon_lru_sort_stub_pattern = {
+	/* Find regions having PAGE_SIZE or larger size */
+	.min_sz_region = PAGE_SIZE,
+	.max_sz_region = ULONG_MAX,
+	/* no matter its access frequency */
+	.min_nr_accesses = 0,
+	.max_nr_accesses = UINT_MAX,
+	/* no matter its age */
+	.min_age_region = 0,
+	.max_age_region = UINT_MAX,
+};
+
 static struct damon_ctx *ctx;
 static struct damon_target *target;
 
@@ -157,36 +169,19 @@ static struct damos *damon_lru_sort_new_
 /* Create a DAMON-based operation scheme for hot memory regions */
 static struct damos *damon_lru_sort_new_hot_scheme(unsigned int hot_thres)
 {
-	struct damos_access_pattern pattern = {
-		/* Find regions having PAGE_SIZE or larger size */
-		.min_sz_region = PAGE_SIZE,
-		.max_sz_region = ULONG_MAX,
-		/* and accessed for more than the threshold */
-		.min_nr_accesses = hot_thres,
-		.max_nr_accesses = UINT_MAX,
-		/* no matter its age */
-		.min_age_region = 0,
-		.max_age_region = UINT_MAX,
-	};
+	struct damos_access_pattern pattern = damon_lru_sort_stub_pattern;
 
+	pattern.min_nr_accesses = hot_thres;
 	return damon_lru_sort_new_scheme(&pattern, DAMOS_LRU_PRIO);
 }
 
 /* Create a DAMON-based operation scheme for cold memory regions */
 static struct damos *damon_lru_sort_new_cold_scheme(unsigned int cold_thres)
 {
-	struct damos_access_pattern pattern = {
-		/* Find regions having PAGE_SIZE or larger size */
-		.min_sz_region = PAGE_SIZE,
-		.max_sz_region = ULONG_MAX,
-		/* and not accessed at all */
-		.min_nr_accesses = 0,
-		.max_nr_accesses = 0,
-		/* for min_age or more micro-seconds */
-		.min_age_region = cold_thres,
-		.max_age_region = UINT_MAX,
-	};
+	struct damos_access_pattern pattern = damon_lru_sort_stub_pattern;
 
+	pattern.max_nr_accesses = 0;
+	pattern.min_age_region = cold_thres;
 	return damon_lru_sort_new_scheme(&pattern, DAMOS_LRU_DEPRIO);
 }
 
_

Patches currently in -mm which might be from xhao@linux.alibaba.com are

mm-damon-simply-damon_ctx-check-in-damon_sysfs_before_terminate.patch
mm-damon-remove-duplicate-get_monitoring_region-definitions.patch
mm-damon-sysfs-change-few-functions-execute-order.patch
mm-damon-simplify-scheme-create-in-damon_lru_sort_apply_parameters.patch
mm-damon-sysfs-avoid-call-damon_target_has_pid-repeatedly.patch
mm-damon-core-remove-duplicate-check-about-thp.patch
mm-damon-simplify-scheme-create-in-lru_sortc.patch

