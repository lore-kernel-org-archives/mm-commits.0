From: akpm@linux-foundation.org
Subject: - kallsyms-unify-32-and-64-bit-code.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:55:31 -0700
Message-ID: <200807252255.m6PMtVFR002983@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58946 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755603AbYGYW5h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:57:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vegard.nossum@gmail.com, arjan@infradead.org, heiko.carstens@de.ibm.com, randy.dunlap@oracle.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     kallsyms: unify 32- and 64-bit code
has been removed from the -mm tree.  Its filename was
     kallsyms-unify-32-and-64-bit-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kallsyms: unify 32- and 64-bit code
From: Vegard Nossum <vegard.nossum@gmail.com>

Use the %p format string which already accounts for the padding you need
with a pointer type on a particular architecture.

Also replace the macro with a static inline function to match the rest of
the file.

Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kallsyms.h |   19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff -puN include/linux/kallsyms.h~kallsyms-unify-32-and-64-bit-code include/linux/kallsyms.h
--- a/include/linux/kallsyms.h~kallsyms-unify-32-and-64-bit-code
+++ a/include/linux/kallsyms.h
@@ -6,6 +6,7 @@
 #define _LINUX_KALLSYMS_H
 
 #include <linux/errno.h>
+#include <linux/kernel.h>
 #include <linux/stddef.h>
 
 #define KSYM_NAME_LEN 128
@@ -105,18 +106,10 @@ static inline void print_fn_descriptor_s
 	print_symbol(fmt, (unsigned long)addr);
 }
 
-#ifndef CONFIG_64BIT
-#define print_ip_sym(ip)		\
-do {					\
-	printk("[<%08lx>]", ip);	\
-	print_symbol(" %s\n", ip);	\
-} while(0)
-#else
-#define print_ip_sym(ip)		\
-do {					\
-	printk("[<%016lx>]", ip);	\
-	print_symbol(" %s\n", ip);	\
-} while(0)
-#endif
+static inline void print_ip_sym(unsigned long ip)
+{
+	printk("[<%p>]", (void *) ip);
+	print_symbol(" %s\n", ip);
+}
 
 #endif /*_LINUX_KALLSYMS_H*/
_

Patches currently in -mm which might be from vegard.nossum@gmail.com are

origin.patch
linux-next.patch
parisc-fix-incomplete-header-guard.patch

