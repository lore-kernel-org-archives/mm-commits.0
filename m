From: akpm@linux-foundation.org
Subject: + makefile-support-flag-fsanitizer-coverage=trace-cmp.patch added to -mm tree
Date: Wed, 11 Oct 2017 16:15:15 -0700
Message-ID: <59dea603.bZFQNk7L5ixblFrb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41110 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750999AbdJKXPR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Oct 2017 19:15:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tchibo@google.com, alex.popov@linux.com, andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, keescook@chromium.org, mark.rutland@arm.com, quentin.casasnovas@oracle.com, syzkaller@googlegroups.com, vegard.nossum@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Makefile: support flag -fsanitizer-coverage=trace-cmp
has been added to the -mm tree.  Its filename is
     makefile-support-flag-fsanitizer-coverage=trace-cmp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/makefile-support-flag-fsanitizer-coverage%3Dtrace-cmp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/makefile-support-flag-fsanitizer-coverage%3Dtrace-cmp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Victor Chibotaru <tchibo@google.com>
Subject: Makefile: support flag -fsanitizer-coverage=trace-cmp

The flag enables Clang instrumentation of comparison operations (currently
not supported by GCC).  This instrumentation is needed by the new KCOV
device to collect comparison operands.

Link: http://lkml.kernel.org/r/20171011095459.70721-2-glider@google.com
Signed-off-by: Victor Chibotaru <tchibo@google.com>
Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alexander Popov <alex.popov@linux.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Cc: <syzkaller@googlegroups.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile              |    3 +--
 lib/Kconfig.debug     |   10 ++++++++++
 scripts/Makefile.kcov |    7 +++++++
 3 files changed, 18 insertions(+), 2 deletions(-)

diff -puN lib/Kconfig.debug~makefile-support-flag-fsanitizer-coverage=trace-cmp lib/Kconfig.debug
--- a/lib/Kconfig.debug~makefile-support-flag-fsanitizer-coverage=trace-cmp
+++ a/lib/Kconfig.debug
@@ -759,6 +759,16 @@ config KCOV
 
 	  For more details, see Documentation/dev-tools/kcov.rst.
 
+config KCOV_ENABLE_COMPARISONS
+	bool "Enable comparison operands collection by KCOV"
+	depends on KCOV
+	default n
+	help
+	  KCOV also exposes operands of every comparison in the instrumented
+	  code along with operand sizes and PCs of the comparison instructions.
+	  These operands can be used by fuzzing engines to improve the quality
+	  of fuzzing coverage.
+
 config KCOV_INSTRUMENT_ALL
 	bool "Instrument all code by default"
 	depends on KCOV
diff -puN Makefile~makefile-support-flag-fsanitizer-coverage=trace-cmp Makefile
--- a/Makefile~makefile-support-flag-fsanitizer-coverage=trace-cmp
+++ a/Makefile
@@ -373,8 +373,6 @@ CFLAGS_KERNEL	=
 AFLAGS_KERNEL	=
 LDFLAGS_vmlinux =
 CFLAGS_GCOV	:= -fprofile-arcs -ftest-coverage -fno-tree-loop-im $(call cc-disable-warning,maybe-uninitialized,)
-CFLAGS_KCOV	:= $(call cc-option,-fsanitize-coverage=trace-pc,)
-
 
 # Use USERINCLUDE when you must reference the UAPI directories only.
 USERINCLUDE    := \
@@ -657,6 +655,7 @@ ifeq ($(shell $(CONFIG_SHELL) $(srctree)
 	KBUILD_AFLAGS += -DCC_HAVE_ASM_GOTO
 endif
 
+include scripts/Makefile.kcov
 include scripts/Makefile.gcc-plugins
 
 ifdef CONFIG_READABLE_ASM
diff -puN /dev/null scripts/Makefile.kcov
--- /dev/null
+++ a/scripts/Makefile.kcov
@@ -0,0 +1,7 @@
+ifdef CONFIG_KCOV
+CFLAGS_KCOV	:= $(call cc-option,-fsanitize-coverage=trace-pc,)
+ifeq ($(CONFIG_KCOV_ENABLE_COMPARISONS),y)
+CFLAGS_KCOV += $(call cc-option,-fsanitize-coverage=trace-cmp,)
+endif
+
+endif
_

Patches currently in -mm which might be from tchibo@google.com are

kcov-support-comparison-operands-collection.patch
makefile-support-flag-fsanitizer-coverage=trace-cmp.patch
kcov-update-documentation.patch

