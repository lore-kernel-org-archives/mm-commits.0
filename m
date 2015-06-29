From: akpm@linux-foundation.org
Subject: [merged] lib-string-introduce-strreplace.patch removed from -mm
 tree
Date: Mon, 29 Jun 2015 13:48:05 -0700
Message-ID: <5591af05.25VE4IEWKXvWFcNr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50918 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039AbbF2UsG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:48:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, gregkh@linuxfoundation.org, joe@perches.com, neilb@suse.de, rostedt@goodmis.org, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/string.c: introduce strreplace()
has been removed from the -mm tree.  Its filename was
     lib-string-introduce-strreplace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/string.c: introduce strreplace()

Strings are sometimes sanitized by replacing a certain character (often
'/') by another (often '!').  In a few places, this is done the same way
Schlemiel the Painter would do it.  Others are slightly smarter but still
do multiple strchr() calls.  Introduce strreplace() to do this using a
single function call and a single pass over the string.

One would expect the return value to be one of three things: void, s, or
the number of replacements made.  I chose the fourth, returning a pointer
to the end of the string.  This is more likely to be useful (for example
allowing the caller to avoid a strlen call).

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Neil Brown <neilb@suse.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string.h |    1 +
 lib/string.c           |   17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff -puN include/linux/string.h~lib-string-introduce-strreplace include/linux/string.h
--- a/include/linux/string.h~lib-string-introduce-strreplace
+++ a/include/linux/string.h
@@ -111,6 +111,7 @@ extern int memcmp(const void *,const voi
 extern void * memchr(const void *,int,__kernel_size_t);
 #endif
 void *memchr_inv(const void *s, int c, size_t n);
+char *strreplace(char *s, char old, char new);
 
 extern void kfree_const(const void *x);
 
diff -puN lib/string.c~lib-string-introduce-strreplace lib/string.c
--- a/lib/string.c~lib-string-introduce-strreplace
+++ a/lib/string.c
@@ -849,3 +849,20 @@ void *memchr_inv(const void *start, int
 	return check_bytes8(start, value, bytes % 8);
 }
 EXPORT_SYMBOL(memchr_inv);
+
+/**
+ * strreplace - Replace all occurrences of character in string.
+ * @s: The string to operate on.
+ * @old: The character being replaced.
+ * @new: The character @old is replaced with.
+ *
+ * Returns pointer to the nul byte at the end of @s.
+ */
+char *strreplace(char *s, char old, char new)
+{
+	for (; *s; ++s)
+		if (*s == old)
+			*s = new;
+	return s;
+}
+EXPORT_SYMBOL(strreplace);
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch

