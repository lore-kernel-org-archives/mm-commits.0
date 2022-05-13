Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E90CC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:25:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383782AbiEMTZV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383829AbiEMTX7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:23:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCFB92E6BA
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:22:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A89860ADC
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:22:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C05E7C34100;
        Fri, 13 May 2022 19:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469746;
        bh=F7fk5I0X+OCexTbn9fJ9npx6J91m3IU8FqfGWw+LBgU=;
        h=Date:To:From:Subject:From;
        b=Liax92gz4xjjYSdKeWlcR6Yxq310J30XCoYTQiS8/OYyaEF3LGUw/OymtVLUBu0Xq
         AAUTQgv+vVKK3yVIKP7ttDvWSkbzx1ra2uDy6jpPkR2zQUMSKXrM61yKdXT7NdNpUR
         WGQB97zg5Lni9UhhLpUhRwA+Ffil5ZosHp1d7Gag=
Date:   Fri, 13 May 2022 12:22:26 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-clean-up-kconfig-options-descriptions.patch removed from -mm tree
Message-Id: <20220513192226.C05E7C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kasan: clean-up kconfig options descriptions
has been removed from the -mm tree.  Its filename was
     kasan-clean-up-kconfig-options-descriptions.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: clean-up kconfig options descriptions

Various readability clean-ups of KASAN Kconfig options.

No functional changes.

Link: https://lkml.kernel.org/r/c160840dd9e4b1ad5529ecfdb0bba35d9a14d826.1652203271.git.andreyknvl@google.com
Link: https://lkml.kernel.org/r/47afaecec29221347bee49f58c258ac1ced3b429.1652123204.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.kasan |  168 +++++++++++++++++++++-----------------------
 1 file changed, 82 insertions(+), 86 deletions(-)

--- a/lib/Kconfig.kasan~kasan-clean-up-kconfig-options-descriptions
+++ a/lib/Kconfig.kasan
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
 # This config refers to the generic KASAN mode.
 config HAVE_ARCH_KASAN
 	bool
@@ -15,9 +16,8 @@ config HAVE_ARCH_KASAN_VMALLOC
 config ARCH_DISABLE_KASAN_INLINE
 	bool
 	help
-	  An architecture might not support inline instrumentation.
-	  When this option is selected, inline and stack instrumentation are
-	  disabled.
+	  Disables both inline and stack instrumentation. Selected by
+	  architectures that do not support these instrumentation types.
 
 config CC_HAS_KASAN_GENERIC
 	def_bool $(cc-option, -fsanitize=kernel-address)
@@ -26,13 +26,13 @@ config CC_HAS_KASAN_SW_TAGS
 	def_bool $(cc-option, -fsanitize=kernel-hwaddress)
 
 # This option is only required for software KASAN modes.
-# Old GCC versions don't have proper support for no_sanitize_address.
+# Old GCC versions do not have proper support for no_sanitize_address.
 # See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=89124 for details.
 config CC_HAS_WORKING_NOSANITIZE_ADDRESS
 	def_bool !CC_IS_GCC || GCC_VERSION >= 80300
 
 menuconfig KASAN
-	bool "KASAN: runtime memory debugger"
+	bool "KASAN: dynamic memory safety error detector"
 	depends on (((HAVE_ARCH_KASAN && CC_HAS_KASAN_GENERIC) || \
 		     (HAVE_ARCH_KASAN_SW_TAGS && CC_HAS_KASAN_SW_TAGS)) && \
 		    CC_HAS_WORKING_NOSANITIZE_ADDRESS) || \
@@ -40,10 +40,13 @@ menuconfig KASAN
 	depends on (SLUB && SYSFS) || (SLAB && !DEBUG_SLAB)
 	select STACKDEPOT_ALWAYS_INIT
 	help
-	  Enables KASAN (KernelAddressSANitizer) - runtime memory debugger,
-	  designed to find out-of-bounds accesses and use-after-free bugs.
+	  Enables KASAN (Kernel Address Sanitizer) - a dynamic memory safety
+	  error detector designed to find out-of-bounds and use-after-free bugs.
+
 	  See Documentation/dev-tools/kasan.rst for details.
 
+	  For better error reports, also enable CONFIG_STACKTRACE.
+
 if KASAN
 
 choice
@@ -51,75 +54,71 @@ choice
 	default KASAN_GENERIC
 	help
 	  KASAN has three modes:
-	  1. generic KASAN (similar to userspace ASan,
-	     x86_64/arm64/xtensa, enabled with CONFIG_KASAN_GENERIC),
-	  2. software tag-based KASAN (arm64 only, based on software
-	     memory tagging (similar to userspace HWASan), enabled with
-	     CONFIG_KASAN_SW_TAGS), and
-	  3. hardware tag-based KASAN (arm64 only, based on hardware
-	     memory tagging, enabled with CONFIG_KASAN_HW_TAGS).
 
-	  All KASAN modes are strictly debugging features.
+	  1. Generic KASAN (supported by many architectures, enabled with
+	     CONFIG_KASAN_GENERIC, similar to userspace ASan),
+	  2. Software Tag-Based KASAN (arm64 only, based on software memory
+	     tagging, enabled with CONFIG_KASAN_SW_TAGS, similar to userspace
+	     HWASan), and
+	  3. Hardware Tag-Based KASAN (arm64 only, based on hardware memory
+	     tagging, enabled with CONFIG_KASAN_HW_TAGS).
 
-	  For better error reports enable CONFIG_STACKTRACE.
+	  See Documentation/dev-tools/kasan.rst for details about each mode.
 
 config KASAN_GENERIC
-	bool "Generic mode"
+	bool "Generic KASAN"
 	depends on HAVE_ARCH_KASAN && CC_HAS_KASAN_GENERIC
 	depends on CC_HAS_WORKING_NOSANITIZE_ADDRESS
 	select SLUB_DEBUG if SLUB
 	select CONSTRUCTORS
 	help
-	  Enables generic KASAN mode.
+	  Enables Generic KASAN.
 
-	  This mode is supported in both GCC and Clang. With GCC it requires
-	  version 8.3.0 or later. Any supported Clang version is compatible,
-	  but detection of out-of-bounds accesses for global variables is
-	  supported only since Clang 11.
+	  Requires GCC 8.3.0+ or Clang.
 
-	  This mode consumes about 1/8th of available memory at kernel start
-	  and introduces an overhead of ~x1.5 for the rest of the allocations.
+	  Consumes about 1/8th of available memory at kernel start and adds an
+	  overhead of ~50% for dynamic allocations.
 	  The performance slowdown is ~x3.
 
-	  Currently CONFIG_KASAN_GENERIC doesn't work with CONFIG_DEBUG_SLAB
-	  (the resulting kernel does not boot).
+	  (Incompatible with CONFIG_DEBUG_SLAB: the kernel does not boot.)
 
 config KASAN_SW_TAGS
-	bool "Software tag-based mode"
+	bool "Software Tag-Based KASAN"
 	depends on HAVE_ARCH_KASAN_SW_TAGS && CC_HAS_KASAN_SW_TAGS
 	depends on CC_HAS_WORKING_NOSANITIZE_ADDRESS
 	select SLUB_DEBUG if SLUB
 	select CONSTRUCTORS
 	help
-	  Enables software tag-based KASAN mode.
+	  Enables Software Tag-Based KASAN.
+
+	  Requires GCC 11+ or Clang.
 
-	  This mode require software memory tagging support in the form of
-	  HWASan-like compiler instrumentation.
+	  Supported only on arm64 CPUs and relies on Top Byte Ignore.
 
-	  Currently this mode is only implemented for arm64 CPUs and relies on
-	  Top Byte Ignore. This mode requires Clang.
+	  Consumes about 1/16th of available memory at kernel start and
+	  add an overhead of ~20% for dynamic allocations.
 
-	  This mode consumes about 1/16th of available memory at kernel start
-	  and introduces an overhead of ~20% for the rest of the allocations.
-	  This mode may potentially introduce problems relating to pointer
-	  casting and comparison, as it embeds tags into the top byte of each
-	  pointer.
+	  May potentially introduce problems related to pointer casting and
+	  comparison, as it embeds a tag into the top byte of each pointer.
 
-	  Currently CONFIG_KASAN_SW_TAGS doesn't work with CONFIG_DEBUG_SLAB
-	  (the resulting kernel does not boot).
+	  (Incompatible with CONFIG_DEBUG_SLAB: the kernel does not boot.)
 
 config KASAN_HW_TAGS
-	bool "Hardware tag-based mode"
+	bool "Hardware Tag-Based KASAN"
 	depends on HAVE_ARCH_KASAN_HW_TAGS
 	depends on SLUB
 	help
-	  Enables hardware tag-based KASAN mode.
+	  Enables Hardware Tag-Based KASAN.
 
-	  This mode requires hardware memory tagging support, and can be used
-	  by any architecture that provides it.
+	  Requires GCC 10+ or Clang 12+.
 
-	  Currently this mode is only implemented for arm64 CPUs starting from
-	  ARMv8.5 and relies on Memory Tagging Extension and Top Byte Ignore.
+	  Supported only on arm64 CPUs starting from ARMv8.5 and relies on
+	  Memory Tagging Extension and Top Byte Ignore.
+
+	  Consumes about 1/32nd of available memory.
+
+	  May potentially introduce problems related to pointer casting and
+	  comparison, as it embeds a tag into the top byte of each pointer.
 
 endchoice
 
@@ -131,83 +130,80 @@ choice
 config KASAN_OUTLINE
 	bool "Outline instrumentation"
 	help
-	  Before every memory access compiler insert function call
-	  __asan_load*/__asan_store*. These functions performs check
-	  of shadow memory. This is slower than inline instrumentation,
-	  however it doesn't bloat size of kernel's .text section so
-	  much as inline does.
+	  Makes the compiler insert function calls that check whether the memory
+	  is accessible before each memory access. Slower than KASAN_INLINE, but
+	  does not bloat the size of the kernel's .text section so much.
 
 config KASAN_INLINE
 	bool "Inline instrumentation"
 	depends on !ARCH_DISABLE_KASAN_INLINE
 	help
-	  Compiler directly inserts code checking shadow memory before
-	  memory accesses. This is faster than outline (in some workloads
-	  it gives about x2 boost over outline instrumentation), but
-	  make kernel's .text size much bigger.
+	  Makes the compiler directly insert memory accessibility checks before
+	  each memory access. Faster than KASAN_OUTLINE (gives ~x2 boost for
+	  some workloads), but makes the kernel's .text size much bigger.
 
 endchoice
 
 config KASAN_STACK
-	bool "Enable stack instrumentation (unsafe)" if CC_IS_CLANG && !COMPILE_TEST
+	bool "Stack instrumentation (unsafe)" if CC_IS_CLANG && !COMPILE_TEST
 	depends on KASAN_GENERIC || KASAN_SW_TAGS
 	depends on !ARCH_DISABLE_KASAN_INLINE
 	default y if CC_IS_GCC
 	help
-	  The LLVM stack address sanitizer has a know problem that
-	  causes excessive stack usage in a lot of functions, see
-	  https://bugs.llvm.org/show_bug.cgi?id=38809
-	  Disabling asan-stack makes it safe to run kernels build
-	  with clang-8 with KASAN enabled, though it loses some of
-	  the functionality.
-	  This feature is always disabled when compile-testing with clang
-	  to avoid cluttering the output in stack overflow warnings,
-	  but clang users can still enable it for builds without
-	  CONFIG_COMPILE_TEST.	On gcc it is assumed to always be safe
-	  to use and enabled by default.
-	  If the architecture disables inline instrumentation, stack
-	  instrumentation is also disabled as it adds inline-style
-	  instrumentation that is run unconditionally.
+	  Disables stack instrumentation and thus KASAN's ability to detect
+	  out-of-bounds bugs in stack variables.
+
+	  With Clang, stack instrumentation has a problem that causes excessive
+	  stack usage, see https://bugs.llvm.org/show_bug.cgi?id=38809. Thus,
+	  with Clang, this option is deemed unsafe.
+
+	  This option is always disabled when compile-testing with Clang to
+	  avoid cluttering the log with stack overflow warnings.
+
+	  With GCC, enabling stack instrumentation is assumed to be safe.
+
+	  If the architecture disables inline instrumentation via
+	  ARCH_DISABLE_KASAN_INLINE, stack instrumentation gets disabled
+	  as well, as it adds inline-style instrumentation that is run
+	  unconditionally.
 
 config KASAN_TAGS_IDENTIFY
-	bool "Enable memory corruption identification"
+	bool "Memory corruption type identification"
 	depends on KASAN_SW_TAGS || KASAN_HW_TAGS
 	help
-	  This option enables best-effort identification of bug type
-	  (use-after-free or out-of-bounds) at the cost of increased
-	  memory consumption.
+	  Enables best-effort identification of the bug types (use-after-free
+	  or out-of-bounds) at the cost of increased memory consumption.
+	  Only applicable for the tag-based KASAN modes.
 
 config KASAN_VMALLOC
 	bool "Check accesses to vmalloc allocations"
 	depends on HAVE_ARCH_KASAN_VMALLOC
 	help
-	  This mode makes KASAN check accesses to vmalloc allocations for
-	  validity.
+	  Makes KASAN check the validity of accesses to vmalloc allocations.
 
-	  With software KASAN modes, checking is done for all types of vmalloc
-	  allocations. Enabling this option leads to higher memory usage.
+	  With software KASAN modes, all types vmalloc allocations are
+	  checked. Enabling this option leads to higher memory usage.
 
-	  With hardware tag-based KASAN, only VM_ALLOC mappings are checked.
-	  There is no additional memory usage.
+	  With Hardware Tag-Based KASAN, only non-executable VM_ALLOC mappings
+	  are checked. There is no additional memory usage.
 
 config KASAN_KUNIT_TEST
 	tristate "KUnit-compatible tests of KASAN bug detection capabilities" if !KUNIT_ALL_TESTS
 	depends on KASAN && KUNIT
 	default KUNIT_ALL_TESTS
 	help
-	  This is a KUnit test suite doing various nasty things like
-	  out of bounds and use after free accesses. It is useful for testing
-	  kernel debugging features like KASAN.
+	  A KUnit-based KASAN test suite. Triggers different kinds of
+	  out-of-bounds and use-after-free accesses. Useful for testing whether
+	  KASAN can detect certain bug types.
 
 	  For more information on KUnit and unit tests in general, please refer
-	  to the KUnit documentation in Documentation/dev-tools/kunit.
+	  to the KUnit documentation in Documentation/dev-tools/kunit/.
 
 config KASAN_MODULE_TEST
 	tristate "KUnit-incompatible tests of KASAN bug detection capabilities"
 	depends on m && KASAN && !KASAN_HW_TAGS
 	help
-	  This is a part of the KASAN test suite that is incompatible with
-	  KUnit. Currently includes tests that do bad copy_from/to_user
-	  accesses.
+	  A part of the KASAN test suite that is not integrated with KUnit.
+	  Incompatible with Hardware Tag-Based KASAN.
 
 endif # KASAN
_

Patches currently in -mm which might be from andreyknvl@google.com are


