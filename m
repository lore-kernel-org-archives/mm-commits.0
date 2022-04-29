Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C233FC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 16:26:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379060AbiD2Q3S (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 12:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379058AbiD2Q3Q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 12:29:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D247167D7
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 09:25:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDE706231C
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 16:25:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 420DAC385AE;
        Fri, 29 Apr 2022 16:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651249557;
        bh=qpSSn5hoK69rTOa3zFrYtXjrGhqq9CBDaGgqwt55O9U=;
        h=Date:To:From:Subject:From;
        b=YnmvFmLSldtsKvnPd0xZCe4VWEDsfIqM7P5k8s3NZBPMBkAJbZ5EGaCywT7L9tMEs
         pjb0fEhZ3kjdY4RZ3gBSavGptZbb0YxdhXxcfeDFlguhFp8d17rKK+HOOB1Z39bfNV
         VY4DIrXoHZBF98vdXvSiSPbZTy+t/GudrWIs1Pm4=
Date:   Fri, 29 Apr 2022 09:25:56 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-vaddr-move-damon_set_regions-to-core.patch added to mm-unstable branch
Message-Id: <20220429162557.420DAC385AE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/vaddr: move 'damon_set_regions()' to core
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-vaddr-move-damon_set_regions-to-core.patch

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

