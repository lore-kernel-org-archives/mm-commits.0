From: akpm@linux-foundation.org
Subject: [merged] lib-net-make-isodigit-public-and-use-it.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:53:20 -0700
Message-ID: <20130430185320.74B5031C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:64522 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933133Ab3D3SxV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:53:21 -0400
Received: by mail-qa0-f73.google.com with SMTP id p6so87956qad.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:53:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib, net: make isodigit() public and use it
has been removed from the -mm tree.  Its filename was
     lib-net-make-isodigit-public-and-use-it.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1208,7 +1208,6 @@ EXPORT_SYMBOL_GPL(sunrpc_cache_pipe_upca
  * key and content are both parsed by cache
  */
 
-#define isodigit(c) (isdigit(c) && c <= '7')
 int qword_get(char **bpp, char *dest, int bufsize)
 {
 	/* return bytes copied, or -1 on error */
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

origin.patch
linux-next.patch
lib-string_helpers-introduce-generic-string_unescape.patch
lib-string_helpers-introduce-generic-string_unescape-fix.patch
staging-speakup-remove-custom-string_unescape_any_inplace.patch
dynamic_debug-reuse-generic-string_unescape-function.patch
binfmt_misc-reuse-string_unescape_inplace.patch

