Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ADEAC43217
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:15:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbiJCVPZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbiJCVN4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:13:56 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 056FD5467C
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:09:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 66DA8CE0E70
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:09:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96D9C433D6;
        Mon,  3 Oct 2022 21:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831358;
        bh=H+JdrPq6jXUroHzsGzMrWdwbNnIypSX3sOOi9erMH+w=;
        h=Date:To:From:Subject:From;
        b=QDmuTcHA6Tp4/yE0+wKiTnkgID+aXCejyvGqCW3potFDGQ3rLx2WKttLWhXWaPyFE
         xc4YHxowwBzk0i6ib8useiPTipew1GnSxDuf3C1RDmmTLOeopgK2Ybhq3u/hvwjMmL
         wpetm56kKbz0FrV125uxw6Cio3wzRrPsae+I4rT0=
Date:   Mon, 03 Oct 2022 14:09:17 -0700
To:     mm-commits@vger.kernel.org, yangyingliang@huawei.com,
        sj@kernel.org, xhao@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-simplify-scheme-create-in-lru_sortc.patch removed from -mm tree
Message-Id: <20221003210918.A96D9C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon: simplify scheme create in lru_sort.c
has been removed from the -mm tree.  Its filename was
     mm-damon-simplify-scheme-create-in-lru_sortc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xin Hao <xhao@linux.alibaba.com>
Subject: mm/damon: simplify scheme create in lru_sort.c
Date: Thu, 15 Sep 2022 13:30:41 +0000

In damon_lru_sort_new_hot_scheme() and damon_lru_sort_new_cold_scheme(),
they have so much in common, so we can combine them into a single
function, and we just need to distinguish their differences.

[yangyingliang@huawei.com: change damon_lru_sort_stub_pattern to static]
  Link: https://lkml.kernel.org/r/20220917121228.1889699-1-yangyingliang@huawei.com
Link: https://lkml.kernel.org/r/20220915133041.71819-1-sj@kernel.org
Signed-off-by: Xin Hao <xhao@linux.alibaba.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
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
 
+static struct damos_access_pattern damon_lru_sort_stub_pattern = {
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

mm-damon-move-sz_damon_region-to-damon_sz_region.patch
mm-damon-use-damon_sz_region-in-appropriate-place.patch

