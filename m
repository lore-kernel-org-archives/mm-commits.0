From: akpm@linux-foundation.org
Subject: + lib-vsprintf-optimize-put_dec_trunc8.patch added to -mm tree
Date: Wed, 15 Aug 2012 15:37:23 -0700
Message-ID: <20120815223724.368081E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:44296 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab2HOWhZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Aug 2012 18:37:25 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so1513489obb.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Aug 2012 15:37:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@horizon.com, mina86@mina86.com, vda.linux@googlemail.com


The patch titled
     Subject: lib: vsprintf: optimize put_dec_trunc8()
has been added to the -mm tree.  Its filename is
     lib-vsprintf-optimize-put_dec_trunc8.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: George Spelvin <linux@horizon.com>
Subject: lib: vsprintf: optimize put_dec_trunc8()

If you're going to have a conditional branch after each 32x32->64-bit
multiply, might as well shrink the code and make it a loop.

This also avoids using the long multiply for small integers.

(This leaves the comments in a confusing state, but that's a separate
patch to make review easier.)

Signed-off-by: George Spelvin <linux@horizon.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff -puN lib/vsprintf.c~lib-vsprintf-optimize-put_dec_trunc8 lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintf-optimize-put_dec_trunc8
+++ a/lib/vsprintf.c
@@ -174,20 +174,12 @@ char *put_dec_trunc8(char *buf, unsigned
 	unsigned q;
 
 	/* Copy of previous function's body with added early returns */
-	q      = (r * (uint64_t)0x1999999a) >> 32;
-	*buf++ = (r - 10 * q) + '0'; /* 2 */
-	if (q == 0)
-		return buf;
-	r      = (q * (uint64_t)0x1999999a) >> 32;
-	*buf++ = (q - 10 * r) + '0'; /* 3 */
-	if (r == 0)
-		return buf;
-	q      = (r * (uint64_t)0x1999999a) >> 32;
-	*buf++ = (r - 10 * q) + '0'; /* 4 */
-	if (q == 0)
-		return buf;
-	r      = (q * (uint64_t)0x1999999a) >> 32;
-	*buf++ = (q - 10 * r) + '0'; /* 5 */
+	while (r >= 10000) {
+		q = r + '0';
+		r  = (r * (uint64_t)0x1999999a) >> 32;
+		*buf++ = q - 10*r;
+	}
+
 	if (r == 0)
 		return buf;
 	q      = (r * 0x199a) >> 16;
_

Patches currently in -mm which might be from linux@horizon.com are

lib-vsprintf-optimize-division-by-10-for-small-integers.patch
lib-vsprintf-optimize-division-by-10000.patch
lib-vsprintf-optimize-put_dec_trunc8.patch
lib-vsprintf-fix-broken-comments.patch

