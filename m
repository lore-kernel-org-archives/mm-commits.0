From: akpm@linux-foundation.org
Subject: +
 kconfigh-use-already-defined-macros-for-is_reachable-define.patch added to
 -mm tree
Date: Tue, 14 Jun 2016 15:23:44 -0700
Message-ID: <576083f0.DK1+IM93pqQ5/xYp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56162 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbcFNWXp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jun 2016 18:23:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, arnd@arndb.de, michal.simek@xilinx.com, mmarek@suse.cz, nicolas.pitre@linaro.org, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: kconfig.h: use already defined macros for IS_REACHABLE() define
has been added to the -mm tree.  Its filename is
     kconfigh-use-already-defined-macros-for-is_reachable-define.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kconfigh-use-already-defined-macros-for-is_reachable-define.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kconfigh-use-already-defined-macros-for-is_reachable-define.patch

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
Subject: kconfig.h: use already defined macros for IS_REACHABLE() define

For the same reason as commit 02d699f1f464 ("include/linux/kconfig.h: ese
macros which are already defined"), it is better to use macros
IS_BUILTIN() and IS_MODULE() for defining IS_REACHABLE().

Link: http://lkml.kernel.org/r/1465883938-25194-3-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michal Simek <michal.simek@xilinx.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kconfig.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/kconfig.h~kconfigh-use-already-defined-macros-for-is_reachable-define include/linux/kconfig.h
--- a/include/linux/kconfig.h~kconfigh-use-already-defined-macros-for-is_reachable-define
+++ a/include/linux/kconfig.h
@@ -42,8 +42,8 @@
  * This is similar to IS_ENABLED(), but returns false when invoked from
  * built-in code when CONFIG_FOO is set to 'm'.
  */
-#define IS_REACHABLE(option) (config_enabled(option) || \
-		 (config_enabled(option##_MODULE) && __is_defined(MODULE)))
+#define IS_REACHABLE(option) (IS_BUILTIN(option) || \
+		 (IS_MODULE(option) && __is_defined(MODULE)))
 
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

