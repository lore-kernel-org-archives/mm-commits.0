Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8330C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Jun 2022 20:09:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbiFHUJx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Jun 2022 16:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbiFHUJx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jun 2022 16:09:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ADDDBCE8F
        for <mm-commits@vger.kernel.org>; Wed,  8 Jun 2022 13:09:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 826DC61C67
        for <mm-commits@vger.kernel.org>; Wed,  8 Jun 2022 20:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F58C34116;
        Wed,  8 Jun 2022 20:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654718990;
        bh=aIlVnclWNZ0BcyQpUax0+FKYm9mz7g1yg7EzdULb7h8=;
        h=Date:To:From:Subject:From;
        b=vZuJzyjZeNRxsIuj4C5fDMfLeeq6D4JdPX4Rgv6JfZ//I8foLidbQ9H60YBODVExP
         pVyuu5c3V/qk6/wu91Z1BQ8RrK7ri+SArDp14ARb6XiehCe2f2p2sef2EMM2UAoBuG
         ISRoVOMtM7dCkIZZBZCJQr3bk8+F7hLRzqcAitKw=
Date:   Wed, 08 Jun 2022 13:09:50 -0700
To:     mm-commits@vger.kernel.org, trix@redhat.com,
        ndesaulniers@google.com, nathan@kernel.org, jstitt007@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] include-uapi-linux-swabh-move-explicit-cast-outside-ternary.patch removed from -mm tree
Message-Id: <20220608200950.D5F58C34116@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: include/uapi/linux/swab.h: move explicit cast outside ternary
has been removed from the -mm tree.  Its filename was
     include-uapi-linux-swabh-move-explicit-cast-outside-ternary.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Justin Stitt <jstitt007@gmail.com>
Subject: include/uapi/linux/swab.h: move explicit cast outside ternary
Date: Tue, 7 Jun 2022 17:14:22 -0700

A cast inside __builtin_constant_p doesn't do anything since it should
evaluate as constant at compile time irrespective of this cast.  Instead,
I moved this cast outside the ternary to ensure the return type is as
expected.

For instance, if __HAVE_BUILTIN_BSWAP16__ was not defined then __swab16 is
actually returning an `int` not a `u16` due to integer promotion as
described by Nick in this thread.  This has repercussions when building
with clang -Wformat.  This fix should solve many of these warnings.

Link: https://github.com/ClangBuiltLinux/linux/issues/378
Link: https://lkml.kernel.org/r/20220608001422.26383-1-jstitt007@gmail.com
Signed-off-by: Justin Stitt <jstitt007@gmail.com>
Suggested-by: Nathan Chancellor <nathan@kernel.org>
Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: Tom Rix <trix@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/swab.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/include/uapi/linux/swab.h~include-uapi-linux-swabh-move-explicit-cast-outside-ternary
+++ a/include/uapi/linux/swab.h
@@ -99,10 +99,10 @@ static inline __attribute_const__ __u32
  * @x: value to byteswap
  */
 #ifdef __HAVE_BUILTIN_BSWAP16__
-#define __swab16(x) (__u16)__builtin_bswap16((__u16)(x))
+#define __swab16(x) (__u16)__builtin_bswap16(x)
 #else
 #define __swab16(x)				\
-	(__builtin_constant_p((__u16)(x)) ?	\
+	(__u16)(__builtin_constant_p(x) ?	\
 	___constant_swab16(x) :			\
 	__fswab16(x))
 #endif
@@ -112,10 +112,10 @@ static inline __attribute_const__ __u32
  * @x: value to byteswap
  */
 #ifdef __HAVE_BUILTIN_BSWAP32__
-#define __swab32(x) (__u32)__builtin_bswap32((__u32)(x))
+#define __swab32(x) (__u32)__builtin_bswap32(x)
 #else
 #define __swab32(x)				\
-	(__builtin_constant_p((__u32)(x)) ?	\
+	(__u32)(__builtin_constant_p(x) ?	\
 	___constant_swab32(x) :			\
 	__fswab32(x))
 #endif
@@ -125,10 +125,10 @@ static inline __attribute_const__ __u32
  * @x: value to byteswap
  */
 #ifdef __HAVE_BUILTIN_BSWAP64__
-#define __swab64(x) (__u64)__builtin_bswap64((__u64)(x))
+#define __swab64(x) (__u64)__builtin_bswap64(x)
 #else
 #define __swab64(x)				\
-	(__builtin_constant_p((__u64)(x)) ?	\
+	(__u64)(__builtin_constant_p(x) ?	\
 	___constant_swab64(x) :			\
 	__fswab64(x))
 #endif
_

Patches currently in -mm which might be from jstitt007@gmail.com are


