Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B997BC433EF
	for <mm-commits@archiver.kernel.org>; Sat, 11 Sep 2021 22:13:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FD8160FDC
	for <mm-commits@archiver.kernel.org>; Sat, 11 Sep 2021 22:13:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbhIKWO2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 11 Sep 2021 18:14:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:51664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229800AbhIKWO2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 11 Sep 2021 18:14:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF27860F6C;
        Sat, 11 Sep 2021 22:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631398395;
        bh=/3RZfNu8JmX57+RM8rWPbYp92FXmh91Fb4KklIuArVc=;
        h=Date:From:To:Subject:From;
        b=fa4d+zdMdOzBSq8T7apvXfC3oLz5mZNM07jx5SSjqS50m/NOqGV3iXMiI4+YuUmMQ
         kMXoaXHRfWIONRgyuArrKDrqvRMhp2RcPebFeiSzJt+b2Oe+vkkbiMfzD8LsqeKk3O
         1Cac1eCh5VwOpivGTqUvHdlNSsubKBQpQz1Wj+AY=
Date:   Sat, 11 Sep 2021 15:13:11 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org,
        samitolvanen@google.com, peterz@infradead.org, ojeda@kernel.org,
        nivedita@alum.mit.edu, ndesaulniers@google.com, nathan@kernel.org,
        masahiroy@kernel.org, elver@google.com, arnd@arndb.de,
        ardb@kernel.org, keescook@chromium.org
Subject:  +
 compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix.patch
 added to -mm tree
Message-ID: <20210911221311.5toPT%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Compiler Attributes: check GCC version for __alloc_size attribute
has been added to the -mm tree.  Its filename is
     compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: Compiler Attributes: check GCC version for __alloc_size attribute

Unfortunately, just version checking the use of
-Wno-alloc-size-larger-than is not sufficient to make the __alloc_size
attribute behave correctly under older GCC versions.  The attribute itself
must be disabled in those situations too, as there appears to be no way to
reliably silence the SIZE_MAX constant expression cases for GCC versions
less than 9.1:

In file included from ./include/linux/resource_ext.h:11,
                 from ./include/linux/pci.h:40,
                 from drivers/net/ethernet/intel/ixgbe/ixgbe.h:9,
                 from drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c:4:
In function 'kmalloc_node',
    inlined from 'ixgbe_alloc_q_vector' at ./include/linux/slab.h:743:9:
./include/linux/slab.h:618:9: error: argument 1 value '18446744073709551615' exceeds maximum object size 9223372036854775807 [-Werror=alloc-size-larger-than=]
  return __kmalloc_node(size, flags, node);
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
./include/linux/slab.h: In function 'ixgbe_alloc_q_vector':
./include/linux/slab.h:455:7: note: in a call to allocation function '__kmalloc_node' declared here
 void *__kmalloc_node(size_t size, gfp_t flags, int node) __assume_slab_alignment __malloc;
       ^~~~~~~~~~~~~~

Specifically:
-Wno-alloc-size-larger-than is not correctly handled by GCC < 9.1
  https://godbolt.org/z/hqsfG7q84 (doesn't disable)
  https://godbolt.org/z/P9jdrPTYh (doesn't admit to not knowing about option)
  https://godbolt.org/z/465TPMWKb (only warns when other warnings appear)

-Walloc-size-larger-than=18446744073709551615 is not handled by GCC < 8.2
  https://godbolt.org/z/73hh1EPxz (ignores numeric value)

Link: https://lkml.kernel.org/r/20210910201132.3809437-1-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Marco Elver <elver@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Arvind Sankar <nivedita@alum.mit.edu>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc.h        |    9 +++++++++
 include/linux/compiler_attributes.h |    6 ------
 include/linux/compiler_types.h      |    5 +++++
 3 files changed, 14 insertions(+), 6 deletions(-)

--- a/include/linux/compiler_attributes.h~compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix
+++ a/include/linux/compiler_attributes.h
@@ -54,12 +54,6 @@
 #define __aligned_largest               __attribute__((__aligned__))
 
 /*
- *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-alloc_005fsize-function-attribute
- * clang: https://clang.llvm.org/docs/AttributeReference.html#alloc-size
- */
-#define __alloc_size(x, ...)		__attribute__((__alloc_size__(x, ## __VA_ARGS__)))
-
-/*
  * Note: users of __always_inline currently do not write "inline" themselves,
  * which seems to be required by gcc to apply the attribute according
  * to its docs (and also "warning: always_inline function might not be
--- a/include/linux/compiler-gcc.h~compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix
+++ a/include/linux/compiler-gcc.h
@@ -153,3 +153,12 @@
 #else
 #define __diag_GCC_8(s)
 #endif
+
+/*
+ * https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-alloc_005fsize-function-attribute
+ * However, prior to 9.1, -Wno-alloc-size-larger-than does not work,
+ * making this attribute unusable.
+ */
+#if GCC_VERSION < 90100
+#define __alloc_size(x, ...)	/**/
+#endif
--- a/include/linux/compiler_types.h~compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix
+++ a/include/linux/compiler_types.h
@@ -254,6 +254,11 @@ struct ftrace_likely_data {
 #define asm_volatile_goto(x...) asm goto(x)
 #endif
 
+/* If not specifically disabled, allow the use of __alloc_size attribute. */
+#ifndef __alloc_size
+# define __alloc_size(x, ...)		__attribute__((__alloc_size__(x, ## __VA_ARGS__)))
+#endif
+
 #ifdef CONFIG_CC_HAS_ASM_INLINE
 #define asm_inline asm __inline
 #else
_

Patches currently in -mm which might be from keescook@chromium.org are

rapidio-avoid-bogus-__alloc_size-warning.patch
compiler-attributes-add-__alloc_size-for-better-bounds-checking.patch
compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix.patch
checkpatch-add-__alloc_size-to-known-attribute.patch
slab-clean-up-function-declarations.patch
slab-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-page_alloc-add-__alloc_size-attributes-for-better-bounds-checking.patch
percpu-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-vmalloc-add-__alloc_size-attributes-for-better-bounds-checking.patch

