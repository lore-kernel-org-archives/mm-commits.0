Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32B64C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Dec 2021 03:41:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355231AbhLBDoo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Dec 2021 22:44:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355244AbhLBDn7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Dec 2021 22:43:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0AE8C061756
        for <mm-commits@vger.kernel.org>; Wed,  1 Dec 2021 19:40:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 681E3B8221B
        for <mm-commits@vger.kernel.org>; Thu,  2 Dec 2021 03:40:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE37AC00446;
        Thu,  2 Dec 2021 03:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638416433;
        bh=XKEODUbBsxKp66cg3+YT3WOjc1ytk56BKM6BavY1wy0=;
        h=Date:From:To:Subject:From;
        b=xIGYysWdtl8AVRbhiQUbvrsRX15F9OS93JiqRtpobzktiyZ6fRVhHsl+XsJS/Ak+t
         7a/wxGyZJ4dFeaReYL49gKUFjUmfC8MNLdMBioAQzeTODDzO4v2YdCwQCkCap+dFrh
         5842/VhTffQHxlHlCgZUspdyCjucHILHwCo4Ff/s=
Date:   Wed, 01 Dec 2021 19:40:32 -0800
From:   akpm@linux-foundation.org
To:     brendanhiggins@google.com, lkp@intel.com,
        mm-commits@vger.kernel.org, shuah@kernel.org, sj@kernel.org
Subject:  +
 =?US-ASCII?Q?mm-damon-vaddr-test-split-a-test-function-having-1024-bytes-?=
 =?US-ASCII?Q?frame-size.patch?= added to -mm tree
Message-ID: <20211202034032.gJBsiD0Hu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/vaddr-test: split a test function having >1024 bytes frame size
has been added to the -mm tree.  Its filename is
     mm-damon-vaddr-test-split-a-test-function-having-1024-bytes-frame-size.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-vaddr-test-split-a-test-function-having-1024-bytes-frame-size.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-vaddr-test-split-a-test-function-having-1024-bytes-frame-size.patch

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
Subject: mm/damon/vaddr-test: split a test function having >1024 bytes frame size

On some configuration[1], 'damon_test_split_evenly()' kunit test function
has >1024 bytes frame size, so below build warning is triggered:

      CC      mm/damon/vaddr.o
    In file included from mm/damon/vaddr.c:672:
    mm/damon/vaddr-test.h: In function 'damon_test_split_evenly':
    mm/damon/vaddr-test.h:309:1: warning: the frame size of 1064 bytes is larger than 1024 bytes [-Wframe-larger-than=]
      309 | }
          | ^

This commit fixes the warning by separating the common logic in the
function.

[1] https://lore.kernel.org/linux-mm/202111182146.OV3C4uGr-lkp@intel.com/

Link: https://lkml.kernel.org/r/20211201150440.1088-6-sj@kernel.org
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr-test.h |   77 ++++++++++++++++++++--------------------
 1 file changed, 40 insertions(+), 37 deletions(-)

--- a/mm/damon/vaddr-test.h~mm-damon-vaddr-test-split-a-test-function-having-1024-bytes-frame-size
+++ a/mm/damon/vaddr-test.h
@@ -252,59 +252,62 @@ static void damon_test_apply_three_regio
 			new_three_regions, expected, ARRAY_SIZE(expected));
 }
 
-static void damon_test_split_evenly(struct kunit *test)
+static void damon_test_split_evenly_fail(struct kunit *test,
+		unsigned long start, unsigned long end, unsigned int nr_pieces)
 {
-	struct damon_ctx *c = damon_new_ctx();
-	struct damon_target *t;
-	struct damon_region *r;
-	unsigned long i;
-
-	KUNIT_EXPECT_EQ(test, damon_va_evenly_split_region(NULL, NULL, 5),
-			-EINVAL);
-
-	t = damon_new_target(42);
-	r = damon_new_region(0, 100);
-	KUNIT_EXPECT_EQ(test, damon_va_evenly_split_region(t, r, 0), -EINVAL);
+	struct damon_target *t = damon_new_target(42);
+	struct damon_region *r = damon_new_region(start, end);
 
 	damon_add_region(r, t);
-	KUNIT_EXPECT_EQ(test, damon_va_evenly_split_region(t, r, 10), 0);
-	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 10u);
+	KUNIT_EXPECT_EQ(test,
+			damon_va_evenly_split_region(t, r, nr_pieces), -EINVAL);
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1u);
 
-	i = 0;
 	damon_for_each_region(r, t) {
-		KUNIT_EXPECT_EQ(test, r->ar.start, i++ * 10);
-		KUNIT_EXPECT_EQ(test, r->ar.end, i * 10);
+		KUNIT_EXPECT_EQ(test, r->ar.start, start);
+		KUNIT_EXPECT_EQ(test, r->ar.end, end);
 	}
+
 	damon_free_target(t);
+}
+
+static void damon_test_split_evenly_succ(struct kunit *test,
+	unsigned long start, unsigned long end, unsigned int nr_pieces)
+{
+	struct damon_target *t = damon_new_target(42);
+	struct damon_region *r = damon_new_region(start, end);
+	unsigned long expected_width = (end - start) / nr_pieces;
+	unsigned long i = 0;
 
-	t = damon_new_target(42);
-	r = damon_new_region(5, 59);
 	damon_add_region(r, t);
-	KUNIT_EXPECT_EQ(test, damon_va_evenly_split_region(t, r, 5), 0);
-	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 5u);
+	KUNIT_EXPECT_EQ(test,
+			damon_va_evenly_split_region(t, r, nr_pieces), 0);
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), nr_pieces);
 
-	i = 0;
 	damon_for_each_region(r, t) {
-		if (i == 4)
+		if (i == nr_pieces - 1)
 			break;
-		KUNIT_EXPECT_EQ(test, r->ar.start, 5 + 10 * i++);
-		KUNIT_EXPECT_EQ(test, r->ar.end, 5 + 10 * i);
+		KUNIT_EXPECT_EQ(test,
+				r->ar.start, start + i++ * expected_width);
+		KUNIT_EXPECT_EQ(test, r->ar.end, start + i * expected_width);
 	}
-	KUNIT_EXPECT_EQ(test, r->ar.start, 5 + 10 * i);
-	KUNIT_EXPECT_EQ(test, r->ar.end, 59ul);
+	KUNIT_EXPECT_EQ(test, r->ar.start, start + i * expected_width);
+	KUNIT_EXPECT_EQ(test, r->ar.end, end);
 	damon_free_target(t);
+}
 
-	t = damon_new_target(42);
-	r = damon_new_region(5, 6);
-	damon_add_region(r, t);
-	KUNIT_EXPECT_EQ(test, damon_va_evenly_split_region(t, r, 2), -EINVAL);
-	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1u);
+static void damon_test_split_evenly(struct kunit *test)
+{
+	struct damon_ctx *c = damon_new_ctx();
+
+	KUNIT_EXPECT_EQ(test, damon_va_evenly_split_region(NULL, NULL, 5),
+			-EINVAL);
+
+	damon_test_split_evenly_fail(test, 0, 100, 0);
+	damon_test_split_evenly_succ(test, 0, 100, 10);
+	damon_test_split_evenly_succ(test, 5, 59, 5);
+	damon_test_split_evenly_fail(test, 5, 6, 2);
 
-	damon_for_each_region(r, t) {
-		KUNIT_EXPECT_EQ(test, r->ar.start, 5ul);
-		KUNIT_EXPECT_EQ(test, r->ar.end, 6ul);
-	}
-	damon_free_target(t);
 	damon_destroy_ctx(c);
 }
 
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

