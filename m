From: akpm@linux-foundation.org
Subject: [merged] lib-vsprintf-optimize-put_dec_trunc8.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:14:14 -0700
Message-ID: <20121005201415.2592A5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:54984 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820Ab2JEUOR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:14:17 -0400
Received: by mail-wi0-f202.google.com with SMTP id hr7so57836wib.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:14:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@horizon.com, mina86@mina86.com, rabin@rab.in, vda.linux@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: vsprintf: optimize put_dec_trunc8()
has been removed from the -mm tree.  Its filename was
     lib-vsprintf-optimize-put_dec_trunc8.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: Rabin Vincent <rabin@rab.in>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff -puN lib/vsprintf.c~lib-vsprintf-optimize-put_dec_trunc8 lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintf-optimize-put_dec_trunc8
+++ a/lib/vsprintf.c
@@ -174,22 +174,12 @@ char *put_dec_trunc8(char *buf, unsigned
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
-	if (r == 0)
-		return buf;
+	while (r >= 10000) {
+		q = r + '0';
+		r  = (r * (uint64_t)0x1999999a) >> 32;
+		*buf++ = q - 10*r;
+	}
+
 	q      = (r * 0x199a) >> 16;
 	*buf++ = (r - 10 * q)  + '0'; /* 6 */
 	if (q == 0)
_

Patches currently in -mm which might be from linux@horizon.com are

origin.patch

