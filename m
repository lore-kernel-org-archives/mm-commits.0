Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1154CC46467
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 22:53:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbjASWx1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Jan 2023 17:53:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbjASWxB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2023 17:53:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD0ADA10B
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 14:35:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 156A160CF5
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 22:34:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7D9C433D2;
        Thu, 19 Jan 2023 22:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674167666;
        bh=b6XoSDSntp7yFv5vy4gmR4jYcrBv5Sq/ZlznANiAksk=;
        h=Date:To:From:Subject:From;
        b=c4lTJaaR5ijFt4qwkYYSNKpM5iNg0UlSYukpiH6VQPSNGbaGhZXsJo/XYPqr5/WjU
         PUHjiLcHfjhQZE2UkMbBc8NDlLTYMK/OaUlBdrv+ebhnzVQTw377EbB2+OZBXthfBn
         2ytq7n8ME5c4zAdqAWo8o/wyJF3rXYVZspE6wIdY=
Date:   Thu, 19 Jan 2023 14:34:25 -0800
To:     mm-commits@vger.kernel.org, brendanhiggins@google.com,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-test-add-a-test-for-damon_update_monitoring_results.patch added to mm-unstable branch
Message-Id: <20230119223426.6F7D9C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core-test: add a test for damon_update_monitoring_results()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-test-add-a-test-for-damon_update_monitoring_results.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-test-add-a-test-for-damon_update_monitoring_results.patch

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
Subject: mm/damon/core-test: add a test for damon_update_monitoring_results()
Date: Thu, 19 Jan 2023 01:38:31 +0000

Add a simple unit test for damon_update_monitoring_results() function.

Link: https://lkml.kernel.org/r/20230119013831.1911-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/damon/core-test.h~mm-damon-core-test-add-a-test-for-damon_update_monitoring_results
+++ a/mm/damon/core-test.h
@@ -289,6 +289,35 @@ static void damon_test_set_regions(struc
 	damon_destroy_target(t);
 }
 
+static void damon_test_update_monitoring_result(struct kunit *test)
+{
+	struct damon_attrs old_attrs = {
+		.sample_interval = 10, .aggr_interval = 1000,};
+	struct damon_attrs new_attrs;
+	struct damon_region *r = damon_new_region(3, 7);
+
+	r->nr_accesses = 15;
+	r->age = 20;
+
+	new_attrs = (struct damon_attrs){
+		.sample_interval = 100, .aggr_interval = 10000,};
+	damon_update_monitoring_result(r, &old_attrs, &new_attrs);
+	KUNIT_EXPECT_EQ(test, r->nr_accesses, 15);
+	KUNIT_EXPECT_EQ(test, r->age, 2);
+
+	new_attrs = (struct damon_attrs){
+		.sample_interval = 1, .aggr_interval = 1000};
+	damon_update_monitoring_result(r, &old_attrs, &new_attrs);
+	KUNIT_EXPECT_EQ(test, r->nr_accesses, 150);
+	KUNIT_EXPECT_EQ(test, r->age, 2);
+
+	new_attrs = (struct damon_attrs){
+		.sample_interval = 1, .aggr_interval = 100};
+	damon_update_monitoring_result(r, &old_attrs, &new_attrs);
+	KUNIT_EXPECT_EQ(test, r->nr_accesses, 150);
+	KUNIT_EXPECT_EQ(test, r->age, 20);
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -299,6 +328,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damon_test_split_regions_of),
 	KUNIT_CASE(damon_test_ops_registration),
 	KUNIT_CASE(damon_test_set_regions),
+	KUNIT_CASE(damon_test_update_monitoring_result),
 	{},
 };
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-update-kernel-doc-comments-for-damos-action-supports-of-each-damon-operations-set.patch
mm-damon-core-update-kernel-doc-comments-for-damos-filters-supports-of-each-damon-operations-set.patch
docs-mm-damon-index-mention-damos-on-the-intro.patch
docs-admin-guide-mm-damon-usage-update-damos-actions-filters-supports-of-each-damon-operations-set.patch
docs-mm-damon-add-a-maintainer-profile-for-damon.patch
maintainers-damon-link-maintainer-profile-git-trees-and-website.patch
selftests-damon-sysfs-hide-expected-write-failures.patch
selftests-damon-debugfs_rm_non_contexts-hide-expected-write-error-messages.patch
mm-damon-update-comments-in-damonh-for-damon_attrs.patch
mm-damon-core-update-monitoring-results-for-new-monitoring-attributes.patch
mm-damon-core-test-add-a-test-for-damon_update_monitoring_results.patch
scripts-spelling-add-a-few-more-typos.patch

