Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61AB2C43217
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:13:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbiJCVNH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiJCVLi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:11:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33545208B
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5122E6118C
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A090C433D7;
        Mon,  3 Oct 2022 21:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831249;
        bh=Q3xuKNLbcZlLoevXIWn71dLG142Xpul+YunyqK/KGZo=;
        h=Date:To:From:Subject:From;
        b=gk7H4FjGFSygDQvSgYIrGtJB8WyQzQlKHSJtrS0RKP3X7MhxoelxfjJrfwuhd6Ebb
         +lfi2DE6sshATeaJiFIXjYPF4xvOcZ1QNaMrA7hwqnaLJDe9DX4P3kkvP0dGsgtuYu
         +u+pobjVxOS1qzjWtAVURcGIWddRLimVsMQc6GiY=
Date:   Mon, 03 Oct 2022 14:07:28 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-reclaim-use-stat-parameters-generator.patch removed from -mm tree
Message-Id: <20221003210729.9A090C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/reclaim: use stat parameters generator
has been removed from the -mm tree.  Its filename was
     mm-damon-reclaim-use-stat-parameters-generator.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/reclaim: use stat parameters generator
Date: Tue, 13 Sep 2022 17:44:43 +0000

This commit makes DAMON_RECLAIM to generate the module parameters for
DAMOS statistics using the generator macro to simplify the code and
reduce duplicates.

Link: https://lkml.kernel.org/r/20220913174449.50645-17-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |   41 +++++------------------------------------
 1 file changed, 5 insertions(+), 36 deletions(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-use-stat-parameters-generator
+++ a/mm/damon/reclaim.c
@@ -136,35 +136,9 @@ module_param(monitor_region_end, ulong,
 static int kdamond_pid __read_mostly = -1;
 module_param(kdamond_pid, int, 0400);
 
-/*
- * Number of memory regions that tried to be reclaimed.
- */
-static unsigned long nr_reclaim_tried_regions __read_mostly;
-module_param(nr_reclaim_tried_regions, ulong, 0400);
-
-/*
- * Total bytes of memory regions that tried to be reclaimed.
- */
-static unsigned long bytes_reclaim_tried_regions __read_mostly;
-module_param(bytes_reclaim_tried_regions, ulong, 0400);
-
-/*
- * Number of memory regions that successfully be reclaimed.
- */
-static unsigned long nr_reclaimed_regions __read_mostly;
-module_param(nr_reclaimed_regions, ulong, 0400);
-
-/*
- * Total bytes of memory regions that successfully be reclaimed.
- */
-static unsigned long bytes_reclaimed_regions __read_mostly;
-module_param(bytes_reclaimed_regions, ulong, 0400);
-
-/*
- * Number of times that the time/space quota limits have exceeded
- */
-static unsigned long nr_quota_exceeds __read_mostly;
-module_param(nr_quota_exceeds, ulong, 0400);
+static struct damos_stat damon_reclaim_stat;
+DEFINE_DAMON_MODULES_DAMOS_STATS_PARAMS(damon_reclaim_stat,
+		reclaim_tried_regions, reclaimed_regions, quota_exceeds);
 
 static struct damon_ctx *ctx;
 static struct damon_target *target;
@@ -318,13 +292,8 @@ static int damon_reclaim_after_aggregati
 	struct damos *s;
 
 	/* update the stats parameter */
-	damon_for_each_scheme(s, c) {
-		nr_reclaim_tried_regions = s->stat.nr_tried;
-		bytes_reclaim_tried_regions = s->stat.sz_tried;
-		nr_reclaimed_regions = s->stat.nr_applied;
-		bytes_reclaimed_regions = s->stat.sz_applied;
-		nr_quota_exceeds = s->stat.qt_exceeds;
-	}
+	damon_for_each_scheme(s, c)
+		damon_reclaim_stat = s->stat;
 
 	return damon_reclaim_handle_commit_inputs();
 }
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-initialize-damon_target-list-in-damon_new_target.patch

