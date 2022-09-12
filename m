Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F3A6C54EE9
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:30:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiILD37 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiILD2x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:28:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EC027CDB
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:28:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8515261164
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:28:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCAB6C433D7;
        Mon, 12 Sep 2022 03:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953328;
        bh=CjKVzcBeKSI8ZXdCUMI8V3R+yAYemMPxeOEIjyO1GiE=;
        h=Date:To:From:Subject:From;
        b=j7kcWQYE510rb6uBFzid/eCjMZgBQMKrSav05dhpN1/9HQs819l7jnV6Hu0lSA6ah
         6+63BleqgWYGoU3i+4IwkInIPKoUZFgwCXYR3fIWehIRRNx5yBjo6db6cuXjYsslTT
         bWaxSRvSzlgNBEinwhleGVFIIU2PqRMn0xqTuYvw=
Date:   Sun, 11 Sep 2022 20:28:47 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, kaixuxia@tencent.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-simplify-the-parameter-passing-for-region-split-operation.patch removed from -mm tree
Message-Id: <20220912032847.DCAB6C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core: simplify the parameter passing for region split operation
has been removed from the -mm tree.  Its filename was
     mm-damon-core-simplify-the-parameter-passing-for-region-split-operation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kaixu Xia <kaixuxia@tencent.com>
Subject: mm/damon/core: simplify the parameter passing for region split operation
Date: Sat, 13 Aug 2022 23:19:03 +0800

The parameter 'struct damon_ctx *ctx' is unnecessary in damon region split
operation, so we can remove it.

Link: https://lkml.kernel.org/r/1660403943-29124-1-git-send-email-kaixuxia@tencent.com
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core-test.h |    6 +++---
 mm/damon/core.c      |   21 +++++++++------------
 2 files changed, 12 insertions(+), 15 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-simplify-the-parameter-passing-for-region-split-operation
+++ a/mm/damon/core.c
@@ -658,9 +658,8 @@ static void kdamond_reset_aggregated(str
 	}
 }
 
-static void damon_split_region_at(struct damon_ctx *ctx,
-		struct damon_target *t, struct damon_region *r,
-		unsigned long sz_r);
+static void damon_split_region_at(struct damon_target *t,
+				  struct damon_region *r, unsigned long sz_r);
 
 static bool __damos_valid_target(struct damon_region *r, struct damos *s)
 {
@@ -726,7 +725,7 @@ static void damon_do_apply_schemes(struc
 						continue;
 					sz = DAMON_MIN_REGION;
 				}
-				damon_split_region_at(c, t, r, sz);
+				damon_split_region_at(t, r, sz);
 				r = damon_next_region(r);
 				sz = r->ar.end - r->ar.start;
 			}
@@ -745,7 +744,7 @@ static void damon_do_apply_schemes(struc
 						DAMON_MIN_REGION);
 				if (!sz)
 					goto update_stat;
-				damon_split_region_at(c, t, r, sz);
+				damon_split_region_at(t, r, sz);
 			}
 			ktime_get_coarse_ts64(&begin);
 			sz_applied = c->ops.apply_scheme(c, t, r, s);
@@ -928,9 +927,8 @@ static void kdamond_merge_regions(struct
  * r		the region to be split
  * sz_r		size of the first sub-region that will be made
  */
-static void damon_split_region_at(struct damon_ctx *ctx,
-		struct damon_target *t, struct damon_region *r,
-		unsigned long sz_r)
+static void damon_split_region_at(struct damon_target *t,
+				  struct damon_region *r, unsigned long sz_r)
 {
 	struct damon_region *new;
 
@@ -947,8 +945,7 @@ static void damon_split_region_at(struct
 }
 
 /* Split every region in the given target into 'nr_subs' regions */
-static void damon_split_regions_of(struct damon_ctx *ctx,
-				     struct damon_target *t, int nr_subs)
+static void damon_split_regions_of(struct damon_target *t, int nr_subs)
 {
 	struct damon_region *r, *next;
 	unsigned long sz_region, sz_sub = 0;
@@ -969,7 +966,7 @@ static void damon_split_regions_of(struc
 			if (sz_sub == 0 || sz_sub >= sz_region)
 				continue;
 
-			damon_split_region_at(ctx, t, r, sz_sub);
+			damon_split_region_at(t, r, sz_sub);
 			sz_region = sz_sub;
 		}
 	}
@@ -1004,7 +1001,7 @@ static void kdamond_split_regions(struct
 		nr_subregions = 3;
 
 	damon_for_each_target(t, ctx)
-		damon_split_regions_of(ctx, t, nr_subregions);
+		damon_split_regions_of(t, nr_subregions);
 
 	last_nr_regions = nr_regions;
 }
--- a/mm/damon/core-test.h~mm-damon-core-simplify-the-parameter-passing-for-region-split-operation
+++ a/mm/damon/core-test.h
@@ -126,7 +126,7 @@ static void damon_test_split_at(struct k
 	t = damon_new_target();
 	r = damon_new_region(0, 100);
 	damon_add_region(r, t);
-	damon_split_region_at(c, t, r, 25);
+	damon_split_region_at(t, r, 25);
 	KUNIT_EXPECT_EQ(test, r->ar.start, 0ul);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 25ul);
 
@@ -219,14 +219,14 @@ static void damon_test_split_regions_of(
 	t = damon_new_target();
 	r = damon_new_region(0, 22);
 	damon_add_region(r, t);
-	damon_split_regions_of(c, t, 2);
+	damon_split_regions_of(t, 2);
 	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 2u);
 	damon_free_target(t);
 
 	t = damon_new_target();
 	r = damon_new_region(0, 220);
 	damon_add_region(r, t);
-	damon_split_regions_of(c, t, 4);
+	damon_split_regions_of(t, 4);
 	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 4u);
 	damon_free_target(t);
 	damon_destroy_ctx(c);
_

Patches currently in -mm which might be from kaixuxia@tencent.com are

mm-damon-sysfs-simplify-the-judgement-whether-kdamonds-are-busy.patch
mm-damon-core-iterate-the-regions-list-from-current-point-in-damon_set_regions.patch
mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme.patch

