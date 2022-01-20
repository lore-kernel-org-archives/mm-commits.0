Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FAC6C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:28:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377882AbiATV2Y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:28:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58908 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377888AbiATV2V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:28:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12D00B81E6A
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:28:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BC59C340E0;
        Thu, 20 Jan 2022 21:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714098;
        bh=+e2oNa6OnDOCvGH9GcwxmuF03dX3E0uA1dLbfoqlnWA=;
        h=Date:From:To:Subject:From;
        b=OOqhsm89O54LzFubqTGboEqyUuLWBpiJXypAVEgVxws/RGPNF9Yr4+manmE8m6bFx
         NZvn6N8OsTr9Lf8YtSi3xDuPdRQzFSXTcB1S0RUN//oZ2RlTm9r6h7guRZczxTuJ1Y
         lEKOEIjgstlelyjbG6WuSK7Dakp2cJzUNsMHbHuI=
Date:   Thu, 20 Jan 2022 13:28:18 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        songmuchun@bytedance.com, xhao@linux.alibaba.com
Subject:  [merged]
 mm-damon-core-using-function-abs-instead-of-diff_of.patch removed from -mm
 tree
Message-ID: <20220120212818.tcDghPHzx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: use abs() instead of diff_of()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-using-function-abs-instead-of-diff_of.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xin Hao <xhao@linux.alibaba.com>
Subject: mm/damon/core: use abs() instead of diff_of()

In kernel, we can use abs(a - b) to get the absolute value, So there is no
need to redefine a new one.

Link: https://lkml.kernel.org/r/b24e7b82d9efa90daf150d62dea171e19390ad0b.1636989871.git.xhao@linux.alibaba.com
Signed-off-by: Xin Hao <xhao@linux.alibaba.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-using-function-abs-instead-of-diff_of
+++ a/mm/damon/core.c
@@ -750,8 +750,6 @@ static void damon_merge_two_regions(stru
 	damon_destroy_region(r, t);
 }
 
-#define diff_of(a, b) (a > b ? a - b : b - a)
-
 /*
  * Merge adjacent regions having similar access frequencies
  *
@@ -765,13 +763,13 @@ static void damon_merge_regions_of(struc
 	struct damon_region *r, *prev = NULL, *next;
 
 	damon_for_each_region_safe(r, next, t) {
-		if (diff_of(r->nr_accesses, r->last_nr_accesses) > thres)
+		if (abs(r->nr_accesses - r->last_nr_accesses) > thres)
 			r->age = 0;
 		else
 			r->age++;
 
 		if (prev && prev->ar.end == r->ar.start &&
-		    diff_of(prev->nr_accesses, r->nr_accesses) <= thres &&
+		    abs(prev->nr_accesses - r->nr_accesses) <= thres &&
 		    sz_damon_region(prev) + sz_damon_region(r) <= sz_limit)
 			damon_merge_two_regions(t, prev, r);
 		else
_

Patches currently in -mm which might be from xhao@linux.alibaba.com are


