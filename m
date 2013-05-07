From: akpm@linux-foundation.org
Subject: [merged] dynamic_debug-reuse-generic-string_unescape-function.patch removed from -mm tree
Date: Tue, 07 May 2013 10:47:50 -0700
Message-ID: <20130507174750.75E9D5A41B9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:54037 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759295Ab3EGRrv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:47:51 -0400
Received: by mail-qe0-f74.google.com with SMTP id 1so85135qec.1
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:47:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, jbaron@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dynamic_debug: reuse generic string_unescape function
has been removed from the -mm tree.  Its filename was
     dynamic_debug-reuse-generic-string_unescape-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
