Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 636B9C4707F
	for <mm-commits@archiver.kernel.org>; Tue, 25 May 2021 21:42:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 363D2613C1
	for <mm-commits@archiver.kernel.org>; Tue, 25 May 2021 21:42:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233466AbhEYVnb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 May 2021 17:43:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:49590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233437AbhEYVnb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 25 May 2021 17:43:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06BC6613B6;
        Tue, 25 May 2021 21:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621978921;
        bh=/gC1Xdacf/EKH8cHmdGs8hq6eVfKaxQIOP8rREzW3Fs=;
        h=Date:From:To:Subject:From;
        b=a+X58dxITaxg1WluQho01RJvligCBBrWyvcfZhzXf17lyIwbwWPB0NgXQJTZ5eAf0
         t97YfGDvsIjWAkESSlb/K3kXU78SYcPX0kdJr2LcZZ8hGnkBI80qbJYZ/9dqn4wA9W
         ksNWjEvhXUXU6skQvAGlmEOVvZ9CFQlu5Dem9gto=
Date:   Tue, 25 May 2021 14:42:00 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, dlatypov@google.com,
        mm-commits@vger.kernel.org, oskar@scara.com, tpiepho@gmail.com,
        yguoaz@gmail.com
Subject:  + lib-math-rationalc-fix-divide-by-zero.patch added to
 -mm tree
Message-ID: <20210525214200.MOYwdf5Dt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/math/rational.c: fix divide by zero
has been added to the -mm tree.  Its filename is
     lib-math-rationalc-fix-divide-by-zero.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-math-rationalc-fix-divide-by-zero.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-math-rationalc-fix-divide-by-zero.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from tpiepho@gmail.com are

lib-math-rationalc-fix-divide-by-zero.patch
lib-math-rational-add-kunit-test-cases.patch

