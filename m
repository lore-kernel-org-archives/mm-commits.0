Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2771C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:46:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7B5B2333F
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbgLPEqT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:46:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:51556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725889AbgLPEqT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:46:19 -0500
Date:   Tue, 15 Dec 2020 20:45:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093938;
        bh=/oznnne3iJ6wyLYrGcIG66gcLRlSPcvBVDczo9e8EXk=;
        h=From:To:Subject:In-Reply-To:From;
        b=YOaIg0VzizP81sTiBs1SrrLTpQwxsgPNYGUaeRXB0xSOLsVamvMtmzP/uu/NPhxv8
         qVpTrFy9p6TaSgCRu7iUq/Kr2dqzp5o/X7aJbRNLE4e5ha0UF8wEFilnuTj4U/hbFx
         9uyvDQ+/BXON0DATxLUyVCBBbtgivPzU+G/SOfC8=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, ndesaulniers@google.com,
        oberpar@linux.ibm.com, torvalds@linux-foundation.org
Subject:  [patch 61/95] gcov: remove support for GCC < 4.9
Message-ID: <20201216044537.99tNyUx4L%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>
Subject: gcov: remove support for GCC < 4.9

Since commit 0bddd227f3dc ("Documentation: update for gcc 4.9
requirement") the minimum supported version of GCC is gcc-4.9.  It's now
safe to remove this code.

Similar to commit 10415533a906 ("gcov: Remove old GCC 3.4 support") but
that was for GCC 4.8 and this is for GCC 4.9.

Link: https://github.com/ClangBuiltLinux/linux/issues/427
Link: https://lkml.kernel.org/r/20201111030557.2015680-1-ndesaulniers@google.com
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/gcc_4_7.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/kernel/gcov/gcc_4_7.c~gcov-remove-support-for-gcc-49
+++ a/kernel/gcov/gcc_4_7.c
@@ -25,10 +25,8 @@
 #define GCOV_COUNTERS			9
 #elif (__GNUC__ > 5) || (__GNUC__ == 5 && __GNUC_MINOR__ >= 1)
 #define GCOV_COUNTERS			10
-#elif __GNUC__ == 4 && __GNUC_MINOR__ >= 9
-#define GCOV_COUNTERS			9
 #else
-#define GCOV_COUNTERS			8
+#define GCOV_COUNTERS			9
 #endif
 
 #define GCOV_TAG_FUNCTION_LENGTH	3
_
