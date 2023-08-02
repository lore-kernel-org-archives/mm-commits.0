Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07D2BC04A94
	for <mm-commits@archiver.kernel.org>; Wed,  2 Aug 2023 18:05:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234129AbjHBSF3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Aug 2023 14:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234050AbjHBSFL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2023 14:05:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3500C1FF2
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 11:04:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE77561377
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 18:04:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CECFC433C8;
        Wed,  2 Aug 2023 18:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690999446;
        bh=6Gq2Rh86GbcfSl0/VRdNPHu+tNivFF/bHIujbYo2HNc=;
        h=Date:To:From:Subject:From;
        b=f1ueWhZE9BG2sDboul28JIruNV9vn8jP+yJYk+w+g3hllvgl8a8ZIXJWwT8IXvg4b
         sOtNXAoHuzqmXuXNTN/vo+L48J9HyAwaiNbRS7mEDkQzdowT64OOz7kYHDx02aKZli
         9mg0v2bqRwtMtlCy7nBEwn87fKTve3vLQ5oYsPlE=
Date:   Wed, 02 Aug 2023 11:04:05 -0700
To:     mm-commits@vger.kernel.org, yuzenghui@huawei.com, will@kernel.org,
        trix@redhat.com, suzuki.poulose@arm.com, oliver.upton@linux.dev,
        ojeda@kernel.org, ndesaulniers@google.com, nathan@kernel.org,
        maz@kernel.org, linux@roeck-us.net, keescook@chromium.org,
        james.morse@arm.com, glider@google.com, dvyukov@google.com,
        catalin.marinas@arm.com, elver@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + compiler-attributes-introduce-the-__preserve_most-function-attribute.patch added to mm-nonmm-unstable branch
Message-Id: <20230802180406.1CECFC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Compiler attributes: introduce the LLVM __preserve_most function attribute
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     compiler-attributes-introduce-the-__preserve_most-function-attribute.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/compiler-attributes-introduce-the-__preserve_most-function-attribute.patch

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
From: Marco Elver <elver@google.com>
Subject: Compiler attributes: introduce the LLVM __preserve_most function attribute
Date: Wed, 2 Aug 2023 17:06:37 +0200

[1]: "On X86-64 and AArch64 targets, this attribute changes the calling
convention of a function. The preserve_most calling convention attempts
to make the code in the caller as unintrusive as possible. This
convention behaves identically to the C calling convention on how
arguments and return values are passed, but it uses a different set of
caller/callee-saved registers. This alleviates the burden of saving and
recovering a large register set before and after the call in the
caller."

[1] https://clang.llvm.org/docs/AttributeReference.html#preserve-most

Use of this attribute results in better code generation for calls to
very rarely called functions, such as error-reporting functions, or
rarely executed slow paths.

Introduce the attribute to compiler_attributes.h.

Link: https://lkml.kernel.org/r/20230802150712.3583252-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: James Morse <james.morse@arm.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Tom Rix <trix@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler_attributes.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/include/linux/compiler_attributes.h~compiler-attributes-introduce-the-__preserve_most-function-attribute
+++ a/include/linux/compiler_attributes.h
@@ -322,6 +322,17 @@
 #endif
 
 /*
+ * Optional: not supported by gcc.
+ *
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#preserve-most
+ */
+#if __has_attribute(__preserve_most__)
+# define __preserve_most __attribute__((__preserve_most__))
+#else
+# define __preserve_most
+#endif
+
+/*
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-pure-function-attribute
  */
 #define __pure                          __attribute__((__pure__))
_

Patches currently in -mm which might be from elver@google.com are

compiler-attributes-introduce-the-__preserve_most-function-attribute.patch
list_debug-introduce-inline-wrappers-for-debug-checks.patch
list_debug-introduce-config_debug_list_minimal.patch

