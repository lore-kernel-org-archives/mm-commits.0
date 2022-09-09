Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 058BFECAAD5
	for <mm-commits@archiver.kernel.org>; Fri,  9 Sep 2022 21:30:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiIIVad (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Sep 2022 17:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbiIIVac (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2022 17:30:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78AE275CF1
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 14:30:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B5D9620D6
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 21:30:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF07C433D6;
        Fri,  9 Sep 2022 21:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662759030;
        bh=c36BIQPwlp3QYKjTNzef9IjjKYHi9iFHgOU7/4Fk9ic=;
        h=Date:To:From:Subject:From;
        b=1vcz2G31kPqJCHfAVcSM7RXSiWs0bA6YFz/t09YsMKWmNmgx9MwlQkYwXtQOHeHDx
         YrRznJAPauEHnixEWsjslW6m36dBFxII1g45Ol/A5tLHLjSv7LnCe7RTyRXoh3Yecb
         jCG+Y8wlX4a1bD1/snjYhfmuedY0M7yCuxrpMpNI=
Date:   Fri, 09 Sep 2022 14:30:29 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, ppbuk5246@gmail.com,
        corbet@lwn.net, brendanhiggins@google.com, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-test-test-damon_set_regions.patch added to mm-unstable branch
Message-Id: <20220909213030.5DF07C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core-test: test damon_set_regions
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-test-test-damon_set_regions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-test-test-damon_set_regions.patch

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
Subject: mm/damon/core-test: test damon_set_regions
Date: Fri, 9 Sep 2022 20:28:57 +0000

Preceding commit fixes a bug in 'damon_set_regions()', which allows holes
in the new monitoring target ranges.  This commit adds a kunit test case
for the problem to avoid any regression.

Link: https://lkml.kernel.org/r/20220909202901.57977-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yun Levi <ppbuk5246@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core-test.h |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/mm/damon/core-test.h~mm-damon-core-test-test-damon_set_regions
+++ a/mm/damon/core-test.h
@@ -267,6 +267,28 @@ static void damon_test_ops_registration(
 	KUNIT_EXPECT_EQ(test, damon_register_ops(&ops), -EINVAL);
 }
 
+static void damon_test_set_regions(struct kunit *test)
+{
+	struct damon_target *t = damon_new_target();
+	struct damon_region *r1 = damon_new_region(4, 16);
+	struct damon_region *r2 = damon_new_region(24, 32);
+	struct damon_addr_range range = {.start = 8, .end = 28};
+	unsigned long expects[] = {8, 16, 16, 24, 24, 28};
+	int expect_idx = 0;
+	struct damon_region *r;
+
+	damon_add_region(r1, t);
+	damon_add_region(r2, t);
+	damon_set_regions(t, &range, 1);
+
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 3);
+	damon_for_each_region(r, t) {
+		KUNIT_EXPECT_EQ(test, r->ar.start, expects[expect_idx++]);
+		KUNIT_EXPECT_EQ(test, r->ar.end, expects[expect_idx++]);
+	}
+	damon_destroy_target(t);
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -276,6 +298,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damon_test_merge_regions_of),
 	KUNIT_CASE(damon_test_split_regions_of),
 	KUNIT_CASE(damon_test_ops_registration),
+	KUNIT_CASE(damon_test_set_regions),
 	{},
 };
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix.patch
selftest-damon-add-a-test-for-duplicate-context-dirs-creation.patch
mm-damon-core-avoid-holes-in-newly-set-monitoring-target-ranges.patch
mm-damon-core-test-test-damon_set_regions.patch
docs-admin-guide-mm-damon-rename-the-title-of-the-document.patch
mm-damon-kconfig-notify-debugfs-deprecation-plan.patch
docs-admin-guide-mm-damon-start-mention-the-dependency-as-sysfs-instead-of-debugfs.patch
docs-admin-guide-mm-damon-usage-note-damon-debugfs-interface-deprecation-plan.patch

