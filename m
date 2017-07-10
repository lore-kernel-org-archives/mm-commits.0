From: akpm@linux-foundation.org
Subject: [patch 082/115] kernel/kallsyms.c: replace all_var with
 IS_ENABLED(CONFIG_KALLSYMS_ALL)
Date: Mon, 10 Jul 2017 15:51:20 -0700
Message-ID: <20170710225120.AkSwqv-Ts%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43312 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754942AbdGJWvV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:51:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, yamada.masahiro@socionext.com

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
