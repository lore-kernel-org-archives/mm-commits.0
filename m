Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B755FC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 28 Oct 2021 19:36:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BA41610CB
	for <mm-commits@archiver.kernel.org>; Thu, 28 Oct 2021 19:36:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbhJ1TjH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Oct 2021 15:39:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230412AbhJ1TjG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 28 Oct 2021 15:39:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81B5C610FC;
        Thu, 28 Oct 2021 19:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635449799;
        bh=K6d/sGSic7KKttQo815ZbOg6l+XRKgM6295KxC9HAts=;
        h=Date:From:To:Subject:From;
        b=oiYCq9VYnKyZok8GWfJ4WloDK/TLtzO8afqjJHoQWNM+DG/os+N17NOKRfRU3Xri6
         qbwzatdU5wtpQMd26yTkPi4Hfxw7M+54P6Zua3CuHfB5z7ZANoCaIXbIj+NIfPNOrQ
         ZdOW685GKvh7ewIcIzcPH+cJ5yF6R1gtlmgbpUWM=
Date:   Thu, 28 Oct 2021 12:36:39 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org
Subject:  +
 mm-damon-core-test-fix-wrong-expectations-for-damon_split_regions_of.patch
 added to -mm tree
Message-ID: <20211028193639.ey--jUTOB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core-test: fix wrong expectations for 'damon_split_regions_of()'
has been added to the -mm tree.  Its filename is
     mm-damon-core-test-fix-wrong-expectations-for-damon_split_regions_of.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-core-test-fix-wrong-expectations-for-damon_split_regions_of.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-core-test-fix-wrong-expectations-for-damon_split_regions_of.patch

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
Subject: mm/damon/core-test: fix wrong expectations for 'damon_split_regions_of()'

Kunit test cases for 'damon_split_regions_of()' expects the number of
regions after calling the function will be same to their request
('nr_sub').  However, the requested number is just an upper-limit, because
the function randomly decides the size of each sub-region.  This commit
fixes the wrong expectation.

Link: https://lkml.kernel.org/r/20211028090628.14948-1-sj@kernel.org
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core-test.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/damon/core-test.h~mm-damon-core-test-fix-wrong-expectations-for-damon_split_regions_of
+++ a/mm/damon/core-test.h
@@ -219,14 +219,14 @@ static void damon_test_split_regions_of(
 	r = damon_new_region(0, 22);
 	damon_add_region(r, t);
 	damon_split_regions_of(c, t, 2);
-	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 2u);
+	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 2u);
 	damon_free_target(t);
 
 	t = damon_new_target(42);
 	r = damon_new_region(0, 220);
 	damon_add_region(r, t);
 	damon_split_regions_of(c, t, 4);
-	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 4u);
+	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 4u);
 	damon_free_target(t);
 	damon_destroy_ctx(c);
 }
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-test-fix-wrong-expectations-for-damon_split_regions_of.patch
maintainers-update-seongjaes-email-address.patch
mm-damon-core-print-kdamond-start-log-in-debug-mode-only.patch
mm-damon-core-account-age-of-target-regions.patch
mm-damon-core-implement-damon-based-operation-schemes-damos.patch
mm-damon-vaddr-support-damon-based-operation-schemes.patch
mm-damon-dbgfs-support-damon-based-operation-schemes.patch
mm-damon-schemes-implement-statistics-feature.patch
selftests-damon-add-schemes-debugfs-tests.patch
docs-admin-guide-mm-damon-document-damon-based-operation-schemes.patch
mm-damon-dbgfs-allow-users-to-set-initial-monitoring-target-regions.patch
mm-damon-dbgfs-test-add-a-unit-test-case-for-init_regions.patch
docs-admin-guide-mm-damon-document-init_regions-feature.patch
mm-damon-vaddr-separate-commonly-usable-functions.patch
mm-damon-vaddr-separate-commonly-usable-functions-fix.patch
mm-damon-implement-primitives-for-physical-address-space-monitoring.patch
mm-damon-dbgfs-support-physical-memory-monitoring.patch
docs-damon-document-physical-memory-monitoring-support.patch
mm-damon-paddr-support-the-pageout-scheme.patch
mm-damon-paddr-support-the-pageout-scheme-fix.patch
mm-damon-schemes-implement-size-quota-for-schemes-application-speed-control.patch
mm-damon-schemes-skip-already-charged-targets-and-regions.patch
mm-damon-schemes-implement-time-quota.patch
mm-damon-dbgfs-support-quotas-of-schemes.patch
mm-damon-selftests-support-schemes-quotas.patch
mm-damon-schemes-prioritize-regions-within-the-quotas.patch
mm-damon-vaddrpaddr-support-pageout-prioritization.patch
mm-damon-dbgfs-support-prioritization-weights.patch
tools-selftests-damon-update-for-regions-prioritization-of-schemes.patch
mm-damon-schemes-activate-schemes-based-on-a-watermarks-mechanism.patch
mm-damon-dbgfs-support-watermarks.patch
selftests-damon-support-watermarks.patch
mm-damon-introduce-damon-based-reclamation-damon_reclaim.patch
documentation-admin-guide-mm-damon-add-a-document-for-damon_reclaim.patch
docs-admin-guide-mm-damon-start-fix-wrong-example-commands.patch
docs-admin-guide-mm-damon-start-fix-a-wrong-link.patch
docs-admin-guide-mm-damon-start-simplify-the-content.patch
docs-admin-guide-mm-pagemap-wordsmith-page-flags-descriptions.patch

