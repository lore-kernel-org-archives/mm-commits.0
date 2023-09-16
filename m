Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B04B6C2BA1B
	for <mm-commits@archiver.kernel.org>; Sat, 16 Sep 2023 20:19:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236073AbjIPUSc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 16 Sep 2023 16:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236879AbjIPUSU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 16 Sep 2023 16:18:20 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4F61CD8
        for <mm-commits@vger.kernel.org>; Sat, 16 Sep 2023 13:18:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1B0C433C7;
        Sat, 16 Sep 2023 20:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694895494;
        bh=rR4FEp8yc3UgTdeRVpHSfajwy3Oe0YyKkCs0jfpXhv0=;
        h=Date:To:From:Subject:From;
        b=c44ywztjIMPXwIX7AHTEywc3jaBODT8Lus+6mBW5sZw9iSomORVY4vzOlKtuwMgwG
         RZRyqeTZjWWGA2oqzPoxE3ipe92hMiuSRu1FExqhzsOIqnnLgSfM6omxmRvXlk0ncl
         gg3488TMpGD8iLz3YIKPUp6wXi0Ib9bB1wplgU+U=
Date:   Sat, 16 Sep 2023 13:18:13 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, rostedt@goodmis.org,
        corbet@lwn.net, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-document-damos-apply-intervals.patch added to mm-unstable branch
Message-Id: <20230916201814.7A1B0C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Docs/mm/damon/design: document DAMOS apply intervals
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-document-damos-apply-intervals.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-document-damos-apply-intervals.patch

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
Subject: Docs/mm/damon/design: document DAMOS apply intervals
Date: Sat, 16 Sep 2023 02:09:41 +0000

Update DAMON design doc to explain about DAMOS apply intervals.

Link: https://lkml.kernel.org/r/20230916020945.47296-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-damos-apply-intervals
+++ a/Documentation/mm/damon/design.rst
@@ -259,7 +259,8 @@ works, DAMON provides a feature called D
 Schemes (DAMOS).  It lets users specify their desired schemes at a high
 level.  For such specifications, DAMON starts monitoring, finds regions having
 the access pattern of interest, and applies the user-desired operation actions
-to the regions as soon as found.
+to the regions, for every user-specified time interval called
+``apply_interval``.
 
 
 .. _damon_design_damos_action:
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
mm-damon-core-make-damos-uses-nr_accesses_bp-instead-of-nr_accesses.patch
mm-damon-sysfs-schemes-use-nr_accesses_bp-as-the-source-of-tried_regions-n-nr_accesses.patch
mm-damon-core-use-nr_accesses_bp-as-a-source-of-damos_before_apply-tracepoint.patch
mm-damon-core-implement-scheme-specific-apply-interval.patch
docs-mm-damon-design-document-damos-apply-intervals.patch
mm-damon-sysfs-schemes-support-damos-apply-interval.patch
selftests-damon-sysfs-test-damos-apply-intervals.patch
docs-admin-guide-mm-damon-usage-update-for-damos-apply-intervals.patch
docs-abi-damon-update-for-damos-apply-intervals.patch

