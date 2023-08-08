Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 323E7C04A6A
	for <mm-commits@archiver.kernel.org>; Tue,  8 Aug 2023 20:11:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234419AbjHHULj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Aug 2023 16:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbjHHULZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Aug 2023 16:11:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A219FAD36
        for <mm-commits@vger.kernel.org>; Tue,  8 Aug 2023 11:35:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34CE762A20
        for <mm-commits@vger.kernel.org>; Tue,  8 Aug 2023 18:35:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EEA8C433C8;
        Tue,  8 Aug 2023 18:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691519724;
        bh=98sAQMMIg2DVQ1dkJUjtevR2ZHTgLkJqYmHu3GMZZLI=;
        h=Date:To:From:Subject:From;
        b=zRgI4skgVD8N8YzepiI/nX/4y2zNnNGC+HOwetrbjw4jF/szonLaAva4i6puEE9Bw
         s/3oxw6DB72w6bhrsY1VHTCvzvGksyWPvbEnHnDbFcnK3qXr6z7FRZu6jRiZvOLaXY
         8GR9UyO5tokfrfGdG8ysiSp1i7AqT/degESMF9PQ=
Date:   Tue, 08 Aug 2023 11:35:23 -0700
To:     mm-commits@vger.kernel.org, yuzenghui@huawei.com, will@kernel.org,
        trix@redhat.com, suzuki.poulose@arm.com, samitolvanen@google.com,
        rostedt@goodmis.org, peterz@infradead.org, oliver.upton@linux.dev,
        ojeda@kernel.org, ndesaulniers@google.com, nathan@kernel.org,
        maz@kernel.org, mark.rutland@arm.com, linux@roeck-us.net,
        keescook@chromium.org, james.morse@arm.com, glider@google.com,
        dvyukov@google.com, catalin.marinas@arm.com, elver@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + compiler_types-introduce-the-clang-__preserve_most-function-attribute.patch added to mm-nonmm-unstable branch
Message-Id: <20230808183524.7EEA8C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: compiler_types: introduce the Clang __preserve_most function attribute
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     compiler_types-introduce-the-clang-__preserve_most-function-attribute.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/compiler_types-introduce-the-clang-__preserve_most-function-attribute.patch

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
Subject: compiler_types: introduce the Clang __preserve_most function attribute
Date: Tue, 8 Aug 2023 12:17:25 +0200

[1]: "On X86-64 and AArch64 targets, this attribute changes the calling
convention of a function. The preserve_most calling convention attempts
to make the code in the caller as unintrusive as possible. This
convention behaves identically to the C calling convention on how
arguments and return values are passed, but it uses a different set of
caller/callee-saved registers. This alleviates the burden of saving and
recovering a large register set before and after the call in the caller.
If the arguments are passed in callee-saved registers, then they will be
preserved by the callee across the call. This doesn't apply for values
returned in callee-saved registers.

 * On X86-64 the callee preserves all general purpose registers, except
   for R11. R11 can be used as a scratch register. Floating-point
   registers (XMMs/YMMs) are not preserved and need to be saved by the
   caller.

 * On AArch64 the callee preserve all general purpose registers, except
   x0-X8 and X16-X18."

[1] https://clang.llvm.org/docs/AttributeReference.html#preserve-most

Introduce the attribute to compiler_types.h as __preserve_most.

Use of this attribute results in better code generation for calls to
very rarely called functions, such as error-reporting functions, or
rarely executed slow paths.

Beware that the attribute conflicts with instrumentation calls inserted
on function entry which do not use __preserve_most themselves. Notably,
function tracing which assumes the normal C calling convention for the
given architecture.  Where the attribute is supported, __preserve_most
will imply notrace. It is recommended to restrict use of the attribute
to functions that should or already disable tracing.

The attribute may be supported by a future GCC version (see
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=110899).

Link: https://lkml.kernel.org/r/20230808102049.465864-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Miguel Ojeda <ojeda@kernel.org>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: James Morse <james.morse@arm.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Tom Rix <trix@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler_types.h |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

--- a/include/linux/compiler_types.h~compiler_types-introduce-the-clang-__preserve_most-function-attribute
+++ a/include/linux/compiler_types.h
@@ -106,6 +106,34 @@ static inline void __chk_io_ptr(const vo
 #define __cold
 #endif
 
+/*
+ * On x86-64 and arm64 targets, __preserve_most changes the calling convention
+ * of a function to make the code in the caller as unintrusive as possible. This
+ * convention behaves identically to the C calling convention on how arguments
+ * and return values are passed, but uses a different set of caller- and callee-
+ * saved registers.
+ *
+ * The purpose is to alleviates the burden of saving and recovering a large
+ * register set before and after the call in the caller.  This is beneficial for
+ * rarely taken slow paths, such as error-reporting functions that may be called
+ * from hot paths.
+ *
+ * Note: This may conflict with instrumentation inserted on function entry which
+ * does not use __preserve_most or equivalent convention (if in assembly). Since
+ * function tracing assumes the normal C calling convention, where the attribute
+ * is supported, __preserve_most implies notrace.  It is recommended to restrict
+ * use of the attribute to functions that should or already disable tracing.
+ *
+ * Optional: not supported by gcc.
+ *
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#preserve-most
+ */
+#if __has_attribute(__preserve_most__)
+# define __preserve_most notrace __attribute__((__preserve_most__))
+#else
+# define __preserve_most
+#endif
+
 /* Builtins */
 
 /*
_

Patches currently in -mm which might be from elver@google.com are

compiler_types-introduce-the-clang-__preserve_most-function-attribute.patch
list_debug-introduce-inline-wrappers-for-debug-checks.patch
list_debug-introduce-config_debug_list_minimal.patch

