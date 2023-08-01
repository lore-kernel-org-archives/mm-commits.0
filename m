Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF0B9C00528
	for <mm-commits@archiver.kernel.org>; Tue,  1 Aug 2023 19:08:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjHATIE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Aug 2023 15:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232351AbjHATH7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Aug 2023 15:07:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 464E7DF
        for <mm-commits@vger.kernel.org>; Tue,  1 Aug 2023 12:07:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D62156169A
        for <mm-commits@vger.kernel.org>; Tue,  1 Aug 2023 19:07:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B51C433C7;
        Tue,  1 Aug 2023 19:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690916877;
        bh=9t89dvn4urstuncOgt6IDdpq8yo8bFex0EAUDbJizYI=;
        h=Date:To:From:Subject:From;
        b=nYLUQFT0d+gy4Vkhnn73nH7dWAXKnPQB7cFMkxm/5X68wXc7GMO5tSYWkmZ70otod
         M5IdTNZysUIt0azq+Dtc5krK/aoQnuCxfXQD+dT52nYFu5S2Tge39nxSceIIjRHG+N
         kzwGLNGLU681pz0n6HQhAcJ7J3mbu7lihj1Db9u0=
Date:   Tue, 01 Aug 2023 12:07:56 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-test-add-a-test-for-damos_new_filter.patch added to mm-unstable branch
Message-Id: <20230801190757.37B51C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core-test: add a test for damos_new_filter()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-test-add-a-test-for-damos_new_filter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-test-add-a-test-for-damos_new_filter.patch

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
Subject: mm/damon/core-test: add a test for damos_new_filter()
Date: Sat, 29 Jul 2023 20:37:33 +0000

damos_new_filter() was having a bug that not initializing ->list field of
the returning damos_filter struct, which results in access to
uninitialized memory.  Add a unit test for the function.

Link: https://lkml.kernel.org/r/20230729203733.38949-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core-test.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/mm/damon/core-test.h~mm-damon-core-test-add-a-test-for-damos_new_filter
+++ a/mm/damon/core-test.h
@@ -341,6 +341,18 @@ static void damon_test_set_attrs(struct
 	KUNIT_EXPECT_EQ(test, damon_set_attrs(c, &invalid_attrs), -EINVAL);
 }
 
+static void damos_test_new_filter(struct kunit *test)
+{
+	struct damos_filter *filter;
+
+	filter = damos_new_filter(DAMOS_FILTER_TYPE_ANON, true);
+	KUNIT_EXPECT_EQ(test, filter->type, DAMOS_FILTER_TYPE_ANON);
+	KUNIT_EXPECT_EQ(test, filter->matching, true);
+	KUNIT_EXPECT_PTR_EQ(test, filter->list.prev, &filter->list);
+	KUNIT_EXPECT_PTR_EQ(test, filter->list.next, &filter->list);
+	damos_destroy_filter(filter);
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -353,6 +365,7 @@ static struct kunit_case damon_test_case
 	KUNIT_CASE(damon_test_set_regions),
 	KUNIT_CASE(damon_test_update_monitoring_result),
 	KUNIT_CASE(damon_test_set_attrs),
+	KUNIT_CASE(damos_test_new_filter),
 	{},
 };
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-initialize-damo_filter-list-from-damos_new_filter.patch
mm-damon-core-test-add-a-test-for-damos_new_filter.patch

