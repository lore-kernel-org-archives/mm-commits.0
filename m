From: akpm@linux-foundation.org
Subject: [to-be-updated]
 makefile-move-stackprotector-availability-out-of-kconfig.patch removed from -mm tree
Date: Tue, 17 Oct 2017 12:57:00 -0700
Message-ID: <59e6608c.0eZh/045SV8os1wu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36716 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760136AbdJQT5B (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Oct 2017 15:57:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, dalias@libc.org, labbott@redhat.com, mingo@kernel.org, mmarek@suse.com, npiggin@gmail.com, viro@zeniv.linux.org.uk, yamada.masahiro@socionext.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: Makefile: move stackprotector availability out of Kconfig
has been removed from the -mm tree.  Its filename was
     makefile-move-stackprotector-availability-out-of-kconfig.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: Makefile: move stackprotector availability out of Kconfig

Various portions of the kernel, especially per-architecture pieces, need
to know if the compiler is building it with the stack protector.  This was
done in the arch/Kconfig with 'select', but this doesn't allow a way to do
auto-detected compiler support.  In preparation for creating an
on-if-available default, move the logic for the definition of
CONFIG_CC_STACKPROTECTOR into the Makefile.

Link: http://lkml.kernel.org/r/1506972007-80614-3-git-send-email-keescook@chromium.org
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

 Makefile     |    7 +++++--
 arch/Kconfig |    8 --------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff -puN arch/Kconfig~makefile-move-stackprotector-availability-out-of-kconfig arch/Kconfig
--- a/arch/Kconfig~makefile-move-stackprotector-availability-out-of-kconfig
+++ a/arch/Kconfig
@@ -523,12 +523,6 @@ config HAVE_CC_STACKPROTECTOR
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
@@ -549,7 +543,6 @@ config CC_STACKPROTECTOR_NONE
 
 config CC_STACKPROTECTOR_REGULAR
 	bool "Regular"
-	select CC_STACKPROTECTOR
 	help
 	  Functions will have the stack-protector canary logic added if they
 	  have an 8-byte or larger character array on the stack.
@@ -563,7 +556,6 @@ config CC_STACKPROTECTOR_REGULAR
 
 config CC_STACKPROTECTOR_STRONG
 	bool "Strong"
-	select CC_STACKPROTECTOR
 	help
 	  Functions will have the stack-protector canary logic added in any
 	  of the following conditions:
diff -puN Makefile~makefile-move-stackprotector-availability-out-of-kconfig Makefile
--- a/Makefile~makefile-move-stackprotector-availability-out-of-kconfig
+++ a/Makefile
@@ -688,8 +688,11 @@ else
   stackp-flag := $(call cc-option, -fno-stack-protector)
 endif
 endif
-# Find arch-specific stack protector compiler sanity-checking script.
-ifdef CONFIG_CC_STACKPROTECTOR
+ifdef stackp-name
+  # If the stack protector has been selected, inform the rest of the build.
+  KBUILD_CFLAGS += -DCONFIG_CC_STACKPROTECTOR
+  KBUILD_AFLAGS += -DCONFIG_CC_STACKPROTECTOR
+  # Find arch-specific stack protector compiler sanity-checking script.
   stackp-path := $(srctree)/scripts/gcc-$(SRCARCH)_$(BITS)-has-stack-protector.sh
   stackp-check := $(wildcard $(stackp-path))
 endif
_

Patches currently in -mm which might be from keescook@chromium.org are

writeback-convert-timers-to-use-timer_setup.patch
makefile-introduce-config_cc_stackprotector_auto.patch
makefile-introduce-config_cc_stackprotector_auto-fix.patch
makefile-introduce-config_cc_stackprotector_auto-fix-2.patch
makefile-introduce-config_cc_stackprotector_auto-fix-3.patch

