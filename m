From: akpm@linux-foundation.org
Subject: + kconfigh-remove-config_enabled-macro.patch added to -mm tree
Date: Tue, 18 Oct 2016 14:06:44 -0700
Message-ID: <58068ee4.WA/DNAvKYMqO+B7f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56620 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936094AbcJRVGp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2016 17:06:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, arnd@arndb.de, hpa@zytor.com, keescook@chromium.org, mingo@kernel.org, mmarek@suse.com, oberpar@linux.vnet.ibm.com, tglx@linutronix.de, thgarnie@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kconfig.h: remove config_enabled() macro
has been added to the -mm tree.  Its filename is
     kconfigh-remove-config_enabled-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kconfigh-remove-config_enabled-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kconfigh-remove-config_enabled-macro.patch

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
Subject: kconfig.h: remove config_enabled() macro

The use of config_enabled() is ambiguous.  For config options,
IS_ENABLED(), IS_REACHABLE(), etc. will make intention clearer.
Sometimes config_enabled() has been used for non-config options
because it is useful to check whether the given symbol is defined
or not.

I have been tackling on deprecating config_enabled(), and now is the
time to finish this work.

Some new users have appeared for v4.9-rc1, but it is trivial to
replace them:

 - arch/x86/mm/kaslr.c
  replace config_enabled() with IS_ENABLED() because
  CONFIG_X86_ESPFIX64 and CONFIG_EFI are boolean.

 - include/asm-generic/export.h
  replace config_enabled() with __is_defined().

Then, config_enabled() can be removed now.

Going forward, please use IS_ENABLED(), IS_REACHABLE(), etc. for
config options, and __is_defined() for non-config symbols.

Link: http://lkml.kernel.org/r/1476616078-32252-1-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Michal Marek <mmarek@suse.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Garnier <thgarnie@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/kaslr.c          |    6 +++---
 include/asm-generic/export.h |    2 +-
 include/linux/kconfig.h      |    5 ++---
 3 files changed, 6 insertions(+), 7 deletions(-)

diff -puN arch/x86/mm/kaslr.c~kconfigh-remove-config_enabled-macro arch/x86/mm/kaslr.c
--- a/arch/x86/mm/kaslr.c~kconfigh-remove-config_enabled-macro
+++ a/arch/x86/mm/kaslr.c
@@ -104,10 +104,10 @@ void __init kernel_randomize_memory(void
 	 * consistent with the vaddr_start/vaddr_end variables.
 	 */
 	BUILD_BUG_ON(vaddr_start >= vaddr_end);
-	BUILD_BUG_ON(config_enabled(CONFIG_X86_ESPFIX64) &&
+	BUILD_BUG_ON(IS_ENABLED(CONFIG_X86_ESPFIX64) &&
 		     vaddr_end >= EFI_VA_START);
-	BUILD_BUG_ON((config_enabled(CONFIG_X86_ESPFIX64) ||
-		      config_enabled(CONFIG_EFI)) &&
+	BUILD_BUG_ON((IS_ENABLED(CONFIG_X86_ESPFIX64) ||
+		      IS_ENABLED(CONFIG_EFI)) &&
 		     vaddr_end >= __START_KERNEL_map);
 	BUILD_BUG_ON(vaddr_end > __START_KERNEL_map);
 
diff -puN include/asm-generic/export.h~kconfigh-remove-config_enabled-macro include/asm-generic/export.h
--- a/include/asm-generic/export.h~kconfigh-remove-config_enabled-macro
+++ a/include/asm-generic/export.h
@@ -70,7 +70,7 @@ KSYM(__kcrctab_\name):
 #include <generated/autoksyms.h>
 
 #define __EXPORT_SYMBOL(sym, val, sec)				\
-	__cond_export_sym(sym, val, sec, config_enabled(__KSYM_##sym))
+	__cond_export_sym(sym, val, sec, __is_defined(__KSYM_##sym))
 #define __cond_export_sym(sym, val, sec, conf)			\
 	___cond_export_sym(sym, val, sec, conf)
 #define ___cond_export_sym(sym, val, sec, enabled)		\
diff -puN include/linux/kconfig.h~kconfigh-remove-config_enabled-macro include/linux/kconfig.h
--- a/include/linux/kconfig.h~kconfigh-remove-config_enabled-macro
+++ a/include/linux/kconfig.h
@@ -31,7 +31,6 @@
  * When CONFIG_BOOGER is not defined, we generate a (... 1, 0) pair, and when
  * the last step cherry picks the 2nd arg, we get a zero.
  */
-#define config_enabled(cfg)		___is_defined(cfg)
 #define __is_defined(x)			___is_defined(x)
 #define ___is_defined(val)		____is_defined(__ARG_PLACEHOLDER_##val)
 #define ____is_defined(arg1_or_junk)	__take_second_arg(arg1_or_junk 1, 0)
@@ -41,13 +40,13 @@
  * otherwise. For boolean options, this is equivalent to
  * IS_ENABLED(CONFIG_FOO).
  */
-#define IS_BUILTIN(option) config_enabled(option)
+#define IS_BUILTIN(option) __is_defined(option)
 
 /*
  * IS_MODULE(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'm', 0
  * otherwise.
  */
-#define IS_MODULE(option) config_enabled(option##_MODULE)
+#define IS_MODULE(option) __is_defined(option##_MODULE)
 
 /*
  * IS_REACHABLE(CONFIG_FOO) evaluates to 1 if the currently compiled
_

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

kconfigh-remove-config_enabled-macro.patch

