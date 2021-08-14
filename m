Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDA08C4338F
	for <mm-commits@archiver.kernel.org>; Sat, 14 Aug 2021 21:58:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90D4060F9F
	for <mm-commits@archiver.kernel.org>; Sat, 14 Aug 2021 21:58:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbhHNV6o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Aug 2021 17:58:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:54174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229564AbhHNV6o (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 14 Aug 2021 17:58:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9307160F48;
        Sat, 14 Aug 2021 21:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628978294;
        bh=sDiQQ2IWTsk8FAClotWqOrQ4JqQc+a7Fa0QCGY3OjSw=;
        h=Date:From:To:Subject:From;
        b=oU+f2exjzttiJv05kiz3VL0jdluSxOZ7pRwNr96DG8BN+CJyZogMftq64jZZ5aw+n
         zy3xO8/cfhkpahm8cxceHGls3NWsX0/Y6X/qevRtWsuUOSHHMn7Nh5nUNlvLKicQZ1
         cTd02JUWISn1fs1JDiFZEjcn2AXXvcr0u2JafBFA=
Date:   Sat, 14 Aug 2021 14:58:14 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vitor@massaru.org,
        sedat.dilek@gmail.com, peterz@infradead.org,
        penguin-kernel@I-love.SAKURA.ne.jp, paulmck@kernel.org,
        ojeda@kernel.org, nathan@kernel.org, michal.lkml@markovi.net,
        masahiroy@kernel.org, dlatypov@google.com, ndesaulniers@google.com
Subject:  [failures] makefile-remove-stale-cc-option-checks.patch
 removed from -mm tree
Message-ID: <20210814215814.W_qqW%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Makefile: remove stale cc-option checks
has been removed from the -mm tree.  Its filename was
     makefile-remove-stale-cc-option-checks.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Makefile: remove stale cc-option checks

cc-option, cc-option-yn, and cc-disable-warning all invoke the compiler
during build time, and can slow down the build when these checks become
stale for our supported compilers, whose minimally supported versions
increases over time.  See Documentation/process/changes.rst for the
current supported minimal versions (GCC 4.9+, clang 10.0.1+).  Compiler
version support for these flags may be verified on godbolt.org.

The following flags are GCC only and supported since at least GCC 4.9.
Remove cc-option and cc-disable-warning tests.
* -fno-tree-loop-im
* -Wno-maybe-uninitialized
* -fno-reorder-blocks
* -fno-ipa-cp-clone
* -fno-partial-inlining
* -femit-struct-debug-baseonly
* -fno-inline-functions-called-once
* -fconserve-stack

The following flags are supported by all supported versions of GCC and
Clang. Remove their cc-option, cc-option-yn, and cc-disable-warning tests.
* -fno-delete-null-pointer-checks
* -fno-var-tracking
* -mfentry
* -Wno-array-bounds

The following configs are made dependent on GCC, since they use GCC
specific flags.
* READABLE_ASM
* DEBUG_SECTION_MISMATCH

--param=allow-store-data-races=0 was renamed to --allow-store-data-races
in the GCC 10 release.

Also, base RETPOLINE_CFLAGS and RETPOLINE_VDSO_CFLAGS on CONFIC_CC_IS_*
then remove cc-option tests for Clang.

Link: https://github.com/ClangBuiltLinux/linux/issues/1436
Link: https://lkml.kernel.org/r/20210810204240.4008685-1-ndesaulniers@google.com
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Miguel Ojeda <ojeda@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michal Marek <michal.lkml@markovi.net>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Vitor Massaru Iha <vitor@massaru.org>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Daniel Latypov <dlatypov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile          |   55 ++++++++++++++++++++++++--------------------
 lib/Kconfig.debug |    2 +
 2 files changed, 33 insertions(+), 24 deletions(-)

--- a/lib/Kconfig.debug~makefile-remove-stale-cc-option-checks
+++ a/lib/Kconfig.debug
@@ -365,6 +365,7 @@ config STRIP_ASM_SYMS
 config READABLE_ASM
 	bool "Generate readable assembler code"
 	depends on DEBUG_KERNEL
+	depends on CC_IS_GCC
 	help
 	  Disable some compiler optimizations that tend to generate human unreadable
 	  assembler output. This may make the kernel slightly slower, but it helps
@@ -383,6 +384,7 @@ config HEADERS_INSTALL
 
 config DEBUG_SECTION_MISMATCH
 	bool "Enable full Section mismatch analysis"
+	depends on CC_IS_GCC
 	help
 	  The section mismatch analysis checks if there are illegal
 	  references from one section to another section.
--- a/Makefile~makefile-remove-stale-cc-option-checks
+++ a/Makefile
@@ -683,9 +683,10 @@ endif # KBUILD_EXTMOD
 # Defaults to vmlinux, but the arch makefile usually adds further targets
 all: vmlinux
 
-CFLAGS_GCOV	:= -fprofile-arcs -ftest-coverage \
-	$(call cc-option,-fno-tree-loop-im) \
-	$(call cc-disable-warning,maybe-uninitialized,)
+CFLAGS_GCOV	:= -fprofile-arcs -ftest-coverage
+ifdef CONFIG_CC_IS_GCC
+CFLAGS_GCOV	+= -fno-tree-loop-im
+endif
 export CFLAGS_GCOV
 
 # The arch Makefiles can override CC_FLAGS_FTRACE. We may also append it later.
@@ -693,12 +694,14 @@ ifdef CONFIG_FUNCTION_TRACER
   CC_FLAGS_FTRACE := -pg
 endif
 
-RETPOLINE_CFLAGS_GCC := -mindirect-branch=thunk-extern -mindirect-branch-register
-RETPOLINE_VDSO_CFLAGS_GCC := -mindirect-branch=thunk-inline -mindirect-branch-register
-RETPOLINE_CFLAGS_CLANG := -mretpoline-external-thunk
-RETPOLINE_VDSO_CFLAGS_CLANG := -mretpoline
-RETPOLINE_CFLAGS := $(call cc-option,$(RETPOLINE_CFLAGS_GCC),$(call cc-option,$(RETPOLINE_CFLAGS_CLANG)))
-RETPOLINE_VDSO_CFLAGS := $(call cc-option,$(RETPOLINE_VDSO_CFLAGS_GCC),$(call cc-option,$(RETPOLINE_VDSO_CFLAGS_CLANG)))
+ifdef CONFIG_CC_IS_GCC
+RETPOLINE_CFLAGS	:= $(call cc-option,-mindirect-branch=thunk-extern -mindirect-branch-register)
+RETPOLINE_VDSO_CFLAGS	:= $(call cc-option,-mindirect-branch=thunk-inline -mindirect-branch-register)
+endif
+ifdef CONFIG_CC_IS_CLANG
+RETPOLINE_CFLAGS	:= -mretpoline-external-thunk
+RETPOLINE_VDSO_CFLAGS	:= -mretpoline
+endif
 export RETPOLINE_CFLAGS
 export RETPOLINE_VDSO_CFLAGS
 
@@ -751,7 +754,7 @@ include/config/auto.conf:
 endif # may-sync-config
 endif # need-config
 
-KBUILD_CFLAGS	+= $(call cc-option,-fno-delete-null-pointer-checks,)
+KBUILD_CFLAGS	+= -fno-delete-null-pointer-checks
 KBUILD_CFLAGS	+= $(call cc-disable-warning,frame-address,)
 KBUILD_CFLAGS	+= $(call cc-disable-warning, format-truncation)
 KBUILD_CFLAGS	+= $(call cc-disable-warning, format-overflow)
@@ -766,17 +769,17 @@ KBUILD_CFLAGS += -Os
 endif
 
 # Tell gcc to never replace conditional load with a non-conditional one
-KBUILD_CFLAGS	+= $(call cc-option,--param=allow-store-data-races=0)
+ifdef CONFIG_CC_IS_GCC
+KBUILD_CFLAGS	+= $(call cc-option,--allow-store-data-races,--param=allow-store-data-races=0)
 KBUILD_CFLAGS	+= $(call cc-option,-fno-allow-store-data-races)
+endif
 
 ifdef CONFIG_READABLE_ASM
 # Disable optimizations that make assembler listings hard to read.
 # reorder blocks reorders the control in the function
 # ipa clone creates specialized cloned functions
 # partial inlining inlines only parts of functions
-KBUILD_CFLAGS += $(call cc-option,-fno-reorder-blocks,) \
-                 $(call cc-option,-fno-ipa-cp-clone,) \
-                 $(call cc-option,-fno-partial-inlining)
+KBUILD_CFLAGS += -fno-reorder-blocks -fno-ipa-cp-clone -fno-partial-inlining
 endif
 
 ifneq ($(CONFIG_FRAME_WARN),0)
@@ -868,8 +871,10 @@ DEBUG_CFLAGS	+= -gdwarf-$(dwarf-version-
 endif
 
 ifdef CONFIG_DEBUG_INFO_REDUCED
-DEBUG_CFLAGS	+= $(call cc-option, -femit-struct-debug-baseonly) \
-		   $(call cc-option,-fno-var-tracking)
+DEBUG_CFLAGS	+= -fno-var-tracking
+ifdef CONFIG_CC_IS_GCC
+DEBUG_CFLAGS	+= -femit-struct-debug-baseonly
+endif
 endif
 
 ifdef CONFIG_DEBUG_INFO_COMPRESSED
@@ -903,10 +908,8 @@ ifdef CONFIG_FTRACE_MCOUNT_USE_RECORDMCO
   endif
 endif
 ifdef CONFIG_HAVE_FENTRY
-  ifeq ($(call cc-option-yn, -mfentry),y)
-    CC_FLAGS_FTRACE	+= -mfentry
-    CC_FLAGS_USING	+= -DCC_USING_FENTRY
-  endif
+  CC_FLAGS_FTRACE	+= -mfentry
+  CC_FLAGS_USING	+= -DCC_USING_FENTRY
 endif
 export CC_FLAGS_FTRACE
 KBUILD_CFLAGS	+= $(CC_FLAGS_FTRACE) $(CC_FLAGS_USING)
@@ -915,7 +918,7 @@ endif
 
 # We trigger additional mismatches with less inlining
 ifdef CONFIG_DEBUG_SECTION_MISMATCH
-KBUILD_CFLAGS += $(call cc-option, -fno-inline-functions-called-once)
+KBUILD_CFLAGS += -fno-inline-functions-called-once
 endif
 
 ifdef CONFIG_LD_DEAD_CODE_DATA_ELIMINATION
@@ -994,14 +997,16 @@ KBUILD_CFLAGS += $(call cc-disable-warni
 
 # We'll want to enable this eventually, but it's not going away for 5.7 at least
 KBUILD_CFLAGS += $(call cc-disable-warning, zero-length-bounds)
-KBUILD_CFLAGS += $(call cc-disable-warning, array-bounds)
+KBUILD_CFLAGS += -Wno-array-bounds
 KBUILD_CFLAGS += $(call cc-disable-warning, stringop-overflow)
 
 # Another good warning that we'll want to enable eventually
 KBUILD_CFLAGS += $(call cc-disable-warning, restrict)
 
 # Enabled with W=2, disabled by default as noisy
-KBUILD_CFLAGS += $(call cc-disable-warning, maybe-uninitialized)
+ifdef CONFIG_CC_IS_GCC
+KBUILD_CFLAGS += -Wno-maybe-uninitialized
+endif
 
 # disable invalid "can't wrap" optimizations for signed / pointers
 KBUILD_CFLAGS	+= -fno-strict-overflow
@@ -1010,7 +1015,9 @@ KBUILD_CFLAGS	+= -fno-strict-overflow
 KBUILD_CFLAGS  += -fno-stack-check
 
 # conserve stack if available
-KBUILD_CFLAGS   += $(call cc-option,-fconserve-stack)
+ifdef CONFIG_CC_IS_GCC
+KBUILD_CFLAGS   += -fconserve-stack
+endif
 
 # Prohibit date/time macros, which would make the build non-deterministic
 KBUILD_CFLAGS   += -Werror=date-time
_

Patches currently in -mm which might be from ndesaulniers@google.com are


