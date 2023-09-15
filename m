Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 006A4EED61A
	for <mm-commits@archiver.kernel.org>; Fri, 15 Sep 2023 16:37:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234753AbjIOQhP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Sep 2023 12:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbjIOQgr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Sep 2023 12:36:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53FFAAC
        for <mm-commits@vger.kernel.org>; Fri, 15 Sep 2023 09:36:41 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A2AC433C8;
        Fri, 15 Sep 2023 16:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694795801;
        bh=bcIVuzl74v0vK88NxX6rn3yVon7+j1Q6qBfqIehqlVQ=;
        h=Date:To:From:Subject:From;
        b=hzAO6gKA5Bfx7VkvIN+5STsbEMLadnfi0rQivzN4Jq1Gl2cMaePLPY7PUBdn7F104
         y33ZuIXhSRtwJ0Puvzkqet4hCmK7wKnM36G5KMDUs+WhrXNg5VJwQIZrcdQtalYaPy
         ZFTAI4zcFjn/Pyt4EsYLYTFireZGfwejPVvB60Nc=
Date:   Fri, 15 Sep 2023 09:36:40 -0700
To:     mm-commits@vger.kernel.org, brendanhiggins@google.com,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-use-pseudo-moving-sum-for-nr_accesses_bp.patch added to mm-unstable branch
Message-Id: <20230915163640.D4A2AC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: use pseudo-moving sum for nr_accesses_bp
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-use-pseudo-moving-sum-for-nr_accesses_bp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-use-pseudo-moving-sum-for-nr_accesses_bp.patch

This patch will later appear in the mm-unstable branch at
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
Subject: mm/damon/core: use pseudo-moving sum for nr_accesses_bp
Date: Fri, 15 Sep 2023 02:52:49 +0000

Let nr_accesses_bp be calculated as a pseudo-moving sum that updated for
every sampling interval, using damon_moving_sum().  This is assumed to be
useful for cases that the aggregation interval is set quite huge, but the
monivoting results need to be collected earlier than next aggregation
interval is passed.

Link: https://lkml.kernel.org/r/20230915025251.72816-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   12 +++++++++---
 mm/damon/core.c       |   16 +++++++++++++++-
 mm/damon/paddr.c      |    9 +++++----
 mm/damon/vaddr.c      |   12 +++++++-----
 4 files changed, 36 insertions(+), 13 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-use-pseudo-moving-sum-for-nr_accesses_bp
+++ a/include/linux/damon.h
@@ -40,7 +40,8 @@ struct damon_addr_range {
  * @ar:			The address range of the region.
  * @sampling_addr:	Address of the sample for the next access check.
  * @nr_accesses:	Access frequency of this region.
- * @nr_accesses_bp:	@nr_accesses in basis point (0.01%).
+ * @nr_accesses_bp:	@nr_accesses in basis point (0.01%) that updated for
+ *			each sampling interval.
  * @list:		List head for siblings.
  * @age:		Age of this region.
  *
@@ -51,7 +52,11 @@ struct damon_addr_range {
  * damon_update_region_access_rate().
  *
  * @nr_accesses_bp is another representation of @nr_accesses in basis point
- * (1 in 10,000) that updated every aggregation interval.
+ * (1 in 10,000) that updated for every &damon_attrs->sample_interval in a
+ * manner similar to moving sum.  By the algorithm, this value becomes
+ * @nr_accesses * 10000 for every &struct damon_attrs->aggr_interval.  This can
+ * be used when the aggregation interval is too huge and therefore cannot wait
+ * for it before getting the access monitoring results.
  *
  * @age is initially zero, increased for each aggregation interval, and reset
  * to zero again if the access frequency is significantly changed.  If two
@@ -629,7 +634,8 @@ int damon_set_regions(struct damon_targe
 		unsigned int nr_ranges);
 unsigned int damon_moving_sum(unsigned int mvsum, unsigned int nomvsum,
 		unsigned int len_window, unsigned int new_value);
-void damon_update_region_access_rate(struct damon_region *r, bool accessed);
+void damon_update_region_access_rate(struct damon_region *r, bool accessed,
+		struct damon_attrs *attrs);
 
 struct damos_filter *damos_new_filter(enum damos_filter_type type,
 		bool matching);
--- a/mm/damon/core.c~mm-damon-core-use-pseudo-moving-sum-for-nr_accesses_bp
+++ a/mm/damon/core.c
@@ -1599,14 +1599,28 @@ unsigned int damon_moving_sum(unsigned i
  * damon_update_region_access_rate() - Update the access rate of a region.
  * @r:		The DAMON region to update for its access check result.
  * @accessed:	Whether the region has accessed during last sampling interval.
+ * @attrs:	The damon_attrs of the DAMON context.
  *
  * Update the access rate of a region with the region's last sampling interval
  * access check result.
  *
  * Usually this will be called by &damon_operations->check_accesses callback.
  */
-void damon_update_region_access_rate(struct damon_region *r, bool accessed)
+void damon_update_region_access_rate(struct damon_region *r, bool accessed,
+		struct damon_attrs *attrs)
 {
+	unsigned int len_window = 1;
+
+	/*
+	 * sample_interval can be zero, but cannot be larger than
+	 * aggr_interval, owing to validation of damon_set_attrs().
+	 */
+	if (attrs->sample_interval)
+		len_window = attrs->aggr_interval / attrs->sample_interval;
+	r->nr_accesses_bp = damon_moving_sum(r->nr_accesses_bp,
+			r->last_nr_accesses * 10000, len_window,
+			accessed ? 10000 : 0);
+
 	if (accessed)
 		r->nr_accesses++;
 }
--- a/mm/damon/paddr.c~mm-damon-core-use-pseudo-moving-sum-for-nr_accesses_bp
+++ a/mm/damon/paddr.c
@@ -148,7 +148,8 @@ out:
 	return accessed;
 }
 
-static void __damon_pa_check_access(struct damon_region *r)
+static void __damon_pa_check_access(struct damon_region *r,
+		struct damon_attrs *attrs)
 {
 	static unsigned long last_addr;
 	static unsigned long last_folio_sz = PAGE_SIZE;
@@ -157,12 +158,12 @@ static void __damon_pa_check_access(stru
 	/* If the region is in the last checked page, reuse the result */
 	if (ALIGN_DOWN(last_addr, last_folio_sz) ==
 				ALIGN_DOWN(r->sampling_addr, last_folio_sz)) {
-		damon_update_region_access_rate(r, last_accessed);
+		damon_update_region_access_rate(r, last_accessed, attrs);
 		return;
 	}
 
 	last_accessed = damon_pa_young(r->sampling_addr, &last_folio_sz);
-	damon_update_region_access_rate(r, last_accessed);
+	damon_update_region_access_rate(r, last_accessed, attrs);
 
 	last_addr = r->sampling_addr;
 }
@@ -175,7 +176,7 @@ static unsigned int damon_pa_check_acces
 
 	damon_for_each_target(t, ctx) {
 		damon_for_each_region(r, t) {
-			__damon_pa_check_access(r);
+			__damon_pa_check_access(r, &ctx->attrs);
 			max_nr_accesses = max(r->nr_accesses, max_nr_accesses);
 		}
 	}
--- a/mm/damon/vaddr.c~mm-damon-core-use-pseudo-moving-sum-for-nr_accesses_bp
+++ a/mm/damon/vaddr.c
@@ -557,26 +557,27 @@ static bool damon_va_young(struct mm_str
  * r	the region to be checked
  */
 static void __damon_va_check_access(struct mm_struct *mm,
-				struct damon_region *r, bool same_target)
+				struct damon_region *r, bool same_target,
+				struct damon_attrs *attrs)
 {
 	static unsigned long last_addr;
 	static unsigned long last_folio_sz = PAGE_SIZE;
 	static bool last_accessed;
 
 	if (!mm) {
-		damon_update_region_access_rate(r, false);
+		damon_update_region_access_rate(r, false, attrs);
 		return;
 	}
 
 	/* If the region is in the last checked page, reuse the result */
 	if (same_target && (ALIGN_DOWN(last_addr, last_folio_sz) ==
 				ALIGN_DOWN(r->sampling_addr, last_folio_sz))) {
-		damon_update_region_access_rate(r, last_accessed);
+		damon_update_region_access_rate(r, last_accessed, attrs);
 		return;
 	}
 
 	last_accessed = damon_va_young(mm, r->sampling_addr, &last_folio_sz);
-	damon_update_region_access_rate(r, last_accessed);
+	damon_update_region_access_rate(r, last_accessed, attrs);
 
 	last_addr = r->sampling_addr;
 }
@@ -593,7 +594,8 @@ static unsigned int damon_va_check_acces
 		mm = damon_get_mm(t);
 		same_target = false;
 		damon_for_each_region(r, t) {
-			__damon_va_check_access(mm, r, same_target);
+			__damon_va_check_access(mm, r, same_target,
+					&ctx->attrs);
 			max_nr_accesses = max(r->nr_accesses, max_nr_accesses);
 			same_target = true;
 		}
_

Patches currently in -mm which might be from sj@kernel.org are

docs-admin-guide-mm-damon-usage-fixup-missed-ref-keyword.patch
docs-admin-guide-mm-damon-usage-place-debugfs-usage-at-the-bottom.patch
docs-admin-guide-mm-damon-usage-move-debugfs-intro-to-the-bottom-of-the-section.patch
docs-mm-damon-design-explicitly-introduce-nr_accesses.patch
docs-admin-guide-mm-damon-usage-explain-the-format-of-damon_aggregate-tracepoint.patch
docs-mm-damon-design-add-a-section-for-kdamond-and-damon-context.patch
docs-admin-guide-mm-damon-usage-link-design-doc-for-details-of-kdamond-and-context.patch
mm-damon-core-fix-a-comment-about-damon_set_attrs-call-timings.patch
mm-damon-core-add-more-comments-for-nr_accesses.patch
mm-damon-core-remove-duplicated-comment-for-watermarks-based-deactivation.patch
mm-damon-core-remove-struct-target-parameter-from-damon_aggregated-tracepoint.patch
mm-damon-core-add-a-tracepoint-for-damos-apply-target-regions.patch
docs-admin-guide-mm-damon-usage-document-damos_before_apply-tracepoint.patch
mm-damon-core-use-number-of-passed-access-sampling-as-a-timer.patch
mm-damon-core-define-and-use-a-dedicated-function-for-region-access-rate-update.patch
mm-damon-vaddr-call-damon_update_region_access_rate-always.patch
mm-damon-core-implement-a-pseudo-moving-sum-function.patch
mm-damon-core-test-add-a-unit-test-for-damon_moving_sum.patch
mm-damon-core-introduce-nr_accesses_bp.patch
mm-damon-core-use-pseudo-moving-sum-for-nr_accesses_bp.patch
mm-damon-core-skip-updating-nr_accesses_bp-for-each-aggregation-interval.patch
mm-damon-core-mark-damon_moving_sum-as-a-static-function.patch

