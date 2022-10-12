Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1F3CC4332F
	for <mm-commits@archiver.kernel.org>; Wed, 12 Oct 2022 22:57:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiJLW54 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Oct 2022 18:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiJLW5b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2022 18:57:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D85711C27E
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 15:57:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A818061627
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 22:57:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CEC6C433D6;
        Wed, 12 Oct 2022 22:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665615447;
        bh=Inx5ciKsv0W5GO2vZoBbbA7V6GK2ScEdfV/YwGIEP08=;
        h=Date:To:From:Subject:From;
        b=j9zUW2CedR/UZ77LJd1a8c8NAlYC9vSsGyJRLKBCo7NkE+32Qu0ZGE79/VsUKAZsi
         OABbSTymeQV0Rc+YNy3t3jPt58A5qUBka5Jzi4SsOIPDlAk17G5gBUcrpqvGTH8n5l
         vnyTphyTlo0q+RBuMMapSR85D83lcMVeELyHsd1E=
Date:   Wed, 12 Oct 2022 15:57:26 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, xhao@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-use-damon_sz_region-in-appropriate-place.patch removed from -mm tree
Message-Id: <20221012225727.0CEC6C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon: use damon_sz_region() in appropriate place
has been removed from the -mm tree.  Its filename was
     mm-damon-use-damon_sz_region-in-appropriate-place.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xin Hao <xhao@linux.alibaba.com>
Subject: mm/damon: use damon_sz_region() in appropriate place
Date: Tue, 27 Sep 2022 08:19:46 +0800

In many places we can use damon_sz_region() to instead of "r->ar.end -
r->ar.start".

Link: https://lkml.kernel.org/r/20220927001946.85375-2-xhao@linux.alibaba.com
Signed-off-by: Xin Hao <xhao@linux.alibaba.com>
Suggested-by: SeongJae Park <sj@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c  |   17 ++++++++---------
 mm/damon/vaddr.c |    4 ++--
 2 files changed, 10 insertions(+), 11 deletions(-)

--- a/mm/damon/core.c~mm-damon-use-damon_sz_region-in-appropriate-place
+++ a/mm/damon/core.c
@@ -490,7 +490,7 @@ static unsigned long damon_region_sz_lim
 
 	damon_for_each_target(t, ctx) {
 		damon_for_each_region(r, t)
-			sz += r->ar.end - r->ar.start;
+			sz += damon_sz_region(r);
 	}
 
 	if (ctx->attrs.min_nr_regions)
@@ -673,7 +673,7 @@ static bool __damos_valid_target(struct
 {
 	unsigned long sz;
 
-	sz = r->ar.end - r->ar.start;
+	sz = damon_sz_region(r);
 	return s->pattern.min_sz_region <= sz &&
 		sz <= s->pattern.max_sz_region &&
 		s->pattern.min_nr_accesses <= r->nr_accesses &&
@@ -701,7 +701,7 @@ static void damon_do_apply_schemes(struc
 
 	damon_for_each_scheme(s, c) {
 		struct damos_quota *quota = &s->quota;
-		unsigned long sz = r->ar.end - r->ar.start;
+		unsigned long sz = damon_sz_region(r);
 		struct timespec64 begin, end;
 		unsigned long sz_applied = 0;
 
@@ -730,14 +730,14 @@ static void damon_do_apply_schemes(struc
 				sz = ALIGN_DOWN(quota->charge_addr_from -
 						r->ar.start, DAMON_MIN_REGION);
 				if (!sz) {
-					if (r->ar.end - r->ar.start <=
-							DAMON_MIN_REGION)
+					if (damon_sz_region(r) <=
+					    DAMON_MIN_REGION)
 						continue;
 					sz = DAMON_MIN_REGION;
 				}
 				damon_split_region_at(t, r, sz);
 				r = damon_next_region(r);
-				sz = r->ar.end - r->ar.start;
+				sz = damon_sz_region(r);
 			}
 			quota->charge_target_from = NULL;
 			quota->charge_addr_from = 0;
@@ -842,8 +842,7 @@ static void kdamond_apply_schemes(struct
 					continue;
 				score = c->ops.get_scheme_score(
 						c, t, r, s);
-				quota->histogram[score] +=
-					r->ar.end - r->ar.start;
+				quota->histogram[score] += damon_sz_region(r);
 				if (score > max_score)
 					max_score = score;
 			}
@@ -957,7 +956,7 @@ static void damon_split_regions_of(struc
 	int i;
 
 	damon_for_each_region_safe(r, next, t) {
-		sz_region = r->ar.end - r->ar.start;
+		sz_region = damon_sz_region(r);
 
 		for (i = 0; i < nr_subs - 1 &&
 				sz_region > 2 * DAMON_MIN_REGION; i++) {
--- a/mm/damon/vaddr.c~mm-damon-use-damon_sz_region-in-appropriate-place
+++ a/mm/damon/vaddr.c
@@ -72,7 +72,7 @@ static int damon_va_evenly_split_region(
 		return -EINVAL;
 
 	orig_end = r->ar.end;
-	sz_orig = r->ar.end - r->ar.start;
+	sz_orig = damon_sz_region(r);
 	sz_piece = ALIGN_DOWN(sz_orig / nr_pieces, DAMON_MIN_REGION);
 
 	if (!sz_piece)
@@ -618,7 +618,7 @@ static unsigned long damos_madvise(struc
 {
 	struct mm_struct *mm;
 	unsigned long start = PAGE_ALIGN(r->ar.start);
-	unsigned long len = PAGE_ALIGN(r->ar.end - r->ar.start);
+	unsigned long len = PAGE_ALIGN(damon_sz_region(r));
 	unsigned long applied;
 
 	mm = damon_get_mm(target);
_

Patches currently in -mm which might be from xhao@linux.alibaba.com are


