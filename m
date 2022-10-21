Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DE68C38A2D
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 18:29:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiJUS3o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Oct 2022 14:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbiJUS3m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2022 14:29:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F262EF6A
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 11:29:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8130461F29
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 18:29:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6673C433C1;
        Fri, 21 Oct 2022 18:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666376977;
        bh=2qyiCBPzGwW08GOlFtAtP1BBxhvhx0UiQp6fFYPVIsY=;
        h=Date:To:From:Subject:From;
        b=nZg+X+1LEEDYUj2Z+pQnEIMIqXA0LiIA0qcFuA2ZhzqiB8oxHGDnfhOUO5EeNOQah
         CacTuEdyUMT+OcpICBns3je4ey9fMMvr+tZdBr5owaqV8BN/aGJhux3ARUdIka65FP
         TgnIc3le945aTfHGyYN2Blu43JWyKAF7t6zRhlKI=
Date:   Fri, 21 Oct 2022 11:29:37 -0700
To:     mm-commits@vger.kernel.org, ubizjak@gmail.com,
        ndesaulniers@google.com, nathan@kernel.org, memxor@gmail.com,
        keescook@chromium.org, glider@google.com, elver@google.com,
        ashimida@linux.alibaba.com, arnd@arndb.de, andreyknvl@gmail.com,
        ojeda@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + compiler-gcc-remove-attribute-support-check-for-__no_sanitize_thread__.patch added to mm-unstable branch
Message-Id: <20221021182937.D6673C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: compiler-gcc: remove attribute support check for `__no_sanitize_thread__`
has been added to the -mm mm-unstable branch.  Its filename is
     compiler-gcc-remove-attribute-support-check-for-__no_sanitize_thread__.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/compiler-gcc-remove-attribute-support-check-for-__no_sanitize_thread__.patch

This patch will later appear in the mm-unstable branch at
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
From: Miguel Ojeda <ojeda@kernel.org>
Subject: compiler-gcc: remove attribute support check for `__no_sanitize_thread__`
Date: Fri, 21 Oct 2022 13:59:54 +0200

The attribute was added in GCC 5.1, which matches the minimum GCC version
supported by the kernel.

Therefore, remove the check.

Link: https://godbolt.org/z/vbxKejxbx
Link: https://lkml.kernel.org/r/20221021115956.9947-3-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Acked-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Li <ashimida@linux.alibaba.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/compiler-gcc.h~compiler-gcc-remove-attribute-support-check-for-__no_sanitize_thread__
+++ a/include/linux/compiler-gcc.h
@@ -84,7 +84,7 @@
 
 #define __no_sanitize_address __attribute__((__no_sanitize_address__))
 
-#if defined(__SANITIZE_THREAD__) && __has_attribute(__no_sanitize_thread__)
+#if defined(__SANITIZE_THREAD__)
 #define __no_sanitize_thread __attribute__((__no_sanitize_thread__))
 #else
 #define __no_sanitize_thread
_

Patches currently in -mm which might be from ojeda@kernel.org are

compiler-gcc-be-consistent-with-underscores-use-for-no_sanitize.patch
compiler-gcc-remove-attribute-support-check-for-__no_sanitize_address__.patch
compiler-gcc-remove-attribute-support-check-for-__no_sanitize_thread__.patch
compiler-gcc-remove-attribute-support-check-for-__no_sanitize_undefined__.patch
compiler-gcc-document-minimum-version-for-__no_sanitize_coverage__.patch

