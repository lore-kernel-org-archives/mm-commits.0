Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05034C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 18:29:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbiJUS35 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Oct 2022 14:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiJUS3r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2022 14:29:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7983A4A9
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 11:29:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CBADB82CCC
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 18:29:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF11EC433D6;
        Fri, 21 Oct 2022 18:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666376981;
        bh=ZJ8aIumT8P8Q3g48xazIkKkmCC3zvdaOGifjR7z0M3E=;
        h=Date:To:From:Subject:From;
        b=K7vy7jA4fp7Xr/gB4P7ZwcRGiRf9NhcA6Agu9jdm4TGdkRbM5MBme+xnPI2pK98UT
         97/u9iCAChS3W6BfCU1xnQwHpEq+vEZ0N3HQai23S0zISJrfGHoKld8nsz85LqXuIR
         a9K958rJYSezSJinX0KkrnmKq/2w5syYAo9L68/c=
Date:   Fri, 21 Oct 2022 11:29:41 -0700
To:     mm-commits@vger.kernel.org, ubizjak@gmail.com,
        ndesaulniers@google.com, nathan@kernel.org, memxor@gmail.com,
        keescook@chromium.org, glider@google.com, elver@google.com,
        ashimida@linux.alibaba.com, arnd@arndb.de, andreyknvl@gmail.com,
        ojeda@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + compiler-gcc-document-minimum-version-for-__no_sanitize_coverage__.patch added to mm-unstable branch
Message-Id: <20221021182941.CF11EC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: compiler-gcc: document minimum version for `__no_sanitize_coverage__`
has been added to the -mm mm-unstable branch.  Its filename is
     compiler-gcc-document-minimum-version-for-__no_sanitize_coverage__.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/compiler-gcc-document-minimum-version-for-__no_sanitize_coverage__.patch

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
Subject: compiler-gcc: document minimum version for `__no_sanitize_coverage__`
Date: Fri, 21 Oct 2022 13:59:56 +0200

The attribute was added in GCC 12.1.

This will simplify future cleanups, and is closer to what we do
in `compiler_attributes.h`.

Link: https://godbolt.org/z/MGbT76j6G
Link: https://lkml.kernel.org/r/20221021115956.9947-5-ojeda@kernel.org
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

 include/linux/compiler-gcc.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/linux/compiler-gcc.h~compiler-gcc-document-minimum-version-for-__no_sanitize_coverage__
+++ a/include/linux/compiler-gcc.h
@@ -92,6 +92,9 @@
 
 #define __no_sanitize_undefined __attribute__((__no_sanitize_undefined__))
 
+/*
+ * Only supported since gcc >= 12
+ */
 #if defined(CONFIG_KCOV) && __has_attribute(__no_sanitize_coverage__)
 #define __no_sanitize_coverage __attribute__((__no_sanitize_coverage__))
 #else
_

Patches currently in -mm which might be from ojeda@kernel.org are

compiler-gcc-be-consistent-with-underscores-use-for-no_sanitize.patch
compiler-gcc-remove-attribute-support-check-for-__no_sanitize_address__.patch
compiler-gcc-remove-attribute-support-check-for-__no_sanitize_thread__.patch
compiler-gcc-remove-attribute-support-check-for-__no_sanitize_undefined__.patch
compiler-gcc-document-minimum-version-for-__no_sanitize_coverage__.patch

