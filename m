From: akpm@linux-foundation.org
Subject: [merged] lib-stringc-improve-strrchr.patch removed from -mm tree
Date: Mon, 16 Feb 2015 12:15:52 -0800
Message-ID: <54e24ff8.iSMJ3aOqj1J1D1gM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50871 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbbBPUQ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:16:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/string.c: improve strrchr()
has been removed from the -mm tree.  Its filename was
     lib-stringc-improve-strrchr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/string.c: improve strrchr()

Instead of potentially passing over the string twice in case c is not
found, just keep track of the last occurrence.  According to
bloat-o-meter, this also cuts the generated code by a third (54 vs 36
bytes).  Oh, and we get rid of those 7-space indented lines.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN lib/string.c~lib-stringc-improve-strrchr lib/string.c
--- a/lib/string.c~lib-stringc-improve-strrchr
+++ a/lib/string.c
@@ -313,12 +313,12 @@ EXPORT_SYMBOL(strchrnul);
  */
 char *strrchr(const char *s, int c)
 {
-       const char *p = s + strlen(s);
-       do {
-           if (*p == (char)c)
-               return (char *)p;
-       } while (--p >= s);
-       return NULL;
+	const char *last = NULL;
+	do {
+		if (*s == (char)c)
+			last = s;
+	} while (*s++);
+	return (char *)last;
 }
 EXPORT_SYMBOL(strrchr);
 #endif
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch

