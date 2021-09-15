Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D295CC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 03:35:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC02861242
	for <mm-commits@archiver.kernel.org>; Wed, 15 Sep 2021 03:35:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbhIODgu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Sep 2021 23:36:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229980AbhIODgt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Sep 2021 23:36:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C6026113E;
        Wed, 15 Sep 2021 03:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631676931;
        bh=/FZJE+aiOGDdI40U51ZjARv0dvDFzUD3Zwu40N26/14=;
        h=Date:From:To:Subject:From;
        b=PIfoJ5ZjxkgZs+LB0I3XKqA7u1+SPtJtKYHig8wOGyZjJ//L3MbhCfovy5nr5FgYs
         yL/fGOYqKUi+dWDSsPPEW1iJbGRJVUcukJjY1LilTw5GixwpEQw0B/iDmBzAV8l6xJ
         byWQKiOF+DlvPIE/1snNR0/FL93FcGk/3zKQbTBs=
Date:   Tue, 14 Sep 2021 20:35:31 -0700
From:   akpm@linux-foundation.org
To:     kilobyte@angband.pl, mm-commits@vger.kernel.org,
        sj38.park@gmail.com
Subject:  +
 mm-damon-dont-use-strnlen-with-known-bogus-source-length.patch added to -mm
 tree
Message-ID: <20210915033531.IdrhacHQk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: don't use strnlen() with known-bogus source length
has been added to the -mm tree.  Its filename is
     mm-damon-dont-use-strnlen-with-known-bogus-source-length.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-dont-use-strnlen-with-known-bogus-source-length.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-dont-use-strnlen-with-known-bogus-source-length.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from kilobyte@angband.pl are

mm-damon-dont-use-strnlen-with-known-bogus-source-length.patch

