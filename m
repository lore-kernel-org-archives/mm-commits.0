From: akpm@linux-foundation.org
Subject: + lib-vsprintf-optimised-put_dec-function.patch added to -mm tree
Date: Thu, 24 Feb 2011 13:51:20 -0800
Message-ID: <201102242151.p1OLpKSn028708@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751056Ab1BXVvk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Feb 2011 16:51:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mina86@mina86.com, jones@cs.uiowa.edu, vda.linux@googlemail.com


The patch titled
     lib: vsprintf: optimised put_dec() function
has been added to the -mm tree.  Its filename is
     lib-vsprintf-optimised-put_dec-function.patch

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
Subject: lib: vsprintf: optimised put_dec() function
From: Michal Nazarewicz <mina86@mina86.com>

The put_dec() and family of functions were based on a code optimised for
processors with 8-bit ALU but since we don't need to limit ourselves to
such small ALUs, the code was optimised and used capacities of an 16-bit
ALU anyway.

This patch goes further and uses the full capacity of the processor's ALU.

On 64-bit machines, the number is repeatedly divided by 100,000 to split
it into 5-decimal-digit which are converted using the obvious base
conversion algorithm expect division by ten is replaced with
multiplication and shifts.

On 32-bit machines, no division is performed at all and in particular, no
64-bit division is performed.  This can speed up conversion a few times
and up to 10 times!

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Douglas W. Jones <jones@cs.uiowa.edu>
Cc: Denis Vlasenko <vda.linux@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |  269 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 185 insertions(+), 84 deletions(-)

diff -puN lib/vsprintf.c~lib-vsprintf-optimised-put_dec-function lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintf-optimised-put_dec-function
+++ a/lib/vsprintf.c
@@ -272,109 +272,210 @@ int skip_atoi(const char **s)
 	return i;
 }
 
-/* Decimal conversion is by far the most typical, and is used
+
+#if BITS_PER_LONG > 32                   /* machine is at least 64-bit */    \
+ || ULLONG_MAX > 18446744073709551615ULL /* long long is more than 64-bit */
+
+/*
+ * Decimal conversion is by far the most typical, and is used
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
+ * using ideas described at <http://www.cs.uiowa.edu/~jones/bcd/divide.html>
+ * (with permission from the author, Douglas W. Jones).
+ *
+ * Formats correctly any integer in [0, 99999].
+ */
+static noinline_for_stack char *put_dec_full5(char *buf, unsigned q)
 {
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
+	unsigned r;
+
+	/*
+	 * '(x * 0xcccd) >> 19' is an approximation of 'x / 10' that
+	 * gives correct results for all x < 81920 unless we use full
+	 * 64-bit intermidiate result in which case it gives correct
+	 * results for x < 262149.  Because of this, we cast 0xcccd to
+	 * (uint64_t).  Thanks to this we can produce full 5 digits
+	 * without any branches.
+	 */
+
+	r      = (q * (uint64_t)0xcccd) >> 19;
+	*buf++ = (q - 10 * r) + '0';
+
+	/*
+	 * Other, possible ways to approx. divide by 10
+	 *  -- bigger loose most significant bits and are worse --
+	 * (x * 0xcccd) >> 19   x < 81920  (x < 262149 when 64-bit used)
+	 * (x * 0x6667) >> 18   x < 43699
+	 * (x * 0x3334) >> 17   x < 16389
+	 * (x * 0x199a) >> 16   x < 16389
+	 * (x * 0x0ccd) >> 15   x < 16389
+	 * (x * 0x0667) >> 14   x <  2739
+	 * (x * 0x0334) >> 13   x <  1029
+	 * (x * 0x019a) >> 12   x <  1029
+	 * (x * 0x00cd) >> 11   x <  1029   shorter code than * 0x67 (on i386)
+	 * (x * 0x0067) >> 10   x <   179
+	 * (x * 0x0034) >>  9   x <    69   same
+	 * (x * 0x001a) >>  8   x <    69   same
+	 * (x * 0x000d) >>  7   x <    69   same, shortest code (on i386)
+	 * (x * 0x0007) >>  6   x <    19
+	 *  -- smaller are useless --
+	 * See <http://www.cs.uiowa.edu/~jones/bcd/divide.html>.
+	 */
+
+	q      = (r * 0x199a) >> 16;
+	*buf++ = (r - 10 * q)  + '0';
+
+	r      = (q * 0xcd) >> 11;
+	*buf++ = (q - 10 * r)  + '0';
+
+	q      = (r * 0xcd) >> 11;
+	*buf++ = (r - 10 * q) + '0';
+
+	*buf++ = q + '0';
 
 	return buf;
 }
-/* Same with if's removed. Always emits five digits */
-static noinline_for_stack
-char *put_dec_full(char *buf, unsigned q)
+
+/* Same as above but do not pad with zeros. */
+static noinline_for_stack char *put_dec_trunc5(char *buf, unsigned q)
 {
-	/* BTW, if q is in [0,9999], 8-bit ints will be enough, */
-	/* but anyway, gcc produces better code with full-sized ints */
-	unsigned d3, d2, d1, d0;
-	d1 = (q>>4) & 0xf;
-	d2 = (q>>8) & 0xf;
-	d3 = (q>>12);
+	unsigned r;
 
 	/*
-	 * Possible ways to approx. divide by 10
-	 * gcc -O2 replaces multiply with shifts and adds
-	 * (x * 0xcd) >> 11: 11001101 - shorter code than * 0x67 (on i386)
-	 * (x * 0x67) >> 10:  1100111
-	 * (x * 0x34) >> 9:    110100 - same
-	 * (x * 0x1a) >> 8:     11010 - same
-	 * (x * 0x0d) >> 7:      1101 - same, shortest code (on i386)
+	 * If q is 5-digit just use the put_dec_full5() instead of
+	 * cascading if()s.
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
+	if (q > 9999)
+		return put_dec_full5(buf, q);
+
+	r      = (q * 0x199a) >> 16;
+	*buf++ = (q - 10 * r)  + '0';
+
+	if (r) {
+		q   = (r * 0xcd) >> 11;
+		*buf++ = (r - 10 * q)  + '0';
+
+		if (q) {
+			r      = (q * 0xcd) >> 11;
+			*buf++ = (q - 10 * r)  + '0';
+
+			if (r)
+				*buf++ = r + '0';
+		}
+	}
 
 	return buf;
 }
+
 /* No inlining helps gcc to use registers better */
 static noinline_for_stack
 char *put_dec(char *buf, unsigned long long num)
 {
-	while (1) {
-		unsigned rem;
-		if (num < 100000)
-			return put_dec_trunc(buf, num);
-		rem = do_div(num, 100000);
-		buf = put_dec_full(buf, rem);
+	while (num >= 100000)
+		buf = put_dec_full5(buf, do_div(num, 100000));
+	return put_dec_trunc5(buf, num);
+}
+
+/* This is used by ip4_string(). */
+#define put_dec_8bit put_dec_trunc5
+
+#else /* BITS_PER_LONG <= 32 (ie. 32-bit machine) && long long is 64-bit*/
+
+/*
+ * This is similar to the put_dec_full5() above expect it handles
+ * numbers from 0 to 9999 (ie. at most four digits).  It is used by
+ * the put_dec() below which is optimised for 32-bit processors.
+ */
+static noinline_for_stack
+char *put_dec_full4(char *buf, unsigned q)
+{
+	unsigned r;
+
+	r      = (q * 0xcccd) >> 19;
+	*buf++ = (q - 10 * r) + '0';
+
+	q      = (r * 0x199a) >> 16;
+	*buf++ = (r - 10 * q)  + '0';
+
+	r      = (q * 0xcd) >> 11;
+	*buf++ = (q - 10 * r)  + '0';
+
+	*buf++ = r + '0';
+
+	return buf;
+}
+
+/*
+ * Similar to above but handles only 8-bit operands and does not pad
+ * with zeros.  Used by ip4_string().
+ */
+static noinline_for_stack
+char *put_dec_8bit(char *buf, unsigned q)
+{
+	unsigned r;
+
+	r      = (q * 0xcd) >> 11;
+	*buf++ = (q - 10 * r) + '0';
+
+	if (r) {
+		q      = (r * 0xd) >> 7;
+		*buf++ = (r - 10 * q)  + '0';
+
+		if (q)
+			*buf++ = q + '0';
+	}
+
+	return buf;
+}
+
+/*
+ * Based on code by Douglas W. Jones found at
+ * <http://www.cs.uiowa.edu/~jones/bcd/decimal.html#sixtyfour> (with
+ * permission from the author).  This performs no 64-bit division and
+ * hence should be faster on 32-bit machines then the version of the
+ * function above.
+ */
+static noinline_for_stack
+char *put_dec(char *buf, unsigned long long n)
+{
+	uint32_t d3, d2, d1, q;
+
+	if (n < 10) {
+		*buf++ = '0' + (unsigned)n;
+		return buf;
 	}
+
+	d1  = (n >> 16) & 0xFFFF;
+	d2  = (n >> 32) & 0xFFFF;
+	d3  = (n >> 48) & 0xFFFF;
+
+	q   = 656 * d3 + 7296 * d2 + 5536 * d1 + (n & 0xFFFF);
+
+	q   = q / 10000;
+	buf = put_dec_full4(buf, q % 10000);
+
+	d1  = q + 7671 * d3 + 9496 * d2 + 6 * d1;
+	q   = d1 / 10000;
+	buf = put_dec_full4(buf, d1 % 10000);
+
+	d2  = q + 4749 * d3 + 42 * d2;
+	q   = d2 / 10000;
+	buf = put_dec_full4(buf, d2 % 10000);
+
+	d3  = q + 281 * d3;
+	q   = d3 / 10000;
+	buf = put_dec_full4(buf, d3 % 10000);
+
+	buf = put_dec_full4(buf, q);
+
+	while (buf[-1] == '0')
+		--buf;
+
+	return buf;
 }
 
+#endif
+
 #define ZEROPAD	1		/* pad with zero */
 #define SIGN	2		/* unsigned/signed long */
 #define PLUS	4		/* show plus */
@@ -748,7 +849,7 @@ char *ip4_string(char *p, const u8 *addr
 	}
 	for (i = 0; i < 4; i++) {
 		char temp[3];	/* hold each IP quad in reverse order */
-		int digits = put_dec_trunc(temp, addr[index]) - temp;
+		int digits = put_dec_8bit(temp, addr[index]) - temp;
 		if (leading_zeros) {
 			if (digits < 3)
 				*p++ = '0';
_

Patches currently in -mm which might be from mina86@mina86.com are

lib-vsprintf-optimised-put_dec-function.patch
lib-vsprintf-added-a-put_dec-test-and-benchmark-tool.patch

