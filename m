Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CB5FC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 16:26:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379048AbiD2Q3S (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 12:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379059AbiD2Q3R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 12:29:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309D85580
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 09:25:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3326B83698
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 16:25:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6663FC385A7;
        Fri, 29 Apr 2022 16:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651249555;
        bh=rqmFIMmPUCDfvarjUfXf6W4bKHzN7HMPyizINOseD50=;
        h=Date:To:From:Subject:From;
        b=HIWWxxpCTTaJQTzAh+KHKwxmifF+zFp9b3rsfMsWFfBC1eAuDoKa/h7jAYcN30gIj
         OeRnn4y5ZTmT0JskoPneqaQKrbnU7nxA9mrHw5ujRKFiD29q2jgTFsY2KFb1Qdill+
         ob9GrJrnfbRNIM4XkB1oh/tzpdADPUE/I0UJyUzc=
Date:   Fri, 29 Apr 2022 09:25:54 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-vaddr-generalize-damon_va_apply_three_regions.patch added to mm-unstable branch
Message-Id: <20220429162555.6663FC385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/vaddr: generalize damon_va_apply_three_regions()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-vaddr-generalize-damon_va_apply_three_regions.patch

This patch should soon appear in the mm-unstable branch at
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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/vaddr: generalize damon_va_apply_three_regions()

'damon_va_apply_three_regions()' is for adjusting address ranges to fit in
three discontiguous ranges.  The function can be generalized for arbitrary
number of discontiguous ranges and reused for future usage, such as
arbitrary online regions update.  For such future usage, this commit
introduces a generalized version of the function called
'damon_set_regions()'.

Link: https://lkml.kernel.org/r/20220429160606.127307-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |   66 ++++++++++++++++++++++++++++-----------------
 1 file changed, 42 insertions(+), 24 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-generalize-damon_va_apply_three_regions
+++ a/mm/damon/vaddr.c
@@ -297,59 +297,77 @@ static bool damon_intersect(struct damon
 }
 
 /*
- * Update damon regions for the three big regions of the given target
+ * damon_set_regions() - Set regions of a target for given address ranges.
+ * @t:		the given target.
+ * @ranges:	array of new monitoring target ranges.
+ * @nr_ranges:	length of @ranges.
  *
- * t		the given target
- * bregions	the three big regions of the target
+ * This function adds new regions to, or modify existing regions of a
+ * monitoring target to fit in specific ranges.
+ *
+ * Return: 0 if success, or negative error code otherwise.
  */
-static void damon_va_apply_three_regions(struct damon_target *t,
-		struct damon_addr_range bregions[3])
+static int damon_set_regions(struct damon_target *t,
+		struct damon_addr_range *ranges, unsigned int nr_ranges)
 {
 	struct damon_region *r, *next;
 	unsigned int i;
 
-	/* Remove regions which are not in the three big regions now */
+	/* Remove regions which are not in the new ranges */
 	damon_for_each_region_safe(r, next, t) {
-		for (i = 0; i < 3; i++) {
-			if (damon_intersect(r, &bregions[i]))
+		for (i = 0; i < nr_ranges; i++) {
+			if (damon_intersect(r, &ranges[i]))
 				break;
 		}
-		if (i == 3)
+		if (i == nr_ranges)
 			damon_destroy_region(r, t);
 	}
 
-	/* Adjust intersecting regions to fit with the three big regions */
-	for (i = 0; i < 3; i++) {
-		struct damon_region *first = NULL, *last;
-		struct damon_region *newr;
-		struct damon_addr_range *br;
+	/* Add new regions or resize existing regions to fit in the ranges */
+	for (i = 0; i < nr_ranges; i++) {
+		struct damon_region *first = NULL, *last, *newr;
+		struct damon_addr_range *range;
 
-		br = &bregions[i];
-		/* Get the first and last regions which intersects with br */
+		range = &ranges[i];
+		/* Get the first/last regions intersecting with the range */
 		damon_for_each_region(r, t) {
-			if (damon_intersect(r, br)) {
+			if (damon_intersect(r, range)) {
 				if (!first)
 					first = r;
 				last = r;
 			}
-			if (r->ar.start >= br->end)
+			if (r->ar.start >= range->end)
 				break;
 		}
 		if (!first) {
-			/* no damon_region intersects with this big region */
+			/* no region intersects with this range */
 			newr = damon_new_region(
-					ALIGN_DOWN(br->start,
+					ALIGN_DOWN(range->start,
 						DAMON_MIN_REGION),
-					ALIGN(br->end, DAMON_MIN_REGION));
+					ALIGN(range->end, DAMON_MIN_REGION));
 			if (!newr)
-				continue;
+				return -ENOMEM;
 			damon_insert_region(newr, damon_prev_region(r), r, t);
 		} else {
-			first->ar.start = ALIGN_DOWN(br->start,
+			/* resize intersecting regions to fit in this range */
+			first->ar.start = ALIGN_DOWN(range->start,
 					DAMON_MIN_REGION);
-			last->ar.end = ALIGN(br->end, DAMON_MIN_REGION);
+			last->ar.end = ALIGN(range->end, DAMON_MIN_REGION);
 		}
 	}
+	return 0;
+}
+
+/*
+ * Update damon regions for the three big regions of the given target
+ *
+ * t		the given target
+ * bregions	the three big regions of the target
+ */
+static void damon_va_apply_three_regions(struct damon_target *t,
+		struct damon_addr_range bregions[3])
+{
+	damon_set_regions(t, bregions, 3);
 }
 
 /*
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-test-add-a-kunit-test-case-for-ops-registration.patch
mm-damon-core-add-a-function-for-damon_operations-registration-checks.patch
mm-damon-sysfs-add-a-file-for-listing-available-monitoring-ops.patch
selftets-damon-sysfs-test-existence-and-permission-of-avail_operations.patch
docs-abiadmin-guide-damon-document-avail_operations-sysfs-file.patch
mm-damon-vaddr-register-a-damon_operations-for-fixed-virtual-address-ranges-monitoring.patch
mm-damon-sysfs-support-fixed-virtual-address-ranges-monitoring.patch
docs-abiadmin-guide-damon-update-for-fixed-virtual-address-ranges-monitoring.patch
mm-damon-core-add-a-new-callback-for-watermarks-checks.patch
mm-damon-core-finish-kdamond-as-soon-as-any-callback-returns-an-error.patch
mm-damon-vaddr-generalize-damon_va_apply_three_regions.patch
mm-damon-vaddr-move-damon_set_regions-to-core.patch
mm-damon-vaddr-remove-damon_va_apply_three_regions.patch
mm-damon-sysfs-prohibit-multiple-physical-address-space-monitoring-targets.patch
mm-damon-sysfs-move-targets-setup-code-to-a-separated-function.patch
mm-damon-sysfs-reuse-damon_set_regions-for-regions-setting.patch
mm-damon-sysfs-use-enum-for-state-input-handling.patch
mm-damon-sysfs-update-schemes-stat-in-the-kdamond-context.patch
mm-damon-sysfs-support-online-inputs-update.patch
docs-abiadmin-guide-damon-update-for-state-sysfs-file-input-keyword-commit.patch
mm-damon-reclaim-support-online-inputs-update.patch
docs-admin-guide-mm-damon-reclaim-document-commit_inputs-parameter.patch

