From: akpm@linux-foundation.org
Subject: + lib-globc-add-config_glob_selftest.patch added to -mm tree
Date: Wed, 11 Jun 2014 16:04:57 -0700
Message-ID: <5398e099.yvVIDUFcbAjmYzlF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52603 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154AbaFKXE6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jun 2014 19:04:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, rdunlap@infradead.org, mingo@elte.hu, linux@horizon.com

Subject: + lib-globc-add-config_glob_selftest.patch added to -mm tree
To: linux@horizon.com,mingo@elte.hu,rdunlap@infradead.org,tj@kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Jun 2014 16:04:57 -0700


The patch titled
     Subject: lib/glob.c: add CONFIG_GLOB_SELFTEST
has been added to the -mm tree.  Its filename is
     lib-globc-add-config_glob_selftest.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-globc-add-config_glob_selftest.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-globc-add-config_glob_selftest.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "George Spelvin" <linux@horizon.com>
Subject: lib/glob.c: add CONFIG_GLOB_SELFTEST

This was useful during development, and is retained for future regression
testing.

GCC appears to have no way to place string literals in a particular
section; adding __initconst to a char pointer leaves the string itself in
the default string section, where it will not be thrown away after module
load.

Thus all string constants are kept in explicitly declared and named
arrays.  Sorry this makes printk a bit harder to read.  At least the tests
are more compact.

Signed-off-by: George Spelvin <linux@horizon.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig |   14 ++++
 lib/glob.c  |  164 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 178 insertions(+)

diff -puN lib/Kconfig~lib-globc-add-config_glob_selftest lib/Kconfig
--- a/lib/Kconfig~lib-globc-add-config_glob_selftest
+++ a/lib/Kconfig
@@ -401,6 +401,20 @@ config GLOB
 	  are compiling an out-of tree driver which tells you that it
 	  depends on this.
 
+config GLOB_SELFTEST
+	bool "glob self-test on init"
+	default n
+	depends on GLOB
+	help
+	  This option enables a simple self-test of the glob_match
+	  function on startup.	It is primarily useful for people
+	  working on the code to ensure they haven't introduced any
+	  regressions.
+
+	  It only adds a little bit of code and slows kernel boot (or
+	  module load) by a small amount, so you're welcome to play with
+	  it, but you probably don't need it.
+
 #
 # Netlink attribute parsing support is select'ed if needed
 #
diff -puN lib/glob.c~lib-globc-add-config_glob_selftest lib/glob.c
--- a/lib/glob.c~lib-globc-add-config_glob_selftest
+++ a/lib/glob.c
@@ -121,3 +121,167 @@ backtrack:
 	}
 }
 EXPORT_SYMBOL(glob_match);
+
+
+#ifdef CONFIG_GLOB_SELFTEST
+
+#include <linux/printk.h>
+#include <linux/moduleparam.h>
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
+#endif /* CONFIG_GLOB_SELFTEST */
_

Patches currently in -mm which might be from linux@horizon.com are

origin.patch
add-lib-globc.patch
lib-globc-add-config_glob_selftest.patch
libata-use-glob_match-from-lib-globc.patch
linux-next.patch

