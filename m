From: akpm@linux-foundation.org
Subject: - lib-move-kasprintf-to-a-separate-file.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:56:15 -0700
Message-ID: <200707312356.l6VNuFvm029304@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39748 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764302AbXHAAR7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:17:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, ink@jurassic.park.msu.ru, jay.estabrook@hp.com, jeremy@goop.org, mroos@linux.ee, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     lib: move kasprintf to a separate file
has been removed from the -mm tree.  Its filename was
     lib-move-kasprintf-to-a-separate-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lib: move kasprintf to a separate file
From: Sam Ravnborg <sam@ravnborg.org>

kasprintf pulls in kmalloc which proved to be fatal for at least
bootimage target on alpha.
Move it to a separate file so only users of kasprintf are exposed
to the dependency on kmalloc.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Meelis Roos <mroos@linux.ee>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Jay Estabrook <jay.estabrook@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Makefile    |    2 +-
 lib/kasprintf.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 lib/vsprintf.c  |   35 -----------------------------------
 3 files changed, 45 insertions(+), 36 deletions(-)

diff -puN lib/Makefile~lib-move-kasprintf-to-a-separate-file lib/Makefile
--- a/lib/Makefile~lib-move-kasprintf-to-a-separate-file
+++ a/lib/Makefile
@@ -2,7 +2,7 @@
 # Makefile for some libs needed in the kernel.
 #
 
-lib-y := ctype.o string.o vsprintf.o cmdline.o \
+lib-y := ctype.o string.o vsprintf.o kasprintf.o cmdline.o \
 	 rbtree.o radix-tree.o dump_stack.o \
 	 idr.o int_sqrt.o bitmap.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o argv_split.o
diff -puN /dev/null lib/kasprintf.c
--- /dev/null
+++ a/lib/kasprintf.c
@@ -0,0 +1,44 @@
+/*
+ *  linux/lib/kasprintf.c
+ *
+ *  Copyright (C) 1991, 1992  Linus Torvalds
+ */
+
+#include <stdarg.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/string.h>
+
+/* Simplified asprintf. */
+char *kvasprintf(gfp_t gfp, const char *fmt, va_list ap)
+{
+	unsigned int len;
+	char *p;
+	va_list aq;
+
+	va_copy(aq, ap);
+	len = vsnprintf(NULL, 0, fmt, aq);
+	va_end(aq);
+
+	p = kmalloc(len+1, gfp);
+	if (!p)
+		return NULL;
+
+	vsnprintf(p, len+1, fmt, ap);
+
+	return p;
+}
+EXPORT_SYMBOL(kvasprintf);
+
+char *kasprintf(gfp_t gfp, const char *fmt, ...)
+{
+	va_list ap;
+	char *p;
+
+	va_start(ap, fmt);
+	p = kvasprintf(gfp, fmt, ap);
+	va_end(ap);
+
+	return p;
+}
+EXPORT_SYMBOL(kasprintf);
diff -puN lib/vsprintf.c~lib-move-kasprintf-to-a-separate-file lib/vsprintf.c
--- a/lib/vsprintf.c~lib-move-kasprintf-to-a-separate-file
+++ a/lib/vsprintf.c
@@ -978,38 +978,3 @@ int sscanf(const char * buf, const char 
 }
 
 EXPORT_SYMBOL(sscanf);
-
-
-/* Simplified asprintf. */
-char *kvasprintf(gfp_t gfp, const char *fmt, va_list ap)
-{
-	unsigned int len;
-	char *p;
-	va_list aq;
-
-	va_copy(aq, ap);
-	len = vsnprintf(NULL, 0, fmt, aq);
-	va_end(aq);
-
-	p = kmalloc(len+1, gfp);
-	if (!p)
-		return NULL;
-
-	vsnprintf(p, len+1, fmt, ap);
-
-	return p;
-}
-EXPORT_SYMBOL(kvasprintf);
-
-char *kasprintf(gfp_t gfp, const char *fmt, ...)
-{
-	va_list ap;
-	char *p;
-
-	va_start(ap, fmt);
-	p = kvasprintf(gfp, fmt, ap);
-	va_end(ap);
-
-	return p;
-}
-EXPORT_SYMBOL(kasprintf);
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
powerpc-vdso-install-unstripped-copies-on-disk.patch
pass-g-to-assembler-under-config_debug_info.patch
mkmakefile-include-arch-on-o=-builds.patch
include-linux-kbuild-remove-duplicate-entries.patch
i386-vdso-install-unstripped-copies-on-disk.patch
i386-vdso-install-unstripped-copies-on-disk-fix.patch
x86_64-ia32-vdso-install-unstripped-copies-on-disk.patch
x86-add-cpu-codenames-for-kconfigcpu.patch
change-order-in-kconfigcpu-i386.patch
