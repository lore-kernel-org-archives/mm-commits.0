Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25C03C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10326611C3
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:05:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348083AbhIIVGJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:06:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348681AbhIIVFd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:05:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 756E361207;
        Thu,  9 Sep 2021 21:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221452;
        bh=HhsQ1PM8t1X/V7/nnYAm2vVeQ2LPkw2yc1dRVDyuxqA=;
        h=Date:From:To:Subject:From;
        b=NpMP4zV0CQk/PDraMD9jtMxWale7foBb8yz5AtgdjMP+kiqJOXbOD3k1nm1cP5qEI
         +W+8eARqq6lB3t5o8LrLew7q2R1cbKReSQzJKkacR0Iz/PoSWeN96GE+LgyHJgxRTF
         JSu3MjWSMD72KlMayBartX8BEi2bSfXOMoYh5WTw=
Date:   Thu, 09 Sep 2021 14:04:12 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, brendanhiggins@google.com,
        colin.king@canonical.com, geert@linux-m68k.org,
        mm-commits@vger.kernel.org, tpiepho@gmail.com
Subject:  [merged] math-make-rational-tristate.patch removed from
 -mm tree
Message-ID: <20210909210412._ipu5bP0e%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: math: make RATIONAL tristate
has been removed from the -mm tree.  Its filename was
     math-make-rational-tristate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


