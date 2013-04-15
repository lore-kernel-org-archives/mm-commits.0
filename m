From: akpm@linux-foundation.org
Subject: + dynamic_debug-reuse-generic-string_unescape-function.patch added to -mm tree
Date: Mon, 15 Apr 2013 14:41:03 -0700
Message-ID: <20130415214103.CCFEA31C145@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:37920 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322Ab3DOVlF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Apr 2013 17:41:05 -0400
Received: by mail-vc0-f202.google.com with SMTP id m16so515064vca.3
        for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2013 14:41:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andriy.shevchenko@linux.intel.com, jbaron@redhat.com


The patch titled
     Subject: dynamic_debug: reuse generic string_unescape function
has been added to the -mm tree.  Its filename is
     dynamic_debug-reuse-generic-string_unescape-function.patch

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
Subject: dynamic_debug: reuse generic string_unescape function

There is kernel function to do the job in generic way. Let's use it.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Jason Baron <jbaron@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dynamic_debug.c |   48 ++++--------------------------------------
 1 file changed, 5 insertions(+), 43 deletions(-)

diff -puN lib/dynamic_debug.c~dynamic_debug-reuse-generic-string_unescape-function lib/dynamic_debug.c
--- a/lib/dynamic_debug.c~dynamic_debug-reuse-generic-string_unescape-function
+++ a/lib/dynamic_debug.c
@@ -24,6 +24,7 @@
 #include <linux/sysctl.h>
 #include <linux/ctype.h>
 #include <linux/string.h>
+#include <linux/string_helpers.h>
 #include <linux/uaccess.h>
 #include <linux/dynamic_debug.h>
 #include <linux/debugfs.h>
@@ -276,47 +277,6 @@ static inline int parse_lineno(const cha
 	return 0;
 }
 
-/*
- * Undo octal escaping in a string, inplace.  This is useful to
- * allow the user to express a query which matches a format
- * containing embedded spaces.
- */
-static char *unescape(char *str)
-{
-	char *in = str;
-	char *out = str;
-
-	while (*in) {
-		if (*in == '\\') {
-			if (in[1] == '\\') {
-				*out++ = '\\';
-				in += 2;
-				continue;
-			} else if (in[1] == 't') {
-				*out++ = '\t';
-				in += 2;
-				continue;
-			} else if (in[1] == 'n') {
-				*out++ = '\n';
-				in += 2;
-				continue;
-			} else if (isodigit(in[1]) &&
-				   isodigit(in[2]) &&
-				   isodigit(in[3])) {
-				*out++ = (((in[1] - '0') << 6) |
-					  ((in[2] - '0') << 3) |
-					  (in[3] - '0'));
-				in += 4;
-				continue;
-			}
-		}
-		*out++ = *in++;
-	}
-	*out = '\0';
-
-	return str;
-}
-
 static int check_set(const char **dest, char *src, char *name)
 {
 	int rc = 0;
@@ -370,8 +330,10 @@ static int ddebug_parse_query(char *word
 		} else if (!strcmp(words[i], "module")) {
 			rc = check_set(&query->module, words[i+1], "module");
 		} else if (!strcmp(words[i], "format")) {
-			rc = check_set(&query->format, unescape(words[i+1]),
-				       "format");
+			string_unescape_inplace(words[i+1], UNESCAPE_SPACE |
+							    UNESCAPE_OCTAL |
+							    UNESCAPE_SPECIAL);
+			rc = check_set(&query->format, words[i+1], "format");
 		} else if (!strcmp(words[i], "line")) {
 			char *first = words[i+1];
 			char *last = strchr(first, '-');
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

linux-next.patch
lib-net-make-isodigit-public-and-use-it.patch
lib-string_helpers-introduce-generic-string_unescape.patch
lib-string_helpers-introduce-generic-string_unescape-fix.patch
staging-speakup-remove-custom-string_unescape_any_inplace.patch
dynamic_debug-reuse-generic-string_unescape-function.patch
binfmt_misc-reuse-string_unescape_inplace.patch

