From: akpm@linux-foundation.org
Subject: + binfmt_misc-reuse-string_unescape_inplace.patch added to -mm tree
Date: Mon, 15 Apr 2013 14:41:05 -0700
Message-ID: <20130415214105.CB7CD31C1C6@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:40623 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322Ab3DOVlG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Apr 2013 17:41:06 -0400
Received: by mail-yh0-f73.google.com with SMTP id i21so31211yha.2
        for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2013 14:41:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andriy.shevchenko@linux.intel.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: binfmt_misc: reuse string_unescape_inplace()
has been added to the -mm tree.  Its filename is
     binfmt_misc-reuse-string_unescape_inplace.patch

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
-
 static char * check_special_flags (char * sfs, Node * e)
 {
 	char * p = sfs;
@@ -354,8 +337,9 @@ static Node *create_entry(const char __u
 		p[-1] = '\0';
 		if (!e->mask[0])
 			e->mask = NULL;
-		e->size = unquote(e->magic);
-		if (e->mask && unquote(e->mask) != e->size)
+		e->size = string_unescape_inplace(e->magic, UNESCAPE_HEX);
+		if (e->mask &&
+		    string_unescape_inplace(e->mask, UNESCAPE_HEX) != e->size)
 			goto Einval;
 		if (e->size + e->offset > BINPRM_BUF_SIZE)
 			goto Einval;
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

linux-next.patch
lib-net-make-isodigit-public-and-use-it.patch
lib-string_helpers-introduce-generic-string_unescape.patch
lib-string_helpers-introduce-generic-string_unescape-fix.patch
staging-speakup-remove-custom-string_unescape_any_inplace.patch
dynamic_debug-reuse-generic-string_unescape-function.patch
binfmt_misc-reuse-string_unescape_inplace.patch

