From: akpm@linux-foundation.org
Subject: [merged] lib-fix-vscnprintf-if-size-is-==-0.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:05:19 -0800
Message-ID: <201101132008.p0DK80vl029833@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46816 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933642Ab1AMUIb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:08:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarapov@redhat.com, xiaosuo@gmail.com, mm-commits@vger.kernel.org


The patch titled
     lib/vsprintf.c: fix vscnprintf() if @size is == 0
has been removed from the -mm tree.  Its filename was
     lib-fix-vscnprintf-if-size-is-==-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib/vsprintf.c: fix vscnprintf() if @size is == 0
From: Anton Arapov <aarapov@redhat.com>

vscnprintf() should return 0 if @size is == 0.  Update the comment for it,
as @size is unsigned.

This change based on the code of commit
b903c0b8899b46829a9b80ba55b61079b35940ec ("lib: fix scnprintf() if @size
is == 0") moves the real fix into vscnprinf() from scnprintf() and makes
scnprintf() call vscnprintf(), thus avoid code duplication.

Signed-off-by: Anton Arapov <aarapov@redhat.com>
Acked-by: Changli Gao <xiaosuo@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN lib/vsprintf.c~lib-fix-vscnprintf-if-size-is-==-0 lib/vsprintf.c
--- a/lib/vsprintf.c~lib-fix-vscnprintf-if-size-is-==-0
+++ a/lib/vsprintf.c
@@ -1473,7 +1473,7 @@ EXPORT_SYMBOL(vsnprintf);
  * @args: Arguments for the format string
  *
  * The return value is the number of characters which have been written into
- * the @buf not including the trailing '\0'. If @size is <= 0 the function
+ * the @buf not including the trailing '\0'. If @size is == 0 the function
  * returns 0.
  *
  * Call this function if you are already dealing with a va_list.
@@ -1487,7 +1487,11 @@ int vscnprintf(char *buf, size_t size, c
 
 	i = vsnprintf(buf, size, fmt, args);
 
-	return (i >= size) ? (size - 1) : i;
+	if (likely(i < size))
+		return i;
+	if (size != 0)
+		return size - 1;
+	return 0;
 }
 EXPORT_SYMBOL(vscnprintf);
 
@@ -1535,14 +1539,10 @@ int scnprintf(char *buf, size_t size, co
 	int i;
 
 	va_start(args, fmt);
-	i = vsnprintf(buf, size, fmt, args);
+	i = vscnprintf(buf, size, fmt, args);
 	va_end(args);
 
-	if (likely(i < size))
-		return i;
-	if (size != 0)
-		return size - 1;
-	return 0;
+	return i;
 }
 EXPORT_SYMBOL(scnprintf);
 
_

Patches currently in -mm which might be from aarapov@redhat.com are

origin.patch

