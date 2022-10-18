Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F9C1C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 01:18:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbiJRBSF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 21:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiJRBSE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 21:18:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D699D78231
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 18:18:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8536AB819D6
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 01:18:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3857BC433C1;
        Tue, 18 Oct 2022 01:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666055880;
        bh=5a1wo+zSLrD++1PTkHBNFy7cUqEm9l2KsbUEGnf+frk=;
        h=Date:To:From:Subject:From;
        b=MNekoEnNgVtkDj0RVnbGBHCozhnaRLyCB/j8ni0N/o2SoeyUmqp6saRGso2m7VV4R
         cf+TPBCtytkX+qo+gB0IdxgSFdzhDOPSFheb7wCqMOCnwDZ0He+2E6EGZ3usghPB99
         /+Fccnx93ZAbDIN/bFwkuWzFsPAeAL/l/saw5eXU=
Date:   Mon, 17 Oct 2022 18:17:59 -0700
To:     mm-commits@vger.kernel.org, keescook@chromium.org, Jason@zx2c4.com,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes.patch added to mm-nonmm-unstable branch
Message-Id: <20221018011800.3857BC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes
Date: Mon Oct 17 06:14:56 PM PDT 2022

ERROR: code indent should use tabs where possible
#36: FILE: include/linux/minmax.h:50:
+        (BUILD_BUG_ON_ZERO(__builtin_choose_expr(^I^I^I^I\$

WARNING: please, no spaces at the start of a line
#36: FILE: include/linux/minmax.h:50:
+        (BUILD_BUG_ON_ZERO(__builtin_choose_expr(^I^I^I^I\$

ERROR: code indent should use tabs where possible
#37: FILE: include/linux/minmax.h:51:
+                __is_constexpr((lo) > (hi)), (lo) > (hi), false)))$

WARNING: please, no spaces at the start of a line
#37: FILE: include/linux/minmax.h:51:
+                __is_constexpr((lo) > (hi)), (lo) > (hi), false)))$

WARNING: please, no space before tabs
#40: FILE: include/linux/minmax.h:54:
+^I__clamp_input_check(lo, hi) + ^I^I^I^I^I^I\$

WARNING: please, no space before tabs
#42: FILE: include/linux/minmax.h:56:
+^I^I^I      __typecheck(hi, lo) && __is_constexpr(val) && ^I\$

total: 2 errors, 4 warnings, 44 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/minmax-sanity-check-constant-bounds-when-clamping.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/minmax.h |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/include/linux/minmax.h~minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes
+++ a/include/linux/minmax.h
@@ -37,26 +37,26 @@
 		__cmp(x, y, op), \
 		__cmp_once(x, y, __UNIQUE_ID(__x), __UNIQUE_ID(__y), op))
 
-#define __clamp(val, lo, hi)							\
+#define __clamp(val, lo, hi)	\
 	__cmp(__cmp(val, lo, >), hi, <)
 
-#define __clamp_once(val, lo, hi, unique_val, unique_lo, unique_hi) ({		\
-		typeof(val) unique_val = (val);					\
-		typeof(lo) unique_lo = (lo);					\
-		typeof(hi) unique_hi = (hi);					\
+#define __clamp_once(val, lo, hi, unique_val, unique_lo, unique_hi) ({	\
+		typeof(val) unique_val = (val);				\
+		typeof(lo) unique_lo = (lo);				\
+		typeof(hi) unique_hi = (hi);				\
 		__clamp(unique_val, unique_lo, unique_hi); })
 
-#define __clamp_input_check(lo, hi)						\
-        (BUILD_BUG_ON_ZERO(__builtin_choose_expr(				\
+#define __clamp_input_check(lo, hi)					\
+        (BUILD_BUG_ON_ZERO(__builtin_choose_expr(			\
                 __is_constexpr((lo) > (hi)), (lo) > (hi), false)))
 
-#define __careful_clamp(val, lo, hi) ({						\
-	__clamp_input_check(lo, hi) + 						\
-	__builtin_choose_expr(__typecheck(val, lo) && __typecheck(val, hi) &&	\
-			      __typecheck(hi, lo) && __is_constexpr(val) && 	\
-			      __is_constexpr(lo) && __is_constexpr(hi),		\
-		__clamp(val, lo, hi),						\
-		__clamp_once(val, lo, hi, __UNIQUE_ID(__val),			\
+#define __careful_clamp(val, lo, hi) ({					\
+	__clamp_input_check(lo, hi) +					\
+	__builtin_choose_expr(__typecheck(val, lo) && __typecheck(val, hi) &&\
+			      __typecheck(hi, lo) && __is_constexpr(val) &&\
+			      __is_constexpr(lo) && __is_constexpr(hi),	\
+		__clamp(val, lo, hi),					\
+		__clamp_once(val, lo, hi, __UNIQUE_ID(__val),		\
 			     __UNIQUE_ID(__lo), __UNIQUE_ID(__hi))); })
 
 /**
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-hugetlb-convert-free_huge_page-to-folios-fix.patch
powerpc-ptrace-user_regset_copyin_ignore-always-returns-0-fix.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes.patch

