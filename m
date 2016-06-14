From: akpm@linux-foundation.org
Subject: + kconfigh-use-__is_defined-to-check-if-module-is-defined.patch
 added to -mm tree
Date: Tue, 14 Jun 2016 15:23:40 -0700
Message-ID: <576083ec.R8PXYRCSWojU/tXV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56147 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbcFNWXl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jun 2016 18:23:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, arnd@arndb.de, michal.simek@xilinx.com, mmarek@suse.cz, nicolas.pitre@linaro.org, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: kconfig.h: use __is_defined() to check if MODULE is defined
has been added to the -mm tree.  Its filename is
     kconfigh-use-__is_defined-to-check-if-module-is-defined.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kconfigh-use-__is_defined-to-check-if-module-is-defined.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kconfigh-use-__is_defined-to-check-if-module-is-defined.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: kconfig.h: use __is_defined() to check if MODULE is defined

The macro MODULE is not a config option, it is a per-file build option. 
So, config_enabled(MODULE) is not sensible.  (There is another case in
include/linux/export.h, where config_enabled() is used against a
non-config option.)

This commit renames some macros in include/linux/kconfig.h for the use for
non-config macros and replaces config_enabled(MODULE) with
__is_defined(MODULE).

I am keeping config_enabled() because it is still referenced from some
places, but I expect it would be deprecated in the future.

Link: http://lkml.kernel.org/r/1465883938-25194-1-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michal Simek <michal.simek@xilinx.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kconfig.h |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN include/linux/kconfig.h~kconfigh-use-__is_defined-to-check-if-module-is-defined include/linux/kconfig.h
--- a/include/linux/kconfig.h~kconfigh-use-__is_defined-to-check-if-module-is-defined
+++ a/include/linux/kconfig.h
@@ -17,10 +17,11 @@
  * the last step cherry picks the 2nd arg, we get a zero.
  */
 #define __ARG_PLACEHOLDER_1 0,
-#define config_enabled(cfg) _config_enabled(cfg)
-#define _config_enabled(value) __config_enabled(__ARG_PLACEHOLDER_##value)
-#define __config_enabled(arg1_or_junk) ___config_enabled(arg1_or_junk 1, 0)
-#define ___config_enabled(__ignored, val, ...) val
+#define config_enabled(cfg)		___is_defined(cfg)
+#define __is_defined(x)			___is_defined(x)
+#define ___is_defined(val)		____is_defined(__ARG_PLACEHOLDER_##val)
+#define ____is_defined(arg1_or_junk)	__take_second_arg(arg1_or_junk 1, 0)
+#define __take_second_arg(__ignored, val, ...) val
 
 /*
  * IS_BUILTIN(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'y', 0
@@ -42,7 +43,7 @@
  * built-in code when CONFIG_FOO is set to 'm'.
  */
 #define IS_REACHABLE(option) (config_enabled(option) || \
-		 (config_enabled(option##_MODULE) && config_enabled(MODULE)))
+		 (config_enabled(option##_MODULE) && __is_defined(MODULE)))
 
 /*
  * IS_ENABLED(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'y' or 'm',
_

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

kconfigh-use-__is_defined-to-check-if-module-is-defined.patch
exporth-use-__is_defined-to-check-if-__ksym_-is-defined.patch
kconfigh-use-already-defined-macros-for-is_reachable-define.patch
kconfigh-allow-to-use-is_enablereachable-in-macro-expansion.patch
vmlinuxldsh-replace-config_enabled-with-is_enabled.patch
tree-wide-replace-config_enabled-with-is_enabled.patch

