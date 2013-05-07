From: akpm@linux-foundation.org
Subject: [merged] binfmt_misc-reuse-string_unescape_inplace.patch removed from -mm tree
Date: Tue, 07 May 2013 10:47:53 -0700
Message-ID: <20130507174753.77AE531C1EC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:57868 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759351Ab3EGRry (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:47:54 -0400
Received: by mail-qc0-f202.google.com with SMTP id d1so85132qcz.5
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:47:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: binfmt_misc: reuse string_unescape_inplace()
has been removed from the -mm tree.  Its filename was
     binfmt_misc-reuse-string_unescape_inplace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: binfmt_misc: reuse string_unescape_inplace()

There is string_unescape_inplace() function which decodes strings in generic
way. Let's use it.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
---
 1 file changed, 4 insertions(+), 20 deletions(-)

index 751df5e..1c740e1 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_misc.c |   24 ++++--------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

diff -puN fs/binfmt_misc.c~binfmt_misc-reuse-string_unescape_inplace fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~binfmt_misc-reuse-string_unescape_inplace
+++ a/fs/binfmt_misc.c
@@ -23,6 +23,7 @@
 #include <linux/binfmts.h>
 #include <linux/slab.h>
 #include <linux/ctype.h>
+#include <linux/string_helpers.h>
 #include <linux/file.h>
 #include <linux/pagemap.h>
 #include <linux/namei.h>
@@ -234,24 +235,6 @@ static char *scanarg(char *s, char del)
 	return s;
 }
 
-static int unquote(char *from)
-{
-	char c = 0, *s = from, *p = from;
-
-	while ((c = *s++) != '\0') {
-		if (c == '\\' && *s == 'x') {
-			s++;
-			c = toupper(*s++);
-			*p = (c - (isdigit(c) ? '0' : 'A' - 10)) << 4;
-			c = toupper(*s++);
-			*p++ |= c - (isdigit(c) ? '0' : 'A' - 10);
-			continue;
-		}
-		*p++ = c;
-	}
-	return p - from;
-}
