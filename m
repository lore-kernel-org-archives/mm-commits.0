From: akpm@linux-foundation.org
Subject: + lib-string-remove-duplicated-function.patch added to -mm tree
Date: Thu, 11 Sep 2014 15:18:44 -0700
Message-ID: <54121fc4.A9jDV4XjUmSnkxg0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44139 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827AbaIKWSp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Sep 2014 18:18:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, ak@linux.intel.com, dan.carpenter@oracle.com, grant.likely@linaro.org, hpa@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/string.c: remove duplicated function
has been added to the -mm tree.  Its filename is
     lib-string-remove-duplicated-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-string-remove-duplicated-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-string-remove-duplicated-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/string.c: remove duplicated function

lib/string.c contains two functions, strnicmp and strncasecmp, which do
roughly the same thing, namely compare two strings case-insensitively up
to a given bound.  They have slightly different implementations, but the
only important difference is that strncasecmp doesn't handle len==0
appropriately; it effectively becomes strcasecmp in that case.  strnicmp
correctly says that two strings are always equal in their first 0
characters.

strncasecmp is the POSIX name for this functionality.  So rename the
non-broken function to the standard name.  To minimize the impact on the
rest of the kernel (and since both are exported to modules), make strnicmp
a wrapper for strncasecmp.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string.c |   27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff -puN lib/string.c~lib-string-remove-duplicated-function lib/string.c
--- a/lib/string.c~lib-string-remove-duplicated-function
+++ a/lib/string.c
@@ -27,14 +27,14 @@
 #include <linux/bug.h>
 #include <linux/errno.h>
 
-#ifndef __HAVE_ARCH_STRNICMP
+#ifndef __HAVE_ARCH_STRNCASECMP
 /**
- * strnicmp - Case insensitive, length-limited string comparison
+ * strncasecmp - Case insensitive, length-limited string comparison
  * @s1: One string
  * @s2: The other string
  * @len: the maximum number of characters to compare
  */
-int strnicmp(const char *s1, const char *s2, size_t len)
+int strncasecmp(const char *s1, const char *s2, size_t len)
 {
 	/* Yes, Virginia, it had better be unsigned */
 	unsigned char c1, c2;
@@ -56,6 +56,13 @@ int strnicmp(const char *s1, const char
 	} while (--len);
 	return (int)c1 - (int)c2;
 }
+EXPORT_SYMBOL(strncasecmp);
+#endif
+#ifndef __HAVE_ARCH_STRNICMP
+int strnicmp(const char *s1, const char *s2, size_t len)
+{
+	return strncasecmp(s1, s2, len);
+}
 EXPORT_SYMBOL(strnicmp);
 #endif
 
@@ -73,20 +80,6 @@ int strcasecmp(const char *s1, const cha
 EXPORT_SYMBOL(strcasecmp);
 #endif
 
-#ifndef __HAVE_ARCH_STRNCASECMP
-int strncasecmp(const char *s1, const char *s2, size_t n)
-{
-	int c1, c2;
-
-	do {
-		c1 = tolower(*s1++);
-		c2 = tolower(*s2++);
-	} while ((--n > 0) && c1 == c2 && c1 != 0);
-	return c1 - c2;
-}
-EXPORT_SYMBOL(strncasecmp);
-#endif
