Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FFA0EED618
	for <mm-commits@archiver.kernel.org>; Fri, 15 Sep 2023 16:37:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbjIOQgm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Sep 2023 12:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235028AbjIOQgg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Sep 2023 12:36:36 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC04BAC
        for <mm-commits@vger.kernel.org>; Fri, 15 Sep 2023 09:36:30 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B526C433C8;
        Fri, 15 Sep 2023 16:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694795790;
        bh=BeQoNkXn3OZplSfb4QGxh2JAW+75POChfAr2WSplZ7A=;
        h=Date:To:From:Subject:From;
        b=Vf81QJQwua/eEx4EXC0+nj07s+GwzN9gzMMq7v5T4BlX8D3YW8BABHtTDwGq4uJfm
         dAkG+F+Cq4Fvc9tljj9IZRPHEEI9jSUPrMOUEGRqChlyXfUlxrecfoKB6qyVttdFqm
         C5TIUs53qc/9oSw2WdYHiH7gdghGwABSwvt6WWB0=
Date:   Fri, 15 Sep 2023 09:36:29 -0700
To:     mm-commits@vger.kernel.org, brendanhiggins@google.com,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-define-and-use-a-dedicated-function-for-region-access-rate-update.patch added to mm-unstable branch
Message-Id: <20230915163630.5B526C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: define and use a dedicated function for region access rate update
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-define-and-use-a-dedicated-function-for-region-access-rate-update.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-define-and-use-a-dedicated-function-for-region-access-rate-update.patch

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
Subject: mm/damon/core: define and use a dedicated function for region access rate update
Date: Fri, 15 Sep 2023 02:52:44 +0000

Patch series "mm/damon: provide pseudo-moving sum based access rate".

DAMON checks the access to each region for every sampling interval,
increase the access rate counter of the region, namely nr_accesses, if the
access was made.  For every aggregation interval, the counter is reset. 
The counter is exposed to users to be used as a metric showing the
relative access rate (frequency) of each region.  In other words, DAMON
provides access rate of each region in every aggregation interval.  The
aggregation avoids temporal access pattern changes making things
confusing.  However, this also makes a few DAMON-related operations to
unnecessarily need to be aligned to the aggregation interval.  This can
restrict the flexibility of DAMON applications, especially when the
aggregation interval is huge.

To provide the monitoring results in finer-grained timing while keeping
handling of temporal access pattern change, this patchset implements a
pseudo-moving sum based access rate metric.  It is pseudo-moving sum
because strict moving sum implementation would need to keep all values for
last time window, and that could incur high overhead of there could be
arbitrary number of values in a time window.  Especially in case of the
nr_accesses, since the sampling interval and aggregation interval can
arbitrarily set and the past values should be maintained for every region,
it could be risky.  The pseudo-moving sum assumes there were no temporal
access pattern change in last discrete time window to remove the needs for
keeping the list of the last time window values.  As a result, it beocmes
not strict moving sum implementation, but provides a reasonable accuracy.

Also, it keeps an important property of the moving sum.  That is, the
moving sum becomes same to discrete-window based sum at the time that
aligns to the time window.  This means using the pseudo moving sum based
nr_accesses makes no change to users who shows the value for every
aggregation interval.

Patches Sequence
----------------

The sequence of the patches is as follows.  The first four patches are for
preparation of the change.  The first two (patches 1 and 2) implements a
helper function for nr_accesses update and eliminate corner case that
skips use of the function, respectively.  Following two (patches 3 and 4)
respectively implement the pseudo-moving sum function and its simple unit
test case.

Two patches for making DAMON to use the pseudo-moving sum follow.  The
fifthe one (patch 5) introduces a new field for representing the
pseudo-moving sum-based access rate of each region, and the sixth one
makes the new representation to actually updated with the pseudo-moving
sum function.

Last two patches (patches 7 and 8) makes followup fixes for skipping
unnecessary updates and marking the moving sum function as static,
respectively.


This patch (of 8):

Each DAMON operarions set is updating nr_accesses field of each
damon_region for each of their access check results, from the
check_accesses() callback.  Directly accessing the field could make things
complex to manage and change in future.  Define and use a dedicated
function for the purpose.

Link: https://lkml.kernel.org/r/20230915025251.72816-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20230915025251.72816-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    5 ++++-
 mm/damon/core.c       |   16 ++++++++++++++++
 mm/damon/paddr.c      |    6 ++----
 mm/damon/vaddr.c      |    6 ++----
 4 files changed, 24 insertions(+), 9 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-define-and-use-a-dedicated-function-for-region-access-rate-update
+++ a/include/linux/damon.h
@@ -45,7 +45,9 @@ struct damon_addr_range {
  *
  * @nr_accesses is reset to zero for every &damon_attrs->aggr_interval and be
  * increased for every &damon_attrs->sample_interval if an access to the region
- * during the last sampling interval is found.
+ * during the last sampling interval is found.  The update of this field should
+ * not be done with direct access but with the helper function,
+ * damon_update_region_access_rate().
  *
  * @age is initially zero, increased for each aggregation interval, and reset
  * to zero again if the access frequency is significantly changed.  If two
@@ -620,6 +622,7 @@ void damon_add_region(struct damon_regio
 void damon_destroy_region(struct damon_region *r, struct damon_target *t);
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 		unsigned int nr_ranges);
+void damon_update_region_access_rate(struct damon_region *r, bool accessed);
 
 struct damos_filter *damos_new_filter(enum damos_filter_type type,
 		bool matching);
--- a/mm/damon/core.c~mm-damon-core-define-and-use-a-dedicated-function-for-region-access-rate-update
+++ a/mm/damon/core.c
@@ -1549,6 +1549,22 @@ int damon_set_region_biggest_system_ram_
 	return damon_set_regions(t, &addr_range, 1);
 }
 
+/**
+ * damon_update_region_access_rate() - Update the access rate of a region.
+ * @r:		The DAMON region to update for its access check result.
+ * @accessed:	Whether the region has accessed during last sampling interval.
+ *
+ * Update the access rate of a region with the region's last sampling interval
+ * access check result.
+ *
+ * Usually this will be called by &damon_operations->check_accesses callback.
+ */
+void damon_update_region_access_rate(struct damon_region *r, bool accessed)
+{
+	if (accessed)
+		r->nr_accesses++;
+}
+
 static int __init damon_init(void)
 {
 	damon_region_cache = KMEM_CACHE(damon_region, 0);
--- a/mm/damon/paddr.c~mm-damon-core-define-and-use-a-dedicated-function-for-region-access-rate-update
+++ a/mm/damon/paddr.c
@@ -157,14 +157,12 @@ static void __damon_pa_check_access(stru
 	/* If the region is in the last checked page, reuse the result */
 	if (ALIGN_DOWN(last_addr, last_folio_sz) ==
 				ALIGN_DOWN(r->sampling_addr, last_folio_sz)) {
-		if (last_accessed)
-			r->nr_accesses++;
+		damon_update_region_access_rate(r, last_accessed);
 		return;
 	}
 
 	last_accessed = damon_pa_young(r->sampling_addr, &last_folio_sz);
-	if (last_accessed)
-		r->nr_accesses++;
+	damon_update_region_access_rate(r, last_accessed);
 
 	last_addr = r->sampling_addr;
 }
--- a/mm/damon/vaddr.c~mm-damon-core-define-and-use-a-dedicated-function-for-region-access-rate-update
+++ a/mm/damon/vaddr.c
@@ -566,14 +566,12 @@ static void __damon_va_check_access(stru
 	/* If the region is in the last checked page, reuse the result */
 	if (same_target && (ALIGN_DOWN(last_addr, last_folio_sz) ==
 				ALIGN_DOWN(r->sampling_addr, last_folio_sz))) {
-		if (last_accessed)
-			r->nr_accesses++;
+		damon_update_region_access_rate(r, last_accessed);
 		return;
 	}
 
 	last_accessed = damon_va_young(mm, r->sampling_addr, &last_folio_sz);
-	if (last_accessed)
-		r->nr_accesses++;
+	damon_update_region_access_rate(r, last_accessed);
 
 	last_addr = r->sampling_addr;
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

