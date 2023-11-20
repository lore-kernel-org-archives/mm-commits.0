Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FD1CC2BB3F
	for <mm-commits@archiver.kernel.org>; Mon, 20 Nov 2023 20:13:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjKTUNf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Nov 2023 15:13:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjKTUNe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2023 15:13:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E4CCC
        for <mm-commits@vger.kernel.org>; Mon, 20 Nov 2023 12:13:31 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E12C433C7;
        Mon, 20 Nov 2023 20:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700511210;
        bh=HKPK9G2UufCGaDNARaDvMc40FXc58638jJSncDXAC/c=;
        h=Date:To:From:Subject:From;
        b=UHI3m/WIbAwMB8AOSGzmvbKUn2Ch44tFBqymbZoXZXYx6kkV5C2fMEWwxBflXvsfS
         qGvAGmxqnADbb2FAESlEcfz+DEX97YW91x+G9TKKIsmZLzp3D2YO7kkvGwQT432Kt5
         kiay4o9//frjD+a+97aHlLp0U+dBIqB+F/H1q3i0=
Date:   Mon, 20 Nov 2023 12:13:30 -0800
To:     mm-commits@vger.kernel.org, davidgow@google.com,
        brendanhiggins@google.com, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-test-test-damon_split_region_ats-access-rate-copying.patch added to mm-unstable branch
Message-Id: <20231120201330.D1E12C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core-test: test damon_split_region_at()'s access rate copying
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-test-test-damon_split_region_ats-access-rate-copying.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-test-test-damon_split_region_ats-access-rate-copying.patch

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
Subject: mm/damon/core-test: test damon_split_region_at()'s access rate copying
Date: Sun, 19 Nov 2023 17:15:29 +0000

damon_split_region_at() should set access rate related fields of the
resulting regions same.  It may forgotten, and actually there was the
mistake before.  Test it with the unit test case for the function.

Link: https://lkml.kernel.org/r/20231119171529.66863-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core-test.h |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/mm/damon/core-test.h~mm-damon-core-test-test-damon_split_region_ats-access-rate-copying
+++ a/mm/damon/core-test.h
@@ -122,18 +122,25 @@ static void damon_test_split_at(struct k
 {
 	struct damon_ctx *c = damon_new_ctx();
 	struct damon_target *t;
-	struct damon_region *r;
+	struct damon_region *r, *r_new;
 
 	t = damon_new_target();
 	r = damon_new_region(0, 100);
+	r->nr_accesses_bp = 420000;
+	r->nr_accesses = 42;
+	r->last_nr_accesses = 15;
 	damon_add_region(r, t);
 	damon_split_region_at(t, r, 25);
 	KUNIT_EXPECT_EQ(test, r->ar.start, 0ul);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 25ul);
 
-	r = damon_next_region(r);
-	KUNIT_EXPECT_EQ(test, r->ar.start, 25ul);
-	KUNIT_EXPECT_EQ(test, r->ar.end, 100ul);
+	r_new = damon_next_region(r);
+	KUNIT_EXPECT_EQ(test, r_new->ar.start, 25ul);
+	KUNIT_EXPECT_EQ(test, r_new->ar.end, 100ul);
+
+	KUNIT_EXPECT_EQ(test, r->nr_accesses_bp, r_new->nr_accesses_bp);
+	KUNIT_EXPECT_EQ(test, r->nr_accesses, r_new->nr_accesses);
+	KUNIT_EXPECT_EQ(test, r->last_nr_accesses, r_new->last_nr_accesses);
 
 	damon_free_target(t);
 	damon_destroy_ctx(c);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-copy-nr_accesses-when-splitting-region.patch
mm-damon-core-test-test-damon_split_region_ats-access-rate-copying.patch

