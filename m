From: akpm@linux-foundation.org
Subject: +
 stakc-protector-provide-fstack-protector-strong-build-option.patch added to -mm tree
Date: Thu, 19 Dec 2013 13:52:06 -0800
Message-ID: <52b36a86.+qIgNgLB6mAdT7Hi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46307 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984Ab3LSVwH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Dec 2013 16:52:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, shawn.guo@linaro.org, sfr@canb.auug.org.au, ralf@linux-mips.org, mmarek@suse.cz, mingo@redhat.com, linux@arm.linux.org.uk, lethal@linux-sh.org, james.hogan@imgtec.com, hpa@zytor.com, keescook@chromium.org

Subject: + stakc-protector-provide-fstack-protector-strong-build-option.patch added to -mm tree
To: keescook@chromium.org,hpa@zytor.com,james.hogan@imgtec.com,lethal@linux-sh.org,linux@arm.linux.org.uk,mingo@redhat.com,mmarek@suse.cz,ralf@linux-mips.org,sfr@canb.auug.org.au,shawn.guo@linaro.org,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Thu, 19 Dec 2013 13:52:06 -0800


The patch titled
     Subject: stakc protector: provide -fstack-protector-strong build option
has been added to the -mm tree.  Its filename is
     stakc-protector-provide-fstack-protector-strong-build-option.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/stakc-protector-provide-fstack-protector-strong-build-option.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/stakc-protector-provide-fstack-protector-strong-build-option.patch

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
Subject: stakc protector: provide -fstack-protector-strong build option

This changes the stack protector config option into a choice of "None",
"Regular", and "Strong".  For "Strong", the kernel is built with
-fstack-protector-strong (gcc 4.9 and later).  This options increases the
coverage of the stack protector without the heavy performance hit of
-fstack-protector-all.

For reference, the stack protector options available in gcc are:

-fstack-protector-all:
Adds the stack-canary saving prefix and stack-canary checking suffix to
_all_ function entry and exit. Results in substantial use of stack space
for saving the canary for deep stack users (e.g. historically xfs), and
measurable (though shockingly still low) performance hit due to all the
saving/checking. Really not suitable for sane systems, and was entirely
removed as an option from the kernel many years ago.

-fstack-protector:
Adds the canary save/check to functions that define an 8
(--param=ssp-buffer-size=N, N=8 by default) or more byte local char
array. Traditionally, stack overflows happened with string-based
manipulations, so this was a way to find those functions. Very few
total functions actually get the canary; no measurable performance or
size overhead.

-fstack-protector-strong
Adds the canary for a wider set of functions, since it's not just those
with strings that have ultimately been vulnerable to stack-busting.  With
this superset, more functions end up with a canary, but it still remains
small compared to all functions with no measurable change in performance. 
Based on the original design document, a function gets the canary when it
contains any of:

- local variable's address used as part of the RHS of an assignment or
  function argument
- local variable is an array (or union containing an array), regardless
  of array type or length
- uses register local variables
https://docs.google.com/a/google.com/document/d/1xXBH6rRZue4f296vGt9YQcuLVQHeE516stHwt8M9xyU

Comparison of "size" and "objdump" output when built with gcc-4.9 in
three configurations:
- defconfig
	11430641 text size
	36110 function bodies
- defconfig + CONFIG_CC_STACKPROTECTOR
	11468490 text size (+0.33%)
	1015 of 36110 functions stack-protected (2.81%)
- defconfig + CONFIG_CC_STACKPROTECTOR_STRONG via this patch
	11692790 text size (+2.24%)
	7401 of 36110 functions stack-protected (20.5%)

With -strong, ARM's compressed boot code now triggers stack protection, so
a static guard was added.  Since this is only used during decompression
and was never used before, the exposure here is very small.  Once it
switches to the full kernel, the stack guard is back to normal.

Chrome OS has been using -fstack-protector-strong for its kernel builds
for the last 8 months with no problems.

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

 Makefile                        |    8 ++++
 arch/Kconfig                    |   50 ++++++++++++++++++++++++++++--
 arch/arm/boot/compressed/misc.c |   14 ++++++++
 3 files changed, 68 insertions(+), 4 deletions(-)

diff -puN Makefile~stakc-protector-provide-fstack-protector-strong-build-option Makefile
--- a/Makefile~stakc-protector-provide-fstack-protector-strong-build-option
+++ a/Makefile
@@ -596,12 +596,18 @@ KBUILD_CFLAGS += $(call cc-option,-Wfram
 endif
 
 # Handle stack protector mode.
-ifdef CONFIG_CC_STACKPROTECTOR
+ifdef CONFIG_CC_STACKPROTECTOR_REGULAR
   stackp-flag := -fstack-protector
   ifeq ($(call cc-option, $(stackp-flag)),)
     $(warning Cannot use CONFIG_CC_STACKPROTECTOR: \
 	      -fstack-protector not supported by compiler))
   endif
+else ifdef CONFIG_CC_STACKPROTECTOR_STRONG
+  stackp-flag := -fstack-protector-strong
+  ifeq ($(call cc-option, $(stackp-flag)),)
+    $(warning Cannot use CONFIG_CC_STACKPROTECTOR_STRONG: \
+	      -fstack-protector-strong not supported by compiler)
+  endif
 else
   # Force off for distro compilers that enable stack protector by default.
   stackp-flag := $(call cc-option, -fno-stack-protector)
diff -puN arch/Kconfig~stakc-protector-provide-fstack-protector-strong-build-option arch/Kconfig
--- a/arch/Kconfig~stakc-protector-provide-fstack-protector-strong-build-option
+++ a/arch/Kconfig
@@ -344,10 +344,17 @@ config HAVE_CC_STACKPROTECTOR
 	  - it has implemented a stack canary (e.g. __stack_chk_guard)
 
 config CC_STACKPROTECTOR
-	bool "Enable -fstack-protector buffer overflow detection"
+	def_bool n
+	help
+	  Set when a stack-protector mode is enabled, so that the build
+	  can enable kernel-side support for the GCC feature.
+
+choice
+	prompt "Stack Protector buffer overflow detection"
 	depends on HAVE_CC_STACKPROTECTOR
+	default CC_STACKPROTECTOR_NONE
 	help
-	  This option turns on the -fstack-protector GCC feature. This
+	  This option turns on the "stack-protector" GCC feature. This
 	  feature puts, at the beginning of functions, a canary value on
 	  the stack just before the return address, and validates
 	  the value just before actually returning.  Stack based buffer
@@ -355,8 +362,45 @@ config CC_STACKPROTECTOR
 	  overwrite the canary, which gets detected and the attack is then
 	  neutralized via a kernel panic.
 
+config CC_STACKPROTECTOR_NONE
+	bool "None"
+	help
+	  Disable "stack-protector" GCC feature.
+
+config CC_STACKPROTECTOR_REGULAR
+	bool "Regular"
+	select CC_STACKPROTECTOR
+	help
+	  Functions will have the stack-protector canary logic added if they
+	  have an 8-byte or larger character array on the stack.
+
 	  This feature requires gcc version 4.2 or above, or a distribution
-	  gcc with the feature backported.
+	  gcc with the feature backported ("-fstack-protector").
+
+	  On an x86 "defconfig" build, this feature adds canary checks to
+	  about 3% of all kernel functions, which increases kernel code size
+	  by about 0.3%.
+
+config CC_STACKPROTECTOR_STRONG
+	bool "Strong"
+	select CC_STACKPROTECTOR
+	help
+	  Functions will have the stack-protector canary logic added in any
+	  of the following conditions:
+	  - local variable's address used as part of the RHS of an
+	    assignment or function argument
+	  - local variable is an array (or union containing an array),
+	    regardless of array type or length
+	  - uses register local variables
+
+	  This feature requires gcc version 4.9 or above, or a distribution
+	  gcc with the feature backported ("-fstack-protector-strong").
+
+	  On an x86 "defconfig" build, this feature adds canary checks to
+	  about 20% of all kernel functions, which increases the kernel code
+	  size by about 2%.
+
+endchoice
 
 config HAVE_CONTEXT_TRACKING
 	bool
diff -puN arch/arm/boot/compressed/misc.c~stakc-protector-provide-fstack-protector-strong-build-option arch/arm/boot/compressed/misc.c
--- a/arch/arm/boot/compressed/misc.c~stakc-protector-provide-fstack-protector-strong-build-option
+++ a/arch/arm/boot/compressed/misc.c
@@ -127,6 +127,18 @@ asmlinkage void __div0(void)
 	error("Attempting division by 0!");
 }
 
+unsigned long __stack_chk_guard;
+
+void __stack_chk_guard_setup(void)
+{
+	__stack_chk_guard = 0x000a0dff;
+}
+
+void __stack_chk_fail(void)
+{
+	error("stack-protector: Kernel stack is corrupted\n");
+}
+
 extern int do_decompress(u8 *input, int len, u8 *output, void (*error)(char *x));
 
 
@@ -137,6 +149,8 @@ decompress_kernel(unsigned long output_s
 {
 	int ret;
 
+	__stack_chk_guard_setup();
+
 	output_data		= (unsigned char *)output_start;
 	free_mem_ptr		= free_mem_ptr_p;
 	free_mem_end_ptr	= free_mem_ptr_end_p;
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

