Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98DA6EED61B
	for <mm-commits@archiver.kernel.org>; Fri, 15 Sep 2023 16:37:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234737AbjIOQgn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Sep 2023 12:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235065AbjIOQgk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Sep 2023 12:36:40 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21598AC
        for <mm-commits@vger.kernel.org>; Fri, 15 Sep 2023 09:36:35 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0443C433C7;
        Fri, 15 Sep 2023 16:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694795794;
        bh=8cdyOtoMrOneGeZ1voewAPkVBYhhzg/IqCUWt8JzGqI=;
        h=Date:To:From:Subject:From;
        b=QQZPuG7eZ8hyzqga3lNk22WB1EnSpilZ2tWQJSUHkPcw3SNmRrV8SO4FWwKFTt5m2
         PdVL9HT5IR1VatQ2GuJRIHlRNZYdznyVo3/znoviBGugojBGMiklSIm0MqIH/vVr1k
         H+VEmWdOU+vP5wxQjpuG76KWQeotLEAR44NXmF8E=
Date:   Fri, 15 Sep 2023 09:36:34 -0700
To:     mm-commits@vger.kernel.org, brendanhiggins@google.com,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-implement-a-pseudo-moving-sum-function.patch added to mm-unstable branch
Message-Id: <20230915163634.B0443C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: implement a pseudo-moving sum function
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-implement-a-pseudo-moving-sum-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-implement-a-pseudo-moving-sum-function.patch

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
Subject: mm/damon/core: implement a pseudo-moving sum function
Date: Fri, 15 Sep 2023 02:52:46 +0000

For values that continuously change, moving average or sum are good ways
to provide fast updates while handling temporal and errorneous variability
of the value.  For example, the access rate counter (nr_accesses) is
calculated as a sum of the number of positive sampled access check results
that collected during a discrete time window (aggregation interval), and
hence it handles temporal and errorneous access check results, but
provides the update only for every aggregation interval.  Using a moving
sum method for that could allow providing the value for every sampling
interval.  That could be useful for getting monitoring results snapshot or
running DAMOS in fine-grained timing.

However, supporting the moving sum for cases that number of samples in the
time window is arbirary could impose high overhead, since the number of
past values that it needs to keep could be too high.  The nr_accesses
would also be one of the cases.  To mitigate the overhead, implement a
pseudo-moving sum function that only provides an estimated pseudo-moving
sum.  It assumes there was no error in last discrete time window and
subtract constant portion of last discrete time window sum.

Note that the function is not strictly implementing the moving sum, but it
keeps a property of moving sum, which makes the value same to the
dsicrete-window based sum for each time window-aligned timing.  Hence,
people collecting the value in the old timings would show no difference.

Link: https://lkml.kernel.org/r/20230915025251.72816-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    2 ++
 mm/damon/core.c       |   40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

--- a/include/linux/damon.h~mm-damon-core-implement-a-pseudo-moving-sum-function
+++ a/include/linux/damon.h
@@ -622,6 +622,8 @@ void damon_add_region(struct damon_regio
 void damon_destroy_region(struct damon_region *r, struct damon_target *t);
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 		unsigned int nr_ranges);
+unsigned int damon_moving_sum(unsigned int mvsum, unsigned int nomvsum,
+		unsigned int len_window, unsigned int new_value);
 void damon_update_region_access_rate(struct damon_region *r, bool accessed);
 
 struct damos_filter *damos_new_filter(enum damos_filter_type type,
--- a/mm/damon/core.c~mm-damon-core-implement-a-pseudo-moving-sum-function
+++ a/mm/damon/core.c
@@ -1549,6 +1549,46 @@ int damon_set_region_biggest_system_ram_
 	return damon_set_regions(t, &addr_range, 1);
 }
 
+/*
+ * damon_moving_sum() - Calculate an inferred moving sum value.
+ * @mvsum:	Inferred sum of the last @len_window values.
+ * @nomvsum:	Non-moving sum of the last discrete @len_window window values.
+ * @len_window:	The number of last values to take care of.
+ * @new_value:	New value that will be added to the pseudo moving sum.
+ *
+ * Moving sum (moving average * window size) is good for handling noise, but
+ * the cost of keeping past values can be high for arbitrary window size.  This
+ * function implements a lightweight pseudo moving sum function that doesn't
+ * keep the past window values.
+ *
+ * It simply assumes there was no noise in the past, and get the no-noise
+ * assumed past value to drop from @nomvsum and @len_window.  @nomvsum is a
+ * non-moving sum of the last window.  For example, if @len_window is 10 and we
+ * have 25 values, @nomvsum is the sum of the 11th to 20th values of the 25
+ * values.  Hence, this function simply drops @nomvsum / @len_window from
+ * given @mvsum and add @new_value.
+ *
+ * For example, if @len_window is 10 and @nomvsum is 50, the last 10 values for
+ * the last window could be vary, e.g., 0, 10, 0, 10, 0, 10, 0, 0, 0, 20.  For
+ * calculating next moving sum with a new value, we should drop 0 from 50 and
+ * add the new value.  However, this function assumes it got value 5 for each
+ * of the last ten times.  Based on the assumption, when the next value is
+ * measured, it drops the assumed past value, 5 from the current sum, and add
+ * the new value to get the updated pseduo-moving average.
+ *
+ * This means the value could have errors, but the errors will be disappeared
+ * for every @len_window aligned calls.  For example, if @len_window is 10, the
+ * pseudo moving sum with 11th value to 19th value would have an error.  But
+ * the sum with 20th value will not have the error.
+ *
+ * Return: Pseudo-moving average after getting the @new_value.
+ */
+unsigned int damon_moving_sum(unsigned int mvsum, unsigned int nomvsum,
+		unsigned int len_window, unsigned int new_value)
+{
+	return mvsum - nomvsum / len_window + new_value;
+}
+
 /**
  * damon_update_region_access_rate() - Update the access rate of a region.
  * @r:		The DAMON region to update for its access check result.
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

