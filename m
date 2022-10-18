Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 041E9C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 01:13:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbiJRBNV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 21:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiJRBNS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 21:13:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89C71CB08
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 18:13:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7648BB819D6
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 01:13:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F250C433D7;
        Tue, 18 Oct 2022 01:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666055594;
        bh=nArE3CXSyM3wnwObfhD7pqJa5vEk0dGJed/txfWfEjQ=;
        h=Date:To:From:Subject:From;
        b=EfChFblPCGBD2cup+BQTPgAk9k45j1QhjfnXrOk1kOA8caEMjxwGZ7Atn4ABoKZiA
         nuMXXTSVkfq3UQyl32iPbTFWJRdwUF/g6nHlkW9UfoXh674z78heLcTSBUnYa2Eqmm
         xY+pS5emIcnK18GK/4e13ldUw7aM+zJZ02HQonfg=
Date:   Mon, 17 Oct 2022 18:13:13 -0700
To:     mm-commits@vger.kernel.org, keescook@chromium.org,
        andriy.shevchenko@linux.intel.com, Jason@zx2c4.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + minmax-sanity-check-constant-bounds-when-clamping.patch added to mm-nonmm-unstable branch
Message-Id: <20221018011314.2F250C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: minmax: sanity check constant bounds when clamping
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     minmax-sanity-check-constant-bounds-when-clamping.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/minmax-sanity-check-constant-bounds-when-clamping.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: minmax: sanity check constant bounds when clamping
Date: Mon, 26 Sep 2022 15:34:34 +0200

The clamp family of functions only makes sense if hi>=lo.  If hi and lo
are compile-time constants, then raise a build error.  Doing so has
already caught buggy code.  This also introduces the infrastructure to
improve the clamping function in subsequent commits.

Link: https://lkml.kernel.org/r/20220926133435.1333846-1-Jason@zx2c4.com
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/minmax.h |   26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

--- a/include/linux/minmax.h~minmax-sanity-check-constant-bounds-when-clamping
+++ a/include/linux/minmax.h
@@ -37,6 +37,28 @@
 		__cmp(x, y, op), \
 		__cmp_once(x, y, __UNIQUE_ID(__x), __UNIQUE_ID(__y), op))
 
+#define __clamp(val, lo, hi)							\
+	__cmp(__cmp(val, lo, >), hi, <)
+
+#define __clamp_once(val, lo, hi, unique_val, unique_lo, unique_hi) ({		\
+		typeof(val) unique_val = (val);					\
+		typeof(lo) unique_lo = (lo);					\
+		typeof(hi) unique_hi = (hi);					\
+		__clamp(unique_val, unique_lo, unique_hi); })
+
+#define __clamp_input_check(lo, hi)						\
+        (BUILD_BUG_ON_ZERO(__builtin_choose_expr(				\
+                __is_constexpr((lo) > (hi)), (lo) > (hi), false)))
+
+#define __careful_clamp(val, lo, hi) ({						\
+	__clamp_input_check(lo, hi) + 						\
+	__builtin_choose_expr(__typecheck(val, lo) && __typecheck(val, hi) &&	\
+			      __typecheck(hi, lo) && __is_constexpr(val) && 	\
+			      __is_constexpr(lo) && __is_constexpr(hi),		\
+		__clamp(val, lo, hi),						\
+		__clamp_once(val, lo, hi, __UNIQUE_ID(__val),			\
+			     __UNIQUE_ID(__lo), __UNIQUE_ID(__hi))); })
+
 /**
  * min - return minimum of two values of the same or compatible types
  * @x: first value
@@ -86,7 +108,7 @@
  * This macro does strict typechecking of @lo/@hi to make sure they are of the
  * same type as @val.  See the unnecessary pointer comparisons.
  */
-#define clamp(val, lo, hi) min((typeof(val))max(val, lo), hi)
+#define clamp(val, lo, hi) __careful_clamp(val, lo, hi)
 
 /*
  * ..and if you can't take the strict
@@ -121,7 +143,7 @@
  * This macro does no typechecking and uses temporary variables of type
  * @type to make all the comparisons.
  */
-#define clamp_t(type, val, lo, hi) min_t(type, max_t(type, val, lo), hi)
+#define clamp_t(type, val, lo, hi) __careful_clamp((type)(val), (type)(lo), (type)(hi))
 
 /**
  * clamp_val - return a value clamped to a given range using val's type
_

Patches currently in -mm which might be from Jason@zx2c4.com are

minmax-sanity-check-constant-bounds-when-clamping.patch
minmax-clamp-more-efficiently-by-avoiding-extra-comparison.patch

