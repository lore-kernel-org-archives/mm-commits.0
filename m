Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 085D1C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:12:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238287AbiKOWMr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:12:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238551AbiKOWMi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:12:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158B8317E4
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:12:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C5DAB81B79
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:12:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B57DC433C1;
        Tue, 15 Nov 2022 22:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668550351;
        bh=gGeEqnb+NTrlwAgGGF+lV7qfHthD2SJoHiQwo+CpuyM=;
        h=Date:To:From:Subject:From;
        b=G86QoS6KWm1jSQHwdtBtKF/rR4232St4hlU/vQWftB3/4XO45cyMcNy9eaVdddB5r
         Zw1rEGxBo2aYn2l35ofObiP8GI8Ceg1dw1Owxg4nic9Qfc9kva/FUgO7nLySb3v9C3
         b3UNQKlePNRDLdK1P7P6qwnIKtUutun632etr5CY=
Date:   Tue, 15 Nov 2022 14:12:30 -0800
To:     mm-commits@vger.kernel.org, keescook@chromium.org, Jason@zx2c4.com,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes-fix.patch removed from -mm tree
Message-Id: <20221115221231.4B57DC433C1@smtp.kernel.org>
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
minmax-sanity-check-constant-bounds-when-clamping.patch
proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3-fix.patch

