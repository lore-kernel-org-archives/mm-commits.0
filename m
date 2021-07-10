Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8B3DC07E9B
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 03:34:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B403613DF
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 03:34:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbhGJDgu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 23:36:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231271AbhGJDgu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 23:36:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95DA9613DC;
        Sat, 10 Jul 2021 03:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625888045;
        bh=07OqWhU7qGzIkAjavK8Qrt1sispMM1gk8BS/UPjNR4E=;
        h=Date:From:To:Subject:From;
        b=gpmnPpWDprMloATNKKffFGiPJdosj9ysHhsmX0/zIAuCVWJ4czwfqU5nZUZAHCl92
         U/JmFD78rV9aHHqY5mXYvqbhtz3hMqnMkXHlLYHYIJh53n72x62m9h6WsjjQWkkXme
         zfAY9jT0m2qhdAPvSzbR4MWpEHPv0CWt28I3F8GU=
Date:   Fri, 09 Jul 2021 20:34:05 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tpiepho@gmail.com,
        colin.king@canonical.com, brendanhiggins@google.com,
        andriy.shevchenko@linux.intel.com, geert@linux-m68k.org
Subject:  +
 =?us-ascii?Q?math-rational=5Fkunit=5Ftest-should-depend-on-rational-inste?=
 =?us-ascii?Q?ad-of-selecting-it.patch?= added to -mm tree
Message-ID: <20210710033405.NHpaK%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: math: RATIONAL_KUNIT_TEST should depend on RATIONAL instead of selecting it
has been added to the -mm tree.  Its filename is
     math-rational_kunit_test-should-depend-on-rational-instead-of-selecting-it.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/math-rational_kunit_test-should-depend-on-rational-instead-of-selecting-it.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/math-rational_kunit_test-should-depend-on-rational-instead-of-selecting-it.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: math: RATIONAL_KUNIT_TEST should depend on RATIONAL instead of selecting it

RATIONAL_KUNIT_TEST selects RATIONAL, thus enabling an optional feature
the user may not want to have enabled.  Fix this by making the test depend
on RATIONAL instead.

Link: https://lkml.kernel.org/r/20210706100945.3803694-3-geert@linux-m68k.org
Fixes: b6c75c4afceb8bc0 ("lib/math/rational: add Kunit test cases")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Trent Piepho <tpiepho@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/lib/Kconfig.debug~math-rational_kunit_test-should-depend-on-rational-instead-of-selecting-it
+++ a/lib/Kconfig.debug
@@ -2463,8 +2463,7 @@ config SLUB_KUNIT_TEST
 
 config RATIONAL_KUNIT_TEST
 	tristate "KUnit test for rational.c" if !KUNIT_ALL_TESTS
-	depends on KUNIT
-	select RATIONAL
+	depends on KUNIT && RATIONAL
 	default KUNIT_ALL_TESTS
 	help
 	  This builds the rational math unit test.
_

Patches currently in -mm which might be from geert@linux-m68k.org are

math-make-rational-tristate.patch
math-rational_kunit_test-should-depend-on-rational-instead-of-selecting-it.patch

