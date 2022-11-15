Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91438C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:25:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbiKOWZ0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:25:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231548AbiKOWZ0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:25:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21ED910DF
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:25:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0DB4619D9
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:25:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14041C433D6;
        Tue, 15 Nov 2022 22:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551124;
        bh=VTlvZ6KRM5oE8n1OpDLoZbDf3qigIcwjKQLEb8G/EhA=;
        h=Date:To:From:Subject:From;
        b=enQYlprejuRnqq0Wf9f3NLQl68EShkvmpeuL6+fFaBsDYFt0t0Au4T0UMTjF86b5A
         8auwOTM5UDi2JLb+zN4THc99Oe5EeFHO/oH/t5eV4y1Rw/kkUsV2sihxmZLi375A/v
         nC8H/rA5f1lp0wYQ3Hyp22BBe8mLzm5pPSMi/QWc=
Date:   Tue, 15 Nov 2022 14:25:23 -0800
To:     mm-commits@vger.kernel.org, keescook@chromium.org, Jason@zx2c4.com,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20221115222524.14041C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes.patch

This patch was dropped because it was folded into minmax-sanity-check-constant-bounds-when-clamping.patch

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

mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch
mm-gup-remove-foll_migration-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-checkpatch-fixes.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-fix.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-v3-fix.patch
kasan-allow-sampling-page_alloc-allocations-for-hw_tags-fix.patch
mm-hugetlb-convert-move_hugetlb_state-to-folios-fix.patch
mm-delay-page_remove_rmap-until-after-the-tlb-has-been-flushed-fix.patch
minmax-sanity-check-constant-bounds-when-clamping.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes-fix.patch
proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3-fix.patch

