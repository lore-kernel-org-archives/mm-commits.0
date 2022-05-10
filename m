Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A993C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:19:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236157AbiEJEXH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236305AbiEJEUj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0838340DF
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D41961770
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE492C385C2;
        Tue, 10 May 2022 04:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156150;
        bh=t0/aRxWVthmXRt0RepoZMwzm+lY6L3WraZ1BcgNTWvM=;
        h=Date:To:From:Subject:From;
        b=ZE9GleQcN7zG+ICTmRFFNitjBZYHFH25q84+FiO5O4u8KWtRGhJpHWEOkFqOgpoE6
         mrzmE/Zs/wbakbMfXxZG0ZPrUgR4/MgiWMUi08WTG0piuQaEs/rzZ/5c9RAIFmGo36
         Oo0icnmZw1sC6qBE479kB3f+rIqP6ENoH2T0L8Z8=
Date:   Mon, 09 May 2022 21:15:49 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-vaddr-move-damon_set_regions-to-core.patch removed from -mm tree
Message-Id: <20220510041549.DE492C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/vaddr: move 'damon_set_regions()' to core
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-move-damon_set_regions-to-core.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/vaddr: move 'damon_set_regions()' to core

This commit moves 'damon_set_regions()' from vaddr to core, as it is aimed
to be used by not only 'vaddr' but also other parts of DAMON.

Link: https://lkml.kernel.org/r/20220429160606.127307-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    2 +
 mm/damon/core.c       |   73 ++++++++++++++++++++++++++++++++++++++++
 mm/damon/vaddr.c      |   73 ----------------------------------------
 3 files changed, 75 insertions(+), 73 deletions(-)

--- a/include/linux/damon.h~mm-damon-vaddr-move-damon_set_regions-to-core
+++ a/include/linux/damon.h
@@ -494,6 +494,8 @@ static inline void damon_insert_region(s
 
 void damon_add_region(struct damon_region *r, struct damon_target *t);
 void damon_destroy_region(struct damon_region *r, struct damon_target *t);
+int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
+		unsigned int nr_ranges);
 
 struct damos *damon_new_scheme(
 		unsigned long min_sz_region, unsigned long max_sz_region,
--- a/mm/damon/core.c~mm-damon-vaddr-move-damon_set_regions-to-core
+++ a/mm/damon/core.c
@@ -157,6 +157,79 @@ void damon_destroy_region(struct damon_r
 	damon_free_region(r);
 }
 
+/*
+ * Check whether a region is intersecting an address range
+ *
+ * Returns true if it is.
+ */
+static bool damon_intersect(struct damon_region *r,
+		struct damon_addr_range *re)
+{
+	return !(r->ar.end <= re->start || re->end <= r->ar.start);
+}
+
+/*
+ * damon_set_regions() - Set regions of a target for given address ranges.
+ * @t:		the given target.
+ * @ranges:	array of new monitoring target ranges.
+ * @nr_ranges:	length of @ranges.
+ *
+ * This function adds new regions to, or modify existing regions of a
+ * monitoring target to fit in specific ranges.
+ *
+ * Return: 0 if success, or negative error code otherwise.
+ */
+int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
+		unsigned int nr_ranges)
+{
+	struct damon_region *r, *next;
+	unsigned int i;
+
+	/* Remove regions which are not in the new ranges */
+	damon_for_each_region_safe(r, next, t) {
+		for (i = 0; i < nr_ranges; i++) {
+			if (damon_intersect(r, &ranges[i]))
+				break;
+		}
+		if (i == nr_ranges)
+			damon_destroy_region(r, t);
+	}
+
+	/* Add new regions or resize existing regions to fit in the ranges */
+	for (i = 0; i < nr_ranges; i++) {
+		struct damon_region *first = NULL, *last, *newr;
+		struct damon_addr_range *range;
+
+		range = &ranges[i];
+		/* Get the first/last regions intersecting with the range */
+		damon_for_each_region(r, t) {
+			if (damon_intersect(r, range)) {
+				if (!first)
+					first = r;
+				last = r;
+			}
+			if (r->ar.start >= range->end)
+				break;
+		}
+		if (!first) {
+			/* no region intersects with this range */
+			newr = damon_new_region(
+					ALIGN_DOWN(range->start,
+						DAMON_MIN_REGION),
+					ALIGN(range->end, DAMON_MIN_REGION));
+			if (!newr)
+				return -ENOMEM;
+			damon_insert_region(newr, damon_prev_region(r), r, t);
+		} else {
+			/* resize intersecting regions to fit in this range */
+			first->ar.start = ALIGN_DOWN(range->start,
+					DAMON_MIN_REGION);
+			last->ar.end = ALIGN(range->end, DAMON_MIN_REGION);
+		}
+	}
+	return 0;
+}
+
 struct damos *damon_new_scheme(
 		unsigned long min_sz_region, unsigned long max_sz_region,
 		unsigned int min_nr_accesses, unsigned int max_nr_accesses,
--- a/mm/damon/vaddr.c~mm-damon-vaddr-move-damon_set_regions-to-core
+++ a/mm/damon/vaddr.c
@@ -286,79 +286,6 @@ static void damon_va_init(struct damon_c
  */
 
 /*
- * Check whether a region is intersecting an address range
- *
- * Returns true if it is.
- */
-static bool damon_intersect(struct damon_region *r,
-		struct damon_addr_range *re)
-{
-	return !(r->ar.end <= re->start || re->end <= r->ar.start);
-}
-
-/*
- * damon_set_regions() - Set regions of a target for given address ranges.
- * @t:		the given target.
- * @ranges:	array of new monitoring target ranges.
- * @nr_ranges:	length of @ranges.
- *
- * This function adds new regions to, or modify existing regions of a
- * monitoring target to fit in specific ranges.
- *
- * Return: 0 if success, or negative error code otherwise.
- */
-static int damon_set_regions(struct damon_target *t,
-		struct damon_addr_range *ranges, unsigned int nr_ranges)
-{
-	struct damon_region *r, *next;
-	unsigned int i;
-
-	/* Remove regions which are not in the new ranges */
-	damon_for_each_region_safe(r, next, t) {
-		for (i = 0; i < nr_ranges; i++) {
-			if (damon_intersect(r, &ranges[i]))
-				break;
-		}
-		if (i == nr_ranges)
-			damon_destroy_region(r, t);
-	}
-
-	/* Add new regions or resize existing regions to fit in the ranges */
-	for (i = 0; i < nr_ranges; i++) {
-		struct damon_region *first = NULL, *last, *newr;
-		struct damon_addr_range *range;
-
-		range = &ranges[i];
-		/* Get the first/last regions intersecting with the range */
-		damon_for_each_region(r, t) {
-			if (damon_intersect(r, range)) {
-				if (!first)
-					first = r;
-				last = r;
-			}
-			if (r->ar.start >= range->end)
-				break;
-		}
-		if (!first) {
-			/* no region intersects with this range */
-			newr = damon_new_region(
-					ALIGN_DOWN(range->start,
-						DAMON_MIN_REGION),
-					ALIGN(range->end, DAMON_MIN_REGION));
-			if (!newr)
-				return -ENOMEM;
-			damon_insert_region(newr, damon_prev_region(r), r, t);
-		} else {
-			/* resize intersecting regions to fit in this range */
-			first->ar.start = ALIGN_DOWN(range->start,
-					DAMON_MIN_REGION);
-			last->ar.end = ALIGN(range->end, DAMON_MIN_REGION);
-		}
-	}
-	return 0;
-}
-
-/*
  * Update damon regions for the three big regions of the given target
  *
  * t		the given target
_

Patches currently in -mm which might be from sj@kernel.org are


