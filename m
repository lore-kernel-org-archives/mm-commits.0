Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6D30C5519F
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 00:50:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D9D422201
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 00:50:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="TjEsZ+fZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgKMAua (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Nov 2020 19:50:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:55684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725929AbgKMAua (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Nov 2020 19:50:30 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4A8021D79;
        Fri, 13 Nov 2020 00:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605228618;
        bh=xj2Z8r7tTWpfeRfVLeItnOdXvNrgeXPsJoXPZ4alLoQ=;
        h=Date:From:To:Subject:From;
        b=TjEsZ+fZIhZskZM2ZvOWM6RinwBQraZC9oBybj6pOVJER/zhwYFp5KYot1sh0xXcV
         Q14gFqQAVap/nJpeokieAGoX/xV1dJilCCnwcsBfkyE4JaXOC+iysKRInXOkJNo0om
         h2ZHEKRzh8sL2wAYgnct4z8fSaGRgNpPl1dFwpXs=
Date:   Thu, 12 Nov 2020 16:50:17 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ndesaulniers@google.com,
        oberpar@linux.ibm.com
Subject:  + gcov-remove-support-for-gcc-49.patch added to -mm tree
Message-ID: <20201113005017.E7s9qSKgH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: gcov: remove support for GCC < 4.9
has been added to the -mm tree.  Its filename is
     gcov-remove-support-for-gcc-49.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/gcov-remove-support-for-gcc-49.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/gcov-remove-support-for-gcc-49.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from ndesaulniers@google.com are

gcov-remove-support-for-gcc-49.patch
compiler-clang-remove-version-check-for-bpf-tracing.patch

