Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A16BC433FE
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:36:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E47BC6125F
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:36:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbhKEUjB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:39:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:33798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232616AbhKEUjA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:39:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7293611EE;
        Fri,  5 Nov 2021 20:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144580;
        bh=TW2hIdei19ESGZqyhS5HK/bJ0sILzn3n1UhvzV3EMxs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=doRtpdzuuPb3KnrUOjeRPCp/ys67o/WLYEFR2jBG4O+40rzwF2Ctln1vbHPeKdrBT
         pBwCD1hnU5YGllfuw8nLjfBuKv4Wun2UY2mjHetVnjFHhGyHOEVK3CUitkqltODqRF
         Qd5sESR2Hg0mXVWwLxkuCzxQQzP0HOr/iPN60A30=
Date:   Fri, 05 Nov 2021 13:36:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.bou9@gmail.com, apw@canonical.com,
        cl@linux.com, danielmicay@gmail.com, dennis@kernel.org,
        dwaipayanray1@gmail.com, gustavoars@kernel.org,
        iamjoonsoo.kim@lge.com, ira.weiny@intel.com, jhubbard@nvidia.com,
        jingxiangfeng@huawei.com, joe@perches.com, jrdr.linux@gmail.com,
        keescook@chromium.org, linux-mm@kvack.org, lkp@intel.com,
        lukas.bulwahn@gmail.com, mm-commits@vger.kernel.org,
        mporter@kernel.crashing.org, nathan@kernel.org,
        ndesaulniers@google.com, ojeda@kernel.org, penberg@kernel.org,
        rdunlap@infradead.org, rientjes@google.com, tj@kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 033/262] Compiler Attributes: add __alloc_size()
 for better bounds checking
Message-ID: <20211105203619.7llAC4ARX%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Subject: Compiler Attributes: add __alloc_size() for better bounds checking

GCC and Clang can use the "alloc_size" attribute to better inform the
results of __builtin_object_size() (for compile-time constant values). 
Clang can additionally use alloc_size to inform the results of
__builtin_dynamic_object_size() (for run-time values).

Because GCC sees the frequent use of struct_size() as an allocator size
argument, and notices it can return SIZE_MAX (the overflow indication), it
complains about these call sites overflowing (since SIZE_MAX is greater
than the default -Walloc-size-larger-than=PTRDIFF_MAX).  This isn't
helpful since we already know a SIZE_MAX will be caught at run-time (this
was an intentional design).  To deal with this, we must disable this check
as it is both a false positive and redundant.  (Clang does not have this
warning option.)

Unfortunately, just checking the -Wno-alloc-size-larger-than is not
sufficient to make the __alloc_size attribute behave correctly under older
GCC versions.  The attribute itself must be disabled in those situations
too, as there appears to be no way to reliably silence the SIZE_MAX
constant expression cases for GCC versions less than 9.1:

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

Since anything marked with __alloc_size would also qualify for marking
with __malloc, just include __malloc along with it to avoid redundant
markings. (Suggested by Linus Torvalds.)

Finally, make sure checkpatch.pl doesn't get confused about finding the
__alloc_size attribute on functions. (Thanks to Joe Perches.)

Link: https://lkml.kernel.org/r/20210930222704.2631604-3-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
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
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jing Xiangfeng <jingxiangfeng@huawei.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Souptick Joarder <jrdr.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile                            |   15 +++++++++++++++
 include/linux/compiler-gcc.h        |    8 ++++++++
 include/linux/compiler_attributes.h |   10 ++++++++++
 include/linux/compiler_types.h      |   12 ++++++++++++
 scripts/checkpatch.pl               |    3 ++-
 5 files changed, 47 insertions(+), 1 deletion(-)

--- a/include/linux/compiler_attributes.h~compiler-attributes-add-__alloc_size-for-better-bounds-checking
+++ a/include/linux/compiler_attributes.h
@@ -34,6 +34,15 @@
 #define __aligned_largest               __attribute__((__aligned__))
 
 /*
+ * Note: do not use this directly. Instead, use __alloc_size() since it is conditionally
+ * available and includes other attributes.
+ *
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-alloc_005fsize-function-attribute
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#alloc-size
+ */
+#define __alloc_size__(x, ...)		__attribute__((__alloc_size__(x, ## __VA_ARGS__)))
+
+/*
  * Note: users of __always_inline currently do not write "inline" themselves,
  * which seems to be required by gcc to apply the attribute according
  * to its docs (and also "warning: always_inline function might not be
@@ -153,6 +162,7 @@
 
 /*
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-malloc-function-attribute
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#malloc
  */
 #define __malloc                        __attribute__((__malloc__))
 
--- a/include/linux/compiler-gcc.h~compiler-attributes-add-__alloc_size-for-better-bounds-checking
+++ a/include/linux/compiler-gcc.h
@@ -144,3 +144,11 @@
 #else
 #define __diag_GCC_8(s)
 #endif
+
+/*
+ * Prior to 9.1, -Wno-alloc-size-larger-than (and therefore the "alloc_size"
+ * attribute) do not work, and must be disabled.
+ */
+#if GCC_VERSION < 90100
+#undef __alloc_size__
+#endif
--- a/include/linux/compiler_types.h~compiler-attributes-add-__alloc_size-for-better-bounds-checking
+++ a/include/linux/compiler_types.h
@@ -250,6 +250,18 @@ struct ftrace_likely_data {
 # define __cficanonical
 #endif
 
+/*
+ * Any place that could be marked with the "alloc_size" attribute is also
+ * a place to be marked with the "malloc" attribute. Do this as part of the
+ * __alloc_size macro to avoid redundant attributes and to avoid missing a
+ * __malloc marking.
+ */
+#ifdef __alloc_size__
+# define __alloc_size(x, ...)	__alloc_size__(x, ## __VA_ARGS__) __malloc
+#else
+# define __alloc_size(x, ...)	__malloc
+#endif
+
 #ifndef asm_volatile_goto
 #define asm_volatile_goto(x...) asm goto(x)
 #endif
--- a/Makefile~compiler-attributes-add-__alloc_size-for-better-bounds-checking
+++ a/Makefile
@@ -1008,6 +1008,21 @@ ifdef CONFIG_CC_IS_GCC
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
 
--- a/scripts/checkpatch.pl~compiler-attributes-add-__alloc_size-for-better-bounds-checking
+++ a/scripts/checkpatch.pl
@@ -489,7 +489,8 @@ our $Attribute	= qr{
 			____cacheline_aligned|
 			____cacheline_aligned_in_smp|
 			____cacheline_internodealigned_in_smp|
-			__weak
+			__weak|
+			__alloc_size\s*\(\s*\d+\s*(?:,\s*\d+\s*)?\)
 		  }x;
 our $Modifier;
 our $Inline	= qr{inline|__always_inline|noinline|__inline|__inline__};
_
