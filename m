Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ACC4C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  2 Dec 2021 03:42:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355215AbhLBDp4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Dec 2021 22:45:56 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44724 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355239AbhLBDn7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Dec 2021 22:43:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C4A2B8221A
        for <mm-commits@vger.kernel.org>; Thu,  2 Dec 2021 03:40:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0560C00446;
        Thu,  2 Dec 2021 03:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638416428;
        bh=V3Bl26QzXmNCDGeipo22iU4YRyMIfll1OA90Z6RQgOI=;
        h=Date:From:To:Subject:From;
        b=HJIQbZletpzRmIyVDNpHzmMu0hQ8155KmqsquBDrg8QPD94gYAkAYD8P/8be8OB3+
         nV6WhI6HOPyH7BgDIE7U2ZWX7s7KHZJscBHMinvgzHV3RFnVRXtKe2ncjjVrBISzMw
         +MgrxERxCX2gdaQSNr5APR1Sj2mpV7ECXi/Gx+3o=
Date:   Wed, 01 Dec 2021 19:40:27 -0800
From:   akpm@linux-foundation.org
To:     brendanhiggins@google.com, lkp@intel.com,
        mm-commits@vger.kernel.org, shuah@kernel.org, sj@kernel.org
Subject:  + mm-damon-core-remove-unnecessary-error-messages.patch
 added to -mm tree
Message-ID: <20211202034027.r3nLB8Ifd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: remove unnecessary error messages
has been added to the -mm tree.  Its filename is
     mm-damon-core-remove-unnecessary-error-messages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-core-remove-unnecessary-error-messages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-core-remove-unnecessary-error-messages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: remove unnecessary error messages

DAMON core prints error messages when damon_target object creation is
failed or wrong monitoring attributes are given.  Because appropriate
error code is returned for each case, the messages are not essential. 
Also, because the code path can be triggered with user-specified input,
this could result in kernel log mistakenly being messy.  To avoid the
case, this commit removes the messages.

Link: https://lkml.kernel.org/r/20211201150440.1088-4-sj@kernel.org
Fixes: 4bc05954d007 ("mm/damon: implement a debugfs-based user space interface")
Fixes: b9a6ac4e4ede ("mm/damon: adaptively adjust regions")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-remove-unnecessary-error-messages
+++ a/mm/damon/core.c
@@ -282,7 +282,6 @@ int damon_set_targets(struct damon_ctx *
 	for (i = 0; i < nr_ids; i++) {
 		t = damon_new_target(ids[i]);
 		if (!t) {
-			pr_err("Failed to alloc damon_target\n");
 			/* The caller should do cleanup of the ids itself */
 			damon_for_each_target_safe(t, next, ctx)
 				damon_destroy_target(t);
@@ -312,16 +311,10 @@ int damon_set_attrs(struct damon_ctx *ct
 		    unsigned long aggr_int, unsigned long primitive_upd_int,
 		    unsigned long min_nr_reg, unsigned long max_nr_reg)
 {
-	if (min_nr_reg < 3) {
-		pr_err("min_nr_regions (%lu) must be at least 3\n",
-				min_nr_reg);
+	if (min_nr_reg < 3)
 		return -EINVAL;
-	}
-	if (min_nr_reg > max_nr_reg) {
-		pr_err("invalid nr_regions.  min (%lu) > max (%lu)\n",
-				min_nr_reg, max_nr_reg);
+	if (min_nr_reg > max_nr_reg)
 		return -EINVAL;
-	}
 
 	ctx->sample_interval = sample_int;
 	ctx->aggr_interval = aggr_int;
_

Patches currently in -mm which might be from sj@kernel.org are

timers-implement-usleep_idle_range.patch
mm-damon-core-fix-fake-load-reports-due-to-uninterruptible-sleeps.patch
mm-damon-core-use-better-timer-mechanisms-selection-threshold.patch
mm-damon-dbgfs-remove-an-unnecessary-error-message.patch
mm-damon-core-remove-unnecessary-error-messages.patch
mm-damon-vaddr-remove-an-unnecessary-warning-message.patch
mm-damon-vaddr-test-split-a-test-function-having-1024-bytes-frame-size.patch
mm-damon-vaddr-test-remove-unnecessary-variables.patch
selftests-damon-skip-test-if-damon-is-running.patch
selftests-damon-test-damon-enabling-with-empty-target_ids-case.patch
selftests-damon-test-wrong-damos-condition-ranges-input.patch
selftests-damon-test-debugfs-file-reads-writes-with-huge-count.patch
selftests-damon-split-test-cases.patch
mm-damon-remove-some-no-need-func-definitions-in-damonh-file-fix.patch

