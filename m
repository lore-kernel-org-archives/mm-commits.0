Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3202BC433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:58:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AB6961100
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:58:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347322AbhIHC7l (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:59:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:57476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347291AbhIHC7l (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:59:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD20C60E52;
        Wed,  8 Sep 2021 02:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069914;
        bh=aDyG/SDYeazHD8m1XnGmEhvkOdXa7I93xVB26sTWisw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GVHXPYLkCwW8AM79kqDSleQqBlHmkEwhOqOrFG6yX2F6xo4Ki3G9p0s4jmbVyPXvQ
         gVHSg1l/Gt/5/vISoBozcjk739F1nDLxS2m+kAYJom9Zl1PxMJMDJRc/w8oGckBGMN
         FzGfPmT0E8kpJFjOIxlvp26Zpwd7VfLvM7BAGZeI=
Date:   Tue, 07 Sep 2021 19:58:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        brendanhiggins@google.com, colin.king@canonical.com,
        geert@linux-m68k.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        tpiepho@gmail.com
Subject:  [patch 099/147] math: make RATIONAL tristate
Message-ID: <20210908025833.6Du9-4n3o%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: math: make RATIONAL tristate

Patch series "math: RATIONAL and RATIONAL_KUNIT_TEST improvements".

This series makes the RATIONAL symbol tristate, so it is not forced
builtin if all users are modular, and makes the RATIONAL_KUNIT_TEST depend
on RATIONAL, to avoid enabling RATIONAL if there are no real users.


This patch (of 2):

All but one symbols that select RATIONAL are tristate, but RATIONAL itself
is bool.  Change it to tristate, so the rational fractions support code
can be modular if no builtin code relies on it.

Link: https://lkml.kernel.org/r/20210706100945.3803694-1-geert@linux-m68k.org
Link: https://lkml.kernel.org/r/20210706100945.3803694-2-geert@linux-m68k.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Trent Piepho <tpiepho@gmail.com>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/math/Kconfig    |    2 +-
 lib/math/rational.c |    3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/lib/math/Kconfig~math-make-rational-tristate
+++ a/lib/math/Kconfig
@@ -14,4 +14,4 @@ config PRIME_NUMBERS
 	  If unsure, say N.
 
 config RATIONAL
-	bool
+	tristate
--- a/lib/math/rational.c~math-make-rational-tristate
+++ a/lib/math/rational.c
@@ -13,6 +13,7 @@
 #include <linux/export.h>
 #include <linux/minmax.h>
 #include <linux/limits.h>
+#include <linux/module.h>
 
 /*
  * calculate best rational approximation for a given fraction
@@ -106,3 +107,5 @@ void rational_best_approximation(
 }
 
 EXPORT_SYMBOL(rational_best_approximation);
+
+MODULE_LICENSE("GPL v2");
_
