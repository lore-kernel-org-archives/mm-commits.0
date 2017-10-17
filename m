From: akpm@linux-foundation.org
Subject: [to-be-updated]
 makefile-introduce-config_cc_stackprotector_auto.patch removed from -mm
 tree
Date: Tue, 17 Oct 2017 12:57:03 -0700
Message-ID: <59e6608f.vJZV2Aa1u+4WPeA4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36736 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760136AbdJQT5E (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Oct 2017 15:57:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, dalias@libc.org, labbott@redhat.com, mingo@kernel.org, mmarek@suse.com, npiggin@gmail.com, viro@zeniv.linux.org.uk, yamada.masahiro@socionext.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: Makefile: introduce CONFIG_CC_STACKPROTECTOR_AUTO
has been removed from the -mm tree.  Its filename was
     makefile-introduce-config_cc_stackprotector_auto.patch

This patch was dropped because an updated version will be merged

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

Link: http://lkml.kernel.org/r/1506972007-80614-4-git-send-email-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Michal Marek <mmarek@suse.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile     |   11 +++++++++++
 arch/Kconfig |    8 +++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff -puN arch/Kconfig~makefile-introduce-config_cc_stackprotector_auto arch/Kconfig
--- a/arch/Kconfig~makefile-introduce-config_cc_stackprotector_auto
+++ a/arch/Kconfig
@@ -526,7 +526,7 @@ config HAVE_CC_STACKPROTECTOR
 choice
 	prompt "Stack Protector buffer overflow detection"
 	depends on HAVE_CC_STACKPROTECTOR
-	default CC_STACKPROTECTOR_NONE
+	default CC_STACKPROTECTOR_AUTO
 	help
 	  This option turns on the "stack-protector" GCC feature. This
 	  feature puts, at the beginning of functions, a canary value on
@@ -573,6 +573,12 @@ config CC_STACKPROTECTOR_STRONG
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
diff -puN Makefile~makefile-introduce-config_cc_stackprotector_auto Makefile
--- a/Makefile~makefile-introduce-config_cc_stackprotector_auto
+++ a/Makefile
@@ -676,6 +676,10 @@ endif
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
@@ -688,6 +692,7 @@ else
   stackp-flag := $(call cc-option, -fno-stack-protector)
 endif
 endif
+endif
 ifdef stackp-name
   # If the stack protector has been selected, inform the rest of the build.
   KBUILD_CFLAGS += -DCONFIG_CC_STACKPROTECTOR
@@ -1084,6 +1089,12 @@ PHONY += prepare-compiler-check
 prepare-compiler-check: FORCE
 # Make sure compiler supports requested stack protector flag.
 ifdef stackp-name
+  # Warn about CONFIG_CC_STACKPROTECTOR_AUTO having found no option.
+  ifeq ($(stackp-flag),)
+	@echo CONFIG_CC_STACKPROTECTOR_$(stackp-name): \
+		  Compiler does not support any known stack-protector >&2
+  endif
+  # Fail if specifically requested stack protector is missing.
   ifeq ($(call cc-option, $(stackp-flag)),)
 	@echo Cannot use CONFIG_CC_STACKPROTECTOR_$(stackp-name): \
 		  $(stackp-flag) not supported by compiler >&2 && exit 1
_

Patches currently in -mm which might be from keescook@chromium.org are

writeback-convert-timers-to-use-timer_setup.patch
makefile-introduce-config_cc_stackprotector_auto-fix.patch
makefile-introduce-config_cc_stackprotector_auto-fix-2.patch
makefile-introduce-config_cc_stackprotector_auto-fix-3.patch

