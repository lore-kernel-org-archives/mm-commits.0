Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06D26C07E99
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 03:34:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5206613DF
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jul 2021 03:34:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbhGJDgs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 23:36:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:40218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230317AbhGJDgs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 23:36:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAA7D6101B;
        Sat, 10 Jul 2021 03:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625888043;
        bh=zGCalafj4qSOXQXFePD0PL6fkyrq/KAnC2uB5qEw220=;
        h=Date:From:To:Subject:From;
        b=BTynxzexy8KYNd03fNW9x6Tr3iQcW7gkSEo86GIXU/jsqNqDCeiUWF76zfXUCCqso
         blZzb/j5SLNGf/vuXxtdKEM5u90PtviZoeE/pO2qDplXLsXjeQCK3Led9dDBHqliEz
         4INm3hCJP264JyM2XQPKPexR2s9CYKFiWa2qg91w=
Date:   Fri, 09 Jul 2021 20:34:03 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tpiepho@gmail.com,
        colin.king@canonical.com, brendanhiggins@google.com,
        andriy.shevchenko@linux.intel.com, geert@linux-m68k.org
Subject:  + math-make-rational-tristate.patch added to -mm tree
Message-ID: <20210710033403.wiDF8%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: math: make RATIONAL tristate
has been added to the -mm tree.  Its filename is
     math-make-rational-tristate.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/math-make-rational-tristate.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/math-make-rational-tristate.patch

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

Patches currently in -mm which might be from geert@linux-m68k.org are

math-make-rational-tristate.patch
math-rational_kunit_test-should-depend-on-rational-instead-of-selecting-it.patch

