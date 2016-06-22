From: akpm@linux-foundation.org
Subject: [merged]
 kconfigh-allow-to-use-is_enablereachable-in-macro-expansion.patch removed
 from -mm tree
Date: Wed, 22 Jun 2016 14:29:58 -0700
Message-ID: <576b0356.uOwSKvZ3aCM7ig2m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45000 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbcFVV37 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jun 2016 17:29:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, arnd@arndb.de, michal.simek@xilinx.com, mmarek@suse.cz, nicolas.pitre@linaro.org, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: kconfig.h: allow to use IS_{ENABLE,REACHABLE} in macro expansion
has been removed from the -mm tree.  Its filename was
     kconfigh-allow-to-use-is_enablereachable-in-macro-expansion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: kconfig.h: allow to use IS_{ENABLE,REACHABLE} in macro expansion

The typical usage of IS_ENABLED() is

    if (IS_ENABLED(CONFIG_FOO)) {
            ...
    }

or

    #if IS_ENABLED(CONFIG_FOO)
            ...
    #endif

The current implementation of IS_ENABLED() includes "||" operator,
which works well in those expressions like above.

However, there is a case where we want to evaluate a config option
beyond those use cases.

For example, the OF_TABLE() in include/asm-generic/vmlinux.lds.h
needs to evaluate a config option in macro expansion:

  #define ___OF_TABLE(cfg, name)  _OF_TABLE_##cfg(name)
  #define __OF_TABLE(cfg, name)   ___OF_TABLE(cfg, name)
  #define OF_TABLE(cfg, name)     __OF_TABLE(config_enabled(cfg), name)
  #define _OF_TABLE_0(name)
  #define _OF_TABLE_1(name)            ...

Here, we can not use IS_ENABLED() because of the "||" operator in
its define.  It is true config_enabled() works well, but it is a bit
ambiguous to be used against config options.

This commit makes IS_ENABLED() available in more generic context by
calculating "or" with macro expansion only.

Do likewise for IS_REACHABLE().

Link: http://lkml.kernel.org/r/1465883938-25194-4-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michal Simek <michal.simek@xilinx.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kconfig.h |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff -puN include/linux/kconfig.h~kconfigh-allow-to-use-is_enablereachable-in-macro-expansion include/linux/kconfig.h
--- a/include/linux/kconfig.h~kconfigh-allow-to-use-is_enablereachable-in-macro-expansion
+++ a/include/linux/kconfig.h
@@ -3,6 +3,21 @@
 
 #include <generated/autoconf.h>
 
+#define __ARG_PLACEHOLDER_1 0,
+#define __take_second_arg(__ignored, val, ...) val
+
+/*
+ * The use of "&&" / "||" is limited in certain expressions.
+ * The followings enable to calculate "and" / "or" with macro expansion only.
+ */
+#define __and(x, y)			___and(x, y)
+#define ___and(x, y)			____and(__ARG_PLACEHOLDER_##x, y)
+#define ____and(arg1_or_junk, y)	__take_second_arg(arg1_or_junk y, 0)
+
+#define __or(x, y)			___or(x, y)
+#define ___or(x, y)			____or(__ARG_PLACEHOLDER_##x, y)
+#define ____or(arg1_or_junk, y)		__take_second_arg(arg1_or_junk 1, y)
+
 /*
  * Helper macros to use CONFIG_ options in C/CPP expressions. Note that
  * these only work with boolean and tristate options.
@@ -16,12 +31,10 @@
  * When CONFIG_BOOGER is not defined, we generate a (... 1, 0) pair, and when
  * the last step cherry picks the 2nd arg, we get a zero.
  */
-#define __ARG_PLACEHOLDER_1 0,
 #define config_enabled(cfg)		___is_defined(cfg)
 #define __is_defined(x)			___is_defined(x)
 #define ___is_defined(val)		____is_defined(__ARG_PLACEHOLDER_##val)
 #define ____is_defined(arg1_or_junk)	__take_second_arg(arg1_or_junk 1, 0)
-#define __take_second_arg(__ignored, val, ...) val
 
 /*
  * IS_BUILTIN(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'y', 0
@@ -42,14 +55,13 @@
  * This is similar to IS_ENABLED(), but returns false when invoked from
  * built-in code when CONFIG_FOO is set to 'm'.
  */
-#define IS_REACHABLE(option) (IS_BUILTIN(option) || \
-		 (IS_MODULE(option) && __is_defined(MODULE)))
+#define IS_REACHABLE(option) __or(IS_BUILTIN(option), \
+				__and(IS_MODULE(option), __is_defined(MODULE)))
 
 /*
  * IS_ENABLED(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'y' or 'm',
  * 0 otherwise.
  */
-#define IS_ENABLED(option) \
-	(IS_BUILTIN(option) || IS_MODULE(option))
+#define IS_ENABLED(option) __or(IS_BUILTIN(option), IS_MODULE(option))
 
 #endif /* __LINUX_KCONFIG_H */
_

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

tree-wide-replace-config_enabled-with-is_enabled.patch

