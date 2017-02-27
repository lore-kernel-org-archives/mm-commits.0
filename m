From: akpm@linux-foundation.org
Subject: [merged] lib-add-module-support-to-glob-tests.patch removed from
 -mm tree
Date: Mon, 27 Feb 2017 12:28:55 -0800
Message-ID: <58b48c07.yYrs6C6d2n0L67Z6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34548 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751587AbdB0Ukd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:40:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, andy.shevchenko@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: add module support to glob tests
has been removed from the -mm tree.  Its filename was
     lib-add-module-support-to-glob-tests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: lib: add module support to glob tests

Extract the glob test code into its own source file, to allow to
compile it either to a loadable module, or builtin into the kernel.

Link: http://lkml.kernel.org/r/1483470276-10517-2-git-send-email-geert@linux-m68k.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig    |    3 
 lib/Makefile   |    1 
 lib/glob.c     |  164 ----------------------------------------------
 lib/globtest.c |  167 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 169 insertions(+), 166 deletions(-)

diff -puN lib/Kconfig~lib-add-module-support-to-glob-tests lib/Kconfig
--- a/lib/Kconfig~lib-add-module-support-to-glob-tests
+++ a/lib/Kconfig
@@ -431,8 +431,7 @@ config GLOB
 	  depends on this.
 
 config GLOB_SELFTEST
-	bool "glob self-test on init"
-	default n
+	tristate "glob self-test on init"
 	depends on GLOB
 	help
 	  This option enables a simple self-test of the glob_match
diff -puN lib/Makefile~lib-add-module-support-to-glob-tests lib/Makefile
--- a/lib/Makefile~lib-add-module-support-to-glob-tests
+++ a/lib/Makefile
@@ -162,6 +162,7 @@ obj-$(CONFIG_CORDIC) += cordic.o
 obj-$(CONFIG_DQL) += dynamic_queue_limits.o
 
 obj-$(CONFIG_GLOB) += glob.o
+obj-$(CONFIG_GLOB_SELFTEST) += globtest.o
 
 obj-$(CONFIG_MPILIB) += mpi/
 obj-$(CONFIG_SIGNATURE) += digsig.o
diff -puN lib/glob.c~lib-add-module-support-to-glob-tests lib/glob.c
--- a/lib/glob.c~lib-add-module-support-to-glob-tests
+++ a/lib/glob.c
@@ -121,167 +121,3 @@ backtrack:
 	}
 }
 EXPORT_SYMBOL(glob_match);
-
-
-#ifdef CONFIG_GLOB_SELFTEST
-
-#include <linux/printk.h>
-#include <linux/moduleparam.h>
-
-/* Boot with "glob.verbose=1" to show successful tests, too */
-static bool verbose = false;
-module_param(verbose, bool, 0);
-
-struct glob_test {
-	char const *pat, *str;
-	bool expected;
-};
-
-static bool __pure __init test(char const *pat, char const *str, bool expected)
-{
-	bool match = glob_match(pat, str);
-	bool success = match == expected;
-
-	/* Can't get string literals into a particular section, so... */
-	static char const msg_error[] __initconst =
-		KERN_ERR "glob: \"%s\" vs. \"%s\": %s *** ERROR ***\n";
-	static char const msg_ok[] __initconst =
-		KERN_DEBUG "glob: \"%s\" vs. \"%s\": %s OK\n";
-	static char const mismatch[] __initconst = "mismatch";
-	char const *message;
-
-	if (!success)
-		message = msg_error;
-	else if (verbose)
-		message = msg_ok;
-	else
-		return success;
-
-	printk(message, pat, str, mismatch + 3*match);
-	return success;
-}
-
-/*
- * The tests are all jammed together in one array to make it simpler
- * to place that array in the .init.rodata section.  The obvious
- * "array of structures containing char *" has no way to force the
- * pointed-to strings to be in a particular section.
- *
- * Anyway, a test consists of:
- * 1. Expected glob_match result: '1' or '0'.
- * 2. Pattern to match: null-terminated string
- * 3. String to match against: null-terminated string
- *
- * The list of tests is terminated with a final '\0' instead of
- * a glob_match result character.
- */
-static char const glob_tests[] __initconst =
-	/* Some basic tests */
-	"1" "a\0" "a\0"
-	"0" "a\0" "b\0"
-	"0" "a\0" "aa\0"
-	"0" "a\0" "\0"
-	"1" "\0" "\0"
-	"0" "\0" "a\0"
-	/* Simple character class tests */
-	"1" "[a]\0" "a\0"
-	"0" "[a]\0" "b\0"
-	"0" "[!a]\0" "a\0"
-	"1" "[!a]\0" "b\0"
-	"1" "[ab]\0" "a\0"
-	"1" "[ab]\0" "b\0"
-	"0" "[ab]\0" "c\0"
-	"1" "[!ab]\0" "c\0"
-	"1" "[a-c]\0" "b\0"
-	"0" "[a-c]\0" "d\0"
-	/* Corner cases in character class parsing */
-	"1" "[a-c-e-g]\0" "-\0"
-	"0" "[a-c-e-g]\0" "d\0"
-	"1" "[a-c-e-g]\0" "f\0"
-	"1" "[]a-ceg-ik[]\0" "a\0"
-	"1" "[]a-ceg-ik[]\0" "]\0"
-	"1" "[]a-ceg-ik[]\0" "[\0"
-	"1" "[]a-ceg-ik[]\0" "h\0"
-	"0" "[]a-ceg-ik[]\0" "f\0"
-	"0" "[!]a-ceg-ik[]\0" "h\0"
-	"0" "[!]a-ceg-ik[]\0" "]\0"
-	"1" "[!]a-ceg-ik[]\0" "f\0"
-	/* Simple wild cards */
-	"1" "?\0" "a\0"
-	"0" "?\0" "aa\0"
-	"0" "??\0" "a\0"
-	"1" "?x?\0" "axb\0"
-	"0" "?x?\0" "abx\0"
-	"0" "?x?\0" "xab\0"
-	/* Asterisk wild cards (backtracking) */
-	"0" "*??\0" "a\0"
-	"1" "*??\0" "ab\0"
-	"1" "*??\0" "abc\0"
-	"1" "*??\0" "abcd\0"
-	"0" "??*\0" "a\0"
-	"1" "??*\0" "ab\0"
-	"1" "??*\0" "abc\0"
-	"1" "??*\0" "abcd\0"
-	"0" "?*?\0" "a\0"
-	"1" "?*?\0" "ab\0"
-	"1" "?*?\0" "abc\0"
-	"1" "?*?\0" "abcd\0"
-	"1" "*b\0" "b\0"
-	"1" "*b\0" "ab\0"
-	"0" "*b\0" "ba\0"
-	"1" "*b\0" "bb\0"
-	"1" "*b\0" "abb\0"
-	"1" "*b\0" "bab\0"
-	"1" "*bc\0" "abbc\0"
-	"1" "*bc\0" "bc\0"
-	"1" "*bc\0" "bbc\0"
-	"1" "*bc\0" "bcbc\0"
-	/* Multiple asterisks (complex backtracking) */
-	"1" "*ac*\0" "abacadaeafag\0"
-	"1" "*ac*ae*ag*\0" "abacadaeafag\0"
-	"1" "*a*b*[bc]*[ef]*g*\0" "abacadaeafag\0"
-	"0" "*a*b*[ef]*[cd]*g*\0" "abacadaeafag\0"
-	"1" "*abcd*\0" "abcabcabcabcdefg\0"
-	"1" "*ab*cd*\0" "abcabcabcabcdefg\0"
-	"1" "*abcd*abcdef*\0" "abcabcdabcdeabcdefg\0"
-	"0" "*abcd*\0" "abcabcabcabcefg\0"
-	"0" "*ab*cd*\0" "abcabcabcabcefg\0";
-
-static int __init glob_init(void)
-{
-	unsigned successes = 0;
-	unsigned n = 0;
-	char const *p = glob_tests;
-	static char const message[] __initconst =
-		KERN_INFO "glob: %u self-tests passed, %u failed\n";
-
-	/*
-	 * Tests are jammed together in a string.  The first byte is '1'
-	 * or '0' to indicate the expected outcome, or '\0' to indicate the
-	 * end of the tests.  Then come two null-terminated strings: the
-	 * pattern and the string to match it against.
-	 */
-	while (*p) {
-		bool expected = *p++ & 1;
-		char const *pat = p;
-
-		p += strlen(p) + 1;
-		successes += test(pat, p, expected);
-		p += strlen(p) + 1;
-		n++;
-	}
-
-	n -= successes;
-	printk(message, successes, n);
-
-	/* What's the errno for "kernel bug detected"?  Guess... */
-	return n ? -ECANCELED : 0;
-}
-
-/* We need a dummy exit function to allow unload */
-static void __exit glob_fini(void) { }
-
-module_init(glob_init);
-module_exit(glob_fini);
-
-#endif /* CONFIG_GLOB_SELFTEST */
diff -puN /dev/null lib/globtest.c
--- /dev/null
+++ a/lib/globtest.c
@@ -0,0 +1,167 @@
+/*
+ * Extracted fronm glob.c
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/glob.h>
+#include <linux/printk.h>
+
+/* Boot with "glob.verbose=1" to show successful tests, too */
+static bool verbose = false;
+module_param(verbose, bool, 0);
+
+struct glob_test {
+	char const *pat, *str;
+	bool expected;
+};
+
+static bool __pure __init test(char const *pat, char const *str, bool expected)
+{
+	bool match = glob_match(pat, str);
+	bool success = match == expected;
+
+	/* Can't get string literals into a particular section, so... */
+	static char const msg_error[] __initconst =
+		KERN_ERR "glob: \"%s\" vs. \"%s\": %s *** ERROR ***\n";
+	static char const msg_ok[] __initconst =
+		KERN_DEBUG "glob: \"%s\" vs. \"%s\": %s OK\n";
+	static char const mismatch[] __initconst = "mismatch";
+	char const *message;
+
+	if (!success)
+		message = msg_error;
+	else if (verbose)
+		message = msg_ok;
+	else
+		return success;
+
+	printk(message, pat, str, mismatch + 3*match);
+	return success;
+}
+
+/*
+ * The tests are all jammed together in one array to make it simpler
+ * to place that array in the .init.rodata section.  The obvious
+ * "array of structures containing char *" has no way to force the
+ * pointed-to strings to be in a particular section.
+ *
+ * Anyway, a test consists of:
+ * 1. Expected glob_match result: '1' or '0'.
+ * 2. Pattern to match: null-terminated string
+ * 3. String to match against: null-terminated string
+ *
+ * The list of tests is terminated with a final '\0' instead of
+ * a glob_match result character.
+ */
+static char const glob_tests[] __initconst =
+	/* Some basic tests */
+	"1" "a\0" "a\0"
+	"0" "a\0" "b\0"
+	"0" "a\0" "aa\0"
+	"0" "a\0" "\0"
+	"1" "\0" "\0"
+	"0" "\0" "a\0"
+	/* Simple character class tests */
+	"1" "[a]\0" "a\0"
+	"0" "[a]\0" "b\0"
+	"0" "[!a]\0" "a\0"
+	"1" "[!a]\0" "b\0"
+	"1" "[ab]\0" "a\0"
+	"1" "[ab]\0" "b\0"
+	"0" "[ab]\0" "c\0"
+	"1" "[!ab]\0" "c\0"
+	"1" "[a-c]\0" "b\0"
+	"0" "[a-c]\0" "d\0"
+	/* Corner cases in character class parsing */
+	"1" "[a-c-e-g]\0" "-\0"
+	"0" "[a-c-e-g]\0" "d\0"
+	"1" "[a-c-e-g]\0" "f\0"
+	"1" "[]a-ceg-ik[]\0" "a\0"
+	"1" "[]a-ceg-ik[]\0" "]\0"
+	"1" "[]a-ceg-ik[]\0" "[\0"
+	"1" "[]a-ceg-ik[]\0" "h\0"
+	"0" "[]a-ceg-ik[]\0" "f\0"
+	"0" "[!]a-ceg-ik[]\0" "h\0"
+	"0" "[!]a-ceg-ik[]\0" "]\0"
+	"1" "[!]a-ceg-ik[]\0" "f\0"
+	/* Simple wild cards */
+	"1" "?\0" "a\0"
+	"0" "?\0" "aa\0"
+	"0" "??\0" "a\0"
+	"1" "?x?\0" "axb\0"
+	"0" "?x?\0" "abx\0"
+	"0" "?x?\0" "xab\0"
+	/* Asterisk wild cards (backtracking) */
+	"0" "*??\0" "a\0"
+	"1" "*??\0" "ab\0"
+	"1" "*??\0" "abc\0"
+	"1" "*??\0" "abcd\0"
+	"0" "??*\0" "a\0"
+	"1" "??*\0" "ab\0"
+	"1" "??*\0" "abc\0"
+	"1" "??*\0" "abcd\0"
+	"0" "?*?\0" "a\0"
+	"1" "?*?\0" "ab\0"
+	"1" "?*?\0" "abc\0"
+	"1" "?*?\0" "abcd\0"
+	"1" "*b\0" "b\0"
+	"1" "*b\0" "ab\0"
+	"0" "*b\0" "ba\0"
+	"1" "*b\0" "bb\0"
+	"1" "*b\0" "abb\0"
+	"1" "*b\0" "bab\0"
+	"1" "*bc\0" "abbc\0"
+	"1" "*bc\0" "bc\0"
+	"1" "*bc\0" "bbc\0"
+	"1" "*bc\0" "bcbc\0"
+	/* Multiple asterisks (complex backtracking) */
+	"1" "*ac*\0" "abacadaeafag\0"
+	"1" "*ac*ae*ag*\0" "abacadaeafag\0"
+	"1" "*a*b*[bc]*[ef]*g*\0" "abacadaeafag\0"
+	"0" "*a*b*[ef]*[cd]*g*\0" "abacadaeafag\0"
+	"1" "*abcd*\0" "abcabcabcabcdefg\0"
+	"1" "*ab*cd*\0" "abcabcabcabcdefg\0"
+	"1" "*abcd*abcdef*\0" "abcabcdabcdeabcdefg\0"
+	"0" "*abcd*\0" "abcabcabcabcefg\0"
+	"0" "*ab*cd*\0" "abcabcabcabcefg\0";
+
+static int __init glob_init(void)
+{
+	unsigned successes = 0;
+	unsigned n = 0;
+	char const *p = glob_tests;
+	static char const message[] __initconst =
+		KERN_INFO "glob: %u self-tests passed, %u failed\n";
+
+	/*
+	 * Tests are jammed together in a string.  The first byte is '1'
+	 * or '0' to indicate the expected outcome, or '\0' to indicate the
+	 * end of the tests.  Then come two null-terminated strings: the
+	 * pattern and the string to match it against.
+	 */
+	while (*p) {
+		bool expected = *p++ & 1;
+		char const *pat = p;
+
+		p += strlen(p) + 1;
+		successes += test(pat, p, expected);
+		p += strlen(p) + 1;
+		n++;
+	}
+
+	n -= successes;
+	printk(message, successes, n);
+
+	/* What's the errno for "kernel bug detected"?  Guess... */
+	return n ? -ECANCELED : 0;
+}
+
+/* We need a dummy exit function to allow unload */
+static void __exit glob_fini(void) { }
+
+module_init(glob_init);
+module_exit(glob_fini);
+
+MODULE_DESCRIPTION("glob(7) matching tests");
+MODULE_LICENSE("Dual MIT/GPL");
_

Patches currently in -mm which might be from geert@linux-m68k.org are


