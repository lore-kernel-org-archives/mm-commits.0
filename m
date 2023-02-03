Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6CB0C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:42:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232335AbjBCGmy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:42:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232334AbjBCGld (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:41:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE624EF2
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB31461DAA
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:38:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C842C4339C;
        Fri,  3 Feb 2023 06:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406287;
        bh=siWUERszd9kkn7cXXX3lvbrDixbHTaLjhBawBnKWkbE=;
        h=Date:To:From:Subject:From;
        b=PkF/FwB/9dQuFav0V49zLMo3JekJA4W5JaQdBhhH6uPwgcQMlOJSk6HPODxuN5OrA
         o6jGMcQYfd3+LzwRJ1RBkPXMkxajspk+NQZ4a6vU30bR1VM1BZjRu6pjM6/s6eNZMn
         EIcm7T1GYBtDPc4SQsQ0Y0ZJkmkOKi/kUptO0Unc=
Date:   Thu, 02 Feb 2023 22:38:06 -0800
To:     mm-commits@vger.kernel.org, brendanhiggins@google.com,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-test-add-a-test-for-damon_update_monitoring_results.patch removed from -mm tree
Message-Id: <20230203063807.4C842C4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core-test: add a test for damon_update_monitoring_results()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-test-add-a-test-for-damon_update_monitoring_results.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

scripts-spelling-add-a-few-more-typos.patch

