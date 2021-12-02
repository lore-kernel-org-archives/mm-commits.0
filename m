Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A567AC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Dec 2021 03:42:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355244AbhLBDov (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Dec 2021 22:44:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbhLBDn7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Dec 2021 22:43:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E02C061757
        for <mm-commits@vger.kernel.org>; Wed,  1 Dec 2021 19:40:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5077CB8221B
        for <mm-commits@vger.kernel.org>; Thu,  2 Dec 2021 03:40:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3A2C00446;
        Thu,  2 Dec 2021 03:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638416436;
        bh=25cgr/sZ/Y7c3kAbHJ56pPYFt4rnqEGYm/eztxEKchg=;
        h=Date:From:To:Subject:From;
        b=D9oHDtHDdJyHocBtXkadbWnmJ1b1QTCbChOrM3SegWChikIE7qU95McpzBiuzlNg8
         mPk9d/brGWw7h7qrYOoDNJNU2inC1qOZl4TEP3k0W+wdAcfYbsH2MD4zwtP2nSSQbF
         lePsAkwqmgfbrBu6E1x0qXPnmGWscsvi7+/iLANs=
Date:   Wed, 01 Dec 2021 19:40:35 -0800
From:   akpm@linux-foundation.org
To:     brendanhiggins@google.com, mm-commits@vger.kernel.org,
        shuah@kernel.org, sj@kernel.org
Subject:  + mm-damon-vaddr-test-remove-unnecessary-variables.patch
 added to -mm tree
Message-ID: <20211202034035.GZHvYaNIX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/vaddr-test: remove unnecessary variables
has been added to the -mm tree.  Its filename is
     mm-damon-vaddr-test-remove-unnecessary-variables.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-vaddr-test-remove-unnecessary-variables.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-vaddr-test-remove-unnecessary-variables.patch

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
Subject: mm/damon/vaddr-test: remove unnecessary variables

A couple of test functions in DAMON virtual address space monitoring
primitives implementation has unnecessary damon_ctx variables.  This
commit removes those.

Link: https://lkml.kernel.org/r/20211201150440.1088-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr-test.h |    8 --------
 1 file changed, 8 deletions(-)

--- a/mm/damon/vaddr-test.h~mm-damon-vaddr-test-remove-unnecessary-variables
+++ a/mm/damon/vaddr-test.h
@@ -135,7 +135,6 @@ static void damon_do_test_apply_three_re
 				struct damon_addr_range *three_regions,
 				unsigned long *expected, int nr_expected)
 {
-	struct damon_ctx *ctx = damon_new_ctx();
 	struct damon_target *t;
 	struct damon_region *r;
 	int i;
@@ -145,7 +144,6 @@ static void damon_do_test_apply_three_re
 		r = damon_new_region(regions[i * 2], regions[i * 2 + 1]);
 		damon_add_region(r, t);
 	}
-	damon_add_target(ctx, t);
 
 	damon_va_apply_three_regions(t, three_regions);
 
@@ -154,8 +152,6 @@ static void damon_do_test_apply_three_re
 		KUNIT_EXPECT_EQ(test, r->ar.start, expected[i * 2]);
 		KUNIT_EXPECT_EQ(test, r->ar.end, expected[i * 2 + 1]);
 	}
-
-	damon_destroy_ctx(ctx);
 }
 
 /*
@@ -298,8 +294,6 @@ static void damon_test_split_evenly_succ
 
 static void damon_test_split_evenly(struct kunit *test)
 {
-	struct damon_ctx *c = damon_new_ctx();
-
 	KUNIT_EXPECT_EQ(test, damon_va_evenly_split_region(NULL, NULL, 5),
 			-EINVAL);
 
@@ -307,8 +301,6 @@ static void damon_test_split_evenly(stru
 	damon_test_split_evenly_succ(test, 0, 100, 10);
 	damon_test_split_evenly_succ(test, 5, 59, 5);
 	damon_test_split_evenly_fail(test, 5, 6, 2);
-
-	damon_destroy_ctx(c);
 }
 
 static struct kunit_case damon_test_cases[] = {
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

