Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D3B6FA373D
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 18:29:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbiJUS3p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Oct 2022 14:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiJUS3m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2022 14:29:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D185326CD
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 11:29:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 888E961F46
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 18:29:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB879C433D6;
        Fri, 21 Oct 2022 18:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666376979;
        bh=/oiY8S5ZtwOyQZuf/OB8DVIqRd88UYYw6KFj/Ab8GqE=;
        h=Date:To:From:Subject:From;
        b=yBUCNrNbuztFl+prR74zTtU/hw84mGX53S1zsnDjVu9LkR2SrkwIUip8MK17VegBn
         Ip1cixFvZcSGtHzTTdERdDE+q3aJOEUMcgupI73LqiaABEoOrJlPQ2rAdfYoSHEszf
         uyxD6RaB5dHHaQ9HoPICgNZ6HQM9qVWh8iMgUvt4=
Date:   Fri, 21 Oct 2022 11:29:39 -0700
To:     mm-commits@vger.kernel.org, ubizjak@gmail.com,
        ndesaulniers@google.com, nathan@kernel.org, memxor@gmail.com,
        keescook@chromium.org, glider@google.com, elver@google.com,
        ashimida@linux.alibaba.com, arnd@arndb.de, andreyknvl@gmail.com,
        ojeda@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + compiler-gcc-remove-attribute-support-check-for-__no_sanitize_undefined__.patch added to mm-unstable branch
Message-Id: <20221021182939.DB879C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: compiler-gcc: remove attribute support check for `__no_sanitize_undefined__`
has been added to the -mm mm-unstable branch.  Its filename is
     compiler-gcc-remove-attribute-support-check-for-__no_sanitize_undefined__.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/compiler-gcc-remove-attribute-support-check-for-__no_sanitize_undefined__.patch

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
Subject: compiler-gcc: remove attribute support check for `__no_sanitize_undefined__`
Date: Fri, 21 Oct 2022 13:59:55 +0200

The attribute was added in GCC 4.9, while the minimum GCC version
supported by the kernel is GCC 5.1.

Therefore, remove the check.

Link: https://godbolt.org/z/GrMeo6fYr
Link: https://lkml.kernel.org/r/20221021115956.9947-4-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Li <ashimida@linux.alibaba.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Marco Elver <elver@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc.h |    4 ----
 1 file changed, 4 deletions(-)

--- a/include/linux/compiler-gcc.h~compiler-gcc-remove-attribute-support-check-for-__no_sanitize_undefined__
+++ a/include/linux/compiler-gcc.h
@@ -90,11 +90,7 @@
 #define __no_sanitize_thread
 #endif
 
-#if __has_attribute(__no_sanitize_undefined__)
 #define __no_sanitize_undefined __attribute__((__no_sanitize_undefined__))
-#else
-#define __no_sanitize_undefined
-#endif
 
 #if defined(CONFIG_KCOV) && __has_attribute(__no_sanitize_coverage__)
 #define __no_sanitize_coverage __attribute__((__no_sanitize_coverage__))
_

Patches currently in -mm which might be from ojeda@kernel.org are

compiler-gcc-be-consistent-with-underscores-use-for-no_sanitize.patch
compiler-gcc-remove-attribute-support-check-for-__no_sanitize_address__.patch
compiler-gcc-remove-attribute-support-check-for-__no_sanitize_thread__.patch
compiler-gcc-remove-attribute-support-check-for-__no_sanitize_undefined__.patch
compiler-gcc-document-minimum-version-for-__no_sanitize_coverage__.patch

