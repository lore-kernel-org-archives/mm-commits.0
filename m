From: akpm@linux-foundation.org
Subject: + lib-add-module-support-to-string-tests.patch added to -mm tree
Date: Wed, 27 Sep 2017 16:32:36 -0700
Message-ID: <59cc3514.VgOdtP9Jiy4JzQNC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33048 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752152AbdI0Xch (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Sep 2017 19:32:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, mawilcox@microsoft.com, shuah@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: add module support to string tests
has been added to the -mm tree.  Its filename is
     lib-add-module-support-to-string-tests.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-add-module-support-to-string-tests.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-add-module-support-to-string-tests.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: lib: add module support to string tests

Extract the string test code into its own source file, to allow compiling
it either to a loadable module, or built into the kernel.

Fixes: 03270c13c5ffaa6a ("lib/string.c: add testcases for memset16/32/64")
Link: http://lkml.kernel.org/r/1505397744-3387-1-git-send-email-geert@linux-m68k.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig       |    2 
 lib/Makefile      |    1 
 lib/string.c      |  141 --------------------------------------------
 lib/test_string.c |  141 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 143 insertions(+), 142 deletions(-)

diff -puN lib/Kconfig~lib-add-module-support-to-string-tests lib/Kconfig
--- a/lib/Kconfig~lib-add-module-support-to-string-tests
+++ a/lib/Kconfig
@@ -584,6 +584,6 @@ config PRIME_NUMBERS
 	tristate
 
 config STRING_SELFTEST
-	bool "Test string functions"
+	tristate "Test string functions"
 
 endmenu
diff -puN lib/Makefile~lib-add-module-support-to-string-tests lib/Makefile
--- a/lib/Makefile~lib-add-module-support-to-string-tests
+++ a/lib/Makefile
@@ -39,6 +39,7 @@ obj-y += bcd.o div64.o sort.o parser.o d
 	 bsearch.o find_bit.o llist.o memweight.o kfifo.o \
 	 percpu-refcount.o percpu_ida.o rhashtable.o reciprocal_div.o \
 	 once.o refcount.o usercopy.o errseq.o
+obj-$(CONFIG_STRING_SELFTEST) += test_string.o
 obj-y += string_helpers.o
 obj-$(CONFIG_TEST_STRING_HELPERS) += test-string_helpers.o
 obj-y += hexdump.o
diff -puN lib/string.c~lib-add-module-support-to-string-tests lib/string.c
--- a/lib/string.c~lib-add-module-support-to-string-tests
+++ a/lib/string.c
@@ -1051,144 +1051,3 @@ void fortify_panic(const char *name)
 	BUG();
 }
 EXPORT_SYMBOL(fortify_panic);
-
-#ifdef CONFIG_STRING_SELFTEST
-#include <linux/slab.h>
-#include <linux/module.h>
-
-static __init int memset16_selftest(void)
-{
-	unsigned i, j, k;
-	u16 v, *p;
-
-	p = kmalloc(256 * 2 * 2, GFP_KERNEL);
-	if (!p)
-		return -1;
-
-	for (i = 0; i < 256; i++) {
-		for (j = 0; j < 256; j++) {
-			memset(p, 0xa1, 256 * 2 * sizeof(v));
-			memset16(p + i, 0xb1b2, j);
-			for (k = 0; k < 512; k++) {
-				v = p[k];
-				if (k < i) {
-					if (v != 0xa1a1)
-						goto fail;
-				} else if (k < i + j) {
-					if (v != 0xb1b2)
-						goto fail;
-				} else {
-					if (v != 0xa1a1)
-						goto fail;
-				}
-			}
-		}
-	}
-
-fail:
-	kfree(p);
-	if (i < 256)
-		return (i << 24) | (j << 16) | k;
-	return 0;
-}
-
-static __init int memset32_selftest(void)
-{
-	unsigned i, j, k;
-	u32 v, *p;
-
-	p = kmalloc(256 * 2 * 4, GFP_KERNEL);
-	if (!p)
-		return -1;
-
-	for (i = 0; i < 256; i++) {
-		for (j = 0; j < 256; j++) {
-			memset(p, 0xa1, 256 * 2 * sizeof(v));
-			memset32(p + i, 0xb1b2b3b4, j);
-			for (k = 0; k < 512; k++) {
-				v = p[k];
-				if (k < i) {
-					if (v != 0xa1a1a1a1)
-						goto fail;
-				} else if (k < i + j) {
-					if (v != 0xb1b2b3b4)
-						goto fail;
-				} else {
-					if (v != 0xa1a1a1a1)
-						goto fail;
-				}
-			}
-		}
-	}
-
-fail:
-	kfree(p);
-	if (i < 256)
-		return (i << 24) | (j << 16) | k;
-	return 0;
-}
-
-static __init int memset64_selftest(void)
-{
-	unsigned i, j, k;
-	u64 v, *p;
-
-	p = kmalloc(256 * 2 * 8, GFP_KERNEL);
-	if (!p)
-		return -1;
-
-	for (i = 0; i < 256; i++) {
-		for (j = 0; j < 256; j++) {
-			memset(p, 0xa1, 256 * 2 * sizeof(v));
-			memset64(p + i, 0xb1b2b3b4b5b6b7b8ULL, j);
-			for (k = 0; k < 512; k++) {
-				v = p[k];
-				if (k < i) {
-					if (v != 0xa1a1a1a1a1a1a1a1ULL)
-						goto fail;
-				} else if (k < i + j) {
-					if (v != 0xb1b2b3b4b5b6b7b8ULL)
-						goto fail;
-				} else {
-					if (v != 0xa1a1a1a1a1a1a1a1ULL)
-						goto fail;
-				}
-			}
-		}
-	}
-
-fail:
-	kfree(p);
-	if (i < 256)
-		return (i << 24) | (j << 16) | k;
-	return 0;
-}
-
-static __init int string_selftest_init(void)
-{
-	int test, subtest;
-
-	test = 1;
-	subtest = memset16_selftest();
-	if (subtest)
-		goto fail;
-
-	test = 2;
-	subtest = memset32_selftest();
-	if (subtest)
-		goto fail;
-
-	test = 3;
-	subtest = memset64_selftest();
-	if (subtest)
-		goto fail;
-
-	pr_info("String selftests succeeded\n");
-	return 0;
-fail:
-	pr_crit("String selftest failure %d.%08x\n", test, subtest);
-	return 0;
-}
-
-module_init(string_selftest_init);
-#endif	/* CONFIG_STRING_SELFTEST */
diff -puN /dev/null lib/test_string.c
--- /dev/null
+++ a/lib/test_string.c
@@ -0,0 +1,141 @@
+#include <linux/module.h>
+#include <linux/printk.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+
+static __init int memset16_selftest(void)
+{
+	unsigned i, j, k;
+	u16 v, *p;
+
+	p = kmalloc(256 * 2 * 2, GFP_KERNEL);
+	if (!p)
+		return -1;
+
+	for (i = 0; i < 256; i++) {
+		for (j = 0; j < 256; j++) {
+			memset(p, 0xa1, 256 * 2 * sizeof(v));
+			memset16(p + i, 0xb1b2, j);
+			for (k = 0; k < 512; k++) {
+				v = p[k];
+				if (k < i) {
+					if (v != 0xa1a1)
+						goto fail;
+				} else if (k < i + j) {
+					if (v != 0xb1b2)
+						goto fail;
+				} else {
+					if (v != 0xa1a1)
+						goto fail;
+				}
+			}
+		}
+	}
+
+fail:
+	kfree(p);
+	if (i < 256)
+		return (i << 24) | (j << 16) | k;
+	return 0;
+}
+
+static __init int memset32_selftest(void)
+{
+	unsigned i, j, k;
+	u32 v, *p;
+
+	p = kmalloc(256 * 2 * 4, GFP_KERNEL);
+	if (!p)
+		return -1;
+
+	for (i = 0; i < 256; i++) {
+		for (j = 0; j < 256; j++) {
+			memset(p, 0xa1, 256 * 2 * sizeof(v));
+			memset32(p + i, 0xb1b2b3b4, j);
+			for (k = 0; k < 512; k++) {
+				v = p[k];
+				if (k < i) {
+					if (v != 0xa1a1a1a1)
+						goto fail;
+				} else if (k < i + j) {
+					if (v != 0xb1b2b3b4)
+						goto fail;
+				} else {
+					if (v != 0xa1a1a1a1)
+						goto fail;
+				}
+			}
+		}
+	}
+
+fail:
+	kfree(p);
+	if (i < 256)
+		return (i << 24) | (j << 16) | k;
+	return 0;
+}
+
+static __init int memset64_selftest(void)
+{
+	unsigned i, j, k;
+	u64 v, *p;
+
+	p = kmalloc(256 * 2 * 8, GFP_KERNEL);
+	if (!p)
+		return -1;
+
+	for (i = 0; i < 256; i++) {
+		for (j = 0; j < 256; j++) {
+			memset(p, 0xa1, 256 * 2 * sizeof(v));
+			memset64(p + i, 0xb1b2b3b4b5b6b7b8ULL, j);
+			for (k = 0; k < 512; k++) {
+				v = p[k];
+				if (k < i) {
+					if (v != 0xa1a1a1a1a1a1a1a1ULL)
+						goto fail;
+				} else if (k < i + j) {
+					if (v != 0xb1b2b3b4b5b6b7b8ULL)
+						goto fail;
+				} else {
+					if (v != 0xa1a1a1a1a1a1a1a1ULL)
+						goto fail;
+				}
+			}
+		}
+	}
+
+fail:
+	kfree(p);
+	if (i < 256)
+		return (i << 24) | (j << 16) | k;
+	return 0;
+}
+
+static __init int string_selftest_init(void)
+{
+	int test, subtest;
+
+	test = 1;
+	subtest = memset16_selftest();
+	if (subtest)
+		goto fail;
+
+	test = 2;
+	subtest = memset32_selftest();
+	if (subtest)
+		goto fail;
+
+	test = 3;
+	subtest = memset64_selftest();
+	if (subtest)
+		goto fail;
+
+	pr_info("String selftests succeeded\n");
+	return 0;
+fail:
+	pr_crit("String selftest failure %d.%08x\n", test, subtest);
+	return 0;
+}
+
+module_init(string_selftest_init);
+MODULE_LICENSE("GPL v2");
_

Patches currently in -mm which might be from geert@linux-m68k.org are

lib-add-module-support-to-string-tests.patch

