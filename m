From: akpm@linux-foundation.org
Subject: + makefile-introduce-config_cc_stackprotector_auto.patch added to -mm tree
Date: Tue, 21 Nov 2017 15:36:30 -0800
Message-ID: <5a14b87e.BUEcTxWDbWdNaUeE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40720 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751471AbdKUXgb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Nov 2017 18:36:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, arnd@arndb.de, josh@joshtriplett.org, labbott@redhat.com, yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Makefile: introduce CONFIG_CC_STACKPROTECTOR_AUTO
has been added to the -mm tree.  Its filename is
     makefile-introduce-config_cc_stackprotector_auto.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/makefile-introduce-config_cc_stackprotector_auto.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/makefile-introduce-config_cc_stackprotector_auto.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -527,7 +527,7 @@ config HAVE_CC_STACKPROTECTOR
 choice
 	prompt "Stack Protector buffer overflow detection"
 	depends on HAVE_CC_STACKPROTECTOR
-	default CC_STACKPROTECTOR_NONE
+	default CC_STACKPROTECTOR_AUTO
 	help
 	  This option turns on the "stack-protector" GCC feature. This
 	  feature puts, at the beginning of functions, a canary value on
@@ -574,6 +574,12 @@ config CC_STACKPROTECTOR_STRONG
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
@@ -665,6 +665,10 @@ endif
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
@@ -673,12 +677,18 @@ ifdef CONFIG_CC_STACKPROTECTOR_STRONG
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
@@ -690,9 +700,17 @@ ifdef stackp-name
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
 ifneq ($(CROSS_COMPILE),)
@@ -1093,15 +1111,28 @@ PHONY += prepare-compiler-check
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

makefile-move-stack-protector-compiler-breakage-test-earlier.patch
makefile-move-stack-protector-availability-out-of-kconfig.patch
makefile-introduce-config_cc_stackprotector_auto.patch

