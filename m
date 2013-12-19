From: akpm@linux-foundation.org
Subject: +
 stack-protector-create-have_cc_stackprotector-for-centralized-use.patch
 added to -mm tree
Date: Thu, 19 Dec 2013 13:52:04 -0800
Message-ID: <52b36a84.OYZ8BzfV4qePJw58%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46287 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711Ab3LSVwG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Dec 2013 16:52:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, shawn.guo@linaro.org, sfr@canb.auug.org.au, ralf@linux-mips.org, mmarek@suse.cz, mingo@redhat.com, linux@arm.linux.org.uk, lethal@linux-sh.org, james.hogan@imgtec.com, hpa@zytor.com, keescook@chromium.org

Subject: + stack-protector-create-have_cc_stackprotector-for-centralized-use.patch added to -mm tree
To: keescook@chromium.org,hpa@zytor.com,james.hogan@imgtec.com,lethal@linux-sh.org,linux@arm.linux.org.uk,mingo@redhat.com,mmarek@suse.cz,ralf@linux-mips.org,sfr@canb.auug.org.au,shawn.guo@linaro.org,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Thu, 19 Dec 2013 13:52:04 -0800


The patch titled
     Subject: stack protector: create HAVE_CC_STACKPROTECTOR for centralized use
has been added to the -mm tree.  Its filename is
     stack-protector-create-have_cc_stackprotector-for-centralized-use.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/stack-protector-create-have_cc_stackprotector-for-centralized-use.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/stack-protector-create-have_cc_stackprotector-for-centralized-use.patch

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
Subject: stack protector: create HAVE_CC_STACKPROTECTOR for centralized use

Instead of duplicating the CC_STACKPROTECTOR Kconfig and Makefile logic in
each architecture, switch to using HAVE_CC_STACKPROTECTOR and keep
everything in one place.  This retains the x86-specific bug verification
scripts.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile           |   14 +++++++++++---
 arch/Kconfig       |   22 ++++++++++++++++++++++
 arch/arm/Kconfig   |   13 +------------
 arch/arm/Makefile  |    4 ----
 arch/mips/Kconfig  |   14 +-------------
 arch/mips/Makefile |    4 ----
 arch/sh/Kconfig    |   15 +--------------
 arch/sh/Makefile   |    4 ----
 arch/x86/Kconfig   |   17 +----------------
 arch/x86/Makefile  |    8 +++-----
 10 files changed, 40 insertions(+), 75 deletions(-)

diff -puN Makefile~stack-protector-create-have_cc_stackprotector-for-centralized-use Makefile
--- a/Makefile~stack-protector-create-have_cc_stackprotector-for-centralized-use
+++ a/Makefile
@@ -595,10 +595,18 @@ ifneq ($(CONFIG_FRAME_WARN),0)
 KBUILD_CFLAGS += $(call cc-option,-Wframe-larger-than=${CONFIG_FRAME_WARN})
 endif
 
-# Force gcc to behave correct even for buggy distributions
-ifndef CONFIG_CC_STACKPROTECTOR
-KBUILD_CFLAGS += $(call cc-option, -fno-stack-protector)
+# Handle stack protector mode.
+ifdef CONFIG_CC_STACKPROTECTOR
+  stackp-flag := -fstack-protector
+  ifeq ($(call cc-option, $(stackp-flag)),)
+    $(warning Cannot use CONFIG_CC_STACKPROTECTOR: \
+	      -fstack-protector not supported by compiler))
+  endif
+else
+  # Force off for distro compilers that enable stack protector by default.
+  stackp-flag := $(call cc-option, -fno-stack-protector)
 endif
+KBUILD_CFLAGS += $(stackp-flag)
 
 # This warning generated too much noise in a regular build.
 # Use make W=1 to enable this warning (see scripts/Makefile.build)
diff -puN arch/Kconfig~stack-protector-create-have_cc_stackprotector-for-centralized-use arch/Kconfig
--- a/arch/Kconfig~stack-protector-create-have_cc_stackprotector-for-centralized-use
+++ a/arch/Kconfig
@@ -336,6 +336,28 @@ config SECCOMP_FILTER
 
 	  See Documentation/prctl/seccomp_filter.txt for details.
 
+config HAVE_CC_STACKPROTECTOR
+	bool
+	help
+	  An arch should select this symbol if:
+	  - its compiler supports the -fstack-protector option
+	  - it has implemented a stack canary (e.g. __stack_chk_guard)
+
+config CC_STACKPROTECTOR
+	bool "Enable -fstack-protector buffer overflow detection"
+	depends on HAVE_CC_STACKPROTECTOR
+	help
+	  This option turns on the -fstack-protector GCC feature. This
+	  feature puts, at the beginning of functions, a canary value on
+	  the stack just before the return address, and validates
+	  the value just before actually returning.  Stack based buffer
+	  overflows (that need to overwrite this return address) now also
+	  overwrite the canary, which gets detected and the attack is then
+	  neutralized via a kernel panic.
+
+	  This feature requires gcc version 4.2 or above, or a distribution
+	  gcc with the feature backported.
+
 config HAVE_CONTEXT_TRACKING
 	bool
 	help
diff -puN arch/arm/Kconfig~stack-protector-create-have_cc_stackprotector-for-centralized-use arch/arm/Kconfig
--- a/arch/arm/Kconfig~stack-protector-create-have_cc_stackprotector-for-centralized-use
+++ a/arch/arm/Kconfig
@@ -30,6 +30,7 @@ config ARM
 	select HAVE_BPF_JIT
 	select HAVE_CONTEXT_TRACKING
 	select HAVE_C_RECORDMCOUNT
+	select HAVE_CC_STACKPROTECTOR
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DMA_API_DEBUG
 	select HAVE_DMA_ATTRS
@@ -1856,18 +1857,6 @@ config SECCOMP
 	  and the task is only allowed to execute a few safe syscalls
 	  defined by each seccomp mode.
 
-config CC_STACKPROTECTOR
-	bool "Enable -fstack-protector buffer overflow detection (EXPERIMENTAL)"
-	help
-	  This option turns on the -fstack-protector GCC feature. This
-	  feature puts, at the beginning of functions, a canary value on
-	  the stack just before the return address, and validates
-	  the value just before actually returning.  Stack based buffer
-	  overflows (that need to overwrite this return address) now also
-	  overwrite the canary, which gets detected and the attack is then
-	  neutralized via a kernel panic.
-	  This feature requires gcc version 4.2 or above.
-
 config SWIOTLB
 	def_bool y
 
diff -puN arch/arm/Makefile~stack-protector-create-have_cc_stackprotector-for-centralized-use arch/arm/Makefile
--- a/arch/arm/Makefile~stack-protector-create-have_cc_stackprotector-for-centralized-use
+++ a/arch/arm/Makefile
@@ -40,10 +40,6 @@ ifeq ($(CONFIG_FRAME_POINTER),y)
 KBUILD_CFLAGS	+=-fno-omit-frame-pointer -mapcs -mno-sched-prolog
 endif
 
-ifeq ($(CONFIG_CC_STACKPROTECTOR),y)
-KBUILD_CFLAGS	+=-fstack-protector
-endif
-
 ifeq ($(CONFIG_CPU_BIG_ENDIAN),y)
 KBUILD_CPPFLAGS	+= -mbig-endian
 AS		+= -EB
diff -puN arch/mips/Kconfig~stack-protector-create-have_cc_stackprotector-for-centralized-use arch/mips/Kconfig
--- a/arch/mips/Kconfig~stack-protector-create-have_cc_stackprotector-for-centralized-use
+++ a/arch/mips/Kconfig
@@ -47,6 +47,7 @@ config MIPS
 	select MODULES_USE_ELF_RELA if MODULES && 64BIT
 	select CLONE_BACKWARDS
 	select HAVE_DEBUG_STACKOVERFLOW
+	select HAVE_CC_STACKPROTECTOR
 
 menu "Machine selection"
 
@@ -2322,19 +2323,6 @@ config SECCOMP
 
 	  If unsure, say Y. Only embedded should say N here.
 
-config CC_STACKPROTECTOR
-	bool "Enable -fstack-protector buffer overflow detection (EXPERIMENTAL)"
-	help
-	  This option turns on the -fstack-protector GCC feature. This
-	  feature puts, at the beginning of functions, a canary value on
-	  the stack just before the return address, and validates
-	  the value just before actually returning.  Stack based buffer
-	  overflows (that need to overwrite this return address) now also
-	  overwrite the canary, which gets detected and the attack is then
-	  neutralized via a kernel panic.
-
-	  This feature requires gcc version 4.2 or above.
-
 config USE_OF
 	bool
 	select OF
diff -puN arch/mips/Makefile~stack-protector-create-have_cc_stackprotector-for-centralized-use arch/mips/Makefile
--- a/arch/mips/Makefile~stack-protector-create-have_cc_stackprotector-for-centralized-use
+++ a/arch/mips/Makefile
@@ -232,10 +232,6 @@ bootvars-y	= VMLINUX_LOAD_ADDRESS=$(load
 
 LDFLAGS			+= -m $(ld-emul)
 
-ifdef CONFIG_CC_STACKPROTECTOR
-  KBUILD_CFLAGS += -fstack-protector
-endif
-
 ifdef CONFIG_MIPS
 CHECKFLAGS += $(shell $(CC) $(KBUILD_CFLAGS) -dM -E -x c /dev/null | \
 	egrep -vw '__GNUC_(|MINOR_|PATCHLEVEL_)_' | \
diff -puN arch/sh/Kconfig~stack-protector-create-have_cc_stackprotector-for-centralized-use arch/sh/Kconfig
--- a/arch/sh/Kconfig~stack-protector-create-have_cc_stackprotector-for-centralized-use
+++ a/arch/sh/Kconfig
@@ -66,6 +66,7 @@ config SUPERH32
 	select PERF_EVENTS
 	select ARCH_HIBERNATION_POSSIBLE if MMU
 	select SPARSE_IRQ
+	select HAVE_CC_STACKPROTECTOR
 
 config SUPERH64
 	def_bool ARCH = "sh64"
@@ -695,20 +696,6 @@ config SECCOMP
 
 	  If unsure, say N.
 
-config CC_STACKPROTECTOR
-	bool "Enable -fstack-protector buffer overflow detection (EXPERIMENTAL)"
-	depends on SUPERH32
-	help
-	  This option turns on the -fstack-protector GCC feature. This
-	  feature puts, at the beginning of functions, a canary value on
-	  the stack just before the return address, and validates
-	  the value just before actually returning.  Stack based buffer
-	  overflows (that need to overwrite this return address) now also
-	  overwrite the canary, which gets detected and the attack is then
-	  neutralized via a kernel panic.
-
-	  This feature requires gcc version 4.2 or above.
-
 config SMP
 	bool "Symmetric multi-processing support"
 	depends on SYS_SUPPORTS_SMP
diff -puN arch/sh/Makefile~stack-protector-create-have_cc_stackprotector-for-centralized-use arch/sh/Makefile
--- a/arch/sh/Makefile~stack-protector-create-have_cc_stackprotector-for-centralized-use
+++ a/arch/sh/Makefile
@@ -199,10 +199,6 @@ ifeq ($(CONFIG_DWARF_UNWINDER),y)
   KBUILD_CFLAGS += -fasynchronous-unwind-tables
 endif
 
-ifeq ($(CONFIG_CC_STACKPROTECTOR),y)
-  KBUILD_CFLAGS += -fstack-protector
-endif
-
 libs-$(CONFIG_SUPERH32)		:= arch/sh/lib/	$(libs-y)
 libs-$(CONFIG_SUPERH64)		:= arch/sh/lib64/ $(libs-y)
 
diff -puN arch/x86/Kconfig~stack-protector-create-have_cc_stackprotector-for-centralized-use arch/x86/Kconfig
--- a/arch/x86/Kconfig~stack-protector-create-have_cc_stackprotector-for-centralized-use
+++ a/arch/x86/Kconfig
@@ -125,6 +125,7 @@ config X86
 	select RTC_LIB
 	select HAVE_DEBUG_STACKOVERFLOW
 	select HAVE_IRQ_EXIT_ON_IRQ_STACK if X86_64
+	select HAVE_CC_STACKPROTECTOR
 
 config INSTRUCTION_DECODER
 	def_bool y
@@ -1617,22 +1618,6 @@ config SECCOMP
 
 	  If unsure, say Y. Only embedded should say N here.
 
-config CC_STACKPROTECTOR
-	bool "Enable -fstack-protector buffer overflow detection"
-	---help---
-	  This option turns on the -fstack-protector GCC feature. This
-	  feature puts, at the beginning of functions, a canary value on
-	  the stack just before the return address, and validates
-	  the value just before actually returning.  Stack based buffer
-	  overflows (that need to overwrite this return address) now also
-	  overwrite the canary, which gets detected and the attack is then
-	  neutralized via a kernel panic.
-
-	  This feature requires gcc version 4.2 or above, or a distribution
-	  gcc with the feature backported. Older versions are automatically
-	  detected and for those versions, this configuration option is
-	  ignored. (and a warning is printed during bootup)
-
 source kernel/Kconfig.hz
 
 config KEXEC
diff -puN arch/x86/Makefile~stack-protector-create-have_cc_stackprotector-for-centralized-use arch/x86/Makefile
--- a/arch/x86/Makefile~stack-protector-create-have_cc_stackprotector-for-centralized-use
+++ a/arch/x86/Makefile
@@ -89,13 +89,11 @@ else
         KBUILD_CFLAGS += -maccumulate-outgoing-args
 endif
 
+# Make sure compiler does not have buggy stack-protector support.
 ifdef CONFIG_CC_STACKPROTECTOR
 	cc_has_sp := $(srctree)/scripts/gcc-x86_$(BITS)-has-stack-protector.sh
-        ifeq ($(shell $(CONFIG_SHELL) $(cc_has_sp) $(CC) $(KBUILD_CPPFLAGS) $(biarch)),y)
-                stackp-y := -fstack-protector
-                KBUILD_CFLAGS += $(stackp-y)
-        else
-                $(warning stack protector enabled but no compiler support)
+        ifneq ($(shell $(CONFIG_SHELL) $(cc_has_sp) $(CC) $(KBUILD_CPPFLAGS) $(biarch)),y)
+                $(warning stack-protector enabled but compiler support broken)
         endif
 endif
 
_

Patches currently in -mm which might be from keescook@chromium.org are

mm-fix-use-after-free-in-sys_remap_file_pages.patch
stack-protector-create-have_cc_stackprotector-for-centralized-use.patch
stakc-protector-provide-fstack-protector-strong-build-option.patch
test-add-minimal-module-for-verification-testing.patch
test-check-copy_to-from_user-boundary-validation.patch
test-check-copy_to-from_user-boundary-validation-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
doc-no-singing.patch
coredump-set_dumpable-fix-the-theoretical-race-with-itself.patch
coredump-kill-mmf_dumpable-and-mmf_dump_securely.patch
coredump-make-__get_dumpable-get_dumpable-inline-kill-fs-coredumph.patch
exec-check_unsafe_exec-use-while_each_thread-rather-than-next_thread.patch
exec-check_unsafe_exec-kill-the-dead-eagain-and-clear_in_exec-logic.patch
exec-move-the-final-allow_write_access-fput-into-free_bprm.patch
exec-kill-task_struct-did_exec.patch
fs-proc-arrayc-change-do_task_stat-to-use-while_each_thread.patch
kernel-sysc-k_getrusage-can-use-while_each_thread.patch
kernel-signalc-change-do_signal_stop-do_sigaction-to-use-while_each_thread.patch
linux-next.patch

