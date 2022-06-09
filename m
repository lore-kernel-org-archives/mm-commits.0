Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE06DC43334
	for <mm-commits@archiver.kernel.org>; Thu,  9 Jun 2022 17:29:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239136AbiFIR3j (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Jun 2022 13:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239081AbiFIR3h (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2022 13:29:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C3A21BE65B
        for <mm-commits@vger.kernel.org>; Thu,  9 Jun 2022 10:29:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 292CFB82CFB
        for <mm-commits@vger.kernel.org>; Thu,  9 Jun 2022 17:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8187C34114;
        Thu,  9 Jun 2022 17:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654795773;
        bh=4GeXI15P1Xk4q5ib4mEerhdV87eL/wHbhxU8PlL/KjM=;
        h=Date:To:From:Subject:From;
        b=wYs6owSg1yq3AbSMxmYtInq0OZnMkSiTODu8Auc705Cmp6ke3kDkuwu4y0yKQ0sZU
         bbp8HNXhtS7MTaV4tyATPvDdIqDMggKeTXemzp4wJj0g3wW/21bM3q/iHYNsuy7AdO
         8z4LlypvoJ04cpdRB/V0hzqgd7Owy8GlDJJErvxs=
Date:   Thu, 09 Jun 2022 10:29:33 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        ndesaulniers@google.com, nathan@kernel.org, jstitt007@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + include-uapi-linux-swabh-move-explicit-cast-outside-ternary.patch added to mm-nonmm-unstable branch
Message-Id: <20220609172933.D8187C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/uapi/linux/swab.h: move explicit cast outside ternary
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     include-uapi-linux-swabh-move-explicit-cast-outside-ternary.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/include-uapi-linux-swabh-move-explicit-cast-outside-ternary.patch

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
From: Justin Stitt <jstitt007@gmail.com>
Subject: include/uapi/linux/swab.h: move explicit cast outside ternary
Date: Wed, 8 Jun 2022 15:35:39 -0700

A cast inside __builtin_constant_p doesn't do anything since it should
evaluate as constant at compile time irrespective of this cast.  Instead,
I moved this cast outside the ternary to ensure the return type is as
expected.

Additionally, if __HAVE_BUILTIN_BSWAP16__ was not defined then __swab16 is
actually returning an `int` not a `u16` due to integer promotion.

As Al Viro notes:
You *can't* get smaller-than-int out of ? :, same as you can't get it
out of addition, etc.

This also fixes some clang -Wformat warnings involving default
argument promotion.

Link: https://github.com/ClangBuiltLinux/linux/issues/378
Link: https://lkml.kernel.org/r/20220608223539.470472-1-justinstitt@google.com
Signed-off-by: Justin Stitt <jstitt007@gmail.com>
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Suggested-by: Nathan Chancellor <nathan@kernel.org>
Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/swab.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/uapi/linux/swab.h~include-uapi-linux-swabh-move-explicit-cast-outside-ternary
+++ a/include/uapi/linux/swab.h
@@ -102,7 +102,7 @@ static inline __attribute_const__ __u32
 #define __swab16(x) (__u16)__builtin_bswap16((__u16)(x))
 #else
 #define __swab16(x)				\
-	(__builtin_constant_p((__u16)(x)) ?	\
+	(__u16)(__builtin_constant_p(x) ?	\
 	___constant_swab16(x) :			\
 	__fswab16(x))
 #endif
@@ -115,7 +115,7 @@ static inline __attribute_const__ __u32
 #define __swab32(x) (__u32)__builtin_bswap32((__u32)(x))
 #else
 #define __swab32(x)				\
-	(__builtin_constant_p((__u32)(x)) ?	\
+	(__u32)(__builtin_constant_p(x) ?	\
 	___constant_swab32(x) :			\
 	__fswab32(x))
 #endif
@@ -128,7 +128,7 @@ static inline __attribute_const__ __u32
 #define __swab64(x) (__u64)__builtin_bswap64((__u64)(x))
 #else
 #define __swab64(x)				\
-	(__builtin_constant_p((__u64)(x)) ?	\
+	(__u64)(__builtin_constant_p(x) ?	\
 	___constant_swab64(x) :			\
 	__fswab64(x))
 #endif
_

Patches currently in -mm which might be from jstitt007@gmail.com are

include-uapi-linux-swabh-move-explicit-cast-outside-ternary.patch

