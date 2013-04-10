From: akpm@linux-foundation.org
Subject: + lib-net-make-isodigit-public-and-use-it.patch added to -mm tree
Date: Wed, 10 Apr 2013 15:06:18 -0700
Message-ID: <20130410220618.7F97231C022@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:59386 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab3DJWGT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Apr 2013 18:06:19 -0400
Received: by mail-ie0-f202.google.com with SMTP id x12so152460ief.5
        for <mm-commits@vger.kernel.org>; Wed, 10 Apr 2013 15:06:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andriy.shevchenko@linux.intel.com


The patch titled
     Subject: lib, net: make isodigit() public and use it
has been added to the -mm tree.  Its filename is
     lib-net-make-isodigit-public-and-use-it.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib, net: make isodigit() public and use it

There are at least two users of isodigit().  Let's make it a public
function of ctype.h.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ctype.h |    6 ++++++
 lib/dynamic_debug.c   |    1 -
 net/sunrpc/cache.c    |    1 -
 3 files changed, 6 insertions(+), 2 deletions(-)

diff -puN include/linux/ctype.h~lib-net-make-isodigit-public-and-use-it include/linux/ctype.h
--- a/include/linux/ctype.h~lib-net-make-isodigit-public-and-use-it
+++ a/include/linux/ctype.h
@@ -61,4 +61,10 @@ static inline char _tolower(const char c
 	return c | 0x20;
 }
 
+/* Fast check for octal digit */
+static inline int isodigit(const char c)
+{
+	return c >= '0' && c <= '7';
+}
+
 #endif
diff -puN lib/dynamic_debug.c~lib-net-make-isodigit-public-and-use-it lib/dynamic_debug.c
--- a/lib/dynamic_debug.c~lib-net-make-isodigit-public-and-use-it
+++ a/lib/dynamic_debug.c
@@ -281,7 +281,6 @@ static inline int parse_lineno(const cha
  * allow the user to express a query which matches a format
  * containing embedded spaces.
  */
-#define isodigit(c)		((c) >= '0' && (c) <= '7')
 static char *unescape(char *str)
 {
 	char *in = str;
diff -puN net/sunrpc/cache.c~lib-net-make-isodigit-public-and-use-it net/sunrpc/cache.c
--- a/net/sunrpc/cache.c~lib-net-make-isodigit-public-and-use-it
+++ a/net/sunrpc/cache.c
@@ -1210,7 +1210,6 @@ EXPORT_SYMBOL_GPL(sunrpc_cache_pipe_upca
  * key and content are both parsed by cache
  */
 
-#define isodigit(c) (isdigit(c) && c <= '7')
 int qword_get(char **bpp, char *dest, int bufsize)
 {
 	/* return bytes copied, or -1 on error */
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

linux-next.patch
lib-net-make-isodigit-public-and-use-it.patch

