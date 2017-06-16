From: akpm@linux-foundation.org
Subject: +
 kernel-kallsyms-replace-all_var-with-is_enabledconfig_kallsyms_all.patch
 added to -mm tree
Date: Fri, 16 Jun 2017 11:37:02 -0700
Message-ID: <5944254e.pfC7+PW5/m4k2OaU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59910 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750787AbdFPShD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jun 2017 14:37:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/kallsyms.c: replace all_var with IS_ENABLED(CONFIG_KALLSYMS_ALL)
has been added to the -mm tree.  Its filename is
     kernel-kallsyms-replace-all_var-with-is_enabledconfig_kallsyms_all.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-kallsyms-replace-all_var-with-is_enabledconfig_kallsyms_all.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-kallsyms-replace-all_var-with-is_enabledconfig_kallsyms_all.patch

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
Subject: kernel/kallsyms.c: replace all_var with IS_ENABLED(CONFIG_KALLSYMS_ALL)

'all_var' looks like a variable, but is actually a macro.  Use
IS_ENABLED(CONFIG_KALLSYMS_ALL) for clarification.

Link: http://lkml.kernel.org/r/1497577591-3434-1-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kallsyms.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN kernel/kallsyms.c~kernel-kallsyms-replace-all_var-with-is_enabledconfig_kallsyms_all kernel/kallsyms.c
--- a/kernel/kallsyms.c~kernel-kallsyms-replace-all_var-with-is_enabledconfig_kallsyms_all
+++ a/kernel/kallsyms.c
@@ -28,12 +28,6 @@
 
 #include <asm/sections.h>
 
-#ifdef CONFIG_KALLSYMS_ALL
-#define all_var 1
-#else
-#define all_var 0
-#endif
-
 /*
  * These will be re-linked against their real values
  * during the second link stage.
@@ -82,7 +76,7 @@ static inline int is_kernel(unsigned lon
 
 static int is_ksym_addr(unsigned long addr)
 {
-	if (all_var)
+	if (IS_ENABLED(CONFIG_KALLSYMS_ALL))
 		return is_kernel(addr);
 
 	return is_kernel_text(addr) || is_kernel_inittext(addr);
@@ -280,7 +274,7 @@ static unsigned long get_symbol_pos(unsi
 	if (!symbol_end) {
 		if (is_kernel_inittext(addr))
 			symbol_end = (unsigned long)_einittext;
-		else if (all_var)
+		else if (IS_ENABLED(CONFIG_KALLSYMS_ALL))
 			symbol_end = (unsigned long)_end;
 		else
 			symbol_end = (unsigned long)_etext;
_

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

kernel-kallsyms-replace-all_var-with-is_enabledconfig_kallsyms_all.patch

