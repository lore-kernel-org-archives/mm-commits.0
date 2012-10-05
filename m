From: akpm@linux-foundation.org
Subject: [merged] lib-vsprintf-optimize-division-by-10000.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:14:10 -0700
Message-ID: <20121005201411.3ABB7200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:57026 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820Ab2JEUOO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:14:14 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so98820lah.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:14:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@horizon.com, mina86@mina86.com, vda.linux@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: vsprintf: optimize division by 10000
has been removed from the -mm tree.  Its filename was
     lib-vsprintf-optimize-division-by-10000.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
