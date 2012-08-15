From: akpm@linux-foundation.org
Subject: + lib-vsprintf-optimize-division-by-10000.patch added to -mm tree
Date: Wed, 15 Aug 2012 15:37:20 -0700
Message-ID: <20120815223721.243DF1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:44296 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab2HOWhW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Aug 2012 18:37:22 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so1513489obb.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Aug 2012 15:37:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@horizon.com, mina86@mina86.com, vda.linux@googlemail.com


The patch titled
     Subject: lib: vsprintf: optimize division by 10000
has been added to the -mm tree.  Its filename is
     lib-vsprintf-optimize-division-by-10000.patch

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
Subject: lib: vsprintf: optimize division by 10000

The same multiply-by-inverse technique can be used to convert division by
10000 to a 32x32->64-bit multiply.

Signed-off-by: George Spelvin <linux@horizon.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   58 +++++++++++++++++++++++++----------------------
 1 file changed, 32 insertions(+), 26 deletions(-)

diff -puN lib/vsprintf.c~lib-vsprintf-optimize-division-by-10000 lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintf-optimize-division-by-10000
+++ a/lib/vsprintf.c
@@ -245,17 +245,32 @@ char *put_dec(char *buf, unsigned long l
 
 /* See comment in put_dec_full9 for choice of constants */
 static noinline_for_stack
-char *put_dec_full4(char *buf, unsigned q)
+void put_dec_full4(char *buf, unsigned q)
 {
 	unsigned r;
 	r      = (q * 0xccd) >> 15;
-	*buf++ = (q - 10 * r) + '0';
+	buf[0] = (q - 10 * r) + '0';
 	q      = (r * 0xcd) >> 11;
-	*buf++ = (r - 10 * q)  + '0';
+	buf[1] = (r - 10 * q)  + '0';
 	r      = (q * 0xcd) >> 11;
-	*buf++ = (q - 10 * r)  + '0';
-	*buf++ = r + '0';
-	return buf;
+	buf[2] = (q - 10 * r)  + '0';
+	buf[3] = r + '0';
+}
+
+/*
+ * Call put_dec_full4 on x % 10000, return x / 10000.
+ * The approximation x/10000 == (x * 0x346DC5D7) >> 43
+ * holds for all x < 1,128,869,999.  The largest value this
+ * helper will ever be asked to convert is 1,125,520,955.
+ * (d1 in the put_dec code, assuming n is all-ones).
+ */
+static
+unsigned put_dec_helper4(char *buf, unsigned x)
+{
+        uint32_t q = (x * (uint64_t)0x346DC5D7) >> 43;
+
+        put_dec_full4(buf, x - q * 10000);
+        return q;
 }
 
 /* Based on code by Douglas W. Jones found at
@@ -277,28 +292,19 @@ char *put_dec(char *buf, unsigned long l
 	d3  = (h >> 16); /* implicit "& 0xffff" */
 
 	q   = 656 * d3 + 7296 * d2 + 5536 * d1 + ((uint32_t)n & 0xffff);
+	q = put_dec_helper4(buf, q);
+
+	q += 7671 * d3 + 9496 * d2 + 6 * d1;
+	q = put_dec_helper4(buf+4, q);
 
-	buf = put_dec_full4(buf, q % 10000);
-	q   = q / 10000;
+	q += 4749 * d3 + 42 * d2;
+	q = put_dec_helper4(buf+8, q);
 
-	d1  = q + 7671 * d3 + 9496 * d2 + 6 * d1;
-	buf = put_dec_full4(buf, d1 % 10000);
-	q   = d1 / 10000;
-
-	d2  = q + 4749 * d3 + 42 * d2;
-	buf = put_dec_full4(buf, d2 % 10000);
-	q   = d2 / 10000;
-
-	d3  = q + 281 * d3;
-	if (!d3)
-		goto done;
-	buf = put_dec_full4(buf, d3 % 10000);
-	q   = d3 / 10000;
-	if (!q)
-		goto done;
-	buf = put_dec_full4(buf, q);
- done:
-	while (buf[-1] == '0')
+	q += 281 * d3;
+	buf += 12;
+	if (q)
+		buf = put_dec_trunc8(buf, q);
+	else while (buf[-1] == '0')
 		--buf;
 
 	return buf;
_

Patches currently in -mm which might be from linux@horizon.com are

lib-vsprintf-optimize-division-by-10-for-small-integers.patch
lib-vsprintf-optimize-division-by-10000.patch
lib-vsprintf-optimize-put_dec_trunc8.patch
lib-vsprintf-fix-broken-comments.patch

