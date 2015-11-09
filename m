From: akpm@linux-foundation.org
Subject: [merged] lib-introduce-kvasprintf_const.patch removed from -mm
 tree
Date: Mon, 09 Nov 2015 12:12:42 -0800
Message-ID: <5640fe3a.tMhplxtkfWXlIgGc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57583 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbbKIUMm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 15:12:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/kasprintf.c: introduce kvasprintf_const
has been removed from the -mm tree.  Its filename was
     lib-introduce-kvasprintf_const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/kasprintf.c: introduce kvasprintf_const

This adds kvasprintf_const which tries to use kstrdup_const if possible:
If the format string contains no % characters, or if the format string is
exactly "%s", we delegate to kstrdup_const.  Otherwise, we fall back to
kvasprintf.

Just as for kstrdup_const, the main motivation is to save memory by
reusing .rodata when possible.

The return value should be freed by kfree_const, just like for
kstrdup_const.

There is deliberately no kasprintf_const: In the vast majority of cases,
the format string argument is a literal, so one can determine statically
whether one could instead use kstrdup_const directly (which would also
require one to change all corresponding kfree calls to kfree_const).

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    2 ++
 lib/kasprintf.c        |   16 ++++++++++++++++
 2 files changed, 18 insertions(+)

diff -puN include/linux/kernel.h~lib-introduce-kvasprintf_const include/linux/kernel.h
--- a/include/linux/kernel.h~lib-introduce-kvasprintf_const
+++ a/include/linux/kernel.h
@@ -413,6 +413,8 @@ extern __printf(2, 3)
 char *kasprintf(gfp_t gfp, const char *fmt, ...);
 extern __printf(2, 0)
 char *kvasprintf(gfp_t gfp, const char *fmt, va_list args);
+extern __printf(2, 0)
+const char *kvasprintf_const(gfp_t gfp, const char *fmt, va_list args);
 
 extern __scanf(2, 3)
 int sscanf(const char *, const char *, ...);
diff -puN lib/kasprintf.c~lib-introduce-kvasprintf_const lib/kasprintf.c
--- a/lib/kasprintf.c~lib-introduce-kvasprintf_const
+++ a/lib/kasprintf.c
@@ -31,6 +31,22 @@ char *kvasprintf(gfp_t gfp, const char *
 }
 EXPORT_SYMBOL(kvasprintf);
 
+/*
+ * If fmt contains no % (or is exactly %s), use kstrdup_const. If fmt
+ * (or the sole vararg) points to rodata, we will then save a memory
+ * allocation and string copy. In any case, the return value should be
+ * freed using kfree_const().
+ */
+const char *kvasprintf_const(gfp_t gfp, const char *fmt, va_list ap)
+{
+	if (!strchr(fmt, '%'))
+		return kstrdup_const(fmt, gfp);
+	if (!strcmp(fmt, "%s"))
+		return kstrdup_const(va_arg(ap, const char*), gfp);
+	return kvasprintf(gfp, fmt, ap);
+}
+EXPORT_SYMBOL(kvasprintf_const);
+
 char *kasprintf(gfp_t gfp, const char *fmt, ...)
 {
 	va_list ap;
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

slabh-sprinkle-__assume_aligned-attributes.patch

