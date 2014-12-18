From: akpm@linux-foundation.org
Subject: + lib-string_get_size-return-void.patch added to -mm tree
Date: Thu, 18 Dec 2014 13:46:41 -0800
Message-ID: <54934b41.waeG+qNjv2+FcexB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56817 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbaLRVqm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Dec 2014 16:46:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: libstring_helpers.c:string_get_size(): return void
has been added to the -mm tree.  Its filename is
     lib-string_get_size-return-void.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-string_get_size-return-void.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-string_get_size-return-void.patch

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
Subject: libstring_helpers.c:string_get_size(): return void

string_get_size() was documented to return an error, but in fact always
returned 0.  Since the output always fits in 9 bytes, just document that
and let callers do what they do now: pass a small stack buffer and ignore
the return value.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string_helpers.h |    4 ++--
 lib/string_helpers.c           |   10 ++++------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff -puN include/linux/string_helpers.h~lib-string_get_size-return-void include/linux/string_helpers.h
--- a/include/linux/string_helpers.h~lib-string_get_size-return-void
+++ a/include/linux/string_helpers.h
@@ -10,8 +10,8 @@ enum string_size_units {
 	STRING_UNITS_2,		/* use binary powers of 2^10 */
 };
 
-int string_get_size(u64 size, enum string_size_units units,
-		    char *buf, int len);
+void string_get_size(u64 size, enum string_size_units units,
+		     char *buf, int len);
 
 #define UNESCAPE_SPACE		0x01
 #define UNESCAPE_OCTAL		0x02
diff -puN lib/string_helpers.c~lib-string_get_size-return-void lib/string_helpers.c
--- a/lib/string_helpers.c~lib-string_get_size-return-void
+++ a/lib/string_helpers.c
@@ -20,12 +20,12 @@
  * @len:	length of buffer
  *
  * This function returns a string formatted to 3 significant figures
- * giving the size in the required units.  Returns 0 on success or
- * error on failure.  @buf is always zero terminated.
+ * giving the size in the required units.  @buf should have room for
+ * at least 9 bytes and will always be zero terminated.
  *
  */
-int string_get_size(u64 size, const enum string_size_units units,
-		    char *buf, int len)
+void string_get_size(u64 size, const enum string_size_units units,
+		     char *buf, int len)
 {
 	static const char *const units_10[] = {
 		"B", "kB", "MB", "GB", "TB", "PB", "EB"
@@ -67,8 +67,6 @@ int string_get_size(u64 size, const enum
 
 	snprintf(buf, len, "%u%s %s", (u32)size,
 		 tmp, units_str[units][i]);
