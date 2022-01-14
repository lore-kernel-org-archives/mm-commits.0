Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 085EFC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:09:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbiANWJp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:09:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiANWJp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:09:45 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05BA1C061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:09:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 55D66CE2497
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:09:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727F3C36AE5;
        Fri, 14 Jan 2022 22:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198181;
        bh=2A3XM+2UG12YFp8tc/9YQ+vPnJHFwu+rf8Z18zCW6+8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZddWNWtWUwf4PmALBRLCaJPGzEix6KczzKBT0xjCL8R14380kArlTHoA6ctPf9osx
         OnDBDGfMaZDYh/aXrRAhbxj1AdxVWckhP6K7Lxr0lWKUNd0N9MkQCvFZTMSXm+1uYw
         y9UUlOvgATrhVCcMN2G0iMMsPcE+oQOkoq2iPPOw=
Date:   Fri, 14 Jan 2022 14:09:40 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sj@kernel.org,
        songmuchun@bytedance.com, torvalds@linux-foundation.org,
        xhao@linux.alibaba.com
Subject:  [patch 123/146] mm/damon/core: use abs() instead of
 diff_of()
Message-ID: <20220114220940.B19d9XhL-%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
