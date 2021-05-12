Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8C2FC433B4
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 22:39:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9C3B61417
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 22:39:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbhELWkJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 May 2021 18:40:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:57810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233460AbhELWVR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 May 2021 18:21:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9C2860FE5;
        Wed, 12 May 2021 22:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620858005;
        bh=kaOlvZRuQqNOTiuW1pvlWwcQeuBSpDv5QY5wpHofhdg=;
        h=Date:From:To:Subject:From;
        b=b8sTEHZq4GTmyTJDBJkORPRWdmci6N+uOUBhZ7x0WWPJCLxwTJY7ZbW2KR2neB1xw
         aGhKd/98Wtq+VVDpXxUS5Pt2VGBl/Se+DwQ/E7oJUKQ2QdfYIpf1EgH7UkoAWC+xV0
         RU2aPx70wSzr6vZGYLa6YaXY9ot2sbcuWxzt5vNg=
Date:   Wed, 12 May 2021 15:20:05 -0700
From:   akpm@linux-foundation.org
To:     elver@google.com, glittao@gmail.com, mm-commits@vger.kernel.org
Subject:  +
 mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix.patch
 added to -mm tree
Message-ID: <20210512222005.n58XqC8Gn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub, kunit: add a KUnit test for SLUB debugging functionality-fix
has been added to the -mm tree.  Its filename is
     mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oliver Glitta <glittao@gmail.com>
Subject: mm/slub, kunit: add a KUnit test for SLUB debugging functionality-fix

Remove unused function test_exit(), from SLUB KUnit test.

Link: https://lkml.kernel.org/r/20210512140656.12083-1-glittao@gmail.com
Signed-off-by: Oliver Glitta <glittao@gmail.com>
Reported-by: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/slub_kunit.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/lib/slub_kunit.c~mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix
+++ a/lib/slub_kunit.c
@@ -129,8 +129,6 @@ static int test_init(struct kunit *test)
 	return 0;
 }
 
-static void test_exit(struct kunit *test) {}
-
 static struct kunit_case test_cases[] = {
 	KUNIT_CASE(test_clobber_zone),
 
@@ -147,7 +145,6 @@ static struct kunit_case test_cases[] =
 static struct kunit_suite test_suite = {
 	.name = "slub_test",
 	.init = test_init,
-	.exit = test_exit,
 	.test_cases = test_cases,
 };
 kunit_test_suite(test_suite);
_

Patches currently in -mm which might be from glittao@gmail.com are

mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality.patch
mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix.patch
slub-remove-resiliency_test-function.patch

