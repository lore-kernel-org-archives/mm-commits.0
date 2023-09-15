Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2B18EED617
	for <mm-commits@archiver.kernel.org>; Fri, 15 Sep 2023 16:37:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbjIOQhQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Sep 2023 12:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235079AbjIOQgt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Sep 2023 12:36:49 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0DD8E69
        for <mm-commits@vger.kernel.org>; Fri, 15 Sep 2023 09:36:43 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A366C433C7;
        Fri, 15 Sep 2023 16:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694795803;
        bh=moONB27Ko2LxL8u0AvEYSiFoHJ8o224sptZniXv9GFc=;
        h=Date:To:From:Subject:From;
        b=R6bjnCrf2M8/0injpgA3tLfyiqx53qTrCizN3h8B5GvZAaVDopjLN41KXwhzWvhIR
         fefMa46uFSMUM/SH1SlXe3xJ2lD1EskdYvhIiU+tfj7VGsebUNTIUgjeDOMZeCIU5/
         8sT+kx8c8QLjVDgSpytQapIfMc7QEiUx6PYe2xWE=
Date:   Fri, 15 Sep 2023 09:36:43 -0700
To:     mm-commits@vger.kernel.org, brendanhiggins@google.com,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-skip-updating-nr_accesses_bp-for-each-aggregation-interval.patch added to mm-unstable branch
Message-Id: <20230915163643.8A366C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: skip updating nr_accesses_bp for each aggregation interval
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-skip-updating-nr_accesses_bp-for-each-aggregation-interval.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-skip-updating-nr_accesses_bp-for-each-aggregation-interval.patch

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

