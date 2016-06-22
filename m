From: akpm@linux-foundation.org
Subject: [merged]
 kconfigh-use-already-defined-macros-for-is_reachable-define.patch removed
 from -mm tree
Date: Wed, 22 Jun 2016 14:29:56 -0700
Message-ID: <576b0354.sgzxYNTI0w/mObUV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44993 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbcFVV35 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jun 2016 17:29:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, arnd@arndb.de, michal.simek@xilinx.com, mmarek@suse.cz, nicolas.pitre@linaro.org, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: kconfig.h: use already defined macros for IS_REACHABLE() define
has been removed from the -mm tree.  Its filename was
     kconfigh-use-already-defined-macros-for-is_reachable-define.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

tree-wide-replace-config_enabled-with-is_enabled.patch

