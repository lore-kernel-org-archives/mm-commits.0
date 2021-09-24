Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2AC8C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 22:43:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5129610C7
	for <mm-commits@archiver.kernel.org>; Fri, 24 Sep 2021 22:43:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237813AbhIXWpF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Sep 2021 18:45:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:43316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229669AbhIXWpA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Sep 2021 18:45:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEC44610F7;
        Fri, 24 Sep 2021 22:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632523407;
        bh=uWwxeLdlOGjaTzqH97Y4wiX9ndCY9tuHs3E3OZZlPkg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=iHNHVFG5aL3D8oguHZ8B1fUBb79iBGsZr3+BjfiMYx9nGNMANynZeUFjU27jQzwD7
         dxInDa3XNdpuzczMnUCcujhOHbuzWHBYU2gxhVGJ3t8yUd6zAmMsQQdeDZnutRX6zF
         rywYJKdF+wDy+gRe8BTmZTnVZI+ojb9ttQIpuGb8=
Date:   Fri, 24 Sep 2021 15:43:26 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, kilobyte@angband.pl, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sj38.park@gmail.com,
        torvalds@linux-foundation.org
Subject:  [patch 03/16] mm/damon: don't use strnlen() with
 known-bogus source length
Message-ID: <20210924224326.LWI0zk_0G%akpm@linux-foundation.org>
In-Reply-To: <20210924154257.1dbf6699ab8d88c0460f924f@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Adam Borowski <kilobyte@angband.pl>
Subject: mm/damon: don't use strnlen() with known-bogus source length

gcc knows the true length too, and rightfully complains.

Link: https://lkml.kernel.org/r/20210912204447.10427-1-kilobyte@angband.pl
Signed-off-by: Adam Borowski <kilobyte@angband.pl>
Cc: SeongJae Park <sj38.park@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs-test.h |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/damon/dbgfs-test.h~mm-damon-dont-use-strnlen-with-known-bogus-source-length
+++ a/mm/damon/dbgfs-test.h
@@ -20,27 +20,27 @@ static void damon_dbgfs_test_str_to_targ
 	ssize_t nr_integers = 0, i;
 
 	question = "123";
-	answers = str_to_target_ids(question, strnlen(question, 128),
+	answers = str_to_target_ids(question, strlen(question),
 			&nr_integers);
 	KUNIT_EXPECT_EQ(test, (ssize_t)1, nr_integers);
 	KUNIT_EXPECT_EQ(test, 123ul, answers[0]);
 	kfree(answers);
 
 	question = "123abc";
-	answers = str_to_target_ids(question, strnlen(question, 128),
+	answers = str_to_target_ids(question, strlen(question),
 			&nr_integers);
 	KUNIT_EXPECT_EQ(test, (ssize_t)1, nr_integers);
 	KUNIT_EXPECT_EQ(test, 123ul, answers[0]);
 	kfree(answers);
 
 	question = "a123";
-	answers = str_to_target_ids(question, strnlen(question, 128),
+	answers = str_to_target_ids(question, strlen(question),
 			&nr_integers);
 	KUNIT_EXPECT_EQ(test, (ssize_t)0, nr_integers);
 	kfree(answers);
 
 	question = "12 35";
-	answers = str_to_target_ids(question, strnlen(question, 128),
+	answers = str_to_target_ids(question, strlen(question),
 			&nr_integers);
 	KUNIT_EXPECT_EQ(test, (ssize_t)2, nr_integers);
 	for (i = 0; i < nr_integers; i++)
@@ -48,7 +48,7 @@ static void damon_dbgfs_test_str_to_targ
 	kfree(answers);
 
 	question = "12 35 46";
-	answers = str_to_target_ids(question, strnlen(question, 128),
+	answers = str_to_target_ids(question, strlen(question),
 			&nr_integers);
 	KUNIT_EXPECT_EQ(test, (ssize_t)3, nr_integers);
 	for (i = 0; i < nr_integers; i++)
@@ -56,7 +56,7 @@ static void damon_dbgfs_test_str_to_targ
 	kfree(answers);
 
 	question = "12 35 abc 46";
-	answers = str_to_target_ids(question, strnlen(question, 128),
+	answers = str_to_target_ids(question, strlen(question),
 			&nr_integers);
 	KUNIT_EXPECT_EQ(test, (ssize_t)2, nr_integers);
 	for (i = 0; i < 2; i++)
@@ -64,13 +64,13 @@ static void damon_dbgfs_test_str_to_targ
 	kfree(answers);
 
 	question = "";
-	answers = str_to_target_ids(question, strnlen(question, 128),
+	answers = str_to_target_ids(question, strlen(question),
 			&nr_integers);
 	KUNIT_EXPECT_EQ(test, (ssize_t)0, nr_integers);
 	kfree(answers);
 
 	question = "\n";
-	answers = str_to_target_ids(question, strnlen(question, 128),
+	answers = str_to_target_ids(question, strlen(question),
 			&nr_integers);
 	KUNIT_EXPECT_EQ(test, (ssize_t)0, nr_integers);
 	kfree(answers);
_
