From: akpm@linux-foundation.org
Subject: [merged]
 kasan-fix-clang-compilation-warning-due-to-stack-protector.patch removed
 from -mm tree
Date: Tue, 02 Jun 2020 14:43:17 -0700
Message-ID: <20200602214317.Nm5Dr0GNn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbgFBVnR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:43:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, cai@lca.pw, elver@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fix clang compilation warning due to stack protector
has been removed from the -mm tree.  Its filename was
     kasan-fix-clang-compilation-warning-due-to-stack-protector.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: fix clang compilation warning due to stack protector

KASAN uses a single cc-option invocation to disable both conserve-stack
and stack-protector flags.  The former flag is not present in Clang, which
causes cc-option to fail, and results in stack-protector being enabled.

Fix by using separate cc-option calls for each flag.  Also collect all
flags in a variable to avoid calling cc-option multiple times for
different files.

Link: http://lkml.kernel.org/r/c2f0c8e4048852ae014f4a391d96ca42d27e3255.1590779332.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reported-by: Qian Cai <cai@lca.pw>
Reviewed-by: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/Makefile |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/mm/kasan/Makefile~kasan-fix-clang-compilation-warning-due-to-stack-protector
+++ a/mm/kasan/Makefile
@@ -15,14 +15,19 @@ CFLAGS_REMOVE_tags_report.o = $(CC_FLAGS
 
 # Function splitter causes unnecessary splits in __asan_load1/__asan_store1
 # see: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=63533
-CFLAGS_common.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector) -DDISABLE_BRANCH_PROFILING
-CFLAGS_generic.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector) -DDISABLE_BRANCH_PROFILING
-CFLAGS_generic_report.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector) -DDISABLE_BRANCH_PROFILING
-CFLAGS_init.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector) -DDISABLE_BRANCH_PROFILING
-CFLAGS_quarantine.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector) -DDISABLE_BRANCH_PROFILING
-CFLAGS_report.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector) -DDISABLE_BRANCH_PROFILING
-CFLAGS_tags.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector) -DDISABLE_BRANCH_PROFILING
-CFLAGS_tags_report.o := $(call cc-option, -fno-conserve-stack -fno-stack-protector) -DDISABLE_BRANCH_PROFILING
+CC_FLAGS_KASAN_RUNTIME := $(call cc-option, -fno-conserve-stack)
+CC_FLAGS_KASAN_RUNTIME += $(call cc-option, -fno-stack-protector)
+# Disable branch tracing to avoid recursion.
+CC_FLAGS_KASAN_RUNTIME += -DDISABLE_BRANCH_PROFILING
+
+CFLAGS_common.o := $(CC_FLAGS_KASAN_RUNTIME)
+CFLAGS_generic.o := $(CC_FLAGS_KASAN_RUNTIME)
+CFLAGS_generic_report.o := $(CC_FLAGS_KASAN_RUNTIME)
+CFLAGS_init.o := $(CC_FLAGS_KASAN_RUNTIME)
+CFLAGS_quarantine.o := $(CC_FLAGS_KASAN_RUNTIME)
+CFLAGS_report.o := $(CC_FLAGS_KASAN_RUNTIME)
+CFLAGS_tags.o := $(CC_FLAGS_KASAN_RUNTIME)
+CFLAGS_tags_report.o := $(CC_FLAGS_KASAN_RUNTIME)
 
 obj-$(CONFIG_KASAN) := common.o init.o report.o
 obj-$(CONFIG_KASAN_GENERIC) += generic.o generic_report.o quarantine.o
_

Patches currently in -mm which might be from andreyknvl@google.com are

kcov-cleanup-debug-messages.patch
kcov-fix-potential-use-after-free-in-kcov_remote_start.patch
kcov-move-t-kcov-assignments-into-kcov_start-stop.patch
kcov-move-t-kcov_sequence-assignment.patch
kcov-use-t-kcov_mode-as-enabled-indicator.patch
kcov-collect-coverage-from-interrupts.patch
usb-core-kcov-collect-coverage-from-usb-complete-callback.patch
