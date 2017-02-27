From: akpm@linux-foundation.org
Subject: [merged] lib-add-module-support-to-atomic64-tests.patch removed
 from -mm tree
Date: Mon, 27 Feb 2017 12:28:57 -0800
Message-ID: <58b48c09.ReJqpxUb6Qm1LgmC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34522 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751588AbdB0Ukd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:40:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, andy.shevchenko@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: add module support to atomic64 tests
has been removed from the -mm tree.  Its filename was
     lib-add-module-support-to-atomic64-tests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: lib: add module support to atomic64 tests

Allow to compile the atomic64 test code either to a loadable module, or
builtin into the kernel.

Link: http://lkml.kernel.org/r/1483470276-10517-3-git-send-email-geert@linux-m68k.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug   |    5 +++--
 lib/atomic64_test.c |   10 ++++++++--
 2 files changed, 11 insertions(+), 4 deletions(-)

diff -puN lib/Kconfig.debug~lib-add-module-support-to-atomic64-tests lib/Kconfig.debug
--- a/lib/Kconfig.debug~lib-add-module-support-to-atomic64-tests
+++ a/lib/Kconfig.debug
@@ -1790,9 +1790,10 @@ config PERCPU_TEST
 	  If unsure, say N.
 
 config ATOMIC64_SELFTEST
-	bool "Perform an atomic64_t self-test at boot"
+	tristate "Perform an atomic64_t self-test"
 	help
-	  Enable this option to test the atomic64_t functions at boot.
+	  Enable this option to test the atomic64_t functions at boot or
+	  at module load time.
 
 	  If unsure, say N.
 
diff -puN lib/atomic64_test.c~lib-add-module-support-to-atomic64-tests lib/atomic64_test.c
--- a/lib/atomic64_test.c~lib-add-module-support-to-atomic64-tests
+++ a/lib/atomic64_test.c
@@ -15,6 +15,7 @@
 #include <linux/bug.h>
 #include <linux/kernel.h>
 #include <linux/atomic.h>
+#include <linux/module.h>
 
 #ifdef CONFIG_X86
 #include <asm/cpufeature.h>	/* for boot_cpu_has below */
@@ -241,7 +242,7 @@ static __init void test_atomic64(void)
 	BUG_ON(v.counter != r);
 }
 
-static __init int test_atomics(void)
+static __init int test_atomics_init(void)
 {
 	test_atomic();
 	test_atomic64();
@@ -264,4 +265,9 @@ static __init int test_atomics(void)
 	return 0;
 }
 
-core_initcall(test_atomics);
+static __exit void test_atomics_exit(void) {}
+
+module_init(test_atomics_init);
+module_exit(test_atomics_exit);
+
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from geert@linux-m68k.org are


