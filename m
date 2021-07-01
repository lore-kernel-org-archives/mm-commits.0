Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10C12C11F69
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:55:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF5E761468
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238554AbhGAB6U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:58:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238552AbhGAB6T (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:58:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1391C6141A;
        Thu,  1 Jul 2021 01:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104550;
        bh=OoDZR3KoSDH45IG/Fn+nvWFNLGFWP29DBNy4VtpxdJw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=yzMHwqaKFEsSZM4gULuviuXODu+gfz9w8M9oMJLkpRKjULGYjnek/9oY0DUyV6AtB
         ke5uVAtHDng+wMdEM4RSdS/a8D+PSEygwX8kdC1K7eKdCe+b8oNY++WSnMqM51/DyC
         DD4d01OcPNnMoyr9Lh/lzCnhhog19fxRCNVL1j8w=
Date:   Wed, 30 Jun 2021 18:55:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        dlatypov@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, oskar@scara.com,
        torvalds@linux-foundation.org, tpiepho@gmail.com, yguoaz@gmail.com
Subject:  [patch 163/192] lib/math/rational.c: fix divide by zero
Message-ID: <20210701015549.0882YHh8B%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Trent Piepho <tpiepho@gmail.com>
Subject: lib/math/rational.c: fix divide by zero

If the input is out of the range of the allowed values, either larger than
the largest value or closer to zero than the smallest non-zero allowed
value, then a division by zero would occur.

In the case of input too large, the division by zero will occur on the
first iteration.  The best result (largest allowed value) will be found by
always choosing the semi-convergent and excluding the denominator based
limit when finding it.

In the case of the input too small, the division by zero will occur on the
second iteration.  The numerator based semi-convergent should not be
calculated to avoid the division by zero.  But the semi-convergent vs
previous convergent test is still needed, which effectively chooses
between 0 (the previous convergent) vs the smallest allowed fraction (best
semi-convergent) as the result.

Link: https://lkml.kernel.org/r/20210525144250.214670-1-tpiepho@gmail.com
Fixes: 323dd2c3ed0 ("lib/math/rational.c: fix possible incorrect result from rational fractions helper")
Signed-off-by: Trent Piepho <tpiepho@gmail.com>
Reported-by: Yiyuan Guo <yguoaz@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Oskar Schirmer <oskar@scara.com>
Cc: Daniel Latypov <dlatypov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/math/rational.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/lib/math/rational.c~lib-math-rationalc-fix-divide-by-zero
+++ a/lib/math/rational.c
@@ -12,6 +12,7 @@
 #include <linux/compiler.h>
 #include <linux/export.h>
 #include <linux/minmax.h>
+#include <linux/limits.h>
 
 /*
  * calculate best rational approximation for a given fraction
@@ -78,13 +79,18 @@ void rational_best_approximation(
 		 * found below as 't'.
 		 */
 		if ((n2 > max_numerator) || (d2 > max_denominator)) {
-			unsigned long t = min((max_numerator - n0) / n1,
-					      (max_denominator - d0) / d1);
+			unsigned long t = ULONG_MAX;
 
-			/* This tests if the semi-convergent is closer
-			 * than the previous convergent.
+			if (d1)
+				t = (max_denominator - d0) / d1;
+			if (n1)
+				t = min(t, (max_numerator - n0) / n1);
+
+			/* This tests if the semi-convergent is closer than the previous
+			 * convergent.  If d1 is zero there is no previous convergent as this
+			 * is the 1st iteration, so always choose the semi-convergent.
 			 */
-			if (2u * t > a || (2u * t == a && d0 * dp > d1 * d)) {
+			if (!d1 || 2u * t > a || (2u * t == a && d0 * dp > d1 * d)) {
 				n1 = n0 + t * n1;
 				d1 = d0 + t * d1;
 			}
_
