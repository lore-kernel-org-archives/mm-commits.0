From: akpm@linux-foundation.org
Subject: [merged] kbuild-abort-build-on-bad-stack-protector-flag.patch
 removed from -mm tree
Date: Wed, 27 Jul 2016 11:58:41 -0700
Message-ID: <57990461./ASyHjWs50KBG8ye%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39897 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328AbcG0S6m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 14:58:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, mingo@kernel.org, mmarek@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kbuild: abort build on bad stack protector flag
has been removed from the -mm tree.  Its filename was
     kbuild-abort-build-on-bad-stack-protector-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: kbuild: abort build on bad stack protector flag

Before, the stack protector flag was sanity checked before .config had
been reprocessed.  This meant the build couldn't be aborted early, and
only a warning could be emitted followed later by the compiler blowing up
with an unknown flag.  This has caused a lot of confusion over time, so
this splits the flag selection from sanity checking and performs the
sanity checking after the make has been restarted from a reprocessed
.config, so builds can be aborted as early as possible now.

Additionally moves the x86-specific sanity check to the same location,
since it suffered from the same warn-then-wait-for-compiler-failure
problem.

Link: http://lkml.kernel.org/r/20160712223043.GA11664@www.outflux.net
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Michal Marek <mmarek@suse.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile          |   69 ++++++++++++++++++++++++++------------------
 arch/x86/Makefile |    8 -----
 2 files changed, 42 insertions(+), 35 deletions(-)

diff -puN Makefile~kbuild-abort-build-on-bad-stack-protector-flag Makefile
--- a/Makefile~kbuild-abort-build-on-bad-stack-protector-flag
+++ a/Makefile
@@ -647,41 +647,28 @@ ifneq ($(CONFIG_FRAME_WARN),0)
 KBUILD_CFLAGS += $(call cc-option,-Wframe-larger-than=${CONFIG_FRAME_WARN})
 endif
 
-# Handle stack protector mode.
-#
-# Since kbuild can potentially perform two passes (first with the old
-# .config values and then with updated .config values), we cannot error out
-# if a desired compiler option is unsupported. If we were to error, kbuild
-# could never get to the second pass and actually notice that we changed
-# the option to something that was supported.
-#
-# Additionally, we don't want to fallback and/or silently change which compiler
-# flags will be used, since that leads to producing kernels with different
-# security feature characteristics depending on the compiler used. ("But I
-# selected CC_STACKPROTECTOR_STRONG! Why did it build with _REGULAR?!")
-#
-# The middle ground is to warn here so that the failed option is obvious, but
-# to let the build fail with bad compiler flags so that we can't produce a
-# kernel when there is a CONFIG and compiler mismatch.
-#
+# This selects the stack protector compiler flag. Testing it is delayed
+# until after .config has been reprocessed, in the prepare-compiler-check
+# target.
 ifdef CONFIG_CC_STACKPROTECTOR_REGULAR
   stackp-flag := -fstack-protector
-  ifeq ($(call cc-option, $(stackp-flag)),)
-    $(warning Cannot use CONFIG_CC_STACKPROTECTOR_REGULAR: \
-             -fstack-protector not supported by compiler)
-  endif
+  stackp-name := REGULAR
 else
 ifdef CONFIG_CC_STACKPROTECTOR_STRONG
   stackp-flag := -fstack-protector-strong
-  ifeq ($(call cc-option, $(stackp-flag)),)
-    $(warning Cannot use CONFIG_CC_STACKPROTECTOR_STRONG: \
-	      -fstack-protector-strong not supported by compiler)
-  endif
+  stackp-name := STRONG
 else
   # Force off for distro compilers that enable stack protector by default.
   stackp-flag := $(call cc-option, -fno-stack-protector)
 endif
 endif
+# Find arch-specific stack protector compiler sanity-checking script.
+ifdef CONFIG_CC_STACKPROTECTOR
+  stackp-path := $(srctree)/scripts/gcc-$(ARCH)_$(BITS)-has-stack-protector.sh
+  ifneq ($(wildcard $(stackp-path)),)
+    stackp-check := $(stackp-path)
+  endif
+endif
 KBUILD_CFLAGS += $(stackp-flag)
 
 ifdef CONFIG_KCOV
@@ -1020,8 +1007,10 @@ ifneq ($(KBUILD_SRC),)
 	fi;
 endif
 
-# prepare2 creates a makefile if using a separate output directory
-prepare2: prepare3 outputmakefile asm-generic
+# prepare2 creates a makefile if using a separate output directory.
+# From this point forward, .config has been reprocessed, so any rules
+# that need to depend on updated CONFIG_* values can be checked here.
+prepare2: prepare3 prepare-compiler-check outputmakefile asm-generic
 
 prepare1: prepare2 $(version_h) include/generated/utsrelease.h \
                    include/config/auto.conf
@@ -1052,6 +1041,32 @@ endif
 PHONY += prepare-objtool
 prepare-objtool: $(objtool_target)
 
+# Check for CONFIG flags that require compiler support. Abort the build
+# after .config has been processed, but before the kernel build starts.
+#
+# For security-sensitive CONFIG options, we don't want to fallback and/or
+# silently change which compiler flags will be used, since that leads to
+# producing kernels with different security feature characteristics
+# depending on the compiler used. (For example, "But I selected
+# CC_STACKPROTECTOR_STRONG! Why did it build with _REGULAR?!")
+PHONY += prepare-compiler-check
+prepare-compiler-check: FORCE
+# Make sure compiler supports requested stack protector flag.
+ifdef stackp-name
+  ifeq ($(call cc-option, $(stackp-flag)),)
+	@echo Cannot use CONFIG_CC_STACKPROTECTOR_$(stackp-name): \
+		  $(stackp-flag) not supported by compiler >&2 && exit 1
+  endif
+endif
+# Make sure compiler does not have buggy stack-protector support.
+ifdef stackp-check
+  ifneq ($(shell $(CONFIG_SHELL) $(stackp-check) $(CC) $(KBUILD_CPPFLAGS) $(biarch)),y)
+	@echo Cannot use CONFIG_CC_STACKPROTECTOR_$(stackp-name): \
+                  $(stackp-flag) available but compiler is broken >&2 && exit 1
+  endif
+endif
+	@:
+
 # Generate some files
 # ---------------------------------------------------------------------------
 
diff -puN arch/x86/Makefile~kbuild-abort-build-on-bad-stack-protector-flag arch/x86/Makefile
--- a/arch/x86/Makefile~kbuild-abort-build-on-bad-stack-protector-flag
+++ a/arch/x86/Makefile
@@ -126,14 +126,6 @@ else
         KBUILD_CFLAGS += $(call cc-option,-maccumulate-outgoing-args)
 endif
 
-# Make sure compiler does not have buggy stack-protector support.
-ifdef CONFIG_CC_STACKPROTECTOR
-	cc_has_sp := $(srctree)/scripts/gcc-x86_$(BITS)-has-stack-protector.sh
-        ifneq ($(shell $(CONFIG_SHELL) $(cc_has_sp) $(CC) $(KBUILD_CPPFLAGS) $(biarch)),y)
-                $(warning stack-protector enabled but compiler support broken)
-        endif
-endif
