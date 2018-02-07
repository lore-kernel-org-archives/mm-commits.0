From: akpm@linux-foundation.org
Subject: [merged]
 makefile-introduce-config_cc_stackprotector_auto.patch removed from -mm
 tree
Date: Wed, 07 Feb 2018 11:56:33 -0800
Message-ID: <20180207195633.gIW3vGekR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59088 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754180AbeBGT4j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:56:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, josh@joshtriplett.org, keescook@chromium.org, labbott@redhat.com, mm-commits@vger.kernel.org, yamada.masahiro@socionext.com


The patch titled
     Subject: Makefile: introduce CONFIG_CC_STACKPROTECTOR_AUTO
has been removed from the -mm tree.  Its filename was
     makefile-introduce-config_cc_stackprotector_auto.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: Makefile: introduce CONFIG_CC_STACKPROTECTOR_AUTO

Nearly all modern compilers support a stack-protector option, and nearly
all modern distributions enable the kernel stack-protector, so enabling
this by default in kernel builds would make sense.  However, Kconfig does
not have knowledge of available compiler features, so it isn't safe to
force on, as this would unconditionally break builds for the compilers or
architectures that don't have support.  Instead, this introduces a new
option, CONFIG_CC_STACKPROTECTOR_AUTO, which attempts to discover the best
possible stack-protector available, and will allow builds to proceed even
if the compiler doesn't support any stack-protector.

This option is made the default so that kernels built with modern
compilers will be protected-by-default against stack buffer overflows,
avoiding things like the recent BlueBorne attack.  Selection of a specific
stack-protector option remains available, including disabling it.

Additionally, tiny.config is adjusted to use CC_STACKPROTECTOR_NONE, since
that's the option with the least code size (and it used to be the default,
so we have to explicitly choose it there now).

Link: http://lkml.kernel.org/r/1510076320-69931-4-git-send-email-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Tested-by: Laura Abbott <labbott@redhat.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile                   |   37 ++++++++++++++++++++++++++++++++---
 arch/Kconfig               |    8 ++++++-
 kernel/configs/tiny.config |    4 +++
 3 files changed, 45 insertions(+), 4 deletions(-)

diff -puN arch/Kconfig~makefile-introduce-config_cc_stackprotector_auto arch/Kconfig
--- a/arch/Kconfig~makefile-introduce-config_cc_stackprotector_auto
+++ a/arch/Kconfig
@@ -541,7 +541,7 @@ config HAVE_CC_STACKPROTECTOR
 choice
 	prompt "Stack Protector buffer overflow detection"
 	depends on HAVE_CC_STACKPROTECTOR
-	default CC_STACKPROTECTOR_NONE
+	default CC_STACKPROTECTOR_AUTO
 	help
 	  This option turns on the "stack-protector" GCC feature. This
 	  feature puts, at the beginning of functions, a canary value on
@@ -588,6 +588,12 @@ config CC_STACKPROTECTOR_STRONG
 	  about 20% of all kernel functions, which increases the kernel code
 	  size by about 2%.
 
+config CC_STACKPROTECTOR_AUTO
+	bool "Automatic"
+	help
+	  If the compiler supports it, the best available stack-protector
+	  option will be chosen.
+
 endchoice
 
 config THIN_ARCHIVES
diff -puN kernel/configs/tiny.config~makefile-introduce-config_cc_stackprotector_auto kernel/configs/tiny.config
--- a/kernel/configs/tiny.config~makefile-introduce-config_cc_stackprotector_auto
+++ a/kernel/configs/tiny.config
@@ -10,3 +10,7 @@ CONFIG_OPTIMIZE_INLINING=y
 # CONFIG_SLAB is not set
 # CONFIG_SLUB is not set
 CONFIG_SLOB=y
+CONFIG_CC_STACKPROTECTOR_NONE=y
+# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
+# CONFIG_CC_STACKPROTECTOR_STRONG is not set
+# CONFIG_CC_STACKPROTECTOR_AUTO is not set
diff -puN Makefile~makefile-introduce-config_cc_stackprotector_auto Makefile
--- a/Makefile~makefile-introduce-config_cc_stackprotector_auto
+++ a/Makefile
@@ -680,6 +680,10 @@ endif
 # This selects the stack protector compiler flag. Testing it is delayed
 # until after .config has been reprocessed, in the prepare-compiler-check
 # target.
+ifdef CONFIG_CC_STACKPROTECTOR_AUTO
+  stackp-flag := $(call cc-option,-fstack-protector-strong,$(call cc-option,-fstack-protector))
+  stackp-name := AUTO
+else
 ifdef CONFIG_CC_STACKPROTECTOR_REGULAR
   stackp-flag := -fstack-protector
   stackp-name := REGULAR
@@ -688,12 +692,18 @@ ifdef CONFIG_CC_STACKPROTECTOR_STRONG
   stackp-flag := -fstack-protector-strong
   stackp-name := STRONG
 else
+  # If either there is no stack protector for this architecture or
+  # CONFIG_CC_STACKPROTECTOR_NONE is selected, we're done, and $(stackp-name)
+  # is empty, skipping all remaining stack protector tests.
+  #
   # Force off for distro compilers that enable stack protector by default.
-  stackp-flag := $(call cc-option, -fno-stack-protector)
+  KBUILD_CFLAGS += $(call cc-option, -fno-stack-protector)
+endif
 endif
 endif
 # Find arch-specific stack protector compiler sanity-checking script.
 ifdef stackp-name
+ifneq ($(stackp-flag),)
   stackp-path := $(srctree)/scripts/gcc-$(SRCARCH)_$(BITS)-has-stack-protector.sh
   stackp-check := $(wildcard $(stackp-path))
   # If the wildcard test matches a test script, run it to check functionality.
@@ -705,9 +715,17 @@ ifdef stackp-name
   ifndef stackp-broken
     # If the stack protector is functional, enable code that depends on it.
     KBUILD_CPPFLAGS += -DCONFIG_CC_STACKPROTECTOR
+    # Either we've already detected the flag (for AUTO) or we'll fail the
+    # build in the prepare-compiler-check rule (for specific flag).
+    KBUILD_CFLAGS += $(stackp-flag)
+  else
+    # We have to make sure stack protector is unconditionally disabled if
+    # the compiler is broken (in case we're going to continue the build in
+    # AUTO mode).
+    KBUILD_CFLAGS += $(call cc-option, -fno-stack-protector)
   endif
 endif
-KBUILD_CFLAGS += $(stackp-flag)
+endif
 
 ifeq ($(cc-name),clang)
 KBUILD_CPPFLAGS += $(call cc-option,-Qunused-arguments,)
@@ -1102,15 +1120,28 @@ PHONY += prepare-compiler-check
 prepare-compiler-check: FORCE
 # Make sure compiler supports requested stack protector flag.
 ifdef stackp-name
+  # Warn about CONFIG_CC_STACKPROTECTOR_AUTO having found no option.
+  ifeq ($(stackp-flag),)
+	@echo CONFIG_CC_STACKPROTECTOR_$(stackp-name): \
+		  Compiler does not support any known stack-protector >&2
+  else
+  # Fail if specifically requested stack protector is missing.
   ifeq ($(call cc-option, $(stackp-flag)),)
 	@echo Cannot use CONFIG_CC_STACKPROTECTOR_$(stackp-name): \
 		  $(stackp-flag) not supported by compiler >&2 && exit 1
   endif
+  endif
 endif
-# Make sure compiler does not have buggy stack-protector support.
+# Make sure compiler does not have buggy stack-protector support. If a
+# specific stack-protector was requested, fail the build, otherwise warn.
 ifdef stackp-broken
+  ifeq ($(stackp-name),AUTO)
+	@echo CONFIG_CC_STACKPROTECTOR_$(stackp-name): \
+                  $(stackp-flag) available but compiler is broken: disabling >&2
+  else
 	@echo Cannot use CONFIG_CC_STACKPROTECTOR_$(stackp-name): \
                   $(stackp-flag) available but compiler is broken >&2 && exit 1
+  endif
 endif
 	@:
 
_

Patches currently in -mm which might be from keescook@chromium.org are


