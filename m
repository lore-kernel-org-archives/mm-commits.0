From: akpm@linux-foundation.org
Subject: [merged]
 kernel-kallsyms-replace-all_var-with-is_enabledconfig_kallsyms_all.patch
 removed from -mm tree
Date: Tue, 11 Jul 2017 12:26:15 -0700
Message-ID: <20170711192615.GwU8zqg8E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48408 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932270AbdGKT0Q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:26:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net, mm-commits@vger.kernel.org, yamada.masahiro@socionext.com


The patch titled
     Subject: kernel/kallsyms.c: replace all_var with IS_ENABLED(CONFIG_KALLSYMS_ALL)
has been removed from the -mm tree.  Its filename was
     kernel-kallsyms-replace-all_var-with-is_enabledconfig_kallsyms_all.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


