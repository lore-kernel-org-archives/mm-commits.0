From: akpm@linux-foundation.org
Subject: + lib-fix-scnprintf-if-size-is-==-0.patch added to -mm tree
Date: Fri, 24 Sep 2010 15:15:11 -0700
Message-ID: <201009242215.o8OMFCPJ028432@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47221 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752600Ab0IXWPV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Sep 2010 18:15:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiaosuo@gmail.com, joe@perches.com, mingo@elte.hu


The patch titled
     lib: fix scnprintf() if @size is == 0
has been added to the -mm tree.  Its filename is
     lib-fix-scnprintf-if-size-is-==-0.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib: fix scnprintf() if @size is == 0
From: Changli Gao <xiaosuo@gmail.com>

scnprintf() should return 0 if @size is == 0. Update the comment for it,
as @size is unsigned.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN lib/vsprintf.c~lib-fix-scnprintf-if-size-is-==-0 lib/vsprintf.c
--- a/lib/vsprintf.c~lib-fix-scnprintf-if-size-is-==-0
+++ a/lib/vsprintf.c
@@ -1504,7 +1504,7 @@ EXPORT_SYMBOL(snprintf);
  * @...: Arguments for the format string
  *
  * The return value is the number of characters written into @buf not including
- * the trailing '\0'. If @size is <= 0 the function returns 0.
+ * the trailing '\0'. If @size is == 0 the function returns 0.
  */
 
 int scnprintf(char *buf, size_t size, const char *fmt, ...)
@@ -1516,7 +1516,11 @@ int scnprintf(char *buf, size_t size, co
 	i = vsnprintf(buf, size, fmt, args);
 	va_end(args);
 
-	return (i >= size) ? (size - 1) : i;
+	if (likely(i < size))
+		return i;
+	if (size != 0)
+		return size - 1;
+	return 0;
 }
 EXPORT_SYMBOL(scnprintf);
 
_

Patches currently in -mm which might be from xiaosuo@gmail.com are

linux-next.patch
timer-initialize-the-field-slack-of-timer_list.patch
lib-fix-scnprintf-if-size-is-==-0.patch

