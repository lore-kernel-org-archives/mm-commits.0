From: akpm@linux-foundation.org
Subject: [merged]
 makefile-move-stack-protector-availability-out-of-kconfig.patch removed
 from -mm tree
Date: Wed, 07 Feb 2018 11:56:30 -0800
Message-ID: <20180207195630.mw8hugplj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58792 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754127AbeBGT4c (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:56:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, josh@joshtriplett.org, keescook@chromium.org, labbott@redhat.com, mm-commits@vger.kernel.org, yamada.masahiro@socionext.com


The patch titled
     Subject: Makefile: move stack-protector availability out of Kconfig
has been removed from the -mm tree.  Its filename was
     makefile-move-stack-protector-availability-out-of-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: Makefile: move stack-protector availability out of Kconfig

Various portions of the kernel, especially per-architecture pieces,
need to know if the compiler is building with the stack protector.
This was done in the arch/Kconfig with 'select', but this doesn't
allow a way to do auto-detected compiler support. In preparation for
creating an on-if-available default, move the logic for the definition of
CONFIG_CC_STACKPROTECTOR into the Makefile.

Link: http://lkml.kernel.org/r/1510076320-69931-3-git-send-email-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Tested-by: Laura Abbott <labbott@redhat.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile         |    6 +++++-
 arch/Kconfig     |    8 --------
 arch/x86/Kconfig |    2 +-
 3 files changed, 6 insertions(+), 10 deletions(-)

diff -puN arch/Kconfig~makefile-move-stack-protector-availability-out-of-kconfig arch/Kconfig
--- a/arch/Kconfig~makefile-move-stack-protector-availability-out-of-kconfig
+++ a/arch/Kconfig
@@ -538,12 +538,6 @@ config HAVE_CC_STACKPROTECTOR
 	  - its compiler supports the -fstack-protector option
 	  - it has implemented a stack canary (e.g. __stack_chk_guard)
 
-config CC_STACKPROTECTOR
-	def_bool n
-	help
-	  Set when a stack-protector mode is enabled, so that the build
-	  can enable kernel-side support for the GCC feature.
-
 choice
 	prompt "Stack Protector buffer overflow detection"
 	depends on HAVE_CC_STACKPROTECTOR
@@ -564,7 +558,6 @@ config CC_STACKPROTECTOR_NONE
 
 config CC_STACKPROTECTOR_REGULAR
 	bool "Regular"
-	select CC_STACKPROTECTOR
 	help
 	  Functions will have the stack-protector canary logic added if they
 	  have an 8-byte or larger character array on the stack.
@@ -578,7 +571,6 @@ config CC_STACKPROTECTOR_REGULAR
 
 config CC_STACKPROTECTOR_STRONG
 	bool "Strong"
-	select CC_STACKPROTECTOR
 	help
 	  Functions will have the stack-protector canary logic added in any
 	  of the following conditions:
diff -puN arch/x86/Kconfig~makefile-move-stack-protector-availability-out-of-kconfig arch/x86/Kconfig
--- a/arch/x86/Kconfig~makefile-move-stack-protector-availability-out-of-kconfig
+++ a/arch/x86/Kconfig
@@ -322,7 +322,7 @@ config X86_64_SMP
 
 config X86_32_LAZY_GS
 	def_bool y
-	depends on X86_32 && !CC_STACKPROTECTOR
+	depends on X86_32 && CC_STACKPROTECTOR_NONE
 
 config ARCH_SUPPORTS_UPROBES
 	def_bool y
diff -puN Makefile~makefile-move-stack-protector-availability-out-of-kconfig Makefile
--- a/Makefile~makefile-move-stack-protector-availability-out-of-kconfig
+++ a/Makefile
@@ -693,7 +693,7 @@ else
 endif
 endif
 # Find arch-specific stack protector compiler sanity-checking script.
-ifdef CONFIG_CC_STACKPROTECTOR
+ifdef stackp-name
   stackp-path := $(srctree)/scripts/gcc-$(SRCARCH)_$(BITS)-has-stack-protector.sh
   stackp-check := $(wildcard $(stackp-path))
   # If the wildcard test matches a test script, run it to check functionality.
@@ -702,6 +702,10 @@ ifdef CONFIG_CC_STACKPROTECTOR
       stackp-broken := y
     endif
   endif
+  ifndef stackp-broken
+    # If the stack protector is functional, enable code that depends on it.
+    KBUILD_CPPFLAGS += -DCONFIG_CC_STACKPROTECTOR
+  endif
 endif
 KBUILD_CFLAGS += $(stackp-flag)
 
_

Patches currently in -mm which might be from keescook@chromium.org are


