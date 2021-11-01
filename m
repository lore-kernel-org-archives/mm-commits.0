Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02557C43219
	for <mm-commits@archiver.kernel.org>; Mon,  1 Nov 2021 18:25:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7468610FD
	for <mm-commits@archiver.kernel.org>; Mon,  1 Nov 2021 18:25:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231983AbhKAS1e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 1 Nov 2021 14:27:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:45486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232001AbhKAS1K (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Nov 2021 14:27:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 918B860F70;
        Mon,  1 Nov 2021 18:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635791064;
        bh=Ubi1z7k59QwQo/PD6WxOzYXnhR+29kW0ZuDag1+2hY8=;
        h=Date:From:To:Subject:From;
        b=Q67f0IvVKt/zUAP1Fr/LN4vNG2srZHsZtwqO5djg96GENbLPmpqOyg4auYgBAujSM
         0IoPMzlt3BzjfMY6dwTt5iuPd0kMU6Xg/5d8QtAGlrOK/otzYqy1WgXlxHbQe6OE8B
         xbzPtwfK1gajFeH3Fg4JON64RZDIhyg0zQQj80M8=
Date:   Mon, 01 Nov 2021 11:24:24 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org
Subject:  [merged]
 mm-damon-core-test-fix-wrong-expectations-for-damon_split_regions_of.patch
 removed from -mm tree
Message-ID: <20211101182424.L5Jqxm452%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core-test: fix wrong expectations for 'damon_split_regions_of()'
has been removed from the -mm tree.  Its filename was
     mm-damon-core-test-fix-wrong-expectations-for-damon_split_regions_of.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

