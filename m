From: akpm@linux-foundation.org
Subject: [merged] vsprintf-further-optimize-decimal-conversion.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:33:07 -0700
Message-ID: <20120601193307.82669A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:56227 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758406Ab2FATdI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:33:08 -0400
Received: by qcsp5 with SMTP id p5so246756qcs.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:33:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vda.linux@googlemail.com, jones@cs.uiowa.edu, mina86@mina86.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vsprintf: further optimize decimal conversion
has been removed from the -mm tree.  Its filename was
     vsprintf-further-optimize-decimal-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: vsprintf: further optimize decimal conversion

Previous code was using optimizations which were developed to work well
even on narrow-word CPUs (by today's standards).  But Linux runs only on
32-bit and wider CPUs.  We can use that.

First: using 32x32->64 multiply and trivial 32-bit shift, we can correctly
divide by 10 much larger numbers, and thus we can print groups of 9 digits
instead of groups of 5 digits.

Next: there are two algorithms to print larger numbers.  One is generic:
divide by 1000000000 and repeatedly print groups of (up to) 9 digits. 
It's conceptually simple, but requires an (unsigned long long) /
1000000000 division.

Second algorithm splits 64-bit unsigned long long into 16-bit chunks,
manipulates them cleverly and generates groups of 4 decimal digits.  It so
happens that it does NOT require long long division.

If long is > 32 bits, division of 64-bit values is relatively easy, and we
will use the first algorithm.  If long long is > 64 bits (strange
architecture with VERY large long long), second algorithm can't be used,
and we again use the first one.

Else (if long is 32 bits and long long is 64 bits) we use second one.

And third: there is a simple optimization which takes fast path not only
for zero as was done before, but for all one-digit numbers.

In all tested cases new code is faster than old one, in many cases by 30%,
in few cases by more than 50% (for example, on x86-32, conversion of
12345678).  Code growth is ~0 in 32-bit case and ~130 bytes in 64-bit
case.

This patch is based upon an original from Michal Nazarewicz.

[akpm@linux-foundation.org: checkpatch fixes]
Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Douglas W Jones <jones@cs.uiowa.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bitsperlong.h |    4 
 lib/vsprintf.c                    |  283 ++++++++++++++++++----------
 2 files changed, 195 insertions(+), 92 deletions(-)

diff -puN include/asm-generic/bitsperlong.h~vsprintf-further-optimize-decimal-conversion include/asm-generic/bitsperlong.h
--- a/include/asm-generic/bitsperlong.h~vsprintf-further-optimize-decimal-conversion
+++ a/include/asm-generic/bitsperlong.h
@@ -28,5 +28,9 @@
 #error Inconsistent word size. Check asm/bitsperlong.h
 #endif
 
+#ifndef BITS_PER_LONG_LONG
+#define BITS_PER_LONG_LONG 64
+#endif
+
 #endif /* __KERNEL__ */
 #endif /* __ASM_GENERIC_BITS_PER_LONG */
diff -puN lib/vsprintf.c~vsprintf-further-optimize-decimal-conversion lib/vsprintf.c
--- a/lib/vsprintf.c~vsprintf-further-optimize-decimal-conversion
+++ a/lib/vsprintf.c
@@ -112,106 +112,199 @@ int skip_atoi(const char **s)
 /* Decimal conversion is by far the most typical, and is used
  * for /proc and /sys data. This directly impacts e.g. top performance
  * with many processes running. We optimize it for speed
- * using code from
- * http://www.cs.uiowa.edu/~jones/bcd/decimal.html
- * (with permission from the author, Douglas W. Jones). */
-
-/* Formats correctly any integer in [0,99999].
- * Outputs from one to five digits depending on input.
- * On i386 gcc 4.1.2 -O2: ~250 bytes of code. */
-static noinline_for_stack
-char *put_dec_trunc(char *buf, unsigned q)
-{
-	unsigned d3, d2, d1, d0;
-	d1 = (q>>4) & 0xf;
-	d2 = (q>>8) & 0xf;
-	d3 = (q>>12);
-
-	d0 = 6*(d3 + d2 + d1) + (q & 0xf);
-	q = (d0 * 0xcd) >> 11;
-	d0 = d0 - 10*q;
-	*buf++ = d0 + '0'; /* least significant digit */
-	d1 = q + 9*d3 + 5*d2 + d1;
-	if (d1 != 0) {
-		q = (d1 * 0xcd) >> 11;
-		d1 = d1 - 10*q;
-		*buf++ = d1 + '0'; /* next digit */
-
-		d2 = q + 2*d2;
-		if ((d2 != 0) || (d3 != 0)) {
-			q = (d2 * 0xd) >> 7;
-			d2 = d2 - 10*q;
-			*buf++ = d2 + '0'; /* next digit */
-
-			d3 = q + 4*d3;
-			if (d3 != 0) {
-				q = (d3 * 0xcd) >> 11;
-				d3 = d3 - 10*q;
-				*buf++ = d3 + '0';  /* next digit */
-				if (q != 0)
-					*buf++ = q + '0'; /* most sign. digit */
-			}
-		}
-	}
+ * using ideas described at <http://www.cs.uiowa.edu/~jones/bcd/divide.html>
+ * (with permission from the author, Douglas W. Jones).
+ */
 
-	return buf;
-}
-/* Same with if's removed. Always emits five digits */
+#if BITS_PER_LONG != 32 || BITS_PER_LONG_LONG != 64
+/* Formats correctly any integer in [0, 999999999] */
 static noinline_for_stack
-char *put_dec_full(char *buf, unsigned q)
+char *put_dec_full9(char *buf, unsigned q)
 {
-	/* BTW, if q is in [0,9999], 8-bit ints will be enough, */
-	/* but anyway, gcc produces better code with full-sized ints */
-	unsigned d3, d2, d1, d0;
-	d1 = (q>>4) & 0xf;
-	d2 = (q>>8) & 0xf;
-	d3 = (q>>12);
+	unsigned r;
 
 	/*
 	 * Possible ways to approx. divide by 10
-	 * gcc -O2 replaces multiply with shifts and adds
-	 * (x * 0xcd) >> 11: 11001101 - shorter code than * 0x67 (on i386)
-	 * (x * 0x67) >> 10:  1100111
-	 * (x * 0x34) >> 9:    110100 - same
-	 * (x * 0x1a) >> 8:     11010 - same
-	 * (x * 0x0d) >> 7:      1101 - same, shortest code (on i386)
+	 * (x * 0x1999999a) >> 32 x < 1073741829 (multiply must be 64-bit)
+	 * (x * 0xcccd) >> 19     x <      81920 (x < 262149 when 64-bit mul)
+	 * (x * 0x6667) >> 18     x <      43699
+	 * (x * 0x3334) >> 17     x <      16389
+	 * (x * 0x199a) >> 16     x <      16389
+	 * (x * 0x0ccd) >> 15     x <      16389
+	 * (x * 0x0667) >> 14     x <       2739
+	 * (x * 0x0334) >> 13     x <       1029
+	 * (x * 0x019a) >> 12     x <       1029
+	 * (x * 0x00cd) >> 11     x <       1029 shorter code than * 0x67 (on i386)
+	 * (x * 0x0067) >> 10     x <        179
+	 * (x * 0x0034) >>  9     x <         69 same
+	 * (x * 0x001a) >>  8     x <         69 same
+	 * (x * 0x000d) >>  7     x <         69 same, shortest code (on i386)
+	 * (x * 0x0007) >>  6     x <         19
+	 * See <http://www.cs.uiowa.edu/~jones/bcd/divide.html>
 	 */
-	d0 = 6*(d3 + d2 + d1) + (q & 0xf);
-	q = (d0 * 0xcd) >> 11;
-	d0 = d0 - 10*q;
-	*buf++ = d0 + '0';
-	d1 = q + 9*d3 + 5*d2 + d1;
-		q = (d1 * 0xcd) >> 11;
-		d1 = d1 - 10*q;
-		*buf++ = d1 + '0';
-
-		d2 = q + 2*d2;
-			q = (d2 * 0xd) >> 7;
-			d2 = d2 - 10*q;
-			*buf++ = d2 + '0';
-
-			d3 = q + 4*d3;
-				q = (d3 * 0xcd) >> 11; /* - shorter code */
-				/* q = (d3 * 0x67) >> 10; - would also work */
-				d3 = d3 - 10*q;
-				*buf++ = d3 + '0';
-					*buf++ = q + '0';
-
+	r      = (q * (uint64_t)0x1999999a) >> 32;
+	*buf++ = (q - 10 * r) + '0'; /* 1 */
+	q      = (r * (uint64_t)0x1999999a) >> 32;
+	*buf++ = (r - 10 * q) + '0'; /* 2 */
+	r      = (q * (uint64_t)0x1999999a) >> 32;
+	*buf++ = (q - 10 * r) + '0'; /* 3 */
+	q      = (r * (uint64_t)0x1999999a) >> 32;
+	*buf++ = (r - 10 * q) + '0'; /* 4 */
+	r      = (q * (uint64_t)0x1999999a) >> 32;
+	*buf++ = (q - 10 * r) + '0'; /* 5 */
+	/* Now value is under 10000, can avoid 64-bit multiply */
+	q      = (r * 0x199a) >> 16;
+	*buf++ = (r - 10 * q)  + '0'; /* 6 */
+	r      = (q * 0xcd) >> 11;
+	*buf++ = (q - 10 * r)  + '0'; /* 7 */
+	q      = (r * 0xcd) >> 11;
+	*buf++ = (r - 10 * q) + '0'; /* 8 */
+	*buf++ = q + '0'; /* 9 */
 	return buf;
 }
-/* No inlining helps gcc to use registers better */
+#endif
+
+/* Similar to above but do not pad with zeros.
+ * Code can be easily arranged to print 9 digits too, but our callers
+ * always call put_dec_full9() instead when the number has 9 decimal digits.
+ */
 static noinline_for_stack
-char *put_dec(char *buf, unsigned long long num)
+char *put_dec_trunc8(char *buf, unsigned r)
+{
+	unsigned q;
+
+	/* Copy of previous function's body with added early returns */
+	q      = (r * (uint64_t)0x1999999a) >> 32;
+	*buf++ = (r - 10 * q) + '0'; /* 2 */
+	if (q == 0)
+		return buf;
+	r      = (q * (uint64_t)0x1999999a) >> 32;
+	*buf++ = (q - 10 * r) + '0'; /* 3 */
+	if (r == 0)
+		return buf;
+	q      = (r * (uint64_t)0x1999999a) >> 32;
+	*buf++ = (r - 10 * q) + '0'; /* 4 */
+	if (q == 0)
+		return buf;
+	r      = (q * (uint64_t)0x1999999a) >> 32;
+	*buf++ = (q - 10 * r) + '0'; /* 5 */
+	if (r == 0)
+		return buf;
+	q      = (r * 0x199a) >> 16;
+	*buf++ = (r - 10 * q)  + '0'; /* 6 */
+	if (q == 0)
+		return buf;
+	r      = (q * 0xcd) >> 11;
+	*buf++ = (q - 10 * r)  + '0'; /* 7 */
+	if (r == 0)
+		return buf;
+	q      = (r * 0xcd) >> 11;
+	*buf++ = (r - 10 * q) + '0'; /* 8 */
+	if (q == 0)
+		return buf;
+	*buf++ = q + '0'; /* 9 */
+	return buf;
+}
+
+/* There are two algorithms to print larger numbers.
+ * One is generic: divide by 1000000000 and repeatedly print
+ * groups of (up to) 9 digits. It's conceptually simple,
+ * but requires a (unsigned long long) / 1000000000 division.
+ *
+ * Second algorithm splits 64-bit unsigned long long into 16-bit chunks,
+ * manipulates them cleverly and generates groups of 4 decimal digits.
+ * It so happens that it does NOT require long long division.
+ *
+ * If long is > 32 bits, division of 64-bit values is relatively easy,
+ * and we will use the first algorithm.
+ * If long long is > 64 bits (strange architecture with VERY large long long),
+ * second algorithm can't be used, and we again use the first one.
+ *
+ * Else (if long is 32 bits and long long is 64 bits) we use second one.
+ */
+
+#if BITS_PER_LONG != 32 || BITS_PER_LONG_LONG != 64
+
+/* First algorithm: generic */
+
+static
+char *put_dec(char *buf, unsigned long long n)
 {
-	while (1) {
-		unsigned rem;
-		if (num < 100000)
-			return put_dec_trunc(buf, num);
-		rem = do_div(num, 100000);
-		buf = put_dec_full(buf, rem);
+	if (n >= 100*1000*1000) {
+		while (n >= 1000*1000*1000)
+			buf = put_dec_full9(buf, do_div(n, 1000*1000*1000));
+		if (n >= 100*1000*1000)
+			return put_dec_full9(buf, n);
 	}
+	return put_dec_trunc8(buf, n);
+}
+
+#else
+
+/* Second algorithm: valid only for 64-bit long longs */
+
+static noinline_for_stack
+char *put_dec_full4(char *buf, unsigned q)
+{
+	unsigned r;
+	r      = (q * 0xcccd) >> 19;
+	*buf++ = (q - 10 * r) + '0';
+	q      = (r * 0x199a) >> 16;
+	*buf++ = (r - 10 * q)  + '0';
+	r      = (q * 0xcd) >> 11;
+	*buf++ = (q - 10 * r)  + '0';
+	*buf++ = r + '0';
+	return buf;
+}
+
+/* Based on code by Douglas W. Jones found at
+ * <http://www.cs.uiowa.edu/~jones/bcd/decimal.html#sixtyfour>
+ * (with permission from the author).
+ * Performs no 64-bit division and hence should be fast on 32-bit machines.
+ */
+static
+char *put_dec(char *buf, unsigned long long n)
+{
+	uint32_t d3, d2, d1, q, h;
+
+	if (n < 100*1000*1000)
+		return put_dec_trunc8(buf, n);
+
+	d1  = ((uint32_t)n >> 16); /* implicit "& 0xffff" */
+	h   = (n >> 32);
+	d2  = (h      ) & 0xffff;
+	d3  = (h >> 16); /* implicit "& 0xffff" */
+
+	q   = 656 * d3 + 7296 * d2 + 5536 * d1 + ((uint32_t)n & 0xffff);
+
+	buf = put_dec_full4(buf, q % 10000);
+	q   = q / 10000;
+
+	d1  = q + 7671 * d3 + 9496 * d2 + 6 * d1;
+	buf = put_dec_full4(buf, d1 % 10000);
+	q   = d1 / 10000;
+
+	d2  = q + 4749 * d3 + 42 * d2;
+	buf = put_dec_full4(buf, d2 % 10000);
+	q   = d2 / 10000;
+
+	d3  = q + 281 * d3;
+	if (!d3)
+		goto done;
+	buf = put_dec_full4(buf, d3 % 10000);
+	q   = d3 / 10000;
+	if (!q)
+		goto done;
+	buf = put_dec_full4(buf, q);
+ done:
+	while (buf[-1] == '0')
+		--buf;
+
+	return buf;
 }
 
+#endif
+
 /*
  * Convert passed number to decimal string.
  * Returns the length of string.  On buffer overflow, returns 0.
@@ -220,16 +313,22 @@ char *put_dec(char *buf, unsigned long l
  */
 int num_to_str(char *buf, int size, unsigned long long num)
 {
-	char tmp[21];		/* Enough for 2^64 in decimal */
+	char tmp[sizeof(num) * 3];
 	int idx, len;
 
-	len = put_dec(tmp, num) - tmp;
+	/* put_dec() may work incorrectly for num = 0 (generate "", not "0") */
+	if (num <= 9) {
+		tmp[0] = '0' + num;
+		len = 1;
+	} else {
+		len = put_dec(tmp, num) - tmp;
+	}
 
 	if (len > size)
 		return 0;
 	for (idx = 0; idx < len; ++idx)
 		buf[idx] = tmp[len - idx - 1];
-	return  len;
+	return len;
 }
 
 #define ZEROPAD	1		/* pad with zero */
@@ -314,8 +413,8 @@ char *number(char *buf, char *end, unsig
 
 	/* generate full string in tmp[], in reverse order */
 	i = 0;
-	if (num == 0)
-		tmp[i++] = '0';
+	if (num < spec.base)
+		tmp[i++] = digits[num] | locase;
 	/* Generic code, for any base:
 	else do {
 		tmp[i++] = (digits[do_div(num,base)] | locase);
@@ -611,7 +710,7 @@ char *ip4_string(char *p, const u8 *addr
 	}
 	for (i = 0; i < 4; i++) {
 		char temp[3];	/* hold each IP quad in reverse order */
-		int digits = put_dec_trunc(temp, addr[index]) - temp;
+		int digits = put_dec_trunc8(temp, addr[index]) - temp;
 		if (leading_zeros) {
 			if (digits < 3)
 				*p++ = '0';
_

Patches currently in -mm which might be from vda.linux@googlemail.com are

origin.patch

