Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E673ACCA47F
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:59:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379890AbiFQC7H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379882AbiFQC7E (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:59:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6543E65D05
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:59:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3E8261D49
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:59:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51EC6C34114;
        Fri, 17 Jun 2022 02:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655434742;
        bh=YMVTS1KNfthjpkRzjYdccfk8l8qc/AU9Sev5eXaFqyo=;
        h=Date:To:From:Subject:From;
        b=M2oNkTusA6SGatA3PwnLwjG0PjgdI3DIMzG6EEKreVdJcZlaOeTucqkymWAF5Bu0W
         6q/zG+8PO6BBGb9MXzfV1FKEJ49+laqJAyCEuZKAbfLsbJzdq5prTBdqd5eIFKgxzT
         JRAMBXH7Bdhm5FiAYlp3JsgmGpRAU1dAGSXyPzL4=
Date:   Thu, 16 Jun 2022 19:59:01 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        ndesaulniers@google.com, nathan@kernel.org, jstitt007@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] include-uapi-linux-swabh-move-explicit-cast-outside-ternary.patch removed from -mm tree
Message-Id: <20220617025902.51EC6C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: include/uapi/linux/swab.h: move explicit cast outside ternary
has been removed from the -mm tree.  Its filename was
     include-uapi-linux-swabh-move-explicit-cast-outside-ternary.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
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


