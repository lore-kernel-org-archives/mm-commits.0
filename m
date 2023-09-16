Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89105C2BA12
	for <mm-commits@archiver.kernel.org>; Sat, 16 Sep 2023 20:19:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233681AbjIPUSb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 16 Sep 2023 16:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235240AbjIPUSP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 16 Sep 2023 16:18:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF93ACD8
        for <mm-commits@vger.kernel.org>; Sat, 16 Sep 2023 13:18:09 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87267C433C7;
        Sat, 16 Sep 2023 20:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694895489;
        bh=TKOZC3rXAui5oNt5FHVYz73SFrhASBjDf2opJ13Jv/M=;
        h=Date:To:From:Subject:From;
        b=0m1u3Taf5JdqQJ2BLZMbCGCqokO0MqxpnUueWnL1Z0yoTf5ATiTalOoN8qjbcI4mM
         nB+IimnzY6EAwOE3Xhm6LsY3nzV0+Xc7qe/JyphUQ5wa1gkwf4hppAzVqXOj4WyOCd
         1bvk2HKSQzfZ4A/Sr+7qBq43CgO2gctgnNMer1ck=
Date:   Sat, 16 Sep 2023 13:18:09 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, rostedt@goodmis.org,
        corbet@lwn.net, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-use-nr_accesses_bp-as-a-source-of-damos_before_apply-tracepoint.patch added to mm-unstable branch
Message-Id: <20230916201809.87267C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: use nr_accesses_bp as a source of damos_before_apply tracepoint
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-use-nr_accesses_bp-as-a-source-of-damos_before_apply-tracepoint.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-use-nr_accesses_bp-as-a-source-of-damos_before_apply-tracepoint.patch

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
Subject: mm/damon/core: use nr_accesses_bp as a source of damos_before_apply tracepoint
Date: Sat, 16 Sep 2023 02:09:39 +0000

damos_before_apply tracepoint is exposing access rate of DAMON regions
using nr_accesses field of regions, which was actually used by DAMOS in
the past.  However, it has changed to use nr_accesses_bp instead.  Update
the tracepoint to expose the value that DAMOS is really using.

Note that it doesn't expose the value as is in the basis point, but after
converting it to the natural number by dividing it by 10,000.  Therefore
this change doesn't make user-visible behavioral differences.

Link: https://lkml.kernel.org/r/20230916020945.47296-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/damon.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/trace/events/damon.h~mm-damon-core-use-nr_accesses_bp-as-a-source-of-damos_before_apply-tracepoint
+++ a/include/trace/events/damon.h
@@ -36,7 +36,7 @@ TRACE_EVENT_CONDITION(damos_before_apply
 		__entry->target_idx = target_idx;
 		__entry->start = r->ar.start;
 		__entry->end = r->ar.end;
-		__entry->nr_accesses = r->nr_accesses;
+		__entry->nr_accesses = r->nr_accesses_bp / 10000;
 		__entry->age = r->age;
 		__entry->nr_regions = nr_regions;
 	),
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

