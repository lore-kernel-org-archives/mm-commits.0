Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0293C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:58:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A497261131
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:58:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345390AbhIHC7u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:59:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:57558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347291AbhIHC7o (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:59:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF95561102;
        Wed,  8 Sep 2021 02:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069917;
        bh=qBwKsURUUoNe7editxBH/tg+MxNo3u+5KPes8EBpZqs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GmSK/9GnO+WFisUgBfnre0nCudtGcdp7eVXFwhVj2a473a7803oDXZqYA5fCTwWMc
         fpbjJ0In5MP3TDOsvu2ZYJ+1t2cut0+InbZ+9GGJLFoSUq8ii10l9P1Rxb5VT9x14I
         IHWKiEJPEwIehx3UHWbiLLOxOGKDDaUPGn/fnn+w=
Date:   Tue, 07 Sep 2021 19:58:36 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        brendanhiggins@google.com, colin.king@canonical.com,
        geert@linux-m68k.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        tpiepho@gmail.com
Subject:  [patch 100/147] math: RATIONAL_KUNIT_TEST should depend
 on RATIONAL instead of selecting it
Message-ID: <20210908025836.z27Wy5dH9%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -2460,8 +2460,7 @@ config SLUB_KUNIT_TEST
 
 config RATIONAL_KUNIT_TEST
 	tristate "KUnit test for rational.c" if !KUNIT_ALL_TESTS
-	depends on KUNIT
-	select RATIONAL
+	depends on KUNIT && RATIONAL
 	default KUNIT_ALL_TESTS
 	help
 	  This builds the rational math unit test.
_
