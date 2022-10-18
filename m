Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0FE9C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 19:01:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbiJRTBP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Oct 2022 15:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiJRTA6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2022 15:00:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0EBB7EF2
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 12:00:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0581616B6
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 19:00:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D20EC433B5;
        Tue, 18 Oct 2022 19:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666119653;
        bh=8eOLo9kjrsLa5ADNZlTXwQl6AQD1WhfzGQp6D0YW6oA=;
        h=Date:To:From:Subject:From;
        b=J4NYjLY1/xxDXPrxG5PA/ValMBp5giyMyZMffEW0V+qYmr+efzBnVSJIpeQjthHgW
         m1B3qNVTzpRd4eVWHQ82snHbxjopFZGTgX7HH9dYrXoAhlcIM4smtCg2xjtR818W5V
         nXVHIQUMg3VYHRxj6QGix06vUkTydfLgSighxPs4=
Date:   Tue, 18 Oct 2022 12:00:52 -0700
To:     mm-commits@vger.kernel.org, keescook@chromium.org, Jason@zx2c4.com,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20221018190053.3D20EC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes-fix.patch

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

mm-hugetlb-convert-free_huge_page-to-folios-fix.patch
powerpc-ptrace-user_regset_copyin_ignore-always-returns-0-fix.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes-fix.patch

