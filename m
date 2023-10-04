Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E08EEE7C4FF
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:23:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233418AbjJDUXI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244998AbjJDUWb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:22:31 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCDD7C6
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:22:12 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A18C433CA;
        Wed,  4 Oct 2023 20:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450932;
        bh=DiX6toNEvF9L/CHCCIv8k4UGeagfWjTZsO9pAX2lz9Y=;
        h=Date:To:From:Subject:From;
        b=pZk3hFdEIJyjFCSNUb1FApPMJEbZGqaHs7o8BPFx6i3zlX8WyBMRM4AxHp8kQB7kp
         rfH3Lfa9aBkqCTqxsCNMFChkU7NEYwcNDiAXeqAWwTx/YFTDevqwgNedaMvPaYwQOt
         182lUkHUN/Q6QqqfiNYgzLManoxkNSOkvkSC6d4g=
Date:   Wed, 04 Oct 2023 13:22:10 -0700
To:     mm-commits@vger.kernel.org, brendanhiggins@google.com,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-skip-updating-nr_accesses_bp-for-each-aggregation-interval.patch removed from -mm tree
Message-Id: <20231004202212.16A18C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core: skip updating nr_accesses_bp for each aggregation interval
has been removed from the -mm tree.  Its filename was
     mm-damon-core-skip-updating-nr_accesses_bp-for-each-aggregation-interval.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: skip updating nr_accesses_bp for each aggregation interval
Date: Fri, 15 Sep 2023 02:52:50 +0000

damon_merge_regions_of(), which is called for each aggregation interval,
updates nr_accesses_bp to nr_accesses * 10000.  However, nr_accesses_bp is
updated for each sampling interval via damon_moving_sum() using the
aggregation interval as the moving time window.  And by the definition of
the algorithm, the value becomes same to discrete-window based sum for
each time window-aligned time.  Hence, nr_accesses_bp will be same to
nr_accesses * 10000 for each aggregation interval without explicit update.
Remove the unnecessary update of nr_accesses_bp in
damon_merge_regions_of().

Link: https://lkml.kernel.org/r/20230915025251.72816-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-skip-updating-nr_accesses_bp-for-each-aggregation-interval
+++ a/mm/damon/core.c
@@ -1141,8 +1141,6 @@ static void damon_merge_regions_of(struc
 		else
 			r->age++;
 
-		r->nr_accesses_bp = r->nr_accesses * 10000;
-
 		if (prev && prev->ar.end == r->ar.start &&
 		    abs(prev->nr_accesses - r->nr_accesses) <= thres &&
 		    damon_sz_region(prev) + damon_sz_region(r) <= sz_limit)
_

Patches currently in -mm which might be from sj@kernel.org are


