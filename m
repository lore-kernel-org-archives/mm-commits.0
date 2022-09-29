Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A437EC04A95
	for <mm-commits@archiver.kernel.org>; Thu, 29 Sep 2022 04:08:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234023AbiI2EIM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Sep 2022 00:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232007AbiI2EIL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Sep 2022 00:08:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8B012757D
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 21:08:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B29B7B821DA
        for <mm-commits@vger.kernel.org>; Thu, 29 Sep 2022 04:08:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33543C433D7;
        Thu, 29 Sep 2022 04:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664424487;
        bh=E8tj0e/mFNcKYVgEvJZyzarOtxsL5SmCqfloA0tJjQM=;
        h=Date:To:From:Subject:From;
        b=HhKciLI/+aSTJqOX5HVPGGk6f6QfJh3JSvqIt7mGzR7qpmpkx92ENtgRgkpc/WtS8
         6Q1XA/OV9REusUtpw/nmcE+RJqeR1nnJtftTEAY1iDTMj8LHuibdlZ2Xz/I7IoLk0x
         sTleXqk+S8KBreqsHyXoqX/7XtllCbDJLIjPTwOU=
Date:   Wed, 28 Sep 2022 21:08:06 -0700
To:     mm-commits@vger.kernel.org, xhao@linux.alibaba.com, sj@kernel.org,
        yangyingliang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-damon-simplify-scheme-create-in-lru_sortc-fix.patch removed from -mm tree
Message-Id: <20220929040807.33543C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon: change damon_lru_sort_stub_pattern to static
has been removed from the -mm tree.  Its filename was
     mm-damon-simplify-scheme-create-in-lru_sortc-fix.patch

This patch was dropped because it was folded into mm-damon-simplify-scheme-create-in-lru_sortc.patch

------------------------------------------------------
From: Yang Yingliang <yangyingliang@huawei.com>
Subject: mm/damon: change damon_lru_sort_stub_pattern to static
Date: Sat, 17 Sep 2022 20:12:28 +0800

damon_lru_sort_stub_pattern is only used in lru_sort.c now, change it to
static.

Link: https://lkml.kernel.org/r/20220917121228.1889699-1-yangyingliang@huawei.com
Fixes: 27812ec2a990 ("mm/damon: simplify scheme create in lru_sort.c")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Xin Hao <xhao@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/lru_sort.c~mm-damon-simplify-scheme-create-in-lru_sortc-fix
+++ a/mm/damon/lru_sort.c
@@ -132,7 +132,7 @@ DEFINE_DAMON_MODULES_DAMOS_STATS_PARAMS(
 		lru_sort_tried_cold_regions, lru_sorted_cold_regions,
 		cold_quota_exceeds);
 
-struct damos_access_pattern damon_lru_sort_stub_pattern = {
+static struct damos_access_pattern damon_lru_sort_stub_pattern = {
 	/* Find regions having PAGE_SIZE or larger size */
 	.min_sz_region = PAGE_SIZE,
 	.max_sz_region = ULONG_MAX,
_

Patches currently in -mm which might be from yangyingliang@huawei.com are

mm-damon-simplify-scheme-create-in-lru_sortc.patch
mm-damon-reclaim-change-damon_reclaim_wmarks-to-static.patch
mm-damon-lru_sort-change-damon_lru_sort_wmarks-to-static.patch

