Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2775C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:25:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbiKOWZd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:25:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231617AbiKOWZ2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:25:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1DFC2A941
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:25:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2486B81B87
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:25:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3B5C433D7;
        Tue, 15 Nov 2022 22:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551125;
        bh=HzofGrkRggo5aGBqzsTrh9tEGeIm7WpsKXB8DmtheZU=;
        h=Date:To:From:Subject:From;
        b=w7QGYVdnX9hl/eavU5QQbUZJ+ZZcvUyntR7WPlDNOwwh2RduepjrmzwCrLHyC8NE9
         BQjKuEJsnztLJpjZ0JDTaVlsZmI0mrHRIKZD7CKSG6Iu8/6G49q8M7syrgn79EqC4D
         kW5ukI2VfTgqF8uM6OGNQH+I+5UAmeVrrdbsxglE=
Date:   Tue, 15 Nov 2022 14:25:24 -0800
To:     mm-commits@vger.kernel.org, keescook@chromium.org, Jason@zx2c4.com,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes-fix.patch removed from -mm tree
Message-Id: <20221115222525.4B3B5C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes-fix
has been removed from the -mm tree.  Its filename was
     minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes-fix.patch

This patch was dropped because it was folded into minmax-sanity-check-constant-bounds-when-clamping.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes-fix
Date: Tue Oct 18 11:59:57 AM PDT 2022

s@&&\@&& \@

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/minmax.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/minmax.h~minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes-fix
+++ a/include/linux/minmax.h
@@ -52,8 +52,8 @@
 
 #define __careful_clamp(val, lo, hi) ({					\
 	__clamp_input_check(lo, hi) +					\
-	__builtin_choose_expr(__typecheck(val, lo) && __typecheck(val, hi) &&\
-			      __typecheck(hi, lo) && __is_constexpr(val) &&\
+	__builtin_choose_expr(__typecheck(val, lo) && __typecheck(val, hi) && \
+			      __typecheck(hi, lo) && __is_constexpr(val) && \
 			      __is_constexpr(lo) && __is_constexpr(hi),	\
 		__clamp(val, lo, hi),					\
 		__clamp_once(val, lo, hi, __UNIQUE_ID(__val),		\
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
proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3-fix.patch

