Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DE94C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 03:10:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15A05610C8
	for <mm-commits@archiver.kernel.org>; Fri, 10 Sep 2021 03:10:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbhIJDLh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 23:11:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229461AbhIJDLh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 23:11:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8875C610E8;
        Fri, 10 Sep 2021 03:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631243427;
        bh=5lf4cepMwC7dYTvqtUpcYjVmaWCHEkEFgYtPQNfsC7M=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=HqcfHldKk9ukItTiY5j/3ItYGf5cTjm91hP3B80Yjr/NbG1q5K/+A9p73ad5wzM4Z
         n93OuK02Q968iZznumsnJlO9vcqYYNa+QLg3m9i4R/LBUtpzySLlq5WYTVkE2sUprK
         d1oGnGVmKsMl4TEFU3acjnZ1SSE47sKJDgu+7SL8=
Date:   Thu, 09 Sep 2021 20:10:26 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, apw@canonical.com, cl@linux.com,
        danielmicay@gmail.com, dennis@kernel.org, dwaipayanray1@gmail.com,
        iamjoonsoo.kim@lge.com, joe@perches.com, keescook@chromium.org,
        linux-mm@kvack.org, lukas.bulwahn@gmail.com,
        mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, ojeda@kernel.org, penberg@kernel.org,
        rdunlap@infradead.org, rientjes@google.com, tj@kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 3/9] Compiler Attributes: add __alloc_size() for
 better bounds checking
Message-ID: <20210910031026.thFt7MLEf%akpm@linux-foundation.org>
In-Reply-To: <20210909200948.090d4e213ca34b5ad1325a7e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Subject: Compiler Attributes: add __alloc_size() for better bounds checking

Patch series "Add __alloc_size() for better bounds checking", v2.

GCC and Clang both use the "alloc_size" attribute to assist with bounds
checking around the use of allocation functions.  Add the attribute,
adjust the Makefile to silence needless warnings, and add the hints to the
allocators where possible.  These changes have been in use for a while now
in GrapheneOS.


This patch (of 2):

GCC and Clang can use the "alloc_size" attribute to better inform the
results of __builtin_object_size() (for compile-time constant values). 
Clang can additionally use alloc_size to inform the results of
__builtin_dynamic_object_size() (for run-time values).

Because GCC sees the frequent use of struct_size() as an allocator size
argument, and notices it can return SIZE_MAX (the overflow indication), it
complains about these call sites may overflow (since SIZE_MAX is greater
than the default -Walloc-size-larger-than=PTRDIFF_MAX).  This isn't
helpful since we already know a SIZE_MAX will be caught at run-time (this
was an intentional design).  Instead, just disable this check as it is
both a false positive and redundant.  (Clang does not have this warning
option.)

[keescook@chromium.org: adjust warning logic for pre-9.1 gcc behaviors]
  Link: https://lkml.kernel.org/r/20210827151327.2729736-1-keescook@chromium.org
Link: https://lkml.kernel.org/r/20210818214021.2476230-1-keescook@chromium.org
Link: https://lkml.kernel.org/r/20210818214021.2476230-2-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Miguel Ojeda <ojeda@kernel.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile                            |   15 +++++++++++++++
 include/linux/compiler_attributes.h |    6 ++++++
 2 files changed, 21 insertions(+)

--- a/include/linux/compiler_attributes.h~compiler-attributes-add-__alloc_size-for-better-bounds-checking
+++ a/include/linux/compiler_attributes.h
@@ -54,6 +54,12 @@
 #define __aligned_largest               __attribute__((__aligned__))
 
 /*
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-alloc_005fsize-function-attribute
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#alloc-size
+ */
+#define __alloc_size(x, ...)		__attribute__((__alloc_size__(x, ## __VA_ARGS__)))
+
+/*
  * Note: users of __always_inline currently do not write "inline" themselves,
  * which seems to be required by gcc to apply the attribute according
  * to its docs (and also "warning: always_inline function might not be
--- a/Makefile~compiler-attributes-add-__alloc_size-for-better-bounds-checking
+++ a/Makefile
@@ -1014,6 +1014,21 @@ ifdef CONFIG_CC_IS_GCC
 KBUILD_CFLAGS += -Wno-maybe-uninitialized
 endif
 
+ifdef CONFIG_CC_IS_GCC
+# The allocators already balk at large sizes, so silence the compiler
+# warnings for bounds checks involving those possible values. While
+# -Wno-alloc-size-larger-than would normally be used here, earlier versions
+# of gcc (<9.1) weirdly don't handle the option correctly when _other_
+# warnings are produced (?!). Using -Walloc-size-larger-than=SIZE_MAX
+# doesn't work (as it is documented to), silently resolving to "0" prior to
+# version 9.1 (and producing an error more recently). Numeric values larger
+# than PTRDIFF_MAX also don't work prior to version 9.1, which are silently
+# ignored, continuing to default to PTRDIFF_MAX. So, left with no other
+# choice, we must perform a versioned check to disable this warning.
+# https://lore.kernel.org/lkml/20210824115859.187f272f@canb.auug.org.au
+KBUILD_CFLAGS += $(call cc-ifversion, -ge, 0901, -Wno-alloc-size-larger-than)
+endif
+
 # disable invalid "can't wrap" optimizations for signed / pointers
 KBUILD_CFLAGS	+= -fno-strict-overflow
 
_
