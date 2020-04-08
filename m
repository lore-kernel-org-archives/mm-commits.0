From: akpm@linux-foundation.org
Subject: [merged]
 lib-test_stackinitc-xfail-switch-variable-init-tests.patch removed from -mm
 tree
Date: Tue, 07 Apr 2020 19:01:02 -0700
Message-ID: <20200408020102.nnJ2dkc70%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgDHCBE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 22:01:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ard.biesheuvel@linaro.org, glider@google.com, jannh@google.com, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: test_stackinit.c: XFAIL switch variable init tests
has been removed from the -mm tree.  Its filename was
     lib-test_stackinitc-xfail-switch-variable-init-tests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: lib: test_stackinit.c: XFAIL switch variable init tests

The tests for initializing a variable defined between a switch statement's
test and its first "case" statement are currently not initialized in
Clang[1] nor the proposed auto-initialization feature in GCC.

We should retain the test (so that we can evaluate compiler fixes), but
mark it as an "expected fail".  The rest of the kernel source will be
adjusted to avoid this corner case.

Also disable -Wswitch-unreachable for the test so that the intentionally
broken code won't trigger warnings for GCC (nor future Clang) when
initialization happens this unhandled place.

[1] https://bugs.llvm.org/show_bug.cgi?id=44916

Link: http://lkml.kernel.org/r/202002191358.2897A07C6@keescook
Signed-off-by: Kees Cook <keescook@chromium.org>
Suggested-by: Alexander Potapenko <glider@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Makefile         |    1 +
 lib/test_stackinit.c |   28 ++++++++++++++++++----------
 2 files changed, 19 insertions(+), 10 deletions(-)

--- a/lib/Makefile~lib-test_stackinitc-xfail-switch-variable-init-tests
+++ a/lib/Makefile
@@ -87,6 +87,7 @@ obj-$(CONFIG_TEST_KMOD) += test_kmod.o
 obj-$(CONFIG_TEST_DEBUG_VIRTUAL) += test_debug_virtual.o
 obj-$(CONFIG_TEST_MEMCAT_P) += test_memcat_p.o
 obj-$(CONFIG_TEST_OBJAGG) += test_objagg.o
+CFLAGS_test_stackinit.o += $(call cc-disable-warning, switch-unreachable)
 obj-$(CONFIG_TEST_STACKINIT) += test_stackinit.o
 obj-$(CONFIG_TEST_BLACKHOLE_DEV) += test_blackhole_dev.o
 obj-$(CONFIG_TEST_MEMINIT) += test_meminit.o
--- a/lib/test_stackinit.c~lib-test_stackinitc-xfail-switch-variable-init-tests
+++ a/lib/test_stackinit.c
@@ -92,8 +92,9 @@ static bool range_contains(char *haystac
  * @var_type: type to be tested for zeroing initialization
  * @which: is this a SCALAR, STRING, or STRUCT type?
  * @init_level: what kind of initialization is performed
+ * @xfail: is this test expected to fail?
  */
-#define DEFINE_TEST_DRIVER(name, var_type, which)		\
+#define DEFINE_TEST_DRIVER(name, var_type, which, xfail)	\
 /* Returns 0 on success, 1 on failure. */			\
 static noinline __init int test_ ## name (void)			\
 {								\
@@ -139,13 +140,14 @@ static noinline __init int test_ ## name
 	for (sum = 0, i = 0; i < target_size; i++)		\
 		sum += (check_buf[i] == 0xFF);			\
 								\
-	if (sum == 0)						\
+	if (sum == 0) {						\
 		pr_info(#name " ok\n");				\
-	else							\
-		pr_warn(#name " FAIL (uninit bytes: %d)\n",	\
-			sum);					\
-								\
-	return (sum != 0);					\
+		return 0;					\
+	} else {						\
+		pr_warn(#name " %sFAIL (uninit bytes: %d)\n",	\
+			(xfail) ? "X" : "", sum);		\
+		return (xfail) ? 0 : 1;				\
+	}							\
 }
 #define DEFINE_TEST(name, var_type, which, init_level)		\
 /* no-op to force compiler into ignoring "uninitialized" vars */\
@@ -189,7 +191,7 @@ static noinline __init int leaf_ ## name
 								\
 	return (int)buf[0] | (int)buf[sizeof(buf) - 1];		\
 }								\
-DEFINE_TEST_DRIVER(name, var_type, which)
+DEFINE_TEST_DRIVER(name, var_type, which, 0)
 
 /* Structure with no padding. */
 struct test_packed {
@@ -326,8 +328,14 @@ static noinline __init int leaf_switch_2
 	return __leaf_switch_none(2, fill);
 }
 
-DEFINE_TEST_DRIVER(switch_1_none, uint64_t, SCALAR);
-DEFINE_TEST_DRIVER(switch_2_none, uint64_t, SCALAR);
+/*
+ * These are expected to fail for most configurations because neither
+ * GCC nor Clang have a way to perform initialization of variables in
+ * non-code areas (i.e. in a switch statement before the first "case").
+ * https://bugs.llvm.org/show_bug.cgi?id=44916
+ */
+DEFINE_TEST_DRIVER(switch_1_none, uint64_t, SCALAR, 1);
+DEFINE_TEST_DRIVER(switch_2_none, uint64_t, SCALAR, 1);
 
 static int __init test_stackinit_init(void)
 {
_

Patches currently in -mm which might be from keescook@chromium.org are
