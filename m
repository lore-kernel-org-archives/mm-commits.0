From: akpm@linux-foundation.org
Subject: [merged]
 ubsan-split-bounds-checker-from-other-options.patch removed from -mm tree
Date: Tue, 07 Apr 2020 19:02:24 -0700
Message-ID: <20200408020224.VSoVj02k8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgDHCC0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 22:02:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, ard.biesheuvel@linaro.org, arnd@arndb.de, aryabinin@virtuozzo.com, dan.carpenter@oracle.com, dvyukov@google.com, glider@google.com, gustavo@embeddedor.com, keescook@chromium.org, lenaptr@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ubsan: split "bounds" checker from other options
has been removed from the -mm tree.  Its filename was
     ubsan-split-bounds-checker-from-other-options.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: ubsan: split "bounds" checker from other options

In order to do kernel builds with the bounds checker individually
available, introduce CONFIG_UBSAN_BOUNDS, with the remaining options under
CONFIG_UBSAN_MISC.

For example, using this, we can start to expand the coverage syzkaller is
providing.  Right now, all of UBSan is disabled for syzbot builds because
taken as a whole, it is too noisy.  This will let us focus on one feature
at a time.

For the bounds checker specifically, this provides a mechanism to
eliminate an entire class of array overflows with close to zero
performance overhead (I cannot measure a difference).  In my (mostly)
defconfig, enabling bounds checking adds ~4200 checks to the kernel. 
Performance changes are in the noise, likely due to the branch predictors
optimizing for the non-fail path.

Some notes on the bounds checker:

- it does not instrument {mem,str}*()-family functions, it only
  instruments direct indexed accesses (e.g. "foo[i]"). Dealing with
  the {mem,str}*()-family functions is a work-in-progress around
  CONFIG_FORTIFY_SOURCE[1].

- it ignores flexible array members, including the very old single
  byte (e.g. "int foo[1];") declarations. (Note that GCC's
  implementation appears to ignore _all_ trailing arrays, but Clang only
  ignores empty, 0, and 1 byte arrays[2].)

[1] https://github.com/KSPP/linux/issues/6
[2] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=92589

Link: http://lkml.kernel.org/r/20200227193516.32566-3-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Suggested-by: Elena Petrova <lenaptr@google.com>
Reviewed-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.ubsan      |   29 ++++++++++++++++++++++++-----
 scripts/Makefile.ubsan |    7 ++++++-
 2 files changed, 30 insertions(+), 6 deletions(-)

--- a/lib/Kconfig.ubsan~ubsan-split-bounds-checker-from-other-options
+++ a/lib/Kconfig.ubsan
@@ -2,7 +2,7 @@
 config ARCH_HAS_UBSAN_SANITIZE_ALL
 	bool
 
-config UBSAN
+menuconfig UBSAN
 	bool "Undefined behaviour sanity checker"
 	help
 	  This option enables the Undefined Behaviour sanity checker.
@@ -10,9 +10,10 @@ config UBSAN
 	  behaviours at runtime. For more details, see:
 	  Documentation/dev-tools/ubsan.rst
 
+if UBSAN
+
 config UBSAN_TRAP
 	bool "On Sanitizer warnings, abort the running kernel code"
-	depends on UBSAN
 	depends on $(cc-option, -fsanitize-undefined-trap-on-error)
 	help
 	  Building kernels with Sanitizer features enabled tends to grow
@@ -25,9 +26,26 @@ config UBSAN_TRAP
 	  the system. For some system builders this is an acceptable
 	  trade-off.
 
+config UBSAN_BOUNDS
+	bool "Perform array index bounds checking"
+	default UBSAN
+	help
+	  This option enables detection of directly indexed out of bounds
+	  array accesses, where the array size is known at compile time.
+	  Note that this does not protect array overflows via bad calls
+	  to the {str,mem}*cpy() family of functions (that is addressed
+	  by CONFIG_FORTIFY_SOURCE).
+
+config UBSAN_MISC
+	bool "Enable all other Undefined Behavior sanity checks"
+	default UBSAN
+	help
+	  This option enables all sanity checks that don't have their
+	  own Kconfig options. Disable this if you only want to have
+	  individually selected checks.
+
 config UBSAN_SANITIZE_ALL
 	bool "Enable instrumentation for the entire kernel"
-	depends on UBSAN
 	depends on ARCH_HAS_UBSAN_SANITIZE_ALL
 
 	# We build with -Wno-maybe-uninitilzed, but we still want to
@@ -44,7 +62,6 @@ config UBSAN_SANITIZE_ALL
 
 config UBSAN_NO_ALIGNMENT
 	bool "Disable checking of pointers alignment"
-	depends on UBSAN
 	default y if HAVE_EFFICIENT_UNALIGNED_ACCESS
 	help
 	  This option disables the check of unaligned memory accesses.
@@ -57,7 +74,9 @@ config UBSAN_ALIGNMENT
 
 config TEST_UBSAN
 	tristate "Module for testing for undefined behavior detection"
-	depends on m && UBSAN
+	depends on m
 	help
 	  This is a test module for UBSAN.
 	  It triggers various undefined behavior, and detect it.
+
+endif	# if UBSAN
--- a/scripts/Makefile.ubsan~ubsan-split-bounds-checker-from-other-options
+++ a/scripts/Makefile.ubsan
@@ -5,14 +5,19 @@ ifdef CONFIG_UBSAN_ALIGNMENT
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=alignment)
 endif
 
+ifdef CONFIG_UBSAN_BOUNDS
+      CFLAGS_UBSAN += $(call cc-option, -fsanitize=bounds)
+endif
+
+ifdef CONFIG_UBSAN_MISC
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=shift)
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=integer-divide-by-zero)
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=unreachable)
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=signed-integer-overflow)
-      CFLAGS_UBSAN += $(call cc-option, -fsanitize=bounds)
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=object-size)
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=bool)
       CFLAGS_UBSAN += $(call cc-option, -fsanitize=enum)
+endif
 
 ifdef CONFIG_UBSAN_TRAP
       CFLAGS_UBSAN += $(call cc-option, -fsanitize-undefined-trap-on-error)
_

Patches currently in -mm which might be from keescook@chromium.org are
