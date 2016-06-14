From: akpm@linux-foundation.org
Subject: + exporth-use-__is_defined-to-check-if-__ksym_-is-defined.patch
 added to -mm tree
Date: Tue, 14 Jun 2016 15:23:42 -0700
Message-ID: <576083ee.B9sfMIIuwQHkYeNs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56158 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbcFNWXn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jun 2016 18:23:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, arnd@arndb.de, michal.simek@xilinx.com, mmarek@suse.cz, nico@linaro.org, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: export.h: use __is_defined() to check if __KSYM_* is defined
has been added to the -mm tree.  Its filename is
     exporth-use-__is_defined-to-check-if-__ksym_-is-defined.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exporth-use-__is_defined-to-check-if-__ksym_-is-defined.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/exporth-use-__is_defined-to-check-if-__ksym_-is-defined.patch

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
Subject: export.h: use __is_defined() to check if __KSYM_* is defined

Here the need is for a macro that checks whether the given symbol is
defined or not, which has nothing to do with config.

The new macro __is_defined() is a better fit for this case.

Link: http://lkml.kernel.org/r/1465883938-25194-2-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Acked-by: Nicolas Pitre <nico@linaro.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michal Simek <michal.simek@xilinx.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/export.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/export.h~exporth-use-__is_defined-to-check-if-__ksym_-is-defined include/linux/export.h
--- a/include/linux/export.h~exporth-use-__is_defined-to-check-if-__ksym_-is-defined
+++ a/include/linux/export.h
@@ -82,7 +82,7 @@ extern struct module __this_module;
 #include <generated/autoksyms.h>
 
 #define __EXPORT_SYMBOL(sym, sec)				\
-	__cond_export_sym(sym, sec, config_enabled(__KSYM_##sym))
+	__cond_export_sym(sym, sec, __is_defined(__KSYM_##sym))
 #define __cond_export_sym(sym, sec, conf)			\
 	___cond_export_sym(sym, sec, conf)
 #define ___cond_export_sym(sym, sec, enabled)			\
_

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

kconfigh-use-__is_defined-to-check-if-module-is-defined.patch
exporth-use-__is_defined-to-check-if-__ksym_-is-defined.patch
kconfigh-use-already-defined-macros-for-is_reachable-define.patch
kconfigh-allow-to-use-is_enablereachable-in-macro-expansion.patch
vmlinuxldsh-replace-config_enabled-with-is_enabled.patch
tree-wide-replace-config_enabled-with-is_enabled.patch

